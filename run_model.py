import os
import re
import subprocess


def check_output():
    with open("model.log", "r") as f:
        output = f.read()
        print(output)
        if re.match(r"^r\([0-9]+\);$", output):
            raise Exception("Problem found")


def clear_output():
    try:
        print("Removing existing output")
        os.remove("model.log")
    except FileNotFoundError:
        pass


def run_model():
    completed_process = subprocess.run(
        ["/usr/local/stata/stata", "-b", "do", "analysis/model.do"],
        check=True,
        capture_output=True,
    )
    result = completed_process.stdout.decode("utf8").strip()
    print(result)


if __name__ == "__main__":
    clear_output()
    run_model()
    check_output()
