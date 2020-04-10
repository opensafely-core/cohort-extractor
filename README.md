# For statisticians

This repository contains everything needed to:

* Define a set of covariates needed for your model
* Generate an input dataset from dummy data against which you can develop your model

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

On Windows, you'll want to install a couple of things:

* [This ODBC driver from Microsoft]( https://www.microsoft.com/en-us/download/details.aspx?id=56567)
* The latest `run.exe` from [here](https://github.com/ebmdatalab/opencorona-research-template/releases)
  * This must be copied to the root folder of your research repository

You need to obtain the "database URL", which includes a username and password.

Now double-click `run.exe`, and it will use your covariate definitions
in `analysis/study_definition.py` to generate a data file at `analysis/input.csv`

You can now use Stata as you usually would, with your code entrypoint
in `analysis/model.do`.

## Running the model against real data


* Set environment variables:
  * `DATABASE_URL` should point at the SQL Server DNS for the live data (see `.env-example`)
  * `GITHUB_ACTOR` and `GITHUB_TOKEN` are a username and token with
    package repo read rights. Generate your own from Settings >
    Developer. These are needed to run the Stata docker
    container. Alternatively, you can specify a Stata executable
* Run `run.py generate_cohort` to generate the cohort
* Run `run.py run` to run the model. Its output is streamed to stdout, and saved in `model.log`

# For developers

## Run tests

* Start an mssql server with `docker-compose up`
* Set up a virtualenv and `pip install -r requirements.txt`
* `py.test tests/`

Note: until we make this cleaner... if you change the database schema
be sure to `docker rm stata-docker_sql_1` before restarting.
