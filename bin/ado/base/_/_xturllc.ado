*! version 1.0.3  16apr2013

program _xturllc, rclass sortpreserve

	version 10
	
	syntax varname(ts) [if] [in],				///
		[ Trend						///
		  NOCONStant					///
		  Lags(string)					///
		  KERnel(string)				///
		  DEMEAN					///
		  NOINTERpolate					///
		]
		
	tsunab usrdepvar : `varlist'
	marksample touse
	
	if "`noconstant'" != "" & "`trend'" != "" {
		di in smcl as err 				///
			"cannot specify both {bf:noconstant} and {bf:trend}"
		exit 198
	}

	if `"`lags'"' != "" {
		_xtur_parse_lags `"`lags'"'
		local adf_lags = `s(lags)'
		local adf_lagsel `s(lagsel)'	// aic, bic, or hqic, 
						// if specified
	}
	else {
		local adf_lags = 1
	}
	
	if `"`kernel'"' != "" {
		_xtur_parse_kernel `"`kernel'"'
		local hac_kernel `s(hac_kernel)'
		local hac_lags = `s(hac_lags)'	// # if specified, else .
		local hac_bsel   `s(hac_bsel)'	// nwest or llc, if specified
		if 	"`hac_bsel'" != "" & 		///
			"`hac_bsel'" != "nwest" &	///
			"`hac_bsel'" != "llc" {
				di in smcl as error 	///
					"{bf:kernel()} lag length invalid"
				exit 198
		}
	}
	else {
		local hac_kernel bartlett
		local hac_lags = .
		local hac_bsel llc
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
	// Make back-up of user's xtsettings before re-xtsetting
	capture xtset
	tempname usrdelta
	local panelvar  `r(panelvar)'
	local timevar   `r(timevar)'
	sca `usrdelta' =  `r(tdelta)'
	local usrformat `r(tsmt)'

	// check for strongly balanced sample ...
	_xtstrbal `panelvar' `timevar' `touse'
	if r(strbal) == "no" {
		di as error 			///
			"Levin-Lin-Chiu test requires strongly balanced data"
		exit 498
	}
	// ... without gaps
	cap bys `panelvar' (`timevar'): assert D.`timevar' == `usrdelta' ///
						if `touse' & _n > 1
	if c(rc) {
		di as error			///
			"Levin-Lin-Chiu test cannot have gaps in data"
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

	// create trend variable if requested
	if "`trend'" != "" {
		tempvar ttrend
		qui by `panelvar': gen double `ttrend' = 1
		qui by `panelvar': replace `ttrend' =			///
			(`timevar'-`timevar'[_n-1])/			///
			`: char _dta[_TSdelta]' if _n > 1
		qui by `panelvar': replace `ttrend' = sum(`ttrend')
	}
	
	// remove cross-sectional averages for each time period
	tempvar depvar mean
	if "`demean'" != "" {
		_xturdemean `depvar' : `usrdepvar' `timevar' `touse'
	}
	else {
		qui gen double `depvar' = `usrdepvar'
	}

	tempvar evar nuvar sivar obvar diffvar lagvar tivar 
	tempvar adf_lagused hac_lagused

	qui gen double `evar'  = .		// LLC eq(3)
	qui gen double `nuvar' = .		// LLC eq(3)
	qui gen double `sivar' = .		// LLC eq(6)
	qui gen double `obvar' = _n
	qui gen double `tivar'  = .		// used to record T for each i
	qui gen double `adf_lagused' = .
	qui gen double `hac_lagused' = .
	
	qui gen double `diffvar' = D.`depvar' if `touse'
	qui gen double `lagvar'  = L.`depvar' if `touse'

	by `panelvar': _pregress `diffvar' `lagvar' if `touse' , 	///
		evar(`evar') nuvar(`nuvar') sivar(`sivar') 		///
		obvar(`obvar') tivar(`tivar') model(`model')		///
		ttrend(`ttrend') `noconstant' 				///
		adf_lags(`adf_lags') adf_lagsel("`adf_lagsel'")		///
		adf_lagused(`adf_lagused')				///
		hac_kernel("`hac_kernel'") hac_lags(`hac_lags')		///
		hac_bsel("`hac_bsel'") hac_lagsused(`hac_lagused')
	// _pregress took care of lagging `nuvar', so no lag here
	// which fits LLC eq(7).
	qui regress `evar' `nuvar', noconst
	tempname td nu_hat nu_se p_td

	scalar `nu_hat' = _b[`nuvar']
	scalar `nu_se' = _se[`nuvar']
	scalar `nu_se' = (`nu_se')*sqrt((e(N)-1)/e(N))	
	scalar `td' = `nu_hat'/`nu_se'
	if `model' == 1 {	// no constant, so t ~ N
		scalar `p_td' = normal(`td')
	}
	
	qui sum `tivar'
	local tbar = r(mean)
	local n_g  = r(N)
	local nt   = r(sum)
	qui count if `touse'
	local capT = r(N) / `n_g'		// since balanced panels
	
	tempname sig_e2 muadj sadj tds p_tds sbar
	qui sum `sivar'
	scalar `sbar' = r(mean)
	scalar `sig_e2' = e(rss)/(e(N))
	_get_adj , t(`tbar') model(`model') `nointerpolate'
	scalar `muadj' = r(muadj)
	scalar `sadj'  = r(sadj)

	scalar `tds' = (`td' - `nt'*`sbar'/`sig_e2'*`nu_se'*`muadj') / 	///
				`sadj'
	scalar `p_tds'   = normal(`tds')

	if "`clreclass'" == "yes" {
		eret clear
	}

	ret clear

	qui summ `adf_lagused'
	if "`adf_lagsel'" == "" {
		return scalar adf_lags = r(mean)
	}
	else {
		return scalar adf_lagm = r(mean)
		return local adf_method "`adf_lagsel'"
	}
	
	qui summ `hac_lagused'
	if "`hac_bsel'" == "" {
		return scalar hac_lags = r(mean)
	}
	else {
		return scalar hac_lagm = r(mean)
		ret local hac_method   "`hac_bsel'"
	}
	ret local hac_kernel   "`hac_kernel'"
	if "`noconstant'`trend'" != "" {
		ret local deterministics "`noconstant'`trend'"
	}
	else {
		ret local deterministics "constant"
	}
	ret local demean "`demean'"
	ret scalar N      = `nt'
	ret scalar N_t	  = `capT'
	ret scalar N_g    = `n_g'

	ret scalar tds    = `tds'
	ret scalar td     = `td'
	ret scalar ttilde = `tbar'
	ret scalar sbar   = `sbar'
	ret scalar Var_ep = `sig_e2'	// s_{\tilde{\epsilon}^2 
	ret scalar se_delta  = `nu_se' 	// sic, note name change
	ret scalar delta = `nu_hat' 	// to match notation
	ret scalar mu_adj  = `muadj'
	ret scalar sig_adj = `sadj'
	ret scalar p_tds   = `p_tds'
	if `model' == 1 {
		ret scalar p_td = `p_td'
	}
	ret local test "llc"
	
	di
	di as text "Levin-Lin-Chu unit-root test for " as res "`varlist'"
	local linelen = 33 + length("`varlist'")
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
	di as text _col(45) "Asymptotics: " _c
	if "`noconstant'" != "" {
		di as res "root(N)/T -> 0"
	}
	else {
		di as res "N/T -> 0"
	}
	di as text "Panel means:  " _c
	if `model' == 2 | `model' == 3 {
		di as res "Included"
	}
	else {
		di as res "Not included"
	}
	di as text "Time trend:   " _c
	if `model' == 3 {
		di as res "Included" _c
	}
	else {
		di as res "Not included" _c
	}
	if "`return(demean)'" == "demean" {
		di as text _col(45) "Cross-sectional means removed"
	}
	else {
		di
	}
	di
	if "`return(adf_method)'" == "" {
		if return(adf_lags) != 1 {
			local s s
		}
		di as text "ADF regressions: "	 			///
			as res return(adf_lags) 			///
			as text " lag`s'"
	}
	else {
		di as text "ADF regressions: "				///
			as res %4.2f return(adf_lagm)			///
			as text " lags average (chosen by "		///
			as res "`=upper("`return(adf_method)'")'"	///
			as text ")"
	}

	if "`return(hac_kernel)'" == "quadraticspectral" {
		local hackern "Quad. Spectral"
		local fmt %4.2f
	}
	else {
		local hackern `=proper("`return(hac_kernel)'")'
		local fmt 
	}
	if "`return(hac_method)'" == "" {
		local s
		if `return(hac_lags)' != 1 { 
			local s "s" 
		}
		di as text "LR variance:     "				///
			as res "`hackern'" as text " kernel, "		///
			as res `fmt' return(hac_lags)			///
			as text " lag`s'"
	}
	else {
		local s
		if `return(hac_lagm)' != 1 {
			local s "s"
		}
		if "`return(hac_method)'" == "nwest" {
			local method Newey-West
		}
		else {
			local method LLC
		}
		di as text "LR variance:     "				///
			as res "`hackern'" as text " kernel, " 		///
			as res %4.2f return(hac_lagm)			///
			as text " lags average "	_c
		if "`method'" == "LLC" {
			di as text "(chosen by " as res "LLC" as text ")"
		}
		else {
			di _n as text _col(18) "(chosen by "		///
				as res "`method'" as text ")"
		}
	}
	
	di in smcl as text "{hline 78}"
	di as text _col(21) "Statistic" _col(36) "p-value"
	di in smcl as text "{hline 78}"
	di as text _col(2) "Unadjusted t"				///
		as res _col(21) %8.4f return(td) _c
	if `model' == 1 {
		di as res _col(37) %6.4f return(p_td)
	}
	else {
		di
	}
	di as text _col(2) "Adjusted t*"				///
		as res _col(21) %8.4f return(tds)			///
		as res _col(37) %6.4f return(p_tds)
	di in smcl as text "{hline 78}"

end


program define _gethacvar, rclass

	syntax varlist(max=1 ts) in, lags(real) kernel(string)

	tempvar tvar wvar
	tempname varhac kw x1 x2 s0

	scalar `varhac' = 0

	qui gen double `tvar' = `varlist'^2 `in'
	qui sum `tvar' `in'
	local n = r(N)
	scalar `s0' = r(sum)
	if "`kernel'" == "bartlett" {
		local lags = int(`lags')
		forvalues i=1/`lags' {
			qui replace `tvar' = (l`i'.`varlist')*`varlist' `in'
			qui sum `tvar' `in'
			scalar `varhac' = `varhac' + 			///
				2*(1-`i'/(`lags'+1))*r(sum)
		}
	}
	else if "`kernel'" == "quadraticspectral" {
		qui count if `varlist' < . `in'
		local nobs2 = r(N) 
		forvalues i=1/`nobs2' {
			qui replace `tvar' = (l`i'.`varlist')*`varlist' `in'
			qui sum `tvar' `in'
			scalar `x1' = `i'/(`lags'+1)
			scalar `x2' = 6*_pi*`x1'/5
			scalar `kw' = (25/(12*(_pi*`x1')^2)) * 	///
				(sin(`x2')/`x2' - cos(`x2') )
			scalar `varhac' = `varhac' + 2*`kw'*r(sum)
		}
	}
	else if "`kernel'" == "parzen" {
		local lags = int(`lags')
		forvalues i=1/`lags' {
			qui replace `tvar' = (l`i'.`varlist')*`varlist' `in'
			qui sum `tvar' `in'
			scalar `x1' = `i'/(`lags'+1)
			scalar `kw' = cond(`x1'<=.5, 			///
					   1-6*(`x1'^2)+6*abs(`x1'^3), 	///
					   2*((1-abs(`x1'))^3) )
			scalar `varhac' = `varhac' + 2*`kw'*r(sum)
		}
	}
	else {
		di in smcl as err "{bf:`kernel'} is not a recognized kernel"
		exit 498
	}

	scalar `varhac' = 1/`n'*(`s0' + `varhac')
	return scalar varhac = `varhac'

end


program define _get_adj, rclass

	syntax , t(real) model(integer) [ NOINTERpolate ]

	tempname dmat
	
	if `model' == 1 {
		mat `dmat' = (	25,  .004, 1.049 \ 	///
				30,  .003, 1.035 \	///
				35,  .002, 1.027 \	///
				40,  .002, 1.021 \	///
				45,  .001, 1.017 \	///
				50,  .001, 1.014 \	///
				60,  .001, 1.011 \	///
				70,  .000, 1.008 \	///
				80,  .000, 1.007 \	///
				90,  .000, 1.006 \	///
				100, .000, 1.005 \	///
				250, .000, 1.001 \	///
				.,   .000, 1.000)
	}
	else if `model' == 2 {
		mat `dmat' = (  25,  -.554, .919 \	///
				30,  -.546, .889 \	///
				35,  -.541, .867 \	///
				40,  -.537, .850 \	///
				45,  -.533, .837 \	///
				50,  -.531, .826 \	///
				60,  -.527, .810 \	///
				70,  -.524, .798 \	///
				80,  -.521, .789 \	///
				90,  -.520, .782 \	///
				100, -.518, .776 \	///
				250, -.509, .742 \	///
				.,   -.500, .707)
	}
	else if `model' == 3 {
		mat `dmat' = (	25,  -.703, 1.003 \	///
				30,  -.674,  .949 \	///
				35,  -.653,  .906 \	///
				40,  -.637,  .971 \	///
				45,  -.624,  .842 \	///
				50,  -.614,  .818 \	///
				60,  -.598,  .780 \	///
				70,  -.587,  .751 \	///
				80,  -.578,  .728 \	///
				90,  -.571,  .710 \	///
				100, -.566,  .695 \	///
				250, -.533,  .603 \	///
				.,   -.500,  .500)

	}
	else {
		di as err "error computing finite sample adjustments"
		exit 498

	}

	if `t' <= 25 {
		local row = 1
	}
	else if `t' <=30 {
		local row = 2
	}
	else if `t' <=35 {
		local row = 3
	}
	else if `t' <=40 {
		local row = 4
	}
	else if `t' <=45 {
		local row = 5
	}
	else if `t' <=50 {
		local row = 6
	}
	else if `t' <=60 {
		local row = 7
	}
	else if `t' <=70 {
		local row = 8
	}
	else if `t' <=80 {
		local row = 9
	}
	else if `t' <=90 {
		local row = 10
	}
	else if `t' <=100 {
		local row = 11
	}
	else if `t' <=250 {
		local row = 12
	}
	else {
		local row = 13
	}

	if `row' == 1 | `row' == 13 | "`nointerpolate'" != "" {
		return scalar muadj = `dmat'[`row',2]
		return scalar sadj  = `dmat'[`row',3]
	}
	else {
		local wc = (`t'-`dmat'[`row'-1,1]) /	///
			(`dmat'[`row',1]-`dmat'[`row'-1,1])
		local wp = 1-`wc'	
		return scalar muadj =`wp'*`dmat'[`row'-1,2] +	///
			`wc'*`dmat'[`row',2]
		return scalar sadj  = `wp'*`dmat'[`row'-1,3] +	///
			`wc'*`dmat'[`row',3]
	}

end


program define _pregress, byable(recall, noheader)
	
	syntax varlist(max=2 min=2) [if] [in] ,			///
		evar(varlist max=1)				///
		nuvar(varlist max=1)				///
		sivar(varlist max=1)				///
		obvar(varlist max=1)				///
		tivar(varlist max=1)				///
		[						///
		model(integer 1)				///
		adf_lags(numlist integer max=1 missingokay)	///
		adf_lagsel(string)				///
		adf_lagused(string)				///
		Ttrend(varlist max=1)				///
		NOCONStant					///
		hac_kernel(string)				///
		hac_lags(numlist max=1 missingokay)		///
		hac_bsel(string)				///
		hac_lagsused(string)				///
		]

// model=1 implies no constant or time trend
// model=2 implies constant but no time trend
// model=3 implies constant and time trend

	marksample touse	

	qui count if `touse' 
	if r(N) == 0 {
		exit
	}
	local capT = r(N) + 1	// one obs lost to differencing dep var

	gettoken diffvar lagvar:varlist

	qui sum `obvar' if _byindex()==`_byindex', meanonly
	local first = r(min)
	local last  = r(max)
	
	// mrssdf is sigma_{ei}^2 in LLC 
	tempname mrssdf bhat j sigyi delta
	local minic = .
	scalar `delta' = .
	local firstb = `first'
	local lastb  = `last'
	if "`adf_lagsel'" != "" {
		_xturadfreg `diffvar' `lagvar' "`ttrend'" "`nconstant'"	///
			`adf_lags' `obvar' `first' `last' 		///
			`adf_lagsel' `touse' p_i
	}
	else {
		if `adf_lags' > 0 {
			qui regress `diffvar' `lagvar' 			///
				L(1/`adf_lags').(`diffvar') 		///
				`ttrend' in `first'/`last' if `touse',	///
				`noconstant'
		}
		else {
			qui regress `diffvar' `lagvar' 			///
				`ttrend' in `first'/`last' if `touse',	///
				`noconstant'
		}	
		local p_i = `adf_lags'
	}

	mat `bhat' = e(b)

	qui replace `adf_lagused' = `p_i' in `first'
	local nobs = e(N)

	tempvar obvar3
	qui gen `obvar3' = cond(e(sample), `obvar', .) 		///
		in `first'/`last'
	qui sum `obvar3' in `first'/`last'
	local firstb = r(min)
	local lastb  = r(max)

	scalar `delta' = `bhat'[1,1]

	qui replace `tivar' = `nobs' in `first'
		
	if `p_i' > 0 {
		qui regress `diffvar'  L(1/`p_i').(`diffvar') 		///
			`ttrend' in `first'/`last', `noconstant'
	}
	else {
		qui regress `diffvar' `ttrend' in `first'/`last', `noconstant'
	}
	
	tempvar res
	qui _predict double `res' in `first'/`last', residuals
	qui replace `res' = cond(e(sample), `res', .) in `first'/`last'
	qui replace `evar' = `res' in `first'/`last'
	
	if `p_i' > 0 {
		qui regress `lagvar'  L(1/`p_i').(`diffvar') 		///
			`ttrend' if `touse', `noconstant'
	}
	else {
		qui regress `lagvar'  `ttrend' if `touse', `noconstant'
	}

	cap drop `res'
	qui _predict double `res' in `first'/`last', residuals
	qui replace `res' = cond(e(sample), `res', .) in `first'/`last'
	qui replace `nuvar' = `res' in `first'/`last'
	
	qui reg `evar' `nuvar' in `first'/`last', noconst
	scalar `mrssdf' = e(rss) / (`capT' - `p_i' - 1)
	
	qui replace `evar' = `evar'/sqrt(`mrssdf') in `first'/`last'
	qui replace `nuvar' = `nuvar'/sqrt(`mrssdf') in `first'/`last'

	tempvar wvar

	if `model' == 1 {
		qui gen double `wvar' = `diffvar' if `touse'
	} 
	else if `model' == 2 {
		qui sum `diffvar' in `first'/`last', meanonly
		qui gen double `wvar' = `diffvar'-r(mean) 	///
			in `first'/`last'
		qui replace `wvar' = cond(`touse',`wvar', .) 	///
			in `first'/`last'
	} 
	else if `model' == 3 {
		qui reg `diffvar' `ttrend' in `first'/`last'
		qui _predict double `wvar' in `first'/`last', res
		qui replace `wvar' = cond(`touse',`wvar', .) 	///
			in `first'/`last'
	}


	if `hac_lags' == . {
		_gethaclags `wvar' in `first'/`last', 		///
			method(`hac_bsel')			///
			kernel(`hac_kernel')			///
			obvar(`obvar')
		local hac_lags = r(haclags)
	}
	qui replace `hac_lagsused' = `hac_lags' in `first'
	_gethacvar `wvar' in `first'/`last',			///
		lags(`hac_lags') kernel(`hac_kernel')
	scalar `sigyi' = r(varhac)

	qui replace `sivar'  = sqrt(`sigyi'/`mrssdf') in `first'/`first'

end


program define _gethaclags, rclass

	syntax  varlist(max=1 ts) in,		///
		obvar(varlist max=1)		///
		kernel(string)			/// 
		[ method(string) ]

	local var "`varlist'"

	if "`method'" == "" {
		di in smcl as error 		///
"must specify number of lags or lag-selection algorithm in {bf:kernel()}"
		exit 198
	}

	qui count if `var' < . `in'
	local bigt = r(N)		// non-missing obs
	if "`method'" == "nwest" {
		qui sum `obvar' `in' if `var' < . 
		local last = r(max)

					// intb 1 => integer bandwidth
					// choices for q, cy and n from 
					// tables I  II 
					// newey west (1994) automatic 
					// lag selection ... pages 640-641
		if "`kernel'" == "bartlett" {
			local q    = 1
			local cy   = 1.1447
			local intb = 1
			local n    = int(4*(`bigt'/100)^(2/9))
		}
		else if "`kernel'" == "parzen" {
			local q    = 2
			local cy   = 2.6614
			local intb = 1
			local n    = int(4*(`bigt'/100)^(4/25))
		}
		else { 		// "`kernel'" == "qs" 
			local q    = 2
			local cy   = 1.3221
			local intb = 0
			local n    = int(4*(`bigt'/100)^(2/25))
		}

		
		tempname s_q s_0 sig_0 bigt p gamma sig_j hband
		tempvar  sigw

// note the denominators of bigt cancel when calculating gamma,
// so they are not used in calculating s_0 and s_q

		qui gen double `sigw' = (`var')^2 `in'
		qui sum `sigw' `in' , meanonly
		scalar `bigt' = r(N)

		scalar `sig_0' = r(sum)
		
		scalar `s_q' = 0	
		scalar `s_0' = `sig_0'	

		forvalues j = 1/`n' {
			qui replace `sigw' = `var'*L`j'.`var' `in'
			qui replace `sigw' = sum(`sigw') `in'
			scalar `sig_j' = `sigw'[`last']
			scalar `s_q' = `s_q' + 2*(`j')^`q' * `sig_j'
			scalar `s_0' = `s_0' + 2*`sig_j'
		}

		scalar `p'  =	(1/(2*`q'+1))

		scalar `gamma' = `cy'*( ( (`s_q'/`s_0')^2  )^(`p')  )

		if `intb' == 1 {
			scalar `hband' = int(`gamma'*`bigt'^(`p'))
			return scalar haclags = 		/// 
				cond(`hband'< `bigt',`hband'-1,`bigt'-2)
		}
		else {
			scalar `hband' = `gamma'*`bigt'^(`p')
			return scalar haclags =				///
				cond(`hband'<= `bigt',`hband'-1,`bigt'-1)
		}

		exit
	}
	else {			// Levin-Lin-Chui method
		tempname hband
		qui count `in'	// LLC use capT = # obs/panel in orig. dataset
		return scalar haclags = int(3.21*r(N)^(1/3))
	}
	
end

