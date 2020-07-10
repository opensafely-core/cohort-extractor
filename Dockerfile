FROM ubuntu:bionic

# PYTHON_VERSION can be changed, by passing `--build-arg
# PYTHON_VERSION=<new version>` during docker build
ARG PYTHON_VERSION=3.7.8
ENV PYTHON_VERSION=${PYTHON_VERSION}

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV UBUNTU_VERSION $ubuntuversion
RUN apt-get update
RUN apt-get -y upgrade

# Python dependencies
RUN apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
# Pyenv dependencies
RUN apt-get install -y ca-certificates git

# Install pyenv
RUN curl https://pyenv.run | bash
ENV PATH="/root/.pyenv/shims:/root/.pyenv/bin:${PATH}"
ENV PYENV_SHELL=bash

# Install python
RUN pyenv install $PYTHON_VERSION
RUN pyenv global $PYTHON_VERSION

# Install mssql
RUN apt-get install -y gnupg
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN ACCEPT_EULA=Y apt-get install -y mssql-tools
ENV PATH=$PATH:/opt/mssql-tools/bin

RUN mkdir /workspace
RUN mkdir /app
WORKDIR /app

# Install pip and requirements
COPY requirements.txt /app
# Extra dependencies needed by python packages
RUN apt-get install -y unixodbc-dev
RUN curl https://bootstrap.pypa.io/get-pip.py | python
RUN pip install --requirement requirements.txt

COPY . /app

# .python-version is not needed but can make its way into the image when built
# locally
RUN rm -f .python-version
RUN python setup.py develop
RUN pyenv rehash

WORKDIR /workspace

ENTRYPOINT ["cohortextractor"]
