#!/usr/bin/env python3

"""A cross-platform script to build cohorts, run models, build and
start a notebook, open a web browser on the correct port, and handle
shutdowns gracefully
"""
import runner
import glob
import importlib
import os
import re
import requests
import shutil
import sys


import base64
from io import BytesIO
from argparse import ArgumentParser
from packaging.version import parse
from matplotlib import pyplot as plt
import numpy as np
from pandas.api.types import is_categorical_dtype
from pandas.api.types import is_bool_dtype
from pandas.api.types import is_datetime64_dtype
from pandas.api.types import is_numeric_dtype
import yaml

from datetime import datetime
import seaborn as sns


notebook_tag = "opencorona-research"
target_dir = "/home/app/notebook"


def relative_dir():
    if sys.executable == "run.exe":
        # This is a pyinstaller package on Windows; the `cwd` is
        # likely to be anything (e.g. the Github desktop AppData
        # space); `__file__` is some kind of temporary location
        # resulting from an internal unzip.
        relative_dir = os.path.dirname(os.path.realpath(sys.executable))
    else:
        relative_dir = os.getcwd()
    return relative_dir


def make_chart(name, series, dtype):
    FLOOR_DATE = datetime(1960, 1, 1)
    CEILING_DATE = datetime.today()
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


def generate_cohort(expectations_population):
    for study_name, suffix in list_study_definitions():
        print(f"Generating cohort for {study_name}...")
        _generate_cohort(study_name, suffix, expectations_population)


def _generate_cohort(study_name, suffix, expectations_population):
    print("Running. Please wait...")
    study = load_study_definition(study_name)

    with_sqlcmd = shutil.which("sqlcmd") is not None
    study.to_csv(
        f"analysis/input{suffix}.csv",
        expectations_population=expectations_population,
        with_sqlcmd=with_sqlcmd,
    )
    print(f"Successfully created cohort and covariates at analysis/input{suffix}.csv")


def make_cohort_report():
    for study_name, suffix in list_study_definitions():
        _make_cohort_report(study_name, suffix)


def _make_cohort_report(study_name, suffix):
    study = load_study_definition(study_name)

    df = study.csv_to_df(f"analysis/input{suffix}.csv")
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
            empty_values_chart = '<div><img src="data:image/png;base64,{}"/></div>'.format(
                make_chart(name, df[name].isnull(), bool)
            )
        elif is_numeric_dtype(dtype):
            # also do a null / not null plot
            empty_values_chart = '<div><img src="data:image/png;base64,{}"/></div>'.format(
                make_chart(name, df[name] > 0, bool)
            )
        descriptives.loc["values", name] = main_chart
        descriptives.loc["nulls", name] = empty_values_chart

    with open(f"analysis/descriptives{suffix}.html", "w") as f:

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
    print(f"Created cohort report at analysis/descriptives{suffix}.html")


def update_codelists():
    base_path = os.path.join(os.path.dirname(__file__), "codelists")

    # delete all existing codelists
    for path in glob.glob(os.path.join(base_path, "*.csv")):
        os.unlink(path)

    with open(os.path.join(base_path, "codelists.txt")) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue

            print(line)
            project_id, codelist_id, version = line.split("/")
            url = f"https://codelists.opensafely.org/codelist/{project_id}/{codelist_id}/{version}/download.csv"

            rsp = requests.get(url)
            rsp.raise_for_status()

            with open(
                os.path.join(base_path, f"{project_id}-{codelist_id}.csv"), "w"
            ) as f:
                f.write(rsp.text)


def dump_cohort_sql():
    study = load_study_definition("study_definition")
    print(study.to_sql())


def dump_study_yaml():
    study = load_study_definition("study_definition")
    print(yaml.dump(study.to_data()))


def load_study_definition(name):
    sys.path.extend([relative_dir(), os.path.join(relative_dir(), "analysis")])
    # Avoid creating __pycache__ files in the analysis directory
    sys.dont_write_bytecode = True
    return importlib.import_module(name).study


def list_study_definitions():
    pattern = re.compile(r"^(study_definition(_\w+)?)\.py$")
    for name in sorted(os.listdir(os.path.join(relative_dir(), "analysis"))):
        match = pattern.match(name)
        if match:
            name = match.group(1)
            suffix = match.group(2) or ""
            yield name, suffix


def main():
    parser = ArgumentParser(
        description="Generate cohorts and run models in openSAFELY framework. "
    )
    # Cohort parser options
    parser.add_argument("--version", help="Display runner version", action="store_true")
    subparsers = parser.add_subparsers(help="sub-command help")
    generate_cohort_parser = subparsers.add_parser(
        "generate_cohort", help="Generate cohort"
    )
    generate_cohort_parser.set_defaults(which="generate_cohort")
    cohort_report_parser = subparsers.add_parser(
        "cohort_report", help="Generate cohort report"
    )
    cohort_report_parser.set_defaults(which="cohort_report")
    run_notebook_parser = subparsers.add_parser("notebook", help="Run notebook")
    run_notebook_parser.set_defaults(which="notebook")
    update_codelists_parser = subparsers.add_parser(
        "update_codelists",
        help="Update codelists, using specification at codelists/codelists.txt",
    )
    update_codelists_parser.set_defaults(which="update_codelists")
    dump_cohort_sql_parser = subparsers.add_parser(
        "dump_cohort_sql", help="Show SQL to generate cohort"
    )
    dump_cohort_sql_parser.set_defaults(which="dump_cohort_sql")
    dump_study_yaml_parser = subparsers.add_parser(
        "dump_study_yaml", help="Show SQL to generate cohort"
    )
    dump_study_yaml_parser.set_defaults(which="dump_study_yaml")

    # Cohort parser options
    cohort_method_group = generate_cohort_parser.add_mutually_exclusive_group(
        required=True
    )
    cohort_method_group.add_argument(
        "--expectations-population",
        help="Generate a dataframe from study expectations",
        type=int,
        default=0,
    )
    cohort_method_group.add_argument(
        "--database-url",
        help="Database URL to query",
        type=str,
        default=os.environ.get("DATABASE_URL", ""),
    )

    options = parser.parse_args()
    if options.version:
        version = parse(runner.__version__)
        print(f"v{version.public}")
    elif options.which == "generate_cohort":
        os.environ["DATABASE_URL"] = options.database_url
        generate_cohort(options.expectations_population)
    elif options.which == "cohort_report":
        make_cohort_report()
    elif options.which == "update_codelists":
        update_codelists()
        print("Codelists updated. Don't forget to commit them to the repo")
    elif options.which == "dump_cohort_sql":
        dump_cohort_sql()
    elif options.which == "dump_study_yaml":
        dump_study_yaml()


if __name__ == "__main__":
    main()
