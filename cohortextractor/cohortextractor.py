#!/usr/bin/env python3

"""A cross-platform script to build cohorts, run models, build and
start a notebook, open a web browser on the correct port, and handle
shutdowns gracefully
"""
import base64
import csv
import datetime
import glob
import importlib
import logging
import os
import re
import sys
from argparse import ArgumentParser
from collections import defaultdict
from io import BytesIO

import numpy as np
import pandas
import requests
import seaborn as sns
import structlog
import yaml
from matplotlib import pyplot as plt
from pandas.api.types import (
    is_bool_dtype,
    is_categorical_dtype,
    is_datetime64_dtype,
    is_numeric_dtype,
)
from prettytable import PrettyTable

import cohortextractor
from cohortextractor.localrun import localrun

logger = structlog.get_logger()

notebook_tag = "opencorona-research"
target_dir = "/home/app/notebook"


SUPPORTED_FILE_FORMATS = ["csv", "csv.gz", "feather", "dta", "dta.gz"]
EXTENSION_REGEX = "|".join(map(re.escape, SUPPORTED_FILE_FORMATS))


def show_exception_timestamp(*args):
    """
    Output a timestamp before any exception traceback which can be useful when
    debugging
    """
    timestamp = datetime.datetime.now(datetime.timezone.utc).strftime(
        "%Y-%m-%d %H:%M:%S UTC"
    )
    print(f"Exception at {timestamp}", file=sys.stderr)
    sys.__excepthook__(*args)


sys.excepthook = show_exception_timestamp


def relative_dir():
    return os.getcwd()


def make_chart(name, series, dtype):
    FLOOR_DATE = datetime.datetime(1960, 1, 1)
    CEILING_DATE = datetime.datetime.today()
    img = BytesIO()
    # Setting figure sizes in seaborn is a bit weird:
    # https://stackoverflow.com/a/23973562/559140
    if is_categorical_dtype(dtype):
        sns.set_style("ticks")
        sns.catplot(
            x=name, data=series.to_frame(), kind="count", height=3, aspect=3 / 2
        )
        plt.xticks(rotation=45)
    elif is_bool_dtype(dtype):
        sns.set_style("ticks")
        sns.catplot(x=name, data=series.to_frame(), kind="count", height=2, aspect=1)
        plt.xticks(rotation=45)
    elif is_datetime64_dtype(dtype):
        # Early dates are dummy values; I don't know what late dates
        # are but presumably just dud data
        series = series[(series > FLOOR_DATE) & (series <= CEILING_DATE)]
        # Set bin numbers appropriate to the time window
        delta = series.max() - series.min()
        if delta.days <= 31:
            bins = delta.days
        elif delta.days <= 365 * 10:
            bins = delta.days / 31
        else:
            bins = delta.days / 365
        if bins < 1:
            bins = 1
        fig = plt.figure(figsize=(5, 2))
        ax = fig.add_subplot(111)
        series.hist(bins=int(bins), ax=ax)
        plt.xticks(rotation=45, ha="right")
    elif is_numeric_dtype(dtype):
        # Trim percentiles and negatives which are usually bad data
        series = series.fillna(0)
        series = series[
            (series < np.percentile(series, 95))
            & (series > np.percentile(series, 5))
            & (series > 0)
        ]
        fig = plt.figure(figsize=(5, 2))
        ax = fig.add_subplot(111)
        sns.distplot(series, kde=False, ax=ax)
        plt.xticks(rotation=45)
    else:
        raise ValueError()

    plt.savefig(img, transparent=True, bbox_inches="tight")
    img.seek(0)
    plt.close()
    return base64.b64encode(img.read()).decode("UTF-8")


def preflight_generation_check():
    """Raise an informative error if things are not as they should be"""
    missing_paths = []
    required_paths = ["codelists/", "analysis/"]
    for p in required_paths:
        if not os.path.exists(p):
            missing_paths.append(p)
    if missing_paths:
        msg = "This command expects the following relative paths to exist: {}"
        raise RuntimeError(msg.format(", ".join(missing_paths)))


def generate_cohort(
    output_dir,
    expectations_population,
    selected_study_name=None,
    index_date_range=None,
    skip_existing=False,
    output_format=SUPPORTED_FILE_FORMATS[0],
):
    preflight_generation_check()
    study_definitions = list_study_definitions()
    if selected_study_name and selected_study_name != "all":
        for study_name, suffix in study_definitions:
            if study_name == selected_study_name:
                study_definitions = [(study_name, suffix)]
                break
    for study_name, suffix in study_definitions:
        _generate_cohort(
            output_dir,
            study_name,
            suffix,
            expectations_population,
            index_date_range=index_date_range,
            skip_existing=skip_existing,
            output_format=output_format,
        )


def _generate_cohort(
    output_dir,
    study_name,
    suffix,
    expectations_population,
    index_date_range=None,
    skip_existing=False,
    output_format=SUPPORTED_FILE_FORMATS[0],
):
    logger.info(
        f"Generating cohort for {study_name} in {output_dir}",
    )
    logger.debug(
        "args:",
        suffix=suffix,
        expectations_population=expectations_population,
        index_date_range=index_date_range,
        skip_existing=skip_existing,
        output_format=output_format,
    )

    study = load_study_definition(study_name)

    os.makedirs(output_dir, exist_ok=True)
    for index_date in _generate_date_range(index_date_range):
        if index_date is not None:
            logger.info(f"Setting index_date to {index_date}")
            study.set_index_date(index_date)
            date_suffix = f"_{index_date}"
        else:
            date_suffix = ""
        # If this is changed then the regex in `_generate_measures()`
        # must be updated
        output_file = f"{output_dir}/input{suffix}{date_suffix}.{output_format}"
        if skip_existing and os.path.exists(output_file):
            logger.info(f"Not regenerating pre-existing file at {output_file}")
        else:
            study.to_file(
                output_file,
                expectations_population=expectations_population,
            )
            logger.info(f"Successfully created cohort and covariates at {output_file}")


def _generate_date_range(date_range_str):
    # Bail out with an "empty" range: this means we don't need separate
    # codepaths to handle the range, single date, and no date supplied cases
    if not date_range_str:
        return [None]
    start, end, period = _parse_date_range(date_range_str)
    if end < start:
        raise ValueError(
            f"Invalid date range '{date_range_str}': end cannot be earlier than start"
        )
    dates = []
    while start <= end:
        dates.append(start.isoformat())
        start = _increment_date(start, period)
    # The latest data is generally more interesting/useful so we may as well
    # extract that first
    dates.reverse()
    return dates


def _parse_date_range(date_range_str):
    period = "month"
    if " to " in date_range_str:
        start, end = date_range_str.split(" to ", 1)
        if " by " in end:
            end, period = end.split(" by ", 1)
    else:
        start = end = date_range_str
    try:
        start = _parse_date(start)
        end = _parse_date(end)
    except ValueError:
        raise ValueError(
            f"Invalid date range '{date_range_str}': Dates must be in YYYY-MM-DD "
            f"format or 'today' and ranges must be in the form "
            f"'DATE to DATE by (week|month)'"
        )
    if period not in ("week", "month"):
        raise ValueError(f"Unknown time period '{period}': must be 'week' or 'month'")
    return start, end, period


def _parse_date(date_str):
    if date_str == "today":
        return datetime.date.today()
    else:
        return datetime.date.fromisoformat(date_str)


def _increment_date(date, period):
    if period == "week":
        return date + datetime.timedelta(days=7)
    elif period == "month":
        if date.month < 12:
            return date.replace(month=date.month + 1)
        else:
            return date.replace(month=1, year=date.year + 1)
    else:
        raise ValueError(f"Unknown time period '{period}'")


def generate_measures(
    output_dir,
    selected_study_name=None,
    skip_existing=False,
):
    preflight_generation_check()
    study_definitions = list_study_definitions()
    if selected_study_name and selected_study_name != "all":
        for study_name, suffix in study_definitions:
            if study_name == selected_study_name:
                study_definitions = [(study_name, suffix)]
                break
    for study_name, suffix in study_definitions:
        _generate_measures(
            output_dir,
            study_name,
            suffix,
            skip_existing=skip_existing,
        )


def _generate_measures(
    output_dir,
    study_name,
    suffix,
    skip_existing=False,
):
    logger.info(
        f"Generating measure for {study_name} in {output_dir}",
    )
    logger.debug("args", suffix=suffix, skip_existing=skip_existing)
    measures = load_study_definition(study_name, value="measures")
    measure_outputs = defaultdict(list)
    filename_re = re.compile(fr"^input{re.escape(suffix)}.+\.({EXTENSION_REGEX})$")
    for file in os.listdir(output_dir):
        if not filename_re.match(file):
            continue
        date = _get_date_from_filename(file)
        if date is None:
            continue
        filepath = os.path.join(output_dir, file)
        patient_df = None
        for measure in measures:
            output_file = f"{output_dir}/measure_{measure.id}_{date}.csv"
            measure_outputs[measure.id].append(output_file)
            if skip_existing and os.path.exists(output_file):
                logger.info(f"Not generating pre-existing file {output_file}")
                continue
            # We do this lazily so that if all corresponding output files
            # already exist we can avoid loading the patient data entirely
            if patient_df is None:
                patient_df = _load_dataframe_for_measures(filepath, measures)
            measure_df = measure.calculate(patient_df, _report)
            measure_df.to_csv(output_file, index=False)
            logger.info(f"Created measure output at {output_file}")
    if not measure_outputs:
        logger.warn(
            "No matching output files found. You may need to first run:\n"
            "  cohortextractor generate_cohort --index-date-range ..."
        )
        return
    for measure in measures:
        output_file = f"{output_dir}/measure_{measure.id}.csv"
        _combine_csv_files_with_dates(output_file, measure_outputs[measure.id])
        logger.info(f"Combined measure output for all dates in {output_file}")


def _get_date_from_filename(filename):
    match = re.search(fr"_(\d\d\d\d\-\d\d\-\d\d)\.({EXTENSION_REGEX})$", filename)
    return datetime.date.fromisoformat(match.group(1)) if match else None


def _load_dataframe_for_measures(filename, measures):
    """
    Given a file name and a list of measures, load the file into a Pandas
    dataframe with types as appropriate for the supplied measures
    """
    filename = str(filename)
    numeric_columns = set()
    group_by_columns = set()
    for measure in measures:
        numeric_columns.update([measure.numerator, measure.denominator])
        group_by_columns.update(measure.group_by)
    # This is a special column which we don't load from the CSV but whose value
    # is always set to 1 for every row
    numeric_columns.discard("population")
    group_by_columns.discard("population")
    dtype = {col: "category" for col in group_by_columns}
    for col in numeric_columns:
        dtype[col] = "float64"
    if filename.endswith(".csv") or filename.endswith(".csv.gz"):
        df = pandas.read_csv(
            filename, dtype=dtype, usecols=list(dtype.keys()), keep_default_na=False
        )
    elif filename.endswith(".feather"):
        df = pandas.read_feather(filename, columns=list(dtype.keys()))
    elif filename.endswith(".dta") or filename.endswith(".dta.gz"):
        df = pandas.read_stata(filename, columns=list(dtype.keys()))
    else:
        raise RuntimeError(f"Unsupported file format: {filename}")
    df["population"] = 1
    return df


def _combine_csv_files_with_dates(filename, input_files):
    """
    Takes a list of CSV files which have dates in their filenames and combines
    them into a single CSV file with an additional "date" column indicating the
    date for each row
    """
    input_files = sorted(input_files)
    with open(input_files[0]) as first_file:
        reader = csv.reader(first_file)
        headers = next(reader)
    with open(filename, "w", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(headers + ["date"])
        for file in input_files:
            date = _get_date_from_filename(file)
            with open(file) as input_csvfile:
                reader = csv.reader(input_csvfile)
                if next(reader) != headers:
                    raise RuntimeError(
                        f"Files {input_files[0]} and {file} have different headers"
                    )
                for row in reader:
                    writer.writerow(row + [date])


# Used for reporting events to users. We may introduce a dedicated
# mechanism for this eventually, but for now it just uses the logging
# system.
reporter = structlog.get_logger("cohortextactor.reporter")


def _report(msg):
    reporter.info(msg)


def make_cohort_report(input_dir, output_dir):
    for study_name, suffix in list_study_definitions():
        _make_cohort_report(input_dir, output_dir, study_name, suffix)


def _make_cohort_report(input_dir, output_dir, study_name, suffix):
    study = load_study_definition(study_name)

    df = study.csv_to_df(f"{input_dir}/input{suffix}.csv")
    descriptives = df.describe(include="all")

    for name, dtype in zip(df.columns, df.dtypes):
        if name == "patient_id":
            continue
        main_chart = '<div><img src="data:image/png;base64,{}"/></div>'.format(
            make_chart(name, df[name], dtype)
        )
        empty_values_chart = ""
        if is_datetime64_dtype(dtype):
            # also do a null / not null plot
            empty_values_chart = (
                '<div><img src="data:image/png;base64,{}"/></div>'.format(
                    make_chart(name, df[name].isnull(), bool)
                )
            )
        elif is_numeric_dtype(dtype):
            # also do a null / not null plot
            empty_values_chart = (
                '<div><img src="data:image/png;base64,{}"/></div>'.format(
                    make_chart(name, df[name] > 0, bool)
                )
            )
        descriptives.loc["values", name] = main_chart
        descriptives.loc["nulls", name] = empty_values_chart

    with open(f"{output_dir}/descriptives{suffix}.html", "w") as f:

        f.write(
            """<html>
<head>
  <style>
    table {
      text-align: left;
      position: relative;
      border-collapse: collapse;
    }
    td, th {
      padding: 8px;
      margin: 2px;
    }
    td {
      border-left: solid 1px black;
    }
    tr:nth-child(even) {background: #EEE}
    tr:nth-child(odd) {background: #FFF}
    tbody th:first-child {
      position: sticky;
      left: 0px;
      background: #fff;
    }
  </style>
</head>
<body>"""
        )

        f.write(descriptives.to_html(escape=False, na_rep="", justify="left", border=0))
        f.write("</body></html>")
    logger.info(f"Created cohort report at {output_dir}/descriptives{suffix}.html")


def update_codelists():
    base_path = os.path.join(os.getcwd(), "codelists")

    # delete all existing codelists
    for path in glob.glob(os.path.join(base_path, "*.csv")):
        os.unlink(path)

    with open(os.path.join(base_path, "codelists.txt")) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue

            print(line)
            tokens = line.split("/")
            if len(tokens) not in [3, 4]:
                raise ValueError(
                    f"{line} does not match [project]/[codelist]/[version] "
                    "or user/[username]/[codelist]/[version]"
                )
            url = f"https://codelists.opensafely.org/codelist/{line}/download.csv"
            filename = "-".join(tokens[:-1]) + ".csv"

            rsp = requests.get(url)
            rsp.raise_for_status()

            with open(os.path.join(base_path, filename), "wb") as f:
                f.write(rsp.content)


def dump_cohort_sql(study_definition):
    study = load_study_definition(study_definition)
    print(study.to_sql())


def dump_study_yaml(study_definition):
    study = load_study_definition(study_definition)
    print(yaml.dump(study.to_data()))


def load_study_definition(name, value="study"):
    sys.path.extend([relative_dir(), os.path.join(relative_dir(), "analysis")])
    # Avoid creating __pycache__ files in the analysis directory
    sys.dont_write_bytecode = True
    return getattr(importlib.import_module(name), value)


def list_study_definitions(ignore_errors=False):
    pattern = re.compile(r"^(study_definition(_\w+)?)\.py$")
    matches = []
    try:
        analysis_files = os.listdir(os.path.join(relative_dir(), "analysis"))
    except OSError:
        if not ignore_errors:
            raise
        else:
            analysis_files = []
    for name in sorted(analysis_files):
        match = pattern.match(name)
        if match:
            name = match.group(1)
            suffix = match.group(2) or ""
            matches.append((name, suffix))
    if not matches and not ignore_errors:
        raise RuntimeError(f"No study definitions found in {relative_dir()}")
    return matches


def main():
    parser = ArgumentParser(
        description="Generate cohorts and run models in openSAFELY framework. "
    )
    # Cohort parser options
    parser.add_argument("--version", help="Display version", action="store_true")
    parser.add_argument(
        "--verbose", help="Show extra logging info", action="store_true"
    )
    subparsers = parser.add_subparsers(help="sub-command help")
    generate_cohort_parser = subparsers.add_parser(
        "generate_cohort", help="Generate cohort"
    )
    generate_cohort_parser.set_defaults(which="generate_cohort")
    generate_measures_parser = subparsers.add_parser(
        "generate_measures", help="Generate measures from cohort data"
    )
    generate_measures_parser.set_defaults(which="generate_measures")
    run_parser = subparsers.add_parser("run", help="Run action from project.yaml")
    run_parser.set_defaults(which="run")

    run_parser.add_argument(
        "db",
        help="Database to run against",
        choices=["full", "slice", "dummy"],
        type=str,
    )
    run_parser.add_argument(
        "action",
        help="Action to execute",
        type=str,
    )
    run_parser.add_argument(
        "backend",
        help="Backend to execute against",
        choices=["expectations", "tpp", "all"],
        type=str,
        default="all",
    )

    run_parser.add_argument(
        "--medium-privacy-storage-base",
        help="Location to store medium privacy data",
        default=os.environ.get("MEDIUM_PRIVACY_STORAGE_BASE"),
    )
    run_parser.add_argument(
        "--high-privacy-storage-base",
        help="Location to store high privacy data",
        default=os.environ.get("HIGH_PRIVACY_STORAGE_BASE"),
    )
    run_parser.add_argument(
        "--force-run",
        help="Force a new run for the action",
        action="store_true",
    )
    run_parser.add_argument(
        "--force-run-dependencies",
        help="Force a new run for the action and all its dependencies (only when `--force-run` is also specified)",
        action="store_true",
    )
    cohort_report_parser = subparsers.add_parser(
        "cohort_report", help="Generate cohort report"
    )
    cohort_report_parser.set_defaults(which="cohort_report")
    cohort_report_parser.add_argument(
        "--input-dir",
        help="Location to look for input CSVs",
        type=str,
        default="analysis",
    )
    cohort_report_parser.add_argument(
        "--output-dir",
        help="Location to store output CSVs",
        type=str,
        default="output",
    )

    update_codelists_parser = subparsers.add_parser(
        "update_codelists",
        help="Update codelists, using specification at codelists/codelists.txt",
    )
    update_codelists_parser.set_defaults(which="update_codelists")
    dump_cohort_sql_parser = subparsers.add_parser(
        "dump_cohort_sql", help="Show SQL to generate cohort"
    )
    dump_cohort_sql_parser.add_argument(
        "--study-definition", help="Study definition name", type=str, required=True
    )
    dump_cohort_sql_parser.set_defaults(which="dump_cohort_sql")
    dump_study_yaml_parser = subparsers.add_parser(
        "dump_study_yaml", help="Show study definition as YAML"
    )
    dump_study_yaml_parser.set_defaults(which="dump_study_yaml")
    dump_study_yaml_parser.add_argument(
        "--study-definition", help="Study definition name", type=str, required=True
    )

    # Cohort parser options
    generate_cohort_parser.add_argument(
        "--output-dir",
        help="Location to store output files",
        type=str,
        default="output",
    )
    generate_cohort_parser.add_argument(
        "--output-format",
        help=(
            f"Output file format: {SUPPORTED_FILE_FORMATS[0]} (default),"
            f" {', '.join(SUPPORTED_FILE_FORMATS[1:])}"
        ),
        type=str,
        choices=SUPPORTED_FILE_FORMATS,
        default=SUPPORTED_FILE_FORMATS[0],
    )
    generate_cohort_parser.add_argument(
        "--study-definition",
        help="Study definition to use",
        type=str,
        choices=["all"] + [x[0] for x in list_study_definitions(ignore_errors=True)],
        default="all",
    )
    generate_cohort_parser.add_argument(
        "--temp-database-name",
        help="Name of database to store temporary results",
        type=str,
        default=os.environ.get("TEMP_DATABASE_NAME", ""),
    )
    generate_cohort_parser.add_argument(
        "--index-date-range",
        help="Evaluate the study definition at a range of index dates",
        type=str,
        default="",
    )
    generate_cohort_parser.add_argument(
        "--skip-existing",
        help="Do not regenerate data if output file already exists",
        action="store_true",
    )
    cohort_method_group = generate_cohort_parser.add_mutually_exclusive_group()
    cohort_method_group.add_argument(
        "--expectations-population",
        help="Generate a dataframe from study expectations",
        type=int,
        default=0,
    )
    cohort_method_group.add_argument(
        "--database-url",
        help="Database URL to query (can be supplied as DATABASE_URL environment variable)",
        type=str,
    )

    # Measure generator parser options
    generate_measures_parser.add_argument(
        "--output-dir",
        help="Location to store output files",
        type=str,
        default="output",
    )
    generate_measures_parser.add_argument(
        "--study-definition",
        help="Study definition file containing measure definitions to use",
        type=str,
        choices=["all"] + [x[0] for x in list_study_definitions(ignore_errors=True)],
        default="all",
    )
    generate_measures_parser.add_argument(
        "--skip-existing",
        help="Do not regenerate measure if output file already exists",
        action="store_true",
    )

    options = parser.parse_args()
    if getattr(options, "force_run_dependencies", False) and not getattr(
        options, "force_run", False
    ):
        parser.error("`--force-run-dependencies` requires `--force-run`")
    if options.version:
        print(f"v{cohortextractor.__version__}")
    elif not hasattr(options, "which"):
        parser.print_help()
    elif options.which == "generate_cohort":
        if options.database_url:
            os.environ["DATABASE_URL"] = options.database_url
        if options.temp_database_name:
            os.environ["TEMP_DATABASE_NAME"] = options.temp_database_name
        if not options.expectations_population and not os.environ.get("DATABASE_URL"):
            parser.error(
                "generate_cohort: error: one of the arguments "
                "--expectations-population --database-url is required"
            )
        generate_cohort(
            options.output_dir,
            options.expectations_population,
            selected_study_name=options.study_definition,
            index_date_range=options.index_date_range,
            skip_existing=options.skip_existing,
            output_format=options.output_format,
        )
    elif options.which == "generate_measures":
        generate_measures(
            options.output_dir,
            selected_study_name=options.study_definition,
            skip_existing=options.skip_existing,
        )
    elif options.which == "run":
        log_level = options.verbose and logging.DEBUG or logging.ERROR
        result = localrun(
            options.action,
            options.backend,
            options.db,
            medium_privacy_storage_base=options.medium_privacy_storage_base,
            high_privacy_storage_base=options.high_privacy_storage_base,
            force_run=options.force_run,
            force_run_dependencies=options.force_run_dependencies,
            log_level=log_level,
        )
        if result:
            print("Generated outputs:")
            output = PrettyTable()
            output.field_names = ["status", "path"]

            for action in result:
                for location in action["output_locations"]:
                    output.add_row(
                        [action["status_message"], location["relative_path"]]
                    )
            print(output)
        else:
            print("Nothing to do")

    elif options.which == "cohort_report":
        make_cohort_report(options.input_dir, options.output_dir)
    elif options.which == "update_codelists":
        update_codelists()
        print("Codelists updated. Don't forget to commit them to the repo")
    elif options.which == "dump_cohort_sql":
        dump_cohort_sql(options.study_definition)
    elif options.which == "dump_study_yaml":
        dump_study_yaml(options.study_definition)


if __name__ == "__main__":
    main()
