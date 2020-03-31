*! version 1.0.0  21may2015

program define nl_ivfprobit_cov_eval
	version 14.0
	syntax varlist(min=1 max=1) [if], at(name) tau2(string) ///
		tau2i(string) b(string)

	tempname eta theta rho R b1 b2 a1 a2

	local r : word 1 of `varlist'
	qui replace `r' = 0 `if'

	local k = colsof(`at')
	local ke = rowsof(`tau2')
	local kb = colsof(`b')
	local i1 = `kb' + 1
	if `kb' {
		mat `a1' = `at'[1,1..`kb']'	// exog/endog coef
	}
	mat `a2' = `at'[1,`i1'..`k']'		// corr(depvar,resid)
	forvalues i=1/`ke' {
		mat `a2'[`i',1] = tanh(`a2'[`i',1])
	}

	mat `eta' = cholesky(diag(vecdiag(`tau2')))*`a2' // cov(depar,resid)
	mat `theta' = `tau2i'*`eta'
	mat `R' = I(1)-`eta''*`theta'
	/* rho = var(eps)						*/
	scalar `rho' = `R'[1,1]
	if `rho' <= 0 {
		/* not positive definite				*/
		qui replace `r' = . `if'
		exit
	}
	scalar `rho' = sqrt(`rho')	// scale
	if `kb' {
		mata: st_store((1::`kb'),"`r'",st_matrix("`a1'"):/ ///
			st_numscalar("`rho'"))
	}
	mata: st_store(`i1'::`k',"`r'",st_matrix("`theta'"):/ ///
		st_numscalar("`rho'"))
end

exit
