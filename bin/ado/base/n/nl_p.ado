*! version 2.1.6  15oct2019
program define nl_p

	version 8
	/* NB this predictor does not use _predict */
	if "`e(cmd)'" != "nl" {
		exit 301
	}

	syntax anything(name=vlist) [if] [in] , /*
		*/ [ Yhat Residuals SCores Pr(string) E(string) YStar(string) ]

	tempvar touse 
	mark `touse' `if' `in'

	/* in case pr, e, or ystar has spaces in it, gen an indicator var */
	foreach x in pr e ystar {
		local `x's ""
		if "``x''" != "" {
			local `x's "yes"
		}
	}
	local allopts "`yhat' `residuals' `scores' `prs' `es' `ystars'"
	local k : word count `allopts'
	if `k' > 1 {
		di as error "may only specify one type of prediction"
		exit 198
	}
	if `k' == 0 {
		di as txt "(option {bf:yhat} assumed; fitted values)"
		local yhat yhat
	}

	if e(log_t) == 1 {
		if "`pr'" != "" {
di as error "option {bf:pr()} not allowed with log-transformed model"
exit 198
		}
		if "`e'" != "" {
di as error "option {bf:e()} not allowed with log-transformed model"
exit 198
		}
		if "`ystar'" != "" {
di as error "option {bf:ystar()} not allowed with log-transformed model"
exit 198
		}
	}
	
	if "`scores'" == "" {
		local 0 `vlist'
		syntax newvarname
	}
	else {
		_stubstar2names `vlist' , nvars(`=e(k)')
		local typlist `s(typlist)'
		local varlist `s(varlist)'
	}
	
	if "`yhat'`residuals'`scores'`prs'`es'`ystars'" == "" {
		di as text "(option {bf:yhat} assumed; fitted values)"
		local yhat "yhat"
	}
	if "`e(type)'" != "3" & "`options'" != "" {
		local ops = plural(`:word count `options'', "option")
		di as error "`ops' {bf:`options'} not allowed"
		exit 198
	}
	
	tempvar yh
	if "`e(type)'" == "1" | "`e(type)'" == "2" {
		tempname parmvec	
		matrix `parmvec' = e(b)
		local expr `e(sexp)'
		local params `e(params)'
	
		/* Replace param names with parmvec columns */
		foreach parm of local params {
			local j = colnumb(`parmvec', "`parm':_cons")
			local expr : subinstr local expr /*
				*/ "{`parm'}" "\`parmvec'[1,`j']", all
		}
		quietly generate double `yh' = `expr' if `touse'
	}
	else {
		tempname parmvec
		matrix `parmvec' = e(b)
		local params `e(params)'
		local rhs `e(rhs)'
		local prog `e(funcprog)'
		quietly generate double `yh' = .
		capture `prog' `yh' `rhs' if `touse' , at(`parmvec') `options'
		if _rc {
			di as error "`prog' returned " _rc
			exit _rc
		}
	}
	
	if "`yhat'" != "" {
		quietly generate `typlist' `varlist' = `yh' if `touse'
		label var `varlist' "Fitted values"
	}
	else if "`residuals'" != "" {
		if e(log_t) == 1 {
			quietly generate `typlist' `varlist' = 		/*
				*/ ln((`e(depvar)' - e(lnlsq)) /	/*
				*/ (`yh' - e(lnlsq))) if `touse'
			local x = trim(string(e(lnlsq), "%8.0g"))
			label var `varlist' /*
				*/ "ln((`e(depvar)'-`x')/(yhat-`x'))"
		}
		else {
			quietly generate `typlist' `varlist' =		/*
				*/ `e(depvar)' - `yh' if `touse'
			label var `varlist' "Residuals"
		}
	}
	else if "`scores'" != "" {
		tempvar yhnew
		tempname delta old_pj incr
		
		scalar `delta' = `e(delta)'
		qui gen double `yhnew' = .
		
		local i 1
		foreach parm of local params {
			tempvar J`i'
			local parmcol = colnumb(`parmvec', "`parm':_cons")
			scalar `old_pj' = `parmvec'[1, `parmcol']
			scalar `incr' = `delta'*(abs(`old_pj') + `delta')
			matrix `parmvec'[1, `parmcol'] = `old_pj' + `incr'
			if `e(type)' < 3 {
				cap replace `yhnew' = `expr' if `touse'
				if _rc {
					local rc = _rc
					noi di as error "error evaluating expression"
					exit _rc
				}
			}
			else {
				capture `prog' `yhnew' `rhs' if `touse', /*
					*/ at(`parmvec') `options'
				if _rc {
					local rc = _rc
					noi di as error "error evaluating expression"
					exit _rc
				}
			}
			cap assert `yhnew' < . if `touse'
			if _rc {
				noi di as error "cannot calculate derivatives"
				exit 481
			}
			if `e(log_t)' == 1 {
				qui gen double `J`i'' = ln( 		   /*
					*/ (`yhnew'-`e(lnlsq)') / 	   /*
					*/ (`yh' - `e(lnlsq)') ) / `incr'  /*
					*/ if `touse'
			}
			else {
				qui gen double `J`i'' = /*
					*/ (`yhnew' - `yh')/`incr'	   /*
					*/ if `touse'
			}
			matrix `parmvec'[1, `parmcol'] = `old_pj'
			local ++i
		}
		
		/* The scores are just df/db * residual 		*/
		local i 1
		foreach var of local varlist {
			local typ : word `i' of `typlist'
			local parm : word `i' of `params'
			if e(log_t) == 1 {
				qui gen `typ' `var' = 			/*
				*/	`J`i'' * 			/*
				*/	ln((`e(depvar)' - e(lnlsq)) /	/*
				*/	    (`yh' - e(lnlsq))) if `touse'
			}
			else {
				qui gen `typ' `var' = 			/*
				*/	`J`i'' * (`e(depvar)' - `yh')	/*
				*/	if `touse'
			}
			label variable `var' "score for parameter `parm'"
			local ++i
		}
	}
	else {
		tempvar L U
		qui gen double `L' = .
		qui gen double `U' = .
		_get_lb_ub, pr(`pr') e(`e') ystar(`ystar') lvar(`L') uvar(`U') touse(`touse')
		local lb `s(lb)'
		local ub `s(ub)'
		local ttl `s(ttl)'
		
		tempvar normub normlb normdenub normdenlb
		qui gen double `normub' = normal((`U' - `yh')/`e(rmse)')
		qui replace `normub' = 1 if mi(`U')
		qui gen double `normlb' = normal((`L' - `yh')/`e(rmse)')
		qui replace `normlb' = 0 if mi(`L')
		qui gen double `normdenub' = normalden((`U' - `yh')/`e(rmse)')
		qui replace `normdenub' = 0 if mi(`U')
		qui gen double `normdenlb' = normalden((`L' - `yh')/`e(rmse)')
		qui replace `normdenlb' = 0 if mi(`L')
		if "`pr'" != "" {
			qui gen `typlist' `varlist' = `normub' - `normlb' /*
				*/ if `touse'
			lab var `varlist' "`ttl'"
		}
		else if "`e'" != "" {
			qui gen `typlist' `varlist' = `yh' - 		  /*
			*/ 	`e(rmse)'*( (`normdenub' - `normdenlb') / /*
			*/		    (`normub' - `normlb') )	  /*
			*/		    if `touse'
			lab var `varlist' "`ttl'"
		}
		else {
			tempvar plow pmid e
			qui predict double `plow', pr(., `L')
			qui predict double `pmid', pr(`L', `U')
			qui predict double `e', e(`L', `U')
			qui gen `typlist' `varlist' = `e' 		/*
			*/	if mi(`L') & mi(`U') & `touse'
			qui replace `varlist' = `plow'*`L' +		/*
			*/	(1-`plow')*`e' 				/*
			*/	if !mi(`L') & mi(`U') & `touse'
			qui replace `varlist' = `pmid'*`e' +		/*
			*/	(1-`pmid')*`U'				/*
			*/	if mi(`L') & !mi(`U') & `touse'
			qui replace `varlist' = `plow' * `L' +		/*
			*/	`pmid'*`e' + (1-`plow'-`pmid')*`U'	/*
			*/	if !mi(`L') & !mi(`U') & `touse'
			lab var `varlist' "`ttl'"
		}
	}

end

