# For developers

## Run cohortextractor commands
Run commands in docker with `./run.sh cohortextractor --help`


## Run tests

### Linux

You can run everything in docker with `./run.sh pytest`.

You can also run the tests in your own virtualenv, but either way you
will (probably) still want to use docker to run a SQL Server instance:

* Start an mssql and server with `docker-compose up`
* Set up a Python 3.8 virtualenv and `pip install -r requirements.txt`
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

# java
apt-get update && apt-get install -y default-jre
```
* `py.test tests/`

Note: if you change the database schema
be sure to `docker-compose stop && docker-compose rm` before re-running
tests to ensure they are recreated.

### MacOS

You should broadly follow the Linux instructions above, but use brew to install msodbcsql17 as per [Microsoft's instructions](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver15), copied here:

```bash
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
HOMEBREW_NO_ENV_FILTERING=1 ACCEPT_EULA=Y brew install msodbcsql17 mssql-tools
```

## Make releases

To make a release, when you merge to the main branch, at least one of
your commits must contain a _conventional commit_ prefixed `fix:`,
`perf:` or `feat:` (patch, patch, and minor releases, respectively);
or a final line starting `BREAKING CHANGE:` (major release).

Other types are ignored, but you might as well use them: `docs`,
`style`, `refactor`, `ci`, `revert` are likely to be the most common,
but there's [a full list here](https://github.com/commitizen/conventional-commit-types/blob/master/index.json)
