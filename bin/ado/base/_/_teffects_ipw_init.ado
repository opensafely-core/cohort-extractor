*! version 1.0.2  04dec2014

program define _teffects_ipw_init, rclass
	version 13
	syntax varlist(numeric), model(string) depvar(varname)         ///
			tvar(varlist) tlevels(string) touse(varname)   ///
			stat(string) control(string) [ treated(string) ///
			hvarlist(varlist) verbose wtype(string)        ///
			wvar(varname) ipw(name) noscale ]

	if ("`verbose'"!="") local noi noi

	tempvar pr ps pw pt
	tempname b t t0 ts

	local klev : list sizeof tlevels

	local att = ("`stat'"=="att")
	if ("`wtype'"!="") local wts [`wtype'=`wvar']

	local t0k `tvar'
	if "`model'" == "logit" {
		local model mlogit
		local extra base(`control')
	}
	else if "`model'"=="hetprobit" | "`model'"=="probit" {
		tempvar t0k

		if (!`att') local treated : list tlevels - control

		local treated : list retokenize treated
		qui gen byte `t0k' = `treated'.`tvar'

		if "`model'" == "hetprobit" {
			local extra het(`hvarlist')

			/* need collinear for hetprobit			*/
			local extra `"`extra' collinear"'
		}
	}
	cap `noi' `model' `t0k' `varlist' if `touse' `wts', noconstant ///
		iterate(50) `extra'
	local rc = c(rc)
	if `rc' {
		if `rc' > 1 {
			/* programmer error				*/
			di as err "{p}{it:tmodel} {bf:`model'} initial " ///
			 "estimates failed{p_end}"
		}
		exit `rc'
	}
	if !e(converged) {
		di as txt "{p 0 6 2}Note: {it:tmodel} {bf:`model'} "      ///
		 "initial estimates did not converge; the model may not " ///
		 "be identified{p_end}"
	}
	scalar `ts' = 0
	qui gen double `pw' = 0 if `touse'
	mat `b' = e(b)
	if "`model'" == "mlogit" {
		tempname b0

		/* remove omitted baseoutcome() coefficients		*/
		mat `b0' = `b'
		mat drop `b' 
		local k : list sizeof varlist
		local j : list posof "`control'" in tlevels
		local j = (`j'-1)*`k'
		if (`j') mat `b' = `b0'[1,1..`j']

		local j = `j' + `k' + 1
		if (`j'<=colsof(`b0')) mat `b' = (nullmat(`b'),`b0'[1,`j'...])
	}
	forvalues i=1/`klev' {
		local j : word `i' of `tlevels'
		if `j' == `control' {
			continue
		}
		if ("`model'"=="mlogit") local pextra outcome(`j')

		qui predict double `pr' if `touse', pr `pextra'
		if "`wtype'" == "fweight" {
			qui replace `pw' = `wvar'/`pr' ///
				if (`tvar'==`j') & `touse'
		}
		else {
			qui replace `pw' = 1/`pr' if (`tvar'==`j') & `touse'
		}
		qui replace `pw' = `pw' + `pr' if (`tvar'==`control') & `touse'

		if `att' {
			if `j' == `treated' {
				qui gen double `pt' = `pr' if `touse'
			}
		}
		qui drop `pr'
	}
	if "`wtype'" == "fweight" {
		qui replace `pw' = `wvar'/(1-`pw') if (`tvar'==`control') & ///
			`touse'
	}
	else {
		qui replace `pw' = 1/(1-`pw') if (`tvar'==`control') & `touse'
	}
	if (`att') qui replace `pw' = `pt'*`pw' if `touse'
	if ("`wtype'"!="" & "`wtype'"!="fweight") {
		qui replace `pw' = `pw'*`wvar'
	}
	if "`scale'" == "" {
		summarize `pw' if `touse', meanonly
		qui replace `pw' = `pw'/r(mean) if `touse'
	}
	if "`ipw'" != "" {
		/* IPWRA, just need the weights				*/
		qui gen double `ipw' = `pw'
	}
	else {
		if "`stat'" == "pomeans" {
			cap `noi' regress `depvar' ibn.`tvar' [pw=`pw'] ///
				if `touse', noconst
			mat `t' = e(b)
		}
		else {
			cap `noi' regress `depvar' ib`control'.`tvar' ///
				[pw=`pw'] if `touse'
			mat `t' = e(b)
			local j : list posof "`control'" in tlevels
			mat `t'[1,`j'] = `t'[1,`=`klev'+1']
			mat `t' = `t'[1,1..`klev']
		}
		mat `b' = (`t',`b')
		if "`verbose'" != "" {
			mat li `b', title(initial estimates)
		}
	}
	return mat b = `b'
end
exit
