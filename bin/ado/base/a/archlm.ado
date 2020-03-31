*! version 1.2.0  01nov2017
program define archlm, rclass
	version 7
	syntax [, Lags(numlist integer>0 sort) force ]

	if "`e(clustvar)'" != "" {
		di as err "{bf:estat archlm} does not work after "/*
			*/ "{bf:regress, vce(cluster} {it:clustvar}{bf:)}"
		exit 198
	}
	if "`e(cmd)'" ~= "regress" {
		di as err "This command only works after " 	/*
			*/ "{help regress:regress}"
		exit 301
	}
	if "`e(vcetype)'" == "Robust" & "`force'" == "" {
		di as err "you must specify {bf:force} after "/*
			*/ "{help vce_option:regress, vce(robust)}"
		exit 198
	}


	if "`lags'" == "" {
		local lags=1
	}
	
	tempname b
	mat `b' = e(b)
	local varlist : colnames `b'
	local nvar : word count `varlist'

	tempvar touse
	qui gen byte `touse' = e(sample)

					/* get time variables */
	_ts timevar panelvar if `touse', sort onepanel
	markout `touse' `timevar'
	
	tempname res2
					/* fetch residuals */
	qui predict double `res2' if `touse' , res
	qui replace `res2' = `res2'*`res2'
	qui count if `touse'
	return scalar N = r(N)

	tsreport if `touse',  report
	return scalar N_gaps = r(N_gaps)
	qui count if `touse'
	return scalar N = r(N)
	return scalar k = e(N) - e(df_r)

			/* check matrix dimension */
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
		if ``i'' >= return(N)-1 {
			local lag_err `lag_err' ``i''
		}
		local i = `i'+1
	}
	if "`lag_err'" ~= "" {
		noi di as err "lags(`lag_err') is too large for " /*
			*/ "the number of observations in the sample"
		exit 198
	}

	tempname regest

	noi di as text "LM test for autoregressive conditional " _c
	noi di as text "heteroskedasticity (ARCH)"
        noi di as text "{hline 13}{c TT}{hline 61}"
	noi di as text _col(5) "lags({it:p})" _col(14) "{c |}" /*
		*/  _col(25) "chi2" /*
		*/ _col(44) "df" _col(63) "Prob > chi2"
        noi di as text "{hline 13}{c +}{hline 61}"

	nobreak {
		estimates hold `regest'
		tempname arch df p
		tokenize `lags'
		local i 1
		while "``i''" != "" {
			cap noi Calc ``i'' `res2'
			if _rc {
				estimates unhold `regest'
				exit _rc
			}

			noi di as text _col(6) %3.0f ``i'' _col(14) "{c |}" /*
			*/ as result _col(20) %10.3f r(arch) /*
			*/ _col(43) %3.0f r(df) /*
			*/ _col(63) %8.4f r(p)
			mat `arch' = nullmat(`arch'), r(arch)
			mat `df' = nullmat(`df'), r(df)
			mat `p' = nullmat(`p'), r(p)
			local i = `i' + 1
		}
		mat colnames `arch' = `lags'
		mat colnames `p' = `lags'
		mat colnames `df' = `lags'
		mat coleq `arch' = lags
		mat coleq `p' = lags
		mat coleq `df' = lags

		estimates unhold `regest'
	}

       	noi di as text "{hline 13}{c BT}{hline 61}"
	noi di as text _col(10) "H0: no ARCH effects" /*
			*/ _col(35) "{it:vs.}" /*
			*/ _col(40) "H1: ARCH({it:p}) disturbance"

	return matrix arch `arch'
	return matrix df `df'
	return matrix p `p'
	return local lags `lags'
end

program define Calc, rclass
	args lags res2	

   					/* regress resids^2 on lagged 
					 * resids^2 to order `lags'  */
	qui regress `res2' l(1/`lags').`res2' 
	return scalar arch = e(N)*e(r2)
	return scalar df = `lags'
	return scalar p  = chiprob(`lags',return(arch))

end

