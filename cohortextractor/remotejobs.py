from tinynetrc import Netrc
import getpass
import os
import requests
import subprocess

JOB_SERVER = "jobs.opensafely.org"
ENDPOINT = f"https://{JOB_SERVER}/jobs/"


def set_auth():
    """Set HTTP auth (used by `requests`)
    """
    # In due course, we should use Github OAuth for this
    netrc_path = os.path.join(os.path.expanduser("~"), ".netrc")
    if not os.path.exists(netrc_path):
        with open(netrc_path, "w") as f:
            f.write("")
    netrc = Netrc()
    if netrc[JOB_SERVER]["password"]:
        login = netrc[JOB_SERVER]["login"]
        password = netrc[JOB_SERVER]["password"]
    else:
        login = input("Job server username: ")
        password = getpass.getpass(
            "Password (warning: Ctrl+V won't work here; try Ctrl+Shift+V if you want to paste): "
        )
        netrc[JOB_SERVER] = {"login": login, "password": password}
        netrc.save()
    return (login, password)


def get_repo():
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


def get_job_logs():
    set_auth()
    data = {"repo": get_repo()}
    response = requests.get(ENDPOINT, params=data)
    response.raise_for_status()
    log_lines = []
    for entry in response.json()["results"]:
        if not entry["started"]:
            status = "not started"
        elif entry["status_code"] is None:
            status = "running"
        elif entry["status_code"] == 0:
            status = f"finished ({entry['output_bucket']})"
        else:
            status = f"error ({entry['status_code']})"
        entry["status"] = status
        log_lines.append(
            "{created_at}: {operation}@{tag} on {backend} {status}".format(**entry)
        )
    return sorted(log_lines)


def do_post(data):
    set_auth()
    response = requests.post(ENDPOINT, json=data)
    response.raise_for_status()
    return response.json()


def submit_job(backend, db, tag, operation, repo=None):
    allowed_operations = ["generate_cohort"]
    allowed_backends = ["all", "tpp"]
    assert operation in allowed_operations, f"operation must be in {allowed_operations}"
    assert backend in allowed_backends, f"backend must be in {allowed_backends}"
    if backend == "all":
        backends = allowed_backends[:]
        backends.remove("all")
    else:
        backends = [backend]
    if not repo:
        repo = get_repo()
    responses = []
    for backend in backends:
        data = {
            "repo": repo,
            "tag": tag,
            "operation": "generate_cohort",
            "backend": backend,
            "db": db,
        }
        callback_url = os.environ.get("EBMBOT_CALLBACK_URL", "")
        if callback_url:
            data["callback_url"] = callback_url
        responses.append(do_post(data))
    return responses
