import os
import readline  # noqa -- importing this adds readline behaviour to input()
import tempfile
import time
from urllib.parse import unquote, urlparse

import prestodb
import requests
import structlog

# TODO remove this when certificate verification reinstated
import urllib3
from retry import retry
from tabulate import tabulate

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

sql_logger = structlog.get_logger("cohortextractor.sql")


def presto_connection_from_url(url):
    """Return a connection to Presto instance at given URL."""

    conn_params = presto_connection_params_from_url(url)
    conn = prestodb.dbapi.connect(**conn_params)
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
    """Adapt connection to use passphrase-protected PKCS#12 certificate.

    For instructions for getting a certificate, see
    https://ebmdatalab.github.io/datalab-team-manual/opensafely/accessing-emis-data/
    """

    session = requests.Session()
    crt = env.get("PRESTO_TLS_CERT")
    key = env.get("PRESTO_TLS_KEY")
    pfx_pass = env.get("PFX_PASSWORD_PATH")
    pfx_path = env.get("PFX_PATH")

    # unencrypted cert in env
    if crt and key:
        session.cert = (
            write_to_temp_file(crt, prefix="presto_cert"),
            write_to_temp_file(key, prefix="presto_key"),
        )

    # support encyrpted cert
    elif pfx_pass and pfx_path:
        from requests_pkcs12 import Pkcs12Adapter

        with open(pfx_pass, "rb") as f:
            pkcs12_password = f.read().strip()

        mount_prefix = "{http_scheme}://{host}:{port}".format(**conn_params)
        mount_adaptor = Pkcs12Adapter(
            pkcs12_filename=pfx_path,
            pkcs12_password=pkcs12_password,
        )
        session.mount(mount_prefix, mount_adaptor)
    else:
        raise Exception(
            "Could not load certificate for presto connection from environment"
        )

    conn._http_session = session


def presto_connection_params_from_url(url):
    """Return connection params for given URL."""

    parsed = urlparse(url)
    http_scheme = "https" if parsed.port == 443 else "http"
    parts = parsed.path.strip("/").split("/")
    if len(parts) != 2 or not all(parts) or parsed.scheme != "presto":
        raise ValueError(
            f"Presto URL not of the form 'presto://host.name/catalog/schema': {url}"
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
            connection_params["auth"] = prestodb.auth.BasicAuthentication(
                user, password
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
    """Proxy for prestodb.dbapi.Connection, with a more useful cursor."""

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
      used by EMISBackend, although they could be implemented if required)
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
    """Run a simple REPL against a Presto database at given URL."""

    conn = presto_connection_from_url(url)
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
    except prestodb.exceptions.PrestoUserError as e:
        print(e.message)
        return True
    headers = [col[0] for col in cursor.description]
    rows = list(cursor)
    print()
    print(tabulate(rows, headers=headers))
    return True


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 2:
        print("Usage: python -m cohortextractor.presto_utils DATABASE_URL")
        sys.exit(1)

    repl(sys.argv[1])
