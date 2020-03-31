*! version 1.0.11  28jan2020
program _dslasso_parse, sclass
	version 16.0

	syntax anything(name=eq)	///
		[, controls(passthru)	///
		common_opts(passthru)	///
		SQRTLASSO1		///
		xfolds(passthru)	///
		RESAMPLE1(passthru)	///
		RESAMPLE		///
		technique(string)	///
		iv			///
		model(passthru)		///
		coef			///
		irr			///
		or			///
		*]
	
	/*--------------- parsing ---------------------------*/

						//  parse equation
	ParseEq `eq' , `controls' `iv'
	local depvar `s(depvar)'
	local Dvars `s(Dvars)'
	local endog `s(endog)'
	local exog `s(exog)'
	local Xvars `s(Xvars)'
	local Zvars `s(Zvars)'
	local raw_Xvars `s(raw_Xvars)'
	local lasso_vars `s(lasso_vars)'
	local lasso_drops `s(lasso_drops)'
	local eq `s(eq)'
	local dvars_omit `s(dvars_omit)'
	local dvars_full `s(dvars_full)'
	local raw_inst `s(raw_inst)'
	local lasso_noneed `s(lasso_noneed)'
						//  parse options
	local opts `options'
	foreach lopt_name in lasso elasticnet sqrtlasso{
		ParseLopts `lopt_name' : , 		///
			lasso_vars(`lasso_vars') 	///
			lasso_drops(`lasso_drops')	///
			lasso_names(`lasso_names')	///
			lasso_opts(`lasso_opts')	///
			lasso_cmds(`lasso_cmds')	///
			`common_opts' 			///
			`sqrtlasso1'			///
			`model'				///
			depvar(`depvar')		///
			`opts' 			
		local lasso_opts `s(lasso_opts)'
		local lasso_names `s(lasso_names)'
		local lasso_cmds `s(lasso_cmds)'
		local opts `s(opts)'
	}

						// check extra options
 	CheckExtraOptions, `opts'

						// index lopts
	IndexLopts, lasso_opts(`lasso_opts')	///
		lasso_names(`lasso_names')	///
		lasso_cmds(`lasso_cmds')	///
		lasso_vars(`lasso_vars')	///
		`sqrtlasso1'			///
		depvar(`depvar')		///
		`model'				///
		`common_opts'
	local full_lasso_names `s(full_lasso_names)'
	local full_lasso_cmds `s(full_lasso_cmds)'
	local full_lasso_opts `s(full_lasso_opts)'

						//  transform vars
	TransformVars, myvars(`Dvars')	
	local Dvars `s(myvars)'

						//  Parse cross-fitting
	ParseFolds, `xfolds'
	local xfolds `s(xfolds)'
						//  Parse DML method 
	ParseDML, `technique'
	local dml `s(dml)'
						// parse resample cross-fitting
	ParseResample , `resample1' `resample'
	local resample_method `s(resample_method)'
	local resample_num  `s(resample_num)'
						//  parse coef
	ParseIrrOr, `coef' `irr' `or' `model'
	local irr_or `s(irr_or)'
						//  sreturn list
	sret local depvar `depvar'
	sret local Dvars `Dvars'
	sret local endog `endog'
	sret local exog `exog'
	sret local eq `eq'
	sret local Xvars `Xvars'
	sret local raw_Xvars `raw_Xvars'
	sret local Zvars `Zvars'
	sret local full_lasso_names `full_lasso_names'
	sret local full_lasso_cmds `full_lasso_cmds'
	sret local full_lasso_opts `full_lasso_opts'
	sret local xfolds `xfolds'
	sret local resample_method `resample_method'
	sret local resample_num `resample_num'
	sret local dml `dml'
	sret local dvars_omit `dvars_omit'
	sret local dvars_full `dvars_full'
	sret local raw_inst `raw_inst'
	sret local irr_or `irr_or'
	sret local lasso_noneed `lasso_noneed'
end

					//----------------------------//
					// parse Equation
					//----------------------------//
program ParseEq, sclass
	syntax [anything(name=eq)]	///
		, controls(string)	///
		[iv]

	cap noi _iv_parse `eq'
	local depvar `s(lhs)'
	local rc = _rc

	if (`"`iv'"' == "") {
		local Dvars `s(exog)'
		if (`"`s(inst)'"' != "" | `"`s(endog)'"' != "") {
			di as err "invalid syntax"
			di as err "syntax is {it:depvar} "	///
				"{it:varsofinterest} [,controls()]"
			exit 198
		}
	}
	else {
		local Dvars `s(endog)' 	`s(exog)'
		local inst `s(inst)'
		local Zvars `s(inst)' `s(exog)'
		local endog `s(endog)'
		local exog `s(exog)'
		if (`rc') {
			di as err "invalid syntax"
			di as err "syntax is {it:depvar} {it:[exogvars]} " ///
				"({it:endogvars = instvars}) " 		   ///
				" [,controls()]"
			exit `rc'
		}

		local confound : list exog & endog

		if (`"`confound'"' != "") {
			di as err "{bf:`confound'} cannot be both " ///
				"{it:exogvars} and {it:endogvars}"
			exit 198
		}
	}

	if (`rc') exit `rc'
	
	ParseDvars `Dvars'
	local Dvars `s(Dvars)'
	local lasso_drops `s(drops)'
	local dvars_omit `s(omit)'
	local dvars_full `s(full_vars)'

	ParseDvars `endog'
	local endog `s(Dvars)'

	ParseDvars `exog'
	local exog `s(Dvars)'

	ParseExpandVars `inst'
	local inst `s(myvars)'

	ParseRawXvars , controls(`controls')
	local raw_Xvars `s(raw_Xvars)'

	ParseExpandVars `Zvars'
	local Zvars `s(myvars)'

	CheckDvars , dvars(`Dvars') xvars(`raw_Xvars') zvars(`inst')

	GetLassoNoneed, controls(`controls') inst(`inst') `iv'
	local lasso_noneed = `s(lasso_noneed)'

	sret local eq `eq'
	sret local depvar `depvar'
	sret local Dvars `Dvars'
	sret local Xvars `controls'
	sret local endog `endog'
	sret local exog `exog'
	sret local Zvars `Zvars'
	sret local raw_Xvars `raw_Xvars'
	sret local lasso_vars `depvar' `Dvars'
	sret local lasso_drops `lasso_drops'
	sret local dvars_omit `dvars_omit'
	sret local dvars_full `dvars_full'
	sret local raw_inst `inst'
	sret local lasso_noneed `lasso_noneed'
end
					//----------------------------//
					// ParseDvars
					//----------------------------//
program ParseDvars, sclass
	syntax [varlist(numeric fv default=none)]	///
		[, qui]

	if (`"`varlist'"' == "") {
		exit
		// NotReached
	}

	_rmcoll `varlist' , expand
	local full_vars `r(varlist)'

	foreach var of local full_vars {
		_ms_parse_parts `var'		
		if (!r(omit)) {
			local myvars `myvars' `var'
		}
		else {
			local omit `omit' `var'
		}
	}

	if (`"`myvars'"' == "") {
		di as err "must specify {it:varsofinterests}"
		exit 198
	}

	_lasso_fvexpand `myvars'
	local myvars `r(varlist)'

	sret local Dvars `myvars'
	sret local drops `drops'
	sret local omit `omit'
	sret local full_vars `full_vars'
end
					//----------------------------//
					// Parse controls
					//----------------------------//
program ParseRawXvars, sclass
	syntax [, controls(string)]

	_lasso_parse_controls `controls', infer_lasso
	local indepvars `s(indepvars)'

	_lasso_fvexpand `indepvars'
	sret local raw_Xvars `r(varlist)'
end
					//----------------------------//
					// check Dvars if collinear with Xvars
					// and Zvars
					//----------------------------//
program CheckDvars, sclass
	syntax [, dvars(string)	///
		xvars(string)	///
		zvars(string)]
	
	if (`"`dvars'"' == "") {
		di as err "{it:varsofinterest} required"
		exit 198
	}
	
	_lasso_fvexpand `xvars'
	local xvars `r(varlist)'

	foreach dvar of local dvars {
		local in : list dvar in xvars
		if (`in') {
			di as err "{bf:`dvar'} cannot be specified both " ///
				"in {it:varsofinterest} and {it:controls}"
			exit 198
		}
	}

	if (`"`zvars'"' == "") {
		exit
		// NotReached
	}

	_lasso_fvexpand `zvars'
	local zvars `r(varlist)'

	foreach dvar of local dvars {
		local in : list dvar in zvars
		if (`in') {
			di as err "{bf:`dvar'} cannot be specified both " ///
				"in {it:varsofinterest} and {it:instruments}"
			exit 198
		}
	}
end
					//----------------------------//
					// Parse Lasso options recursively
					//----------------------------//
program ParseLopts, sclass
	_on_colon_parse  `0'
	local lopts `s(before)'
	local 0 `s(after)'

	syntax [, `lopts'(string)	///
		lasso_vars(string)	///
		lasso_drops(string)	///
		lasso_names(string)	///
		lasso_opts(string)	///
		lasso_cmds(string)	///
		common_opts(passthru)	///
		SQRTLASSO1		///
		model(passthru)		///
		depvar(passthru)	///
		*]
	
	
	local lopts_ct ``lopts''
	if (`"`lopts_ct'"' == "") {
		sret local lasso_names `lasso_names'
		sret local lasso_opts `lasso_opts'
		sret local lasso_cmds `lasso_cmds'
		sret local opts `options'
		exit
		// NotReached
	}

	if (!ustrregexm(`"`options'"', "`lopts'\((.*)\)")) {
		ParseOneLopt `lopts' :, `lopts'(`lopts_ct')	///
			lasso_vars(`lasso_vars') 		///
			lasso_drops(`lasso_drops')		///
			lasso_names(`lasso_names')		///
			lasso_cmds(`lasso_cmds')		///
			lasso_opts(`lasso_opts')		///
			`common_opts'				///
			`model'					///
			`depvar'				///
			`sqrtlasso1'				
		sret local lasso_names `s(lasso_names)' 
		sret local lasso_cmds `s(lasso_cmds)' 
		sret local lasso_opts `s(lasso_opts)' 
		sret local opts `options'
	}
	else {
		ParseOneLopt `lopts' :, `lopts'(`lopts_ct') 	///
			lasso_vars(`lasso_vars') 		///
			lasso_drops(`lasso_drops')		///
			lasso_names(`lasso_names')		///
			lasso_cmds(`lasso_cmds')		///
			lasso_opts(`lasso_opts')		///
			`common_opts'				///
			`model'					///
			`depvar'				///
			`sqrtlasso1'				
		local lasso_names `s(lasso_names)' 
		local lasso_cmds `s(lasso_cmds)' 
		local lasso_opts `s(lasso_opts)' 

		ParseLopts `lopts' :, lasso_vars(`lasso_vars')	///
			lasso_drops(`lasso_drops')		///
			lasso_names(`lasso_names')		///
			lasso_cmds(`lasso_cmds')		///
			lasso_opts(`lasso_opts')		///
			`common_opts'				///
			`sqrtlasso1'				///
			`model'					///
			`depvar'				///
			`options' 
	}
end
					//----------------------------//
					// Parse only one lasso option
					//----------------------------//
program ParseOneLopt, sclass
	_on_colon_parse  `0'
	local lopts `s(before)'
	local 0 `s(after)'

	syntax , lasso_vars(string) 	///
		[`lopts'(string) 	///
		lasso_drops(string)	///
		lasso_names(string)	///
		lasso_cmds(string)	///
		lasso_opts(string)	///
		sqrtlasso1		///
		model(passthru)		///
		depvar(passthru)	///
		common_opts(string)]	
	
	local lopts_ct ``lopts''
	if (`"`lopts_ct'"' == "") {
		sret local lasso_names `lasso_names'
		sret local lasso_cmds `lasso_cmds'
		sret local lasso_opts `lasso_opts'
		exit
		//NotReached
	}
	
	local 0 `lopts_ct'
	syntax [anything(name=vars)], [*]
	if (`"`vars'"' == "" | `"`vars'"' == "_all" | `"`vars'"' == "*") {
		local varlist `lasso_vars'
	}
	else {
		syntax varlist(numeric fv default=none), [*]
	}

	fvexpand `varlist'
	local lopt_vars `r(varlist)'

	TransformVars , myvars(`lopt_vars')
	local lopt_vars `s(myvars)'

	OverWriteGlobal, common_opts(`common_opts') lopt(`options')
	local lopt `s(lopt)'

	foreach var of local lopt_vars {
		if (`:list var in lasso_drops') {
			di as err "invalid {bf:`lopts'()} option "	  
			di "{p 4 4 2}"
			di as err "{bf:`lopts'(`var', `lopt')} is ignored " ///
				"because `var' is dropped"
			di "{p_end}"
		}
		else {
			local final_lopt_vars `final_lopt_vars' `var'
		}
	}

	foreach var of local final_lopt_vars {
		if (!`:list var in lasso_vars') {
			di as err "invalid {bf:`lopts'()} option "	  
			di "{p 4 4 2}"
			di as err "{bf:`var'} must be either a {it:depvar} " ///
				"or a {it:varsofinterest}."
			di "{p_end}"
			exit 198
		}
	}

	if (`"`lopts'"' == "elasticnet") {
		local sel_default cv
	}
	else {
		local sel_default plugin
	}


	ExtractSel, `lopt' 
	local sel `s(sel)'
	if (`"`sel'"' == "") {
		local lopt `lopt' selection(`sel_default')
	}

						// check depvar model and lopts
	CheckDepvarLopts, lmethod(`lopts') lopt_vars(`final_lopt_vars') ///
		`model' `depvar' lopt(`lopt')
						//  check lopt
	CheckLopts, lmethod(`lopts') lopt_vars(`final_lopt_vars')  `lopt' 

	if (`"`lopts'"' == "sqrtlasso") {
		local tmp_cmd _sqrtlasso
	}
	else {
		local tmp_cmd `lopts'
	}
	foreach var of local final_lopt_vars {
		local lasso_name `var' || `lasso_name' 
		local lasso_opt `lopt' || `lasso_opt'
		local lasso_cmd `tmp_cmd' || `lasso_cmd'
	}
						//  sret lasso_names and
						//  lasso_opts
	if (`"`lasso_name'"' != "") {
		sret local lasso_names  `lasso_names' `lasso_name'
		sret local lasso_opts  `lasso_opts' `lasso_opt'
		sret local lasso_cmds  `lasso_cmds' `lasso_cmd'
	}
	else {
		sret local lasso_names  `lasso_names' 
		sret local lasso_opts  `lasso_opts' 
		sret local lasso_cmds  `lasso_cmds' 
	}
end
					//----------------------------//
					// check extra options
					//----------------------------//
program CheckExtraOptions
	syntax [, *]
	if (`"`options'"'!="") {
		di as error "option {bf:`options'} not allowed"
		exit(198)
	}
end
					//----------------------------//
					// index user specified lasso opts
					//----------------------------//
program IndexLopts, sclass
	syntax , lasso_vars(string)	///
		depvar(string)		///
		model(string)		///
		[lasso_names(string)	///
		lasso_cmds(string)	///
		lasso_opts(string)	///
		sqrtlasso1		///
		common_opts(string)]
	
	local lasso_vars_orig `lasso_vars'

	_parse expand lasso_names tmp : lasso_names
	_parse expand lasso_opts tmp : lasso_opts	
	_parse expand lasso_cmds tmp : lasso_cmds
						//  customized lopts
	forvalues i = 1/`lasso_names_n' {
		local var `lasso_names_`i''
		local opt `lasso_opts_`i''
		local cmd `lasso_cmds_`i''
		local in : list var in lasso_vars
		local dup_lasso_names `dup_lasso_names' `var'
		if (`in') {
			local lasso_vars : list lasso_vars - var
			local tmp_lasso_names 	`tmp_lasso_names' || `var'
			local tmp_lasso_opts 	`tmp_lasso_opts' || `opt'
			local tmp_lasso_cmds 	`tmp_lasso_cmds' || `cmd'
		}
	}

	local dup_list : list dups dup_lasso_names
	if (`"`dup_list'"' != "") {
		foreach var of local dup_list {
			di as err "invalid {it:lmethod}"
			di "{p 4 4 2}"
			di as err `"{bf:`var'} can only be specified "'	///
				"once in one of {bf:lasso()}, "	 	///
				"{bf:elasticnet()}, or {bf:sqrtlasso()}"
			di "{p_end}"
			exit 198
		}
	}

	local sel_default plugin
						//  default lopts	
	ExtractSel, `common_opts'
	local sel `s(sel)'
	if (`"`sel'"' == "") {
		local opt_default selection(`sel_default') `common_opts'
	}
	else {
		local opt_default `common_opts'
	}

	if (`"`sqrtlasso1'"' == "") {
		local cmd_default lasso
	}
	else {
		local cmd_default _sqrtlasso
	}

	if (`"`model'"' == "linear") {
		local cmd_default_y `cmd_default'
	}
	else {
		local cmd_default_y lasso
	}

	foreach var of local lasso_vars {
		if (`"`var'"' == `"`depvar'"') {
			local tmp_cmd `cmd_default_y'
		}
		else {
			local tmp_cmd `cmd_default'
		}
		local tmp_lasso_names 	`tmp_lasso_names' || `var'
		local tmp_lasso_opts 	`tmp_lasso_opts' || `opt_default'
		local tmp_lasso_cmds 	`tmp_lasso_cmds' || `tmp_cmd'
	}
						//  reorder lopts by lasso_vars
	_parse expand tmp_lasso_names tmp : tmp_lasso_names
	_parse expand tmp_lasso_opts tmp : tmp_lasso_opts
	_parse expand tmp_lasso_cmds tmp : tmp_lasso_cmds
	forvalues i=1/`tmp_lasso_names_n' {
		local var `tmp_lasso_names_`i''
		local pos : list posof `"`var'"' in lasso_vars_orig
		local order `order' `pos'
	}
	mata : get_order("`order'")

	foreach i of local order {
		local var `tmp_lasso_names_`i''
		local opt `tmp_lasso_opts_`i''
		local cmd `tmp_lasso_cmds_`i''
		local full_lasso_names 	`full_lasso_names' || `var'
		local full_lasso_opts 	`full_lasso_opts' || `opt'
		local full_lasso_cmds	`full_lasso_cmds' || `cmd'
	}

	sret local full_lasso_names `full_lasso_names'
	sret local full_lasso_opts `full_lasso_opts'
	sret local full_lasso_cmds `full_lasso_cmds'
end
					//----------------------------//
					// Check lmethod options
					//----------------------------//
program CheckLopts
	
	syntax , lmethod(string)	///
		[lopt_vars(passthru)	///
		*]

	if (`"`lmethod'"' == "lasso") {
		CheckLasso, `lopt_vars' `options'
	}
	else if (`"`lmethod'"' == "elasticnet") {
		CheckEnet, `lopt_vars' `options'
	}
	else if (`"`lmethod'"' == "sqrtlasso") {
		CheckSqrtLasso, `lopt_vars' `options'
	}
						//  check duplications
	local lopt_tmp = ustrregexra(`"`options'"', "\(", "\ \(")

	local dups : list dups lopt_tmp

	if (`"`dups'"' != "") {
		di as err "option {bf:`dups'} cannot be specified both " ///
			"globally and in {bf:`lmethod'()}"
		exit 198
	}
end
					//----------------------------//
					// Check lasso
					//----------------------------//
program CheckLasso
	syntax [, lopt_vars(string)	///
		*]
	
	local is_cv = strpos(`"`options'"', "cv")
	local is_cv = `is_cv' + strpos(`"`options'"', "adapt")
	local is_cv = `is_cv' + strpos(`"`options'"', "plug")
	local is_none = strpos(`"`options'"', "none")
	
	if (!`is_cv' | `is_none') {
		di as err "must specify one of selection(cv), "	///
			"selection(adaptive), or selection(plugin) " ///
			"in {bf:lasso()}"
		exit 198
	}
end
					//----------------------------//
					// Check Enet
					//----------------------------//
program CheckEnet
	syntax [, lopt_vars(string)	///
		*]
	
	local is_cv = strpos(`"`options'"', "cv")
	local is_none = strpos(`"`options'"', "none")
	
	if (!`is_cv' | `is_none') {
		di as err "must specify selection(cv) in {bf:elasticnet()}"
		exit 198
	}
end
					//----------------------------//
					// Check Enet
					//----------------------------//
program CheckSqrtLasso
	syntax [, lopt_vars(string)	///
		*]
	
	local is_cv = strpos(`"`options'"', "cv") 
	local is_cv = `is_cv' + strpos(`"`options'"', "plug")
	local is_none = strpos(`"`options'"', "none")
	
	if (!`is_cv' | `is_none') {
		di as err "must specify selection(cv) or selection(plugin) " ///
			"in {bf:sqrtlasso()}"
		exit 198
	}
end
					//----------------------------//
					// Parse xfolds
					//----------------------------//
program ParseFolds, sclass
	cap syntax [, xfolds(integer 10) ]
	local rc = _rc

	if (`xfolds' <=0 | `rc' ) {
		di as err "option {bf:xfolds(#)} requires positive integer"
		exit 198
	}

	sret local xfolds = `xfolds'
end
					//----------------------------//
					// Parse dml
					//----------------------------//
program ParseDML, sclass
	cap syntax [, dml1 	///
		dml2]
	local rc = _rc
	
	local dml `dml1' `dml2'

	if (`:list sizeof dml' > 1 | `rc' ) {
		di as err "must specify only one of {bf:dml1} or {bf:dml2} " ///
			"in option {bf:technique()}"
		exit 198
	}

	if (`"`dml'"' == "") {
		local dml dml2
	}
	sret local dml `dml'
end
					//----------------------------//
					// Parse resample cross-fitting
					//----------------------------//
program ParseResample, sclass
	syntax [, resample1(string)	///
		resample ]

	if (`"`resample'"' != "" & `"`resample1'"' != "") {
		di as err "you can specify only one of {bf:resample(#)} " ///
			"or {bf:resample}"
		exit 198
		// NotReached
	}

	if (`"`resample'"' != "") {
		sret local resample_num  10
		sret local resample_method mean
		exit
		// NotReached
	}

	local 0 `resample1'

	syntax [anything(name=num)]	///
		[, mean			///
		median ]	
	
	if ("`num'" == "") {
		local num = 1
	}

	cap confirm integer number `num'

	local msg as err "option {bf:resample(#)} must be a positive integer"

	if (_rc) {
		di `msg'
		exit 198
	}
	else if (`num' <= 0  ){
		di `msg'
		exit 198
	}

	local method `mean' `median'

	if (`"`method'"' == "") {
		local method mean
	}

	sret local resample_num `num'
	sret local resample_method `method'
end
					//----------------------------//
					// transform factor variable notation to
					// no base
					//----------------------------//
program TransformVars, sclass
	syntax [, myvars(string)]

	_lasso_fvexpand `myvars'	
	sret local myvars `r(varlist)'
end

					//----------------------------//
					// parse zvars
					//----------------------------//
program ParseExpandVars, sclass
	syntax [varlist(fv numeric default=none)]

	if (`"`varlist'"' == "") {
		exit 
		// NotReached
	}

	_lasso_fvexpand `varlist'
	sret local myvars `r(varlist)'
end
					//----------------------------//
					// check depvar, model and lopts
					//----------------------------//
program CheckDepvarLopts
	syntax [, lmethod(string)	///
		lopt_vars(string)	///
		model(string)		///
		depvar(string) 		///
		lopt(string) ]
	
	local in : list depvar in lopt_vars
	
	if (`"`lmethod'"' == "sqrtlasso" & `in' & `"`model'"' != "linear") {
		di as error "option {bf:sqrtlasso()} not allowed for "  ///
			"{it:depvar} {bf:`depvar'} in `model' model"
		exit 198
	}
end
					//----------------------------//
					// local lasso spec overwrite global
					// spec
					//----------------------------//
program OverWriteGlobal, sclass
	syntax [, common_opts(string)	///
		lopt(string) ]
	
	if (`"`common_opts'"' == "" | `"`lopt'"' == "") {
		sret local lopt `lopt' `common_opts'
		exit
		// NotReached
	}

	ExtractSel, `common_opts'
	local common_part `s(part)'
	local common_sel `s(sel)'

	ExtractSel, `lopt'
	local lopt_part `s(part)'
	local lopt_sel `s(sel)'

	if (`"`common_sel'"' != "" & `"`lopt_sel'"' != "") {
		local lopt `common_part' `lopt_part' `lopt_sel'
	}
	else {
		local lopt `lopt' `common_opts'
	}

	sret local lopt `lopt'
end
					//----------------------------//
					// extract selection
					//----------------------------//
program ExtractSel, sclass
	syntax [, SELection(passthru)	///
		*]

	sret local part `options'
	sret local sel `selection'
end
					//----------------------------//
					// parse irr or
					//----------------------------//
program ParseIrrOr, sclass
	syntax [, coef irr or model(string)]

	local coef_type `coef' `irr' `or'
	local size_type : list sizeof coef_type

	if (`size_type' > 1) {
		di as err "only one of options {bf:coef}, {bf:irr} and " ///
			"{bf:or} allowed"
		exit 198
	}

	if (`"`model'"' == "linear") {
		local default
	}
	else if (`"`model'"' == "logit") {
		local default or
	}
	else if (`"`model'"' == "poisson") {
		local default irr
	}

	if (`"`coef_type'"' == "") {
		sret local irr_or `default'	
	}
	else if (`"`coef_type'"' == "coef") {
		sret local irr_or coef
	}
	else {
		sret local irr_or `coef_type'
	}
end
					//----------------------------//
					// check if need lasso
					//----------------------------//
program GetLassoNoneed, sclass
	syntax [, controls(string)	///
		inst(string)		///
		iv]
	
	local lasso_noneed = 0

	if (`"`iv'"' == "") {
		if (`"`controls'"' == "") {
			local lasso_noneed = 1
		}
	}
	else {
		if (`"`controls'"' == "" & `"`inst'"' == "") {
			local lasso_noneed = 1
		}
	}

	sret local lasso_noneed = `lasso_noneed'
end

mata :
mata set matastrict on

void get_order(string scalar	order)
{
	real vector p
	
	p = strtoreal(tokens(order))
	st_local("order", invtokens(strofreal(invorder(p))))
}


end
