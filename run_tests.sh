#!/bin/bash
exec docker-compose run \
  --rm \
  --entrypoint /bin/bash \
  --volume "$PWD:/workspace" \
  -e PYENV_VERSION=3.8.3 \
  -e TPP_DATABASE_URL='mssql+pyodbc://SA:Your_password123!@sql:1433/Test_OpenCorona?driver=ODBC+Driver+17+for+SQL+Server' \
  -e ACME_DATABASE_URL=presto://presto:8080/sqlserver/dbo \
  -e ACME_DATASOURCE_DATABASE_URL='mssql+pyodbc://SA:Your_password123!@sql:1433/Test_ACME?driver=ODBC+Driver+17+for+SQL+Server' \
  app \
    --login -- py.test "$@"
