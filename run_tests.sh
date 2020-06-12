#!/bin/bash
exec docker-compose run \
  --rm \
  --entrypoint /bin/bash \
  --volume "$PWD:/workspace" \
  -e PYENV_VERSION=3.8.3 \
  -e TPP_DATABASE_URL='mssql://SA:Your_password123!@sql:1433/Test_OpenCorona' \
  -e ACME_DATABASE_URL=presto://presto:8080/sqlserver/dbo \
  -e ACME_DATASOURCE_DATABASE_URL='mssql://SA:Your_password123!@sql:1433/Test_ACME' \
  app \
    --login -- py.test "$@"
