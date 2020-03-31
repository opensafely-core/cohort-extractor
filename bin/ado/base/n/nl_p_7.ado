*! version 1.1.3  15oct2019
program define nl_p_7
	version 6, missing
	/* Note that this predictor does not call back into predict */

	if "`e(cmd)'"!="nl" {
		/* we do this to ensure that clearing macros e`(params)'
		   will do no damage */
		error 301 
	}
	capture noisily Predict `0'
	mac drop `e(params)'
	exit _rc
end

program define Predict
	syntax newvarname [if] [in] [, Yhat Residuals ]

	if "`yhat'"!="" & "`residua'"!="" { 
		version 7: di in red "options {bf:yhat} and {bf:residual} may not be specified together"
		exit 198
	}

	if "`yhat'"=="" & "`residua'"=="" {
		version 7: di in gr "(option {bf:yhat} assumed; fitted values)"
	}

	tempvar touse new 
	mark `touse' `if' `in'

	quietly {
		local k 1
		while `k' <= e(k) { 
			local word : word `k' of `e(params)'
			global `word' = _b[`word']
			local k=`k'+1
		}
		gen double `new' = . 
		`e(version)' nl`e(function)' `new' `e(f_args)' , `e(options)'
	}

	if "`residua'"!="" {
		if e(log_t) {
			gen `typlist' `varlist' = ln((`e(depvar)'-e(lnlsq))/ /*
				*/ (`new'-e(lnlsq))) if `touse'
			local x = trim(string(e(lnlsq),"%8.0g"))
			label var `varlist' "ln((`e(depvar)'-`x')/(yhat-`x'))"
		}
		else {
			gen `typlist' `varlist' = `e(depvar)'-`new' if `touse'
			label var `varlist' "Residuals"
		}
	}
	else {
		gen `typlist' `varlist' = `new' if `touse'
		label var `varlist' "Fitted values"
	}
end
