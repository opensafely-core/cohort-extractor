# OpenSAFELY cohort extractor tool

This tool supports the authoring of OpenSAFELY-compliant research, by:

* Allowing developers to generate random data based on their study
  expectations. They can then use this as input data when developing
  analytic models.
* Supporting downloading of codelist CSVs from the [OpenSAFELY
  codelists repository](https://codelists.opensafely.org/), for
  incorporation into the study definition
* Providing tools to understand and visualise the properties of real
  data, without having direct access to it

It is also the mechanism by which cohorts are extracted from live
database backends within the OpenSAFELY framework.

To install the latest released version:

    pip install --upgrade opensafely-cohort-extractor

To discover its options:

    cohortextractor --help

It is designed to be run within an OpenSAFELY-compliant research
repository. [You can find a template repository to get you started
here](https://github.com/opensafely/research-template).


# For developers

## Run tests

You can run everything in docker with `./run.sh pytest`.

You can also run the tests in your own virtualenv, but either way you
will (probably) still want to use docker to run a SQL Server instance:

* Start an mssql server with `docker-compose up`
* Set up a virtualenv and `pip install -r requirements.txt`
* `py.test tests/`

Note: until we make this cleaner... if you change the database schema
be sure to `docker rm stata-docker_sql_1` before restarting.

## Make releases

To make a release, bump the version in `cohortextractor/VERSION`; Github
Actions should use this to (a) tag the repo accordingly; (b) publish a
new package to pypi; (c) build and publish a new docker image as a
Github Package.

# About the OpenSAFELY framework

The OpenSAFELY framework is a new secure analytics platform for
electronic health records research in the NHS.

Instead of requesting access for slices of patient data and
transporting them elsewhere for analysis, the framework supports
developing analytics against dummy data, and then running against the
real data *within the same infrastructure that the data is stored*.
Read more at [OpenSAFELY.org](https://opensafely.org).

The framework is under fast, active development to support rapid
analytics relating to COVID19; we're currently seeking funding to make
it easier for outside collaborators to work with our system.  You can
read our current roadmap [here](ROADMAP.md).

