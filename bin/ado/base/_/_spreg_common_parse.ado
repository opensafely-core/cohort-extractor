*! version 1.1.0  25apr2018
// _spreg_common_parse parse some common options in spreg ml, spreg gs2sls and
// spivreg
//
//	syntax SPREG, touse(string) :		///
//		anything(name=eq		///
//		id = "spreg equation")		///
//		[,id(passthru)			///
//		ERRorlag(passthru)		///
//		noCONstant			///
//		Verbose				///
//		noLOg		   		///
//		*]
//
// 	options * contains repeatable ivarlag(), dvarlag(), errorlag()
//
// The output is r-class consists of the following members 
//						// main output
//		depvar
//		indeps
//		indeps_lbs
//		rho_lbs
//		exog
//		exog_lbs
//		endog
//		endog_lbs
//		dlmat_list_full
//		dlmat_list
//		elmat_list
//		verbose
//		log
//		touse
//		id
//		covariates
//						 // auxiliary 
//		x
//		x_lbs
//		wy_list
//		wy_index
//		wy_vars
//		wy_lbs
//		const_var
//		wy_n
//		endog_wy_lbs
//		exog_wy_lbs
//		exogr 
//		inst 
//		instd 
//		cn 
//		endog_wy_index 
//		exog_wy_index 
//		test_vars

program _spreg_common_parse, rclass
	version 15.0

	_on_colon_parse `0'
	local 0 `s(before)'
	syntax anything(name=SPREG), touse(string)

	local 0 `s(after)'

	syntax 	anything(name=eq		///
		id = "spreg equation")		///
		[, noCONstant			///
		Verbose				///
		NOLOg LOg		   	///
		force				///
		*]				// options are repeatable
						// ivarlag(), dvarlag()
						// and errorlag()
						// parse depvar, endog and exog	

						// original touse before markout
	tempvar orig_touse 
	qui gen byte `orig_touse' = `touse'
						// Parse Equations
	ParseEq `eq'
	local depvar `s(depvar)'
	local x `s(x)'
	local exog `s(exog)'
	local endog `s(endog)'
	local endog_lbs `s(endog_lbs)'
	local exog_lbs `s(exog_lbs)'
	local raw_inst `s(raw_inst)'
						// markout missing values
	markout `touse' `depvar' `x'
	NoObsError, touse(`touse')
						// parse id
	__sp_parse_id, `id'
	local id `s(id)'
						// parse constant
	ParseConst, `constant'
	local cn = `s(cn)'
	local cn_lb `s(cn_lb)'
						// parse verbose and log
	ParseVerbose , `verbose' `log' `nolog'
	local verbose = `s(verbose)'
	local log = `s(log)'
						// parse ivarlag
	ParseIvarlag, 			///
		depvar(`depvar') 	///
		endog(`endog') 		///
		touse(`touse') 		///
		id(`id')		///
		raw_inst(`raw_inst')	///
		`options'
	local wy_index `s(wy_index)'
	local dlmat_list_full `s(dlmat_list_full)'
	local wy_list `s(wy_list)'
	local wy_n = `s(wy_n)'
	local opts `s(opts)'
						//  markout again for wy_list
	if (`"`wy_list'"' != "") {
		markout `touse' `wy_list'
		NoObsError, touse(`touse')
	}
						// parse dvarlag
	ParseDvarlag, 			///
		depvar(`depvar') 	///
		endog(`endog') 		///
		touse(`touse') 		///
		id(`id')		///
		`opts'
	local wy_index `wy_index' `s(wy_index)'
	local dlmat_list_full `dlmat_list_full' `s(dlmat_list_full)'
	local dlmat_list_full : list uniq dlmat_list_full
	local wy_list `wy_list' `s(wy_list)'
	local wy_n = `s(wy_n)'+`wy_n'
	local opts `s(opts)'
						// parse errorlag
	ParseErrorlag , 		///
		id(`id') 		///
		touse(`touse') 		///
		depvar(`depvar') 	///
		`opts'
	local elmat_list `s(elmat_list)'
	local rho_lbs `s(rho_lbs)'
	local opts `s(opts)'
						// check extra options
 	CheckExtraOptions, `opts'
						// CheckLagList	
	local lag_list : list elmat_list | dlmat_list_full
	_sp_check_lag_list, lag_list(`lag_list')
	local n_spmat = `s(n_spmat)'
						// ParseNdata
	ParseNdata, 				///
		orig_touse(`orig_touse') 	///
		touse(`touse')			///
		depvar(`depvar') 		///
		x(`x')
	local n_data		= `s(n_data)'
	local n_excluded	= `s(n_excluded)'
	local n_missing 	= `s(n_missing)'
	local n_esample 	= `s(n_esample)'
						// display sample selection msg
	_spreg_sample_message, 			///
		n_data(`n_data')		///
		n_excluded(`n_excluded')	///
		n_missing(`n_missing')		///
		n_esample(`n_esample')		///
		n_spmat(`n_spmat')		///
		lag_list(`lag_list')		///
		`force'
						// parse -force-	
	_sp_parse_force, 		///
		`force'			///
		lag_list(`lag_list')	///
		n_spmat(`n_spmat')	///
		n_esample(`n_esample')	///
		id(`id')		///
		touse(`touse')
	local new_lag_list `s(new_lag_list)'
						// update lag_list
	_sp_update_lag_list,				///
		new_lag_list(`new_lag_list')		///
		lag_list(`lag_list')			///
		rho_lbs(`rho_lbs')			///
		elmat_list(`elmat_list')		///
		dlmat_list_full(`dlmat_list_full')	///
		wy_index(`wy_index')
	local lag_list `s(lag_list)'
	local rho_lbs `s(rho_lbs)'
	local elmat_list `s(elmat_list)'
	local dlmat_list_full `s(dlmat_list_full)'
	local wy_index `s(wy_index)'
						// check spmatrix and resort
						// data to match the ids in
						// spmatrix
	_spreg_match_id, id(`id') 	///
		touse(`touse')		///
		lag_list(`lag_list')	

						// Init wy_vars and const_var
	InitWyVars, spreg(`SPREG') wy_n(`wy_n')
	local wy_vars `s(wy_vars)'
	local const_var `s(const_var)'
						// Init WyLabels
	InitWyLabels, 				///
		id(`id')			///
		depvar(`depvar') 		///
		endog(`endog')			///
		touse(`touse')			///
		cn(`cn')			///
		cn_lb(`cn_lb')			///
		exog(`exog')			///
		exog_lbs_in(`exog_lbs')		///
		endog_lbs_in(`endog_lbs')	///
		x(`x') 				///
		wy_index(`wy_index')		///
		wy_vars(`wy_vars')		///
		const_var(`const_var')	
	local x_lbs `s(x_lbs)'
	local indeps `s(indeps)'
	local indeps_lbs `s(indeps_lbs)'
	local wy_lbs `s(wy_lbs)'
	local endog `s(endog)'
	local exog `s(exog)'
	local exog_lbs `s(exog_lbs)'
	local endog_lbs `s(endog_lbs)'
	local endog_wy_lbs `s(endog_wy_lbs)'
	local exog_wy_lbs `s(exog_wy_lbs)'
	local exog_wy_index `s(exog_wy_index)'
	local endog_wy_index `s(endog_wy_index)'
						// Update Dlmat, dlmat applied
						// only to the endogenous var
	UpdateDlmat , wy_index(`wy_index') endog(`endog') 
	local dlmat_list `s(dlmat_list)'
						// CheckColl, remove collinear
	CheckColl, exog_lbs(`exog_lbs')		///
		endog_lbs(`endog_lbs')		///
		indeps(`indeps')		///
		indeps_lbs(`indeps_lbs')	///
		exog(`exog')			///
		touse(`touse')
	local indeps `s(indeps)'
	local exog `s(exog)'
						// Parse Covariates, covariates
						// is used by margins
	ParseCovariates	, x(`x') wy_list(`wy_list') endog(`endog')	///
		depvar(`depvar')
	local covariates `s(covariates)'
						// ParseInst
	ParseInst , 				///
		depvar(`depvar') 		///
		indeps_lbs(`indeps_lbs')	///
		endog_lbs(`endog_lbs')		///
		exog_lbs(`exog_lbs')
	local exogr `s(exogr)'
	local inst `s(inst)'
	local instd `s(instd)'
					// merge dlmat_list_full and elmat_list
	local lag_list_full : list dlmat_list_full | elmat_list

						//  Parse test vars
	ExtractTestVars, indeps_lbs(`indeps_lbs')
	local test_vars `s(test_vars)'
						// CheckNoConstant
	CheckNoConstant, exog(`exog') `constant'
						// return list
	ret local depvar `depvar'	
	ret local indeps `indeps'
	ret local indeps_lbs `indeps_lbs'
	ret local rho_lbs `rho_lbs'
	ret local exog `exog'
	ret local exog_lbs `exog_lbs'
	ret local endog `endog'
	ret local endog_lbs `endog_lbs'
	ret local dlmat_list_full `dlmat_list_full'
	ret local dlmat_list `dlmat_list'
	ret local elmat_list `elmat_list'
	ret local verbose = `verbose'
	ret local log = `log'
	ret local touse `touse'
	ret local id `id'
	ret local covariates `covariates'
	ret local lag_list_full `lag_list_full'
						// return auxiliary
	ret local x `x'
	ret local x_lbs `x_lbs'
	ret local wy_list `wy_list'
	ret local wy_index `wy_index'
	ret local wy_vars `wy_vars'
	ret local wy_lbs `wy_lbs'
	ret local const_var `const_var'
	ret local wy_n = `wy_n'
	ret local endog_wy_lbs `endog_wy_lbs'
	ret local exog_wy_lbs `exog_wy_lbs'
	ret local exogr `exogr'
	ret local inst `inst'
	ret local instd `instd'
	ret local cn = `cn'
	ret local endog_wy_index `endog_wy_index'
	ret local exog_wy_index `exog_wy_index'
	ret local test_vars `test_vars'
end
					//-- ParseInst  --//
program ParseInst, sclass
	syntax [, depvar(string)	///
		indeps_lbs(string)	///
		endog_lbs(string)	///
		exog_lbs(string) ]
	
	local tmp `depvar' `indeps_lbs'
	local tmp1 `endog_lbs'
	local exogr : list tmp - tmp1

	local instd `endog_lbs'
	local tmp `depvar'
	local instd : list instd - tmp
	
	sret local exogr `exogr'
	sret local inst `exog_lbs'
	sret local instd `instd'
end
					//-- ParseCovariates  --//
program ParseCovariates, sclass
	syntax [, x(string)		///
		wy_list(string)		///
		endog(string)		///
		depvar(string)]

	local tmp `x' `wy_list' 
	local tmp : list tmp - depvar
	local tmp : list uniq tmp

	foreach var of local tmp {
		_ms_parse_parts `var'
		if(`"`r(type)'"'=="variable"){
			local covar `covar' `r(name)'			
		}
		else if(`"`r(type)'"'=="factor"){
			local covar `covar' `r(op)'.`r(name)'
		}
		else if(`"`r(type)'"'=="interaction") {
			local k	= r(k_names)
			forvalues i=1/`k' {
				if (regexm("`r(op`i')'","c")) {
					local op 
				}
				else {
					local op `r(op`i')'.
				}
				local covar  `covar' `op'`r(name`i')'
			}
		}
	}
	local covar : list uniq covar
	
	foreach var of local endog {
		_ms_parse_parts `var'
		if(`"`r(type)'"'=="variable"){
			local endog_covar `endog_covar' `r(name)'	
		}
		else if(`"`r(type)'"'=="factor"){
			local endog_covar `endog_covar' `r(op)'.`r(name)'
		}
		else if(`"`r(type)'"'=="interaction") {
			local k	= r(k_names)
			forvalues i=1/`k' {
				if (regexm("`r(op`i')'","c")) {
					local op 
				}
				else {
					local op `r(op`i')'.
				}
				local endog_covar `endog_covar' `op'`r(name`i')'
			}
		}
	}

	local covar : list covar - depvar

						//  ignore omitted interaction
						//  term
	foreach var of local covar {
		_ms_parse_parts `var'
		local op `r(op)'
		if (strpos(`"`op'"', "o")) {
			local rm `rm' `var'
		}
	}
	local covar : list covar - rm

	sret local covariates `covar'	
end

					//-- CheckColl, remove collinear terms
program CheckColl, sclass
	syntax , touse(string)		///
		[ exog_lbs(string)	///
		endog_lbs(string)	///
		indeps(string)		///
		indeps_lbs(string)	///
		exog(string)]

	local both : list exog_lbs & endog_lbs
	foreach var of local both {
		di as error "{bf:`var'} is included in both exogenous and " ///
			"endogenous variable lists"
		exit(498)
	}
						// rmcoll in indeps	
	qui _rmcoll `indeps' if `touse', noconstant expand
	local indeps	= `"`r(varlist)'"'
	collinear_msg , vars(`indeps') vars_lbs(`indeps_lbs')
						// rmcoll in exog
	qui _rmcoll `exog' if `touse', noconstant expand
	local exog	= `"`r(varlist)'"'

	sret local indeps `indeps'
	sret local exog `exog'
end
					//-- collinear error message  --//
program collinear_msg, sclass
	syntax [, vars(string) 		///
		vars_lbs(string)]

	foreach var of local vars {
		_ms_parse_parts `var'
		local omit	= r(omit)
		local op	= r(op)
		local type `r(type)'
		if ( `omit' & 				///
			(`"`type'"'!="factor") &	///
			(`"`type'"'!="interaction") ){
			local pos 	: list posof `"`var'"' in vars
			local var_lb	: word `pos' of `vars_lbs'
			di as txt 	///
				"note: `var_lb' omitted because of collinearity"
		}
	}
end
					//-- UpdateDlmat --//
program UpdateDlmat, sclass
	syntax [,wy_index(string) endog(string)]

	_parse expand wy_index tmp : wy_index

	forvalues i = 1/`wy_index_n' {
		gettoken w y	: wy_index_`i', parse(", ")
		gettoken tmp y	: y, parse(", ")

		local wy_endog : list y in endog
		if (`wy_endog') {
			local dlmat_list `dlmat_list' `w'
		}
	}
	local dlmat_list : list uniq dlmat_list
	sret local dlmat_list	= trim(`"`dlmat_list'"')
end
					//-- InitWyLabels --//
program InitWyLabels, sclass
	syntax	, id(string)		/// 
		depvar(string) 		///
		endog(string)		///
		touse(string)		///
		cn(string)		///
		[cn_lb(string)		///
		x(string) 		///
		exog(string)		///
		exog_lbs_in(string)	///
		endog_lbs_in(string)	///
		wy_index(string)	///
		wy_vars(string)		///
		const_var(string) ]
						// x
	foreach var of local x {
		local x_lbs `x_lbs' `depvar':`var'
	}
						// wy_index
	_parse expand wy_index tmp : wy_index
	forvalues i=1/`wy_index_n' {
		gettoken w y : wy_index_`i', parse(", ")
		gettoken tmp y: y, parse(", ")
		local y	= strtrim(`"`y'"')
		local y : subinstr local y " " "" ,all
		local var : word `i' of `wy_vars'
							// generate spatial lag	
		getSpLag, var(`var') w(`w') y(`y') touse(`touse') id(`id')
		local lb	= trim(`"(`w'"'+`"*"'+`"`y')"')
		local lbs	= `"`lbs' "'+ `"`lb'"'
		label var `var' `"`lb'"'

		local wy_endog : list y in endog
		if (`wy_endog') {
						// endogenous wy
			local endog_wy `endog_wy' `var'	
			local endog_lbs `endog_lbs' `lb'
			local endog_wy_lbs `endog_wy_lbs' endog*`w':`y'
			local endog_wy_index  `endog_wy_index' || `wy_index_`i''
		}
		else {
						// exogenous wy			
			local exog_wy `exog_wy' `var'	
			local exog_lbs `exog_lbs' `lb'
			local exog_wy_lbs `exog_wy_lbs' exog*`w':`y'
			local exog_wy_index `exog_wy_index' || 		///
				`wy_index_`i''
		}
	}
						// constant term
	if (`cn' == 1) {
		qui gen byte `const_var' = 1
		local cn_lb `depvar':`cn_lb'
		local indeps	= trim(`"`x' "' + "`const_var' "	///
			+ `"`exog_wy' "' + `"`endog_wy'"')
		local indeps_lbs= trim(`"`x_lbs' "'+ "`cn_lb' " 	///
			+`"`exog_wy_lbs' "'+`"`endog_wy_lbs'"')
	}
	else {
		local indeps	= trim(`"`x' "' 	///
			+ `"`exog_wy' "' + `"`endog_wy'"')
		local indeps_lbs= trim(`"`x_lbs' "' 	///
			+`"`exog_wy_lbs' "'+`"`endog_wy_lbs'"')
	}
		
	local wy_lbs	= trim(`"`lbs'"')
	local endog	= trim(`"`endog' "' + `"`endog_wy'"')
	local exog	= trim(`"`exog' "' + `"`exog_wy'"')
	local exog_lbs	= trim(`"`exog_lbs_in' "' + `"`exog_lbs'"')
	if (`cn'==1) {
		local exog	= trim(`"`exog' "'+`"`const_var'"')
		local exog_lbs	= trim(`"`exog_lbs' "' + `"`cn_lb'"')
	}
	local endog_lbs		= trim(`"`endog_lbs_in' "' + `"`endog_lbs'"')
	local endog_wy_lbs	= trim(`"`endog_wy_lbs'"')
	local exog_wy_lbs	= trim(`"`exog_wy_lbs'"')
	local endog_wy_index	= trim(`"`endog_wy_index'"')
	local exog_wy_index	= trim(`"`exog_wy_index'"')

	sret local x_lbs `x_lbs'
	sret local indeps `indeps'
	sret local indeps_lbs `indeps_lbs'
	sret local wy_lbs `wy_lbs'
	sret local endog `endog'
	sret local exog `exog'
	sret local exog_lbs `exog_lbs'
	sret local endog_lbs `endog_lbs'
	sret local endog_wy_lbs `endog_wy_lbs'
	sret local exog_wy_lbs `exog_wy_lbs'
	sret local endog_wy_index `endog_wy_index'
	sret local exog_wy_index `exog_wy_index'
end
						//-- get spatial lag --//
program getSpLag 
	syntax , id(string) touse(string) var(string) w(string) y(string)
	
	_ms_parse_parts `y'
	local flag	= 0
	if ("`r(type)'"=="factor" & r(base)==1 ) {
		local flag	= 1
	}
	else if ("`r(type)'"=="interaction") {
		local k		= r(k_names)
		forvalues i = 1/`k' {
			if ( r(base`i')==1 & `flag' == 0 ) {
				local flag = 1
			}
		}
	}

	if (`flag' ==0) {
		spmatrix lag double `var' `w' `y' if `touse', id(`id')
	}
	else {
		qui gen byte `var'	= 0 if `touse'
	}
end

					//-- Init wy_vars and const vars  --//
program InitWyVars, sclass
	syntax , spreg(string) wy_n(integer)	
	
	if (`wy_n' != 0) {
		forvalues i =1/`wy_n' {
			local wy_vars `wy_vars' `spreg'_wy_`i'
		}
	}

	local const_var `spreg'_const_var

	sret local wy_vars `wy_vars'
	sret local const_var `const_var'
end


					//-- Parse ivarlag recursively--//
program ParseIvarlag
	syntax , depvar(string)		///
		endog(string)		///
		touse(string)		///
		id(string)		///
		[IVARLag(string)	///
		raw_inst(string)	///
		ivarlag_out(string)	///
		wy_out(string)		///
		*]	

	if (!ustrregexm(`"`options'"', "ivarlag\((.*)\)")) {
		ParseOneIvarlag, 			///
			depvar(`depvar') 		///
			touse(`touse') 			///
			ivarlag(`ivarlag')		///
			ivarlag_out(`ivarlag_out')	///
			wy_out(`wy_out')
		local dlmat_list_full `s(dlmat_list_full)'
		local wy_list	`s(wy_list)'

		ParseIvarlagIndex, 				///
			endog(`endog')				///
			raw_inst(`raw_inst')			///
			depvar(`depvar')			///
			id(`id')				///
			touse(`touse')				///
			dlmat_list_full(`dlmat_list_full')	///
			wy_list(`wy_list')			///
			`options'
	}
	else { 
		ParseOneIvarlag,			///
			depvar(`depvar')		///
			touse(`touse') 			///
			ivarlag(`ivarlag')		///
			ivarlag_out(`ivarlag_out')	///
			wy_out(`wy_out')
		local ivarlag_out `s(dlmat_list_full)'
		local wy_out `s(wy_list)'

		ParseIvarlag, 				///
			depvar(`depvar') 		///
			endog(`endog')			///
			touse(`touse') 			///
			ivarlag_out(`ivarlag_out')	///
			id(`id')			///
			wy_out(`wy_out')		///
			raw_inst(`raw_inst')		///
			`options'
	}
end
					//-- Parse Dvarlag recursively--//
program ParseDvarlag
	syntax , depvar(string)		///
		endog(string)		///
		touse(string)		///
		id(string)		///
		[DVARLag(string)	///
		varlag_out(string)	///
		wy_out(string)		///
		* ]	

	if (!ustrregexm(`"`options'"', "dvarlag\((.*)\)")) {
		ParseOneDvarlag, 			///
			depvar(`depvar') 		///
			touse(`touse') 			///
			dvarlag(`dvarlag')		///
			varlag_out(`varlag_out')	///
			wy_out(`wy_out')
		local dlmat_list_full `s(dlmat_list_full)'
		local wy_list	`s(wy_list)'

		ParseDvarlagIndex, 				///
			endog(`endog')				///
			depvar(`depvar')			///
			id(`id')				///
			touse(`touse')				///
			dlmat_list_full(`dlmat_list_full')	///
			wy_list(`wy_list')			///
			`options'
	}
	else { 
		ParseOneDvarlag,			///
			depvar(`depvar')		///
			touse(`touse') 			///
			dvarlag(`dvarlag')		///
			varlag_out(`varlag_out')	///
			wy_out(`wy_out')
		local varlag_out `s(dlmat_list_full)'
		local wy_out `s(wy_list)'

		ParseDvarlag, 				///
			depvar(`depvar') 		///
			endog(`endog')			///
			touse(`touse') 			///
			varlag_out(`varlag_out')	///
			id(`id')			///
			wy_out(`wy_out')		///
			`options'
	}
end
					//-- Parse Dvarlag Index --//
program ParseDvarlagIndex, sclass
	syntax , 			 	///
		endog(string)			///
		depvar(string)			///
		id(string)			///
		touse(string)			///
		[dlmat_list_full(string)	///
		wy_list(string)			///
		*]

	_parse expand dlmat_list_full tmp : dlmat_list_full
	_parse expand wy_list tmp : wy_list

	local wy_n	= 0
	forvalues i = 1(1)`dlmat_list_full_n' {
		local w_i `dlmat_list_full_`i''
		local wy_i `wy_list_`i'' 
		foreach w of local w_i {
			foreach y of local wy_i {
				local A `"`w', `y'"'
				local B `"`wy_index'"'
				local in = ustrpos(`"`B'"', `"`A'"')
				if (`in' == 0) {
					local wy_index	=	///
					trim(`"`wy_index'"' + `" `w', `y' ||"')
					local wy_n	= `wy_n' + 1
				}
			}
		}
	}

	local dlmat_list_full : subinstr local dlmat_list_full "||" "", all	
	local wy_list : subinstr local wy_list "||" "", all
	local dlmat_list_full : list uniq dlmat_list_full
	local wy_list : list uniq wy_list
	local dlmat_list_full = trim(`"`dlmat_list_full'"')
	local wy_list	= trim(`"`wy_list'"')

	sret local wy_index `wy_index'
	sret local dlmat_list_full `dlmat_list_full'
	sret local wy_list `wy_list'
	sret local wy_n	= `wy_n'
	sret local opts `options'
end

					//-- Parse Ivarlag Index --//
program ParseIvarlagIndex, sclass
	syntax , 			 	///
		endog(string)			///
		depvar(string)			///
		id(string)			///
		touse(string)			///
		[dlmat_list_full(string)	///
		wy_list(string)			///
		raw_inst(string)		///
		*]

	_parse expand dlmat_list_full tmp : dlmat_list_full
	_parse expand wy_list tmp : wy_list

	local wy_n	= 0
	forvalues i = 1(1)`dlmat_list_full_n' {
		local w_i `dlmat_list_full_`i''
		local wy_i `wy_list_`i'' 
		foreach w of local w_i {
			foreach y of local wy_i {
				CheckEndogWX, 			///
					wx(`y') 		///
					endog(`endog')		///
					raw_inst(`raw_inst')	///
					depvar(`depvar')
				local A `"`w', `y'"'
				local B `"`wy_index'"'
				local in = ustrpos(`"`B'"', `"`A'"')
				if (`in' == 0) {
					local wy_index	=	///
					trim(`"`wy_index'"' + `" `w', `y' ||"')
					local wy_n	= `wy_n' + 1
				}
			}
		}
	}

	local dlmat_list_full : subinstr local dlmat_list_full "||" "", all	
	local wy_list : subinstr local wy_list "||" "", all
	local dlmat_list_full : list uniq dlmat_list_full
	local wy_list : list uniq wy_list
	local dlmat_list_full = trim(`"`dlmat_list_full'"')
	local wy_list	= trim(`"`wy_list'"')

	sret local wy_index `wy_index'
	sret local dlmat_list_full `dlmat_list_full'
	sret local wy_list `wy_list'
	sret local wy_n	= `wy_n'
	sret local opts `options'
end

					//-- CheckEndogWX  --//
program CheckEndogWX
	syntax,		 	///
		wx(string)	///
		endog(string) 	///
		depvar(string)	///
		[raw_inst(string)]

	ExtractEndogList, endog(`endog')
	local endog `s(endog_list)'
	local depvar `depvar'
	
	_ms_parse_parts `wx'
	local k	= r(k_names)	
	if (`k'==.) {
		local isendog : list wx in endog
		local isinst  : list wx in raw_inst
		local isdepvar : list wx in depvar
	}
	else {
		local isendog	= 0
		local isinst	= 0
		local isdepvar	= 0
		forvalues i=1/`k' {
			local var `r(name`i')'
			local flag : list var in endog
			local isendog	= `flag' + `isendog' 

			local flag : list var in raw_inst
			local isinst	= `flag' + `isinst' 

			local flag : list var in depvar
			local isdepvar	= `flag' + `isdepvar' 
		}
	}

	if (`isdepvar') {
		di as err "dependent variable {it:`depvar'} not allowed " ///
			"in {bf:ivarlag()}"
		di as err "use {bf:dvarlag()} to specify a spatial lag of " ///
			" the dependent variable"
		exit 198
	}

	if (`isendog') {
		di as err "option {bf:ivarlag()} does not allow "	///
			"endogenous covariates {it:`wx'}"
		exit 198
	}

	if (`isinst') {
		di as err "option {bf:ivarlag()} does not allow "	///
			"instrumental variables {it:`wx'}"
		exit 198
	}
end
					//-- extract endog list as
					//individual variables 
program ExtractEndogList, sclass
	syntax [,endog(string)]
	
	if (`"`endog'"'=="") exit

	foreach var of local endog {
		_ms_parse_parts `var'
		local k	= r(k_names)
		if (`k'!= .) {
			forvalues i=1/`k' {
				local endog_list `endog_list' `r(name`i')'
			}
		}
		else {
			local endog_list `endog_list' `r(name)'
		}
	}
	local endog_list : list uniq endog_list
	sret local endog_list `endog_list'
end

					//-- Parse One dvarlag --//
program ParseOneDvarlag, sclass
	sret clear
	syntax , [ DVARLag(string)]	///
		depvar(string) 		///
		touse(string)		///
		[varlag_out(string)	///
		wy_out(string)]
	
	if (`"`dvarlag'"' == "") { 
		sret local dlmat_list_full `varlag_out'
		sret local wy_list `wy_out'
		exit
	}

	local w `dvarlag'
	local wy_list `depvar'

	local n_w : word count `w'
	if (`n_w'>1) {
		di as err "option {bf:dvarlag()} allows only "	///
			`"one weighting matrix"'
		exit(198)
	}

	local 0 `wy_list'
	capture syntax varlist(numeric fv)
	if _rc {
		di as err "option {bf:dvarlag()} contains "	///
			`"invalid variables "'
		exit(198)
	}

	local dlmat_list_full = trim(`"`varlag_out'"' + `" `w' ||"')
	local wy_list	= trim(`"`wy_out'"' + `" `wy_list' ||"')

	sret local dlmat_list_full `dlmat_list_full'
	sret local wy_list `wy_list'
end

					//-- Parse One ivarlag --//
program ParseOneIvarlag, sclass
	sret clear
	syntax , [ IVARLag(string)]	///
		depvar(string) 		///
		touse(string)		///
		[ivarlag_out(string)	///
		wy_out(string)]
	
	if (`"`ivarlag'"' == "") {	
		sret local dlmat_list_full `ivarlag_out'	
		sret local wy_list `wy_out'	
		exit
	}

	gettoken w wy_list : ivarlag , parse(":")
	gettoken tmp wy_list : wy_list, parse(":")

	local n_w : word count `w'
	if (`n_w'>1) {
		di as err "option {bf:ivarlag()} allows only "	///
			`"one weighting matrix"'
		exit(198)
	}
	
	qui fvexpand `wy_list' if `touse'
	local wy_list `r(varlist)'

	if(`"`wy_list'"'=="") {
		di as error "option {bf:ivarlag()} requires a varlist"
		exit(198)
	}

	local 0 `wy_list'
	capture syntax varlist(numeric fv)
	if _rc {
		di as err "option {bf:ivarlag()} contains "	///
			`"invalid variables "'
		exit(198)
	}

	local dlmat_list_full = trim(`"`ivarlag_out'"' + `" `w' ||"')
	local wy_list	= trim(`"`wy_out'"' + `" `wy_list' ||"')

	sret local dlmat_list_full `dlmat_list_full'
	sret local wy_list `wy_list'
end

					//-- CheckExtraOptions --//
program CheckExtraOptions
	syntax [, *]
	if (`"`options'"'!="") {
		di as error "option {bf:`options'} not allowed"
		exit(198)
	}
end
					//-- Parse Verbose and log  --//
program ParseVerbose, sclass
	syntax [, Verbose NOLOg LOg]

	if ("`verbose'"=="verbose") {
		local verbose	= 1
	}
	else {
		local verbose 	= 0
	}

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if ("`log'"=="nolog"){
		local log	= 0
	}
	else {
		local log	= 1
	}
	sret local verbose = `verbose'
	sret local log = `log'
end
					//-- Parse Constant --//
program ParseConst, sclass
	syntax  [, noCONstant]

	if (`"`constant'"'=="noconstant") {
		local cn = 0		
		local cn_lb
	} 
	else {
		local cn = 1
		local cn_lb _cons
	}
	sret local cn `cn'
	sret local cn_lb `cn_lb'
end
					//-- Parse Elmat  --//
program ParseErrorlag, sclass
	syntax , id(string) 		///
		touse(string)		///
		depvar(string)		///
		[ ERRorlag(string) 	///
		elmat_list(string)	///
		* ]

	if (!ustrregexm(`"`options'"', "errorlag\((.*)\)")) {
		ParseOneErrorlag,			///
			id(`id')			///
			touse(`touse')			///
			depvar(`depvar')		///
			errorlag(`errorlag')		///
			elmat_list(`elmat_list')	
		local elmat_list `s(elmat_list)'

		local elmat_list : list uniq elmat_list
		foreach w of local elmat_list {
			local rho_lbs `rho_lbs' rho*`w':e.`depvar'
		}
		local rho_lbs = trim(`"`rho_lbs'"')

		sret local elmat_list `elmat_list'
		sret local rho_lbs `rho_lbs'
		sret local opts `options'
	}
	else {
		ParseOneErrorlag,			///
			id(`id')			///
			touse(`touse')			///
			depvar(`depvar')		///
			errorlag(`errorlag')		///
			elmat_list(`elmat_list')	
		local elmat_list `s(elmat_list)'

		ParseErrorlag,				///
			id(`id')			///
			touse(`touse')			///
			depvar(`depvar')		///
			elmat_list(`elmat_list')	///
			`options'
	}
end
					//-- Parse One Errorlag  --//
program ParseOneErrorlag, sclass
	sret clear
	syntax , id(string) 		///
		touse(string)		///
		depvar(string)		///
		[ ERRorlag(string) 	///
		elmat_list(string)	///
		]
	
	if (`"`errorlag'"'=="") {
		sret local elmat_list `elmat_list'	
		exit
	}

	gettoken errorlag tmp : errorlag, parse(",")	
	if (`"`tmp'"'!="") {
		di as err "option {bf:errorlag()} does not allow options"
		exit(198)
	}

	local w `errorlag'
	local n_w : word count `w'
	if (`n_w'>1) {
		di as err "option {bf:errorvarlag()} allows only " ///
			`"one weighting matrix"'
		exit(198)
	}

	local elmat_list `elmat_list' `errorlag' 
	sret local elmat_list `elmat_list'
end

					//-- Parse equation --//
program ParseEq, sclass
	syntax anything(name=eq)	

	_iv_parse `eq'
	local depvar `s(lhs)'

	local x `s(endog)' `s(exog)'
	fvexpand `x' 
	local x `r(varlist)'

	local raw_inst `s(inst)'
	fvexpand `raw_inst'
	local raw_inst `r(varlist)'

	local exog `s(exog)' `s(inst)'
	fvexpand `exog'
	local exog `r(varlist)'

	local endog `s(lhs)' `s(endog)'
	fvexpand `endog'
	local endog `r(varlist)'

	local endog_lbs `endog'
	local exog_lbs `exog'

	CheckIdent, x(`x') exog(`exog')

	Check_FV_X `x'

	sret clear
	sret local depvar `depvar'
	sret local x `x'
	sret local exog `exog'
	sret local endog `endog'
	sret local endog_lbs `endog_lbs'
	sret local exog_lbs `exog_lbs'
	sret local raw_inst `raw_inst'
end
					//-- Check Identification --//
program CheckIdent
	syntax [, x(string)	///
		exog(string)]
	
	local n_x	: list sizeof x
	local n_exog	: list sizeof exog

	if (`n_exog' < `n_x') {
		di "{p 0 0 2}"
		di as err "equation not identified; must have at least " ///
			"as many instruments not in the regression as "	///
			"there are instrumented variables"
		di "{p_end}"
		exit 481
	}
end
					//--  Check_FE_X --//
program Check_FV_X 
	syntax [varlist(default=none numeric fv)]
end
					//-- Extract variables in wald test --//
program ExtractTestVars, sclass
	syntax [,indeps_lbs(string)]

	foreach var of local indeps_lbs {
		gettoken tmp testVar : var , parse(":")
		gettoken tmp testVar : testVar, parse(":")
		if (`"`testVar'"'!="_cons") {
			local test_vars `test_vars' `testVar'
		}
	}

	local test_vars : list uniq test_vars
	sret local test_vars `test_vars'
end
					//-- NoObsError --//
program NoObsError
	syntax [, touse(string)	]
	qui sum `touse' if `touse'
	local n_obs	= r(N)
	if (`n_obs'==0) {
		di as error "insufficient observations"
		exit(2001)
	}
end
					//-- ParseNdata--//
program ParseNdata, sclass
	syntax , orig_touse(string)	///
		touse(string)		///
		depvar(string)		///
		[x(string)]

	qui count
	local n_data = r(N)

	qui count if !`orig_touse'
	local n_excluded = r(N)

	qui count if `touse'
	local n_esample = r(N)

	local n_missing = `n_data' - `n_esample' - `n_excluded' 

	sret local n_data = `n_data'
	sret local n_excluded = `n_excluded'
	sret local n_missing = `n_missing'
	sret local n_esample = `n_esample'
end
					//-- CheckNoConstant --//
program CheckNoConstant 
	syntax [, exog(string)	///
		noCONstant]
	
	if (`"`constant'"'=="noconstant" & `"`exog'"'=="") {
		di "{p 0 0 2}"
		di as err "one or more variables must be specified "	///
			"in indepvars when the option {bf:noconstant} "	///
			"is specified"
		di "{p_end}"
		exit 198
	}
end
