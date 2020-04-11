# For statisticians

This repository contains everything needed to:

* Define a set of covariates needed for your model
* Generate an input dataset from dummy data against which you can develop your model

You can use it as a *template* when you create a new Github Repo.  When you do so, you should also add two *Secrets* to the settings for your repo:

 * `DOCKER_GITHUB_TOKEN`: a token generated using your Github account (see instructions in "Running the model against real data", below)
 * `DUMMY_DATABASE_URL`: the URL / credentials for the dummy database, which the database manager should share with you (or someone else on the team)

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

This must live in a file at `analysis/study_definition.py`.  Until
more documentation is written, refer to the sample one provided here
for inspiration.

## Generating dummy data

### On Windows
You'll want to install a couple of things:

* [This ODBC driver from Microsoft]( https://www.microsoft.com/en-us/download/details.aspx?id=56567)
* The latest `run.exe` from [here](https://github.com/ebmdatalab/opencorona-research-template/releases)
  * This must be copied to the root folder of your research repository

You need to obtain the "database URL", which includes a username and
password.  When running outside the secure environment, obtain a URL
that gives you access to the publicly-available dummy dataset.

Now double-click `run.exe`, and it will use your covariate definitions
in `analysis/study_definition.py` to generate a data file at `analysis/input.csv`

You can now use Stata as you usually would, with your code entrypoint
in `analysis/model.do`.

### Using docker and the command line

Python 3.8 is assumed:

* Install Docker
* `python run.py generate_cohort --docker --database-url <DATABASE_URL>`

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
to access the Docker version of Stata (it's password-protected as it
includes licensed software).

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

* Start an mssql server with `docker-compose up`
* Set up a virtualenv and `pip install -r requirements.txt`
* `py.test tests/`

Note: until we make this cleaner... if you change the database schema
be sure to `docker rm stata-docker_sql_1` before restarting.
