*! version 1.0.3  14jul2004
program define _vec_postvar
	version 8.2

	syntax , cmd(string) 		///
		cestname(name) 		///
		cestsmp(name) 		///
		var_est(name)		///
		rmacname(name)		///
		[			///
		ESTimates(string)	///
		usece(varlist)		///
		dfk 			///
		betaiden		///
		]

	if `"`estimates'"' != "" {
		_estimates hold `cestname',  restore  varname(`cestsmp') null
		estimates restore `estimates'
	}
	else {
		_estimates hold `cestname',  restore copy 	///
			varname(`cestsmp') null
	}

	tempvar esamp 
	qui gen byte `esamp' = e(sample)
	qui count if `esamp' > 0
	if r(N) == 0 {
		di as err "e(sample) not found"
		exit 498
	}

	capture noi _ckvec `cmd' 
	local rc = _rc

	if `rc' > 0 {
		c_local `rmacname' 0
		exit `rc'
	}

	local rank = e(k_ce)
	c_local `rmacname' `rank'

	if "`betaiden'" != "" {
		if e(beta_iden) != 1 {
di as err "{p 0 4 4}the parameters in the cointegrating equations "	///
	"were not identified{p_end}"
di as err "{p 4 4 4}`cmd' requires that the parameters in the "	///
	"cointegrating equations be exactly identified or "	///
	"overidentified{p_end}"
exit 498
		}
	}
	
	_vecmktrend if `esamp'

	local mlag = `e(n_lags)' - 1
	if `mlag' >=1 {
		local lagsm " lags(1/`mlag') "
	}
	else {
		local lagsm 
	}

	forvalues i = 1/`rank' {
		local cevars `cevars' L._ce`i'
	}

	if "`usece'" == "" {
		_vecmkce , allowdrop
	}
	else {
		local cnt 1
		foreach vn of local usece {
			gen double _ce`cnt' = `vn'
			local ++cnt
		}
	}


	local endog `e(endog)'
	tsunab endog : D.( `endog' ) 

	local exog  `cevars'

	if "`e(trend)'" == "constant"    | 		///
		"`e(trend)'" == "rtrend" |		///
		"`e(trend)'" == "trend"  {
		local constant 
	}	
	else {
		local constant  noconstant
	}

	if "`e(trend)'" == "trend"  {
		local exog `exog' _trend
	}	

	if "`e(aconstraints)'" != "" {
		_vecgetacns
		local cns " constraints($T_VECacnslist) "
	}

	capture qui var `endog' if `esamp' , `lagsm'	///
		exog(`exog') `constant' `cns' `dfk'
	local rc = _rc

	capture constraint drop $T_VECacnslist
	capture macro drop T_VECacnslist
	
	if `rc' > 0 {
		di as err "error computing temporary var estimates"
		exit `rc'
	}
	
	estimates store `var_est'

	
end

exit

This program does four things

	1) it checks that e() currently holds vec results

	2) it gets some information from e() and then creates some helper
	variables, if necessary

	3) it stores the current vec e() results using _estimates under the
	name passed in cestname() saving the esamp with the name passed in as
	cesamp()

	4) it runs the VAR that corresponds to the VECM, conditional on the
	estimated cointegrating equations.

	
