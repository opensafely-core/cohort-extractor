*! version 1.0.5  09feb2015
program _xturht, rclass sortpreserve

	version 10
	
	syntax varname(ts) [if] [in],				///
		[ Trend						///
		  NOCONStant					///
		  DEMEAN					///
		  ALTT						///
		]
		
	tsunab usrdepvar : `varlist'
	marksample touse
	
	if "`noconstant'" != "" & "`trend'" != "" {
		di in smcl as err 				///
			"cannot specify both {bf:noconstant} and {bf:trend}"
		exit 198
	}

	if "`trend'" != "" {
		local model 3			// LLC's model #'s
	}
	else if "`noconstant'" == "" {
		local model 2
	}
	else {
		local model 1
	}
	
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
			"Harris-Tzavalis test requires strongly balanced data"
		exit 498
	}
	// ... without gaps
	cap bys `panelvar' (`timevar'): assert D.`timevar' == `usrdelta' ///
			if `touse' & _n > 1
	if c(rc) {
		di as error			///
			"Harris-Tzavalis test cannot have gaps in data"
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

	// get capN and capT
	tempvar countme
	qui by `panelvar': generate `countme' = `touse'
	qui by `panelvar': replace `countme' = sum(`countme')
	qui by `panelvar': replace `countme' = `countme'[_N]
	summ `countme' if `touse', mean
	local capT = r(min)		// already checked for bal. panels
	qui count if `touse'
	local capN = r(N)/`capT'

	// remove cross-sectional averages for each time period
	tempvar depvar
	if "`demean'" != "" {
		_xturdemean `depvar' : `usrdepvar' `timevar' `touse'
	}
	else {
		qui gen double `depvar' = `usrdepvar'
	}

	tempname rho
	if `model' == 1 {
		qui reg `depvar' L.`depvar' if `touse', noconst
		sca `rho' = _b[L.`depvar']
	}
	else if `model' == 2 {
		qui xtreg `depvar' L.`depvar' if `touse', fe
		sca `rho' = _b[L.`depvar']
	}
	else {
		qui {
			// All of this code is a more efficient way of
			// doing fixed-effects regression of y on L.y
			// with panel-specific time trends
			tempvar ttrend
			qui by `panelvar': gen `c(obs_t)' `ttrend' = _n

			tempvar dv lagdv
			gen double `dv' = `depvar'
			gen double `lagdv' = L.`depvar'
				
			tempvar id
			by `panelvar': gen `c(obs_t)' `id' = 1 if _n==1 & `touse'
			replace `id' = sum(`id')
			replace `id' = . if !`touse'
			summ `id' if `touse', mean
			local nid = r(max)

			replace `touse' = 0 if missing(`lagdv')
			// remove fixed effects
			tempvar mean nobs
			foreach var of varlist `dv' `lagdv' {
				bys `id' `touse': gen double `mean' = 	///
							sum(`var') if `touse'
				by `id': gen long `nobs' = sum(`touse')
				replace `mean' = `mean' / `nobs'
				by `id': replace `var' = `var' - `mean'[_N]
				drop `mean' `nobs'
			}
			// now partial out time trend	
			forvalues i = 1/`nid' {
				reg `dv' `ttrend' if `id' == `i' & `touse'
				replace `dv' = `dv' - _b[`ttrend']*`ttrend'  ///
						    - _b[_cons] if `id'==`i' ///
						    & `touse'
				reg `lagdv' `ttrend' if `id' == `i' & `touse'
				replace `lagdv' = `lagdv'  		    ///
						  - _b[`ttrend']*`ttrend'   ///
						  - _b[_cons] if `id'==`i'  ///
						  & `touse'
			}
			reg `dv' `lagdv' if `touse', nocons
			sca `rho' = _b[`lagdv']
		}
		
	}
	tempname rhomean rhovar z p
	if "`altt'" == "" {
		local useT = `capT'
	}
	else {
		local useT = `capT' - 1	// Lose one obs due to lag
	}

	if `model' == 1 {
		sca `rhomean' = 1
		sca `rhovar' = (1/`capN')*(2 / (`useT'*(`useT'-1)))
	}
	else if `model' == 2 {
		sca `rhomean' = 1 - 3/(`useT'+1)
		sca `rhovar' = (1/`capN')*			///
			(3*(17*`useT'^2 - 20*`useT' + 17)) /	///
			(5*(`useT'-1)*(`useT'+1)^3)
	}
	else {
		sca `rhomean' = 1 - 15/(2*(`useT'+2))
		sca `rhovar' = (1/`capN')*			///
		   (15*(193*`useT'^2 - 728*`useT' + 1147)) / 	///
		   (112*(`useT'+2)^3*(`useT'-2))
	}
	sca `z' = (`rho' - `rhomean')/sqrt(`rhovar')
	sca `p' = normal(`z')

	if "`clreclass'" == "yes" {
		eret clear
	}

	ret clear

	ret scalar N        = `capN'*`capT'			// sic
	ret scalar N_g      = `capN'
	ret scalar N_t	    = `capT'
	ret scalar rho      = `rho'
	ret scalar mean_rho = `rhomean'
	ret scalar Var_rho  = `rhovar'
	ret scalar z        = `z'
	ret scalar p        = `p'
	
	return local altt "`altt'"
	if "`trend'`noconstant'" != "" {
		ret local deterministics "`trend'`noconstant'"
	}
	else {
		ret local deterministics "constant"
	}
	if "`demean'" != "" {
		return local demean "demean"
	}
	ret local test "ht"
	
	di
	di as text "Harris-Tzavalis unit-root test for " as res "`varlist'"
	local linelen = 35 + length("`varlist'")
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
	di as text _col(45) "Asymptotics: " as res "N -> Infinity"
	di as text "Panel means:  " _c
	if `model' == 1 {
		di as res "Not included" _c
	}
	else {
		di as res "Included" _c
	}
	di as res _col(58) "T Fixed"
	di as text "Time trend:   " _c
	if `model' == 1 | `model' == 2 {
		di as res "Not included" _c
	}
	else {
		di as res "Included" _c
	}
	if "`return(demean)'" == "demean" {
		di as text _col(45) "Cross-sectional means removed"
	}
	else {
		di
	}
	if "`altt'" != "" {
		di as text "Small-sample adjustment to T applied"
	}
	di in smcl as text "{hline 78}"
	di as text _col(21) "Statistic" _col(39) "z" _col(49) "p-value"
	di in smcl as text "{hline 78}"
	di as text _col(2) "rho"			///
		as res _col(21) %8.4f return(rho)	///
		as res _col(35) %8.4f return(z)		///
		as res _col(50) %6.4f return(p)
	di in smcl as text "{hline 78}"

end
