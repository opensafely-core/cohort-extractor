docker run -it --rm --mount source=$(pwd),dst=/workspace,type=bind stata

Current assumptions:

* Stata analysis must be at /workspace/analysis/model.do
* Data must be at /workspace/analysis/input.csv

TODO

* [ ] Write up the contract and enforce

  - model:
    - must be called `analysis/model.do`
    - it must consume a dataset called `analysis/input.csv`
  - cohort extractor:
    - must consume some kind of definition file (one row per covariate?)
    - must output to `analysis/input.csv`
    - must have a switch to output either the real data or dummy data *and the default should be the dummy data*
    - should be runnable from the command line (maybe packaged in a docker command?)



* [ ] Work out how to run Stata interactively against the same dataset
  - generate data by running a command
    - possibly from their own computer
  - commit dummy data to repo
  - off they go
  -

Questions / next steps:

* Should we provide access to the Stata version from notebooks? Probably not.
  * How can we allow interactive development at the same time as docker-run?
  * Should be possible to launch Stata from within docker?
