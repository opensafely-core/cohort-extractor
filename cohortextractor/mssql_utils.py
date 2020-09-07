from urllib.parse import urlparse, unquote

import sqlalchemy
from sqlalchemy.engine.url import URL


def mssql_connection_params_from_url(url):
    parsed = urlparse(url)
    if parsed.scheme != "mssql" and not parsed.scheme.startswith("mssql+"):
        raise ValueError(f"Wrong scheme for MS-SQL URL: {url}")
    return {
        "host": parsed.hostname,
        "port": parsed.port or 1433,
        "database": parsed.path.lstrip("/"),
        "username": unquote(parsed.username),
        "password": unquote(parsed.password),
    }


def mssql_dbapi_connection_from_url(url):
    # We avoid importing this immediately because we're using the TPPBackend
    # code for error checking (as a hopefully temporary shortcut) and so want
    # to be able to create a TPPBackend instance without needing a MSSQL
    # database driver installed (which complicates local installing).
    params = mssql_connection_params_from_url(url)

    try:
        import ctds
    except ImportError:
        pass
    else:
        return _ctds_connect(ctds, params)

    try:
        import pyodbc
    except ImportError:
        pass
    else:
        return _pyodbc_connect(pyodbc, params)

    raise ImportError(
        "Unable to import database driver, tried `ctds` and `pyodbc`\n"
        "\n"
        "We use `ctds` in production. If you are on Linux the correct version is "
        "specified in the `requirements.txt` file.\n"
        "\n"
        "Installation instructions for other platforms can be found at:\n"
        "https://zillow.github.io/ctds/install.html"
    )


def _pyodbc_connect(pyodbc, params):
    connection_str_template = (
        "DRIVER={{ODBC Driver 17 for SQL Server}};"
        "SERVER={host},{port};"
        "DATABASE={database};"
        "UID={username};"
        "PWD={password}"
    )
    connection_str = connection_str_template.format(**params)
    return pyodbc.connect(connection_str)


def _ctds_connect(ctds, params):
    params = params.copy()
    params["server"] = params.pop("host")
    params["user"] = params.pop("username")
    return ctds.connect(**params)


def mssql_sqlalchemy_engine_from_url(url):
    params = mssql_connection_params_from_url(url)
    params["drivername"] = "mssql+pyodbc"
    params["query"] = {"driver": "ODBC Driver 17 for SQL Server"}
    return sqlalchemy.create_engine(URL(**params))
