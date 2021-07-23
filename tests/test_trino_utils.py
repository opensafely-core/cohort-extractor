from pathlib import Path

import pytest

from cohortextractor.trino_utils import (
    adapt_connection,
    trino_connection_params_from_url,
)


@pytest.mark.parametrize(
    "url",
    [
        "trino://user:password@host:80/catalog/schema",
        "presto://user:password@host:80/catalog/schema",
    ],
)
def test_trino_connection_params_from_url_with_auth(url):
    params = trino_connection_params_from_url(url)

    auth = params.pop("auth")
    assert auth._username == "user"
    assert auth._password == "password"

    assert params == {
        "http_scheme": "http",
        "user": "user",
        "host": "host",
        "port": 80,
        "catalog": "catalog",
        "schema": "schema",
    }


@pytest.mark.parametrize(
    "url",
    [
        "trino://host:443/catalog/schema",
        "presto://host:443/catalog/schema",
    ],
)
def test_trino_connection_params_from_url_with_port_443(url):
    assert trino_connection_params_from_url(url) == {
        "http_scheme": "https",
        "user": "ignored",
        "host": "host",
        "port": 443,
        "catalog": "catalog",
        "schema": "schema",
    }


@pytest.mark.parametrize(
    "url",
    [
        "trino://host/catalog/schema",
        "presto://host/catalog/schema",
    ],
)
def test_trino_connection_params_from_url_with_no_port(url):
    assert trino_connection_params_from_url(url) == {
        "http_scheme": "http",
        "user": "ignored",
        "host": "host",
        "port": 8080,
        "catalog": "catalog",
        "schema": "schema",
    }


class MockConn:
    pass


@pytest.mark.parametrize(
    "env",
    [
        {
            "TRINO_TLS_KEY": "key",
            "TRINO_TLS_CERT": "cert",
        },
        {
            "PRESTO_TLS_KEY": "key",
            "PRESTO_TLS_CERT": "cert",
        },
    ],
)
def test_adapt_connection_plain_keypair(env):
    conn = MockConn()

    adapt_connection(conn, {}, env)

    cert_path, key_path = conn._http_session.cert
    assert Path(cert_path).read_text() == "cert"
    assert Path(key_path).read_text() == "key"


def test_adapt_connection_trino_env_precedence():
    conn = MockConn()
    env = {
        "TRINO_TLS_KEY": "newkey",
        "TRINO_TLS_CERT": "newcert",
        "PRESTO_TLS_KEY": "oldkey",
        "PRESTO_TLS_CERT": "oldcert",
    }

    adapt_connection(conn, {}, env)

    cert_path, key_path = conn._http_session.cert
    assert Path(cert_path).read_text() == "newcert"
    assert Path(key_path).read_text() == "newkey"


def test_adapt_connection_no_cert_configured():
    conn = MockConn()

    with pytest.raises(Exception):
        adapt_connection(conn, {}, {})
