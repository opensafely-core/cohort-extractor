*! version 1.1.2  13feb2015
program checkestimationsample
	version 10

	syntax [, EXTRA(varlist)]

	if (`"`e(wexp)'"'!="") {
		local wvar = strtrim(usubstr(strtrim(`"`e(wexp)'"'), 2, .))
		capture confirm var `wvar'
		if _rc {
			tempvar wvar 
			qui gen float `wvar' `e(wexp)' if e(sample)
		}
	}

	qui _datasignature `e(datasignaturevars)' `wvar' `extra', ///
					esample nodefault nonames
	if (r(datasignature)!=e(datasignature)) {
		di as err "data have changed since estimation"
		exit 459
	}
end
exit
/*
	see signestimationsample.ado for notes concerning option -extra()-
*/
