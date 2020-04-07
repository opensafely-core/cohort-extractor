"""A cross-platform script to build and start a notebook, open a web
browser on the correct port, and handle shutdowns gracefully

"""
import os
import re
import subprocess
import socket
import time
import urllib.request
import argparse

import generate_cohort


tag = "docker.pkg.github.com/ebmdatalab/stata-docker-runner/stata-mp:latest"
current_dir = os.getcwd()
target_dir = "/home/app/notebook"


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
    runcmd = [
        "docker",
        "run",
        "-it",
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
    with open("model.log", "r") as f:
        output = f.read()
        # XXX at this point, for some reason newlines are coming out
        # as escaped literals. I can't work out why and need to get on
        # for now, so have replaced `^` in this regex with `\n`/DOTALL
        if re.findall(r"\nr\([0-9]+\);$", output, re.DOTALL):
            raise Exception(f"Problem found:\n\n{output}")


def clear_output():
    try:
        print("Removing existing output")
        os.remove("model.log")
    except FileNotFoundError:
        pass


def run_model(folder):
    docker_run(tag, "-b", "do", f"{folder}/model.do")
    check_output()


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run models")
    parser.add_argument("command", choices=["run", "generate_cohort", "test", "shell"])
    parser.add_argument(
        "--skip-build", help="Skip docker image build step", action="store_true"
    )
    args = parser.parse_args()
    docker_login()
    docker_pull()
    if args.command == "shell":
        docker_build_and_run("/bin/bash", skip_build=args.skip_build)
    if args.command == "run":
        print(run_model("analysis"))
    if args.command == "test":
        run_model("tests")
    elif args.command == "generate_cohort":
        generate_cohort.main()
