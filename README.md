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

The tool has a `remote` subcommand which triggers jobs to be scheduled
to run elsewhere, via a [job
server](https://github.com/opensafely/job-server). If you set the
environment variable `OPENSAFELY_REMOTE_WEBHOOK`, this hook will be
supplied to the job server, which will `POST` a message to that URL
when a job has finished.


# For developers

## Run tests

You can run everything in docker with `./run.sh pytest`.

You can also run the tests in your own virtualenv, but either way you
will (probably) still want to use docker to run a SQL Server instance:

* Start an mssql server with `docker-compose up`
* Set up a virtualenv and `pip install -r requirements.txt`
* `py.test tests/`

Note: if you change the database schema
be sure to `docker-compose stop && docker-compose rm` before re-running
tests to ensure they are recreated.

## Make releases

To make a release, when you merge to the main branch, at least one of
your commits must contain a _conventional commit_ prefixed `fix:`,
`perf:` or `feat:` (patch, patch, and minor releases, respectively);
or a final line starting `BREAKING CHANGE:` (major release).

Other types are ignored, but you might as well use them: `docs`,
`style`, `refactor`, `ci`, `revert` are likely to be the most common,
but there's [a full list
here](https://github.com/commitizen/conventional-commit-types/blob/master/index.json)


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
it easier for outside collaborators to work with our system.
