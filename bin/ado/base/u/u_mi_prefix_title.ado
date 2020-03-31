*! version 1.0.3  25jan2017
* Note: changes to this file may also need to be copied to _prefix_title.ado
program u_mi_prefix_title
	args totitle colon cmd default

	version 11
	local exclude `""streg""'
	if (`"`e(title)'"' != "" & !inlist("`cmd'",`exclude')) {
		c_local `totitle' `"`e(title)'"'
		exit
	}

	if "`cmd'" == "stcox" {
		local h = cond(`"`e(strata)'"'=="", /*
				*/ "Cox regression", /*
				*/ "Stratified Cox regr.")

		local colon ":"
		if "`e(method)'"=="breslow" {
			local h1="Breslow method for ties" 
		}
		else if "`e(method)'"=="efron" { 
			local h1="Efron method for ties"
		}
		else if "`e(method)'"=="partial" { 
			local h1="Exact partial likelihood"
		}
		else if "`e(method)'"=="marginal" { 
			local h1="Exact marginal likelihood" 
		}
		local mac ties
		local macvary `e(names_vvl_mi)'
		local tiesvary : list mac in macvary 
		if ("`e(ties)'"=="none" & !`tiesvary') {  // no ties
			local h1 "" 
			local colon
			if `"`e(strata)'"'!="" {
				local h "Stratified Cox regression"
			}
		}
		c_local `totitle' `"`h'`colon' `h1'"'
		exit
	}
	if "`cmd'" == "streg" {
		c_local `totitle' `"`e(title)'"'
		exit
	}
	if "`cmd'" == "qreg" {
		if (e(q)==0.5) {
			c_local `totitle' "Median regression"
		}
		else {
			c_local `totitle' "`e(q)' Quantile regression"
		}
		exit
	}
	if "`cmd'" == "sqreg" {
		c_local `totitle' "Simultaneous quantile regression"
		exit
	}
	if "`cmd'" == "iqreg" {
		c_local `totitle' "`e(q1)'-`e(q0)' Interquantile regression"
		exit
	}
	if "`cmd'" == "bsqreg" {
		if (e(q)==0.5) {
			local title "Median regression"
		}
		else {
			local title "`e(q)' Quantile regression"
		}
		c_local `totitle' ///
		       "`title', bootstrap({res:`e(reps)'}{txt:) SEs}"
		exit
	}
	if "`cmd'" == "mvreg" {
		c_local `totitle' "Multivariate linear regression"
		exit
	}
	if "`cmd'" == "binreg" {
		c_local `totitle' "Generalized linear models"
		exit
	}
	if "`cmd'" == "xtlogit" {
		if ("`e(model)'"=="pa") {		
c_local `totitle' "Population-averaged logistic regression"
		}
		exit
	}
	if "`cmd'" == "xtprobit" {
		if ("`e(model)'"=="pa") {		
c_local `totitle' "Population-averaged probit regression"
		}
		exit
	}
	if "`cmd'" == "xtcloglog" {
		if ("`e(model)'"=="pa") {		
c_local `totitle' "Population-averaged complementary log-log model"
		}
		exit
	}
	if "`cmd'" == "xtpoisson" {
		if ("`e(model)'"=="pa") {		
c_local `totitle' "Population-averaged Poisson regression"
		}
		exit
	}
	if "`cmd'" == "xtnbreg" {
		if ("`e(model)'"=="pa") {		
c_local `totitle' "Population-averaged negative binomial regression"
		}
		exit
	}
	if "`cmd'" == "xtgee" {
		if ("`e(title)'"=="") {		
			c_local `totitle' "GEE population-averaged model"
		}
		exit
	}
	if "`cmd'" == "xtreg" {
		if ("`e(model)'"=="re") {		
			c_local `totitle' "Random-effects GLS regression"
		}
		else if ("`e(model)'"=="fe") {		
			c_local `totitle' "Fixed-effects (within) regression"
		}
		else if ("`e(model)'"=="pa") {		
			c_local `totitle' "Population-averaged linear regression"
		}
		exit
	}
	c_local `totitle' `"`default'"'
end
exit
