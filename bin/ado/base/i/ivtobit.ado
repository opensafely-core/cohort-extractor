*! version 2.1.2  06mar2019
program define ivtobit, eclass byable(onecall) properties(svyb svyj svyr)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun ivtobit, unparfirsteq equal unequalfirsteq	///
		mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"ivtobit `0'"'
		exit
	}

	version 15 

	if replay() {
		if "`e(cmd)'" != "ivtobit" {
			error 301
		}
		if _by() {
			error 190
		}
		if "`e(method)'" == "ml" {
			MLDisplay `0'
		}
		else {
			TSDisplay `0'
		}
		exit
	}
	local version = string(_caller())
	if `version' >= 11 {
		local vv "version `version':"
	}
	`vv' `BY' Estimate `0'
	local cmdline `"ivtobit `0'"'
	local cmdline : list retokenize cmdline
	version 10: ereturn local cmdline `"`cmdline'"'
end

program define Estimate, eclass byable(recall) sortpreserve
	local version = string(_caller())
	if `version' >= 11 {
		local vv "version `version':"
	}
	version 15 

	ivmodel_parse tobit : `0'
	local end1 `s(end1)'
	local inst `s(inst)'
	local exog `s(exog)'
	local lhs `s(lhs)'
	local 0 `"`s(options)'"'

	// `lhs' contains depvar, 
	// `exog' contains RHS exogenous variables, 
	// `end1' contains RHS endogenous variables, and
	// `inst' contains the additional instruments

	if `version' < 15 {
		local opver SCore(string) Robust Cluster(varname)
	}
	else {
		local opver VERBose debug CONSTraints(passthru)
	}
	// Undocumented: verbose -- spew output
	// 		 debug   -- programmer debugging tool

	// Now parse the remaining syntax
	syntax [if] [in] [fw pw iw / ] , [ Mle TWOstep FIRST NOLOg LOg	  ///
		LL1 LL2(numlist min=1 max=1) UL1 UL2(numlist min=1 max=1) ///
		Level(cilevel) FROM(passthru) VCE(passthru) `opver' * ]
	_get_diopts diopts options, `options'

	if "`cluster'"!="" & "`vce'"!="" {
		/* version < 15						*/
		/* robust and vce() caught by -_vce_parserun-		*/
		di as err "options {bf:vce()} and {bf:cluster()} may " ///
		 "not be combined"
		exit 198
	}
	local estimator "`mle'`twostep'"
	if "`estimator'" == "" {
		local estimator "mle"
	}
	mlopts mlopts options, `options' 
	if "`s(collinear)'" != "" {
		local 0 , collinear
		syntax [, OPT]
		error 198	// [sic]
	}
	CheckNRTol, `twostep' `mlopts'
	if "`options'" != "" {
		gettoken opt options : options, bind
		di as err "option {bf:`opt'} not allowed"
		exit 198
	}
	if "`estimator'" == "twostep" {
		if `version' >= 15 { 
			local mlopts `"`mlopts'`constraints'"'
		}
		local opts `"`robust'`cluster'`score'`log'`nolog'"'
		local opts `"`opts'`from'`mlopts'"'
		if `"`opts'"' != "" {
			di as err "{p}two-step estimator only allows the " ///
			 "{bf:first} and {bf:level()} options{p_end}"
			exit 198
		}
		_vce_parse, optlist(TWOSTEP) :, `vce'
		local vce
	}
	else {
		/* -mlopts- parse vce					*/
		local options `"`options' `vce'"'
		_vce_parse, optlist(OIM OPG Robust) argoptlist(CLuster):, `vce'
		/* bootstrap and jackknife handled by -_vce_parserun-	*/
		local vcetype `r(vce)'
		if "`vcetype'" != "" {
			local robust `r(robust)'
			local cluster `r(cluster)'
		}
	}
	if _by() {
		_byoptnotallowed score() `"`score'"'
	}
	marksample touse
	markout `touse' `lhs' `exog' `end1' `inst'
	if "`cluster'" != "" {
		markout `touse' `cluster', strok
	}
	// Syntax checking
        if "`ll1'`ll2'`ul1'`ul2'" == "" {
                di as err "must specify censoring point"
                exit 198
        }
        if "`ll1'" != "" & "`ll2'" != "" {
                di as err "options {bf:ll} and {bf:ll(#)} may not be combined"
                exit 184
        }
        if "`ul1'" != "" & "`ul2'" != "" {
                di as err "options {bf:ul} and {bf:ul(#)} may not be combined"
                exit 184
        }
	if "`mle'" != "" & "`twostep'" != "" {
		di as err "cannot specify both {bf:mle} and {bf:twostep} " ///
		 "options"
		exit 198
	}
	if "`weight'" != "" { 
		tempvar wvar
		qui gen double `wvar' = `exp'
		local wgt `"[`weight'=`wvar']"' 
	}
	if "`weight'" != "" & "`weight'" != "fweight" & ///
		"`estimator'" == "twostep" {
		di as err "may only use {bf:fweights} with two-step estimator"
		exit 498
	}
	// Model identification checks
        `vv' ///
        ivrmcollin ivtobit : `lhs', touse(`touse') envars(`end1') ///
                exvars(`exog') ivvars(`inst') wgts(`weight' `wvar') 
		
	local fvopt `s(fvopt)'
	local tsops `s(tsops)'
	local exog `s(exvars)'
	local inst `s(ivvars)'
	local end1 `s(envars)'

	qui count if `touse'
	if r(N) == 0 {
		exit 2000
	}
	
	local exog_ct : word count `exog'
	local end1_ct : word count `end1'
	local inst_ct : word count `inst'
	if `end1_ct' == 0 {
		di as err "no endogenous variables; use {helpb tobit} instead"	
		exit 498
	}
        CheckOrder `end1_ct' `inst_ct'

	if "`score'" != "" {
		/* allow score() option if version < 15			*/
		local nscores = 1 + `end1_ct' + (`end1_ct'+1)*(`end1_ct'+2)/2
		/* clear any e(depvar) in case of error; wrong message	*/
		ereturn local depvar
		cap noi _stubstar2names `score', nvars(`nscores')
		local rc = c(rc)
		if `rc' {
			di as txt "{phang}The number of new variable names " ///
			 "specified in option {bf:score()} must be "         ///
			 "`nscores', or use the {it:stub*} notation.{p_end}"
			exit `rc'
		}
		local svlist `s(varlist)'
		/* always double					*/
		// local stype : word 1 of `s(typlist)'
		forvalues i=1/`nscores' {
			tempvar score`i'
			local stlist `stlist' `score`i''
		}
		local scopt score(`stlist')
	}

	// Now figure out what the ll() and ul() opts are
	tempname ll ul
	qui summ `lhs' if `touse', meanonly
	scalar `ll' = `r(min)' - 1
	scalar `ul' = `r(max)' + 1
	local llop = 0
	local ulop = 0
        if "`ll1'" != "" {
                scalar `ll' = `r(min)'
		local llop = 1
        }
        else if "`ll2'" != "" {
                scalar `ll' = `ll2'
		local llop = 1
        }
        if "`ul1'" != "" {
                scalar `ul' = `r(max)'
		local ulop = 1
        }
        else if "`ul2'" != "" {  
                scalar `ul' = `ul2'
		local ulop = 1
	}
	if `ul' <= `ll' {
		di as err "no uncensored observations"
		exit 2000
	}
	local llopt ll(`llop' `ll')
	local ulopt ul(`ulop' `ul')
	if "`estimator'" == "twostep" {
		TwoStep, touse(`touse') lhs(`lhs') exog(`exog') end1(`end1') ///
			inst(`inst') tsops(`tsops') `llopt' `ulopt'          ///
			level(`level') `first' wvar(`wvar') wtype(`weight')  ///
			version(`version') `verbose'
		ereturn local vce twostep
	}
	else if `version' < 15 { 
		if "`weight'" == "pweight" | "`cluster'" != "" {
			local robust robust
		}
		MLE14, touse(`touse') lhs(`lhs') exog(`exog') end1(`end1') ///
			inst(`inst') tsops(`tsops') `llopt' `ulopt'        ///
			wvar(`wvar') wtype(`weight') ///
			`log' `nolog' `from' `robust' ///
			cluster(`cluster') `scopt' `mlopts' `verbose'      ///
			version(`version') 

		if "`svlist'" != "" {
			tokenize `svlist'
			local i = 1
			while "``i''" != "" {
				rename `score`i'' ``i''
				local i = `i' + 1
			}
			ereturn local scorevars `svlsit'
		}
	}
	else {
		if "`weight'" == "pweight" {
			local vcetype robust
		}
		`vv' ///
		MLE, touse(`touse') lhs(`lhs') exog(`exog') end1(`end1') ///
			inst(`inst') `llopt' `ulopt' wvar(`wvar')        ///
			wtype(`weight') `log' `nolog' ///
			`from' vcetype(`vcetype')  ///
			clustvar(`cluster') `constraints' `mlopts'       ///
			`verbose' `debug'
	}
	tempname b
	mat `b' = e(b)

	ereturn local depvar "`lhs' `end1'"
	ereturn local instd `end1'
	local insts `exog' `inst'
	ereturn local insts "`:list retok insts'"
	ereturn scalar endog_ct = `end1_ct'
	qui test [#1]
	ereturn scalar chi2 = r(chi2)
	ereturn scalar df_m = r(df)
	ereturn scalar p = r(p)
	ereturn local chi2type Wald
	// Count number of censored observations
	// Need to account for fweights if supplied
	tempvar lone
	qui gen double `lone' = (`lhs' <= scalar(`ll'))
	if "`weight'" == "fweight" {
		qui replace `lone' = `lone'*`exp'
	}
	qui summ `lone' if e(sample), meanonly
	local llcens = r(sum)
	qui replace `lone' = (`lhs' >= scalar(`ul'))
	if "`weight'" == "fweight" {
		qui replace `lone' = `lone'*`exp'
	}
	qui summ `lone' if e(sample), meanonly
	loc ulcens = r(sum)
	loc notcens = e(N) - `llcens' - `ulcens'
	ereturn scalar N_unc = `notcens'
	ereturn scalar N_lc = `llcens'
	ereturn scalar N_rc = `ulcens'
	makecns
	ereturn hidden scalar k_autoCns = r(k_autoCns)
	
	if "`weight'" != "" {
		ereturn local wtype "`weight'"
		ereturn local wexp "= `exp'"
	}
	if "`llopt'" != "" {
		ereturn scalar llopt = scalar(`ll')
		ereturn hidden local limit_l `=scalar(`ll')'
	}
	if "`ulopt'" != "" {
		ereturn scalar ulopt = scalar(`ul')
		ereturn hidden local limit_u `=scalar(`ul')'
	}
	if "`ll1'`ll2'" == "" {
		ereturn hidden local limit_l "-inf"
	}
	if "`ul1'`ul2'" == "" {
		ereturn hidden local limit_u "+inf"
	}
	// Undocumented, but needed for -predict , scores-
	ereturn hidden scalar tobitll = scalar(`ll')
	ereturn hidden scalar tobitul = scalar(`ul')
	ereturn hidden scalar version = `version'
	ereturn local footnote "ivtobit_footnote"
	ereturn local predict "ivtobit_p"
	ereturn local estat_cmd "ivtobit_estat"
	local mok XB E(passthru) Pr(passthru) YStar(passthru)
	local mok `mok' default STRuctural Mean fix(passthru) base(passthru)
	local mok `mok' TARGet(passthru)
	ereturn local marginsok `mok'
	ereturn local marginsprop "nochainrule"
	ereturn local cmd "ivtobit"
	
	if "`e(method)'" == "ml" {
		MLDisplay , level(`level') `first' `diopts'
	}
	else {
		TSDisplay, level(`level') `diopts'
	}
end

program define MLDisplay
	syntax , [ level(cilevel)  first * ]

	if "`first'" != "" {
		local noskip noskip
	}
	_get_diopts diopts, `options'

	local 0, `diopts'
	syntax, [ coeflegend * ]
	local ver = cond(missing(e(version)),14.1,e(version))

	_coef_table_header
	di
	if `ver' <= 14.1 {
		version 9.1: ///
		ml display, noheader level(`level') `noskip' nofootnote `diopts'
	}
	else if "`coeflegend'" != "" {
		_coef_table, `diopts' nodiparm
	}
	else if "`first'" == "" {
		_coef_table, level(`level') first `diopts'
	}
	else {
		_coef_table, level(`level') `noskip' `diopts'
	}
	_prefix_footnote
end

program define TSDisplay
	syntax , [ level(cilevel) first *]
	
	if "`first'" != "" {
		local noskip noskip
	}
	_get_diopts diopts, `options'
	di
	di as text "Two-step tobit with endogenous regressors" _c
	di as text _col(51) "Number of obs   = " as res %10.0fc e(N)
	_censobs_header 67
	di
	di as text _col(51) "Wald chi2(" as res e(df_m) as text ")    = " _c
	di as result %10.2f e(chi2)
	di as text _col(51) "Prob > chi2     = " as res %10.4f  ///
		chiprob(e(df_m), e(chi2))
	di
	_coef_table, level(`level') `diopts'
	_prefix_footnote
end

// Borrowed from ivreg.ado	
program define IsStop, sclass

	if `"`0'"' == "[" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "," {
		sret local stop 1
		exit
	}
	if `"`0'"' == "if" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "in" {
		sret local stop 1
		exit
	}
	if `"`0'"' == "" {
		sret local stop 1
		exit
	}
	else {
		sret local stop 0
	}
end

// Borrowed from ivreg.ado	
program define Subtract   /* <cleaned> : <full> <dirt> */
	args        cleaned     /*  macro name to hold cleaned list
		*/  colon       /*  ":"
		*/  full        /*  list to be cleaned
		*/  dirt        /*  tokens to be cleaned from full */

	tokenize `dirt'
	local i 1
	while "``i''" != "" {
		local full : subinstr local full "``i''" "", word all
		local i = `i' + 1
	}

	tokenize `full'                 /* cleans up extra spaces */
	c_local `cleaned' `*'
end

// Borrowed from ivreg.ado
program define Disp
        local first ""
        local piece : piece 1 64 of `"`0'"'
        local i 1
        while "`piece'" != "" {
                di as text "`first'`piece'"
                local first "               "
                local i = `i' + 1
                local piece : piece `i' 64 of `"`0'"'
        }
        if `i'==1 { 
		di 
	}
end

program define CheckOrder
	
	args end inst

        if `end' > `inst' {
                di as err "equation not identified; must have at " ///
                        "least as many instruments "
                di as err "not in the regression as there are "    ///
                        "instrumented variables"
                exit 481
        }
end

program define Check4FVars, sclass
        version 11
        syntax varlist(ts) ,            ///
                touse(varname)          ///
        [                               ///
                exog(varlist ts fv)     ///
                end1(varlist ts fv)     ///
                inst(varlist ts fv)     ///
        ]
        // NOTE: -syntax- sets 'e(fvops)'
end

program define CheckNRTol
	syntax, [ twostep NRTOLerance(passthru) * ]

	if "`nrtolerance'"=="" & "`twostep'"=="" {
		c_local mlopts `options' nrtolerance(1e-7)
	}
end

program define Tobit, eclass
	version 9
	syntax, touse(varname) version(string) ll(string) ul(string) ///
		lhs(string) [ wtype(string) wvar(varname) ind(string) verbose ]
	
	if `version' >= 11 {
		local vv "version `version':"
	}
	if "`wtype'" != "" {
		local wgt [`wtype'=`wvar']
	}
	gettoken llop ll : ll
	gettoken ulop ul : ul

	// Using intreg since tobit doesn't take pweights
	tempvar intregl intregr 
	qui gen double `intregl' = `lhs' if `touse'
	qui gen double `intregr' = `lhs' if `touse'

	qui replace `intregl' = . if `touse' & `intregl'<=scalar(`ll')
	qui replace `intregr' = . if `touse' & `intregr'>=scalar(`ul')
	if `llop' {
		qui replace `intregr' = scalar(`ll') ///
			if `lhs'<=scalar(`ll') & `touse'
	}
	if `ulop' {
		qui replace `intregl' = scalar(`ul') ///
			if `touse' & `lhs'>=scalar(`ul') 
	}
	if "`verbose'" != "" {
		local noi noi
	}
	capture `noi' `vv' intreg `intregl' `intregr' `ind' `wgt' if `touse'
	if _rc {
		di as err "could not find initial values"
		exit 498
	}

	if `version' >= 11 {
		tempname b s V

		mat `b' = e(b)
		mat `V' = e(V)

		local eq : subinstr local lhs "." "_", all

		/* no free param from -intreg-, we access by position
		 *  no need to restripe					*/
		mat `s' = `b'[1,"lnsigma:_cons"]
		mat `b' = `b'[1,"model:"]
		mat coleq `b' = `eq'
		mat `b' = (`b',`s')
		local stripe : colfullnames `b'

		`vv' ///
		mat rownames `V' = `stripe'
		`vv' ///
		mat colnames `V' = `stripe'
		ereturn repost b=`b' V=`V', rename
	}
end

program define TwoStep, eclass
	syntax, touse(varname) lhs(string) end1(string) inst(string)     ///
		tsops(integer) version(string) ll(passthru) ul(passthru) ///
		[ exog(string) wtype(string) wvar(varname) first         ///
		level(passthru) verbose ]
	// First set up D(Pi)
       	// The selection matrix is just the identity matrix
        // if we include the exogenous variables after the other insts.
	local vv "version `version':"
 	if `tsops' {
		qui tsset, noquery
		fvrevar `lhs' if `touse', tsonly
		local tslhs `r(varlist)'
		fvrevar `end1' if `touse', tsonly
		local tsend1 `r(varlist)'
		fvrevar `exog' if `touse', tsonly
		local tsexog `r(varlist)'
		fvrevar `inst' if `touse', tsonly
		local tsinst `r(varlist)'
	}
	else {
		local tslhs `lhs'
		local tsend1 `end1'
		local tsexog `exog'
		local tsinst `inst'
	}
	local exog_ct : list sizeof tsexog
	local inst_ct : list sizeof tsinst
	local end1_ct : list sizeof tsend1
        local totexog_ct = `exog_ct' + `inst_ct'
       	tempname DPi  
        mat `DPi' = J(`totexog_ct'+1, `end1_ct'+`exog_ct'+1, 0)
       	mat `DPi'[`inst_ct'+1, `end1_ct'+1] = I(`exog_ct'+1)
        // Now do the first-stage regressions, fill in DPi and
       	// save fitted values and residuals
	if "`wtype'" != "" {
		local wgt [`wtype'=`wvar']
	}
        tempname junk
       	local fitted ""
        local resids ""
	if "`verbose'" == "" {
	        local qui qui
	}
        if "`first'" != "" {
        	local qui ""
        }
       	local i = 1
       	if `end1_ct' == 1 {
        	`qui' di "First-stage regression"
        }
        else {
        	`qui' di "First-stage regressions"
        }
        foreach y of local tsend1 {
		`vv' ///
       		`qui' _regress `y' `tsinst' `tsexog' `wgt' if `touse', ///
       			`level'
               	mat `junk' = e(b)
                mat `DPi'[1, `i'] = `junk' '
       	        tempvar fitted`i' resids`i'
               	qui predict double `fitted`i'' if `touse', xb
                qui predict double `resids`i'' if `touse', residuals
       	        local fitted "`fitted' `fitted`i''"
               	local resids "`resids' `resids`i''"
                local i = `i' + 1
       	}
	// 2SIV estimates
       	// We also use these 2SIV estimates for exog. test
	Tobit, touse(`touse') lhs(`lhs') ind(`tsend1' `tsexog' `resids')  ///
		`ll' `ul'  version(`version') wtype(`wtype') wvar(`wvar') ///
		`verbose'
	        
	tempname beta2s b2s l2s var2s chi2exog chi2exdf
        mat `beta2s' = e(b)
        mat `b2s' = `beta2s'[1, 1..`end1_ct']
        // Do the exog. test while we're at it.
       	qui  test `resids'
        scalar `chi2exog' = r(chi2)
        scalar `chi2exdf' = r(df)

        // Next, estimate the reduced-form alpha
        // alpha does not contain the params on `resids'
        // Also get lambda
	Tobit, touse(`touse') lhs(`lhs') ind(`tsinst' `tsexog' `resids') ///
		`ll' `ul' version(`version') wtype(`wtype') wvar(`wvar') ///
		`verbose'
        tempname b alpha lambda
        mat `b' = e(b)
        mat `alpha' = J(1, `totexog_ct'+1, 0)
        mat `alpha'[1, 1] = `b'[1, 1..`totexog_ct']
        mat `alpha'[1, `totexog_ct'+1] = ///   
        	`b'[1, `totexog_ct'+`end1_ct'+1]
        mat `lambda' = `b'[1, `totexog_ct'+1..`totexog_ct'+`end1_ct']

        // Build up the omega matrix
        tempname omega var
        mat `var' = e(V)
        mat `omega' = J(`totexog_ct'+1, `totexog_ct'+1, 0)
	// First term is J_aa inverse, which is cov matrix
        // from reduced-form tobit
        mat `omega'[1, 1] = `var'[1..`totexog_ct', 1..`totexog_ct']
        local j = `totexog_ct'+`end1_ct'+1 
        mat `omega'[`totexog_ct'+1, `totexog_ct'+1] = `var'[`j',`j']
        forvalues i = 1/`totexog_ct' {
        	mat `omega'[`totexog_ct'+1, `i'] = `var'[`j', `i']
                mat `omega'[`i', `totexog_ct'+1] = `var'[`i', `j']
        }
        tempvar ylb
        qui gen double `ylb' = 0
        local i = 1
        foreach var of varlist `tsend1' {
		qui replace `ylb' = `ylb' + ///
                	`var'*(`lambda'[1,`i'] - `b2s'[1, `i']) if `touse'
                local i = `i' + 1
        }
	`vv' ///
        qui _regress `ylb' `tsinst' `tsexog' `wgt' if `touse'
        tempname V
        mat `V' = e(V)
        mat `omega' = `omega' + `V'
        tempname omegai
        mat `omegai' = syminv(`omega')
		
        // Newey answer
        tempname finalb finalv
        mat `finalv' = syminv(`DPi'' * `omegai' * `DPi')
        mat `finalb' = `finalv' * `DPi'' * `omegai' * `alpha''
        mat `finalb' = `finalb''
                
	loc names "`end1' `exog' _cons"
        `vv' mat colnames `finalb' = `names'
        `vv' mat colnames `finalv' = `names'
        `vv' mat rownames `finalv' = `names'
        qui summ `touse' `wgt' , meanonly
	local capn = r(sum)
	_ms_op_info `finalb'
	if r(tsops) {
		quietly tsset, noquery
	}
        eret post `finalb' `finalv' `wgt', depname(`lhsname') o(`capn') ///
		esample(`touse') buildfvinfo
        eret scalar chi2_exog = `chi2exog'
        eret scalar df_exog = `chi2exdf'
        eret scalar p_exog = chiprob(`chi2exdf', `chi2exog')

	eret local method "twostep"
	eret local vce "`vce'"
	_post_vce_rank
end

program define MLE_init, rclass
	syntax, touse(varname) lhs(string) end1(string) inst(string)   ///
		ll(passthru) ul(passthru) [ exog(string) wvar(varname) ///
		wtype(string) version(string) verbose ]

	local vv "version `version':"
	tempname b0 V0 se0 bfrom

	if "`verbose'" != "" {
		local cap noi
	}
	local end1_ct : list sizeof end1
	local exog_ct : list sizeof exog
	local inst_ct : list sizeof inst

	Tobit, touse(`touse') lhs(`lhs') ind(`end1' `exog') `ll' `ul' ///
		version(`version') wtype(`wtype') wvar(`wvar') `verbose'
	mat `b0' = e(b)

	// one 1 for constant, second 1 for std. err
	local kcoef =`end1_ct' + `exog_ct' + 2
	if colsof(`b0') != `kcoef' {
		di as err "could not find initial values"
		exit 498
	}
	mat `se0' = `b0'[1, (`end1_ct'+`exog_ct'+2)]
	mat `b0' = `b0'[1, 1..(`end1_ct'+`exog_ct'+1)]

	`vv' ///
	cap `noi' sureg (`end1' = `exog' `inst')
	if _rc {
		di as err "could not find initial values"
		exit 498
	}
	mat `V0' = e(Sigma)
	if "`verbose'" != "" {
		mat li `V0', title(Sigma)
	}
	tempname bv
	if `version' < 15 { 
		tempname cholV
		cap mat `cholV' = cholesky(`V0')
		if _rc {
			di as err "could not find initial values"
			exit 498
		}
		loc nchol = `end1_ct'*(`end1_ct' + 1) / 2
		mat `V0' = J(1, `nchol', 0)
		loc m = 1
		forv i = 1/`end1_ct' {
			local stripe1 `stripe1' s`i'1
			local i1 = `i'+1
			forv j = `i'/`end1_ct' {
				local j1 = `j' + 1
				local stripe `stripe' s`i1'`j1'
				mat `V0'[1, `m'] = `cholV'[`i',`j']
				loc m = `m' + 1
			}
		}
		if `end1_ct' == 1 {
			mat `bv' = (0,`se0'[1,1],ln(`V0'[1,1]))
			local stripe rho:_cons lns:_cons lnv:_cons 
		}
		else {
			local stripe `stripe1' s`=`end_ct'+1'1 `stripe'
			mat `bv' = (exp(`se0'[1,1]), J(1,`end1_ct', 0), `V0')
		}
	}
	else {
		tempname bv corr s
		mat `s' = cholesky(diag(vecdiag(`V0')))
		mat `bv' = syminv(`s')
		mat `corr' = `bv'*`V0'*`bv'
		loc k = (`end1_ct'+1)*(`end1_ct'+2) / 2
		mat `bv' = J(1,`k',0)
		loc m = `end1_ct'
		forvalues i = 1/`end1_ct' {
			local i1 = `i'+1
			local j1 = `i1'
			if `version' < 16 {
				local stripe1 `"`stripe1' athrho`i1'_1:_cons"'
			}
			else {
				local stripe1 `"`stripe1' /:athrho`i1'_1"'
			}
			forvalues j = `i1'/`end1_ct' {
				local j1 = `j'+1
				mat `bv'[1,`++m'] = atanh(`corr'[`j',`i'])
				if `version' < 16 {
					local nm "athrho`j1'_`i1':_cons"
					local stripe `"`stripe' `nm'"'
				}
				else {
					local nm "/:athrho`j1'_`i1'"
					local stripe `"`stripe' `nm'"'
				}
			}
		}
		local stripe `"`stripe1' `stripe'"'
		mat `bv'[1,`++m'] = `se0'[1,1]
		if `version' < 16 {
			local stripe `"`stripe' lnsigma1:_cons"'
		}
		else {
			local stripe `"`stripe' /:lnsigma1"'
		}
		forvalues i = 1/`end1_ct' {
			mat `bv'[1,`++m'] = log(`s'[`i',`i'])
			if `version' < 16 {
				local stripe `"`stripe' lnsigma`=`i'+1':_cons"'
			}
			else {
				local stripe `"`stripe' /:lnsigma`=`i'+1'"'
			}
		}
	}
	mat colnames `bv' = `stripe'
	mat `bfrom' = (`b0',e(b),`bv')

	return mat b = `bfrom'
end

program define MLE14, eclass
	syntax, touse(varname) lhs(string) end1(string) inst(string)  ///
		tsops(integer) version(string) ll(string) ul(string)  ///
		[ exog(string) wvar(varname) wtype(string) NOLOg LOg   ///
		from(string) robust cluster(passthru) score(passthru) ///
		verbose * ]

	local vv version `version':
	local lhsname `lhs'
	local lhsstr : subinstr local lhsname "." "_"
	local exogname `exog'
	local end1name `end1'
	local instname `inst'

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`verbose'"=="" & "`log'" != "" {
		local qui qui
	}
	if "`wtype'" != "" {
		local wgt [`wtype'=`wvar']
	}
 	if `tsops' {
		qui tsset, noquery
		fvrevar `lhs', tsonly
		local tslhs `r(varlist)'
		fvrevar `end1', tsonly
		local tsend1 `r(varlist)'
		fvrevar `exog', tsonly
		local tsexog `r(varlist)'
		fvrevar `inst', tsonly
		local tsinst `r(varlist)'
	}
	else {
		local tslhs `lhs'
		local tsend1 `end1'
		local tsexog `exog'
		local tsinst `inst'
	}
	local exog_ct : list sizeof tsexog
	local inst_ct : list sizeof tsinst
	local end1_ct : list sizeof tsend1
	local mlopts `options'
	if "`from'" == "" {
		tempname bfrom
		// Starting values
		`qui' di as text _n "Fitting exogenous tobit model"

		MLE_init, touse(`touse') lhs(`tslhs') exog(`tsexog')    ///
			end1(`tsend1') inst(`tsinst') ll(`ll') ul(`ul') ///
			wtype(`wtype') wvar(`wvar') version(`version')  ///
			`verbose'

		mat `bfrom' = r(b)
		if "`verbose'" != "" {
			mat li `bfrom', title(initial estimates)
		}
		local init "`bfrom', copy"
	}
	else {
		local init "`from'"
	}
	loc iveqns ""
	loc covterms "/s11 "  
	loc testcmd ""  
	loc i = 1
	foreach var of varlist `tsend1' {
		loc iveqns "`iveqns' (`var' : `var' = `tsexog' `tsinst')"
		loc ip1 = `i' + 1
		// Only for multiple endog vars:
		loc covterms "`covterms' /s`ip1'1"
		loc testcmd "`testcmd' [s`ip1'1]_b[_cons]"
		loc i = `i' + 1
	}
	if `end1_ct' > 1 {
		forv j = 1/`end1_ct' {
			loc jp1 = `j' + 1
			forv i = `j'/`end1_ct' {
				loc ip1 = `i' + 1
				loc covterms "`covterms' /s`ip1'`jp1'"
			}
		}
		local lffun ivtob_lf
	}
	else {  // Fix things up for the one endog var model
		loc covterms "/alpha /lns /lnv"
		loc testcmd "[alpha]_b[_cons]"
		loc dip diparm(lns, exp label("s"))	///
			 diparm(lnv, exp label("v"))
		local lffun ivtob_1_lf
	}
	`qui' di as text _n "Fitting full model"
	// sort so that we can get the cov terms from the
	// last obs. in dataset in lf
	tempvar currsort
	tempname nc
	gen `c(obs_t)' `currsort' = _n
	sort `touse' `currsort'

	gettoken llop ll : ll
	gettoken ulop ul : ul

	glo IVT_NEND = `end1_ct'
	glo IVT_ll `ll'
	glo IVT_ul `ul'
	local title Tobit model with endogenous regressors
	`vv' ///
	ml model lf `lffun' (`lhsstr' : `tslhs' = `tsend1' `tsexog') ///
		`iveqns' `covterms' `wgt' if `touse', title(`title') ///
		maximize `mlopts' `robust' `cluster' search(off)     ///
		init(`init') `mllog' `score' `dip' collinear

	macro drop IVT_NEND
	macro drop IVT_ll
	macro drop IVT_ul
		
	qui test `testcmd'
	eret scalar chi2_exog = r(chi2)
	eret scalar endog_ct = `end1_ct'
	eret scalar p_exog = chiprob(1, e(chi2_exog))
	eret local method "ml"
	if e(endog_ct) == 1 {
		eret hidden scalar k_eq_skip = e(endog_ct)
		eret scalar k_aux = e(k_eq) - e(k_eq_skip) - 1
	}
	else {
		eret hidden scalar k_eq_skip = e(k_eq) - 1
	}
	tempname b0 V0
	// rename b and V -- time-series operators
	mat `b0' = e(b)
	mat `V0' = e(V)
	local names : colfullnames `b0'
 	if `tsops' {
		// Need to do end1 separately, because if an eqn name,
		// must replace . with _

		foreach y of local tsend1 {
			local j : list posof "`y'" in tsend1
			local y2 : word `j' of `end1'
			local y2s : subinstr local y2 "." "_"
			local names : subinstr local names ":`y'" ":`y2'", all
			local names : subinstr local names "`y':" "`y2s':", all
		}
		foreach x in exog inst {
			foreach y of local ts`x' {
				local j : list posof "`y'" in ts`x'
				local y2 : word `j' of ``x''
				local names : subinstr local names "`y'" ///
					"`y2'", all
			}
		}
		`vv' mat colnames `b0' = `names'
		`vv' mat colnames `V0' = `names'
		`vv' mat rownames `V0' = `names'
	}	
	_ms_op_info `b0'
	if r(tsops) {
		quietly tsset, noquery
	}
	eret repost b = `b0' V = `V0' `wgt', rename buildfvinfo
	// Return Sigma matrix
	tempname sigma
	mat `sigma' = I(`end1_ct'+1)
	if `end1_ct' == 1 {
		tempname s a v
		scalar `s' = exp([lns]_b[_cons])
		scalar `a' = [alpha]_b[_cons]
		scalar `v' = exp([lnv]_b[_cons])
		mat `sigma'[1,1] = `s'^2 + `a'^2 * `v'^2
		mat `sigma'[1,2] = `a'*`v'^2
		mat `sigma'[2,1] = `sigma'[1,2]
		mat `sigma'[2,2] = `v'^2
	}
	else {
		loc endp1 = `end1_ct' + 1
		forvalues j = 1/`endp1' {
			forvalues i = `j'/`endp1' {
				mat `sigma'[`i',`j'] = [s`i'`j']_b[_cons]
			}
		}
		mat `sigma' = `sigma'*`sigma''
	}
	eret matrix Sigma = `sigma'
end

program define GetFrom, rclass
	syntax, from(string) cnt(string) depvar(string) indepvars(string) ///
		ivvars(string) ivindvars(string) [ noconstant ]

	local kex : word 1 of `cnt'
	local ken : word 2 of `cnt'
	local kin : word 3 of `cnt'

	ParseFrom `from'
	local ismat = `r(ismatrix)'
	local from `"`r(from)'"'
	local fopt `r(option)'

	local k = `kex' + ("`constant'"=="") + `ken'*(`kin'+1)
	tempname b b1 b2 b3 a

	/* exogenous equation						*/
	local k1 = `kex' + `ken' + ("`constant'"=="")
	mat `b1' = J(1,`k1',0)
	local stripe1 `"`indepvars'"'
	if "`constant'" == "" {
		local stripe1 `"`stripe1' _cons"'
	}
	mat colnames `b1' = `stripe1'
	_ms_parse_parts `depvar'
	if "`r(ts_op)'" != "" {
		local eq : subinstr local depvar "." "_", all
		mat coleq `b1' = `eq'
	}
	else {
		mat coleq `b1' = `depvar'
	}

	/* endogenous equations						*/
	local k2 = `kin'+`kex'+1
	forvalues i=1/`ken' {
		local eq : word `i' of `ivvars'
		mat `a' = J(1,`k2',0)
		mat colnames `a' = `ivindvars' _cons
		_ms_parse_parts `eq'
		if "`r(ts_op)'" != "" {
			local eq : subinstr local eq "." "_", all
		}
		mat coleq `a' = `eq'
		mat `b2' = (nullmat(`b2'),`a')
	}

	/* std.dev. correlations					*/
	local ken1 = `ken'+1
	local k3 = `ken'*`ken1'/2 + `ken' + 1
	mat `b3' = J(1,`k3',0)
	forvalues i=1/`ken1' {
		forvalues j=`=`i'+1'/`ken1' {
			local stripe3 `stripe3' athrho`j'_`i':_cons
		}
	}
	forvalues i=1/`ken1' {
		local stripe3 `stripe3' lnsigma`i':_cons
	}
	mat colnames `b3' = `stripe3'
	mat `b' = (`b1',`b2',`b3')

	if "`fopt'" == "copy" {
		local stripe : colfullnames `b'
		local colopt colnames(`stripe')
	}
	else {
		local upopt  update
	}
	cap noi _mkvec `b', from(`from',`fopt') `upopt' `colopt'
	local rc = c(rc)
	if `rc' {
		di as text "{phang}The {bf:from()} specification is " ///
		 "invalid.{p_end}"
		exit `rc'
	}
	return mat b = `b'
end

program ParseFrom, rclass
	cap noi syntax anything(name=from id="from()" equalok), [ copy skip ]
	local rc = c(rc)

	if `rc' {
		di as txt "{phang}Option {bf:from()} is not specified " ///
		 "correctly.{p_end}"
		exit `rc'
	}
	cap confirm matrix `from'

	local k : word count `copy' `skip'
	if `k' == 2 {
		di as err "{p}{bf:from()} sub-options {bf:copy} and " ///
		 "{bf:skip} cannot be specified together{p_end}"
		exit 184
	}

	return local ismatrix = (c(rc)==0)
	return local from `"`from'"'
	return local option `copy'`skip'
end

program define MLE, eclass
	local version = string(_caller())
	local vv "version `version':"
	version 15
	syntax, touse(varname) lhs(string) end1(string) inst(string) ///
		ll(string) ul(string) [ exog(string) wvar(varname)   ///
		wtype(string) NOLOg LOg from(passthru) vcetype(string)   ///
		clustvar(string) verbose debug constraints(passthru) * ]

	local lhseq : subinstr local lhsname "." "_"

	local kexog : list sizeof exog
	local kinst : list sizeof inst
	local kend1 : list sizeof end1
	local mlopts `options'

	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" != "" {
		local qui qui
	}
	if "`wtype'" != "" {
		local wgt [`wtype'=`wvar']
	}
	tempname b
	if "`from'" == "" {
		local llopt
		tempname bfrom
		// Starting values
		`qui' di as text _n "Fitting exogenous tobit model"

		MLE_init, touse(`touse') lhs(`lhs') exog(`exog')      ///
			end1(`end1') inst(`inst') ll(`ll') ul(`ul')   ///
			wtype(`wtype') wvar(`wvar') version(`version') ///
			`verbose'
	}
	else {
		`vv' ///
		ivgetfrom, `from' depvar(`lhs') exvars(`exog') ///
			envars(`end1') ivvars(`inst') `constant'
	}
	mat `b' = r(b)
	if "`verbose'" != "" {
		mat li `b', title("from()")
	}
	if "`constraints'" != "" {
		tempname Cm T C a
		_make_constraints, b(`b') `constraints'
		mat `Cm' = e(Cm)
		mat `T' = e(T)
		mat `a' = e(a)
		/* apply constraints to initial estimates		*/
		/* stripe preserved					*/
		mat `b' = `b'*`T'
		mat `b' = `b'*`T'' + `a'
	}
	`qui' di as text _n "Fitting full model" _n

	gettoken llop ll: ll
	gettoken ulop ul: ul
	local log = ("`log'"=="")
	local debug = ("`debug'"!="")
	mata: ivtobit_mopt("`b'","`lhs'",`kend1',`=`ll'',`=`ul'',"`touse'", ///
		"`wtype'","`wvar'","`vcetype'","`clustvar'","`Cm'",`log',   ///
		"`options'",`debug')

	tempname b
	mat `b' = e(b)
	/* posts e(Sigma), diparms, endog_cnt, k_aux, and 		*/
	/* chi2 test for exogeneity					*/
	`vv' ///
	ivpostsigma, b(`b') vars(`lhs' `end1')

	ereturn local method "ml"
	ereturn scalar k_eq_model = 1
	ereturn local title "Tobit model with endogenous regressors"
end

program define TallyOmitted, sclass 
	syntax, vlist(string) end1(string) 

	foreach var of local vlist {
		_ms_parse_parts `var'
		local inend1 : list var in end1
		if "`r(type)'" != "variable" {
			if `inend1' {
				local end1_keep `end1_keep' `var'
			}
			else {
				local exog_keep `exog_keep' `var'
			}
			continue
		}
		if `inend1' {
			if `r(omit)' {
				local end1_drop `end1_drop' `var'
			}
			local end1_keep `end1_keep' `var'
		}
		else {
			if `r(omit)' {
				local exog_drop `exog_drop' `var'
			}
			else {
				local exog_noomit `exog_noomit' `var'
			}
			local exog_keep `exog_keep' `var'
		}
	}
	sreturn local exog_keep `exog_keep'
	sreturn local exog_drop `exog_drop'
	sreturn local exog_noomit `exog_noomit'
	sreturn local end1_keep `end1_keep'
	sreturn local end1_drop `end1_drop'
end

exit
