*! version 1.0.5  13may2019
program webgetsem
	args semfile dtafile

	local version = strofreal(floor(c(stata_version)))
	local path = "http://www.stata-press.com/data/r`version'"

	if `"`dtafile'"' != `""' {
		capture use `"`path'/`dtafile'"'
		if _rc == 4 {
			di as error					///
			  `"cannot use `dtafile', data in memory would be lost"'
		}
		else if _rc == 601 {
			di as error `"file `path'/`dtafile' not found"'
		}
		else if _rc {
			use `"`path'/`dtafile'"'
		}

		if _rc {
			exit _rc
		}
	}

	if (strpos(".", `"`semfile'"')) {
		local fn `"`semfile'"'
	}
	else	local fn `semfile'.stsem

	capture confirm new file `"`fn'"'

	if _rc {
		tempfile fn
	}

	capture copy `"`path'/`semfile'"' `"`fn'"'
	if _rc {
		capture copy `"`path'/`semfile'.stsem"' `"`fn'"'
	}

	if _rc {
		di as error `"SEM file `semfile' not found in examples"'
		local rc = _rc

		window stopbox note `"SEM file `semfile' not found in examples"'
	}
	else	sembuilder `"`fn'"'

	sleep 500

	if 0`rc' {
		exit `rc'
	}
	else	erase `"`fn'"'

end
