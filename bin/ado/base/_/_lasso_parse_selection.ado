*! version 1.0.7  10feb2020
					//----------------------------//
					// parse selection for lasso toolbox
					//----------------------------//
program _lasso_parse_selection , sclass

	version 16.0

	syntax , cmd(string)	///
		[ selection(string) ]

	local 0 `selection'
	syntax [anything] [, *]
						//  parse mtype
	ParseMtype `cmd' : , `anything' mspec(`options') 
	local mtype `s(mtype)'
	local mspec `s(mspec)'
	local seldefault `s(seldefault)'
						//  parse mspec
	ParseMspec, cmd(`cmd') mtype(`mtype') mspec(`mspec')	

	sret local sel_type `mtype'
	sret local seldefault `seldefault'
end
					//----------------------------//
					// parse selection type based on cmd
					//----------------------------//
program ParseMtype
	_on_colon_parse `0'
	local cmd `s(before)'
	local 0 `s(after)'

	if (`"`cmd'"' == "lasso") {
		ParseLassoMtype `0'
	}
	else if (`"`cmd'"' == "sqrtlasso") {
		ParseSqrtMtype `0'
	}
	else if (`"`cmd'"' == "elasticnet") {
		ParseEnetMtype `0'
	}
end
					//----------------------------//
					// parse mtype
					//----------------------------//
program ParseSqrtMtype, sclass
	cap syntax [, 			///
		cv			///
		NONE			///
		PLUGin 			///
		mspec(string)		///
		ADAPTive]		//	invalid selection type

	local rc = _rc
	
	local mtype `cv' `none' `plugin'
	local n_mtype : list sizeof mtype
	local invalid `adaptive' 
	
	if (`rc' | `n_mtype' > 1 | `"`invalid'"' != "") {
		InvalidMtype, cmd(sqrtlasso) 
	}

						//  default mtype	
	if (`n_mtype' == 0) {
		local mtype cv
		local seldefault seldefault
	}

	sret local mtype `mtype'
	sret local mspec `mspec'
	sret local seldefault `seldefault'
end
					//----------------------------//
					// parse mtype
					//----------------------------//
program ParseEnetMtype, sclass
	cap syntax [, 			///
		cv			///
		NONE			///
		mspec(string)		///
		PLUGIN 			/// invalid selection type
		ADAPTive]

	local rc = _rc
	
	local mtype `cv' `none' 
	local n_mtype : list sizeof mtype
	local invalid `adaptive' `plugin' 
	
	if (`rc' | `n_mtype' > 1 | `"`invalid'"' != "") {
		InvalidMtype, cmd(elasticnet) 
	}

						//  default mtype	
	if (`n_mtype' == 0) {
		local mtype cv
		local seldefault seldefault
	}

	sret local mtype `mtype'
	sret local mspec `mspec'
	sret local seldefault `seldefault'
end

					//----------------------------//
					// parse mtype
					//----------------------------//
program ParseLassoMtype, sclass
	cap syntax [, 		///
		cv		///
		ADAPTive	///
		NONE		///
		PLUGin 		///
		mspec(string)]	

	local rc = _rc
	
	local mtype `cv' `adaptive' `none' `plugin'
	local n_mtype : list sizeof mtype
	
	if (`rc' | `n_mtype' > 1) {
		InvalidMtype , cmd(lasso) 
	}
						//  default mtype	
	if (`n_mtype' == 0) {
		local mtype cv
		local seldefault seldefault
	}

	sret local mtype `mtype'
	sret local mspec `mspec'
	sret local seldefault `seldefault'
end
					//----------------------------//
					// parse mspec
					//----------------------------//
program ParseMspec
	syntax , cmd(passthru)		///
		[ mtype(string) 	///
		mspec(string)]

	if ("`mtype'" == "cv") {
		ParseCV  , `mspec'
	}
	else if ("`mtype'" == "adaptive") {
		ParseAdapt , `mspec'
	}
	else if ("`mtype'" == "none") {
		ParseNone , `mspec'
	}
	else if (`"`mtype'"' == "plugin") {
		ParsePlugin , `mspec'
	}
	else {
		InvalidMtype, `cmd' 
	}
end
					//----------------------------//
					// parse plugin 
					//----------------------------//
program ParsePlugin, sclass
	cap syntax [, *]

	if _rc {
		di as err "invalid {bf:selection(plugin)}"
		di "{p 4 4 2}"
		di as err "you may specify {bf:selection(plugin [, plugin_spec])}"
		di "{p_end}
		exit 198
	}

	if (`"`options'"' == "") {
		sret local selection plugin
	}
	else {
		sret local selection plugin(`options')
	}
end
					//----------------------------//
					// parse none
					//----------------------------//
program ParseNone, sclass
	
	syntax [, *]
	local mspec `options'

	if (`"`mspec'"' != "") {
		di as err "no option allowed in {bf:selection(none)}"
		exit 198
	}

	sret local selection 
end
					//----------------------------//
					// parse adaptive
					//----------------------------//
program ParseAdapt, sclass
	syntax [, FOLDs(passthru) 	///
		STEPs(integer 2)	///
		power(passthru) 	///
		ridge			///
		UNPENalized		///
		samegroup		///
		serule			///
		ALLlambdas		///
		stopok			///
		strict			///
		gridminok]

	if ("`steps'" == "") {
		local steps = 2
	}

	if (`steps' <= 0) {
		di as err "must specify a positive integer in "	///
			"option {bf:selection(adaptive, steps(#))}"
		exit 198
	}

	ParseAdaptPower, `power'
	local power `s(power)'

	if (`"`unpenalized'"' != "" & `"`ridge'"' != "") {
		di as err "invalid suboption in {bf:selection(adaptive,  )}"
		di "{p 4 4 2}"
		di as err "option {bf:unpenalized} cannot be specified " ///
			"with option {bf:ridge}"
		di "{p_end}"
		exit 198
	}

	sret local selection cv `folds' 			///
		power(`power') `ridge' `samegroup' 		///
		`unpenalized' `serule' `alllambdas' `strict' 	///
		`gridminok' `stopok'
	sret local alasso `steps'
end
					//----------------------------//
					// parse CV
					//----------------------------//
program ParseCV, sclass
	syntax  [, serule 		///
		ALLlambdas		///
		stopok			///
		strict			///
		FOLDs(passthru)		///
		gridminok]


	sret local selection cv `folds' `serule' 	///
		`alllambdas' `strict' `gridminok' `stopok'
end

					//----------------------------//
					// Invalid Mtype
					//----------------------------//
program InvalidMtype
	syntax , cmd(string) 	
	
	if (`"`cmd'"' == "lasso") {
		di as error "invalid {bf:selection()} specification"
		di "{p 4 4 2}"
		di as error "only one of {bf:cv}, {bf:adaptive}, "	///
			"{bf:none}, or {bf:plugin} can be specified"
		di "{p_end}"
		exit 198
	}
	else if (`"`cmd'"' == "sqrtlasso") {
		di as error "invalid {bf:selection()} specification"
		di "{p 4 4 2}"
		di as error "only one of {bf:cv}, {bf:none}, "		///
			"or {bf:plugin} can be specified"
		di "{p_end}"
		exit 198
	}
	else if (`"`cmd'"' == "elasticnet") {
		di as error "invalid {bf:selection()} specification"
		di "{p 4 4 2}"
		di as error "only one of {bf:cv} or {bf:none} "		///
			"can be specified"
		di "{p_end}"
		exit 198
	}
	else {
		di as err "invalid cmd"
		exit 198
	}
	
end
					//----------------------------//
					// parse adaptive power
					//----------------------------//
program ParseAdaptPower, sclass
	syntax [, power(real 1) ]

	if (`power' <= 0 | `power' >= 5) {
		di as err "option {bf:power(#)} requires a positive "	///
			"real number smaller than 5"
		exit 198
	}

	sret local power `power'
end
