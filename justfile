# just has no idiom for setting a default value for an environment variable
# so we shell out, as we need VIRTUAL_ENV in the justfile environment
export VIRTUAL_ENV  := `echo ${VIRTUAL_ENV:-.venv}`

export BIN := VIRTUAL_ENV + if os_family() == "unix" { "/bin" } else { "/Scripts" }
export PIP := BIN + if os_family() == "unix" { "/python -m pip" } else { "/python.exe -m pip" }

export DEFAULT_PYTHON := if os_family() == "unix" { "python3.8" } else { "python" }
export IMAGE_NAME ?= cohortextractor



# list available commands
default:
    @"{{ just_executable() }}" --list


# clean up temporary files
clean:
    rm -rf .venv


# ensure valid virtualenv
virtualenv:
    #!/usr/bin/env bash
    set -euo pipefail

    # allow users to specify python version in .env
    PYTHON_VERSION=${PYTHON_VERSION:-$DEFAULT_PYTHON}

    # create venv and upgrade pip
    test -d $VIRTUAL_ENV || { $PYTHON_VERSION -m venv $VIRTUAL_ENV && $PIP install --upgrade pip; }

    # ensure we have pip-tools so we can run pip-compile
    test -e $BIN/pip-compile || $PIP install pip-tools


_compile src dst *args: virtualenv
    #!/usr/bin/env bash
    set -euo pipefail

    # exit if src file is older than dst file (-nt = 'newer than', but we negate with || to avoid error exit code)
    test "${FORCE:-}" = "true" -o {{ src }} -nt {{ dst }} || exit 0
    $BIN/pip-compile --allow-unsafe --output-file={{ dst }} {{ src }} {{ args }}


# update requirements.prod.txt if requirements.prod.in has changed
requirements-prod *args:
    "{{ just_executable() }}" _compile setup.py --extra drivers -o requirements.prod.txt {{ args }}


# update requirements.dev.txt if requirements.dev.in has changed
requirements-dev *args: requirements-prod
    "{{ just_executable() }}" _compile requirements.dev.in requirements.dev.txt {{ args }}


# ensure prod requirements installed and up to date
prodenv: requirements-prod
    #!/usr/bin/env bash
    set -euo pipefail

    # exit if .txt file has not changed since we installed them (-nt == "newer than', but we negate with || to avoid error exit code)
    test requirements.prod.txt -nt $VIRTUAL_ENV/.prod || exit 0

    $PIP install -r requirements.prod.txt
    touch $VIRTUAL_ENV/.prod


# && dependencies are run after the recipe has run. Needs just>=0.9.9. This is
# a killer feature over Makefiles.
#
# ensure dev requirements installed and up to date
devenv: prodenv requirements-dev && install-precommit
    #!/usr/bin/env bash
    set -euo pipefail

    # exit if .txt file has not changed since we installed them (-nt == "newer than', but we negate with || to avoid error exit code)
    test requirements.dev.txt -nt $VIRTUAL_ENV/.dev || exit 0

    $PIP install -r requirements.dev.txt
    touch $VIRTUAL_ENV/.dev


# ensure precommit is installed
install-precommit:
    #!/usr/bin/env bash
    set -euo pipefail

    BASE_DIR=$(git rev-parse --show-toplevel)
    test -f $BASE_DIR/.git/hooks/pre-commit || $BIN/pre-commit install


# upgrade dev or prod dependencies (specify package to upgrade single package, all by default)
upgrade env package="": virtualenv
    #!/usr/bin/env bash
    set -euo pipefail

    opts="--upgrade"
    test -z "{{ package }}" || opts="--upgrade-package {{ package }}"
    FORCE=true "{{ just_executable() }}" requirements-{{ env }} $opts


# build the production Docker image
docker-build:
    export BUILD_DATE=$(shell date +'%y-%m-%dT%H:%M:%S.%3NZ')
    export REVISION=$(shell git rev-parse --short HEAD)
    export VERSION=$(shell git describe --tags)
    export DOCKER_BUILDKIT=1
    ENV=dev docker-compose build --pull $(ARGS) $(ENV)


# lint the Docker image
docker-lint:
    docker pull hadolint/hadolint
    docker run --rm -i hadolint/hadolint < Dockerfile


# *args is variadic, 0 or more. This allows us to do `just test -k match`, for example.
# Run the tests
test *args="tests": devenv
    $BIN/python -m pytest {{ args }}

black *args=".": devenv
    $BIN/black --check {{ args }}

ruff *args=".": devenv
    $BIN/ruff check {{ args }}

# run the various dev checks but does not change any files
check: black ruff


# fix formatting and import sort ordering
fix: devenv
    $BIN/black .
    $BIN/ruff --fix .


# Run the dev project
run: devenv
    echo "Not implemented yet"
