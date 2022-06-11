import re
import time
import warnings
from urllib.parse import unquote, urlparse

import structlog

from .log_utils import log_execution_time, timing_log_counter

# Some drivers warn about the use of features marked "optional" in the DB-ABI
# spec, using a standardised set of warnings. See:
# https://www.python.org/dev/peps/pep-0249/#optional-db-api-extensions
warnings.filterwarnings("ignore", re.escape("DB-API extension cursor.__iter__() used"))

logger = structlog.get_logger()

SQLSERVER_TIMING_REGEX = re.compile(
    r"""
        .*SQL\sServer\s(?P<timing_type>parse\sand\scompile\stime|Execution\sTime).*  # SQl Server Statistics time message prefix
        .*CPU\stime\s=\s(?P<cpu_time>\d+)\sms  # cpu time in ms
        .*elapsed\stime\s=\s(?P<elapsed_time>\d+)\sms  # elapsed time in ms
        """,
    flags=re.S | re.X,
)


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

    # For more background on why we historically used cTDS and why we support multiple
    # database drivers see:
    # https://github.com/opensafely/cohort-extractor/pull/286
    #
    # And for background on the switch to pymssql for both testing and production
    # https://github.com/opensafely-core/cohort-extractor/issues/704
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
        "We use `pymssql` in production. The correct version is specified in "
        "the `requirements.prod.txt` file."
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


def stats_msg_handler(msgstate, severity, srvname, procname, line, msgtext):
    """
    Log parse, compile and execution timing messages sent by the server.
    """
    try:
        if timing_match := SQLSERVER_TIMING_REGEX.match(msgtext.decode()):
            logger.info(
                "sqlserver-stats",
                description=timing_match.group("timing_type").lower().replace(" ", "_"),
                cpu_time_secs=int(timing_match.group("cpu_time")) / 1000,
                elapsed_time_secs=int(timing_match.group("elapsed_time")) / 1000,
                # SQL Server statistics timing is only set to ON for timed query execution, so
                # we may be able match it to the query it timed by tagging it with the current timing id
                # This may result in multiple execution timings logged against one timing id if
                # query execution is delayed until the time of fetching
                timing_id=timing_log_counter.current,
            )
    except Exception as e:
        # Don't raise any exceptions from the message handling itself, just log them
        logger.error(
            "sqlserver-stats",
            description="Exception in SQL server message handling",
            exc_info=e,
        )


def _pymssql_connect(pymssql, params):
    # https://pymssql.readthedocs.io/en/stable/ref/pymssql.html#pymssql.connect
    params = params.copy()
    params["server"] = params.pop("host")
    params["user"] = params.pop("username")
    # Default timeout is 5 seconds. We don't want queries to timeout at all so
    # set to one week
    params["timeout"] = 7 * 24 * 60 * 60
    params["autocommit"] = True

    connection = pymssql.connect(**params)
    # Install our custom stats handler
    connection._conn.set_msghandler(stats_msg_handler)
    return connection


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
                with log_execution_time(
                    logger, description=f"Fetch batched results {where}"
                ):
                    results = self.cursor.fetchall()
                return results
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
