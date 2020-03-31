*! version 1.0.2  03jun2015

program define _teffects_ra_init, rclass
	version 13
	syntax varlist(numeric), model(string) depvar(varname)           ///
			tvar(varname) tlevels(string) touse(varname)     ///
			stat(string) [ hvarlist(varlist) offset(varname) ///
			verbose wtype(string) wvar(varname) ipw(varname) ///
			aipw control(string) treated(string) ]

	if ("`verbose'"!="") local noi noi

	tempvar exb
	tempname b t t0
	/* weights for regression					*/
	if "`ipw'" != "" {
		if ("`aipw'"=="") local wts [iw=`ipw']
		else if "`wtype'" == "fweight" {
			/* -_teffects_ipw_init- weights ipw with freqs	*/
			qui replace `ipw' = `ipw'/`wvar'
			local wts [fw=`wvar']
		}
	}	
	else if ("`wtype'"!="") local wts [`wtype'=`wvar']

	/* weights for summarize					*/
	if "`wtype'"!="" {
		local swt = cond("`wtype'"=="fweight", "[fw=`wvar']", "[iw=`wvar']")
	}

	local klev : list sizeof tlevels
	forvalues i=1/`klev' {
		tempvar t`i'
		local lev : word `i' of `tlevels'
		qui gen byte `t`i'' = (`tvar'==`lev') if `touse'
		local tvars `tvars' `t`i''
	} 
	if ("`model'" == "hetprobit"|"`model'" == "fhetprobit") {
		/* need collinear for hetprobit?			*/
		local extra collinear  het(c.(`tvars')#c.(`hvarlist'))
	}
	if "`model'" == "linear" {
		local model regress
		local xb xb
	}
	else {
		local extra `extra' iterate(20)
		if ("`model'"=="poisson") {
			local xb n
		}
		if ("`model'"=="fprobit"|"`model'" == "fhetprobit"| ///
			"`model'" == "logit"|"`model'" == "flogit") {
			local xb cm
		}
		if ("`model'"=="probit"| "`model'" == "logit") {
			local xb pr
		}
	}
	
	if ("`model'"=="fprobit"|"`model'" == "fhetprobit") {
		local model fracreg probit
	}		
	if ("`model'"=="flogit") {
		local model fracreg logit
	} 

	if "`varlist'" == "" {
		cap `noi' `model' `depvar' c.(`tvars') if `touse' `wts', ///
			noconstant `extra'
	}
	else {
		cap `noi' `model' `depvar' c.(`tvars')#c.(`varlist') ///
			if `touse' `wts', noconstant `extra'
	}
	local rc = c(rc)
	if `rc' {
		if `rc' > 1 {
			/* programmer error				*/
			di as err "{p}{it:omodel} {cmd:`model'} initial " ///
			 "estimates failed{p_end}"
		}
		exit `rc'
	}
	if "`model'"!="regress" & !e(converged) {
		di as txt "{p 0 6 2}Note: {it:omodel} {cmd:`model'} "     ///
		 "initial estimates did not converge; the model may not " ///
		 "be identified{p_end}"
	}
	mat `b' = e(b)
	mat `t' = J(1,`klev',0)

	if "`stat'" == "att" {
		tempvar treat
		local j : list posof "`treated'" in tlevels
		qui gen byte `treat' = `t`j''
		local iff & `treat'==1
	}
	foreach v of varlist `tvars' {
		qui replace `v' = 0 if `touse'
	}
	/* treatment margins						*/
	local k = 0
	forvalues i=1/`klev' {
		local lev : word `i' of `tlevels'
		qui replace `t`i'' = 1 if `touse'
		qui predict double `exb' if `touse', `xb'
		if "`aipw'" != "" {
			/* EIF, stat != att				*/
			qui replace `exb' = `exb' + cond(`tvar'==`lev', ///
				`ipw'*(`depvar'-`exb'),0) if `touse'
		}
		summarize `exb' if `touse' `iff' `swt', meanonly
		mat `t'[1,`i'] = r(mean)

		qui replace `t`i'' = 0
		qui drop `exb'
	}
	if "`stat'" != "pomeans" {
		local j : list posof "`control'" in tlevels
		scalar `t0' = `t'[1,`j']
		forvalues i=1/`klev' {
			if (`i'!=`j') mat `t'[1,`i'] = `t'[1,`i']-`t0'
		}
	}
	if "`verbose'"!="" {
		mat li `t', title(treatment effects)
	}
	mat `b' = (`t',`b')

	return mat b = `b'
end
exit
