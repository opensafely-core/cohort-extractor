from github import Github
from requests_oauthlib import OAuth2Session
from oauthlib.oauth2 import TokenExpiredError
import json
import subprocess
from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl
import threading
import webbrowser
import requests
from pathlib import Path


client_id = r"ebf9791707d8de35f913"
client_secret = r"e3261ec789e3b65f5c9880af9d32786262bf791f"

authorization_base_url = "https://github.com/login/oauth/authorize"
token_url = "https://github.com/login/oauth/access_token"
scope = "read:packages,repo"

REVIEW_BRANCH_NAME = "server-artefacts"

# fmt: off
try:
    import wx
    # Initialize wx App
    app = wx.App()
    app.MainLoop()

    def ask(message):
        dlg = wx.TextEntryDialog(None, message)
        dlg.ShowModal()
        result = dlg.GetValue()
        dlg.Destroy()
        return result
except ImportError:
    def ask(message):
        return input(message)
# fmt: on


def _git_run(*args):
    cmd = ["git"] + list(args)
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode > 0:
        print(result.stderr)
        raise subprocess.CalledProcessError(
            returncode=result.returncode, cmd=cmd, stderr=result.stderr
        )
    return result


def with_friendly_git_warning(func):
    def checker(*args, **kwargs):
        try:
            _git_run("--version")
            return func(*args, **kwargs)
        except FileNotFoundError:
            return "Git must be installed!"

    return checker


def get_github_token():
    """Log in a user via Github OAuth, cache the token locally (at
    `token.json`), and return the token.

    """
    access_token = {}
    github = OAuth2Session(client_id, scope=scope, redirect_uri=None)
    authorization_url, state = github.authorization_url(authorization_base_url)
    try:
        with open("token.json", "r") as f:
            access_token = json.load(f)
    except FileNotFoundError:
        pass

    def start_server():
        class Handler(BaseHTTPRequestHandler):
            def log_message(self, format, *args):
                pass

            def do_GET(self):
                self.send_response(200)
                self.send_header("Content-Type", "text/plain")
                self.end_headers()
                text = f"Paste the following:\n\nhttps://localhost:8080{self.path}\n\nYou can then close this browser window"
                self.wfile.write(text.encode())
                return

        server = HTTPServer(("localhost", 8080), Handler)
        config_folder = Path(__file__).absolute().parent / "config"
        server.socket = ssl.wrap_socket(
            server.socket,
            keyfile=config_folder / "localhost.key",
            certfile=config_folder / "localhost.crt",
            server_side=True,
        )
        thread = threading.Thread(target=server.serve_forever)
        thread.deamon = True

        thread.start()
        print("starting server on port {}".format(server.server_port))
        return server

    try:
        client = OAuth2Session(client_id, token=access_token)
        resp = client.get(
            "https://api.github.com/repos/ebmdatalab/opencorona-research-template/commits"
        )
        resp.raise_for_status()
    except (TokenExpiredError, requests.exceptions.HTTPError, ValueError):
        server = start_server()
        webbrowser.open(authorization_url)
        resp = ask(
            "A login for github should have opened in your browser. Paste authorisation string from your browser here:\n"
        )
        access_token = github.fetch_token(
            token_url, client_secret=client_secret, authorization_response=resp
        )

        server.shutdown()
        with open("token.json", "w") as f:
            json.dump(access_token, f)
    return access_token["access_token"]


def get_local_branches():
    """List local branches, except `master`
    """
    result = _git_run("branch", "--list")
    return [x[2:] for x in result.stdout.splitlines() if x[2:] not in ["master"]]


def get_current_branch():
    result = _git_run("rev-parse", "--abbrev-ref", "HEAD")
    return result.stdout.strip()


def setup_git_config():
    """Set up local config to match Github OAuth account
    """
    github = Github(get_github_token())
    github_user = github.get_user()
    _git_run("config", "user.name", f'"{github_user.name}"')
    _git_run("config", "user.email", f'"{github_user.email}"')


def review_branch_exists():
    return REVIEW_BRANCH_NAME in get_local_branches()


def get_changes(pathspec):
    """Return a list of files that have changed, except any hard-coded exceptions.

    Exceptions are a belt-and-braces measure to ensure we never commit
    potentially-sensitive data.

    """
    result = _git_run("status", "--short", "--porcelain", "--", pathspec)
    return [
        x.strip()[2:].strip()
        for x in result.stdout.splitlines()
        if not x.endswith("input.csv")
    ]


def add_and_commit_outputs(file_list):
    """Make a commit of all changes found in `file_list`
    """
    assert file_list, "Nothing to commit"
    _git_run("add", *file_list)
    _git_run("commit", "-m", "Automatically added files")


def create_review_branch():
    """Optionally create, then checkout, REVIEW_BRANCH_NAME
    """
    if not review_branch_exists():
        assert (
            get_current_branch() == "master"
        ), "You must be on git master branch to start a new review"
        _git_run("checkout", "-b", REVIEW_BRANCH_NAME)
    else:
        _git_run("checkout", REVIEW_BRANCH_NAME)


@with_friendly_git_warning
def release_outputs(message):
    """Make a "release": that is, merge the branch REVIEW_BRANCH_NAME into
    master, using the identity obtained from Github using OAuth2

    """
    if review_branch_exists():

        setup_git_config()
        _git_run("checkout", "master")
        _git_run("merge", "--no-ff", "--signoff", "-m", message, REVIEW_BRANCH_NAME)
        _git_run("branch", "--delete", REVIEW_BRANCH_NAME)
        # XXX and now git push!
        return "Git push not yet implemented!"
    else:
        return "No changes to release"


@with_friendly_git_warning
def diff_outputs(names_only=True):
    if review_branch_exists():
        _git_run("checkout", "master")
        if names_only:
            intro_text = "These files have changed. Please review them.\n\n"
            result = _git_run("diff", "--name-only", REVIEW_BRANCH_NAME)
        else:
            intro_text = "This is a diff of all changes. Please review.\n\n"
            result = _git_run("diff", REVIEW_BRANCH_NAME)
        return intro_text + result.stdout
    else:
        return "No changes to report"


@with_friendly_git_warning
def update_review_branch(pathspec):
    """Check out the review branch, and add any relevant changed files
    """
    changes = get_changes(pathspec)
    if changes:
        create_review_branch()
        add_and_commit_outputs(changes)
        _git_run("checkout", "master")
    return changes
