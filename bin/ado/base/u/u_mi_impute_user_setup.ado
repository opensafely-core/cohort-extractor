*! version 1.0.0  26oct2015
program u_mi_impute_user_setup
	version 14.0
	global MI_IMPUTE_user_setup 1

	// handle 'if' and 'weights'
	cap noi syntax [if] [fw pw aw iw],                      ///
			[					///
				ivars(string)			///
				xvars(string)			///
				title1(string asis) title2(string asis) ///
				noFILLMISsing			///
				NOIsily				///
				NOLEGend			///
				ORDERASIS			///
				impobj(string) 			/// // internal
				* /// // xvars#(),if#(), weight#(), user options
			]
	if _rc {
		di as err "in program {bf:u_mi_impute_user_setup}"
		exit _rc
	}
	// ivars() must be specified
	local nivars : list sizeof ivars
	if (`nivars'==0) {
di as err "{bf:mi_impute_cmd_${MI_IMPUTE_user_method}_parse}: invalid syntax"
di as err "{p 4 4 2}You must specify imputation variable(s) in option"
di as err " {bf:ivars()} of program {bf:u_mi_impute_user_setup}; see"
di as err "{help mi_impute_usermethod##parser:Writing an imputation parser}"
di as err "for details.{p_end}"
exit 100
	}
	// set preliminary touse and weight expression
	marksample touse
	if ("`weight'"!="") {
		local wgtexp [`weight'`exp']
	}
	// parse xvars#(),if#(), weight#() options
	local 0 , `options'
	forvalues i=1/`nivars' {
		syntax [, xvars`i'(string) if`i'(string asis) ///
			  weight`i'(string asis) * ]
		if (`"`xvars`i''"'=="") {
			local xvars`i' `xvars'
		}
		if (`"`weight`i''"'=="") {
			local weight`i' `wgtexp'
		}
		local 0 , `options'
	}
	
	if ("`impobj'"=="") {
		local impobj $MI_IMPUTE_obj.Imp
	}

	// set other global macros
	global MI_IMPUTE_user_options `options'
	global MI_IMPUTE_user_fillmissing "`fillmissing'"
	if ("$MI_IMPUTE_user_opt_noisily"=="") {
		global MI_IMPUTE_user_quietly quietly
	}

	// check imputation variables
	// check ivars are not specified more than once
	local dups : list dups ivars
	if ("`dups'"!="") {
		local uniq: list uniq dups
		local n: word count `uniq'
		di as err "{p 0 0 2}{bf:`uniq'}: duplicates found;"
		di as err "{p_end}" 
		di as err "{p 4 4 2}variables cannot be specified" 
		di as err "as imputation variables in multiple "
		di as err "equations{p_end}"
		exit 198
	}
	// check ivars are registered
	u_mi_impute_check_ivars ivars : "`ivars'" "`nivars'"
	// check if imputed vars are used as regressors
	local bad : list ivars & xvars
	if ("`bad'"!="") {
		local n : word count `bad'
		di as err "{p 0 0 2}"				///
			  "{bf:`bad'}: imputation "		///
			  plural(`n',"variable")		///
			  " cannot be also specified as independent " 	///
			  plural(`n',"variable") "{p_end}"
		exit 198
	}

	// set global touse 
	local tousename __mi_imp_user_gltouse
	global MI_IMPUTE_user_touse `tousename'
	cap drop `tousename'
	qui gen byte `tousename' = `touse'
	markout `tousename' `ivars', sysmissok
	//make sure that global touse is defined only on m=0
	local style `_dta[_mi_style]'
	if ("`style'"=="mlong" | "`style'"=="flong") { // must use m0
               	sort _mi_m _mi_id // make sure data are sorted before parse
		qui replace `tousename' = 0 if _mi_m>0
	}
	/* if ("`ifgroup'"!="") { // for by()
		qui replace `tousename'=0 if !(`ifgroup') & `tousename'
	}*/
	qui count if `tousename'
	local Nobs = r(N)
	if (`Nobs'==0) {
		error 2000
	}

	// preliminary setup for a multivariate object
	mata: `impobj'.presetup("`ivars'",	///
				"`tousename'",	///
				"$MI_IMPUTE_user_method",	///
				"`orderasis'")
	mata: `impobj'.st_setmacros("ivarsinc","ivarsincord","orderid", ///
				    "pattern","fvopivarsord","incordid")
	// set titles
	if (`"`title1'"'!="") {
		mata: `impobj'.title1 = `title1'
	}
	if (`"`title2'"'!="") {
		mata: `impobj'.title2 = `title2'
	}
	global MI_IMPUTE_user_allivars "`ivars'"
	global MI_IMPUTE_user_ordind "`orderid'"
	global MI_IMPUTE_user_pattern "`pattern'" // based on the global touse
	global MI_IMPUTE_user_xvars `xvars'
	global MI_IMPUTE_user_k_ivars `nivars'

	// set objects for each imputation variable
	global MI_IMPUTE_user_missvars
	global MI_IMPUTE_user_tousevars `tousename'
	global MI_IMPUTE_user_ivarsinc 		// final incomplete ivars
	global MI_IMPUTE_user_incordind
	tokenize `ivars'
	forvalues i=1/`nivars' {
		local ivar ``i''
		SetupIvar `if`i'' `weight`i'', index(`i') ivar(`ivar')   ///
		    xvars(`xvars`i'') touse(`tousename') incordid(`incordid')
	}

	// set multivariate object
	mata: `impobj'.setup("$MI_IMPUTE_user_incordind")

	global MI_IMPUTE_user_ivars $MI_IMPUTE_user_ivarsinc
	global MI_IMPUTE_user_k_ivarsinc : ///
		list sizeof global(MI_IMPUTE_user_ivarsinc)
	// set additional global macros with only one imputation variable
	global MI_IMPUTE_user_weight `wgtexp'
	if (`nivars'==1) {
		global MI_IMPUTE_user_ivar `ivars'
		global MI_IMPUTE_user_miss $MI_IMPUTE_user_miss1
	}
	// note about complete ivars and also sets s(nomiss) flag
	// that makes -mi impute- stop if no incomplete ivars
	u_mi_impute_note_nomiss "$MI_IMPUTE_user_ivarscomplete" ///
				"$MI_IMPUTE_user_ivarsinc" ""
end

program SetupIvar
	cap noi syntax [if] [fw pw aw iw], 		///
				index(integer)		///
				touse(string)		///
				ivar(string)		///
			[				///
				incordid(string) 	///
				xvars(string)		///
			]
	if _rc {
		di as err "in program {bf:u_mi_impute_user_setup}"
		exit _rc
	}

	if ("`weight'"!="") { // handle weights
		local wgtexp [`weight'`exp']
		tempvar wgt
		qui gen double `wgt'`exp'
	}

	// check complete predictors
	if ("`xvars'"!="") {
		cap noi {
			_chk_ts `xvars'
			fvunab xvars : `xvars'
			unopvarlist `xvars'
			local xvars `r(varlist)'
			confirm numeric variable `xvars'
		}
		if _rc {
		       di as err "complete predictors are incorrectly specified"
		       exit _rc
		}
	}

	// check if imputed vars are used as regressors
	local bad : list ivar in xvars
	if (`bad') {
		di as err "{p 0 0 2}{bf:`ivar'}: imputation variable cannot" ///
			  " be also specified as independent variable{p_end}"
		exit 198
	}
	// check if any registered imp. vars are used as regressors
	local imputed	`_dta[_mi_ivars]'
	local tochk : list imputed - ivars
	local bad : list tochk & xvars
	if ("`bad'"!="") {
		local n1: word count `bad'
		local n2: word count `ivars'
		di as txt "{p 0 6 2}note: " plural(`n1',"variable") 	/// 
			  " {bf:`bad'} registered as "		///
			  "imputed and used to model "		///
			  plural(`n2',"variable") 		///
			  " {bf:`ivars'}; this may cause "	///
			  "some observations to be omitted "  	///
			  "from the estimation and may lead "	///
			  "to missing imputed values{p_end}"	
	}

	// object 
	local impobj $MI_IMPUTE_obj.Imp.pImpCls[`index']

	// generate touse for each variable
	local tousename __mi_imp_touse`index'
	cap drop `tousename'
	marksample tousetmp
	qui gen byte `tousename' = `tousetmp'*`touse'
	qui count if `tousename'
	local Nobs = r(N)
	if (`Nobs'==0) {
		di as err "imputation variable {bf:`ivar'}:"
		error 2000
	}
	global MI_IMPUTE_user_tousevars $MI_IMPUTE_user_tousevars `tousename'

	// define global macros for incomplete ivars
	local incind :  list posof "`index'" in incordid
	if (`incind') { 
		global MI_IMPUTE_user_touse`incind' `tousename'
		global MI_IMPUTE_user_weight`incind' `wgtexp'
		global MI_IMPUTE_user_xvars`incind' `xvars'
		global MI_IMPUTE_user_ivar`incind' `ivar'
		local missname __mi_imp_miss`index'
		cap drop `missname'
		global MI_IMPUTE_user_miss`incind' `missname'
		global MI_IMPUTE_user_missvars ///
			$MI_IMPUTE_user_missvars `missname'
			qui gen byte `missname' = cond(`tousename'==1 & ///
						       `ivar'==.,1,0)
	}
	mata: `impobj'->setmissingsample("`ivar'",     ///
					"`tousename'", ///
					"`weight'","`wgt'",0,0,.)
	// check if <ivar> has missing
	qui u_mi_ivars_musthave_missing nbadvars bad : ///
		"`ivar'" "`tousename'" "nomissok" "0 4 2"
	if (`nbadvars') {
		global MI_IMPUTE_user_ivarscomplete ///
			$MI_IMPUTE_user_ivarscomplete `ivar'
	}
	else {
		global MI_IMPUTE_user_ivarsinc ///
			$MI_IMPUTE_user_ivarsinc `ivar'
		global MI_IMPUTE_user_incordind ///
			$MI_IMPUTE_user_incordind `incind'
	}
	if (`Nobs'==1) {
		di as err "imputation variable {bf:`ivar'}:"
		error 2001
	}
	mata: `impobj'->setup("`tousename'","`wgt'")
end

program _chk_ts
	syntax [varlist(default=none fv)]
end
