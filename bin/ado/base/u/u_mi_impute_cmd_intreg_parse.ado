*! version 1.0.1  13oct2015
program u_mi_impute_cmd_intreg_parse, sclass
	version 12	
	// preliminary syntax check
	syntax [anything(equalok)] [if] [aw fw pw iw],	///
			impobj(string)			/// //internal
			ll(varname numeric)		///
			ul(varname numeric)		///
		[					/// 
			NOCONStant			///
			OFFset(passthru)		///
			NOCMDLEGend			/// //undoc.
			CREATEIVARONLY			/// //internal
			IVAREXISTS			/// //internal
			IVARANY				/// //internal
			float				/// //internal
			double				/// //internal
			*				/// //common univ. opts
		]
	local vartype `float'`double'
	if ("`vartype'"=="") {
		local vartype float
	}
	// parse newname
	gettoken newivar xspec : anything, parse("= ")
	if (`"`newivar'"'!="") {
		if `_dta[_mi_M]'>0 {
			local ivarany ivarany
		}
	}
	if (`"`newivar'"'!="" & "`ivarany'"!="") {
		cap confirm new variable `newivar'
		if _rc & `_dta[_mi_M]'>0 {
			local ivarexists ivarexists
		}
	}
	unab dv1 : `ll'
	unab dv2 : `ul'
	local depvars `dv1' `dv2'
	tempvar touse tousem0
	mark `touse' `if'
	qui gen byte `tousem0' = 1
	local style `_dta[_mi_style]'
	local is_long = ("`style'"=="mlong" | "`style'"=="flong")
	if (`is_long') { // use m = 0
		qui replace `touse' = 0 if _mi_m>0
		qui replace `tousem0' = 0 if _mi_m>0
	}
	else {
		local mixeq "mi xeq :"
	}

	if ("`ivarexists'"!="") {
		_intreg_check_ivar "`newivar'" "`dv1'" "`dv2'" `"`touse'"'
	}
	else { // must be new variable
		cap noi confirm new variable `newivar'
		if _rc {
			if ("`newivar'"=="") {
				local rc = 100
			}
			else if _rc==7 {
				local rc = 198
			}		
			else {
				local rc = _rc
			}
			if `_dta[_mi_M]'>0 {
				local msg2 " or existing"
			}
			else {
				local msg1 "When no imputations exist, "
			}	
			di as err "{p 0 0 2}"
			di as err "{bf:mi impute intreg}: invalid syntax;"
			di as err "{p_end}"
			di as err "{p 4 4 2}"
			di as err "`msg1'the name of a new`msg2' variable"
			di as err "to store imputed values required"
			di as err "following the method specification{p_end}"
			exit `rc'
		}
		qui gen `vartype' `newivar' = `dv1' if `dv1'==`dv2' & `tousem0'
		qui replace `newivar' = .a if (`dv1'>. | `dv2'>.) & `tousem0'
		if (`is_long') {
			qui replace `newivar' = `newivar'[_mi_id] if _mi_m>0
		}
		qui label variable `newivar' ///
			"Imputation variable for [`dv1', `dv2']"
		qui mi register imputed `newivar'
	}
	qui drop `touse' `tousem0'
	//check that dependent variables are not registered as imputed
	local ivars `_dta[_mi_ivars]'
	if ("`:list depvars & ivars'"!="") {
		di as err "{bf:mi impute intreg}: invalid syntax;"
		di as err "{p 4 4 2}dependent variables"
		di as err "{bf:`dv1'} and {bf:`dv2'}"
		di as err "specified within {bf:ll()} and {bf:ul()}"
		di as err "should not be registered as imputed; use"
		di as err "{helpb mi unregister} to unregister these variables"
		di as err "{p_end}"
		exit 198
	}
	// register dependent variables as passive
	qui `mixeq' recast `vartype' `depvars'
	local pvars `_dta[_mi_pvars]'
	local newpvars : list uniq depvars
	local newpvars : list newpvars - pvars
	if ("`newpvars'"!="") {
		qui mi register passive `newpvars'
	}
	if ("`createivaronly'"!="") exit
	
	u_mi_get_maxopts maxopts uvopts : `"`options'"'
	local cmdopts `noconstant' `offset' `maxopts'
	local uvopts `uvopts' `nocmdlegend'
	if ("`weight'"!="") { // accommodates default weights
		local wgtexp [`weight' `exp']
	}

	u_mi_impute_cmd__uvmethod_parse `newivar' `xspec' `if' `wgtexp', ///
		impobj(`impobj') method(intreg) cmd(intreg)		///
		cmdopts(`cmdopts') `noconstant' `uvopts'		///
		depvars(`depvars')
	
	sret local ivarexists "`ivarexists'"
end

program _intreg_check_ivar
	args newivar ll ul touse

	cap noi u_mi_mustbe_registered_imputed bad newivar : "`newivar'"
	if _rc {
		unopvarlist `newivar'
		local newivar `r(varlist)'
		di as err "{p 4 4 4} Because you specified an existing"
		di as err "variable, {bf:`newivar'}, with the {bf:intreg}" 
		di as err "method, it must satisfy the requirement in the above"
		di as err "error message.{p_end}"
		exit _rc
	}
	cap assert `newivar'==`ll' if `ll'==`ul' & `touse'
	if _rc {
		di as err "{p 0 2 2}{bf:`newivar'} is not consistent in the"
		di as err "observed data with the"
		di as err "variables {bf:`ll'} and {bf:`ul'} containing the"
		di as err "lower and upper interval-censoring limits{p_end}"
		exit 459
	}
	cap assert `newivar'>. if `ll'>. | `ul'>. & `touse'
	if _rc {
		di as err "{p 0 2 2}{bf:`newivar'} does not contain hard"
		di as err "missing values in observations where either of the"
		di as err "variables {bf:`ll'} and {bf:`ul'}, containing the"
		di as err "lower and upper interval-censoring limits,"
		di as err "contain hard missing values{p_end}"
		exit 459
	}
	cap mi xeq 0: ///
		assert `newivar'==. if `ll'!=`ul' & `ll'<.a & `ul'<.a & `touse'
	if _rc {
		di as err "{p 0 2 2}{bf:`newivar'} does not contain soft"
		di as err "missing values in the missing and/or censored"
		di as err "observations identified by"
		di as err "variables {bf:`ll'} and {bf:`ul'} containing the"
		di as err "lower and upper interval-censoring limits{p_end}"
		exit 459
	}
end
