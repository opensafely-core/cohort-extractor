*! version 1.0.2  06nov2018
program sbknown
	version 14.0

	tempname b LastEstimates
	tempvar  touse

/**get regressorlist from previous regression**/
	mat `b' = e(b)
	local varlist : colnames `b'
	local nvar : word count `varlist'
	local varlist : subinstr local varlist "_cons" "", word 	/*
		*/ count(local hascons)
	if (!`hascons') local cons "noconstant"

	qui gen byte `touse' = e(sample)

	if ("`e(cmd)'"=="arima") {
		local varlist : subinstr local varlist "_cons" ""
		local ar_vars `varlist'
		foreach var of local varlist {
			_ms_parse_parts `var'
			if ("`r(name)'"=="ar") local ar_vars: list ar_vars - var
		}
		local varlist `ar_vars'
	}
/**get time variables**/
        _ts timevar panelvar if `touse', sort onepanel
	local fmt : format `timevar'
	markout `touse' `timevar'

	qui tsreport if `touse', `detail'
	local gaps `r(N_gaps)'
	if (`gaps'!=0) {
		di as err "{p 0 8 2} gaps not allowed{p_end}"
		exit 198
	}


	tempname LastEstimates ModelEstimates
	_estimates hold `LastEstimates', copy restore
	estimates store `ModelEstimates'	

	local modelvars `varlist'
	syntax [anything] , break(string) [ breakvars(string) lr wald ]
	sbtest_known `modelvars', breakvars(`breakvars') 	    	    ///
			break(`break') `lr' `wald' mcons(`cons') 	    ///
			touse(`touse') model_est(`ModelEstimates') tform(`fmt')
	
end


program sbtest_known, rclass
	syntax [anything], break(string) [ breakvars(string) wald     	    ///
				lr mcons(string) touse(string)		    ///
				model_est(string) tform(string)] 

	local varlist `anything'
	local nbreak : word count `break'
	if (`nbreak'>1) local break : list sort break
	tempvar __N
	qui gen `c_obs_t)' `__N' = _n 

	_ts timevar panelvar if `touse', sort onepanel
	qui sum `timevar' if `touse'
	local bdate = `r(min)'
	local edate = `r(max)'
	qui estimates restore `model_est'
	local cmd `e(cmd)'
	if ("`cmd'"=="ivregress" & "`lr'"!="") {
		di as err "{p}{bf:LR} test may not be specified with "
		di as err "{bf:ivregress}{p_end}"
		exit 198
	}
	local nparams = `e(rank)'*(`nbreak'+1)

	local stdate `bdate'
	foreach i of local break {
		if (`i'<`bdate' | `i'>`edate') {
			di as err "{p}break date must be in the original"
			di as err "sample{p_end}"
			exit 198
		}
		local lminobs = `i'-`stdate'
		local rminobs = `edate'-`i'
		if (`lminobs'<`nparams' | `rminobs'<`nparams') {
			di as err "{p}insufficient observations at the "
			di as err "specified break date{p_end}"
			exit 198
		}
		qui levelsof `__N' if `timevar'==`i' & `touse', local(brkobs)
		local brkobs = `__N'[`brkobs']
		local _break `_break' `brkobs'
		local stdate `i'
	}

	if ("`breakvars'"!="") {
		_sbchkvars `varlist', breakvars(`breakvars') mcons(`mcons')
		local tmpbvars `s(breakvars)'
		local nonbrkvars : list varlist - tmpbvars
		if ("`tmpbvars'"!="") local brkvars `tmpbvars'
		if ("`s(breakcons)'"!="") local breakcons `s(breakcons)'
	}
	else if ("`breakvars'"=="") {
		local brkvars `varlist'
		if ("`mcons'"=="")	local breakcons constant
	}
	opts_exclusive "`wald' `lr'"
	if ("`wald'"=="" & "`lr'"=="" | "`wald'"!="") local test wald
	else local test lr

	_chowtest `brkvars', break(`_break') test(`test') 		    ///
		modelcons(`mcons') breakcons(`breakcons') touse(`touse')    ///
		model_est(`model_est') nonbrk(`nonbrkvars')


/**Setup output**/

	local df = `r(df)'
	if ("`test'"=="wald") {
		if ("`r(F)'"!="") local chistat = `r(df)'*`r(F)'
		else if ("`r(chi2)'"!="") local chistat = `r(chi2)'
		local pval = chi2tail(`r(df)',`chistat')
	}
	else if ("`test'"=="lr") {
		local chistat = `r(chi2)'
		local pval = `r(p)'
	}

	_ts timevar panelvar if `touse', sort onepanel
	qui tsset
	if ("`r(unit1)'"!="." & "`r(unit1)'"!="g") {
		local bdate   : di `tform' `bdate'
		local edate   : di `tform' `edate'
		if (wordcount("`break'")==1) {
			local brkdate : di `tform' `break'
		}
		else {
			local break : list sort break
			foreach i of local break {
				local _brkdate : di `tform' `i'	
				local brkdate `brkdate' `_brkdate' 
			}
		}
	}
	else local brkdate `break'

	
	if ("`test'"=="wald")		local testtype Wald
	else if ("`test'"=="lr")	local testtype LR


/**Print output**/
	di as txt _n "`testtype' test for a structural break: Known break date"
	di as txt _n "{col 35}Number of obs {col 50}= " as res %10.0fc e(N)
	local disample "{txt:Sample}:{col 13}{res: `bdate' - `edate'} "
	if (length(`"`bdate' - `edate'"')>=39) di _n "`disample'"
	else di "`disample'"
	di as txt "Break date: " _col(14) as res "`brkdate'"
	di as txt "Ho: No structural break"
	di as txt _n _col(14) "chi2(" as res `df' as txt ")" _col(27)    ///
		"="  as res %10.04f `chistat'
	di as txt _col(14) "Prob > chi2" _col(27) "=" as res %10.04f `pval'
		
	if ("`breakcons'"!="")	local bcons _cons
	if ("`varlist'"!="") {
		di in smcl _n "{p 0 35 0}{txt}Exogenous variables: {space 10}`varlist'{p_end}"
		di in smcl "{p 0 35 0}{txt}Coefficients included in test: `brkvars' `bcons'{p_end}"
	}
	else di as txt _n "Coefficients included in test: `bcons'"

/**Return results**/
	return scalar chi2 = `chistat'
	return scalar p = `pval'
	return scalar df = `df'
	return local test = "`test'" 
	return local breakvars = "`brkvars' `bcons'"
	return local breakdate = "`brkdate'"

end
