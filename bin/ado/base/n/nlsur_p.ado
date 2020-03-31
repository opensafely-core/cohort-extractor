*! version 1.1.3  15oct2019
program define nlsur_p

	version 9
	/* NB this predictor does not use _predict */
	if "`e(cmd)'" != "nlsur" {
		exit 301
	}
	
	syntax anything(name=vlist) [if] [in] , /*
		*/ [ Yhat Residuals Equation(string) ]
	
	tempvar touse 
	mark `touse' `if' `in'

	local allopts "`yhat' `residuals'"
	if `:word count `allopts'' > 1 {
		di as error "may only specify one type of prediction"
		exit 198
	}
	
	if "`equation'" != "" {
		local equation `=trim("`equation'")'
		local myrc = 0
		if bsubstr("`equation'",1,1) != "#" {
			local myrc = 1
		}
		else {
			local equation `=bsubstr("`equation'", 2, .)'
		}
		capture confirm integer number `equation'
		if _rc != 0 | `myrc' != 0 {
			di as error "option {bf:equation()} misspecified"
			exit 303
		}
		if `equation' < 1 | `equation' > `e(k_eq)' {
			di as error "equation number out of range"
			exit 303
		}
		if `:word count `vlist'' > 2 {
			di as error "too many variables specified"
			exit 103
		}
		if `:word count `vlist'' == 2 {
			local typlist `:word 1 of `vlist''
			local varlist `:word 2 of `vlist''
		}
		else {
			local typlist "float"
			local varlist `vlist'
		}
		
	}
	else {
		_stubstar2names `vlist' , nvars(`=e(k_eq)') singleok
		local typlist `s(typlist)'
		local varlist `s(varlist)'
		if `:list sizeof varlist' == 1 {
			local equation 1
		}
	}
	
	if "`yhat'`residuals'" == "" {
		di as text "(option {bf:yhat} assumed; fitted values)"
		local yhat "yhat"
	}
	if "`e(type)'" == "1" & "`options'" != "" {
		local ops = plural(`:word count `options'', "option")
		di as error "`ops' {bf:`options'} not allowed"
		exit 198
	}
	
	if "`e(type)'" == "1" | "`e(type)'" == "2" {
		tempname parmvec	
		matrix `parmvec' = e(b)
		forvalues i = 1/`e(k_eq)' {
			local expr`i' `e(sexp_`i')'
		}
		local params `e(params)'
	
		/* Replace param names with parmvec columns */
		foreach parm of local params {
			local j = colnumb(`parmvec', "`parm':_cons")
			forvalues i = 1/`e(k_eq)' {
				local expr`i' : subinstr local expr`i' /*
					*/ "{`parm'}" "\`parmvec'[1,`j']", all
			}
		}
		if "`equation'" != "" {
			tempvar yh`equation'
			quietly generate double `yh`equation'' = 	///
				`expr`equation'' if `touse'
		}
		else {
			forvalues i = 1/`e(k_eq)' {
				tempvar yh`i'
				quietly generate double `yh`i'' = 	///
					`expr`i'' if `touse'
			}
		}
	}
	else {
		tempname parmvec
		matrix `parmvec' = e(b)
		local params `e(params)'
		local rhs `e(rhs)'
		local prog `e(funcprog)'
		local yh
		forvalues i = 1/`e(k_eq)' {
			tempvar yh`i'
			quietly generate double `yh`i'' = .
			local yh `yh' `yh`i''
		}
		capture `prog' `yh' `rhs' if `touse' , at(`parmvec') `options'
		if _rc {
			di as error "`prog' returned " _rc
			exit _rc
		}
	}
	
	if "`equation'" != "" {
		if "`yhat'" != "" {
			qui gen `typlist' `varlist' = `yh`equation'' if `touse'
			label var `varlist' "Equation `equation' fitted values"
		}
		else if "`residuals'" != "" {
			qui gen `typlist' `varlist' = 			///
				`e(depvar_`equation')' - `yh`equation'' ///
				if `touse'
			label var `varlist' "Equation `equation' residuals"
		}
	}
	else {
		forvalues i = 1/`e(k_eq)' {
			local v : word `i' of `varlist'
			if "`yhat'" != "" {
				quietly generate `typlist' `v' = 	///
					`yh`i'' if `touse'
				label var `v' "Equation `i' fitted values"
			}
			else if "`residuals'" != "" {
				quietly generate `typlist' `v' =	///
					`e(depvar_`i')' - `yh`i'' 	///
					if `touse'
				label var `v'				///
					"Equation `i' residuals"
			}
		}
	}

end

