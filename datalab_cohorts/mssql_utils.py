from urllib.parse import urlparse, unquote

import pyodbc
import sqlalchemy
from sqlalchemy.engine.url import URL


def mssql_connection_params_from_url(url):
    parsed = urlparse(url)
    return {
        "host": parsed.hostname,
        "port": parsed.port or 1433,
        "database": parsed.path.lstrip("/"),
        "username": unquote(parsed.username),
        "password": unquote(parsed.password),
    }


def mssql_pyodbc_connection_from_url(url):
    connection_str_template = (
        "DRIVER={{ODBC Driver 17 for SQL Server}};"
        "SERVER={host},{port};"
        "DATABASE={database};"
        "UID={username};"
        "PWD={password}"
    )
    connection_str = connection_str_template.format(
        **mssql_connection_params_from_url(url)
    )
    return pyodbc.connect(connection_str)


def mssql_sqlalchemy_engine_from_url(url):
    params = mssql_connection_params_from_url(url)
    params["drivername"] = "mssql+pyodbc"
    params["query"] = {"driver": "ODBC Driver 17 for SQL Server"}
    return sqlalchemy.create_engine(URL(**params))
