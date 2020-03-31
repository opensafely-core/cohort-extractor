*! version 1.3.3  15oct2019
program define ivregress_p
	version 10
	local vv : di "version " string(_caller()) ":"

	// See if scores were requested
	syntax [anything] [if] [in] , [SCores *]
	if "`scores'" != "" {
		`vv' CalcScores `anything' `if' `in' , `options'
		exit
	}
	
	// Take care of xb quickly if we can
	local myopts Residuals STDP STDF Pr(string) E(string) ///
		YStar(string)
	_pred_se "`myopts'" `0'
	if `s(done)' {
		exit
	}
	local vtype `s(typ)'
	local varn  `s(varn)'
	local 0     `"`s(rest)'"'	

	syntax [if] [in] [, XB Residuals STDP STDF Pr(string) 	///
			    E(string) YStar(string)]
	marksample touse
	
	local mostopts `scores'`stdp'`stdf'`pr'`e'`ystar'
	if "`mostopts'" != "" {
		if `"`pr'"' != "" {
			local mostopts "pr()"
		}
		else if `"`e'"' != "" {
			local mostopts "e()"
		}
		else if `"`ystar'"' != "" {
			local mostopts "ystar()"
		}
		if "`e(estimator)'" == "gmm" {
			di as err "option {bf:`mostopts'} not available with GMM estimator"
			exit 198
		}
		if "`e(vcetype)'" != "" & "`mostopts'"!="stdp" {
			di as err "option {bf:`mostopts'} not available with robust VCEs"
			exit 198
		}
	}
	
	if "`xb'`residuals'`mostopts'" == "" {
		di as text "(option {bf:xb} assumed; fitted values)"
		local xb xb
	}
	
	if "`xb'" != "" & "`residuals'" != "" {
		opts_exclusive "xb residuals"
	}
	if "`e'" != "" & "`residuals'" != "" {
		opts_exclusive "e() residuals"
	}
	if "`pr'" != "" & "`residuals'" != "" {
		opts_exclusive "pr() residuals"
	}
	if "`ystar'" != "" & "`residuals'" != "" {
		opts_exclusive "ystar() residuals"
	}
	if "`stdp'" != "" & "`residuals'" != "" {
		opts_exclusive "stdp residuals"
	}
	if "`stdf'" != "" & "`residuals'" != "" {
		opts_exclusive "stdf residuals"
	}
	if "`mean'" != "" & "`residuals'" != "" {
		opts_exclusive "mean residuals"
	}
	if "`stdp'"!= ""  & "`stdf'" != "" {
		opts_exclusive "stdp stdf"
	}
	if "`xb'`residuals'" != "" {
		tempvar y
		if "`xb'" != "" {
			_predict `vtype' `varn' if `touse'
		}
		else {	
			qui _predict double `y' if `touse'
			gen `vtype' `varn' = `=e(depvar)' - `y' if `touse'
			label var `varn' "Residuals"
		}
		exit
	}

	if "`stdp'" != "" {
		_predict `vtype' `varn' if `touse', stdp
		exit
	}
	
	if "`stdf'" != "" {
		tempvar stdp h
		qui _predict double `stdp' if `touse', stdp
		qui gen double `h' = (`stdp' / e(rmse))^2 if `touse'
		gen `vtype' `varn' = e(rmse)*sqrt(1 + `h') if `touse'
		label var `varn' "S.E. of the forecast"
		exit
	}

	// At this point, we're pr, e, or ystar
	regre_p2 `"`vtype'"' `"`varn'"' `"`touse'"' "" 		///
		 `"`pr'"' `"`e'"' `"`ystar'"' "e(rmse)"
	exit
	
end

program CalcScores
	version 10
	local vv : di "version " string(_caller()) ":"

	syntax anything(name = vlist) [if] [in] [, *]
	
	if "`options'" != "" {
		local ops = plural(`:word count `options'', "option")
		di as error "`ops' {bf:`options'} not allowed"
		exit 198
	}
	
	marksample touse

	_ms_op_info e(b)
	if r(fvops) & _caller() < 11 {
		local vv "version 11:"
	}

	// # of scores = # of endog vars + 1(if constant or exog vars)
	tempname b
	matrix `b' = e(b)
	local nscores : word count `e(instd)'
	if colsof(`b') > `nscores' {
		local `++nscores'
	}
	
	capture _stubstar2names `vlist', nvars(`nscores')
	if _rc {
		if _rc == 102 | _rc == 103 {
			if _rc == 102 {
				di as error "too few variables specified"
			}
			else {
				di as error "too many variables specified"
			}
			if `:word count `e(instd)'' != `nscores' {
				di as error 	///
"you must specify `nscores' new variables, " `nscores'-1 " for each endogenous"
				di as error	///
"regressor and 1 for the exogenous regressors"
			}
			else {
				di as error	///
"since the model has no exogenous regressors, you must specify"
				di as error	///
"`nscores' new variables, 1 for each endogenous regressor"
			}
		}
		exit _rc
	}
	else {
		// Redo to get full error message
		_stubstar2names `vlist', nvars(`nscores')
	}
	local typlist `s(typlist)'
	local varlist `s(varlist)'
	
	local bstripe : colnames `b'
	local endog `e(instd)'
	local allinst `e(insts)'
	local nocons
	if "`e(constant)'" != "" {
		local nocons "noconstant"
	}
	local wexp `"[`e(wtype)'`e(wexp)']"'
	tempvar esample resid
	gen byte `esample' = e(sample)
	predict double `resid' if `touse', residual
	
	// Scores only valid in sample
	qui replace `touse' = 0 if `esample' == 0
	
	tempname usrest
	_estimates hold `usrest', restore
	tempvar scorewrk
	local i 1
	tempvar endotmp
	foreach y of local endog {
		cap drop `scorewrk'
		local scorei : word `i' of `varlist'
		qui gen double `endotmp' = `y' if `esample'
		qui `vv' _regress `endotmp' `allinst' `wexp' ///
			if `esample', `nocons'
		qui predict double `scorewrk' if `touse', xb
		qui gen `typlist' `scorei' = `scorewrk'*`resid' if `touse'
		label var `scorei' "score for endogenous variable `y'"
		drop `endotmp'
		local `++i'
	}
		
	// Final score for exog vars or constant if present
	if `i' == `nscores' {
		local scorei : word `i' of `varlist'
		qui gen `typlist' `scorei' = `resid' if `touse'
		label var `scorei' "residuals"
	}
	
end
