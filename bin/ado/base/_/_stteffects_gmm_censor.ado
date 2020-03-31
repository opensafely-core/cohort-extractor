*! version 1.0.0  12jan2015

program define _stteffects_gmm_censor, rclass
	version 14.0
	syntax varlist(numeric) [if], dist(string) b(name) to(passthru) ///
		do(varname) surv(name) [ dsurv(string) deriv(varlist) ]

	tempvar co ti xb zg d1 d2

	local bderiv = ("`deriv'"!="")
	local expo = ("`dist'"=="exponential")
	qui gen byte `co' = 1-`do' `if'
	qui gen byte `ti' = 1 `if'

	local eqs : coleq `b'
	local eqs : list uniq eqs

	qui gen double `surv' = .
	if `bderiv' {
		/* two derivatives if not exponential			*/
		gettoken dsurvc dsurva : dsurv
		tempvar d1
		/* d1 not used here					*/
		qui gen double `d1' = .
		/* dsurv = dsurv/dcm					*/
		qui gen double `dsurvc' = .
		/* dCM/dcm 						*/
		_stteffects_gmm_var `deriv', eqs(`eqs') req(CME) ceq(CME)
		local dcm_cm `r(varname)'

		local dlist `d1' `dsurvc'
	}
	mat score double `xb' = `b' `if', eq(CME)
	_stteffects_gmm_var `varlist', eq(CME) eqs(`eqs')
	local s `r(varname)'
	local slist `s'
	if `expo' {
		if `bderiv' {
			local dlist `dlist' `dcm_cm'
		}
		_stteffects_exponential_moments `surv' `s' `if', xb(`xb') ///
			ti(`ti') `to' do(`co') deriv(`dlist')
	}
	else {
		mat score double `zg' = `b' `if', eq(CME_lnshape)
		_stteffects_gmm_var `varlist', eq(CME_lnshape) eqs(`eqs')
		local sa `r(varname)'
		local slist `slist' `sa'
		if `bderiv' {
			/* dsurv/dcma					*/
			qui gen double `dsurva' = .
			/* dCM/dcma					*/
			_stteffects_gmm_var `deriv', eqs(`eqs') req(CME) ///
				ceq(CME_lnshape)
			local dcm_cma `r(varname)'
			/* dCMA/dcm					*/
			_stteffects_gmm_var `deriv', eqs(`eqs') ///
				req(CME_lnshape) ceq(CME)
			local dcma_cm `r(varname)'
			/* dCMA/dcma					*/
			_stteffects_gmm_var `deriv', eqs(`eqs') ///
				req(CME_lnshape) ceq(CME_lnshape)
			local dcma_cma `r(varname)'

			local dlist `dlist' `dsurva' `dcm_cm' `dcm_cma'
			local dlist `dlist' `dcma_cm' `dcma_cma'
		}
		_stteffects_`dist'_moments `surv' `s' `sa' `if', xb(`xb') ///
			zg(`zg') ti(`ti') `to' do(`co') deriv(`dlist')
	}
	return local varlist `slist'
end

exit
