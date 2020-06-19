# For statisticians

The OpenSAFELY framework is a new secure analytics platform for
electronic health records research in the NHS.

Instead of requesting access for slices of patient data and
transporting them elsewhere for analysis, the framework supports
developing analytics against dummy data, and then running against the
real data *within the same infrastructure that the data is stored*.
Read more at [OpenSAFELY.org](https://opensafely.org).

The framework is under fast, active development to support rapid
analytics relating to COVID19; we're currently seeking funding to make
it easier for outside collaborators to work with our system.  Until
then, be warned that these instructions are preliminary, you will
almost certainly need more support from the OpenSAFELY team to get
running, and the framework API is changing quickly.  In other words,
if you'd like to work with us at this stage, get in touch before
writing too much code.

Currently there is a single backend implemented for the data, for
running analytics against TPP SystmOne records.  Other backends are
under development.

This repository contains everything needed to:

* Define a set of covariates needed for your model
* Generate an input dataset from dummy data against which you can develop your model
* Request that the model be run against the live data

You will need access to a dummy dataset to do this; get in touch to
request credentials.  Our first analyses are with Stata - you will,
therefore, also need a licenced copy of Stata (see below for
information about the Docker version)

Until we have developed a deployment framework, you should use this
repository as a *template* when you create a new Github Repo.  When
you do so, for the automated tests to run, you should also add two
*Secrets* to the settings for your repo:

 * `DOCKER_GITHUB_TOKEN`: a token generated using your Github account (see instructions in "Running the model against real data", below)

The entrypoint of your model **must** be called `model.do` and it must
live in the `analysis/` folder.

Your model **must** start by importing the dataset, which will be called
`input.csv` and be in the same folder.

For portability, the recommended way of starting your model is:

```stata
import delimited `c(pwd)'/analysis/input.csv
```

## Defining covariates

At the moment, this involves writing some simple Python code.

This must live in a file at `analysis/study_definition.py` (or
`analysis/study_definition_<name>.py` if you have multiple studies).
Documentation is at https://github.com/opensafely/documentation/blob/master/study_definition.md.
You can also refer to the sample one provided in this repo
for inspiration; or, if you're feeling adventurous, search the
tests (in `tests/`) for `StudyDefinition` examples.

## Generating dummy data

To generate dummy data, install the `opensafely-cohort-extractor` package:

     pip install --upgrade "git+ssh://git@github.com/ebmdatalab/opensafely-research-template.git@eggify#egg=opensafely-cohort-extractor"

This will install the `cohort-extractor` script.

Run it from the root of your study repo:

    cohort-extractor generate_cohort --expectations-population=10000

If you don't have Python installed, you can always wait for Github
Actions to generate a dummy `input.csv` after each push.

To generate a cohort from a TPP-compliant backend from the command
line, you'll want to install [this ODBC driver from
Microsoft](https://www.microsoft.com/en-us/download/details.aspx?id=56567)

You need to obtain the "database URL", which includes a username and
password.  When running outside the secure environment, obtain a URL
that gives you access to the publicly-available dummy dataset.

    cohort-extractor generate_cohort --database-url='mssql+odbc://username:password@host:port/database?driver=ODBC+Driver+17+for+SQL+Server'

If you have multiple study definitions named like
`analysis/study_definition_<name>.py` then the corresponding output
files will be named `workdir/input_<name>.csv`.

You can now copy the CSV to analysis, and use Stata as you usually
would, with your code entrypoint in `analysis/model.do`.

## Running the model

There are two ways to run your model:

* Directly in your usual development environment. For example, if you
  have Stata installed locally, just open `model.do` and run as normal
* Via a docker image

We use the Github Docker package repository, so you'll need to add a
Personal Access Token with permissions to read packages. visit your
personal Github "settings" page, find the *Developer > Developer
Settings > Personal Access Tokens*, and add a token there (any name
will do) with the permission `read:packages`. Take a note of the token
(you only get a chance to see it once!).

Now run

    docker login docker.pkg.github.com -u <YourGithubUsername> --password <PersonalAccessToken>

You can check this worked by running

    docker pull docker.pkg.github.com/opensafely/stata-docker/stata-mp:latest

And you can run it with

    docker run --mount source=$(pwd),dst=/workspace,type=bind stata-mp analysis/model.do

# For developers

## Run tests

You can run everything in docker with `./run_tests.sh`.

You can also run the tests in your own virtualenv, but either way you
will (probably) still want to use docker to run a SQL Server instance:


* Start an mssql server with `docker-compose up`
* Set up a virtualenv and `pip install -r requirements.txt`
* `py.test tests/`

Note: until we make this cleaner... if you change the database schema
be sure to `docker rm stata-docker_sql_1` before restarting.

## Rebuild run.exe

If you need to make a new release of `run.exe`, then bump
`cohortextractor/VERSION` (using the semver standard), and the Github Actions
workflow `windows_build_and_release.yaml` should take care of the
rest.
