import csv
import os
import readline  # noqa -- importing this adds readline behaviour to input()
import tempfile
import time
import warnings
from urllib.parse import unquote, urlparse

import requests
import structlog

# The Trino client ought to be close to a drop-in replacement for the Presto
# but it isn't: despite the tests passing we get 500s from Presto in production
# whenever we try to query it. As a quick fix we want to revert to using the
# Presto client, but we don't want to revert all the renaming we've done as
# longer term we need to stick with Trino (after we've resolved the issue with
# the client). So we do this import munging to allow us to run against the old
# Presto client for now. It's dirty but hopefully short-lived.
try:
    import trino
    from trino.exceptions import TrinoQueryError, TrinoUserError
except ImportError:
    import prestodb as trino
    from prestodb.exceptions import PrestoQueryError as TrinoQueryError
    from prestodb.exceptions import PrestoUserError as TrinoUserError

# TODO remove this when certificate verification reinstated
import urllib3
from retry import retry
from tabulate import tabulate

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

sql_logger = structlog.get_logger("cohortextractor.sql")


def trino_connection_from_url(url):
    """Return a connection to Trino instance at given URL."""

    conn_params = trino_connection_params_from_url(url)
    conn = trino.dbapi.connect(**conn_params)
    if "PFX_PATH" in os.environ or "PRESTO_TLS_CERT" in os.environ:
        adapt_connection(conn, conn_params)

    conn._http_session.verify = False

    # TODO reinstate this
    # For now, there is no valid certificate for directoraccess-cert.emishealthinsights.co.uk.
    # for path in Path(__file__).resolve().parent.parent.glob("certs/*"):
    #     if path.parts[-1] in url:
    #         conn._http_session.verify = path / "2.crt"
    #         break

    return ConnectionProxy(conn)


def write_to_temp_file(contents, **kwargs):
    fp, path = tempfile.mkstemp(**kwargs)
    # fp is already opened file number
    os.write(fp, contents.encode("utf8"))
    os.close(fp)
    return path


def adapt_connection(conn, conn_params, env=os.environ):
    """Adapt connection to use TLS client certificate."""
    session = requests.Session()
    # PRESTO_TLS_CERT and PRESTO_TLS_KEY are now legacy.
    # These environment variables are included for backwards compatibility only and will
    # be removed in future.
    # If both environment variable pairs (PRESTO_TLS_CERT and PRESTO_TLS_KEY;
    # TRINO_TLS_CERT and TRINO_TLS_KEY) are specified, then the TRINO environment
    # variables take priority.
    presto_crt = env.get("PRESTO_TLS_CERT")
    presto_key = env.get("PRESTO_TLS_KEY")
    trino_crt = env.get("TRINO_TLS_CERT")
    trino_key = env.get("TRINO_TLS_KEY")

    # unencrypted cert in env
    if trino_crt and trino_key:
        session.cert = (
            write_to_temp_file(trino_crt, prefix="trino_cert"),
            write_to_temp_file(trino_key, prefix="trino_key"),
        )

    elif presto_crt and presto_key:
        warnings.warn(
            "PRESTO_TLS_CERT and PRESTO_TLS_KEY will be removed in a future"
            " cohort-extractor version; use TRINO_TLS_CERT and TRINO_TLS_KEY instead.",
            DeprecationWarning,
        )
        session.cert = (
            write_to_temp_file(presto_crt, prefix="presto_cert"),
            write_to_temp_file(presto_key, prefix="presto_key"),
        )

    else:
        raise Exception(
            "Could not load certificate for Trino connection from environment"
        )

    conn._http_session = session


def trino_connection_params_from_url(url):
    """Return connection params for given URL."""

    parsed = urlparse(url)
    http_scheme = "https" if parsed.port == 443 else "http"
    parts = parsed.path.strip("/").split("/")
    # presto:// is now legacy and replaced with trino://
    # presto:// is included for backwards compatibilty only and can be
    # removed in future.
    if len(parts) != 2 or not all(parts) or parsed.scheme not in ("trino", "presto"):
        raise ValueError(
            "Trino URL not of the form 'trino://host.name/catalog/schema'"
            f" or 'presto://host.name/catalog.schema': {url}"
        )

    if parsed.scheme == "presto":
        warnings.warn(
            "presto:// will be removed in a future cohort-extractor version;"
            " use trino:// instead.",
            DeprecationWarning,
        )

    catalog, schema = parts
    connection_params = {
        "http_scheme": http_scheme,
        "host": parsed.hostname,
        "port": parsed.port or 8080,
        "catalog": catalog,
        "schema": schema,
    }

    if parsed.username:
        user = unquote(parsed.username)
        connection_params["user"] = user
        if parsed.password:
            password = unquote(parsed.password)
            connection_params["auth"] = trino.auth.BasicAuthentication(user, password)
    else:
        connection_params["user"] = "ignored"

    return connection_params


def wait_for_trino_to_be_ready(url, test_query, timeout):
    """
    Waits for Trino to be ready to execute queries by repeatedly attempting to
    connect and run `test_query`, raising the last received error after
    `timeout` seconds
    """
    connection_params = trino_connection_params_from_url(url)
    start = time.time()
    while True:
        try:
            connection = trino.dbapi.connect(**connection_params)
            cursor = connection.cursor()
            cursor.execute(test_query)
            cursor.fetchall()
            break
        except (
            TrinoQueryError,
            requests.exceptions.ConnectionError,
        ):
            if time.time() - start < timeout:
                time.sleep(1)
            else:
                raise


class ConnectionProxy:
    """Proxy for trino.dbapi.Connection, with a more useful cursor."""

    def __init__(self, connection):
        self.connection = connection

    def __getattr__(self, attr):
        """Pass any unhandled attribute lookups to proxied connection."""

        return getattr(self.connection, attr)

    def cursor(self):
        """Return a proxied cursor."""

        return CursorProxy(self.connection.cursor())


class CursorProxy:
    """Proxy for trino.dbapi.Cursor.

    Unlike trino.dbapi.Cursor:

    * any exceptions caused by an invalid query are raised by .execute() (and
      not later when you fetch the results)
    * the .description attribute is set immediately after calling .execute()
    * you can iterate over it to yield rows
    * .fetchone()/.fetchmany()/.fetchall() are disabled (they are not currently
      used by EMISBackend, although they could be implemented if required)
    """

    _rows = None

    def __init__(self, cursor, batch_size=10**6):
        """Initialise proxy.

        cursor: the trino.dbapi.Cursor to be proxied
        batch_size: the number of records to fetch at a time (this will need to
            be tuned)
        """

        self.cursor = cursor
        self.batch_size = batch_size

    def __getattr__(self, attr):
        """Pass any unhandled attribute lookups to proxied cursor."""

        return getattr(self.cursor, attr)

    @retry(tries=3)
    def execute(self, sql, *args, **kwargs):
        """Execute a query/statement and fetch first batch of results.

        This:

        * triggers any exceptions caused by the query/statement
        * populates the .description attribute of the cursor
        """

        sql_logger.debug(sql)
        self.cursor.execute(sql, *args, **kwargs)
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


def repl(url):
    """Run a simple REPL against a Trino database at given URL."""

    conn = trino_connection_from_url(url)
    cursor = conn.cursor()
    while read_eval_print(cursor):
        pass


def read_eval_print(cursor):
    """Read a semicolon-terminated SQL statement, execute it, and print the results."""

    lines = []
    while True:
        prompt = "  " if lines else "> "
        try:
            line = input(prompt).strip()
        except (EOFError, KeyboardInterrupt):
            print()
            return bool(lines)

        lines.append(line)
        if line and line[-1] == ";":
            break

    sql = "\n".join(lines)[:-1]
    try:
        cursor.execute(sql)
    except TrinoUserError as e:
        print(e.message)
        return True
    headers = [col[0] for col in cursor.description]
    rows = list(cursor)
    print()
    print(tabulate(rows, headers=headers))
    return True


def sql_to_csv(url, sql, output, errors):
    """
    Executes the supplied SQL against the specified database and writes CSV to
    `output`
    """
    conn = trino_connection_from_url(url)
    cursor = conn.cursor()
    try:
        cursor.execute(sql)
    except TrinoUserError as e:
        errors.write(e.message)
        errors.write("\n")
        return False
    writer = csv.writer(output)
    headers = [col[0] for col in cursor.description]
    writer.writerow(headers)
    writer.writerows(cursor)
    return True


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python -m cohortextractor.trino_utils DATABASE_URL [SQL]...")
        sys.exit(1)
    database_url = sys.argv[1]
    sql = " ".join(sys.argv[2:])

    if not sql:
        repl(database_url)
    else:
        success = sql_to_csv(database_url, sql, output=sys.stdout, errors=sys.stderr)
        sys.exit(0 if success else 1)
