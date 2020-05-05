"""A cross-platform script to build cohorts, run models, build and
start a notebook, open a web browser on the correct port, and handle
shutdowns gracefully
"""

import glob
import os
import re
import requests
import subprocess
import shutil
import signal
import socket
import sys
import time
import urllib.request
import webbrowser


import base64
from io import BytesIO
from matplotlib import pyplot as plt
import numpy as np
from pandas.api.types import is_categorical_dtype
from pandas.api.types import is_bool_dtype
from pandas.api.types import is_datetime64_dtype
from pandas.api.types import is_numeric_dtype

from datetime import datetime
import seaborn as sns


try:
    from gooey import Gooey
    from gooey import GooeyParser as ArgumentParser

    GOOEY_INSTALLED = True  # Currently, only in a Windows build
except ImportError:
    GOOEY_INSTALLED = False
    from argparse import ArgumentParser

stata_image = "docker.pkg.github.com/ebmdatalab/stata-docker-runner/stata-mp:latest"
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


def await_jupyter_http(port):
    """Wait up to 10 seconds for Jupyter to be available
    """
    print(f"Waiting for Jupyter to be ready on port {port}")
    timeout = 10
    increment = 0.1
    counter = 0
    url = f"http://localhost:{port}"
    while counter < (timeout / increment):
        try:
            with urllib.request.urlopen(url, timeout=timeout):
                return
        except ConnectionResetError:
            counter += 1
            time.sleep(increment)
        except socket.timeout:
            break

    raise SystemError(f"Unable to reach Jupyter at {url}")


def stream_subprocess_output(cmd):
    """Stream stdout and stderr of `cmd` in a subprocess to stdout
    """
    with subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        bufsize=1,
        universal_newlines=True,
    ) as p:
        for line in p.stdout:
            # I don't understand why we need the `\r`, but when run
            # via docker apparently require a carriage return for the
            # output to display correctly
            print(line, end="\r")
        p.wait()
        if p.returncode > 0:
            raise subprocess.CalledProcessError(cmd=cmd, returncode=p.returncode)


def docker_build(tag):
    """Build container for Dockerfile in current directory
    """
    buildcmd = ["docker", "build", "-t", tag, "-f", "Dockerfile", "."]
    print(
        "Building docker image. This may take some time (particularly on the first run)..."
    )
    print("Running", " ".join(buildcmd))
    stream_subprocess_output(buildcmd)


def docker_login():
    runcmd = [
        "docker",
        "login",
        "docker.pkg.github.com",
        "-u",
        os.environ["GITHUB_ACTOR"],
        "--password",
        os.environ["GITHUB_TOKEN"],
    ]
    print("Running {}".format(" ".join(runcmd)))
    return stream_subprocess_output(runcmd)


def docker_pull(image):
    runcmd = ["docker", "pull", image]
    print("Running {}".format(" ".join(runcmd)))
    return stream_subprocess_output(runcmd)


def docker_run(image, *args, detach=False):
    """Run docker in background, and install signal handler to stop it
    again

    """
    current_dir = relative_dir()
    runcmd = [
        "docker",
        "run",
        f"--detach={detach and 'true' or 'false'}",
        "-w",
        target_dir,
        "--rm",  # clean up the container after it's stopped
        "--mount",
        f"source={current_dir},dst={target_dir},type=bind",
        "--publish-all",
        "--mount",
        # Ensure we override any local pyenv configuration
        f"source={current_dir}/.python-version-docker,dst={target_dir}/.python-version,type=bind",
        image,
        *args,
    ]
    print("Running {}".format(" ".join(runcmd)))
    if detach:
        completed_process = subprocess.run(runcmd, check=True, capture_output=True)
        container_id = completed_process.stdout.decode("utf8").strip()

        def stop_handler(sig, frame):
            print("Stopping docker...")
            subprocess.run(["docker", "kill", container_id], check=True)
            sys.exit(0)

        signal.signal(signal.SIGINT, stop_handler)

        return container_id
    else:
        return stream_subprocess_output(runcmd)


def docker_port(container_id):
    """Return the port that the specified container is listening on
    """
    completed_process = subprocess.run(
        ["docker", "port", container_id], check=True, capture_output=True
    )
    port_mapping = completed_process.stdout.decode("utf8").strip()
    port = port_mapping.split(":")[-1]
    return port


def check_output():
    # Stata insists on writing to the current
    # directory: https://stackoverflow.com/a/35051922/559140
    output = ""
    with open("model.log", "r") as f:
        output = f.read()
        # XXX at this point, for some reason newlines are coming out
        # as escaped literals. I can't work out why and need to get on
        # for now, so have replaced `^` in this regex with `\n`/DOTALL
        if re.findall(r"\nr\([0-9]+\);$", output, re.DOTALL):
            raise Exception(f"Problem found:\n\n{output}")
    return output


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


def generate_cohort():
    print("Running. Please wait...")
    sys.path.extend([relative_dir(), os.path.join(relative_dir(), "analysis")])
    # Avoid creating __pycache__ files in the analysis directory
    sys.dont_write_bytecode = True
    from study_definition import study

    with_sqlcmd = shutil.which("sqlcmd") is not None
    study.to_csv("analysis/input.csv", with_sqlcmd=with_sqlcmd)
    print("Successfully created cohort and covariates at analysis/input.csv")


def make_cohort_report():
    sys.path.extend([relative_dir(), os.path.join(relative_dir(), "analysis")])
    # Avoid creating __pycache__ files in the analysis directory
    sys.dont_write_bytecode = True
    from study_definition import study

    df = study.csv_to_df("analysis/input.csv")
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

    with open("analysis/descriptives.html", "w") as f:

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
    print("Created cohort report at analysis/descriptives.html")


def run_model(folder, stata_path=None):
    # XXX it's /e on windows
    args = ["-b", "do", f"{folder}/model.do"]
    if not stata_path:
        # XXX they'll need to log in docker_login()? Ensure
        # environment variables are set
        docker_run(stata_image, *args)
    else:
        stream_subprocess_output([stata_path] + args)
    return check_output()


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


def main(from_cmd_line=False):
    parser = ArgumentParser(
        description="Generate cohorts and run models in openSAFELY framework. "
        "Latest version at https://github.com/ebmdatalab/opencorona-research-template/releases/latest"
    )
    subparsers = parser.add_subparsers(help="sub-command help")
    generate_cohort_parser = subparsers.add_parser(
        "generate_cohort", help="Generate cohort"
    )
    generate_cohort_parser.set_defaults(which="generate_cohort")
    cohort_report_parser = subparsers.add_parser(
        "cohort_report", help="Generate cohort report"
    )
    cohort_report_parser.set_defaults(which="cohort_report")
    run_model_parser = subparsers.add_parser("run", help="Run model")
    run_model_parser.set_defaults(which="run")
    run_notebook_parser = subparsers.add_parser("notebook", help="Run notebook")
    run_notebook_parser.set_defaults(which="notebook")
    update_codelists_parser = subparsers.add_parser(
        "update_codelists",
        help="Update codelists, using specification at codelists/codelists.txt",
    )
    update_codelists_parser.set_defaults(which="update_codelists")

    # Cohort parser options
    generate_cohort_parser.add_argument(
        "--database-url",
        help="Database URL to query",
        type=str,
        required=True,
        default=os.environ.get("DATABASE_URL", ""),
    )
    if from_cmd_line:
        generate_cohort_parser.add_argument(
            "--docker", action="store_true", help="Run in docker"
        )
        generate_cohort_parser.add_argument(
            "--skip-build", action="store_true", help="Skip docker build step"
        )

    # Model runner options
    run_model_stata_kwargs = {
        "help": "Path to Stata executable. Will use docker version if left empty"
    }
    if GOOEY_INSTALLED:
        run_model_stata_kwargs["widget"] = "FileChooser"

    run_model_parser.add_argument("--stata-path", **run_model_stata_kwargs)
    run_target_group = run_model_parser.add_mutually_exclusive_group()
    run_target_group.add_argument(
        "--analysis",
        action="store_true",
        help="Run stata against model at analysis/model.do",
    )
    run_target_group.add_argument(
        "--test", action="store_true", help="Run stata using internal test model"
    )

    # Notebook runner options at the moment
    run_notebook_parser.add_argument(
        "--skip-build", action="store_true", help="Skip docker build step"
    )

    options = parser.parse_args()
    if options.which == "run":
        if options.test:
            try:
                run_model("tests", options.stata_path)
                print("SUCCESS running tests")
            except subprocess.CalledProcessError:
                print("ERROR running tests")
                raise
        else:
            print(run_model("analysis", options.stata_path))
    elif options.which == "generate_cohort":
        if from_cmd_line and options.docker:
            if not options.skip_build:
                docker_build(notebook_tag)
            args = sys.argv[:]
            if "--docker" in args:
                args.remove("--docker")
            docker_run(notebook_tag, "python", *args)
        else:
            os.environ["DATABASE_URL"] = options.database_url
            generate_cohort()
    elif options.which == "cohort_report":
        make_cohort_report()
    elif options.which == "notebook":
        if not options.skip_build:
            docker_build(notebook_tag)
        container_id = docker_run(notebook_tag, detach=True)
        port = docker_port(container_id)
        await_jupyter_http(port)
        webbrowser.open(f"http://localhost:{port}", new=2)  # Open in a new tab
        print(
            "To stop this docker container, use Ctrl+ C, or the File -> Shut Down menu in Jupyter Lab"
        )
        stream_subprocess_output(["docker", "logs", "--follow", container_id])
    elif options.which == "update_codelists":
        update_codelists()
        print("Codelists updated. Don't forget to commit them to the repo")


if __name__ == "__main__":
    if (len(sys.argv) == 1 or sys.argv[1] == "--ignore-gooey") and GOOEY_INSTALLED:
        Gooey(main)()
    else:
        main(from_cmd_line=True)
