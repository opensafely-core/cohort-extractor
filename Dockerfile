# syntax=docker/dockerfile:1.2
#################################################
#
# Initial cohortextractor layer with just system dependencies installed.
#
# hadolint ignore=DL3007
FROM ghcr.io/opensafely-core/base-action:latest as cohortextractor-dependencies

# setup default env vars for all images
# ACTION_EXEC sets the default executable for the entrypoint in the base-action image
ENV VIRTUAL_ENV=/opt/venv/ \
    PATH="/opt/venv/bin:/opt/mssql-tools/bin:$PATH" \
    ACTION_EXEC=cohortextractor \
    PYTHONUNBUFFERED=True \
    PYTHONDONTWRITEBYTECODE=1

RUN mkdir /workspace
WORKDIR /workspace
VOLUME /workspace

# We are going to use an apt cache on the host, so disable the default debian
# docker clean up that deletes that cache on every apt install
RUN rm -f /etc/apt/apt.conf.d/docker-clean

# Using apt-helper means we don't need to install curl or gpg
RUN /usr/lib/apt/apt-helper download-file https://packages.microsoft.com/keys/microsoft.asc /etc/apt/trusted.gpg.d/microsoft.asc && \
    /usr/lib/apt/apt-helper download-file https://packages.microsoft.com/config/ubuntu/20.04/prod.list /etc/apt/sources.list.d/mssql-release.list

COPY dependencies.txt /root/dependencies.txt
# use space efficient utility from base image
RUN --mount=type=cache,target=/var/cache/apt \
    /usr/bin/env ACCEPT_EULA=Y /root/docker-apt-install.sh /root/dependencies.txt

#################################################
#
# Next, use the dependencies image to create an image to build dependencies
FROM cohortextractor-dependencies as cohortextractor-builder

# install build time dependencies
COPY build-dependencies.txt /root/build-dependencies.txt
RUN /root/docker-apt-install.sh /root/build-dependencies.txt

# install everything in venv for isolation from system python libraries
# hadolint ignore=DL3013,DL3042
RUN --mount=type=cache,target=/root/.cache \
    /usr/bin/python3 -m venv /opt/venv && \
    /opt/venv/bin/python -m pip install -U pip setuptools wheel

COPY requirements.prod.txt /root/requirements.prod.txt
# hadolint ignore=DL3042
RUN --mount=type=cache,target=/root/.cache python -m pip install -r /root/requirements.prod.txt

# WARNING clever/ugly hack alert:
#
# We could just do `COPY . /app` and install from there. But if we do, any
# changes to app files will invalidate this and all subsequent layers, causing
# them to need rebuilding. This would mean basically reinstalling dev
# dependencies every time.
#
# To avoid this, we just copy the setup.py file, and use that to install the
# package as an editable package, without  deps. This does two things:
#
# 1. Sets up `cohortextractor` entrypoint in `/opt/venv/bin/`
# 2. Sets up a `.egg-link` file in `/opt/venv/lib/site-packages` that will load
#    cohortextractor from /app.
#
# This means we can later populate /app with the actual code (via copying or
# mounting), and it will already be plugged in to the virtualenv and ready to
# go.

RUN mkdir /app
COPY setup.py /app/setup.py
# hadolint ignore=DL3042
RUN python -m pip install --no-deps --editable /app


################################################
#
# A base image with the including the prepared venv and metadata.
FROM cohortextractor-dependencies as cohortextractor-base

# Some static metadata for this specific image, as defined by:
# https://github.com/opencontainers/image-spec/blob/master/annotations.md#pre-defined-annotation-keys
# The org.opensafely.action label is used by the jobrunner to indicate this is
# an approved action image to run.
LABEL org.opencontainers.image.title="cohortextractor" \
      org.opencontainers.image.description="Cohortextractor action for opensafely.org" \
      org.opencontainers.image.source="https://github.com/opensafely-core/cohortextractor" \
      org.opensafely.action="cohortextractor"

COPY --from=cohortextractor-builder /opt/venv /opt/venv


################################################
#
# Build the actual production image from the base
FROM cohortextractor-base as cohortextractor

# copy app code. This will be automatically picked up by the virtual env as per
# comment above
COPY . /app

# We run `cohortextractor --help` as a basic test, and to force dependencies to
# import because the first time we import matplotlib we get a "generated new
# fontManager" message and we want to trigger that now rather than every time
# we run the docker image
RUN cohortextractor --help


################################################
#
# Development image that includes test dependencies and mounts the code in
FROM cohortextractor-base as cohortextractor-dev

# Install dev dependencies
COPY requirements.dev.txt /root/requirements.dev.txt
# hadolint ignore=DL3042
RUN --mount=type=cache,target=/root/.cache python -m pip install -r /root/requirements.dev.txt

# the code is intended to be mounted in to /app
VOLUME /app
