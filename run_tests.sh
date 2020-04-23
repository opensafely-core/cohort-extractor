#!/bin/bash
exec docker-compose run \
  --rm \
  -e DATABASE_URL=mssql+pyodbc://SA:Your_password123!@sql:1433/Test_OpenCorona?driver=ODBC+Driver+17+for+SQL+Server \
  app \
    bash --login -- py.test "$@" tests/
