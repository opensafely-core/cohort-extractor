import os
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
        csvfile = os.path.join(tmpdir, "output.csv")
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
            # "-w",
            # "99",
            "-o",
            csvfile,
        ]
        try:
            subprocess.run(cmd, capture_output=True, encoding="utf8", check=True)
        except subprocess.CalledProcessError as e:
            print(e.output)
            raise
        with open(filename, "a+", newline="\r\n") as final_file:
            # We use windows line endings because that's what
            # the CSV module's default dialect does
            found_error = False

            for line_num, line in enumerate(open(csvfile, "r")):
                if line_num == 0:
                    if line.startswith("Warning"):
                        continue
                    elif line.startswith("Msg "):
                        found_error = True
                if line_num <= 2 and line.startswith("-"):
                    continue
                yield line
                final_file.write(line)
            if found_error:
                final_file.seek(0)
                raise ValueError(final_file.read())
