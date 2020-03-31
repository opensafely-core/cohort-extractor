*! version 3.5.4  28feb2017
program define logistic, eclass prop(or svyb svyj svyr swml mi bayes) ///
				byable(onecall)
	version 6.0, missing
	local version : di "version " string(_caller()) ", missing :"

	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`version' `BY' _vce_parserun logistic, mark(OFFset CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"logistic `0'"'
		exit
	}
        if replay() {
		if `"`e(cmd)'"'~=`"logistic"' { error 301 }
		if _by() { error 190 }
		`version' Display `0'
		exit
	}
	quietly syntax [anything] [if] [in] [fw iw pw aw] [, * ]
	`version' `BY' Estimate `0'
	version 10: ereturn local cmdline `"logistic `0'"'
end

program Estimate, eclass byable(recall)
	version 6.0, missing
	local vv : di "version " string(_caller()) ", missing :"
	syntax varlist(ts fv) [if] [in] 	///
		[fw pw iw] [,			///
		Level(cilevel) 			///
		COEF 				///
		Log 				///
		noCONstant			///
		noRULES 			///
		SCore(passthru) 		///
		VCE(passthru) 			///
		moptobj(passthru)		/// NOT DOCUMENTED
		*				///
	]
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}
	local fvops = "`s(fvops)'" == "true" | _caller() >= 11

	gettoken lhs rhs : varlist
	_fv_check_depvar `lhs'

	if "`log'" == "" {
		local log nolog
	}
	if _caller() < 11 {
		local qui quietly
	}
	else {
		local noh noheader
	}

	if `fvops' {
		_get_diopts diopts options, `options'
	}
	tempvar touse 
	mark `touse' `if' `in'
	`vv' ///
	`qui' logit `varlist' if `touse' 	///
		[`weight'`exp'], 		///
		`score' 			///
		`vce' 				///
		`options' 			///
		`log' 				///
		`constant'			///
		nocoef 				///
		`noh' 				///
		`rules'				///
		`moptobj'

	capture global S_E_vl = _b[_cons]
	if _rc & "`constant'" != "noconstant" { 
		di in red `"may not drop constant"'
		exit 399
	}
	/* we pick up other e() things from -logit- */
	est local wtype		`"`weight'"'
	est local wexp		`"`exp'"'
	est local predict	`"logistic_p"'

	if (1) {   /* double save in S_E_  */
		global S_E_vl   `"`varlist'"'
		global S_E_if   `"`if'"'
		global S_E_in   `"`in'"'
		global S_E_wgt  `"`weight'"'
		global S_E_exp  `"`exp'"'
		global S_E_ll   `"`e(ll)'"'
		global S_E_nobs `"`e(N)'"'
		global S_E_mdf  `"`e(df_m)'"'
		global S_E_cmd  "logistic"
	}
	est local cmd "logistic"

	if _caller() >= 11 {
		local rules norules
	}
	`vv' Display, level(`level') `coef' `diopts' `rules'
end

program Display
	version 9
	local vv : di "version " string(_caller()) ", missing :"
	syntax [, COEF noRULES or *]
	if `"`e(opt)'"' != "" {
		_get_diopts ignored, `options'
	}
	if `"`coef'"'=="" {
		`vv' logit, or `rules' `options'
	}
	else	`vv' logit, `rules' `options'
end
exit
