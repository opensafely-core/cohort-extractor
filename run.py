"""A cross-platform script to build cohorts, run models, build and
start a notebook, open a web browser on the correct port, and handle
shutdowns gracefully
"""

import os
import re
import subprocess
import socket
import sys
import time
import urllib.request
import webbrowser

from runner.common import relative_dir
from runner.common import stream_subprocess_output
from runner.docker import docker_run
from runner.docker import docker_build
from runner.docker import docker_port
from runner.docker import docker_login
from runner.git_change_manager import review_branch_exists
from runner.git_change_manager import update_review_branch
from runner.git_change_manager import diff_outputs
from runner.git_change_manager import release_outputs
from runner.git_change_manager import get_github_token

from github import Github


stata_image = "docker.pkg.github.com/ebmdatalab/stata-docker-runner/stata-mp:latest"
notebook_tag = "opencorona-research"


try:
    from gooey import Gooey
    from gooey import GooeyParser as ArgumentParser

    GOOEY_INSTALLED = True  # Currently, only in a Windows build
except ImportError:
    GOOEY_INSTALLED = False
    from argparse import ArgumentParser


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
    if stata_path and sys.platform == "win32":
        args = ["/e", "do", f"{folder}/model.do"]
    else:
        # Running in *nix, either natively, or in docker
        args = ["-b", "do", f"{folder}/model.do"]
    if not stata_path:
        docker_run(stata_image, *args)
    else:
        stream_subprocess_output([stata_path] + args)
    return check_output()


def main(from_cmd_line=False):
    OUTPUT_PATHSPEC = "outputs"
    parser = ArgumentParser()
    subparsers = parser.add_subparsers(help="sub-command help")

    generate_cohort_parser = subparsers.add_parser(
        "generate_cohort", help="Generate cohort"
    )
    generate_cohort_parser.set_defaults(which="generate_cohort")

    run_model_parser = subparsers.add_parser("run", help="Run model")
    run_model_parser.set_defaults(which="run")

    run_notebook_parser = subparsers.add_parser("notebook", help="Run notebook")
    run_notebook_parser.set_defaults(which="notebook")

    login_parser = subparsers.add_parser(
        "github_login",
        help="Log into github (required for docker operations, or approving changes for publication)",
    )
    login_parser.set_defaults(which="github_login")

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
            "--docker",
            action="store_true",
            help="Run in docker (useful if you don't have python set up locally, but you do have docker)",
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

    # Notebook runner options
    run_notebook_parser.add_argument(
        "--skip-build", action="store_true", help="Skip docker build step"
    )

    if review_branch_exists():
        help_annex = "(No changes to review)"
    else:
        help_annex = ""
    view_changes_parser = subparsers.add_parser(
        "view_changes", help=f"Review changes {help_annex}"
    )
    view_changes_parser.set_defaults(which="view_changes")
    view_changes_parser.add_argument(
        "--show-diff", action="store_true", help="Show full diff as well as filenames"
    )

    approve_changes_parser = subparsers.add_parser(
        "approve_changes", help=f"Approve changes {help_annex}"
    )
    approve_changes_parser.set_defaults(which="approve_changes")

    signoff_kwargs = {
        "help": "Sign off changes with notes",
        "type": str,
        "required": True,
    }
    if GOOEY_INSTALLED:
        signoff_kwargs["widget"] = "Textarea"
        signoff_kwargs["gooey_options"] = {"height": 150}

    approve_changes_parser.add_argument("--signoff-message", **signoff_kwargs)

    options = parser.parse_args()
    if options.which == "run":
        if options.test:
            try:
                run_model("tests", options.stata_path)
                print("SUCCESS running tests")
                # Automatically add changes in `outputs` to our local working
                # branch, `server-artefacts`
                update_review_branch(OUTPUT_PATHSPEC)

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
    elif options.which == "view_changes":
        update_review_branch(OUTPUT_PATHSPEC)
        print(diff_outputs(names_only=not options.show_diff))
    elif options.which == "approve_changes":
        # This branch requires a github login
        get_github_token()
        update_review_branch(OUTPUT_PATHSPEC)
        print(release_outputs(options.signoff_message))
    elif options.which == "github_login":
        token = get_github_token()
        gh = Github(token)
        user = gh.get_user()
        print(docker_login(user.login, token))


if __name__ == "__main__":
    if (len(sys.argv) == 1 or sys.argv[1] == "--ignore-gooey") and GOOEY_INSTALLED:
        Gooey(main, monospace_display=True)()
    else:
        main(from_cmd_line=True)
