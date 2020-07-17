import os
import re
import subprocess
import tempfile
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


def mssql_pyodbc_connection_from_url(url):
    # We avoid importing this immediately because we're using the TPPBackend
    # code for error checking (as a hopefully temporary shortcut) and so want
    # to be able to create a TPPBackend instance without needing pyodbc
    # installed (which complicates local installing).
    import pyodbc

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


def mssql_query_to_csv_file(database_url, query, filename, yield_output_lines=False):
    """
    Uses the `sqlcmd` program to run an SQL query against the given server and
    save the result as CSV. For large/slow queries this seems to be more
    reliable than running them over pyodbc
    """
    iterator = _mssql_query_to_csv_file(database_url, query, filename)
    # We don't want the default behaviour of this function to be to create an
    # iterator which does nothing until you consume it (which might lead to
    # confusion) but we do want the option of yielding the results so that
    # callers who need to run additional checks on the output can do so
    if yield_output_lines:
        return iterator
    else:
        for line in iterator:
            pass


def _mssql_query_to_csv_file(database_url, query, filename):
    with tempfile.TemporaryDirectory() as tmpdir:
        # Don't output count after table output
        query = f"SET NOCOUNT ON;\n{query}"
        sqlfile = os.path.join(tmpdir, "query.sql")
        with open(sqlfile, "w") as f:
            f.write(query)
        db_dict = mssql_connection_params_from_url(database_url)
        cmd = [
            "sqlcmd",
            "-S",
            db_dict["host"] + "," + str(db_dict["port"]),
            "-d",
            db_dict["database"],
            "-U",
            db_dict["username"],
            "-P",
            db_dict["password"],
            "-i",
            sqlfile,
            "-W",  # strip whitespace
            "-s",
            ",",  # comma delimited
            "-r",
            "1",  # error messages to stderr
        ]
        temp_file = os.path.join(tmpdir, "output.csv")
        with open(temp_file, "wb") as temp_file_handle:
            process = subprocess.Popen(
                cmd, encoding="utf-8", stderr=subprocess.PIPE, stdout=temp_file_handle
            )
            _, stderr = process.communicate()
            has_error = process.returncode != 0 or _output_contains_errors(stderr)
        # We use windows line endings because that's what the CSV module's
        # default dialect does
        with open(filename, "w+", newline="\r\n") as out, open(temp_file, "r") as inp:
            for line_num, line in enumerate(inp):
                # sqlcmd outputs a separator line (consisting of repeated
                # dashes) between the column headers and the data. There's no
                # option to disable this behaviour so we remove it here.
                if line_num == 1:
                    if not re.match(r"^[\-,]+$", line):
                        stderr += (
                            f"\nExpected line 2 to be a separator containing only "
                            f"dashes and commas but found: {line}"
                        )
                        has_error = True
                    continue
                yield line
                out.write(line)
        # We deliberately create the output file before raising any error to
        # aid debugging (given that these queries can often take a long time to
        # run)
        if has_error:
            raise ValueError(stderr)


def _output_contains_errors(output):
    return any(line.startswith("Msg ") for line in output.splitlines())
