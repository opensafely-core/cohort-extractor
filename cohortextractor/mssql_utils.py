import re
from urllib.parse import urlparse, unquote
import warnings

import sqlalchemy
from sqlalchemy.engine.url import URL


# Some drivers warn about the use of features marked "optional" in the DB-ABI
# spec, using a standardised set of warnings. See:
# https://www.python.org/dev/peps/pep-0249/#optional-db-api-extensions
warnings.filterwarnings("ignore", re.escape("DB-API extension cursor.__iter__() used"))


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

    # For more background on why we use cTDS and why we support multiple
    # database drivers see:
    # https://github.com/opensafely/cohort-extractor/pull/286
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
    # Default timeout is 5 seconds. We don't want queries to timeout at all so
    # set to one week
    params["timeout"] = 7 * 24 * 60 * 60
    params["autocommit"] = True
    return ctds.connect(**params)


def mssql_sqlalchemy_engine_from_url(url):
    params = mssql_connection_params_from_url(url)
    params["drivername"] = "mssql+pyodbc"
    params["query"] = {"driver": "ODBC Driver 17 for SQL Server"}
    return sqlalchemy.create_engine(URL(**params))
