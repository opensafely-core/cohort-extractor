*! version 1.0.0  12feb2015

program define _stteffects_parse_stvarlist, sclass
	version 14.0
	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'

	local 0, `before'
	syntax, model(string) tvar(passthru) touse(varname) ///
		[ wtype(passthru) wvar(passthru) ]

	local 0 `after'
	cap noi syntax [ varlist(numeric fv default=none) ],[ WEIBull GAMma ///
			LNormal EXPonential noCONstant ancillary(string) ]
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The `model' model is misspecified.{p_end}"
		exit `rc'
	}

	local k = ("`exponential'"!="")
	local k = `k' + (`"`weibull'"'!="")
	local k = `k' + (`"`gamma'"'!="")
	local k = `k' + (`"`lnormal'"'!="")
	if `k' > 1 {
		di as err "{p}`model'-model distribution options "  ///
		 "{bf:exponential}, {bf:weibull}, {bf:gamma}, and " ///
		 "{bf:lnormal} cannot be specified together{p_end}"
		exit 184
	}
	if (`k'==0) local weibull weibull

	local k_omitted = 0
	if "`varlist'" != "" {
		CleanVarlist `varlist', model(`model') `tvar' touse(`touse') ///
			`constant' `wtype' `wvar'
		local varlist `s(varlist)'
		local fvvarlist `s(fvvarlist)'
		local k_omitted = `s(k_omitted)'
	}
	else if "`constant'" != "" {
		di as err "{p}`model' model has no covariates or constant " ///
		 "term; this is not allowed{p_end}"
		exit 498
	}
	sreturn local k_omitted = `k_omitted'
	if "`exponential'"!= "" {
		if `"`ancillary'"' != "" {
			di as err "suboption {bf:ancillary()} is not allowed"
			di as txt "{phang}The `model' model is " ///
			 "misspecified.{p_end}"
			exit 198
		}
		sreturn local dist exponential
		sreturn local varlist `"`varlist'"'
		sreturn local fvvarlist `"`fvvarlist'"'
		sreturn local constant `constant'
		exit
	}
	local dist `weibull'`lnormal'`gamma'

	ParseAncillary `model' `dist' : `ancillary'
	local shapevlist `"`s(varlist)'"'
	local shapeconst `s(constant)'

	CleanVarlist `shapevlist', model(`model') `tvar' touse(`touse') ///
		`shapeconst' `wtype' `wvar' ancillary
	local shapevlist `s(varlist)'
	local fvshapevlist `s(fvvarlist)'
	local k_omitted = `k_omitted' + `s(k_omitted)'

	/* check for consistent factor variable coding			*/
	cap noi fvexpand `fvvarlist' `fvshapevlist' if `touse'
	local rc = c(rc) 
	if `rc' {
		di as txt "{phang}The `model'-model `dist' distribution is " ///
		 "misspecified.{p_end}"
		exit `rc'
	}

	sreturn local dist `dist'
	sreturn local varlist `"`varlist'"'
	sreturn local fvvarlist `"`fvvarlist'"'
	sreturn local shapevlist `"`shapevlist'"'
	sreturn local fvshapevlist `"`fvshapevlist'"'
	sreturn local k_omitted = `k_omitted'
	sreturn local constant `constant'
	sreturn local shapeconst `shapeconst'
end

program define CleanVarlist, sclass
	cap noi syntax [ varlist(numeric fv default=none) ], model(string) ///
		tvar(string) touse(string) [ wtype(string) wvar(string)    ///
		ancillary noconstant ]
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The `model'-model distribution is " ///
		 "misspecified.{p_end}"
		exit `rc'
	}
	if "`wtype'" != "" {
		local wts [`wtype'=`wvar']
		if ("`wtype'"=="fweight") local fopt freq(`wvar')
	}
	/* assumption stset						*/
	local st_bt : char _dta[st_bt]
	if "`st_bt'" == "" {  // should not happen
		di as err "{p}survival time variable could not be found; " ///
		 "be sure to {bf:stset} your data{p_end}"
		exit 119
	}
	if "`ancillary'" != "" {
		local rest " for the ancillary parameter"
	}
	/* quietly drop redundant variable names; for the omodel they	*/
	/*  will be quietly dropped by the parser after we interact	*/
	/*  them with the treatment variable leading to a 		*/
	/*  conformability error because our variable count will be off	*/
	local varlist : list uniq varlist

	fvrevar `varlist', list
	local varlist0 `r(varlist)'

	local vlist `varlist0'
	local vlist : list vlist - st_bt
	if `"`vlist'"' != `"`varlist0'"' {
		di as err "{p}`model'-model variable list`rest' cannot " ///
		 "include the survival time variable `st_bt'{p_end}" 
		exit 198
	}
	local st_bd : char _dta[st_bd]
	if "`st_bd'" != "" {
		local vlist `varlist0'
		local vlist : list vlist - st_bd
		if `"`vlist'"' != `"`varlist0'"' {
			di as err "{p}`model'-model variable list`rest' " ///
			 "cannot include the failure event variable "     ///
			 "`st_bd'{p_end}" 
			exit 198
		}
	}
	else if "`model'" == "censoring" {	// should not happen
		di as err "{p}censoring model requires that you {bf:stset} " ///
		 "a failure event variable{p_end}"
		exit 119
	}
	if "`model'" != "censoring" {
		local vlist `varlist0'
		local vlist : list vlist - tvar
		if `"`vlist'"' != `"`varlist0'"' {
			di as err "{p}`model'-model variable list`rest' " ///
			 "cannot include the treatment variable `tvar'{p_end}" 
			exit 198
		}
	}
	markout `touse' `varlist'
	_teffects_count_obs `touse', `fopt' ///
		why(observations with missing values)

	/* check for collinearity among variables 			*/
	_rmcoll `varlist' if `touse' `wts', `constant'
	local k_omitted = r(k_omitted)
	if (`k_omitted'!=0) local varlist `r(varlist)'

	fvexpand `varlist' if `touse'
	local fvops `r(fvops)'
	local fvvarlist `r(varlist)'

	fvrevar `varlist', list
	local varlist `r(varlist)'

	sreturn local varlist `"`varlist'"'
	sreturn local fvvarlist `"`fvvarlist'"'
	sreturn local k_omitted = `k_omitted'
	sreturn local fvopts `fvopts'
end

program define ParseAncillary, sclass
	_on_colon_parse `0'
	local before `s(before)'
	local vlist `s(after)'

	gettoken model dist : before
	local dist : list retokenize dist
	local args : list retokenize vlist

	local 0 `args'

	cap noi syntax [ varlist(numeric fv default=none) ], [ noCONstant ]
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The `model'-`dist' model is misspecified." ///
		 "{p_end}"
		exit `rc'
	}
	if `"`varlist'"'=="" & "`constant'"!="" {
		di as err "{p}`model'-model ancillary parameter "          ///
		 "specification has no covariates or constant term; this " ///
		 "is not allowed{p_end}"
		exit 498
	}
	sreturn local varlist `varlist'
	sreturn local constant `constant'
end

exit
