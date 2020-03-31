*! version 1.0.1  17jan2019
program _polasso_gmm_pois
	version 16.0

	syntax varlist if , 		///
		at(name) 		///
		depvar(string)		///
		tt_vars(string)		///
		xbvar(string)		///
		[derivatives(varlist) ]
	
	tempvar xb
	qui matrix score double `xb' = `at' `if' 

	tempvar mu
	qui gen double `mu' = exp(`xb' + `xbvar') `if'

	qui replace `varlist' = `depvar' - `mu' `if'

	if (`"`derivatives'"' == "") {
		exit
		// NotReached
	}

	qui replace `derivatives' = -`mu' `if'
end
