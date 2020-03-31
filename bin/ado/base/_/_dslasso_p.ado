*! version 1.0.0  07jun2019
/*
	double selection Lasso prediction
*/
program _dslasso_p
	version 16.0

	if ( `"`e(cmd)'"' != "dsregress" & 		///
		`"`e(cmd)'"' != "dslogit" & 		///
		`"`e(cmd)'"' != "dspoisson" & 		///
		`"`e(cmd)'"' != "poregress" & 		///
		`"`e(cmd)'"' != "xporegress" & 		///
		`"`e(cmd)'"' != "pologit" & 		///
		`"`e(cmd)'"' != "xpologit" & 		///
		`"`e(cmd)'"' != "popoisson" & 		///
		`"`e(cmd)'"' != "xpopoisson" & 		///
		`"`e(cmd)'"' != "poivregress" &		///
		`"`e(cmd)'"' != "xpoivregress" ) {
		error 301
	}

	syntax newvarname [if] [in] [, *]
						//  marksample
	marksample touse, novarlist
						//  get prediction options
	ParsePreOpt , `options'
	local preopt `s(preopt)'
	local var_lb `s(var_lb)'
						//  compute prediction
	tempvar yhat
	qui gen `typlist' `yhat' = . 
	ComputePredict, yhat(`yhat') preopt(`preopt') touse(`touse')

						//  copy to the target var
	qui gen `typlist' `varlist' = `yhat' if `touse'
	label var `varlist' `"`var_lb'"'
end
					//----------------------------//
					// parse prediction options
					//----------------------------//
program ParsePreOpt, sclass
	syntax [, xb]

	local model `e(model)'

	local preopt `xb' 
	local n_case : list sizeof preopt

	if (`n_case' > 1) {
		di as err "only one {it:statistic} may be specified"
		exit 198
	}
						//  default case
	local def_txt "(option {bf:xb} assumed); partial linear prediction"	
	local def_preopt xb

	if (`n_case'==0) {
		di as txt `"`def_txt'"'
		local preopt `def_preopt'
	}

	if (`"`preopt'"' == "xb") {
		local var_lb "Partial linear prediction"
	}

	sret local preopt `preopt'
	sret local var_lb `var_lb'
end
					//----------------------------//
					// compute prediction
					//----------------------------//
program ComputePredict
	syntax , yhat(string)	///
		preopt(string)	///
		touse(string)
	
	tempvar xb
	_predict double `xb' if `touse'

	if (`"`preopt'"' == "xb") {
		qui replace `yhat' = `xb' if `touse'
	}
	else if (`"`preopt'"' == "pr") {
		tempvar exp_xb
		qui gen double `exp_xb' = exp(`xb') if `touse'
		qui replace `yhat' = `exp_xb'/(1+`exp_xb') if `touse'
	}
	else if (`"`preopt'"' == "n") {
		qui replace `yhat' = exp(`xb') if `touse'
	}
end
