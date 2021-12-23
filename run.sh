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

ENV=${ENV:-dev}
WORKSPACE=${WORKSPACE:-$PWD}

exec docker-compose run --rm -v "$WORKSPACE:/workspace" "$ENV" "$@"
