*! version 1.3.0  01nov2017
program define durbina, sort rclass
	syntax [, Lags(numlist integer>0 sort) Robust Small noMiss0 /*
		*/ force ] 
	version 7.0

	if "`e(clustvar)'" != "" {
		di as err "This command does not work after specifying "/*
			*/ "the {cmd:cluster()} option"
		exit 198
	}
	if "`e(cmd)'" ~= "regress" {
		if "`e(cmd)'" == "newey" {
		 	if "`force'" == "" {
				di as err "You must specify {cmd:force} "/*
					*/"for this command to work after "/*
					*/"{help newey:newey}"
				exit 198	
			}
		}
		else {
			di as err "This command only works after " 	/*
				*/ "{help regress:regress} and "	/*
				*/ "{help newey:newey}"
			exit 301
		}	
	}
	if "`e(vcetype)'" == "Robust" & "`force'" == "" {
		di as err "you must specify {cmd:force} after "/*
			*/ "{help regress:regress, robust}"
		exit 198
	}


	if "`robust'" ~= "" {
		if "`small'" ~= "" {
			di as err "-small- cannot be specified with " /*
				*/ "-robust-."
			exit 198
		}
		else {
			local small "small"
		}
	}

	if "`lags'" == "" {
		local lags=1
	}
		
	tempname b matt vcv res regest

	 		/* get regressorlist from previous regression */
	mat `b' = e(b)
	local varlist : colnames `b'
	local nvar : word count `varlist'
	local varlist : subinstr local varlist "_cons" "", /*
		*/ word count(local hascons)
	if !`hascons' { 
		local cons "noconstant" 
	}

	tempvar touse
	qui gen byte `touse' = e(sample)

					/* get time variables */
	_ts timevar panelvar if `touse', sort onepanel
	markout `touse' `timevar'

					/* fetch residuals */
	qui predict double `res' if `touse' , res

	tsreport if `touse',  report
	return scalar N_gaps = r(N_gaps)
	qui count if `touse'
	return scalar N = r(N) 
	return scalar k = e(N) - e(df_r)

			/* check matrix dimensions */
	local laglist `lags'
	local nlag : word count `laglist' 
	if `nlag' > 1 { 
		local laglist : subinstr local laglist " " ",", all
		local maxlag = max(`laglist')
	}
	else {
		local maxlag = `laglist'
	}
	if c(max_matdim) <= (`maxlag' + `nvar' + 1) {
		error 915
	}


	local lag_err
	tokenize `lags'
	local i 1
	while "``i''" != "" {
		if ``i'' >= return(N)-2 {
			local lag_err `lag_err' ``i''
		}
		local i = `i'+1
	}
	if "`lag_err'" ~= "" {
		noi di as err "lags(`lag_err') is too large for the " /*
			*/ "number of observations in the sample"
		exit 198
	}
	
			/* regress resids on lagged resids and regressorlist */
	if "`small'" == "" {
		local testname chi2
	}
	else {
		local testname F
	}

	noi di _n as text "Durbin's alternative test for autocorrelation" 

        noi di as text "{hline 13}{c TT}{hline 61}"
	noi di as text _col(5) "lags({it:p})" _col(14) "{c |}" /*
		*/ _col(25) "`testname'" /*
		*/ _col(44) "df" _col(63) "Prob > `testname'"
        noi di as text "{hline 13}{c +}{hline 61}"

	nobreak {
		estimates hold `regest'
		tempname chi2val pval chi2 F df df_r p
		tokenize `lags'
		local i 1
		while "``i''" != "" {
			cap noi Calc ``i'' `res' `"`varlist'"' `touse' /*
				*/ `"`miss0'"' `"`cons'"' `"`robust'"'
			if _rc {
				estimates unhold `regest'
				exit _rc
			}
			
			if "`small'" == "" {
				scalar `chi2val' = r(F)*r(df)
				scalar `pval' = chi2tail(r(df), `chi2val')

				noi di as text _col(6) %3.0f ``i'' /*
				*/ _col(14) "{c |}" /*
				*/ as result _col(20) %10.3f `chi2val' /*
				*/ _col(43) %3.0f r(df) /*
				*/ _col(63) %8.4f `pval'

				mat `chi2' = nullmat(`chi2'), `chi2val'
			}
			else {
				scalar `pval' = r(p)

				noi di as text _col(6) %3.0f ``i'' /*
				*/ _col(14) "{c |}" /*
				*/ as result _col(18) %10.3f r(F) /*
				*/ _col(39) "(" %3.0f r(df) "," /*
				*/ %5.0f r(df_r) " )" /*
				*/ _col(63) %8.4f r(p)

				mat `F' = nullmat(`F'), r(F)
				mat `df_r' = nullmat(`df_r'), r(df_r)
			}

			mat `df' = nullmat(`df'), r(df)
			mat `p' = nullmat(`p'), `pval'

			local i = `i' + 1
		}

		version 11: ///
		mat colnames ``testname'' = `lags'
		version 11: ///
		mat colnames `p' = `lags'
		version 11: ///
		mat colnames `df' = `lags'
		mat coleq ``testname'' = lags
		mat coleq `p' = lags
		mat coleq `df' = lags
	
		if "`small'" != "" {
			version 11: ///
			mat colnames `df_r' = `lags'
			mat coleq `df_r' = lags
			return matrix df_r `df_r'
		}

		estimates unhold `regest'
	}

        noi di as text "{hline 13}{c BT}{hline 61}"
	noi di as text _col(25) "H0: no serial correlation"

	return matrix `testname' ``testname''
	return matrix df `df'
	return matrix p `p'
	
	return local lags `lags'
end


program define Calc, rclass
	args lags 	/* lag order
	*/   res 	/* OLS residuals
	*/   varlist 	/* explanatory variables
	*/   touse 	/* e(sample)
	*/   dm 	/* Davidson-MacKinnon method
	*/   cons 	/* constant term
	*/   robust	/* robust */

	tsrevar l(1/`lags').`res'
	local reslist `r(varlist)'
			
			/* replace missing lag values in leading 
			   observations with zeros */
			/* we want to restrict the replacement of missing
			   values with zero to e(sample) only, useful when
			   -nosample- is specified */ 
	if "`dm'"=="" {
		foreach i of local reslist {
			qui replace `i' = 0 if `i' >= . & `touse'
		}
	}

	version 11: ///
	qui regress `res' `reslist' `varlist' if `touse', `cons' `robust'
	qui test `reslist'

	return scalar df_r = e(df_r)
	return scalar df = r(df)
	return scalar F = r(F)
	return scalar p = r(p)
end
