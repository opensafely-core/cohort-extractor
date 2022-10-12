#!/usr/bin/env python3

"""A cross-platform script to build cohorts, run models, build and
start a notebook, open a web browser on the correct port, and handle
shutdowns gracefully
"""
import base64
import csv
import datetime
import importlib
import os
import pathlib
import re
import sys
import traceback
from argparse import ArgumentParser
from collections import defaultdict
from io import BytesIO

import numpy as np
import pandas
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

import cohortextractor
from cohortextractor.exceptions import DummyDataValidationError, ValidationError
from cohortextractor.generate_codelist_report import generate_codelist_report

from .log_utils import log_execution_time, log_stats

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
    dummy_data_file,
    selected_study_name=None,
    index_date_range=None,
    skip_existing=False,
    output_format=SUPPORTED_FILE_FORMATS[0],
    output_name=None,
    params=(),
):
    preflight_generation_check()
    study_definitions = list_study_definitions()
    if selected_study_name and selected_study_name != "all":
        for study_name, suffix in study_definitions:
            if study_name == selected_study_name:
                study_definitions = [(study_name, suffix)]
                break
    if dummy_data_file and len(study_definitions) > 1:
        msg = "You can only provide dummy data for a single study definition"
        raise DummyDataValidationError(msg)
    if output_name and len(study_definitions) > 1:
        raise ValidationError(
            "You can only use the --output-file argument with a single study definition"
        )
    for study_name, suffix in study_definitions:
        with log_execution_time(
            logger,
            description="generate_cohort",
            study_definition=study_name,
            index_date="all",
        ):
            _generate_cohort(
                output_dir,
                study_name,
                suffix if not output_name else "",
                expectations_population,
                dummy_data_file,
                index_date_range=index_date_range,
                skip_existing=skip_existing,
                output_format=output_format,
                output_name=output_name or "input",
                params=params,
            )


def _generate_cohort(
    output_dir,
    study_name,
    suffix,
    expectations_population,
    dummy_data_file,
    index_date_range=None,
    skip_existing=False,
    output_format=SUPPORTED_FILE_FORMATS[0],
    output_name="input",
    params=(),
):
    logger.info(
        f"Generating cohort for {study_name} in {output_dir}",
    )
    logger.debug(
        "args:",
        suffix=suffix,
        expectations_population=expectations_population,
        dummy_data_file=dummy_data_file,
        index_date_range=index_date_range,
        skip_existing=skip_existing,
        output_format=output_format,
    )

    study = load_study_definition(study_name, params=params)

    os.makedirs(output_dir, exist_ok=True)

    index_dates = _generate_date_range(index_date_range)
    log_stats(logger, index_date_count=len(index_dates) if index_date_range else 0)
    if index_date_range:
        log_stats(logger, min_index_date=index_dates[-1], max_index_date=index_dates[0])

    # record if we've logged the SQL for this generate_cohort run
    # For subsequent runs, we log the timing and the first line of the SQL only, since
    # the only difference should be the index date
    sql_logged = False
    for index_date in index_dates:
        log_kwargs = dict(description="generate_cohort", study_definition=study_name)
        if index_date is not None:
            log_kwargs.update(index_date=index_date)
        with log_execution_time(logger, **log_kwargs):
            if index_date is not None:
                logger.info(f"Setting index_date to {index_date}")
                study.set_index_date(index_date)
                if sql_logged:
                    study.set_sql_logging(truncate=True)
                date_suffix = f"_{index_date}"
            else:
                date_suffix = ""
            # If this is changed then the regex in `_generate_measures()`
            # must be updated
            output_file = (
                f"{output_dir}/{output_name}{suffix}{date_suffix}.{output_format}"
            )
            if skip_existing and os.path.exists(output_file):
                logger.info(f"Not regenerating pre-existing file at {output_file}")
            else:
                study.to_file(
                    output_file,
                    expectations_population=expectations_population,
                    dummy_data_file=dummy_data_file,
                )
                logger.info(
                    f"Successfully created cohort and covariates at {output_file}"
                )
                sql_logged = True


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
        with log_execution_time(
            logger,
            description="generate_measures",
            study_definition=study_name,
            input_file="all",
        ):
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
    filename_re = re.compile(rf"^input{re.escape(suffix)}.+\.({EXTENSION_REGEX})$")

    log_stats(logger, measures_count=len(measures))
    for file in os.listdir(output_dir):
        if not filename_re.match(file):
            continue
        date = _get_date_from_filename(file)
        if date is None:
            continue
        filepath = os.path.join(output_dir, file)
        logger.info(f"Calculating measures for {filepath}")
        date_string_for_logs = date.strftime("%Y-%m-%d")
        with log_execution_time(
            logger,
            description="generate_measures",
            input_file=filepath,
            date=date_string_for_logs,
            study_definition=study_name,
        ):
            patient_df = None
            for measure in measures:
                logger.info(f"Calculating {measure.id}")
                output_file = f"{output_dir}/measure_{measure.id}_{date}.csv"
                measure_outputs[measure.id].append(output_file)
                if skip_existing and os.path.exists(output_file):
                    logger.info(f"Not generating pre-existing file {output_file}")
                    continue
                # We do this lazily so that if all corresponding output files
                # already exist we can avoid loading the patient data entirely
                if patient_df is None:
                    logger.info(f"Loading patient data from {filepath}")
                    with log_execution_time(
                        logger,
                        description="Load patient dataframe for measures",
                        input_file=filepath,
                        date=date_string_for_logs,
                    ):
                        patient_df = _load_dataframe_for_measures(filepath, measures)
                        log_stats(
                            logger,
                            dataframe="patient_df",
                            measure_id=measure.id,
                            date=date_string_for_logs,
                            memory=patient_df.memory_usage(deep=True).sum(),
                        )
                with log_execution_time(
                    logger,
                    description="Calculate measure",
                    measure_id=measure.id,
                    date=date_string_for_logs,
                ):
                    measure_df = measure.calculate(patient_df, _report)
                log_stats(
                    logger,
                    dataframe="measure_df",
                    measure_id=measure.id,
                    date=date_string_for_logs,
                    memory=measure_df.memory_usage(deep=True).sum(),
                )
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
    match = re.search(rf"_(\d\d\d\d\-\d\d\-\d\d)\.({EXTENSION_REGEX})$", filename)
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
    numeric_columns.discard(measure.POPULATION_COLUMN)
    group_by_columns.discard(measure.POPULATION_COLUMN)
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
    df[measure.POPULATION_COLUMN] = 1
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


def dump_cohort_sql(study_definition, params=()):
    study = load_study_definition(study_definition, params=params)
    print(study.to_sql())


def dump_study_yaml(study_definition, params=()):
    study = load_study_definition(study_definition, params=params)
    print(yaml.dump(study.to_data()))


def load_study_definition(name, value="study", params=()):
    sys.path.extend([relative_dir(), os.path.join(relative_dir(), "analysis")])
    # Avoid creating __pycache__ files in the analysis directory
    sys.dont_write_bytecode = True
    # Set any supplied "<key>=<value>" parameters on the global `params` dict
    cohortextractor.params.clear()
    cohortextractor.params.update(params)
    logger.info(f"Setting cohortextractor.params to: {cohortextractor.params}")
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


def check_maintenance(current_mode):
    # avoid circular imports
    from cohortextractor.study_definition import StudyDefinition

    db_url = os.environ["DATABASE_URL"]
    backend_cls = StudyDefinition.get_backend_for_database_url(db_url)
    backend = backend_cls(db_url, None)

    if backend.in_maintenance_mode(current_mode):
        # Note: logs are output on stderr, so this should be the only output on
        # stdout
        print("db-maintenance")


def main(args=None):
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
    generate_codelist_report_parser = subparsers.add_parser(
        "generate_codelist_report",
        help="Generate OpenSAFELY Interactive codelist report",
    )
    generate_codelist_report_parser.set_defaults(which="generate_codelist_report")
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

    dump_cohort_sql_parser = subparsers.add_parser(
        "dump_cohort_sql", help="Show SQL to generate cohort"
    )
    dump_cohort_sql_parser.add_argument(
        "--study-definition", help="Study definition name", type=str, required=True
    )
    dump_cohort_sql_parser.add_argument(
        "--param",
        nargs="+",
        action="append",
        dest="params",
        default=[],
        help="Additional parameter to pass to study definition",
    )
    dump_cohort_sql_parser.set_defaults(which="dump_cohort_sql")
    dump_study_yaml_parser = subparsers.add_parser(
        "dump_study_yaml", help="Show study definition as YAML"
    )
    dump_study_yaml_parser.set_defaults(which="dump_study_yaml")
    dump_study_yaml_parser.add_argument(
        "--study-definition", help="Study definition name", type=str, required=True
    )
    dump_study_yaml_parser.add_argument(
        "--param",
        nargs="+",
        action="append",
        dest="params",
        default=[],
        help="Additional parameter to pass to study definition",
    )
    # Cohort parser options
    generate_cohort_parser.add_argument(
        "--output-dir",
        help="Location to store output files",
        type=str,
    )
    generate_cohort_parser.add_argument(
        "--output-format",
        help=(
            f"Output file format: {SUPPORTED_FILE_FORMATS[0]} (default),"
            f" {', '.join(SUPPORTED_FILE_FORMATS[1:])}"
        ),
        type=str,
        choices=SUPPORTED_FILE_FORMATS,
    )
    generate_cohort_parser.add_argument(
        "--output-file",
        help=(
            f"Full path to output file, including directory and extension e.g. "
            f"output/input.{SUPPORTED_FILE_FORMATS[0]}"
        ),
        type=pathlib.Path,
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
    generate_cohort_parser.add_argument(
        "--with-end-date-fix",
        action="store_true",
    )
    generate_cohort_parser.add_argument(
        "--param",
        nargs="+",
        action="append",
        dest="params",
        default=[],
        help="Additional parameter to pass to study definition",
    )
    cohort_method_group = generate_cohort_parser.add_mutually_exclusive_group()
    cohort_method_group.add_argument(
        "--expectations-population",
        help="Generate a dataframe from study expectations",
        type=int,
        default=0,
    )
    cohort_method_group.add_argument(
        "--dummy-data-file",
        help="Use dummy data from file",
        type=pathlib.Path,
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

    # Codelist report parser options
    generate_codelist_report_parser.add_argument(
        "--output-dir",
        help="Location to store output files",
        type=pathlib.Path,
        default="output",
    )
    generate_codelist_report_parser.add_argument(
        "--codelist-path",
        help="Location of codelist",
        type=str,
    )
    generate_codelist_report_parser.add_argument(
        "--start-date",
        help="Start date",
        type=datetime.date.fromisoformat,
    )
    generate_codelist_report_parser.add_argument(
        "--end-date",
        help="End date",
        type=datetime.date.fromisoformat,
    )
    generate_codelist_report_parser.add_argument(
        "--codes",
        default=16,
        help="For dummy data, how many codes to use from the codelist",
        type=int,
    )
    generate_codelist_report_parser.add_argument(
        "--days",
        default=70,
        help="For dummy data, how many days of data to generate between start date and end date",
        type=int,
    )

    maintenance_parser = subparsers.add_parser(
        "maintenance",
        help="Report if backend db is currently performing maintenance",
    )
    maintenance_parser.set_defaults(which="maintenance")
    maintenance_parser.add_argument(
        "--database-url",
        help="Database URL to query (can be supplied as DATABASE_URL environment variable)",
    )
    maintenance_parser.add_argument(
        "--current-mode",
        help="The current mode we think the database is in",
        default="unknown",
    )

    options = parser.parse_args(sys.argv[1:] if args is None else args)

    if options.version:
        print(f"v{cohortextractor.__version__}")
    elif not hasattr(options, "which"):
        parser.print_help()
    elif options.which == "generate_cohort":
        if options.database_url:
            os.environ["DATABASE_URL"] = options.database_url
        if options.temp_database_name:
            os.environ["TEMP_DATABASE_NAME"] = options.temp_database_name
        if not (
            options.expectations_population
            or options.dummy_data_file
            or os.environ.get("DATABASE_URL")
        ):
            parser.error(
                "generate_cohort: error: one of the arguments "
                "--expectations-population --dummy-data-file --database-url is required"
            )
        if options.output_file:
            output_dir = options.output_file.parent
            match = re.match(
                rf"^(.+)\.({EXTENSION_REGEX})$", str(options.output_file.name)
            )
            if not match:
                parser.error(
                    f"generate_cohort: error: --output-file must have a supported "
                    f"extension: {', '.join(SUPPORTED_FILE_FORMATS)}"
                )
            output_name = match.group(1)
            output_format = match.group(2)
            # It would be simpler if we could just insist that these other options
            # weren't present, but job-runner adds `--output-dir` automatically so we
            # can't do that.
            if options.output_dir and options.output_dir != str(output_dir):
                parser.error(
                    f"generate_cohort: error: --output-dir '{options.output_dir}' "
                    f"does not match directory in --output-file"
                )
            if options.output_format and options.output_format != output_format:
                parser.error(
                    f"generate_cohort: error: --output-format '{options.output_format}' "
                    f"does not match format in --output-file"
                )
        else:
            output_dir = options.output_dir or "output"
            output_name = None
            output_format = options.output_format or SUPPORTED_FILE_FORMATS[0]

        try:
            generate_cohort(
                str(output_dir),
                options.expectations_population,
                options.dummy_data_file,
                selected_study_name=options.study_definition,
                index_date_range=options.index_date_range,
                skip_existing=options.skip_existing,
                output_format=output_format,
                output_name=output_name,
                params=dict_from_params(options.params),
            )
        except ValidationError as e:
            print(f"{e.human_name}: {e}")
            sys.exit(1)
        except Exception as e:
            # Checking for "DatabaseError" in the MRO means we can identify database errors without
            # referencing a specific driver.  Both pymssql and presto/trino-python-client raise
            # exceptions derived from a DatabaseError parent class

            # Ignore errors which don't look like database errors
            if "DatabaseError" not in str(e.__class__.mro()):
                raise

            traceback.print_exc()
            # Exit with specific exit codes to help identify known issues
            transient_errors = [
                "Unexpected EOF from the server",
                "DBPROCESS is dead or not enabled",
            ]
            if any(message in str(e) for message in transient_errors):
                logger.error(f"Intermittent database error: {e}")
                sys.exit(3)
            if "Invalid object name 'CodedEvent_SNOMED'" in str(e):
                logger.error(
                    "CodedEvent_SNOMED table is currently not available.\n"
                    "This is likely due to regular database maintenance."
                )
                sys.exit(4)
            logger.error(f"Database error: {e}")
            sys.exit(5)

    elif options.which == "generate_measures":
        generate_measures(
            options.output_dir,
            selected_study_name=options.study_definition,
            skip_existing=options.skip_existing,
        )
    elif options.which == "generate_codelist_report":
        generate_codelist_report(
            options.output_dir,
            options.codelist_path,
            options.start_date,
            options.end_date,
            options.codes,
            options.days,
        )
    elif options.which == "cohort_report":
        make_cohort_report(options.input_dir, options.output_dir)
    elif options.which == "dump_cohort_sql":
        dump_cohort_sql(
            options.study_definition, params=dict_from_params(options.params)
        )
    elif options.which == "dump_study_yaml":
        dump_study_yaml(
            options.study_definition, params=dict_from_params(options.params)
        )
    elif options.which == "maintenance":
        if options.database_url:
            os.environ["DATABASE_URL"] = options.database_url
        check_maintenance(options.current_mode)


def dict_from_params(params):
    # Arguments like this:
    #
    #     --param key1=value1 --param key2 = value2 --param key3= 'value 3'
    #
    # Are parsed by argpase into a list like this:
    #
    #     [["key1=value1"], ["key2", "=", "value2"], ["key3=", "value 3"]]
    #
    # We want to transform that into a dict like this:
    #
    #     {"key1": "value1", "key2": "value2", "key3: "value 3"}
    #
    return dict("".join(param_parts).partition("=")[::2] for param_parts in params)


if __name__ == "__main__":
    main()
