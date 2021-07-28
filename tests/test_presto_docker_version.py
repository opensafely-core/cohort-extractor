import requests
import yaml


def test_docker_version():
    with open("docker-compose.yml") as f:
        our_version = yaml.safe_load(f)["services"]["presto"]["image"].split(":")[1]

    rsp = requests.get("https://explorerplus.emishealthinsights.co.uk/v1/info")
    their_version = rsp.json()["nodeVersion"]["version"]

    assert our_version == their_version
