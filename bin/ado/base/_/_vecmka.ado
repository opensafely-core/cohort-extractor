*! version 1.0.3  18jun2004
program define _vecmka
	version 8.2

	args A

	tempname  b pi pi0 g0
	

	_ckvec _vecmka

	mat `b' = e(b)

	local rank = e(k_ce)
	local pm1  = e(n_lags) -1
	local k    = e(k_eq)
	local trend "`e(trend)'"

	mat `pi0' = e(pi)

// in rconstant and rtrend must skip over _cons or _trend term in e(pi)
	if "`trend'" == "rconstant" | "`trend'" == "rtrend" {
		local k1 = `k' + 1
	}
	else {
		local k1 = `k' 
	}

	local j 1
	forvalues i=1/`k' {
		mat `pi' = (nullmat(`pi') \ `pi0'[1,`j'..(`j'+`k'-1)]    )
		local j = 1 + `i'*`k1'
	}

	forvalues i=1/`pm1' {
		tempname g`i'
		local gilist `gilist' `g`i''
	}

	_vecmkgam , g(`g0') b(`b') rank(`rank') trend(`trend')	///
		pm1(`pm1') gilist(`gilist') k(`k')

	if `pm1' > 0 {
		mat `A'1 = `pi' + `g1' + I(`k')
	
		forvalues i = 2/`pm1' {
			local im1 = `i' - 1
			mat `A'`i' = `g`i'' - `g`im1''
		}

		local p = `pm1' + 1
		mat `A'`p' = -1*`g`pm1''
	}	
	else {
		mat `A'1 = `pi' +  I(`k')

	}


end	

exit

This program calculates the A1, .. Ap matrices for the VAR from of an
estimated VECM.  The matrices are stored as `A'1, ... 
where the original name A is passed in to the program.

