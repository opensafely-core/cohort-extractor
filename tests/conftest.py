import os
from pathlib import Path


def pytest_generate_tests(metafunc):
    """Source the test environment
    """
    for line in open(Path(__file__).absolute().parent.parent / ".env-test"):
        k, v = line.split("=", 1)
        os.environ[k.strip()] = v.strip()
