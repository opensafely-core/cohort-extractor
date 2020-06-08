import time
from urllib.parse import urlparse, unquote

import prestodb
import requests


class PrestoNoActiveNodesError(Exception):
    pass


def presto_connection_from_url(url):
    return prestodb.dbapi.connect(**presto_connection_params_from_url(url))


def presto_connection_params_from_url(url):
    parsed = urlparse(url)
    parts = parsed.path.strip("/").split("/")
    if len(parts) != 2 or not all(parts) or parsed.scheme != "presto":
        raise ValueError(
            f"Presto URL not of the form 'presto://host.name/catalog/schema': {url}"
        )
    catalog, schema = parts
    connection_params = {
        "host": parsed.hostname,
        "port": parsed.port or 8080,
        "catalog": catalog,
        "schema": schema,
    }
    if parsed.username:
        user = unquote(parsed.username)
        password = unquote(parsed.password)
        connection_params.update(
            user=user, auth=prestodb.auth.BasicAuthentication(user, password)
        )
    else:
        connection_params["user"] = "ignored"
    return connection_params


def wait_for_presto_to_be_ready(url, timeout):
    connection_params = presto_connection_params_from_url(url)
    start = time.time()
    while True:
        try:
            connection = prestodb.dbapi.connect(**connection_params)
            cursor = connection.cursor()
            cursor.execute(
                "SELECT COUNT(*) FROM system.runtime.nodes WHERE state = 'active'"
            )
            count = cursor.fetchone()[0]
            if count == 0:
                raise PrestoNoActiveNodesError("No active nodes found")
            break
        except (
            prestodb.exceptions.PrestoQueryError,
            requests.exceptions.ConnectionError,
            PrestoNoActiveNodesError,
        ):
            if time.time() - start < timeout:
                time.sleep(1)
            else:
                raise
