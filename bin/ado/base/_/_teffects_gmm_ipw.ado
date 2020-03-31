*! version 1.0.1  14nov2014

program define _teffects_gmm_ipw
	version 13
	syntax varlist if [fw iw pw/], at(name) model(string) tvars(varlist) ///
		tlevels(string) depvar(varname) tvarlist(varlist)         ///
		stat(string) control(passthru) [ treated(passthru)        ///
		hvarlist(varlist) derivatives(varlist) prlist(passthru) ]

	local pomeans = ("`stat'"=="pomeans")
	local logit = ("`model'"=="logit")
	local kvar : list sizeof tvarlist
	local klev : list sizeof tlevels
	/* programmer error				 		*/
	local khvar : list sizeof hvarlist
	local kpar = (`klev'-1)*`kvar'+`klev'+`khvar'
	if (colsof(`at')!=`kpar') error 503

	tempvar ipw xb
	tempname bx bipw

	mat `bipw' = `at'[1,`=`klev'+1'...]
	gettoken r vlist : varlist

	if "`model'" == "logit" {
		 _teffects_gmm_ipw_mlogit `vlist' `if', at(`bipw')   ///
			tvars(`tvars') tlevels(`tlevels')            ///
			tvarlist(`tvarlist') stat(`stat') ipw(`ipw') ///
			`control' `treated' derivatives(`derivatives') `prlist'
	}
	else {
		/* probit or hetprobit					*/
		 _teffects_gmm_ipw_hetprobit `vlist' `if', at(`bipw')      ///
			model(`model') tvars(`tvars') tlevels(`tlevels') ///
			tvarlist(`tvarlist') stat(`stat') ipw(`ipw')     ///
			hvarlist(`hvarlist') `control' `treated'         ///
			derivatives(`derivatives') `prlist'
	}
	mat `bx' = `at'[1,1..`klev']
	mat colnames `bx' = `tvars'

	qui mat score double `xb' = `bx' `if'
	local del `xb'
	qui replace `del' = `depvar'-`xb' `if'
	qui replace `r' = `ipw'*`del' `if'

	if ("`derivatives'"=="") exit

	forvalues i=1/`klev' {
		local di : word `i' of `derivatives'
		local tr : word `i' of `tvars'
		qui replace `di' = cond(`tr',-`ipw',0) `if'
	}
	local k = `klev'+1
	forvalues i=`k'/`kpar' {
		local di : word `i' of `derivatives'
		qui replace `di' = `di'*`del'
	}
end
exit
