IMAGE_NAME ?= cohortextractor
PYTHON_VERSION ?= python3.8
VIRTUAL_ENV ?= venv
BIN = $(VIRTUAL_ENV)/bin


.PHONY: prodenv
prodenv: requirements.prod.txt
	$(BIN)/pip install -r requirements.prod.txt


.PHONY: devenv
devenv: requirements.dev.txt prodenv
	$(BIN)/pip install -r requirements.dev.txt


# combine setup.py and requirements.prod.in
requirements.prod.txt: setup.py requirements.prod.in $(BIN)/pip-compile
	$(VIRTUAL_ENV)/bin/pip-compile setup.py --extra drivers requirements.prod.in -o requirements.prod.txt


requirements.dev.txt: requirements.dev.in requirements.prod.txt $(BIN)/pip-compile
	$(VIRTUAL_ENV)/bin/pip-compile requirements.dev.in


# ensure we have pip-tools so we can run pip-compile to boostrap env
$(BIN)/pip-compile: | $(VIRTUAL_ENV)
	$(BIN)/pip install pip-tools


# create venv if needed
$(VIRTUAL_ENV):
	$(PYTHON_VERSION) -m venv $(VIRTUAL_ENV) && $(BIN)/pip install --upgrade pip


# build the production docker image
.PHONY: build
docker-build: export BUILD_DATE=$(shell date +'%y-%m-%dT%H:%M:%S.%3NZ')
docker-build: export GITREF=$(shell git rev-parse --short HEAD)
docker-build: export DOCKER_BUILDKIT=1
docker-build: ENV=dev
docker-build:
	docker-compose build $(ARGS) $(ENV)



.PHONY: lint
docker-lint:
	@docker pull hadolint/hadolint
	@docker run --rm -i hadolint/hadolint < Dockerfile
