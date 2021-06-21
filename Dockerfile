FROM ghcr.io/opensafely-core/base-action

RUN \
  apt-get update --fix-missing && \
  apt-get install -y \
    python3.8 python3.8-dev python3-pip git curl unixodbc-dev default-jre-headless && \
  update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Install mssql tools
RUN \
  apt-get install -y gnupg && \
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
  apt-get update && \
  ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
  ACCEPT_EULA=Y apt-get install -y mssql-tools

ENV PATH=$PATH:/opt/mssql-tools/bin

# Copy in app code and install requirements
RUN \
  mkdir /app && \
  mkdir /workspace
COPY . /app

# We have to set this because requirements.txt contains relative path
# references
WORKDIR /app

# We run `cohortextractor --help` at the end to force dependencies to import
# because the first time we import matplotlib we get a "generated new
# fontManager" message and we want to trigger that now rather than every time
# we run the docker image
RUN \
  python -m pip install --upgrade 'pip>=21,<22' && \
  python -m pip install --requirement requirements.txt && \
  cohortextractor --help

WORKDIR /workspace

# It's helpful to see output immediately
ENV PYTHONUNBUFFERED=True

# These are need so that Spark uses the correct version of Python
ENV PYSPARK_PYTHON=/usr/bin/python
ENV PYSPARK_DRIVER_PYTHON=/usr/bin/python

ENTRYPOINT ["cohortextractor"]
