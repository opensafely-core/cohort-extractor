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

At the moment, this involves writing some simple Python code. We plan
to make this much simpler over the next few weeks.

*covariate definition howto goes here*

## Generating dummy data

To generate dummy data from the dummy dataset:

* Set credential somehow **XXX**
* If on Windows, double-click `run.exe`, and follow the instructions

This will use your covariate definitions to generate a file for your model at `analysis/input.csv`

You can now use Stata as you usually would, with your code entrypoint
in `analysis/model.do`.

## Running the model against data

* Set the environment to point at the SQL Server (see `.env-example`) - either the public dummy data one, or the real one (accessible only inside TPP secure environment)
  * `GITHUB_ACTOR` and `GITHUB_TOKEN` are a username and token with package repo read rights. Generate your own from Settings > Developer
* Run `run.py generate_cohort` to generate the cohort
* Run `run.py run` to run the model. Its output is streamed to stdout, and saved in `model.log`

# For developers

## Run tests

* Start an mssql server with `docker-compose up`
* Set up a virtualenv and `pip install -r requirements.txt`
* `py.test tests/`

Note: until we make this cleaner... if you change the database schema
be sure to `docker rm stata-docker_sql_1` before restarting.
