*! version 1.1.2  09feb2015
program _xturbreitung, rclass sortpreserve

	version 10
	
	syntax varname(ts) [if] [in],				///
		[ Trend						///
		  NOCONStant					///
		  Lags(integer 0)				///
		  DEMEAN					///
		  Robust					///
		  ALTDIVISOR	/* alternative divisor for
		                   Omega, used in cert scripts
		                */				///   
		]
		
	tsunab usrdepvar : `varlist'
	marksample touse
	
	if "`noconstant'" != "" & "`trend'" != "" {
		di in smcl as err 				///
			"cannot specify both {bf:noconstant} and {bf:trend}"
		exit 198
	}

	if `lags' < 0 {
		di as error "{bf:lags()} must be nonnegative"
		exit 198
	}
	
	_xt, trequired
	// Make back-up of user's xtsettings before re-xtsetting
	capture xtset
	tempname usrdelta
	local panelvar  `r(panelvar)'
	local timevar   `r(timevar)'
	sca `usrdelta' =  `r(tdelta)'
	local usrformat `r(tsmt)'

	// check for strongly balanced sample ...
	qui _xtstrbal `panelvar' `timevar' `touse'
	if r(strbal) == "no" {
		di as error 			///
			"Breitung test requires strongly balanced data"
		exit 498
	}
	// ... without gaps
	cap bys `panelvar' (`timevar'): assert D.`timevar' == `usrdelta' ///
						if `touse' & _n > 1
	if c(rc) {
		di as error			///
			"Breitung test cannot have gaps in data"
		exit 498
	}
	
	// Back up user's e-class() stuff
	// capture --> _estimates errors out if no e-class() stuff
	// so clear our e-class() junk if nothing to restore
	tempname usrest
	capture _estimates hold `usrest', restore
	if _rc {
		local clreclass "yes"
	}

	// remove cross-sectional averages for each time period
	tempvar depvar mean
	if "`demean'" != "" {
		_xturdemean `depvar' : `usrdepvar' `timevar' `touse'
	}
	else {
		qui gen double `depvar' = `usrdepvar'
	}

	// generate a panel var = 1...N so we can loop
	tempvar obvar id pantouse
	gen `c(obs_t)' `obvar' = _n
	qui bys `panelvar' (`timevar'): gen long `pantouse' = sum(`touse')
	qui by `panelvar' (`timevar'): replace `pantouse' = (`pantouse'[_N]>0)
	qui by `panelvar' (`timevar'): gen `c(obs_t)' `id' = 1 if _n==1 & `pantouse'
	qui replace `id' = sum(`id') 
	qui replace `id' = . if !`touse'
	summ `id' if `touse', mean
	local capN = r(max)
	qui count if `touse'
	local capT = r(N) / `capN'

	if "`robust'" != "" {
		if (`capT' - `lags' - 1) < `capN' {
			di as error 				///
"robust test statistic requires more time periods net of lags than panels"
			exit 498
		}
	}

quietly {
	preserve
	drop if `id' == 0 | missing(`id')
	xtset `id' `timevar', delta(`=`usrdelta'')
	tempvar dify lagy sig2
	gen double `lagy' = L.`depvar'
	gen double `dify' = D.`depvar'

	if "`trend'" == "" {
		if "`noconstant'" == "" {
			// the `lags'+1 takes care of the fact that the first 
			// useful obs is greater than _n==1 because of 
			// differencing and lagging of variables
			tempvar junk
			by `id':gen double `junk' = `depvar'[`lags'+1]
			by `id':replace `lagy' = `lagy' - `junk'
		}
	
		if `lags' > 0 {
			local p_d = 0
			local p_l = 0
			tempvar tmpresid
			forvalues i = 1/`capN' {
				reg `dify' L(1/`lags')D.`depvar' ///
					if `id' == `i', noconst
				predict double `tmpresid' 		///
					if `id' == `i', residuals
				replace `dify' = `tmpresid' if `id' == `i'
				cap drop `tmpresid'
				reg `lagy' L(1/`lags')D.`depvar' ///
					if `id' == `i', noconst
				predict double `tmpresid' 		///
					if `id' == `i', residuals
				replace `lagy' = `tmpresid' if `id' == `i'
				cap drop `tmpresid'
			}
		}
		// calc sig2
		gen double `sig2' = `dify'^2
		by `id': replace `sig2' = sum(`sig2')
		by `id': replace `sig2' = `sig2'[_N]/(`capT' - `lags' - 1 - 1)
	}
	else {					// trend
		tempvar u utmp du
		gen double `u' = .
		gen double `utmp' = .
		gen double `du' = .
		local p_avg = 0
		if `lags' > 0 {		// prewhitening step
			tempname beta
			forvalues i = 1/`capN' {
				reg D.`depvar' L(1/`lags')D.`depvar' ///
					if `id' == `i'
				local ltop = `lags'
				mat `beta' = e(b)
				replace `du' = D.`depvar' if `id' == `i'
				replace `utmp' = `depvar' if `id' == `i'
				forvalues j = 1/`ltop' {
					replace `du' = `du' -		///
						`beta'[1,`j']*		///
						    L`j'D.`depvar'	///
						if `id' == `i'
					replace `utmp' = `utmp' -	///
						`beta'[1,`j']*		///
						    L`j'.`depvar'	///
						if `id' == `i'
				}
				replace `u' = L.`utmp' if `id' == `i'
			}
		}
		else {
			replace `du' = `dify'
			replace `u' = `lagy'
		}
		// NB the `lags'+2 obs of `u' corresponds to u1[1] obs
		// in Breitung's code
		tempvar meandu
		by `id': gen double `meandu' = sum(`du')
		by `id': replace `meandu' = `meandu'[_N] / (`capT' - `lags' - 1)
		by `id': gen double `sig2' = sum((`du' - `meandu')*`du')
		by `id': replace `sig2' = `sig2'[_N]/(`capT' - `lags' - 1 - 1)

		// transformation
		by `id': replace `lagy' = `u' - `u'[`lags'+2] -	///
						(_n-`lags'-2)*`meandu'

		tempvar tmp fwdmeandu
		by `id': generate double `tmp' = sum(`du')
		by `id': generate double `fwdmeandu' = 			///
			(`tmp'[_N] - `tmp'[_n]) / (_N-_n)
		by `id': replace `dify' = (`du' - `fwdmeandu')*	///
			sqrt((`capT'-_n) / (`capT'-_n+1))
	}	// end trend

	tempvar s10 s11

	// Helmert transformation defined for t = 1..T-1; see Breitung eq 16
	// so we take the _N-1'st observation, not the _N'th, when we 
	// detrend the data
	if "`trend'" == "" {
		local lastobs _N
	}
	else {
		local lastobs _N - 1
	}
	by `id': gen double `s10' = sum(`lagy'*`dify') / `sig2' if `touse'
	by `id': replace `s10' = . if _n != `lastobs'
	by `id': gen double `s11' = sum(`lagy'*`lagy') / `sig2' if `touse'
	by `id': replace `s11' = . if _n != `lastobs'
	tempname sums10 sums11 lambda p
	su `s10' if `touse', mean
	scalar `sums10' = r(sum)
	su `s11' if `touse', mean
	scalar `sums11' = r(sum)
	scalar `lambda' = `sums10' / sqrt(`sums11')
	scalar `p' = normal(`lambda')
	
	if "`robust'" != "" {
		tempname phi lrobust probust
		tempvar ur
		sca `phi' = `sums10' / `sums11'
		gen double `ur' = `dify' - `phi'*`lagy' if `touse'
		mata:DoRobust("`dify'", "`lagy'", "`ur'", "`touse'", 	///
				"`trend'", `capT', `lags', "`lrobust'",	///
				"`altdivisor'")
		sca `probust' = normal(`lrobust')
	}
} // end quietly block
	
	ret scalar N    = `capN'*`capT'                 // sic
	ret scalar N_g  = `capN'
	ret scalar N_t    = `capT'
	ret scalar lambda = `lambda'
	ret scalar p = `p'
	if "`robust'" != "" {
		ret scalar lrobust = `lrobust'
		ret scalar p_lrobust = `probust'
		ret local  robust    "robust"
	}
	ret scalar lags = `lags'
	if "`trend'`noconstant'" != "" {
		return local deterministics "`trend'`noconstant'"
	}
	else {
		return local deterministics "constant"
	}
	if "`demean'" != "" {
		return local demean "demean"
	}
	
	ret local test "breitung"
	
	// restore user's xtsettings
	restore
	qui xtset `panelvar' `timevar', delta(`=`usrdelta'') format(`usrformat')

	di
	di as text "Breitung unit-root test for " as res "`varlist'"
	local linelen = 30 + length("`varlist'")
	di in smcl as text "{hline `linelen'}"
	di as text "Ho: Panels contain unit roots"			///
		_col(45) "Number of panels" 				///
		_col(63) "=" 						///
		_col(64) as res %7.0g return(N_g)
	di as text "Ha: Panels are stationary"				///
		_col(45) "Number of periods"				///
		_col(63) "="						///
		_col(64) as res %7.0g return(N_t)
	di
	di as text "AR parameter: " as res "Common" _c
	di as text _col(45) "Asymptotics:  " as res "T,N -> Infinity"
	di as text "Panel means:  " _c
	if "`noconstant'" != "" {
		di as res "Not included" _c
	}
	else {
		di as res "Included" _c
	}
	di as res _col(63) "sequentially"
	di as text "Time trend:   " _c
	if "`trend'" != "" {
		di as res "Included" _c
	}
	else {
		di as res "Not included" _c
	}
	di as text _col(45) "Prewhitening: " _c
	if `lags' > 0 {
		if `lags' > 1 {
			local s s
		}
		di as res `lags' as text " lag`s'"
	}
	else {
		di as res "Not performed"
	}
	if "`demean'" != "" {
		di as text _col(45) "Cross-sectional means removed"
	}
	di in smcl as text "{hline 78}"
	di as text _col(21) "Statistic" _col(36) "p-value"
	di in smcl as text "{hline 78}"
	if "`robust'" != "" {
		local star "*"
		di as text _col(2) "lambda`star'"		///
			as res _col(21) %8.4f return(lrobust)	///
			as res _col(37) %6.4f return(p_lrobust)
	}
	else {
		di as text _col(2) "lambda"			///
			as res _col(21) %8.4f return(lambda)	///
			as res _col(37) %6.4f return(p)
	}
	di in smcl as text "{hline 78}"
	if "`robust'" != "" {
		di as text _col(2) 			///
			"* Lambda robust to cross-sectional correlation"
	}

end

mata:

/* Calculates the robust version of the statistic given dv, v1,
   and u = dv - phi*v1; easier to do the matrix calculations here
*/

void DoRobust(	string scalar dvs, string scalar v1s,
		string scalar us,  string scalar tousevar,
		string scalar trend, real scalar capT, 
		real scalar lags, string scalar lambdars,
		string scalar altdivisor)
{

	real matrix dv, v1, u, ui, uj, om, dvi, v1i
	real scalar a, b, i, j, capN, i1, i2, j1, j2

	st_view(dv=., ., tokens(dvs), tousevar)
	st_view(v1=., ., tokens(v1s), tousevar)
	st_view(u=.,  ., tokens(us),  tousevar)

	capN = rows(dv) / capT
	om = J(capN, capN, 0)
	i1 = 1
	for(i=1; i<=capN; ++i) {
		i2 = i1 + capT - 1
		j1 = 1
		for(j=1; j<=capN; ++j) {
			j2 = j1 + capT - 1
			ui = u[i1..i2]
			uj = u[j1..j2]
			om[i,j] = editmissing(ui,0)'*
				  editmissing(uj,0)
			j1 = j2 + 1
		}
		i1 = i2 + 1
	}
	if (altdivisor == "") {
		        /*    T - p - 2   */
		om = om / (capT - lags - 2)
	}
	else {
			/*    T0 - p - 1 in Breitung's code */
		om = om / (capT - 2*lags - 2)
	}
	a = b = 0
	for(i=1; i<= (capT-lags-1); ++i) {
		ui = J(1,0,0)
		for(j=1; j<=capN; ++j) {
			ui = ui, ((j-1)*capT + i + lags + (trend==""))
		}
		dvi = editmissing(dv[ui], 0)
		v1i = editmissing(v1[ui], 0)
		a = a + v1i'dvi
		b = b + v1i'*om*v1i
	}

	st_numscalar(lambdars, a/sqrt(b))
	
}

end

