import time
from urllib.parse import urlparse, unquote

import prestodb
import requests


def presto_connection_from_url(url):
    return ConnectionProxy(
        prestodb.dbapi.connect(**presto_connection_params_from_url(url))
    )


def presto_connection_params_from_url(url):
    parsed = urlparse(url)
    parts = parsed.path.strip("/").split("/")
    if len(parts) != 2 or not all(parts) or parsed.scheme != "presto":
        raise ValueError(
            f"Presto URL not of the form 'presto://host.name/catalog/schema': {url}"
        )
    catalog, schema = parts
    connection_params = {
        "host": parsed.hostname,
        "port": parsed.port or 8080,
        "catalog": catalog,
        "schema": schema,
    }
    if parsed.username:
        user = unquote(parsed.username)
        password = unquote(parsed.password)
        connection_params.update(
            user=user, auth=prestodb.auth.BasicAuthentication(user, password)
        )
    else:
        connection_params["user"] = "ignored"
    return connection_params


def wait_for_presto_to_be_ready(url, test_query, timeout):
    """
    Waits for Presto to be ready to execute queries by repeatedly attempting to
    connect and run `test_query`, raising the last received error after
    `timeout` seconds
    """
    connection_params = presto_connection_params_from_url(url)
    start = time.time()
    while True:
        try:
            connection = prestodb.dbapi.connect(**connection_params)
            cursor = connection.cursor()
            cursor.execute(test_query)
            cursor.fetchall()
            break
        except (
            prestodb.exceptions.PrestoQueryError,
            requests.exceptions.ConnectionError,
        ):
            if time.time() - start < timeout:
                time.sleep(1)
            else:
                raise


class ConnectionProxy:
    """Proxy for prestodb.dbapi.Connection, with a more useful cursor.
    """

    def __init__(self, connection):
        self.connection = connection

    def __getattr__(self, attr):
        """Pass any unhandled attribute lookups to proxied connection."""

        return getattr(self.connection, attr)

    def cursor(self):
        """Return a proxied cursor."""

        return CursorProxy(self.connection.cursor())


class CursorProxy:
    """Proxy for prestodb.dbapi.Cursor.

    Unlike prestodb.dbapi.Cursor:

    * any exceptions caused by an invalid query are raised by .execute() (and
      not later when you fetch the results)
    * the .description attribute is set immediately after calling .execute()
    * you can iterate over it to yield rows
    * .fetchone()/.fetchmany()/.fetchall() are disabled (they are not currently
      used by ACMEBackend, although they could be implemented if required)
    """

    _rows = None

    def __init__(self, cursor, batch_size=10 ** 6):
        """Initialise proxy.

        cursor: the presto.dbapi.Cursor to be proxied
        batch_size: the number of records to fetch at a time (this will need to
            be tuned)
        """

        self.cursor = cursor
        self.batch_size = batch_size

    def __getattr__(self, attr):
        """Pass any unhandled attribute lookups to proxied cursor."""

        return getattr(self.cursor, attr)

    def execute(self, *args, **kwargs):
        """Execute a query/statement and fetch first batch of results.

        This:

        * triggers any exceptions caused by the query/statement
        * populates the .description attribute of the cursor
        """

        self.cursor.execute(*args, **kwargs)
        self._rows = self.cursor.fetchmany()

    def __iter__(self):
        """Iterate over results."""

        while self._rows:
            yield from iter(self._rows)
            self._rows = self.cursor.fetchmany(self.batch_size)

    def fetchone(self):
        raise RuntimeError("Iterate over cursor to get results")

    def fetchmany(self, size=None):
        raise RuntimeError("Iterate over cursor to get results")

    def fetchall(self):
        raise RuntimeError("Iterate over cursor to get results")
