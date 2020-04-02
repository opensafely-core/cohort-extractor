"""A cross-platform script to build and start a notebook, open a web
browser on the correct port, and handle shutdowns gracefully

"""
import os
import subprocess
import socket
import time
import urllib.request
import argparse
import sys

import generate_cohort


tag = "datalab-stata"
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


def docker_run(tag, *cmd):
    """Run docker in background, and install signal handler to stop it
    again

    """
    runcmd = [
        "docker",
        "run",
        "-it",
        "--rm",  # clean up the container after it's stopped
        "--mount",
        f"source={current_dir},dst={target_dir},type=bind",
        tag,
        *cmd,
    ]
    print("Running docker with {}".format(" ".join(runcmd)))
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


def docker_build_and_run(cmd, skip_build=False):
    if not skip_build:
        docker_build(tag)
    result = docker_run(tag, "python3", cmd)
    print(result)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run models")
    parser.add_argument("command", choices=["run", "generate_cohort"])
    parser.add_argument(
        "--skip-build", help="Skip docker image build step", action="store_true"
    )
    args = parser.parse_args()
    if args.command == "run":
        docker_build_and_run("run_model.py", skip_build=args.skip_build)
    elif args.command == "generate_cohort":
        generate_cohort.main()
