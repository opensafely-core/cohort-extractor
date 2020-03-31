*! version 2.0.3  15oct2019
program define nl_9_p
	version 8
	/* NB this predictor does not use _predict */
	if "`e(cmd)'" != "nl" {
		exit 301
	}
	
	syntax newvarname [if] [in] , [ Yhat Residuals * ]
	if "`yhat'" != "" & "`residuals'" != "" {
		di as error "options {bf:yhat} and {bf:residual} may not be specified together"
		exit 198
	}
	
	if "`yhat'" == "" & "`residuals'" == "" {
		di as text "(option {bf:yhat} assumed; fitted values)"
	}
	if "`e(type)'" != "3" & "`options'" != "" {
		local ops = plural(`:word count `options'', "option")
		di as error "`ops' {bf:`options'} not allowed"
		exit 198
	}
	
	tempvar touse 
	mark `touse' `if' `in'

	tempvar new
	if "`e(type)'" == "1" | "`e(type)'" == "2" {
		tempname parmvec	
		local expr `e(sexp)'
		local params `e(params)'
		matrix `parmvec' = e(b)
	
		/* Replace param names with parmvec columns */
		foreach parm of local params {
			local j = colnumb(`parmvec', "`parm'")
			local expr : subinstr local expr /*
				*/ "{`parm'}" "\`parmvec'[1,`j']", all
		}
		quietly generate double `new' = `expr'
	}
	else {
		tempname parmvec
		matrix `parmvec' = e(b)
		local rhs `e(rhs)'
		local prog `e(funcprog)'
		quietly generate double `new' = .
		capture `prog' `new' `rhs' , at(`parmvec') `options'
		if _rc {
			di as error "`prog' returned " _rc
			exit _rc
		}
	}
	if "`residuals'" != "" {
		if e(log_t) == 1 {
			quietly generate `typlist' `varlist' = 		/*
				*/ ln((`e(depvar)' - e(lnlsq)) /	/*
				*/ (`new' - e(lnlsq))) if `touse'
			local x = trim(string(e(lnlsq), "%8.0g"))
			label var `varlist' /*
				*/ "ln((`e(depvar)'-`x')/(yhat-`x'))"
		}
		else {
			quietly generate `typlist' `varlist' =		/*
				*/ `e(depvar)' - `new' if `touse'
			label var `varlist' "Residuals"
		}
	}
	else {
		quietly generate `typlist' `varlist' = `new' if `touse'
		label var `varlist' "Fitted values"
	}
end
