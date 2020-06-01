#!/bin/bash
exec docker-compose run \
  --rm \
  --entrypoint /bin/bash \
  -e SQL_SERVER_URL='mssql+pyodbc://SA:Your_password123!@sql_server:1433/Test_OpenCorona?driver=ODBC+Driver+17+for+SQL+Server' \
  app \
    --login -- py.test "$@" tests/
