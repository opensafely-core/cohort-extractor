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
        password = getpass.getpass()
        netrc[JOB_SERVER] = {"login": login, "password": password}
        netrc.save()
    return (login, password)


def get_repo():
    cmd = ["git", "config", "--get", "remote.origin.url"]
    result = subprocess.check_output(cmd, encoding="utf8")
    if result.startswith("git@github.com"):
        # Turn git@github.com:opensafely/cohort-extractor.git into
        # https://github.com/opensafely/cohort-extractor
        org_and_repo = result.split(":")[1][: -(len(".git") + 1)]
        result = f"https://github.com/{org_and_repo}"
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
        else:
            if entry["status_code"] is None:
                status = "running"
            elif entry["status_code"] == 0:
                status = "finished"
            else:
                status = f"error ({entry['status_code']})"
            entry["status"] = status
        log_lines.append(
            "{created_at}: {operation} on {tag} ({status})".format(**entry)
        )
    return log_lines


def do_post(data):
    set_auth()
    response = requests.post(ENDPOINT, json=data)
    response.raise_for_status()
    return response.json()


def submit_job(tag, operation):
    allowed_operations = ["generate_cohort"]
    assert operation in allowed_operations, f"operation must be in {allowed_operations}"
    data = {"repo": get_repo(), "tag": tag, "operation": "generate_cohort"}
    return do_post(data)
