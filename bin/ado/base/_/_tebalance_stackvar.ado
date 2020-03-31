*! version 1.0.1  09apr2015

program define _tebalance_stackvar, rclass
	version 14.0
	syntax, xt(string) xc(string) tu(varname) [ var(string) wt(string) ]

	tempvar x xt0 xc0 xt1 xc1 z wz ww
	tempname mi wi

	local expand = 0
	local wgts = ("`wt'" != "")
	local tvar `e(tvar)'
	local tvlab : value label `tvar'
	if "`tvlab'" != "" {
		local tlab : label `tvlab' `=e(treated)'
		local clab : label `tvlab' `=e(control)'
	}
	else {
		local tlab treated
		local clab control
	}
	local treated = e(treated)
	local control = e(control)
	/* ivars are variables containing matching indices		*/
	local ivars `e(indexvar)'

	/* stacked variables						*/
	if "`var'" == "" {
		if "`e(subcmd)'" != "psmatch" {
			/* programmer error				*/
			di as err "variable required"
			exit 100
		}
		predict double `x', ps tlevel(`treated')
	}
	else {
		fvrevar `var' if `tu'
		local x `r(varlist)'
	}
	if `wgts' {
		local svars `"`xt0' `xc0' `wt' `xt1' `xc1' `wz'"'
	}
	else {
		local svars `"`xt0' `xc0' `xt1' `xc1'"'
	}
	local att = ("`e(stat)'"=="atet")
	local knn = e(k_nnmax) //e(k_nneighbor)
	qui gen double `wz' = .
	/* before matching plots					*/
	qui gen double `xt0' = `x' if `tvar'==`treated' & `tu'
	qui gen double `xc0' = `x' if `tvar'==`control' & `tu'
	if `att' {
		qui gen double `xt1' = `x' if `tvar'==`treated' & `tu'
		if `wgts' {
			qui replace `wz' = `wt' if `tvar'==`treated' & `tu'
		}
	}
	else {
		qui gen double `xt1' = .
	}
	qui gen double `xc1' = .
	qui gen double `z' = .
	qui gen double `ww' = .

	local N = _N
	forvalues i=1/`N' {
		if (!`tu'[`i']) {
			continue
		}
		if `att' & `tvar'[`i']==`control' {
			continue
		}
		local kn = 0
		forvalues k=1/`knn' {
			local iv : word `k' of `ivars'
			local i1 = `iv'[`i']
			if missing(`i1') {
				continue, break
			}
			local `++kn'
			qui replace `z' = `x'[`i1'] in `k'

			if (`wgts') scalar `wi' = `wt'[`i1']
			else scalar `wi' = 1.0

			qui replace `ww' = scalar(`wi') in `k'
		}
		summarize `z' [iw=`ww'] if _n<=`kn', meanonly
		if `tvar'[`i'] == `control' {
			qui replace `xt1' = r(mean) in `i'
		}
		else {
			qui replace `xc1' = r(mean) in `i'
		}
		if (`wgts') {
			qui replace `wz' = `wt'[`i'] in `i'
		}
	}
	qui keep if `tu'
	local N = _N
	qui stack `svars', into(`xt' `xc' `wt') clear

	label variable `xt' "`tlab'"
	label variable `xc' "`clab'"
	/* first N observations are the unmatched distribution		*/
	return local N = `N'
end

exit
