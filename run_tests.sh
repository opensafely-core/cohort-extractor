#!/bin/bash
exec docker-compose run \
  --rm \
  --entrypoint /bin/bash \
  --volume "$PWD:/workspace" \
  -e PYENV_VERSION=3.8.3 \
  -e TPP_DATABASE_URL='mssql://SA:Your_password123!@mssql:1433/Test_OpenCorona' \
  -e EMIS_DATABASE_URL=presto://presto:8080/mssql/dbo \
  -e EMIS_DATASOURCE_DATABASE_URL='mssql://SA:Your_password123!@mssql:1433/Test_EMIS' \
  app \
    --login -- py.test "$@"
