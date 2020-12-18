from cohortextractor.presto_utils import presto_connection_params_from_url


def test_presto_connection_params_from_url_with_auth():
    url = "presto://user:password@host:80/catalog/schema"
    params = presto_connection_params_from_url(url)

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

def test_presto_connection_params_from_url_with_port_443():
    url = "presto://host:443/catalog/schema"
    assert presto_connection_params_from_url(url)== {
        "http_scheme": "https",
        "user": "ignored",
        "host": "host",
        "port": 443,
        "catalog": "catalog",
        "schema": "schema",
    }

def test_presto_connection_params_from_url_with_no_port():
    url = "presto://host/catalog/schema"
    assert presto_connection_params_from_url(url)== {
        "http_scheme": "http",
        "user": "ignored",
        "host": "host",
        "port": 8080,
        "catalog": "catalog",
        "schema": "schema",
    }
