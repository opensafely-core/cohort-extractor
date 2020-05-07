# Codelists

Codelists are hosted at [codelists.opensafely.org](https://codelists.opensafely.org).

To fetch all the codelists identified in `codelists.txt`, and store them in this repository (in the `codelists/` folder), run `run update_codelists`.

As such, codelists should not be added or edited by hand.  Instead:

* Go to [the openSAFELY codelists admin](https://codelists.opensafely.org/admin) (you will need an editor account)
* Create or update the codelist.
  * Copy/paste the CSV data into the `csv_data field`
  * Set the `version_str` to today's date in `YYYY-MM-DD`
  * Click "Save"
* Update `codelists/codelists.txt`
* From the root of this repo, run `python run.py update_codelists`
* Check the git diff for sense
* Commit the changes and make a PR
