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
Until more documentation is written, refer to the sample one provided
here for inspiration; or, if you're feeling adventurous, search the
tests (in `tests/`) for `StudyDefinition` examples.

## Generating dummy data

### On Windows
You'll want to install a couple of things:

* [This ODBC driver from Microsoft](https://www.microsoft.com/en-us/download/details.aspx?id=56567)
* The latest `run.exe` from [here](https://github.com/ebmdatalab/opensafely-research-template/releases/latest)
  * This must be copied to and run from the root folder of your research repository
  * Note that if you're testing a new branch with new `runner` functionality, you'll need to download the latest `run.exe` that is *tagged with that branch name* from the **Releases** section of github

You need to obtain the "database URL", which includes a username and
password.  When running outside the secure environment, obtain a URL
that gives you access to the publicly-available dummy dataset.

Now double-click `run.exe`, and it will use your covariate definitions
in `analysis/study_definition.py` to generate a data file at `analysis/input.csv`.

If you have multiple study definitions named like
`analysis/study_definition_<name>.py` then the corresponding output
files will be named `analysis/input_<name>.csv`.

You can now use Stata as you usually would, with your code entrypoint
in `analysis/model.do`.

### Using plain python

* Install ODBC Driver 17 for SQL Server for your platform
* Set up a Python 3.8 virtual environment
* `pip install -r requirements.txt`
* `python run.py --help`

## Running the model

There are three ways to run your model:

* Directly in your usual development environent. For example, if you have Stata installed locally, just open `model.do` and run as normal
* Via the runner tool:
   * Select the `run` option and tell it where your Stata application is
   * Leave the Stata location blank, and the tool will attempt to use Docker to run the model

For the last option, you will need to provide docker with credentials
to access the Docker version of Stata. It's password-protected as it
includes licensed software -- if you are a third party outside the
OpenSAFELY collaborative, you'll need to purchase your own Stata
licence, and we will help you set up your own docker version.

We use the Github Docker package repository, so you'll need to add a
Personal Access Token with permissions to read packages. visit your
personal Github "settings" page, find the *Developer > Developer
Settings > Personal Access Tokens*, and add a token there (any name
will do) with the permission `read:packages`. Take a note of the token
(you only get a chance to see it once!).

Now run

    docker login docker.pkg.github.com -u <YourGithubUsername> --password <PersonalAccessToken>

You can check this worked by running

    docker pull docker.pkg.github.com/ebmdatalab/stata-docker-runner/stata-mp:latest

* Run `run.py run --analysis` to run the model. Its output is streamed to stdout, and saved in `model.log`

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
`runner/VERSION` (using the semver standard), and the Github Actions
workflow `windows_build_and_release.yaml` should take care of the
rest.
