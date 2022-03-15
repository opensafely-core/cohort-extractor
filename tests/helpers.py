import time

import sqlalchemy
from sqlalchemy.engine.url import URL

from cohortextractor.mssql_utils import mssql_connection_params_from_url


def mssql_sqlalchemy_engine_from_url(url):
    """Create a sqlalchemy connection."""
    params = mssql_connection_params_from_url(url)
    params["drivername"] = "mssql+pymssql"
    return sqlalchemy.create_engine(URL(**params))


def wait_for_mssql_to_be_ready(engine, timeout):
    """
    Waits for the MS SQL database to be ready by repeatedly attempting to
    connect, raising the last received error after `timeout` seconds.
    """
    start = time.time()
    while True:
        try:
            engine.connect()
            break
        except sqlalchemy.exc.DBAPIError:
            if time.time() - start < timeout:
                time.sleep(1)
            else:
                raise


def assert_results(results, **expected_values):
    for col_name, expected_col_values in expected_values.items():
        col_values = [row[col_name] for row in results]
        assert col_values == expected_col_values, f"Unexpected results for {col_name}"


class RecordingReporter:
    def __init__(self):
        self.msg = ""

    def __call__(self, msg):
        self.msg = msg


def null_reporter(msg):
    pass
