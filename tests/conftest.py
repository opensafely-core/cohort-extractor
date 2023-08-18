import os
from pathlib import Path

import pytest


def pytest_generate_tests(metafunc):
    """Source the test environment"""
    for line in open(Path(__file__).absolute().parent.parent / ".env-test"):
        k, v = line.split("=", 1)
        k = k.strip()
        if not os.environ.get(k):
            os.environ[k] = v.strip()


@pytest.fixture()
def include_t1oo():
    # This flag should only be passed by job-runner, if it's
    # been set in tests, something is wrong
    assert "OPENSAFELY_INCLUDE_T1OO" not in os.environ
    os.environ["OPENSAFELY_INCLUDE_T1OO"] = "True"
    yield
    del os.environ["OPENSAFELY_INCLUDE_T1OO"]
