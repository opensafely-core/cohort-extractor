*! version 1.0.4  09feb2015
program _xturfisher, rclass sortpreserve

	version 10
	
	syntax varname(ts) [if] [in],				///
		[ DFUller PPerron DEMEAN 			///
		  GENerate(string)	/* undocumented	*/	///
		  NOConstant TRend DRift Lags(string) ]
		
	tsunab usrdepvar : `varlist'
	marksample touse
	
	_xt, trequired
	capture xtset
	tempname usrdelta
	local panelvar  `r(panelvar)'
	local timevar   `r(timevar)'
	sca `usrdelta' =  `r(tdelta)'

	
	local k : word count `dfuller' `pperron'
	if `k' == 0 {
		di in smcl as error "must specify one of {bf:dfuller} " _c
		di in smcl as error "or {bf:pperron}"
		exit 198
	}
	else if `k' > 1 {
		di in smcl as error "can specify only one of {bf:dfuller} " _c
		di in smcl as error "or {bf:pperron}"
		exit 198
	}
	local testcmd `dfuller' `pperron'
	if "`testcmd'" == "pperron" & "`drift'" != "" {
		di in smcl as error 	///
			"cannot specify {bf:drift} with {bf:pperron}"
		exit 198
	}
	if "`noconstant'" != "" {
		di in smcl as error	///
"cannot specify {bf:noconstant} because p-values are not available in this case"
		exit 498
	}
	if "`lags'" == "" {
		di in smcl as error "must specify {bf:lags()}"
		exit 198
	}
	
	local usrlags `lags'			// backup
	local options `noconstant' `trend' `drift' lags(`lags')
	
	// Doesn't require strongly balanced sample; gaps okay too
	// keep track of unbalanced for display purposes
	qui _xtstrbal `panelvar' `timevar' `touse'
	if "`r(strbal)'" != "yes" {
		local unbalanced unbalanced
	}

	// remove cross-sectional averages for each time period
	tempvar depvar mean
	if "`demean'" != "" {
		_xturdemean `depvar' : `usrdepvar' `timevar' `touse'
	}
	else {
		gen double `depvar' = `usrdepvar'
	}

       // generate a panel var = 1...N so we can loop
       tempvar obvar id pantouse
       gen `c(obs_t)' `obvar' = _n
       qui bys `panelvar' (`timevar'): gen long `pantouse' = sum(`touse')
       qui by `panelvar' (`timevar'): replace `pantouse' = (`pantouse'[_N]>0)
       qui by `panelvar' (`timevar'): gen `c(obs_t)' `id' = 1 if _n==1 & `pantouse'
       qui replace `id' = sum(`id')
       qui replace `id' = 0 if !`touse'
       summ `id', mean
       local capN = r(max)
       qui count if `touse'
       local capT = r(N) / `capN'      // could be non-integer (Average)

	// Back up user's e-class() stuff
	// capture --> _estimates errors out if no e-class() stuff
	// so clear our e-class() junk if nothing to restore
	tempname usrest
	capture _estimates hold `usrest', restore
	if _rc {
		local clreclass "yes"
	}
	
	// test with user's real var, not demeaned one
	capture `testcmd' `varlist' if `id'==1 & `touse', `options'
	if _rc {
		di in smcl as error "performing unit-root test on first " _c
		di in smcl as error "panel using the syntax"
		di in smcl as error "{bf:`testcmd' `varlist', `options'} "
		di in smcl as error "returned error code " _rc
		exit _rc
	}
	else if "`r(p)'" == "" {
		di in smcl as error 				///
			"{bf:`testcmd'} did not return a p-value in r(p)"
		exit 498
	}

	tempvar p lags
	qui gen double `p' = .
	qui gen double `lags' = .	
	forvalues i = 1/`capN' {
		summ `obvar' if `id' == `i' & `touse', mean
		local first = r(min)
		cap `testcmd' `depvar' if `id'==`i' & `touse', `options'
		if !_rc {
			qui replace `p' = r(p) in `first'
			qui replace `lags' = r(lags) in `first'
		}
		else {
			di as error "could not compute test for panel `i'"
		}
	}
	
	qui {
		// -dfuller- and -pperron- can return p == 0, so that
		// ln(p), etc., return missing.  Here we fix that:
		replace `p' = c(epsdouble) if `p' < c(epsdouble)
	
		tempname P Pdf Ppval
		tempvar lnpi
		gen double `lnpi' = ln(`p') 
		summ `lnpi', mean
		sca `P' = -2*r(sum)
		sca `Pdf' = r(N)*2
		sca `Ppval' = chi2tail(`Pdf', `P')
		
		tempname Z Zp
		tempvar inormalp
		gen double `inormalp' = invnormal(`p')
		summ `inormalp', mean
		sca `Z' = r(sum) / sqrt(r(N))
		sca `Zp' = normal(`Z')

		tempname L k Ldf Lp
		tempvar logit
		gen double `logit' = ln(`p'/(1-`p'))
		summ `logit', mean
		sca `k' = (3*(5*r(N)+3)) / (_pi^2*r(N)*(5*r(N)+2))
		sca `L' = sqrt(`k')*r(sum)
		sca `Ldf' = 5*r(N)+4
		sca `Lp' = 1 - ttail(`Ldf', `L')
		
		tempname Pmod Pmodpval
		tempvar pmodsummand
		gen double `pmodsummand' = -2*ln(`p') - 2
		summ `pmodsummand', mean
		sca `Pmod' = r(sum) / (2*sqrt(r(N)))
		sca `Pmodpval' = 1-normal(`Pmod')
		
		if "`generate'" != "" {
			cap drop `generate'
			gen double `generate' = `p'
		}
	}
	
	return scalar P    = `P'
	return scalar p_P  = `Ppval'
	return scalar df_P = `Pdf'

	return scalar Z   = `Z'
	return scalar p_Z = `Zp'
	
	return scalar L    = `L'
	return scalar p_L  = `Lp'
	return scalar df_L = `Ldf'

	return scalar Pm   = `Pmod'
	return scalar p_Pm = `Pmodpval'
	
	return scalar N_g = `capN'
	return scalar N_t = `capT'
	return scalar N = `=round(`capT'*`capN')'
	
	return local test "fisher"
	return local urtest "`testcmd'"
	if "`options'" != "" {
		return local options `:list retok options'
	}
	if "`demean'" != "" {
		return local demean "demean"
	}
	
	local line1 "Fisher-type unit-root test for `varlist'"
	if "`testcmd'" == "dfuller" {
		local line2 "Based on augmented Dickey-Fuller tests"
	}
	else if "`testcmd'" == "pperron" {
		local line2 "Based on Phillips-Perron tests"
	}
	local linelen = max(`:length local line1', `:length local line2')
	di
	di as text "Fisher-type unit-root test for " as res "`varlist'"
	di as text "`line2'"
	di in smcl as text "{hline `linelen'}"

	if "`unbalanced'" != "" {
		local panhead _col(45) /*
*/ "Number of panels" _col(68) "=" _col(69) as res %7.0g `capN'
		local perhead _col(45) /*
*/ "Avg. number of periods" _col(68) "=" _col(69) as res %7.2f `capT'
	}
	else {
		local panhead _col(45) /*
*/ "Number of panels" _col(63) "=" _col(64) as res %7.0g `capN'
		local perhead _col(45) /*
*/ "Number of periods" _col(63) "=" _col(64) as res %7.0g `capT'
	}
	di as text "Ho: All panels contain unit roots"	`panhead'
	di as text "Ha: At least one panel is stationary" `perhead'

	if "`testcmd'" == "dfuller" {
		local col 15
	}
	else if "`testcmd'" == "pperron" {
		local col 18
	}
	else {
		exit 9999		// not reached
	}
	di
	di as text "AR parameter:" as res _col(`col') "Panel-specific" _c
	di as text _col(45) "Asymptotics: " as res "T -> Infinity"
	di as text "Panel means:" as res _col(`col') 			///
		cond("`noconstant'"=="", "Included", "Not included")
	di as text "Time trend:" as res _col(`col')			///
		cond("`trend'"=="", "Not included", "Included") _c
	if "`demean'" != "" {
		di as text _col(45) "Cross-sectional means removed"
	}
	else {
		di
	}

	if "`usrlags'" == "1" {
		local s
	}
	else {
		local s s
	}
	if "`testcmd'" == "dfuller" {
		di as text "Drift term:" as res _col(`col')		///
			cond("`drift'"=="", "Not included", "Included") _c
		di as text _col(45) "ADF regressions: " as res `usrlags' ///
			as text " lag`s'"
	}
	else {
		di as text "Newey-West lags:" as res _col(`col')	///
			`usrlags' as text " lag`s'"
	}
	
	di in smcl as text "{hline 78}"
	di as text _col(35) "Statistic" _col(50) "p-value"
	di in smcl as text "{hline 78}"
	di as text _col(2) "Inverse chi-squared(" as res return(df_P)	///
		as text ")" _col(28) "P" 				///
		as res _col(35) %9.4f return(P)				///
		as res _col(51) %6.4f return(p_P)
	di as text _col(2) "Inverse normal"				///
		as text _col(28) "Z"					///
		as res _col(35) %9.4f return(Z)				///
		as res _col(51) %6.4f return(p_Z)
	di as text _col(2) "Inverse logit t(" as res return(df_L)	///
		as text ")" _col(28) "L*"				///
		as res _col(35) %9.4f return(L)				///
		as res _col(51) %6.4f return(p_L)
	di as text _col(2) "Modified inv. chi-squared"			///
		as text _col(28) "Pm"					///
		as res _col(35) %9.4f return(Pm)			///
		as res _col(51) %6.4f return(p_Pm)
	di in smcl as text "{hline 78}"
	di as text _col(2) ///
		"P statistic requires number of panels to be finite."
	di as text _col(2) ///
"Other statistics are suitable for finite or infinite number of panels."
	di in smcl as text "{hline 78}"
	if "`clreclass'" == "yes" {
		eret clear
	}
end
