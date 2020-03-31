*! version 1.1.0  25apr2018
// _spxtreg_common_parse parse some common options in -spxtreg, fe- and
// -spxterg, re- .
//
// o. This program will call _spxtreg_match_id, which will resort the data to
// match ids in weighting matrix.
//
// o. This program must be called by a program with sortpreserve property
//
//	syntax SPXTREG, touse(string) :			///
//		anything(name=eq id="spxtreg varlist")	///	
//		[, id(passthru)				///
//		noCONstant				///
//		IElag(passthru)				///
//		force					///
//		*]
//
//	options * contains repeatable ivarlag(), errorlag(), dvarlag()
//
// The output is a r-class consisting of the following members
						// return list
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
//		touse 
//		id 
//		timevar 
//		panelvar
//		timevalues 
//		covariates 
//		lag_list_full 
//		log
//			       			// return auxiliary
//		x 
//		x_lbs 
//		wy_list 
//		wy_index 
//		wy_vars 
//		wy_lbs 
//		wy_n 
//		endog_wy_lbs 
//		exog_wy_lbs 
//		endog_wy_index 
//		exog_wy_index 
//		test_vars 


program _spxtreg_common_parse, rclass
	version 15.0
	
	_on_colon_parse `0'
	local 0 `s(before)'
	syntax anything(name=SPXTREG), touse(string)

	local 0 `s(after)'
	syntax	anything(name=eq		///
		id = "spxtreg varlist")		///
		[, IElag(passthru)		///
		noCONstant			///
		NOLOg LOg			///
		force				///
		Verbose				/// undocumented
		*]				//  options is ivarlag(),
						// dvarlag(), and errorlag()
						// They are all repeatable
	tempvar orig_touse
	qui gen byte `orig_touse' = `touse'

						//  Check noObs
	NoObsError, touse(`touse')
						// parse panelvar and timevar
	ParseXtvar, touse(`touse')
	local timevar `s(timevar)'
	local timevalues `s(timevalues)'
	local panelvar `s(panelvar)'
						// parse depvar and x
	ParseEq `eq'
	local depvar `s(depvar)'
	local x `s(x)'
	local exog `s(exog)'
	local endog `s(endog)'
	local endog_lbs `s(endog_lbs)'
	local exog_lbs `s(exog_lbs)'
						// parse ID
	__sp_parse_id, `id'
	local id `s(id)'
						// parse verbose and log
	ParseVerbose ,  `verbose' `log' `nolog'
	local verbose = `s(verbose)'
	local log = `s(log)'
						// parse constant
	ParseConst, `constant'
	local cn = `s(cn)'
	local cn_lb `s(cn_lb)'
						// parse ivarlag
	ParseIvarlag, 				///
		depvar(`depvar') 		///
		endog(`endog') 			///
		touse(`touse') 			///
		id(`id')			///
		timevar(`timevar')		///
		timevalues(`timevalues')	///
		`options'
	local wy_index `s(wy_index)'
	local dlmat_list_full `s(dlmat_list_full)'
	local wy_list `s(wy_list)'
	local wy_n = `s(wy_n)'
	local opts `s(opts)'
						// get missing id and time
	tempvar mi_time
	UpdateTouseMissing, id(`id')		///
		timevar(`timevar')		///
		depvar(`depvar')		///
		x(`x')				///
		wy_list(`wy_list')		///
		mi_time(`mi_time')		///
		panelvar(`panelvar')		///
		touse(`touse')
						// parse dvarlag
	ParseDvarlag, 				///
		depvar(`depvar') 		///
		endog(`endog') 			///
		touse(`touse') 			///
		id(`id')			///
		timevar(`timevar')		///
		timevalues(`timevalues')	///
		`opts'
	local wy_index `wy_index' `s(wy_index)'
	local dlmat_list_full `dlmat_list_full' `s(dlmat_list_full)'
	local dlmat_list_full : list uniq dlmat_list_full
	local wy_list `wy_list' `s(wy_list)'
	local wy_n = `s(wy_n)'+`wy_n'
	local opts `s(opts)'
						// parse errorlag
	ParseErrorlag , 			///
		id(`id') 			///
		touse(`touse') 			///
		depvar(`depvar') 		///
		timevar(`timevar')		///
		timevalues(`timevalues')	///
		`opts'
	local elmat_list `s(elmat_list)'
	local rho_lbs `s(rho_lbs)'
	local opts `s(opts)'
						// check extra options
 	CheckExtraOptions, `opts'
					// merge dlmat_list_full and elmat_list
	local lag_list_full : list dlmat_list_full | elmat_list
	local lag_list_full : list lag_list_full | ulmat_list
						// UpdateTouse
	UpdateTouse, touse(`touse')		///
		mi_time(`mi_time')		///
		lag_list_full(`lag_list_full')	///
		timevar(`timevar')		///
		panelvar(`panelvar')
	local timevalues `s(timevalues)'
						// CheckLagList
	_sp_check_lag_list, lag_list(`lag_list_full')
	local n_spmat = `s(n_spmat)'
						// ParseNdata
	ParseNdata,				///
		orig_touse(`orig_touse')	///
		touse(`touse')			///
		timevar(`timevar')		///
		panelvar(`panelvar')		///
		timevalues(`timevalues')
	local n_data		= `s(n_data)'
	local n_excluded	= `s(n_excluded)'
	local n_missing		= `s(n_missing)'
	local n_esample		= `s(n_esample)'
	local n_esample_t	= `s(n_esample_t)'

						// display sample selection msg
	_spxtreg_sample_message, 		///
		n_data(`n_data')		///
		n_excluded(`n_excluded')	///
		n_missing(`n_missing')		///
		n_esample(`n_esample')		///
		n_esample_t(`n_esample_t')	///
		n_spmat(`n_spmat')		///
		lag_list(`lag_list_full')	///
		panelvar(`id')			///
		timevar(`timevar')		///
		timevalues(`timevalues')	///
		touse(`touse')			///
		`force'
	
						// parse touse_t
	tempvar touse_t
	qui gen byte `touse_t' = 0
	local time1 : word 1 of `timevalues'
	qui replace `touse_t' = 1 if `touse' & `timevar' == `time1'
						// parse -force- 
	_sp_parse_force, 			///
		`force'				///
		lag_list(`lag_list_full')	///
		n_spmat(`n_spmat')		///
		n_esample(`n_esample_t')	///
		id(`id')			///
		touse(`touse_t')
	local new_lag_list `s(new_lag_list)'
						// update lag_list
	_sp_update_lag_list,				///
		new_lag_list(`new_lag_list')		///
		lag_list(`lag_list_full')		///
		rho_lbs(`rho_lbs')			///
		elmat_list(`elmat_list')		///
		dlmat_list_full(`dlmat_list_full')	///
		wy_index(`wy_index')
	local lag_list_full `s(lag_list)'
	local rho_lbs `s(rho_lbs)'
	local elmat_list `s(elmat_list)'
	local dlmat_list_full `s(dlmat_list_full)'
	local wy_index `s(wy_index)'
						// check spmat and resort data
						// to match the ids in spmat
	_spxtreg_match_id, id(`id')		///
		touse(`touse')			///
		lag_list(`lag_list_full')	///
		timevar(`timevar')		///
		timevalues(`timevalues')
						// Init wy_vars 
	InitWyVars, spreg(`SPXTREG') wy_n(`wy_n')
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
		timevar(`timevar')		///
		timevalues(`timevalues')	///
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
	local exog `s(exog)'
	local indeps `s(indeps)'
						// Parse Covariates, covariates
						// is used by margins
	ParseCovariates	, x(`x') wy_list(`wy_list') endog(`endog')	///
		depvar(`depvar') timevar(`timevar')
	local covariates `s(covariates)'
						//  Parse test vars
	ExtractTestVars, indeps_lbs(`indeps_lbs')
	local test_vars `s(test_vars)'
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
	ret local touse `touse'
	ret local id `id'
	ret local timevar `timevar'
	ret local panelvar `panelvar'
	ret local timevalues `timevalues'
	ret local covariates `covariates'
	ret local lag_list_full `lag_list_full'
	ret local log	= `log'
	ret local verbose = `verbose'
	ret local ulmat_list `ulmat_list'
	ret local rho_u_lbs `rho_u_lbs'
						// return auxiliary
	ret local x `x'
	ret local x_lbs `x_lbs'
	ret local wy_list `wy_list'
	ret local wy_index `wy_index'
	ret local wy_vars `wy_vars'
	ret local wy_lbs `wy_lbs'
	ret local wy_n = `wy_n'
	ret local endog_wy_lbs `endog_wy_lbs'
	ret local exog_wy_lbs `exog_wy_lbs'
	ret local endog_wy_index `endog_wy_index'
	ret local exog_wy_index `exog_wy_index'
	ret local test_vars `test_vars'
	ret local cn `cn'
end
					//-- ParseEq  --//
program ParseEq, sclass
	syntax varlist(default=none numeric fv)
	gettoken depvar x : varlist
	_fv_check_depvar `depvar'
	fvexpand `x'	
	local x `r(varlist)'

	sret local depvar `depvar'
	sret local x `x'
	sret local exog `x'
	sret local endog `depvar'
	sret local endog_lbs `depvar'
	sret local exog_lbs `x'
end
					//-- ParseXtvar --//
program ParseXtvar, sclass
	syntax , touse(string)
	capture _xt
	if (_rc!=0) {
		di as err "must specify panelvar; use {bf:xtset}"	
		exit _rc
	}
	local timevar `_dta[_TStvar]'
	sret local timevar `timevar'

	local panelvar `_dta[_TSpanel]'
	sret local panelvar `panelvar'
	
	if (`"`timevar'"'!="") {
		qui summarize `panelvar' if `touse'
		local id_min = r(min)
		tempvar touse_tmp
		qui gen `touse_tmp' = 0
		qui replace `touse_tmp' = 1 if `touse' & `panelvar' == `id_min'
		mata : get_timevalues(`"`timevar'"', `"`touse_tmp'"')
	}
	else {
		di as error "must specify timevar; use {bf:xtset}"	
		exit 498
	}
end
					//-- CheckExtraOptions --//
program CheckExtraOptions
	syntax [, *]
	if (`"`options'"'!="") {
		di as error "option {bf:`options'} not allowed"
		exit(198)
	}
end
					//-- Init wy_vars  --//
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
					//-- InitWyLabels --//
program InitWyLabels, sclass
	syntax	, 			///
		id(string)		///
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
		const_var(string) 	///
		timevar(string)		///
		timevalues(string)]
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
		_spxtreg_get_splag, var(`var') w(`w') y(`y') touse(`touse') ///
			timevar(`timevar') timevalues(`timevalues') id(`id')
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

	sret local exog `exog'
	sret local indeps `indeps'
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
					//-- ParseCovariates  --//
program ParseCovariates, sclass
	syntax [, x(string)		///
		wy_list(string)		///
		endog(string)		///
		depvar(string)		///
		timevar(string)]

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

	local covar : list covar -  depvar

	if (`"`timevar'"'!="") {
		cap fvexpand i.`timevar'	
		local timevars `r(varlist)'
		local covar : list covar - timevars
		local covar : list covar - timevar
	}
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
					//-- Parse Verbose and log  --//
program ParseVerbose, sclass
	syntax [, Verbose NOLOg LOg ]

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if ("`log'"=="nolog"){
		local log	= 0
	}
	else {
		local log	= 1
	}
	sret local log = `log'

	if ("`verbose'"=="verbose") {
		local verbose	= 1	
	}
	else {
		local verbose	= 0
	}
	sret local verbose = `verbose'
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
					//-- Parse ivarlag recursively--//
program ParseIvarlag
	syntax , depvar(string)		///
		endog(string)		///
		touse(string)		///
		id(string)		///
		[IVARLag(string)	///
		ivarlag_out(string)	///
		wy_out(string)		///
		timevar(string)		///
		timevalues(string)	///
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
			depvar(`depvar')			///
			id(`id')				///
			touse(`touse')				///
			dlmat_list_full(`dlmat_list_full')	///
			wy_list(`wy_list')			///
			timevar(`timevar')			///
			timevalues(`timevalues')		///
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
			timevar(`timevar')		///
			timevalues(`timevalues')	///
			`options'
	}
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
		timevar(string)			///
		timevalues(string)		///
		*]

	_parse expand dlmat_list_full tmp : dlmat_list_full
	_parse expand wy_list tmp : wy_list

	local wy_n	= 0
	forvalues i = 1(1)`dlmat_list_full_n' {
		local w_i `dlmat_list_full_`i''
		local wy_i `wy_list_`i'' 
		foreach w of local w_i {
			foreach y of local wy_i {
				CheckEndogWX, 		///
					wx(`y') 	///
					endog(`endog')	///
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
					//-- Parse Dvarlag recursively--//
program ParseDvarlag
	syntax , depvar(string)		///
		endog(string)		///
		touse(string)		///
		id(string)		///
		[DVARLag(string)	///
		varlag_out(string)	///
		wy_out(string)		///
		timevar(string)		///
		timevalues(string)	///
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
			timevar(`timevar')		///
			timevalues(`timevalues')	///
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
			timevar(`timevar')		///
			timevalues(`timevalues')	///
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
		timevar(string)			///
		timevalues(string)		///
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
					//-- Parse Elmat  --//
program ParseErrorlag, sclass
	syntax , id(string) 		///
		touse(string)		///
		depvar(string)		///
		[ ERRorlag(string) 	///
		elmat_list(string)	///
		timevar(string)		///
		timevalues(string)	///
		* ]

	if (!ustrregexm(`"`options'"', "errorlag\((.*)\)")) {
		ParseOneErrorlag,			///
			id(`id')			///
			touse(`touse')			///
			depvar(`depvar')		///
			errorlag(`errorlag')		///
			timevar(`timevar')		///
			timevalues(`timevalues')	///
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
			timevar(`timevar')		///
			timevalues(`timevalues')	///
			elmat_list(`elmat_list')	
		local elmat_list `s(elmat_list)'

		ParseErrorlag,				///
			id(`id')			///
			touse(`touse')			///
			depvar(`depvar')		///
			elmat_list(`elmat_list')	///
			timevar(`timevar')		///
			timevalues(`timevalues')	///
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
		timevar(string)		///
		timevalues(string)	///
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
	if (`n_w'!=1) {
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

	gettoken dvarlag tmp : dvarlag, parse(",")	
	if (`"`tmp'"'!="") {
		di as err "option {bf:dvarlag()} does not allow options"
		exit(198)
	}

	local w `dvarlag'
	local wy_list `depvar'

	local n_w : word count `w'
	if (`n_w'!=1) {
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
					//-- CheckEndogWX  --//
program CheckEndogWX
	syntax, wx(string) endog(string) depvar(string)

	ExtractEndogList, endog(`endog')
	local endog `s(endog_list)'
	local depvar `depvar'
	
	_ms_parse_parts `wx'
	local k	= r(k_names)	
	if (`k'==.) {
		local isendog : list wx in endog
		local isdepvar : list wx in depvar
	}
	else {
		local isendog	= 0
		local isdepvar	= 0
		forvalues i=1/`k' {
			local var `r(name`i')'
			local flag : list var in endog
			local isendog	= `flag' + `isendog' 

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
					//-- get missing id and time --//
program UpdateTouseMissing, sclass
	syntax [, id(string)		///
		timevar(string)		///
		depvar(string)		///
		x(string)		///
		wy_list(string)		///
		mi_time(string)		///
		panelvar(string) 	///
		touse(string)	]
	
	marksample mi_touse
	markout `mi_touse' `depvar' `x' `wy_list'
	
	qui sum `panelvar' if !`mi_touse' & `touse'
	local id_min = r(min)
	local n_mi = r(N)
	tempvar touse_tmp
	qui gen `touse_tmp' = 0
	qui replace `touse_tmp' = 1 if !`mi_touse' & `panelvar'==`id_min'
	mata : get_timevalues(`"`timevar'"', `"`touse_tmp'"')
	qui gen `mi_time'	= 1
	if (`"`timevalues'"' != "") {
		local k_time : list sizeof timevalues
		forvalues i=1/`k_time' {
			local mi_t : word `i' of `timevalues'
			qui replace `mi_time' = 0 if `timevar' == `mi_t'
		}
	}
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
					//-- UpdateTouse --//
program UpdateTouse, sclass
	syntax [, touse(string)		///
		mi_time(string)		///
		lag_list_full(string) 	///
		timevar(string)		///
		panelvar(string)]
	
	qui replace `touse' = `touse'*`mi_time'

	NoObsError, touse(`touse')

	if (`"`timevar'"'!="") {
		qui summarize `panelvar' if `touse'
		local id_min = r(min)
		tempvar touse_tmp
		qui gen `touse_tmp' = 0
		qui replace `touse_tmp' = 1 if `touse' & `panelvar' == `id_min'
		mata : get_timevalues(`"`timevar'"', `"`touse_tmp'"', 1)
		sret local timevalues `timevalues'
	}
end
					//-- ParseNdata--//
program ParseNdata, sclass
	syntax , orig_touse(string)	///
		touse(string)		///
		timevar(string)		///
		panelvar(string)	///
		timevalues(string)

	qui count
	local n_data = r(N)

	qui count if !`orig_touse'
	local n_excluded = r(N)

	qui count if `touse'
	local n_esample = r(N)

	local n_missing = `n_data' - `n_esample' - `n_excluded' 
	mata : get_n_esample_t(`"`timevar'"', `"`panelvar'"', `"`touse'"')

	sret local n_data = `n_data'
	sret local n_excluded = `n_excluded'
	sret local n_missing = `n_missing'
	sret local n_esample = `n_esample'
	sret local n_esample_t = `n_esample_t'
end

mata :
void get_timevalues(			///
	string scalar	timevar,	///
	string scalar	touse,		///
	|real scalar	tosort)
{
	real vector	timevalues	

	timevalues =st_data(., timevar, touse)
	if (rows(timevalues) == 0) {
		return
		// NotReached
	}
	if (tosort) {
		_sort(timevalues,1)
	}
	_transpose(timevalues)
	st_local("timevalues", invtokens(strofreal(timevalues,"%16.0g")))
}

void get_n_esample_t(			///
	string scalar	timevar,	///
	string scalar	panelvar,	///
	string scalar	touse)
{
	real matrix 	D
	real scalar	n_t

	D = st_data(., (timevar, panelvar), touse)
	_sort(D, 1)
	n_t = rows(select(D, D[.,1]:==D[1,1]))
	st_local("n_esample_t", strofreal(n_t))

}
end
