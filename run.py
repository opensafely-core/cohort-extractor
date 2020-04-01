"""A cross-platform script to build and start a notebook, open a web
browser on the correct port, and handle shutdowns gracefully

"""
import os
import signal
import subprocess
import socket
import sys
import time
import urllib.request
import webbrowser

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
            print(line, end="")
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


def docker_run(tag):
    """Run docker in background, and install signal handler to stop it
    again

    """
    runcmd = [
        "docker",
        "run",
        "-it",
        # "--detach",  # in the background, so we can find out the port it's bound to
        "--rm",  # clean up the container after it's stopped
        "--mount",
        f"source={current_dir},dst={target_dir},type=bind",
        "--publish-all",
        tag,
    ]
    print("Running docker with {}".format(" ".join(runcmd)))
    # completed_process = subprocess.run(runcmd, check=True, capture_output=True)
    # container_id = completed_process.stdout.decode("utf8").strip()

    # def stop_handler(sig, frame):
    #     print("Stopping docker...")
    #     subprocess.run(["docker", "kill", container_id], check=True)
    #     sys.exit(0)

    # signal.signal(signal.SIGINT, stop_handler)

    # return container_id


def docker_port(container_id):
    """Return the port that the specified container is listening on
    """
    completed_process = subprocess.run(
        ["docker", "port", container_id], check=True, capture_output=True
    )
    port_mapping = completed_process.stdout.decode("utf8").strip()
    port = port_mapping.split(":")[-1]
    return port


def main():
    docker_build(tag)
    # container_id =
    docker_run(tag)
    # port = docker_port(container_id)
    # await_jupyter_http(port)
    # webbrowser.open(f"http://localhost:{port}", new=2)  # Open in a new tab
    # print(
    # "To stop this docker container, use Ctrl+ C, or the File -> Shut Down menu in Jupyter Lab"
    # )
    # stream_subprocess_output(["docker", "logs", "--follow", container_id])


if __name__ == "__main__":
    main()
