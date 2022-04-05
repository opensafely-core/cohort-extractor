import re
import time
import warnings
from urllib.parse import unquote, urlparse

import structlog

# Some drivers warn about the use of features marked "optional" in the DB-ABI
# spec, using a standardised set of warnings. See:
# https://www.python.org/dev/peps/pep-0249/#optional-db-api-extensions
warnings.filterwarnings("ignore", re.escape("DB-API extension cursor.__iter__() used"))

logger = structlog.get_logger()


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
    #
    try:
        import pymssql
    except ImportError:
        pass
    else:
        return _pymssql_connect(pymssql, params)

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
        "Unable to import database driver, tried `pymssql`, `ctds` and `pyodbc`\n"
        "\n"
        "We use `ctds` in production. If you are on Linux the correct version is "
        "specified in the `requirements.prod.txt` file.\n"
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


def _pymssql_connect(pymssql, params):
    # https://pymssql.readthedocs.io/en/stable/ref/pymssql.html#pymssql.connect
    params = params.copy()
    params["server"] = params.pop("host")
    params["user"] = params.pop("username")
    # Default timeout is 5 seconds. We don't want queries to timeout at all so
    # set to one week
    params["timeout"] = 7 * 24 * 60 * 60
    params["autocommit"] = True
    return pymssql.connect(**params)


def mssql_fetch_table(
    get_cursor,
    table,
    key_column,
    batch_size=2**14,
    retries=2,
    sleep=0.5,
    backoff_factor=1,
):
    """
    Returns the contents of a table as an iterator of tuples, with the first
    row being the column headers

    The table must have a unique integer `key_column` which can be used for
    paging the results. For performance reasons this column should be indexed.

    Failed requests are automatically retried after a pause of `sleep`,
    assuming `retries` is greater than zero.
    """

    batch_fetcher = BatchFetcher(
        get_cursor=get_cursor,
        table=table,
        key_column=key_column,
        batch_size=batch_size,
        retries=retries,
        sleep=sleep,
        backoff_factor=backoff_factor,
    )

    result_batch = batch_fetcher.fetch()
    headers = [x[0] for x in batch_fetcher.cursor.description]
    key_column_index = headers.index(key_column)
    yield headers
    yield from iter(result_batch)
    while len(result_batch) == batch_size:
        min_key = result_batch[-1][key_column_index]
        result_batch = batch_fetcher.fetch(min_key)
        yield from iter(result_batch)


class BatchFetcher:
    def __init__(
        self,
        get_cursor,
        table,
        key_column,
        batch_size,
        retries,
        sleep,
        backoff_factor,
    ):
        self.get_cursor = get_cursor
        self.table = table
        self.key_column = key_column
        self.batch_size = batch_size
        self.retries = retries
        self.sleep = sleep
        self.backoff_factor = backoff_factor
        self.cursor = None

    def fetch(self, min_key=None):
        if min_key is not None:
            assert isinstance(min_key, int)
            where = f"WHERE {self.key_column} > {min_key}"
        else:
            where = ""
        query = (
            f"SELECT TOP {self.batch_size} * FROM {self.table} "
            f"{where} ORDER BY {self.key_column}"
        )
        retries = self.retries
        sleep = self.sleep
        while True:
            try:
                if self.cursor is None:
                    self.cursor = self.get_cursor()
                self.cursor.execute(query)
                return self.cursor.fetchall()
            # We can't be more specific than this because we don't know what class
            # of cursor object we'll be passed
            except Exception:
                logger.exception(f"Hit exception, sleeping for {sleep} seconds")
                retries -= 1
                if retries == 0:
                    raise
                else:
                    time.sleep(sleep)
                    sleep *= self.backoff_factor
                    self.cursor = None
