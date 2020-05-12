import os
import sys


def relative_dir():
    if sys.executable == "run.exe":
        # This is a pyinstaller package on Windows; the `cwd` is
        # likely to be anything (e.g. the Github desktop AppData
        # space); `__file__` is some kind of temporary location
        # resulting from an internal unzip.
        relative_dir = os.path.dirname(os.path.realpath(sys.executable))
    else:
        relative_dir = os.getcwd()
    return relative_dir


with open(os.path.join(relative_dir(), "runner", "VERSION")) as version_file:
    __version__ = version_file.read().strip()
