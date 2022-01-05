# For developers

## Run cohortextractor commands

Run cohortextractor commands in Docker with `./run.sh cohortextractor --help`.

If you need to point cohortextractor to a study, then you can set the WORKSPACE env var

```
WORKSPACE=/path/to/study ./run.sh ...
```

## Run tests

### Docker

You can run everything in docker with `./run.sh pytest`.

If using MacOS Docker Desktop, you should increase Settings->Resources->Memory to at least 4GB.

### Linux

You can also run the tests in your own virtualenv, but either way you
will (probably) still want to use docker to run a SQL Server instance:

* Start an mssql and server with `docker-compose up`
* install system dependencies
```
# mssql tools
sudo su
apt-get install -y gnupg && \
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
  apt-get update && \
  ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
  ACCEPT_EULA=Y apt-get install -y mssql-tools
export PATH=$PATH:/opt/mssql-tools/bin

```
* Set up virtual env: `make devenv` - Note: if not on linux, you may need to install ctds manually
* `py.test tests/`

Note: if you change the database schema
be sure to `docker-compose stop && docker-compose rm` before re-running
tests to ensure they are recreated.

### macOS

Running the tests in your own virtualenv on macOS is not advised, because of a hard-to-debug issue with OpenSSL and Microsoft's ODBC driver for SQL Server.
Whilst the [installation instructions](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver15) are clear,
there are several [known issues](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/known-issues-in-this-version-of-the-driver?view=sql-server-ver15#connectivity) that you should be aware of.
[*Hic sunt dracones*](https://en.wikipedia.org/wiki/Here_be_dragons).

## Make releases

To make a release, when you merge to the main branch, at least one of
your commits must contain a _conventional commit_ prefixed `fix:`,
`perf:` or `feat:` (patch, patch, and minor releases, respectively);
or a final line starting `BREAKING CHANGE:` (major release).

Other types are ignored, but you might as well use them: `docs`,
`style`, `refactor`, `ci`, `revert` are likely to be the most common,
but there's [a full list here](https://github.com/commitizen/conventional-commit-types/blob/master/index.json)



## Debugging pymssql

To get query logs from pymssql, we can set an envvar: `TDSDUMP=stdout`. You can just set this when using local venv, or uncomment the line in
docker-compose.yaml if using run.sh.

It's useful when disabling pytest's output/log capturing:

`./run.sh pytest -s --log-cli-level=INFO`


Ths output is very verbose, so this grep filter might help filter out the noise
(note: there are tab characters in there).

`grep -vE '^([a-z]+\.[ch]:|[0-9a-f]{4} |                |       .*[:=].*)' | grep -v -e '^[[:space:]]*$'`
