*! version 1.3.0  19feb2019
program define fracpred
	version 8
	if "`e(fp_cmd)'"!="fracpoly" error 301
	if "`e(cmd)'"=="stpm" | "`e(cmd2)'"=="stpm" {
		local xb [xb]
		local cmd stpm
	}
	else if "`e(cmd2)'"!="" local cmd "`e(cmd2)'"
	else local cmd "`e(cmd)'"


	if "`cmd'"=="mlogit" | "`cmd'"=="mprobit" {
		di as err "`cmd' not yet supported by fracpred"
		exit 198
	}

	local dist `e(fp_dist)'
	local y "`e(fp_depv)'"

	syntax newvarname [, For(str) Stdp Dresid All ]

	if "`dresid'"!="" & ("`cmd'"=="clogit" | "`cmd'"=="stcrreg") {
		di as err "dresid option of fracpred not supported for `cmd'"
		exit 198
	}

	// Fix to cope with -mim-
	if "`e(prefix2)'"=="mim" global S_esample _mim_e
	else global S_esample e(sample)

	local all = cond("`all'"=="", "if $S_esample", "")

	quietly if "`for'"=="" {
		tempvar yhat
		if `dist'==4 {
			predict double `yhat', xb
			if "`all'"!="" { 
				replace `yhat'=. if $S_esample==0 
			}
		}
		else 	_predict `yhat' `all', xb

	// predicted values and SE

		if "`dresid'"=="" {
			if "`stdp'"=="" {
				gen `typlist' `varlist'=`yhat'
				lab var `varlist' "predicted `e(fp_depv)'"
			}
			else {
				_predict `typlist' `varlist' `all', stdp
				lab var `varlist' "SE of predicted `e(fp_depv)'"
			}
		}

	// deviance residuals

		else {
			if "`e(fp_wgt)'"!="" & "`wts'"!="nowts" {
					/* for weighted residual calc */
				local exp "`e(fp_wexp)'" 
			}
			gen `typlist' `varlist'=.
			residual "`cmd'" `varlist' `yhat' "`exp'"
			lab var `varlist' "deviance residuals for `e(fp_depv)'"
		}
		exit
	}
	/*
		Identify index of "for" variable in `e(fp_fvl)'
		and #terms (nuse) it has.
	*/
	unabbrev `for', max(1)
	local for $S_1
	/*
		Start of PR bug fix: check for valid "for" variable.
	*/
	local i 1
	local xfor 0
	while `i'<=e(fp_nx) {
		if "`for'"=="`e(fp_x`i')'" {
			local xfor `i'
			local i = e(fp_nx)
		}
		local ++i
	}
	if `xfor'==0 {
		noi di as err "`for' was not an xvar"
		exit 198
	}
	if "`e(fp_k`xfor')'"=="." {
		noi di as err "`for' not selected in model"
		exit 198
	}
	local index 1
	local i 1
	while `i'<=e(fp_nx) {
		local terms: word count `e(fp_k`i')'
		/*
			Account for "catzero" variable, if present 
			(fracpoly, mfracpol)
		*/
		if "`e(fp_c`i')'"!="" local ++terms
		/*
			Count number of auxiliaries, which are to be skipped
			(used in boxtid, powexp, etc)
		*/
		if "`e(fp_a`i')'"!="" local nauxil `e(fp_a`i')'
		else local nauxil 0
		if "`for'"=="`e(fp_x`i')'" {
			local nuse `terms'
			local i = e(fp_nx)
		}
		else {
			/*
				If variable `i' is not in final model, it won't
				be in `e(fp_fvl)'.  It will have e(fp_k`i') 
				equal to ".".   Such variables should be
				ignored when identifying the position of
				variable `i' in `e(fp_fvl)'.
			*/
			if "`e(fp_k`i')'"!="." {
				local index=`index'+`terms'+`nauxil'
			}
		}
		local ++i
	}
	/*
		PR bug fix: check for "for" variable among xvarlist,
		Presence will cause 'nuse' to be nonnull.
	*/
	if "`nuse'"=="" {
		noi di as err "`for' not in model"
		exit 198
	}
	tempname V
	matrix `V'=e(V)
	if "`cmd'"=="stpm" matrix `V' = `V'["xb:", "xb:"]
	/*
		deal with constant
	*/
	local nfvl: word count `e(fp_fvl)'
	local ncons=`nfvl'+1
	if missing(`V'[`ncons',`ncons']) | "`cmd'"=="ologit" | "`cmd'"=="oprobit" local ncons 0

	tempvar v
	qui gen double `v'=0 `all'
	if "`stdp'"!="" {				/* SE */
		local nuse=`nuse'+`nauxil'
		vcalc `V' `index' `nuse' `v' `ncons'
		qui gen `typlist' `varlist'=sqrt(`v')
		lab var `varlist' "se(`for')"
	}
	else {						/* predicted */
		pcalc `index' `nuse' `v' `ncons' `xb'
		qui gen `typlist' `varlist'=`v'
		lab var `varlist' "xb(`for')"
	}
end

* 1=V, 2=first element to use in V, 3=# of vars to use,
* 4=vector of variances, 5=index of cons in VCE matrix, or 0 if no cons.
program define vcalc
	args V i1 nuse v ncons
	quietly {
		local i2=`i1'+`nuse'-1
		forvalues i=`i1'/`i2' {
			// name of ith predictor
			local xi: word `i' of `e(fp_fvl)'
			forvalues j=`i1'/`i' {
				local xj: word `j' of `e(fp_fvl)'
				replace `v' = `v'+((`j'<`i')+1)*`V'[`i',`j']*`xi'*`xj'
			}
		}
	/*
		deal with constant
	*/
		if `ncons'>0 {
			replace `v'=`v'+`V'[`ncons',`ncons']
			local i2=`i1'+`nuse'-1
			forvalues i=`i1'/`i2' {
				local xi: word `i' of `e(fp_fvl)'
				replace `v'=`v'+2*`V'[`ncons',`i']*`xi'
			}
		}
	}
end

* 1=first element to use in `e(fp_fvl)', 2=# of vars to use,
* 3=fitted values, 4=index of cons in VCE matrix, or 0 if no cons.
* If there are auxils, order in `e(fp_fvl)' is mainvars auxils mainvars 
* auxils...
program define pcalc
	args i1 nuse v ncons xb
	quietly {
		local i2=`i1'+`nuse'-1
		forvalues i=`i1'/`i2' {
			// name of ith predictor
			local xi: word `i' of `e(fp_fvl)'
			replace `v'=`v'+`xb'_b[`xi']*`xi'
		}
	/*
		deal with constant
	*/
		if `ncons'>0 replace `v'=`v'+`xb'_b[_cons]
	}
end


program define residual
/*
	Compute deviance residuals.
	Approach is to set output variable `r' to missing
	if these residuals are undefined. This won't hurt fracplot.
*/
	args cmd r eta exp
	local dist `e(fp_dist)'
	local y `e(fp_depv)'

	if `dist'==0 { // Normal
		replace `r' = `y'-`eta'
	}
	else if `dist'==1 { // works only for logit/probit; for other commands, set residuals to missing
		cap drop `r'
		cap predict `r', deviance
		if _rc gen `r' = .
	}
	else if `dist'==2 { // Poisson
		tempvar mu
		gen `mu' = exp(`eta')
		replace `r' = sign(`y'-`mu') /*
		 */ *sqrt(cond(`y'==0, 2*`mu', /*
		 */ 2*(`y'*log(`y'/`mu')-(`y'-`mu'))))
	}
	else if `dist'==3 {	// refit Cox model on linear predictor only
		local wgt [`e(fp_wgt)' `e(fp_wexp)']
		local opts `e(fp_opts)'
		tempvar touse
		gen byte `touse' = $S_esample
		tempname ests
		cap drop `r'
		_estimates hold `ests'
		capture quietly cox `y' `eta' `wgt' if `touse', /*
			*/ `opts' mgale(`r')
		local rc = _rc
		_estimates unhold `ests'
		if `rc' exit `rc'
		drop `touse'
		// deviance residuals
		local s=index("`opts'","dead(")
		local dead=bsubstr("`opts'",`s'+5,.)
		local s=index("`dead'",")")
		local dead=bsubstr("`dead'",1,`s'-1)
		replace `r'=sign(`r')*sqrt(-2*cond(`dead'==0, /*
		 */ `r', `r'+log1m(`r') ) )
		
	}
	else if `dist'==4 { // glm
		cap drop `r'
		predict `r', deviance
	}
	else if `dist'==7 {	// stcox, streg, stpm
		if "`cmd'"=="stcox" {
			local opts `e(fp_opts)'
			tempvar touse mgale
			gen byte `touse' = $S_esample
			tempname ests
			_estimates hold `ests'
			cap drop `r'
			capture quietly stcox `eta' if `touse', `opts' mgale(`mgale')
			local rc = _rc
			predict `r', deviance
			_estimates unhold `ests'
			if `rc' exit `rc'
			drop `touse'
		}
		else if "`cmd'"=="streg" {
			cap drop `r'
			predict `r', deviance
		}
	}
/*
	Note: other `dist' values neither accommodated nor trapped.
	Deviance residuals will be missing by default.
*/
	replace `r'=. if $S_esample==0
	if `"`exp'"'!="" {
		parse `"`exp'"', parse("=")
/*
	Weighted residuals using weights standardized Stata-fashion
*/
		sum `2' if $S_esample, meanonly
		replace `r' = `r'*sqrt(`2'/r(mean))
	}
end
