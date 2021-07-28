import os

import pytest
import requests
import yaml


@pytest.mark.skipif(
    os.environ.get("TEST_TRINO_DOCKER_VERSION") != "1",
    reason="TEST_TRINO_DOCKER_VERSION=1 not set in environment",
)
def test_docker_version():
    with open("docker-compose.yml") as f:
        our_version = yaml.safe_load(f)["services"]["trino"]["image"].split(":")[1]

    rsp = requests.get("https://explorerplus.emishealthinsights.co.uk/v1/info")
    their_version = rsp.json()["nodeVersion"]["version"]

    assert our_version == their_version
