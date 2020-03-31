*! version 2.1.3  01feb2012
program define imtest, rclass
	version 8

	local ver : di "version " string(_caller()) ", missing :"

	if "`e(cmd)'" == "anova" {
		if 0`e(version)' < 2 {
			di as err ///
			"imtest not allowed after anova run with version < 11"
			exit 301
		}
	}
	else if "`e(cmd)'" != "regress" {
		di as err "imtest is only possible after regress"
		exit 301
	}
	if "`e(wtype)'" != "" {
		di as err "imtest does not support weights"
		exit 101
	}
	if "`e(clustvar)'" != "" {
		di as err "imtest does not support cluster()"
		exit 498
	}
	
	syntax [, Double Preserve White ]


quietly {

	tempname est w df b s2 uss
	tempvar res touse y y2

	local type = cond("`double'" != "", "double", "float")

	local lhs `e(depvar)'
	mat `b' = e(b)
	local RHS : colnames(`b')
	local RHS : subinstr local RHS "_cons" "", word
	foreach var of local RHS {
		_ms_parse_parts `var'
		if !r(omit) {
			local rhs `rhs' `var'
		}
	}
	local nrhs : list sizeof rhs

	if `nrhs' == 0 {
		noi di as txt "(imtest not allowed without covariates)"
		exit 0
	}		

	gen byte `touse' = e(sample)

	// keep only variables/observations needed lateron
 	if "`preserve'" != "" {
		preserve
		keep if `touse'
		unopvarlist `lhs' `RHS'
		keep `r(varlist)'
		local iftouse
	}
	else {
		local iftouse "if `touse'"
	}

	// -----------------------------------------------------------------
	// create temporary variates x(i)*x(j) i=1..n, j=1..i
	//
	// the variables are centered to improve numerical stability
	// centering does not effect the decomposition
	// -----------------------------------------------------------------

	tokenize `rhs'
	local k 0
	forvalues i = 1/`nrhs' {
		tempname mean`i'
		summ ``i'' `iftouse' , meanonly
		scalar `mean`i'' = r(mean)

		forvalues j = 1/`i' {
			local k = `k'+1
			tempvar x`k'
			gen `type' `x`k'' = (``i'' - `mean`i'') * ///
			                    (``j'' - `mean`j'') `iftouse'
			local rhs2  `rhs2' `x`k''
		}
	}
	compress

	scalar `s2' = e(rss)/e(N)
	predict `type' `res' `iftouse', res
	
	_est hold `est', restore

	// White's original test

	if "`white'" != "" {
		gen `type' `y' = `res'^2  `iftouse'
		`ver' regress `y' `rhs' `rhs2'  `iftouse'
		return scalar chi2 = e(N) * e(r2)
		return scalar df   = e(df_m)
		return scalar p    = chi2tail(return(df), return(chi2))
		drop `y'
	}

	// Cameron & Trivedi's decomposition

	// heteroskedasticity
	gen `type' `y'  = (`res')^2 - `s2'  `iftouse'
	gen `type' `y2' = (`y')^2
	summ `y2'  `iftouse'
	scalar `uss' = r(sum)   // uncentered ss
	`ver' regress `y' `rhs' `rhs2'  `iftouse'
	return scalar chi2_h = e(N)*(1 - e(rss)/`uss')
	return scalar df_h   = e(df_m)
	drop `y' `y2'

	// skewness
	gen `type' `y' = (`res')^3 - 3*`s2'*`res'  `iftouse'
	gen `type' `y2' = (`y')^2  `iftouse'
	summ `y2'  `iftouse'
	scalar `uss' = r(sum)   // uncentered ss 
	`ver' regress `y' `RHS'  `iftouse'
	return scalar chi2_s = e(N)*(1 - e(rss)/`uss')
	return scalar df_s   = e(df_m)
	drop `y' `y2'

	// kurtosis
	gen `type' `y' = (`res')^4 - 6*`s2'*(`res')^2 + 3*`s2'*`s2'  `iftouse'
	gen `type' `y2' = (`y')^2  `iftouse'
	summ `y2'  `iftouse'
	scalar `uss' = r(sum)    // uncentered ss
	`ver' regress `y'  `iftouse'
	return scalar chi2_k = e(N)*(1 - e(rss)/`uss')
	return scalar df_k   = 1
	drop `y' `y2'

	return scalar chi2_t = return(chi2_h) + return(chi2_s) + return(chi2_k)
	return scalar df_t   = return(df_h)   + return(df_s)   + return(df_k)
	
} /* quietly */

	
	// display results

	if "`white'" != "" {
		di _n as txt "White's test for Ho: homoskedasticity" _n ///
		   "         against Ha: unrestricted heteroskedasticity" _n

		di _col(10) as txt "chi2("              ///
		            as res `return(df)'         ///
		            as txt ")"                  ///
		   _col(23) "= "                        ///
		            as res %9.2f return(chi2)
		di _col(10) as txt "Prob > chi2  = "    /// 
		            as res %9.4f return(p)
	}

	di as txt _n "Cameron & Trivedi's decomposition of IM-test" _n

	#del ;
	di as txt "{hline 21}{c TT}{hline 29}" ;
	di as txt "{ralign 20:Source} {c |}       chi2     df      p" ;
	di as txt "{hline 21}{c +}{hline 29}" ;
	
	di as txt "{ralign 20:Heteroskedasticity} {c |}" 
	   as res %11.2f return(chi2_h)
	          %7.0f  return(df_h)
	          %10.4f chi2tail(return(df_h),return(chi2_h)) ;
	   
	di as txt "{ralign 20:Skewness} {c |}" 
	   as res %11.2f return(chi2_s)
	          %7.0f  return(df_s)
	          %10.4f chi2tail(return(df_s),return(chi2_s)) ;
	   
	di as txt "{ralign 20:Kurtosis} {c |}" 
	   as res %11.2f return(chi2_k)
 	          %7.0f  return(df_k)
	          %10.4f chi2tail(return(df_k),return(chi2_k)) ;
	   
	di as txt "{hline 21}{c +}{hline 29}" ;
	di as txt "{ralign 20:Total} {c |}" 
	   as res %11.2f return(chi2_t)
	          %7.0f  return(df_t)
	          %10.4f chi2tail(return(df_t),return(chi2_t)) ;
	   
	di as txt "{hline 21}{c BT}{hline 29}" ;
	#del cr
end
exit

The code for the imtest decomposition uses parts of ado code written 
by John Scott Long.


options

  double    specifies that -double-s are used for intermediate results

  preserve  specifies that data are unnecessary vars/obs are dropped
            to conserve memory; preserve ensures restoring the data.

  white     compute White's original test

