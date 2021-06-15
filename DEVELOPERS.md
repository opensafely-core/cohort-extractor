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
but there's [a full list here](https://github.com/commitizen/conventional-commit-types/blob/master/index.json)
