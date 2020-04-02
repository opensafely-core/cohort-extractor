import os
import re
import subprocess


def check_output():
    # Stata insists on writing to the current
    # directory: https://stackoverflow.com/a/35051922/559140
    with open("model.log", "r") as f:
        output = f.read()
        print(output)
        if re.match(r"^r\([0-9]+\);$", output):
            raise Exception("Problem found")


def fix_permissions():
    """Ensure generated files are world-writable.

    Ugly hack until we get round to changing the base docker image to
    run as a user other than root.

    """
    os.chmod("model.log", 0o666)


def clear_output():
    try:
        print("Removing existing output")
        os.remove("model.log")
    except FileNotFoundError:
        pass


def run_model():
    completed_process = subprocess.run(
        ["/usr/local/stata/stata-mp", "-b", "do", "analysis/model.do"],
        check=True,
        capture_output=True,
    )
    result = completed_process.stdout.decode("utf8").strip()
    print(result)


if __name__ == "__main__":
    clear_output()
    run_model()
    fix_permissions()
    check_output()
