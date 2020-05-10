import subprocess
import itertools
import pkg_resources
import os

packages = list(pkg_resources.working_set)

args = list(
    itertools.chain(
        *zip(["--hidden-import"] * len(packages), [p.project_name for p in packages])
    )
)
cmd = ["pyinstaller"] + args + ["--onefile", "wrapper.py"]
subprocess.run(cmd, check=True)
