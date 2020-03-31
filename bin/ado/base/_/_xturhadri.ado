*! version 1.0.5  09feb2015
program _xturhadri, rclass sortpreserve

	version 10
	
	syntax varname(ts) [if] [in],				///
		[ Trend						///
		  DEMEAN					///
		  Robust					///
		  KERnel(string)				///
		  NODFKADJUST		/* undocumented */	///
		]
		
	tsunab usrdepvar : `varlist'
	marksample touse
	
	_xt, trequired
	capture xtset
	tempname usrdelta
	local panelvar  `r(panelvar)'
	local timevar   `r(timevar)'
	sca `usrdelta' =  `r(tdelta)'

	// check for strongly balanced sample ...
	qui _xtstrbal `panelvar' `timevar' `touse'
	if r(strbal) == "no" {
		di as error 			///
			"Hadri LM test requires strongly balanced data"
		exit 498
	}
	// ... without gaps
	cap bys `panelvar' (`timevar'): assert D.`timevar' == `usrdelta' ///
					if `touse' & _n > 1
	if c(rc) {
		di as error			///
			"Hadri LM test cannot have gaps in data"
		exit 498
	}
		
	if "`kernel'" != "" {
		_xtur_parse_kernel `"`kernel'"'
		local hac_kernel `s(hac_kernel)'
		local hac_lags = `s(hac_lags)'
		if "`s(hac_bsel)'" != "" {
			di in smcl as error "{bf:kernel()} lag length invalid"
			exit 198
		}
		if "`robust'" != "" {
			di as error 			///
"cannot specify both {bf:kernel()} and {bf:robust}"
			exit 198
		}
	}
	
	// Back up user's e-class() stuff
	// capture --> _estimates errors out if no e-class() stuff
	// so clear our e-class() junk if nothing to restore 
	tempname usrest
	capture _estimates hold `usrest', restore
	if _rc {
		local clreclass "yes"
	}

	// create trend variable if requested
	if "`trend'" != "" {
		tempvar ttrend
		qui bys `panelvar' (`timevar'): gen double `ttrend' = 1
		qui by `panelvar': replace `ttrend' =			///
			(`timevar'-`timevar'[_n-1])/			///
			`: char _dta[_TSdelta]' if _n > 1
		qui by `panelvar': replace `ttrend' = sum(`ttrend')
	}
	
	// remove cross-sectional averages for each time period
	tempvar depvar
	if "`demean'" != "" {
		_xturdemean `depvar' : `usrdepvar' `timevar' `touse'
	}
	else {
		qui gen double `depvar' = `usrdepvar'
	}
	
	tempvar obvar
	gen `c(obs_t)' `obvar' = _n
	
	// generate a panel var = 1..N so we can loop
	tempvar id pantouse
	qui bys `panelvar': gen long `pantouse' = sum(`touse')
	qui by `panelvar': replace `pantouse' = (`pantouse'[_N]>0)
	qui by `panelvar': gen `c(obs_t)' `id' = 1 if _n==1 & `pantouse'
	qui replace `id' = sum(`id')
	qui replace `id' = 0 if !`touse'
	summ `id', mean
	local capN = r(max)
	qui count if `touse'
	local capT = r(N) / `capN'		// balanced panels
	
	tempvar eit resid
	qui gen double `eit' = .
	forvalues i = 1/`capN' {
		summ `obvar' if `id' == `i', mean
		local first = r(min)
		local last  = r(max)
			// ttrend empty if no trend
		qui reg `depvar' `ttrend' in `first'/`last'
		cap drop `resid'
		qui predict double `resid' in `first'/`last', residual
		qui replace `eit' = `resid' in `first'/`last'
	}
	
	tempvar runsum runsumsq
	qui bys `id' (`timevar'): gen double `runsum' = sum(`eit')
	qui gen double `runsumsq' = `runsum'^2 
	qui by `id': replace `runsumsq' = sum(`runsumsq')
	qui by `id': replace `runsumsq' = . if _n < _N

	tempname sigmaesq LM mu var Z Zp
	tempvar esq
	qui gen double `esq' = `eit'^2
	if "`robust'`hac_kernel'" == "" {
		su `esq', mean
		local divisor = `capT' - 1 - ("`trend'" != "")
		if "`nodfkadjust'" != "" {
			local divisor = `capT'	
		}
		sca `sigmaesq' = r(sum) / 			///
			(`capN'*`divisor')
		summ `runsumsq', mean
		sca `LM' = r(sum) / (`capN'*`capT'^2) / `sigmaesq'
	}
	else if "`robust'" != "" & "`hac_kernel'" == "" {
		qui by `id': replace `esq' = sum(`esq')
		local divisor = `capT' - 1 - ("`trend'" != "")
		if "`nodfkadjust'" != "" {
			local divisor = `capT'	
		}
		qui by `id': replace `esq' = `esq'[_N] / `divisor'
		qui by `id': replace `runsumsq' = `runsumsq' / `esq'[_N]
		summ `runsumsq', mean
		sca `LM' = r(sum) / (`capN'*`capT'^2)
	}
	else if "`hac_kernel'" != "" {
		tempvar lrvar lagjvar lag0var lagsum
		qui by `id': gen double `lag0var' = sum(`esq')
		qui by `id': replace `lag0var' = cond(_n==_N, 		  ///	
			`lag0var'[_N] / `capT', .)
		qui by `id': gen double `lrvar' = cond(_n==_N, `lag0var', .)
		tempname z kw theta
		if `hac_lags' == . {
			local hac_lags = 1
		}
		local top = `hac_lags'
		if "`hac_kernel'" == "quadraticspectral" {
			local top = `capT'
		}
		forvalues l = 1/`hac_lags' {
			sca `z' = `l' / (`hac_lags'+1)
			if "`hac_kernel'" == "bartlett" {
				scalar `kw' = 1 - `z'
			}
			else if "`hac_kernel'" == "parzen" {
				if `z' <= 0.5 {
					scalar `kw' = 1 - 6*`z'^2 + 6*`z'^3
				}
				else {
					scalar `kw' = 2*(1 - `z')^3
				}
			}
			else {
				scalar `theta' = 6*_pi*`z' / 5
				if `z' == 1 {
					scalar `kw' = 1
				}
				else {
					scalar `kw' = 3*( 		///
						sin(`theta')/`theta' -  ///
						cos(`theta')) / `theta'^2
				}
			}
			cap drop `lagsum'
			qui by `id': gen double `lagsum' = 	///
				`eit'*`eit'[_n-`l']
			qui by `id': replace `lagsum' = sum(`lagsum')
			qui by `id': replace `lrvar' = `lrvar' + 	///
						2*`kw'*`lagsum'[_N]/`capT'
		}
		summ `lrvar', mean
		qui by `id': replace `runsumsq' = `runsumsq' / r(mean)
		summ `runsumsq', mean
		sca `LM' = r(sum) / (`capN'*`capT'^2)
	}
	else {
		// not reached
		exit 9999
	}
	if "`trend'" != "" {
		sca `mu' = 1/15
		sca `var' = 11/6300
	}
	else {
		sca `mu' = 1/6
		sca `var' = 1/45
	}
	sca `Z' = sqrt(`capN')*(`LM' - `mu') / sqrt(`var')
	sca `Zp' = normal(-1*`Z')

	ret clear

	ret scalar N	= `capN'*`capT'			// sic
	ret scalar N_g	= `capN'
	ret scalar N_t	= `capT'
	ret scalar z	= `Z'
	ret scalar p	= `Zp'
	ret scalar mu	= `mu'
	ret scalar var	= `var'
	if "`trend'" != "" {
		ret local deterministics "trend"
	}
	else {
		ret local deterministics "constant"
	}
	ret local robust   `robust'
	if "`hac_kernel'" != "" {
		ret local kernel     `hac_kernel'
		ret scalar lags = `hac_lags'
	}

	if "`clreclass'" == "yes" {
		ereturn clear		// get rid of our crumbs
	}
	if "`demean'" != "" {
		ret local demean "demean"
	}
	return local test "hadri"
	
	di
	di as text "Hadri LM test for " as res "`varlist'"
	local linelen = 20 + length("`varlist'")
	di in smcl as text "{hline `linelen'}"
	di as text "Ho: All panels are stationary"			///
		_col(45) "Number of panels" 				///
		_col(63) "=" 						///
		_col(64) as res %7.0g return(N_g)
	di as text "Ha: Some panels contain unit roots"			///
		_col(45) "Number of periods"				///
		_col(63) "="						///
		_col(64) as res %7.0g return(N_t)
	di
	di as text "Time trend:         " _c
	if "`ttrend'" != "" {
		di as res "Included" _c
	}
	else {
		di as res "Not included" _c
	}
	di as text _col(45) "Asymptotics: " as res "T, N -> Infinity"
	di as text "Heteroskedasticity: " _c
	if "`robust'" != "" | "`hac_kernel'" != "" {
		di as res "Robust" _c
	}
	else {
		di as res "Not robust" _c
	}
	di as res _col(63) "sequentially"

	if "`hac_kernel'" != "" {
		if "`hac_kernel'" == "quadraticspectral" {
			local hackern "Quad. Spectral"
			local fmt %4.2f
		}
		else {
			local hackern `=proper("`hac_kernel'")'
			local fmt
		}
		if `hac_lags' != 1 {
			local s s
		}
		di as text "LR variance:        "			///
			as res "`hackern'" as text " kernel, " _c
		if "`hac_kernel'" == "quadraticspectral" | `hac_lags' > 9 {
			if "`demean'" != "" {
				di as text _col(45) 			///
					"Cross-sectional means removed"
			}
			else {
				di
			}	
			di _col(21) as res `fmt' `hac_lags' as text " lag`s'"
		}
		else {
			di as res `fmt' `hac_lags' as text " lag`s'" _c
			if "`demean'" != "" {
				di as text _col(45) 			///
					"Cross-sectional means removed"
			}
			else {
				di
			}
		}
	}
	else {
		di as text "LR variance:        " as res "(not used)" _c
		if "`demean'" != "" {
			di as text _col(45) "Cross-sectional means removed"
		}
		else {
			di
		}
	}
	di in smcl as text "{hline 78}"
	di as text _col(21) "Statistic" _col(36) "p-value"
	di in smcl as text "{hline 78}"
	di as text _col(2) "z"					///
		as res _col(21) %8.4f return(z)			///
		as res _col(37) %6.4f return(p)
	di in smcl as text "{hline 78}

end

