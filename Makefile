IMAGE_NAME ?= cohortextractor
PYTHON_VERSION ?= python3.8
VIRTUAL_ENV ?= venv
BIN = $(VIRTUAL_ENV)/bin


.PHONY: prodenv
prodenv: $(VIRTUAL_ENV)/prod

.PHONY: devenv
devenv: $(VIRTUAL_ENV)/dev

$(VIRTUAL_ENV)/prod: requirements.prod.txt | $(VIRTUAL_ENV)
	$(BIN)/pip install -r requirements.prod.txt
	touch $@

$(VIRTUAL_ENV)/dev: $(VIRTUAL_ENV)/prod requirements.dev.txt
	$(BIN)/pip install -r requirements.dev.txt
	touch $@


requirements.prod.txt: setup.py
	@# ensure we have pip-compile
	$(MAKE) $(BIN)/pip-compile
	$(VIRTUAL_ENV)/bin/pip-compile setup.py --extra drivers -o requirements.prod.txt


requirements.dev.txt: requirements.dev.in requirements.prod.txt
	@# ensure we have pip-compile
	$(MAKE) $(BIN)/pip-compile
	$(VIRTUAL_ENV)/bin/pip-compile requirements.dev.in


# ensure we have pip-tools so we can run pip-compile to boostrap env
$(BIN)/pip-compile: | $(VIRTUAL_ENV)
	$(BIN)/pip install pip-tools


# create venv if needed
$(VIRTUAL_ENV):
	$(PYTHON_VERSION) -m venv $(VIRTUAL_ENV) && $(BIN)/pip install --upgrade pip


# build the production docker image
.PHONY: docker-build
docker-build: export BUILD_DATE=$(shell date +'%y-%m-%dT%H:%M:%S.%3NZ')
docker-build: export GITREF=$(shell git rev-parse --short HEAD)
docker-build: export DOCKER_BUILDKIT=1
docker-build: ENV=dev
docker-build:
	docker-compose build --pull $(ARGS) $(ENV)



.PHONY: lint
docker-lint:
	@docker pull hadolint/hadolint
	@docker run --rm -i hadolint/hadolint < Dockerfile
