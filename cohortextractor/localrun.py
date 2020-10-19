import logging
import os
import subprocess
import tempfile

from jobrunner.job import Job


def get_branch():
    """Return name of current git branch
    """
    cmd = ["git", "rev-parse", "--abbrev-ref", "HEAD"]
    return subprocess.check_output(cmd, encoding="utf8").strip()


def get_repo():
    """Return an HTTP-based Github URL for the current git remote
    """
    cmd = ["git", "config", "--get", "remote.origin.url"]
    result = subprocess.check_output(cmd, encoding="utf8").strip()
    if result.startswith("git@github.com"):
        # Turn git@github.com:opensafely/cohort-extractor.git into
        # https://github.com/opensafely/cohort-extractor
        org_and_repo = result.split(":")[1]
        result = f"https://github.com/{org_and_repo}"
    if result.endswith(".git"):
        result = result[: -len(".git")]
    return result


def localrun(
    action_id,
    backend,
    db,
    force_run=False,
    force_run_dependencies=False,
    log_level=logging.WARNING,
):
    repo = get_repo()
    job_spec = {
        "url": "",
        "backend": backend,
        "pk": None,
        "run_locally": True,
        "action_id": action_id,
        "force_run": force_run,
        "force_run_dependencies": force_run_dependencies,
        "workspace": {
            "id": 1,
            "url": "",
            "name": "local",
            "repo": repo,
            "branch": get_branch(),
            "db": db,
            "owner": "me",
        },
        "workspace_id": 1,
    }
    os.environ["HIGH_PRIVACY_STORAGE_BASE"] = tempfile.mkdtemp(prefix="opensafely_high_privacy")
    os.environ["MEDIUM_PRIVACY_STORAGE_BASE"] = tempfile.mkdtemp(prefix="opensafely_medium_privacy")
    job = Job(job_spec, workdir=os.getcwd())
    job.logger.setLevel(log_level)
    return job.main()
