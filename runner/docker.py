from runner.common import relative_dir
from runner.common import stream_subprocess_output
import signal
import subprocess
import sys


target_dir = "/home/app/notebook"


def docker_build(tag):
    """Build container for Dockerfile in current directory
    """
    buildcmd = ["docker", "build", "-t", tag, "-f", "Dockerfile", "."]
    print(
        "Building docker image. This may take some time (particularly on the first run)..."
    )
    print("Running", " ".join(buildcmd))
    stream_subprocess_output(buildcmd)


def docker_login(user, token):
    runcmd = [
        "docker",
        "login",
        "docker.pkg.github.com",
        "-u",
        user,
        "--password",
        token,
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
