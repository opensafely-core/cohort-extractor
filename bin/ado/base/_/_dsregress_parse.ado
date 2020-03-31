*! version 1.0.9  07jun2019
/*
	parsing common options for -dsregress-, -poregress-, -xporegress-
*/
program _dsregress_parse, sclass
	version 16.0

	syntax [anything(name=eq)]	///
		[if] [in]		///
		[, controls(passthru)	///	
		vce(passthru)		///
		noconstant		///	common_opts
		selection(string)	///
		grid(passthru)		///
		SQRTlasso		///
		nolog			///
		verbose			///
		semi			///	
		debug			///	NotDoc
		cmd(passthru)		///	NotDoc
		model(passthru)		///	NotDoc
		zero(passthru)		///	NotDoc
		tolerance(passthru)	///
		gmm			///
		OFFset(passthru)	///
		EXPosure(passthru)	///
		RESAMPLE1(passthru)	///
		RESAMPLE		///
		*]			//	advanced options

	
	/*----------------- parsing -------------------------------*/
						//  touse	
	marksample touse
						// parse vce
	ParseVCE , `vce' touse(`touse') `model' `gmm'
 	local vce `s(vce)'
 	local vcetype `s(vcetype)'

						// parse selection	
	ParseSelection `model' : , selection(`selection') `sqrtlasso' 
	local selectionopt `s(selectionopt)'

						//  parse debug
	ParseDebug, `debug'
	local debug `s(debug)'
	local qui `s(qui)'
						// parse resample cross-fitting
	ParseResample , `resample1' `resample'
	local resample_num  `s(resample_num)'

						//  parse log
	ParseLog, `log' `verbose' resample_num(`resample_num')
	local log `s(log)'
	local verbose `s(verbose)'
	local dslog `s(dslog)'
	local relog `s(relog)'
						//  Check tolerance
	CheckTol, `tolerance'
						// parse offset and exposure
	ParseOffset, `offset' `exposure' `model'
	local offset `s(offset)'
	local exposure `s(exposure)'

						//  check constant
	CheckConst , `constant'
						//  parse opts
	ParseOpts, `controls' `vce' `vcetype' 				///
		`options' `sqrtlasso' `qui' `cmd' `model' `verbose'	///
		`offset' `exposure'					///
		common_opts(`selectionopt' `grid' `log'  `constant'	///
		`debug' `tolerance') `zero' `constant' 			///
		`semi' `tolerance' `dslog' `resample' `resample1' `relog'
	local opts `s(opts)'
						//  return results
	sret local opts `opts'
end

/*---------------------------------------------------------------------------*/
/*
	parsing basic options
*/
/*---------------------------------------------------------------------------*/
					//----------------------------//
					// parse vce
					//----------------------------//
program ParseVCE
	syntax [, * model(string) gmm ]

	if (`"`model'"' == "linear") {
		ParseVceLinear , `options'
	}
	else if (`"`model'"' == "logit" | `"`model'"' == "poisson" ) {
		ParseVceLogit , `options' `gmm'
	}
end
					//----------------------------//
					// parse vce for logit model
					//----------------------------//
program ParseVceLogit, sclass
	syntax [, vce(passthru)	///
		touse(string)	///
		gmm]
	
	
	if (`"`gmm'"' == "") {
		_vce_parse `touse' , optlist(Robust oim) : , `vce'
	}
	else {
		_vce_parse `touse' , optlist(Robust) : , `vce'
	}

	if ("`r(vce)'"=="robust" | `"`vce'"' == "") {
		local vce robust
		local vcetype Robust
	}
	else if "`r(vce)'"=="oim" {
		local vce oim
		local vcetype
	}

	if (`"`vce'"' != "") {
		sret local vce vce(`vce')
	}

	if (`"`vcetype'"' != "") {
		sret local vcetype vcetype(`vcetype')
	}
end
					//----------------------------//
					// parse vce for linear model
					//----------------------------//
program ParseVceLinear, sclass
	syntax [, vce(passthru)	///
		touse(string)]	
	
	
	_vce_parse `touse' , optlist(ols Robust hc2 hc3) : , `vce'

	if ("`r(vce)'"=="robust" | `"`vce'"' == "") {
		local vce robust
		local vcetype Robust
	}
	else if "`r(vce)'"=="ols" {
		local vce 
		local vcetype
	}
	else if ("`r(vce)'" == "hc2") {
		local vce hc2
		local vcetype Robust HC2
	}
	else if ("`r(vce)'" == "hc3") {
		local vce hc3
		local vcetype Robust HC3
	}

	if (`"`vce'"' != "") {
		sret local vce vce(`vce')
	}

	if (`"`vcetype'"' != "") {
		sret local vcetype vcetype(`vcetype')
	}
end

					//----------------------------//
					// parse selection
					//----------------------------//
program ParseSelection
	_on_colon_parse `0'
	local 0 ,`s(before)'
	syntax [, model(string)]

	local zero `s(after)'

	if (`"`model'"' == "linear") {
		ParseSelectionLinear `zero'
	}
	else if (`"`model'"' == "logit") {
		ParseSelectionLogit `zero'
	}
	else if (`"`model'"' == "poisson" ) {
		ParseSelectionLogit `zero'
	}
end
					//----------------------------//
					// parse selection for logit model
					//----------------------------//
program ParseSelectionLogit, sclass
	syntax [, selection(string)	///
		sqrtlasso]

	cap _lasso_parse_selection , cmd(lasso) selection(`selection')
	local rc = _rc
	local sel_type `s(sel_type)'

	CheckSelType, sel_type(`sel_type') good_type(cv adaptive plugin)

	if (`rc') {
		_lasso_parse_selection , cmd(lasso) selection(`selection')
	}

	if ( "`sel_type'" == "adaptive" & `"`sqrtlasso'"' != "") {
		di as err "option {bf:selection(adaptive)} cannot be "	///
			"specified with sqrtlasso"
		exit 198
	}

	if (`"`selection'"' != "") {
		sret local selectionopt selection(`selection')
	}
end

					//----------------------------//
					// parse selection for linear model
					//----------------------------//
program ParseSelectionLinear, sclass
	syntax [, selection(string)	///
		sqrtlasso ]

	cap _lasso_parse_selection , cmd(lasso) selection(`selection')
	local rc = _rc
	local sel_type `s(sel_type)'

	CheckSelType, sel_type(`sel_type') good_type(cv adaptive plugin)

	if (`rc') {
		_lasso_parse_selection , cmd(lasso) selection(`selection')
	}

	if ( "`sel_type'" == "adaptive" & `"`sqrtlasso'"' != "") {
		di as err "option {bf:selection(adaptive)} cannot be "	///
			"specified with sqrtlasso"
		exit 198
	}

	if (`"`selection'"' != "") {
		sret local selectionopt selection(`selection')
	}
end
					//----------------------------//
					// parse opts
					//----------------------------//
program ParseOpts, sclass
	syntax [, controls(passthru)	///
		common_opts(passthru)	///
		zero(string)		///
		cmd(string)		///
		model(string)		///
		*]
	
	local cmdline `cmd' `zero'

	local opts cmd(`cmd') model(`model')	///
		cmdline(`cmdline')		///
		`controls'  			///
		`options'			///
		`common_opts' 
	
	sret local opts `opts'
end
					//----------------------------//
					// parse debug
					//----------------------------//
program ParseDebug, sclass
	syntax [, debug]

	if (`"`debug'"' == "") {
		local debug nodebug
		local qui qui
	}
	else {
		local debug debug
	}

	sret local debug `debug'
	sret local qui `qui'
end
					//----------------------------//
					// CheckSqrtLasso
					//----------------------------//
program CheckSqrtLasso
	syntax [, model(string) sqrtlasso]

	if ( (`"`model'"' == "logit" & `"`sqrtlasso'"' != "") 	///
		|(`"`model'"' == "poisson" & `"`sqrtlasso'"' != "" ) ) {
		di as err "option {bf:sqrtlasso} not allowed for `model' model"
		exit 198
	}
end

					//----------------------------//
					// Check Tol
					//----------------------------//
program CheckTol, sclass
	syntax [, tolerance(real 1E-10)]

	if (`tolerance' <= 0) {
		di as err "option {bf:tolerance()} contains nonpositive number"
		exit 198
	}
end

					//----------------------------//
					// parse adaptive number
					//----------------------------//
program ParseAdaptNum, sclass
	syntax [, adaptive		///
		selection(string) 	///
		*]

	if (`"`adaptive'"' == "") {
		sret local options `options'
		sret local selection `selection'
		exit 
		// NotReached
	}

	gettoken adapt_num options : options

	sret local selection `selection' `adapt_num'
	sret local options `options'
end

					//----------------------------//
					// parse log
					//----------------------------//
program ParseLog, sclass
	syntax , [ nolog verbose resample_num(string)]

	if (`"`log'"' == "nolog" & `"`verbose'"' != "") {
		di as error "option {bf:nolog} is not allowed with "	///
			"option {bf:verbose}"
		exit 198
	}

	if (`resample_num' > 1) {
		local relog relog
	}

	if (`"`log'"' == "log" | `"`log'"' == "") {
		local dslog dslog
	}
	else {
		local dslog 
		local relog
	}

	if (`"`verbose'"' != "") {
		local iterlog log
	}
	else {
		local iterlog nolog
	}

	if (c(iterlog) == "off") {
		local iterlog nolog
		local dslog
		local relog
	}

	sret local log `dslog' `relog' `iterlog'
	sret local verbose `verbose'
	sret local dslog `dslog'
	sret local relog `relog'
end
					//----------------------------//
					// Check sel_type
					//----------------------------//
program CheckSelType
	syntax [, sel_type(string) 	///
		good_type(string) ]
	
	if (`"`sel_type'"' == "") {
		exit
	}

	local n_type : list sizeof sel_type
	local in_good : list sel_type in good_type

	if (`n_type' > 1 | !`in_good') {
		opts_exclusive "`good_type'" selection 198
	}
end

					//----------------------------//
					// parse offset and exposure
					//----------------------------//
program ParseOffset, sclass
	syntax  [, offset(varname numeric)	///
		exposure(varname numeric) 	///
		model(string) ]	

	if (`"`offset'"' == "" & `"`exposure'"' == "") {
		exit
		// NotReached
	}

	if (`"`model'"' == "linear") {
		if (`"`offset'"' != "") {
			di as error `"option {bf:offset()} not allowed"'
			exit 198
		}
		else if (`"`exposure'"' != "") {
			di as error `"option {bf:exposure()} not allowed"'
			exit 198
		}
	}
	else if (`"`model'"' == "logit") {
		local extra `exposure'
		if (`"`extra'"' != "") {
			di as error `"option {bf:exposure()} not allowed"'
			exit 198
		}
	}
	else if (`"`model'"' == "poisson") {
		if (`"`offset'"' != "" & `"`exposure'"' != "") {
			di as error "only one of {bf:offset()} and "	///
				"{bf:exposure()} is allowed"
			exit 198
		}
	}

	if (`"`offset'"' != "") {
		sret local offset offset(`offset')
	}

	if (`"`exposure'"' != "") {
		sret local exposure exposure(`exposure')
	}
end

					//----------------------------//
					// noconstant is not allowed
					//----------------------------//
program CheckConst
	syntax [, noconstant]

	if (`"`constant'"' == "noconstant") {
		di as err "option {bf:noconstant} not allowed"
		exit 198
	}
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
		sret local resample_num = 10
		exit
		// NotReached
	}

	local 0 `resample1'

	syntax [anything(name=num)]	
	
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

	sret local resample_num = `num'
end
