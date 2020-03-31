*! version 1.4.0  30nov2018
program sem, eclass byable(onecall) properties(svyb svyj svylb)
	version 12
	local vv : di "version " string(_caller()) ", missing:"

	if replay() {
		if ("`e(cmd)'"!="sem") {
			error 301 
		}
		if (_by()) {
			error 190
		}
		
		sem_display `0'
		exit
	}
	quietly ssd query
	local is_ssd = r(isSSD)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
		if `is_ssd' {
			`BY' ssd query
			error 190	// [sic]
		}
	} 
	local 0 : list retok 0
	`vv' `BY' _vce_parserun sem, noeqlist : `0'
	if "`s(exit)'" != "" {
		ereturn scalar df_m = `e(rank)'
		ereturn local cmdline `"sem `0'"'
		exit
	}
	if `is_ssd' {
		`vv' Estimate `is_ssd' `0'
	}
	else {
		`vv' `BY' EstimateSP 0 `0'
	}
	ereturn local cmdline `"sem `0'"'
end

program EstimateSP, byable(onecall) sortpreserve
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' Estimate `0'
end

program Estimate, byable(recall) eclass
	version 12
	local vv : di "version " string(_caller()) ", missing:"

	gettoken is_ssd 0 : 0

nobreak {
capture noisily break {

	// bytouse will only have by var marked out
	if _by() {
		tempname bytouse
		mark `bytouse'
	}
	tempname SEM 
	if `is_ssd' == 0 {
		tempname touse
	}
	`vv' sem_parse_spec `SEM', bytouse(`bytouse') touse(`touse') : `0'
	local display_opts `s(display_opts)'

	// sem_fit() returns in e()			
	mata: st_sem_fit()

} // nobreak 

	local rc = c(rc)

} // capture noisily break

	if "`SEM'" != "" {
		capture mata: rmexternal("`SEM'")
		capture drop `SEM'*
	}
	if `rc' {
		exit `rc'
	}

	local covars : colvarlist e(b)
	local covars : list uniq covars
	local RMLIST _cons `e(lyvars)' `e(lxvars)'
	local covars : list covars - RMLIST
	if "`covars'" == "" {
		ereturn hidden local covariates _NONE
	}
	else	ereturn hidden local covariates `"`covars'"'

	local 0 `", `display_opts'"'
	syntax [, standardized *]
	ereturn hidden local stdopt "`standardized'"
	ereturn hidden local marginsprop allcons
	ereturn hidden local marginsnotok	///
			XBLATent1(passthru)	///
			XBLATent		///
			LATent1(passthru)	///
			LATent			///
			SCores			///
			xb

	if inlist("`e(vce)'", "robust", "cluster", "opg") {
		local varlist	`e(oyvars)'	///
				`e(oxvars)'	///
				`e(clustvar)'	///
				`e(groupvar)'
		fvrevar	`varlist', list
		local varlist `"`r(varlist)'"'
		local varlist : list uniq varlist
		signestimationsample `varlist'
	}

	sem_display, `display_opts'
end

exit
