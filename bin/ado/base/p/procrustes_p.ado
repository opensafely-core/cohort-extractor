*! version 1.0.2  16jan2019
program procrustes_p
	version 8

	if "`e(cmd)'" != "procrustes" {
		error 301
	}

// retrieve estimation results

	tempname A b c rho
	
	matrix `A'   = e(A)
	matrix `c'   = e(c)
	scalar `rho' = e(rho)

	local ylist `e(ylist)'
	confirm numeric variable `ylist'
	
	local xlist `e(xlist)'
	confirm numeric variable `xlist'

// parse

	syntax anything(name=newvarlist id=newvarlist) [if] [in] [, ///
							FITted RESiduals Q ]

	local opts `fitted' `q' `residuals'
	local nopt : list sizeof opts
	opts_exclusive "`opts'"
	local star "*"
	if `nopt' == 0 {
		local star
		local fitted fitted
	}

	local na   = colsof(`A') // number of yvars
	capture _stubstar2names `newvarlist', nvars(`na') singleok
	if c(rc) {
		if c(rc) == 102 & "`q'" != "" {
			dis as err "one new variable expected"
			exit 103
		}
		else if c(rc) == 102 | c(rc) == 103 {
			local nvar : list sizeof newvarlist
			dis as err "`na' new variables expected, `nvar' found"
			exit = c(rc)
		}
		else {	// rerun to get error message
			_stubstar2names `newvarlist', nvars(`na') singleok
		}
	}
	local varlist `s(varlist)'
	local typlist `s(typlist)'
	local nvar : list sizeof varlist

	if "`fitted'" != "" | "`residuals'" != "" {
		if `nvar' != `na' {
			dis as err "`na' new variables expected, `nvar' found"
			exit =cond(`na'>`nvar',102,103)
		}
	}
	
	if "`q'" != "" {
		if `nvar' != 1 {
			dis as err "one new variable expected"
			exit 103
		}
	}

	`star' dis as txt "(option {bf:fitted} assumed; fitted values)"

// create variables

	marksample touse, novarlist

	local outvar `varlist'
	local outtp  `typlist'

	tempname yhat
	if "`q'" != "" {
		gen `typlist' `varlist' = 0 if `touse'
		label var `varlist' "procrustes: rss"
	}
	
	forvalues iy = 1 / `na' {
		gettoken y  ylist : ylist

		capture drop `yhat'
		matrix `b' = `A'[1...,`iy']'
		matrix score double `yhat' = `b' if `touse'
		quietly replace `yhat' = `rho'*`yhat'  + `c'[1,`iy'] if `touse'

		if "`fitted'" != "" {
			gettoken v  varlist : varlist
			gettoken tp typlist : typlist

			quietly gen `tp' `v' = `yhat'
			label var `v' "procrustes: approx `y'"
		}
		
		else if "`residuals'" != "" {
			gettoken v  varlist : varlist
			gettoken tp typlist : typlist

			quietly gen `tp' `v' = `y' - `yhat'
			label var `v' "procrustes: residual `y'"
		}
		
		else if "`q'" != "" {
			quietly replace `varlist' = `varlist' + (`y'-`yhat')^2
		}
		
		else {
			_stata_internalerror
		}
	}

// missing value messages

	foreach v of local outvar {
		quietly count if missing(`vt')
		local n = r(N)
		if `n' > 0 {
			dis as txt "(`v': `n' " /// 
			    plural(`n',"missing value") " generated)"
		}
	}
end
exit
