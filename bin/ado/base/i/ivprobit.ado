*! version 2.2.3  06mar2019
program define ivprobit, eclass byable(onecall) ///
		properties(svyb svyj svyr)
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	`BY' _vce_parserun ivprobit, unparfirsteq equal unequalfirsteq	///
		mark(CLuster) : `0'
	if "`s(exit)'" != "" {
		version 10: ereturn local cmdline `"ivprobit `0'"'
		exit
	}

	version 8.2

	if replay() {
		if "`e(cmd)'" != "ivprobit" {
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
	local cmdline `"ivprobit `0'"'
	local cmdline : list retokenize cmdline
	version 10: ereturn local cmdline `"`cmdline'"'
end

program define Estimate, eclass byable(recall) sortpreserve
	local version = string(_caller())
	if `version' >= 11 {
		local vv "version `version':"
	}
	version 8.2
	
	ivmodel_parse probit : `0'
	local end1 `s(end1)'
	local inst `s(inst)'
	local exog `s(exog)'
	local lhs `s(lhs)'
	local 0 `"`s(options)'"'

	// `lhs' contains depvar, 
	// `exog' contains RHS exogenous variables, 
	// `end1' contains RHS endogenous variables, and
	// `inst' contains the additional instruments

	// parse the remaining syntax
	if `version' <= 14.0 {
		/* undocumented -doopt- is passed thru to -probit-	*/
		/* 	-probit- specified -ml- option -halfsteponly-	*/
		local opts14 Robust CLuster(varname) NRTOLerance(string)
		local opts14 `opts14' SCore(string) doopt
	}
	else {
		local opts14_1 VERBose INITITERate(passthru) debug
		local opts14_1 `opts14_1' CONSTraints(passthru)
		/* undocumented: verbose - spew output			*/
		/* 		 debug   - debugging			*/
		/*               inititerate(#) - # iterations for	*/
		/*			initial estimates		*/
	}
	syntax [if] [in] [fw pw iw / ] , [ Mle TWOstep first NOLOg LOg asis ///
		Level(cilevel) from(passthru) `opts14_1' `opts14' ///
		moptobj(passthru) VCE(passthru) * ]

	_get_diopts diopts options, `options'
	if "`twostep'" != "" {
		_vce_parse, optlist(TWOSTEP) :, `vce'
	}
	else if `"`vce'"' != "" {
		local options `"`options' `vce'"'
	}
	// Syntax checking
	if "`mle'"!="" & "`twostep'"!="" {
		di as err "{p}options {bf:mle} and {bf:twostep} cannot be " ///
		 "specified together{p_end}
		exit 184
	}
	local estimator "`mle'`twostep'"
	if "`estimator'" == "" {
		local estimator "mle"
	}
	if "`weight'" != "" { 
		tempvar wvar
		qui gen double `wvar' = `exp'
		local wgt [`weight'=`wvar']
	}
	if "`weight'"!="" & "`weight'"!="fweight" & "`estimator'"=="twostep" {
		di as err "`weight's not allowed"
		di as text "{phang}The two-step estimator may only use " ///
		 "fweights{p_end}"
		exit 498
	}
	if "`nrtolerance'"=="" & "`estimator'"=="mle" & `version'<=14.0 {
		local nrtolerance 1e-7
	}
	if "`nrtolerance'" != "" {
		local options `"`options' nrtolerance(`nrtolerance')"'
	}
	mlopts mlopts options, `options'
	if "`s(collinear)'" != "" {
		local 0 , collinear
		syntax [, OPT]
		error 198	// [sic]
	}
	if "`options'" != "" {
		gettoken opt options : options, bind
		di as err "option {bf:`opt'} not allowed"
		exit 198
	}
	if "`estimator'" == "mle" {
		local vce `s(vce)'
	}
	else {
		if `"`s(vce)'"' != "" {
			di as err "duplicate {bf:vce()} option not allowed"
			exit 198
		}
	}
	/* _vceparserun catches -robust- with -vce()-			*/
	if "`cluster'"!="" & "`vce'"!="" {
		di as err "{p}options {bf:vce()} and {bf:cluster()} cannot " ///
		 "be specified together{p_end}" 
		exit 184
	}
	/* option vce parsed by -mlopts-; get type			*/
	if "`estimator'" == "mle" {
		GetVCEtype, `vce' wtype(`weight')
		local vcetype `s(vcetype)'
		if "`s(vceclvar)'" != "" {
			local cluster `s(vceclvar)'
		}
		if "`cluster'" != "" { 
			local clusopt "cluster(`cluster')" 
		} 
	}

	if _by() {
		_byoptnotallowed score() `"`score'"'
	}
	if "`estimator'" == "twostep" {
		CheckTwostepOpts, `robust' cluster(`cluster') `log' `nolog'  ///
			`inititerate' `from' mlopts(`mlopts') score(`score') ///
			`constraints'
	}
	if "`weight'" == "pweight" | "`cluster'" != "" {
		local robust "robust"
	}
	if "`from'"!="" & "`inititerate'"!="" {
		di as err "{p}options {bf:from()} and {bf:inititerate()} " ///
		 "cannot be specified together{p_end}"
		exit 184
	}
	marksample touse
	markout `touse' `exog' `end1' `inst'
	if "`cluster'" != "" {
		markout `touse' `cluster', strok
	}

	fvexpand `exog' if `touse'
	local exog "`r(varlist)'"

	fvexpand `inst' if `touse'
	local inst "`r(varlist)'"

	fvexpand `end1' if `touse'
	local end1 "`r(varlist)'"

	/* version < 14.1 allows score() option				*/
	if "`score'" != "" {
		// end1_ct gets redone later after collinearity checking
		local end1_ct : word count `end1'
		local nscores = 1+`end1_ct'+(`end1_ct'+1)*(`end1_ct'+2)/2-1
		cap noi _stubstar2names `score', nvars(`nscores')
		local rc = c(rc)
		if `rc' {
			di as txt "{phang}The number of new variable names " ///
			 "specified in option {bf:score()} must be "         ///
			 "`nscores', or use the {it:stub*} notation.{p_end}"
			exit `rc'
		}
		local svlist `s(varlist)'
		local stype : word 1 of `s(typlist)'
	}
	
	`vv' Check4FVars `lhs',	exog(`exog')	///
				end1(`end1')	///
				inst(`inst')	///
				touse(`touse')

	local fvops = "`s(fvops)'" == "true" | `version' >= 11
	local tsops = "`s(tsops)'" == "true"
	if `fvops' {
		if `version' < 11 {
			local vv "version 11:"
		}
	}
	else {
		// model identification checks
		CheckVars `lhs' "`exog'" "`end1'" "`inst'" `touse' "`wgt'"
        	local exog `s(exog)'
		local inst `s(inst)'
	}

	// call _binperfect and locate perfect predictors
	// this includes exogenous and endogenous vars and insts
	// not if asis specified
	tempname rules
	mat `rules' = J(1,4,0)
	if `fvops' {
		`vv' ///
		cap noi _rmcoll `lhs' `exog' `end1' if `touse' `wgt', ///
			touse(`touse') logit expand `asis' noskipline
		if c(rc) {
			error c(rc)
		}
		mat `rules' = r(rules)
		local vlist "`r(varlist)'"
		gettoken lhs vlist : vlist
		local n : list sizeof exog
		local exog
		forval i = 1/`n' {
			gettoken v vlist : vlist
			local exog `exog' `v'
		}
		local end1 : copy local vlist
		// dropping endogenous variables not allowed
		CheckEndogDropped, endog(`end1')

		// Need to check reduced-form model if two-step est
		if "`twostep'" != "" {
			di as text "Checking reduced-form model..."
			`vv' ///
			cap noi _rmcoll `lhs' `inst' `exog' if `touse'    ///
				`wgt', touse(`touse') logit expand `asis' ///
				noskipline
			if c(rc) {
				error c(rc)
			}
			mat `rules' = `rules' \ r(rules)
			local vlist "`r(varlist)'"
			gettoken lhs vlist : vlist
		}
		else {
			`vv' ///
			_rmcoll `inst' `exog' if `touse' `wgt', expand
			local vlist "`r(varlist)'"
		}
		local n : list sizeof inst
		local inst
		forval i = 1/`n' {
			gettoken v vlist : vlist
			local inst `inst' `v'
		}
		local exog : copy local vlist
	}
	else if "`asis'" == "" {
		_binperfect `lhs' `exog' `end1' , touse(`touse')
		mat `rules' = r(rules)
		if !(`rules'[1,1] == 0 & `rules'[1,2] == 0 & ///
			`rules'[1,3] == 0 & `rules'[1,4] == 0) {
			noi _binperfout `rules'
			// remove dropped vars from varlists
			local dropped : rownames(`rules')
			foreach d in `dropped' {
				local exog : subinstr local exog "`d'" ""
				local inst : subinstr local inst "`d'" ""
				local end1 : subinstr ///
					local end1 "`d'" "", count(local c)
				if `c' > 0 {
					di as err "may not drop an " ///
					 "endogenous regressor"
					exit 498
				}
			}
			qui count if `touse'
			if r(N) == 0 {
				error 2000
			}
			CheckVars `lhs' "`exog'" "`end1'" "`inst'" 	///
				   `touse' "`wgt'"
			local exog `"`s(exog)'"'
			local inst `"`s(inst)'"' 
		}
		// need to check reduced-form model if two-step est
		if "`twostep'" != "" {
			di as txt "Checking reduced-form model..."
			_binperfect `lhs' `inst' `exog', touse(`touse')
			mat `rules' = r(rules)
			if !(`rules'[1,1] == 0 & `rules'[1,2] == 0 & ///
				`rules'[1,3] == 0 & `rules'[1,4] == 0) {
				noi _binperfout `rules'
				// Remove dropped vars from varlists
				local dropped : rownames(`rules')
				foreach d in `dropped' {
					local exog : subinstr local exog ///
						"`d'" ""
					local inst : subinstr local inst ///
						"`d'" ""
				}
				qui count if `touse'
				if r(N) == 0 {
					error 2000
				}
			}
		}

	}
	qui count if `touse'
	if r(N) == 0 {
		error 2000
	}
	if "`estimator'"=="twostep" | `version' <= 14.0 {
        	local exogname `exog'
	        local end1name `end1'
        	local instname `inst'
		if `tsops' {
			qui tsset, noquery
			fvrevar `lhs', tsonly
			local lhs `r(varlist)'
			fvrevar `end1', tsonly
			local end1 `r(varlist)'
			fvrevar `exog', tsonly
			local exog `r(varlist)'
			fvrevar `inst', tsonly
			local inst `r(varlist)'
		}
	}
	local exog_ct : word count `exog'
	local end1_ct : word count `end1'
	local inst_ct : word count `inst'
	if `end1_ct' == 0 {
		di as error "no endogenous variables; use {bf:probit} instead"	
		exit 498
	}
        CheckOrder `end1_ct' `inst_ct'

	tempvar xb	// used later by both estimators
	
	if "`estimator'" == "twostep" {
		TwoStep, lhs(`lhs') exog(`exog') inst(`inst') end1(`end1') ///
			touse(`touse') wtype(`weight') wvar(`wvar')        ///
			vv(`version') cnt(`exog_ct' `end1_ct' `inst_ct')   ///
			xb(`xb') `doopt' exogname(`exogname')              ///
			end1name(`end1name') instname(`instname') `first'
		ereturn local vce twostep
	}
	else if `version' <= 14.0 {
		MLE14, lhs(`lhs') exog(`exog') inst(`inst') end1(`end1') ///
			touse(`touse') wtype(`weight') wvar(`wvar')      ///
			vv(`version') cnt(`exog_ct' `end1_ct' `inst_ct') ///
			`log' `nolog' ///
			 xb(`xb') mlopts(`mlopts') `from' `clusopt' ///
			scores(`svlist') `doopt' exogname(`exogname')    ///
			end1name(`end1name') instname(`instname') `moptobj'
	}
	else {
		`vv' ///
		MLE, lhs(`lhs') exog(`exog') inst(`inst') end1(`end1') ///
			touse(`touse') wtype(`weight') wvar(`wvar')    ///
			cnt(`exog_ct' `end1_ct' `inst_ct') `log' `nolog' ///
			mlopts(`mlopts') xb(`xb') `from' `clusopt'     ///
			`constraints' vcetype(`vcetype') `inititerate' ///
			`verbose' `debug' `moptobj'
	}
	macro drop IV_NEND

	ereturn local chi2type Wald

	// count number of completely determined outcomes
        // need to account for fweights if supplied
        tempvar suc fai
        qui gen `suc' = (`xb' > 18)
        if "`weight'" == "fweight" {
           qui replace `suc' = `suc'*`exp'
        }
        qui summ `suc' if e(sample), meanonly
        eret scalar N_cds = r(sum)

        qui gen `fai' = (`xb' < -18)
        if "`weight'" == "fweight" {
           qui replace `fai' = `fai'*`exp'
        }
        qui summ `fai' if e(sample), meanonly
        eret scalar N_cdf = r(sum)

	ereturn hidden scalar version = `version'
	if "`asis'" != "" {
		eret local asis "asis"
	}
	// e(rules) undocumented but needed by predict
	eret matrix rules `rules'
	if "`weight'" != "" {
		eret local wtype "`weight'"
		eret local wexp "= `exp'"
	}
	eret local footnote "ivprobit_footnote"
	eret local estat_cmd "ivprobit_estat"
	eret local predict "ivprobit_p"
	eret local marginsok "Pr XB default STRuctural fix(passthru) base(passthru) TARGet(passthru)"
	eret local marginsprop "nochainrule"
	eret local cmd "ivprobit"
	if "`e(method)'" == "ml" {
		`vv' ///
		MLDisplay , level(`level') `first' `diopts'
	}
	else {
		TSDisplay, level(`level') `diopts'
	}
end

program define MLDisplay
	syntax , [ level(cilevel) first * ]

	if "`first'" != "" {
		local noskip noskip
	}
	_get_diopts diopts, `options'

	local 0, `diopts'
	syntax, [ coeflegend * ]
	local ver = cond(missing(e(version)),14,e(version))

	_coef_table_header
	di
	if `ver' < 14.1 {
		version 12: ///
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
	if "`coeflegend'" == "" {
		_prefix_footnote
	}
end

program define TSDisplay
	syntax , [ level(cilevel) *]
	
	_get_diopts diopts, `options'
	di
	di as text "Two-step probit with endogenous regressors" _c
	di as text _col(51) "Number of obs   = " as res %10.0fc e(N)
	di as text _col(51) "Wald chi2(" as res e(df_m) as text ")" _c
	di as text _col(67) "= " as result %10.2f e(chi2)
	di as text _col(51) "Prob > chi2     = " as res %10.4f  ///
		chiprob(e(df_m), e(chi2))
	di
	_coef_table, level(`level') `diopts'
	_prefix_footnote
end

program define ParseEquations, sclass

	local n = 0

	gettoken lhs rest : 0
	_fv_check_depvar `lhs'
	gettoken lhs 0 : 0, parse(" ,[") match(paren)
	IsStop `lhs'
	if `s(stop)' { 
		error 198 
	}  
	local syntax "{bf:(}{it:all instrumented variables}{bf: = }"
	local syntax "`syntax' {it:instrument variables}{bf:)}"
	while `s(stop)'==0 {
		if "`paren'"=="(" {
			local n = `n' + 1
			if `n'>1 {
				capture noi error 198
				di as txt "{phang}The syntax is: " ///
				 "`syntax'{p_end}"
				exit 198
			}
			gettoken p lhs : lhs, parse(" =")
			while "`p'"!="=" {
				if "`p'"=="" {
					capture noi error 198
					di as txt "{phang}The syntax is: " ///
					 "`syntax'.  The equal sign is "   ///
					 "required{p_end}"
					exit 198
				}
				local end`n' `end`n'' `p'
				gettoken p lhs : lhs, parse(" =")
			}
			fvunab end`n' : `end`n''
			if "`lhs'" != "" {
				fvunab exog`n' : `lhs'
			}
		}
		else {
			local exog `exog' `lhs'
		}
		gettoken lhs 0 : 0, parse(" ,[") match(paren)
		IsStop `lhs'
	}
	local 0 `"`lhs' `0'"'

	if !`n' {
		di as error "no endogenous variables; use {bf:probit} instead"	
		exit 498
	}
	cap _fv_check_depvar `end1'
	local rc = c(rc)
	if `rc' {
		di as err "{p}endogenous variables may not use factor " ///
		 "operators{p_end}
		exit `rc'
	}
	if "`exog1'" == "" {
		di as err "no instrument variables specified"
		di as txt "{phang}The syntax is: `syntax'{p_end}"
		exit 481
	}
	sreturn local end1 `end1'
	sreturn local exog1 `exog1'
	sreturn local exog `exog'
	sreturn local options `"`0'"'
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

program define Check4FVars, sclass
	version 11
	syntax varlist(ts) ,		///
		touse(varname)		///
	[				///
		exog(varlist ts fv)	///
		end1(varlist ts fv)	///
		inst(varlist ts fv)	///
	]
	// NOTE: -syntax- sets 'e(fvops)'
end

// Collinearity checker 
program define CheckVars, sclass
	args lhs exog end1 inst touse wgt

	/* backups */
	local end1_o `end1'
	local exog_o `exog'
	local inst_o `inst'
	
	/* Let X = [endog exog] and W = [exog inst].  Then
	   X'X and W'W must be of full rank */
	quietly {
		/* X'X */
		_rmcoll `end1' `exog' if `touse' `wgt'
		local noncol `r(varlist)'
		local end1 : list end1 & noncol
		local exog : list exog & noncol
		/* W'W */
		_rmcoll `exog' `inst' if `touse' `wgt'
		local noncol `r(varlist)'
		local exog : list exog & noncol
		local inst : list inst & noncol
	}
	local dropped : list end1_o - end1
	if `:word count `dropped'' > 0 {
		di as error "may not drop an endogenous regressor"
		exit 498
	}
	foreach type in exog inst {
		local dropped : list `type'_o - `type'
		foreach x of local dropped {
			di as text "note: `x' omitted because of collinearity"
		}
	}

	sret local exog `exog'
	sret local inst `inst'
end

program define CheckOrder
	args end inst

        if `end' > `inst' {
                di as error "equation not identified; must have at " ///
                        "least as many instruments "
                di as error "not in the regression as there are "    ///
                        "instrumented variables"
                exit 481
        }
end

program define GetVCEtype, sclass
	syntax, [ vce(string) wtype(string) ]

	if "`vce'" == "" {
		if "`wtype'" == "pweight" {
			sreturn local vcetype robust
		}
		else {
			sreturn local vcetype oim
		}
		exit
	}
	local 0, `vce'
	cap noi syntax, [ oim opg Robust Cluster * ]

	local vcetype `oim'`opg'`robust'`cluster'
	if "`wtype'"=="pweight" & "`vcetype'"!="robust" & ///
		"`vcetype'"!="cluster" {
		di as err "{p}option {bf:vce(`vcetype')} not allowed with " ///
		 "probability weights{p_end}"
		exit 198
	}
	sreturn local vcetype `oim'`opg'`robust'`cluster'
	sreturn local vceclvar `options'
end

program define CheckTwostepOpts
	syntax, [ robust cluster(passthru) NOLOg LOg inititerate(passthru) ///
		from(passthru) mlopts(string) score(passthru)          ///
		constraints(passthru) ]

	local rc = 0
	local opts robust cluster nolog log inititerate from mlopts score
	local opts `opts' constraints
	foreach opt in `opts' {
		if "``opt''" != "" {
			if "`opt'" == "mlopts" {
				local sopt ``opt''
				gettoken opt1 sopt : sopt, bind
				local `opt' `opt1'
			}
			di as err "option {bf:``opt''} not allowed"
			local rc = 198
			continue, break
		}
	}
	if !`rc' {
		exit
	}
	di as txt "{phang}The two-step estimator only allows the " ///
	 "{bf:first}, {bf:level()}, and {bf:asis} options.{p_end}"
	exit 198
end

program define CheckEndogDropped
	syntax, endog(string)

	while "`endog'" != "" {
		gettoken var endog : endog
		_ms_parse_parts `var'

		if r(omit) {
			di as err "{p}dropping an endogenous variable is " ///
			 "not allowed{p_end}"
			exit 498
		}
	}
end

program define TwoStep, eclass
	syntax, lhs(string) end1(string) touse(varname) cnt(numlist) ///
		xb(name) vv(string) end1name(string) [ exog(string)  ///
		inst(string) exogname(string) instname(string)       ///
		wtype(string) wvar(varname) doopt first]
	
	local version `vv'
	local vv version `vv':
	local exog_ct : word 1 of `cnt'
	local end1_ct : word 2 of `cnt'
	local inst_ct : word 3 of `cnt'
	if "`wtype'" != "" {
		local wgt [`wtype'=`wvar']
	}

	// First set up D(Pi)
       	// The selection matrix is just the identity matrix
        // if we include the exogenous variables after the other insts.
        local totexog_ct = `exog_ct' + `inst_ct'
       	tempname dpi  
	mat `dpi' = J(`totexog_ct'+1, `end1_ct'+`exog_ct'+1, 0)
        mat `dpi'[`inst_ct'+1, `end1_ct'+1] = I(`exog_ct'+1)
       // now do the first-stage regressions, fill in dpi and
        // save fitted values and residuals
       tempname junk
        local fitted ""
	local resids ""
	local qui "qui"
	if "`first'" != "" {
	    	local qui ""
	}
        local i = 1
        if `end1_ct' == 1 {
	       	`qui' di "first-stage regression"
	}
	else {
	      	`qui' di "first-stage regressions"
	}
	foreach y of local end1 {
		`vv' ///
		`qui' _regress `y' `inst' `exog' `wgt' if `touse', ///
        		level(`level')
               	mat `junk' = e(b)
	        mat `dpi'[1, `i'] = `junk' '
                tempvar fitted`i' resids`i'
               	qui predict double `fitted`i'' if `touse', xb
	        qui predict double `resids`i'' if `touse', residuals
                local fitted "`fitted' `fitted`i''"
               	local resids "`resids' `resids`i''"
	        local i = `i' + 1
        }
	// 2siv estimates
        // we also use these 2siv estimates for exog. test
	`vv' ///
	qui probit `lhs' `end1' `exog' `resids' `wgt' if `touse', `doopt'
        tempname beta2s b2s l2s var2s chi2exog chi2exdf
        mat `beta2s' = e(b)
        mat `b2s' = `beta2s'[1, 1..`end1_ct']
        // do the exog. test while we're at it.
	qui test `resids'
        scalar `chi2exog' = r(chi2)
        scalar `chi2exdf' = r(df)
	        
        // next, estimate the reduced-form alpha
        // alpha does not contain the params on `resids'
        // also get lambda
	`vv' ///
        qui probit `lhs' `inst' `exog' `resids' `wgt' if `touse', `doopt'
        tempname b alpha lambda
        mat `b' = e(b)
        mat `alpha' = J(1, `totexog_ct'+1, 0)
        mat `alpha'[1, 1] = `b'[1, 1..`totexog_ct']
        mat `alpha'[1, `totexog_ct'+1] = `b'[1, `totexog_ct'+`end1_ct'+1]
        mat `lambda' = `b'[1, `totexog_ct'+1..`totexog_ct'+`end1_ct']

        // build up the omega matrix
        tempname omega var
        mat `var' = e(V)
        mat `omega' = J(`totexog_ct'+1, `totexog_ct'+1, 0)
        // first term is j_aa inverse, which is cov matrix
        // from reduced-form probit
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
        foreach var of local end1 {
        	qui replace `ylb' = `ylb' + `var'*(`lambda'[1,`i'] - ///
			`b2s'[1, `i']) if `touse'
                local i = `i' + 1
        }
	`vv' ///
	qui _regress `ylb' `inst' `exog' `wgt' if `touse'

        tempname v
        mat `v' = e(V)
        mat `omega' = `omega' + `v'
        tempname omegai
        mat `omegai' = syminv(`omega')
		
        // newey answer
        tempname finalb finalv
        mat `finalv' = syminv(`dpi'' * `omegai' * `dpi')
        mat `finalb' = `finalv' * `dpi'' * `omegai' * `alpha''
        mat `finalb' = `finalb''
                
       	// do this here before we restripe e(b)
       	// for count of completely determined outcomes
        loc names `end1' `exog' _cons
	`vv' ///
         mat colnames `finalb' = `names'
	 mat score double `xb' = `finalb' if e(sample)

	// fill in orig names for end1, exog and inst - timeseries ops.
	foreach x in end1 exog inst {
		local new`x' ``x''
		foreach y of local `x' {
			local j : list posof "`y'" in `x'
			local y2 : word `j' of ``x'name'
			local new`x' : subinstr local new`x' "`y'" "`y2'"
		}
		local `x' `new`x''
	}
        loc names `end1' `exog' _cons
	`vv' ///
        mat colnames `finalb' = `names'
	`vv' ///
        mat colnames `finalv' = `names'
	`vv' ///
        mat rownames `finalv' = `names'
        qui summ `touse' `wgt' , meanonly
        local capn = r(sum)
	if `version' < 11 {
		local lhsname : subinstr local lhs "." "_"
	}
	else {
		local lhsname : copy local lhs
	}
        eret post `finalb' `finalv' `wgt', depname(`lhsname') o(`capn') ///
		esample(`touse') buildfvinfo
        eret scalar chi2_exog = `chi2exog'
        eret scalar df_exog = `chi2exdf'
        eret scalar p_exog = chiprob(`chi2exdf', `chi2exog')
        qui test `end1' `exog'
        eret scalar chi2 = r(chi2)
        eret scalar df_m = r(df)
        eret scalar p = chiprob(r(df), r(chi2))
	eret local method "twostep"
	eret local instd `end1'
	local insts `exog' `inst'
	eret local insts "`:list retok insts'"

	local depvar `lhs' `end1'
	local depvar : list retokenize depvar
	eret local depvar `depvar'

	eret local vce "`vce'"
	_post_vce_rank
end

program define MLE14, eclass
	version 14.0
	syntax, lhs(string) end1(string) touse(varname) cnt(numlist)     ///
		xb(name) vv(string) end1name(passthru) [ exog(string)    ///
		inst(string) exogname(passthru) instname(passthru) ///
		NOLOg LOg ///
		mlopts(string) wtype(string) wvar(varname) from(string)  ///
		cluster(passthru) scores(string) doopt moptobj(passthru) ]

	local exog_ct : word 1 of `cnt'
	local end1_ct : word 2 of `cnt'
	local inst_ct : word 3 of `cnt'

	local noi "noi"

	local mllog `log' `nolog'
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" != "" {
		local noi ""
	}
	if "`wtype'" != "" {
		local wgt [`wtype'=`wvar']
	}
	local lhsname `lhs'
	if `vv' < 11 {
		local lhsstr : subinstr local lhsname "." "_"
	}
	else {
		local lhsstr : copy local lhs
	}
	local vv version `vv':

	tempname b0 V0
	if "`from'" == "" {
		// Starting values
		tempname bfrom cholV
		qui `noi' di as text _n "Fitting exogenous probit model"
		`vv' ///
		cap `noi' probit `lhs' `end1' `exog' `wgt' if `touse', ///
			nocoef `doopt' `mllog'
		if _rc {
			di as error "could not find initial values"
			exit 498
		}
		local probcoef_ct `=`end1_ct' + `exog_ct' + 1'
		mat `b0' = e(b)
		if colsof(`b0') != `probcoef_ct' {
			di as txt "regressor dropped by "        ///
			 "{cmd:probit}; using 2SLS for initial " ///
			 "values instead"
			cap ivregress 2sls `lhs' `exog' (`end1' = `inst') ///
				`wgt' if `touse'
			local myrc `=_rc'
			mat `b0' = e(b)
			if `myrc' | (colsof(`b0') != `probcoef_ct') {
				di as err "could not find initial values"
				exit 498
			}
		}
		`vv' ///
		cap sureg (`end1' = `exog' `inst')
		if _rc {
			di as error "could not find initial values"
			exit 498
		}
		mat `V0' = e(Sigma)
		cap mat `cholV' = cholesky(`V0')
		if _rc {
                        di as error "could not find initial values"
			exit 498
		}
		loc nchol = `end1_ct'*(`end1_ct' + 1) / 2
		mat `V0' = J(1, `nchol', 0)
		loc m = 1
		forv i = 1/`end1_ct' {
			forv j = `i'/`end1_ct' {
				mat `V0'[1, `m'] = `cholV'[`i',`j']
				loc m = `m' + 1
			}
		}
		if `end1_ct' == 1 {
			mat `bfrom' = `b0', e(b), 0, ln(`V0'[1,1])
		}
		else {
			mat `bfrom' = `b0', e(b), J(1,`end1_ct', 0), `V0'
		}
		local init "`bfrom', copy"
	}
	else {
		local init "`from'"
	}
	loc iveqns ""    // Holds IV equations
	loc covterms ""  // Holds like /s21 /s31 /s32 for cov mat
	loc testcmd ""   // To give to -test- for exog. test
	loc i = 1
	foreach var of varlist `end1' {
		loc iveqns "`iveqns' (`var' : `var' = `exog' `inst')"
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
	}
	else {  // Fix things up for the one endog var model
		loc covterms "/athrho /lnsigma "
		loc testcmd "[athrho]_b[_cons]"
		loc dip diparm(athrho, tanh label("rho"))	///
			diparm(lnsigma, exp label("sigma"))
	}
	if `"`scores'"' != "" {
		local kscores : list sizeof scores
		forvalues i=1/`kscores' {
			tempvar s`i'

			local slist `slist' `s`i''
		}
		local sopt score(`slist')
	}
			
	qui `noi' di as text _n "Fitting full model"
	// sort so that we can get the cov terms from the
	// last obs. in dataset in lf
	tempvar currsort
	gen `c(obs_t)' `currsort' = _n
	sort `touse' `currsort'
	glo IV_NEND = `end1_ct'
	if `end1_ct' == 1 {
		`vv' ///
		ml model lf ivprob_1_lf				///
			(`lhsstr' : `lhs' = `end1' `exog')	///
			`iveqns' `covterms'			///
			`wgt' if `touse' ,			///
			title(Probit model with endogenous regressors) ///
			maximize `mlopts' `robust' `cluster' 	///
			search(off) init(`init') `mllog'		///
			`sopt' collinear `dip' `moptobj'
	}
	else {                 
		tempname fcons

		scalar `fcons' = $IV_NEND*ln(2*_pi)/2                   
		global IV_CONST `fcons'

		`vv' ///
		ml model lf ivprob_lf				///
			(`lhsstr' : `lhs' = `end1' `exog')	///
			`iveqns' `covterms'			///
			`wgt' if `touse',			///
			title(Probit model with endogenous regressors) ///
			maximize `mlopts' `robust' `cluster'    ///
			search(off) init(`init') `mllog'		///
			`sopt' collinear `moptobj'
		macro drop IV_CONST
	}
	qui test `testcmd'
	eret scalar chi2_exog = r(chi2)
	eret scalar endog_ct = `end1_ct'
	eret scalar p_exog = chiprob(e(endog_ct), e(chi2_exog))
	eret local method "ml"
	if e(endog_ct) == 1 {
		eret hidden scalar k_eq_skip = e(endog_ct)
		eret scalar k_aux = e(k_eq) - e(k_eq_skip) - 1
	}
	else {
		eret hidden scalar k_eq_skip = e(k_eq) - 1
	}
	if "`scores'" != "" {
		/* only version < 14.1					*/
		tokenize `scores'
		local i = 1
		while "``i''" != "" {
			rename `s`i'' ``i''
			local i = `i' + 1
		}
		eret local scorevars `svlist'
	}
	// Do this here before we restripe e(b)
	// For count of completely determined outcomes
	tempname outb
	mat `outb' = e(b)
        mat score double `xb' = `outb' if e(sample)

	// rename b and V -- time-series operators
	mat `b0' = e(b)
	mat `V0' = e(V)
	local names : colfullnames `b0'
	ReStripe, names(`names') end1(`end1') exog(`exog') inst(`inst') ///
		`end1name' `exogname' `instname'
	local names `"`s(names)'"'
	`vv' ///
	mat colnames `b0' = `names'
	`vv' ///
	mat colnames `V0' = `names'
	`vv' ///
	mat rownames `V0' = `names'
	_ms_op_info `b0'
	if r(tsops) {
		quietly tsset, noquery
	}
	eret repost b = `b0' V = `V0' `wgt', rename buildfvinfo
	eret local depvar "`lhsname' `end1'"
	eret local instd `end1'
	local insts `exog' `inst'
	eret local insts "`:list retok insts'"
	// Return Sigma matrix
	tempname sigma
	mat `sigma' = I(`end1_ct'+1)
	if `end1_ct' == 1 {
		mat `sigma'[2,2] = exp(2*[lnsigma]_b[_cons])
		mat `sigma'[2,1] = tanh([athrho]_b[_cons])* ///
					   exp([lnsigma]_b[_cons])
		mat `sigma'[1,2] = `sigma'[2,1]
	}
	else {
		loc endp1 = `end1_ct' + 1
		forvalues j = 1/`endp1' {
			forvalues i = `j'/`endp1' {
				if `i'==1 & `j'==1 {
					mat `sigma'[`i',`j'] = 1
				}
				else {
					mat `sigma'[`i',`j'] = ///
						[s`i'`j']_b[_cons]
				}
			}
		}
		mat `sigma' = `sigma'*`sigma''
	}
		
	eret matrix Sigma = `sigma'
	qui test [#1]
	eret scalar chi2 = r(chi2)
	eret scalar df_m = r(df)
	eret scalar p = r(p)
end

program define MLE, eclass
	local vv : display "version " _caller() ":"
	version 14.1
	syntax, lhs(string) end1(string) touse(varname) cnt(numlist)      ///
		xb(name) [ exog(string) inst(string) ///
		NOLOg LOg mlopts(string) ///
		debug wtype(string) wvar(varname) from(passthru)          ///
		constraints(passthru) vcetype(string) cluster(varname)    ///
		inititerate(passthru) verbose moptobj(string) ]

	local exog_ct : word 1 of `cnt'
	local end1_ct : word 2 of `cnt'
	local inst_ct : word 3 of `cnt'

	forvalues i=1/`end1_ct' {
		tempvar r`i'
		local resid `resid' `r`i''
	}
	tempname b kautocns
	if "`from'" != "" {
		`vv' ///
		ivgetfrom, `from' depvar(`lhs') exvars(`exog') ///
			envars(`end1') ivvars(`inst') probit
		mat `b' = r(b)
		if "`verbose'" != "" {
			mat li `b', title("from()")
		}
	}
	else {
		`vv' ///
		ivfprobit_twostep, depvar(`lhs') envars(`end1')             ///
			exvars(`exog') ivvars(`inst') binary touse(`touse') ///
			resid(`resid') wtype(`wtype') wvar(`wvar')          ///
			`verbose' `inititerate' `log' `nolog' notest
		mat `b' = r(b)
	}

	if "`constraints'" != "" {
		tempname C
		local k = `kiv'+1
		ApplyConstraints, b(`b') `constraints'
	
		mat `C' = e(C)
		scalar `kautocns' = e(k_autoCns)
	}
	else {
		scalar `kautocns' = 0
	}
	_parse_iterlog, `log' `nolog'
	local log "`s(nolog)'"
	if "`log'" == "" {
		di 
		if "`from'" == "" {
			di as txt "Fitting full model" _n
		}
	}
	mata: ivfprobit_mopt("`b'","`lhs'",`end1_ct',"`touse'","`wtype'",  ///
			"`wvar'","`vcetype'","`cluster'","","`C'","`log'", ///
			`"`mlopts'"',1,("`debug'"!=""))

	mat `b' = e(b)
	/* posts e(Sigma), diparms, endog_ct, k_aux, and 		*/
	/*  chi2 test for exogeneity					*/
	`vv' ///
	ivpostsigma, probit b(`b') vars(`lhs' `end1')

        mat score double `xb' = `b' if e(sample)

	qui test [#1]
	eret scalar chi2 = r(chi2)
	eret scalar df_m = r(df)
	eret scalar p = r(p)

	ereturn scalar k_eq_model = 1
	ereturn hidden scalar k_autoCns = `kautocns'

	ereturn local insts `exog' `inst'
	ereturn local instd `end1'
	ereturn local depvar "`lhs' `end1'"
	ereturn local title "Probit model with endogenous regressors"
	ereturn local method ml
end

program define ApplyConstraints, eclass
	syntax, b(name) constraints(numlist)

	tempname V T a C b0 Ta acns

	local vars : colnames `b'
	local eqs : coleq `b'

	mat `b0' = `b'
	mat `V' = `b''*`b'

	ereturn post `b0' `V'

	makecns `constraints'
	scalar `acns' = r(k_autoCns)
	matcproc `T' `a' `C'

	local stripe : colfullnames `b'

	mat `b' = `b'*`T'
	mat `b' = `b'*`T'' + `a'

	mat colnames `b' = `stripe'

	ereturn mat C  = `C'
	ereturn scalar k_autoCns = `acns'
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

program ReStripe, sclass
	syntax, names(string) end1(string) end1name(string) [ exog(string) ///
		inst(string) end1name(string) exogname(string) instname(string)]
	
	// Need to do end1 separately, because if an eqn name,
	// must replace . with _
	local newend1 `end1'
	foreach y of local end1 {
		local j : list posof "`y'" in end1
		local y2 : word `j' of `end1'
		local newend1 : subinstr local newend1 "`y'" "`y2'"
		local y2s : subinstr local y2 "." "_"
		local names : subinstr local names ":`y'" ":`y2'", all
		local names : subinstr local names "`y':" "`y2s':", all
	}
	local end1 `newend1'
	foreach x in exog inst {
		local new`x' ``x''
		foreach y of local `x' {
			local j : list posof "`y'" in `x'
			local y2 : word `j' of ``x'name'
			local new`x' : subinstr local new`x' "`y'" "`y2'"
			local names : subinstr local names "`y'" "`y2'", all
		}
		local `x' `new`x''
	}
	sreturn local names `"`names'"'
end

exit
