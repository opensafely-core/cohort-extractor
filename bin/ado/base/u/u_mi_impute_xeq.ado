*! version 1.2.0  13oct2015
program u_mi_impute_xeq
	local version : di "version " string(_caller()) ":"
	version 12
	syntax, 	xeqmethod(string) 		///
			ivars(string) 			///
			mstart(integer) mend(integer) 	///
			cmdlineimpute(string asis) 	///
		[	FORCE				///
			NODOTS				/// 
			impobj(string) 			///
			cmdlineinit(string asis) 	///
			initinaloop			///
		]
	local style `_dta[_mi_style]'
	if ("`style'"=="wide") {
		local nopreserve `""nopreserve""'
	}
	local itermethod = inlist("`xeqmethod'","mvn","chained")
	if ("`xeqmethod'"=="mvn" & `"`cmdlineinit'"'!="") {
		local cmdlineinit `"`cmdlineinit' "`mstart'""'
	}
	global MI_IMPUTE_setstripe 0
	if ($MI_IMPUTE_user==0) {
		local initname u_mi_impute_cmd_`xeqmethod'_init
	}
	else {
		local initname mi_impute_cmd_`xeqmethod'_init
	}
	if (`"`cmdlineinit'"'!="" & "`initinaloop'"=="") { 
		// init on m0, if requested
		u_mi_impute_xeq_`style' 0 `nopreserve' : 	///
		    `"`version' `initname' `cmdlineinit'"'
	}
	// display dots title
	if ("`initinaloop'"!="" & "`xeqmethod'"=="chained" & "`nodots'"=="") {
		di as txt "Performing chained iterations:"
		local notitle notitle
	}
	_imp_title title lastchar : `mstart' `mend' "`nodots'"
	if (`itermethod') {
		local title = lower(`"`title'"')
		u_mi_dots, title(`"`title'"') indent(2) `nodots'
	}
	else if ("`nodots'"=="") {
		di
		di as txt "`title'`lastchar'"
		u_mi_dots, indent(2) `nodots'
	}
	// impute in m>0
	local ind = 1
	forvalues imp=`mstart'/`mend' {
		global MI_IMPUTE_badivars
		if ("`initinaloop'"!="") {
			global MI_IMPUTE_user_m 0
			u_mi_impute_xeq_`style' 0 `nopreserve' : 	///
	`"`version' u_mi_impute_cmd_`xeqmethod'_init `cmdlineinit'`notitle'"'
			if ("`xeqmethod'"=="chained") {
				local notitle  `"" notitle""'
			}
		}
		global MI_IMPUTE_user_m `imp'
		if (`imp'==`mstart' & "`xeqmethod'"=="mvn") {
			u_mi_impute_xeq_`style' `imp' `nopreserve' : ///
				`"mata : `impobj'.post_impvals()"'
			local cmd_rc = 0
		}
		else {
			if ($MI_IMPUTE_user==0) {
				local xeqimpcmd ///
				`"u_mi_impute_cmd_`xeqmethod' `cmdlineimpute'"'
			}
			else {
				local xeqimpcmd u_mi_impute_cmd__user
			}
			cap noi u_mi_impute_xeq_`style' `imp' `nopreserve' : ///
				`"`version' `xeqimpcmd'"'
			local cmd_rc = _rc
		}
		local dot_rc = (`cmd_rc'!=0)
		if (`cmd_rc' & (`cmd_rc'!=504 & `cmd_rc'!=459)) {
			// stop on error other than 504 or 459
			if (`cmd_rc'==499) { //if nonnested conditional vars
				local cmd_rc 459
			}
			di as err "{p 0 0 2}"
			di as err "error occurred during imputation" 
			di as err "of {bf:`ivars'} on {bf:m = `imp'}"
			di as err "{p_end}"
			exit `cmd_rc'
		}
		cap noi u_mi_dots `ind' `dot_rc', every(10) `nodots'
		if (`cmd_rc') { // errors 504 or 459
			// imputation step resulted in miss. values
			if ("`force'"=="") {
				// stop, do not replace existing imp.
				dierr `cmd_rc' "$MI_IMPUTE_badivars"
				exit 498
			}
			// continue
		}
		local ++ind
	} // end imputation loop
	global MI_IMPUTE_user_m
	u_mi_dots, last `nodots'
end

program _imp_title
	args imptitle lastchar colon mstart mend nodots

	if ("`nodots'"=="") {
		local endti ":"
	}
	else {
		local endti " ... "
	}
	local n = `mend'-`mstart'+1
	if (`n'>1) {
		local title Imputing {it:m}=`mstart' 
		local title `title' through {it:m}=`mend'
	}
	else {
		local title Imputing {it:m}=`mstart'
	}
	c_local `imptitle' `title'
	c_local `lastchar' `"`endti'"'
end

program dierr
	args err ivars
	if (`err'==504) {
		di as err "{p 0 0 2}Coefficients (or residual variance) "  ///
			  "estimated from the observed data are missing. " ///
			  "This may happen, for example, when the number " ///
			  "of parameters exceeds the number of "	   ///
			  "observations. Choose an alternate imputation " ///
			  "model.{p_end}"
	}
	else if (`err'==459) {
		_errmiss "`ivars'"
	}
end

program _errmiss
	args ivars

	if ("`ivars'"!="") {
		local diivars "{bf:`ivars'}: "
	}
	di as err "{p}`diivars'missing imputed values produced{p_end}"
	di as err "{p 4 4 2}This may occur when imputation variables"
	di as err "are used as independent variables or when independent"
	di as err "variables contain missing values.  You can specify option "
	di as err "{bf:force} if you wish to proceed anyway."
	di as err "{p_end}"

end
