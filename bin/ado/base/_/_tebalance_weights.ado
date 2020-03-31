*! version 1.0.0  03sep2014

program define _tebalance_weights
	syntax newvarname, tu(varname) [ wt(varname) ]

	local wvar `varlist'

	if "`wt'" != "" {
		local wght [fw=`wt']
	}
	local dep `e(depvar)'
	local tvar `e(tvar)'
	local tlev `e(tlevels)'
	/* ivars are variables containing matching indices		*/
	local ivars `e(indexvar)'
	local klev : list sizeof tlev
	local t0 = e(control)
	local t1 = e(treated)
	local att = ("`e(stat)'"=="atet")
	local j0 : list posof "`t0'" in tlev
	local jt : list posof "`t1'" in tlev
	qui gen double `wvar' = .
	if "`e(subcmd)'"=="nnmatch" | "`e(subcmd)'"=="psmatch" {
		mata: _match_postestimates("km","`wvar'","`e(stat)'",        ///
				"`dep'","`tvar'","`e(wtype)'","`wt'","`tu'", ///
				"`ivars'","","",0)
		if (!`att') {
			qui replace `wvar' =  1 + `wvar' if `tu'
		}
	}
	else {
		tempvar p
		foreach lev in `tlev' {
			qui predict double `p' if `tvar'==`lev' & `tu', ///
				ps tlevel(`lev')

			qui replace `wvar' = 1/`p' if `tvar'==`lev' & `tu'
			qui drop `p'
		}
		if (`att') {
			qui predict double `p' if `tu', ps tlevel(`t1')
			qui replace `wvar' = `p'*`wvar' if `tu'
		}
		/* normalize ipw					*/
		summarize `wvar' `wght' if `tu', meanonly
		qui replace `wvar' = `wvar'/r(mean) if `tu'
	}
	if ("`wt'"!="") qui replace `wvar' = `wt'*`wvar' if `tu'
end
exit
