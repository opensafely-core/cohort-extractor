#!/bin/bash
if [[ -z "$1" || "$1" = 'help' || "$1" = '--help' || "$1" = '-help' ]]; then
  echo "./run.sh COMMAND [ARGUMENT]..."
  echo
  echo "Runs COMMAND inside the Docker container with a correctly configured"
  echo "environment. For example:"
  echo
  echo "  Run tests:"
  echo "    ./run.sh pytest"
  echo
  echo "  Start a bash shell:"
  echo "    ./run.sh bash"
  echo
  echo "  Run the cohortextractor tool:"
  echo "    ./run.sh cohortextractor [ARGUMENT]..."
  exit 1
fi

# If the command is `bash` then just remove all arguments to use the default
# entrypoint
if [[ "$1" = "bash" ]]; then
  set --
fi

# If the command is `cohortextractor` then rewrite it to execute the correct
# Python module as the entry point script doesn't seem to work in this context
if [[ "$1" = "cohortextractor" ]]; then
  shift 1
  set -- python -m cohortextractor.cohortextractor "$@"
fi

exec docker-compose run \
  --rm \
  --entrypoint /bin/bash \
  --volume "$PWD:/workspace" \
  -e PYENV_VERSION=3.7.8 \
  -e TPP_DATABASE_URL='mssql://SA:Your_password123!@mssql:1433/Test_OpenCorona' \
  -e ACME_DATABASE_URL=presto://presto:8080/mssql/dbo \
  -e ACME_DATASOURCE_DATABASE_URL='mssql://SA:Your_password123!@mssql:1433/Test_ACME' \
  app \
    --login -- "$@"
