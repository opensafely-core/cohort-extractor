*! version 1.0.8  05apr2017
program  _spivreg_p, sortpreserve
	version 15.0

	if (`"`e(cmd)'"'!="_spivreg" 		///
		& `"`e(cmd)'"'!="spregress" 	///
		& `"`e(cmd)'"'!="spivregress"	///
		& `"`e(cmd2)'"'!="_spreg_pseudor2") {
		error 301
	}

	syntax newvarname [if] [in] [, 	///
		slow			///	not documented
		rtransform(string)	///	
		*]
						// parse ID
	__sp_parse_id
	local id `s(id)'
						// make sure that esample is a
						// bigger set than touse
	marksample touse, novarlist		
	tempvar esample
 	qui gen byte `esample' = e(sample)
	CheckTouse, touse(`touse') esample(`esample') 
						// MatchID
	local lag_list `e(lag_list_full)'
	_spreg_match_id, id(`id') touse(`esample') lag_list(`lag_list')
						// parse predict options
	parsePreOpt, `options'
	local predict_opt `s(predict_opt)'
	local var_lb `s(var_lb)'
						// generate necessary wx_vars
	mata : _SPREG_INIT_WX(`"`e(exog_wy_lbs)'"')			
	local exog_wy_vars `s(exog_wy_vars)' 
	initWxVars, exog_wy_vars(`exog_wy_vars') 
						// update b_exog labels
	tempvar cn_var
	UpdateExogB, cn_var(`cn_var') 		///
		exog_wy_vars(`exog_wy_vars') 	
	local b_exog_vars `s(b_exog_vars)'
						// get lambdas, rhos, b_exog
	tempname lambdas rhos b_exog
	_spivreg_init_coef, b_exog(`b_exog') lambdas(`lambdas') rhos(`rhos')
						// computation
	local y_hat `varlist'
	qui gen `typlist' `y_hat' = .
	mata : _SPIVREG_PREDICT(	///
		`"`y_hat'"', 		///
		`"`predict_opt'"',	///
		`"`b_exog_vars'"',	///
		`"`touse'"',		///
		`"`esample'"',		///
		`"`b_exog'"',		///
		`"`lambdas'"',		///
		`"`rhos'"',		///
		`"`slow'"',		///
		`rtransform')
	label var `varlist' `"`var_lb'"'
end
					//----------------------------//
					// parsePredictOpt parses predict
					// options, and return appropriate
					// option and labels for new variable
					//----------------------------//
program parsePreOpt, sclass
	syntax [,			///
		RForm			///
		LImited			///
		FULL			///
		NAive			///
		xb			///
		direct			///
		indirect		///
		Residuals		///
		UCResiduals		///
		]

	local predict_opt `rform' `limited' `full' 	///
		`naive' `xb' `direct' `indirect' 	///
		`residuals' `ucresiduals'
	local case : word count `predict_opt'
	
	if (`case' >1) {
		di as err "only one {it:statistic} may be specified"
		exit 198
	}

	if (`case'==0) {
		di as txt "(option {bf:rform} assumed; reduced-form mean)"	
		local predict_opt rform
	}
						// check heteroskedasticity and
						// limited and full
	if ( (`"`predict_opt'"' == "limited" | 		///
		`"`predict_opt'"' == "full") 		///
		&(`"`e(het)'"' == "heteroskedastic") ){
		di as err "option {bf:`predict_opt'} not allowed "	///
			"with heteroskedastic"
		exit 198
	}
						// create labels based on
						// predict option
	if ("`predict_opt'" == "xb") {
		local var_lb "Linear prediction"
	}
	else if ("`predict_opt'" == "naive") {
		local var_lb "Naive-form prediction"
	}
	else if ("`predict_opt'" == "rform") {
		local var_lb "Reduced-form mean"
	}
	else if ("`predict_opt'" == "limited") {
		local var_lb "Limited-information mean"
	}
	else if ("`predict_opt'" == "full") {
		local var_lb "Full-information mean"
	}
	else if ("`predict_opt'" == "direct") {
		local var_lb "Direct mean"
	}
	else if ("`predict_opt'" == "indirect") {
		local var_lb "Indirect mean"
	}
	else if ("`predict_opt'" == "residuals") {
		local var_lb "Residuals"
	}
	else if ("`predict_opt'" == "ucresiduals") {
		local var_lb "Uncorrelated residuals"
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
		spmatrix lag double `var' `w' `y' if e(sample)
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
	
						// b_exog
	if (`"`e(constant)'"'=="hasconstant") {
		qui gen byte `cn_var' = 1 
		local b_exog_vars `e(x_lbs)' `cn_var' `exog_wy_vars' 	
	}
	else {
		local b_exog_vars `e(x_lbs)' `exog_wy_vars' 
	}
	sret local b_exog_vars `b_exog_vars'
end

program CheckTouse
	syntax , touse(string) esample(string)
	cap qui assert `esample' == 1 if `touse'
	if _rc {
		di as err "prediction sample must be a subset of e(sample)" 
		exit 498
	}
end
