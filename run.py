"""A cross-platform script to build cohorts, run models, build and
start a notebook, open a web browser on the correct port, and handle
shutdowns gracefully
"""

import os
import re
import subprocess
import socket
import time
import urllib.request



try:
    from gooey import Gooey
    from gooey import GooeyParser as ArgumentParser

    GOOEY_INSTALLED = True  # Currently, only in a Windows build
except ImportError:
    GOOEY_INSTALLED = False
    from argparse import ArgumentParser

tag = "docker.pkg.github.com/ebmdatalab/stata-docker-runner/stata-mp:latest"
target_dir = "/home/app/notebook"


def relative_dir():
    if sys.executable.endswith(".exe"):
        # This is a pyinstaller package on Windows; the `cwd` is
        # likely to be anything (e.g. the Github desktop AppData
        # space); `__file__` is some kind of temporary location
        # resulting from an internal unzip.
        relative_dir = os.path.dirname(os.path.realpath(sys.executable))
    else:
        relative_dir = os.path.dirname(os.path.realpath(__file__))
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
    print(
        "Building docker image. This may take some time (particularly on the first run)..."
    )
    buildcmd = ["docker", "build", "-t", tag, "-f", "Dockerfile", "."]
    stream_subprocess_output(buildcmd)


def docker_login():
    runcmd = [
        "echo",
        os.environ["GITHUB_TOKEN"],
        "|",
        "docker",
        "login",
        "docker.pkg.github.com",
        "-u",
        os.environ["GITHUB_ACTOR"],
        "--password-stdin",
    ]
    print("Running {}".format(" ".join(runcmd)))
    return stream_subprocess_output(runcmd)


def docker_pull():
    runcmd = ["docker", "pull", tag]
    print("Running {}".format(" ".join(runcmd)))
    return stream_subprocess_output(runcmd)


def docker_run(tag, *args):
    """Run docker in background, and install signal handler to stop it
    again

    """
    current_dir = relative_dir()
    runcmd = [
        "docker",
        "run",
        "-w",
        target_dir,
        "--rm",  # clean up the container after it's stopped
        "--mount",
        f"source={current_dir},dst={target_dir},type=bind",
        "--mount",
        # Ensure we override any local pyenv configuration
        f"source={current_dir}/.python-version-docker,dst={target_dir}/.python-version,type=bind",
        tag,
        *args,
    ]
    print("Running {}".format(" ".join(runcmd)))
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


def docker_build_and_run(*args, skip_build=False):
    if not skip_build:
        docker_build(tag)
    result = docker_run(tag, *args)
    print(result)


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


def generate_cohort():
    sys.path.extend([relative_dir(), os.path.join(relative_dir(), "analysis")])
    # Avoid creating __pycache__ files in the analysis directory
    sys.dont_write_bytecode = True
    from study_definition import study

    study.to_csv("analysis/input.csv")
    print("Successfully created cohort and covariates at analysis/input.csv")


def run_model(folder, stata_path=None):
    # XXX it's /e on windows
    # XXX and windows doesn't know where we are now
    args = ["-b", "do", f"{folder}/model.do"]
    if not stata_path:
        docker_run(tag, *args)
    else:
        stream_subprocess_output([stata_path] + args)
    return check_output()


def main():
    parser = ArgumentParser()
    subparsers = parser.add_subparsers(help="sub-command help")
    generate_cohort_parser = subparsers.add_parser(
        "generate_cohort", help="Generate cohort"
    )
    generate_cohort_parser.set_defaults(which="generate_cohort")
    run_model_parser = subparsers.add_parser("run", help="Run model")
    run_model_parser.set_defaults(which="run")

    generate_cohort_parser.add_argument(
        "--database-url",
        help="Database URL to query",
        type=str,
        required=True,
        default=os.environ.get("DATABASE_URL", ""),
    )
    if GOOEY_INSTALLED:
        run_model_parser.add_argument(
            "--stata-path",
            help="Path to Stata executable. Will use docker version if left empty",
            widget="FileChooser",
        )
    else:
        run_model_parser.add_argument(
            "--stata-path",
            help="Path to Stata executable. Will use docker version if left empty",
        )
    run_target_group = run_model_parser.add_mutually_exclusive_group()
    run_target_group.add_argument(
        "--analysis",
        action="store_true",
        help="Run stata against model at analysis/model.do",
    )
    run_target_group.add_argument(
        "--test", action="store_true", help="Run stata using internal test model"
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
        generate_cohort()


if __name__ == "__main__":
    if GOOEY_INSTALLED:
        Gooey(main)()
    else:
        main()
