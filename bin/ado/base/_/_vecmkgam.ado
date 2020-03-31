*! version 1.0.0  16jul2004
program define _vecmkgam 
	version 8.2

	syntax , 			///
		g(name)			///
		b(name)			///
		rank(integer)		///
		trend(string)		///	
		pm1(integer)		///
		k(integer)		///
		[			///
		gilist(string)		///
		]


	if "`gilist'" != "" {
		local ngi : word count `gilist'
		if `ngi' != `pm1' {
			di as err "incorrect number of names for Gamma " ///
				"matrices specified"
			exit 498
		}	

		forvalues i = 1/`pm1' {
			local G`i' : word `i' of `gilist'
			capture confirm name `G`i''
			if _rc > 0 {
				di as err "name `i' in gilist(`gilist') " ///
					is not a Stata name"
				exit 498
			}	
			mat `G`i'' = J(`k', `k', .)
		}
	}
	else {
		forvalues i = 1/`pm1' {
			tempname G`i'
			mat `G`i'' = J(`k', `k', .)
		}
	}

	local nt = -1

	if "`trend'" == "none" | "`trend'" == "rconstant" {
		local nt 0
	}

	if "`trend'" == "constant" | "`trend'" == "rtrend" {
		local nt 1
	}
	
	if "`trend'" == "trend" {
		local nt 2
	}

	if `nt' < 0 {
		di as err "error in trend specification, cannot "	///
			"compute Gamma_i"
		exit 498
	}

//  This loop extracts the Gamma_i from the short-run parameter estimates 
//  in e(b) which is passed in as b

	local tpereq = `rank' + `k'*`pm1' + `nt'

	forvalues i1 = 1/`k' {
		forvalues i2 = 1/`k' {
			forvalues i3 = 1/`pm1' {
mat `G`i3''[`i1',`i2'] = `b'[1,(`i1'-1)*`tpereq'+`rank'+ (`i2'-1)*`pm1' + `i3' ]
			}
		}
	}

	mat `g' = I(`k')
	
	forvalues i = 1/`pm1' {
		mat `g' = `g' - `G`i'' 
	}
end

exit 

This program makes the Gamma_i matrix and the Gamma matrix and saves them
in the names that were passed in via the options g()--for Gamma--, and
gilist()--for the Gamma_i--.
