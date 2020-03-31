*! version 1.0.7  05apr2017
// prediction after spxtreg

program _spxtreg_p, sortpreserve
	version 15.0

	if (`"`e(cmd)'"'!="spxtregress" & 	///
		`"`r(cmd)'"'!="_spxtreg_pseudor2") {
		error 301
	}

	syntax newvarname [if] [in] 		///
		[, ie 				/// NOT DOCUMENTED
		*]				//  statistics 

						// check xtset	
	CheckXt
						// parse ID	
	__sp_parse_id
	local id `s(id)'
						// make sure that esample is a
						// bigger set than touse
	marksample touse, novarlist		
	tempvar esample
 	qui gen byte `esample' = e(sample)
	CheckTouse, touse(`touse') esample(`esample') 
						// parse predict options
	parsePreOpt, `options'
	local predict_opt `s(predict_opt)'
	local var_lb `s(var_lb)'
						// MatchID
	local lag_list `e(lag_list_full)'
	_spxtreg_match_id, id(`id')		///
		touse(`esample') 		///
		lag_list(`lag_list')		///
		timevar(`e(timevar)')		///
		timevalues(`e(timevalues)')
						// generate necessary wx_vars
	mata : _SPREG_INIT_WX(`"`e(exog_wy_lbs)'"')			
	local exog_wy_vars `s(exog_wy_vars)' 
	initWxVars, exog_wy_vars(`exog_wy_vars') 
						// update b_exog labels
	tempvar cn_var
	UpdateExogB, exog_wy_vars(`exog_wy_vars') cn_var(`cn_var')
	local b_exog_vars `s(b_exog_vars)'

						// get lambdas, rhos, b_exog
	tempname lambdas rhos b_exog
	_spivreg_init_coef, b_exog(`b_exog') lambdas(`lambdas') rhos(`rhos')
						// parse individual effects	
	ParseUi, ie(`ie')
	local ie = `s(ie)'
						// computation
	local y_hat `varlist'
	qui gen `typlist' `y_hat' = .
	mata : _SPXTREG_PREDICT(	///
		`"`y_hat'"', 		///
		`"`predict_opt'"',	///
		`"`b_exog_vars'"',	///
		`"`touse'"',		///
		`"`esample'"',		///
		`"`b_exog'"',		///
		`"`lambdas'"',		///
		`"`rhos'"',		///
		`"`ie'"')

	label var `varlist' `"`var_lb'"'

end
					//----------------------------//
					// Check touse to be subsample in
					// e(esample)
					//----------------------------//
program CheckTouse
	syntax , touse(string) esample(string)
	cap qui assert `esample' == 1 if `touse'
	if _rc {
		di as err "prediction sample must be a subset of e(sample)" 
		exit 498
	}
end
					//----------------------------//
					// parsePredictOpt parses predict
					// options, and return appropriate
					// option and labels for new variable
					//----------------------------//
program parsePreOpt, sclass
	syntax [,			///
		RForm			///
		xb			///
		direct			///
		indirect		///
		u			///	NOT DOCUMENTED
		xbu			///	NOT DOCUMENTED
		]

	local predict_opt `rform' `xb' `xbu' `u' `direct' `indirect'
	local case : word count `predict_opt'
	
	if (`case' >1) {
		di as err "only one {it:statistic} may be specified"
		exit 198
	}

	if (`case'==0) {
		di as txt "(option {bf:rform} assumed; reduced-form mean)"	
		local predict_opt rform
	}
						// create labels based on
						// predict option
	if ("`predict_opt'" == "xb") {
		local var_lb "Linear prediction"
	}
	if ("`predict_opt'" == "xbu") {
		local var_lb `"Xb+u[`e(ivar)']"'
	}
	if ("`predict_opt'" == "u") {
		local var_lb `"u[`e(ivar)']"'
	}
	else if ("`predict_opt'" == "rform") {
		local var_lb "Reduced-form mean"
	}
	else if ("`predict_opt'" == "direct") {
		local var_lb "Direct mean"
	}
	else if ("`predict_opt'" == "indirect") {
		local var_lb "Indirect mean"
	}

	sret local predict_opt `predict_opt'
	sret local var_lb `var_lb'
end
					//----------------------------//
					// initWxVars generate temporary spatial
					// lags for X, such as W1*X1, W2*X2. If
					// there is no WX in estimation, no
					// action is taken.
					//----------------------------//
program initWxVars
	syntax [,			///
		exog_wy_vars(string)]

	local exog_wy_index `e(exog_wy_index)'
	if (`"`exog_wy_vars'"' == "") {
		exit
	}
	
	_parse expand exog_wy tmp : exog_wy_index
	forvalues i=1/`exog_wy_n' {
		gettoken w y : exog_wy_`i', parse(", ")
		gettoken temp y: y, parse(", ")
		local y = trim(`"`y'"')
		local y : subinstr local y " " "" ,all
		local var : word `i' of `exog_wy_vars'
		_spxtreg_get_splag, 		///
			touse(e(sample)) 	///
			var(`var') 		///	
			w(`w') 			///
			y(`y')			///
			timevar(`e(timevar)')	///
			timevalues(`e(timevalues)')
		local lb	= trim(`"(`w'"'+`"*"'+`"`y')"')
		label var `var' `"`lb'"'
	}
end
					//----------------------------//
					// UpdateExogB update a varlist
					// corresponding to b_exog
					//----------------------------//
program UpdateExogB, sclass
	syntax [, cn_var(string)	///
		exog_wy_vars(string)]

	if (`"`e(constant)'"' == "hasconstant") {
		qui gen byte `cn_var'	= 1	
		local b_exog_vars `e(x)' `cn_var' `exog_wy_vars'
	}
	else {
		local b_exog_vars `e(x)' `exog_wy_vars' 
	}

	sret local b_exog_vars `b_exog_vars'
end
					//----------------------------//
					// Parse individual effects flag
					//----------------------------//
program ParseUi, sclass
	syntax [, ie(string) ]

	if (`"`ie'"'=="ie") {
		local ie	= 1
	}
	else {
		local ie	= 0
	}
	sret local ie	= `ie'
end
					//-- check xtset --//
program CheckXt	
	capture _xt
	if (_rc!=0) {
		di as err "must specify panelvar; use {bf:xtset}"	
		exit _rc
	}
end
