*! version 4.0.0  30apr2019
program define pkequiv, rclass sortpreserve
	version 14, missing
	syntax varlist(numeric min=5 max=5) ///
	       [if]                         ///
	       [in]                         ///
	       [,                           ///
	         COMpare(string)            ///
		 LImit(real 0.20)           ///
		 LEvel(passthru)            /// as percent (like cilevel)
		 FIEller                    ///
		 SYMmetric                  ///
		 ANDERson                   ///
		 TOST                       ///
		 noBoot                     ///
		 Reps(integer 1000)         /// undocumented
		 SCHUTZ                     /// undocumented log-scale analysis
	       ]

	************************************************************************
	* Parse and check for syntax errors
	************************************************************************
	// To validate against Schutz's results
	local log = cond("`schutz'"=="", "", "log")

	// Parse varlist
	local vdups : list dups varlist
	if "`vdups'" != "" {
		local vrs = plural(`: word count `vdups'', "variable")
		di as err "`vrs' {bf:`vdups'} may only appear once"
		exit 198
	}
	tokenize `varlist'
	local outcome  "`1'"
	local treat    "`2'"
	local period   "`3'"
	local seq      "`4'"
	local id       "`5'"

	// Confirm -limit()- and -level()- are within appropriate ranges
	if `limit' < .01 | `limit' > .99 {
		di as err "{bf:limit()} must be between 0.01 and 0.99 inclusive"
		exit 198
	}
	if "`level'" == "" {
		local level 90
	}
	else {
		local zero `0'
		local 0 ", `level'"
		syntax [, level(cilevel)]
		local 0 `zero'
	}
	// Convert percent `level' into proportion between 0 and 1
	local lvl = `level' / 100

	// -fieller-, -symmetric-, and -log- are exclusive
	opts_exclusive "`fieller' `symmetric' `log'"

	************************************************************************
	* Identify which two treatments to compare
	************************************************************************
	// Run marksample. Unused treatments will be marked out separately below
	marksample touse
	qui count if `touse'
	if r(N)==0 {
		error 2000
	}

	// If -compare()- not specified, verify there are 2 treatments
	if `"`compare'"' == "" {
		tempname trtlev
		qui tabulate `treat' if `touse', matrow(`trtlev')
		if r(r) < 2 {
			di as err "only one value of treatment variable "    ///
				  "{bf:`treat'} found"
			di as err "{p 4 4 2}"                                ///
				  "Crossover designs must have more than "   ///
				  "one treatment."                           ///
				  "{p_end}"
			exit 459
		}
		else if r(r) > 2 {
			di as err "`=r(r)' values of treatment variable "    ///
				  "{bf:`treat'} found"
			di as err "{p 4 4 2}"                                ///
				  "Use option {bf:compare({it:# #})} to "    ///
				  "select two treatments for comparison."    ///
				  "{p_end}"
			exit 198
		}
		// If two treatments, set lowest as reference (`c1')
		else {
			local c1 = `trtlev'[1,1]
			local c2 = `trtlev'[2,1]
		}
	}
	// Otherwise verify both treatments in -compare()- are valid
	else {
		if `: word count `compare'' != 2  {
			di as err "option {bf:compare({it:# #})} must "      ///
				  "specify two numeric treatment codes"
			exit 198
		}
		local c1 : word 1 of `compare'
		cap confirm number `c1'
		if _rc {
			di as err "option {bf:compare({it:# #})} must "      ///
				  "specify two numeric treatment codes"
			exit 198
		}
		qui count if (float(`treat') == float(`c1') & `touse')
		if r(N) == 0 {
			di as err "no observations with treatment variable " ///
				  "{bf:`treat'} = {bf:`c1'}"
			exit 459
		}
		local c2 : word 2 of `compare'
		cap confirm number `c2'
		if _rc {
			di as err "option {bf:compare({it:# #})} must "      ///
				  "specify two numeric treatment codes"
			exit 198
		}
		qui count if (float(`treat') == float(`c2') & `touse')
		if r(N) == 0 {
			di as err "no observations with treatment variable " ///
				  "{bf:`treat'} = {bf:`c2'}"
			exit 459
		}
		if `c1' == `c2' {
			di as err "comparison treatments must be different"
			exit 198
		}
	}

	************************************************************************
	* Mark out unused treatments & check for invalid data
	************************************************************************
	// Mark out obs of unused treatments
	qui replace `touse'=0 if !inlist(float(`treat'),float(`c1'),float(`c2'))

	// Crossover designs must have > 1 period
	summarize `period' if `touse', meanonly
	if r(min) == r(max) {
		di as err "only one value of period variable {bf:`period'} " ///
			  "found"
		di as err "{p 4 4 2}"                                        ///
			  "Crossover designs must have more than one "       ///
			  "period."                                          ///
			  "{p_end}"
		exit 459
	}

	// Higher-order crossover designs are not supported
	tempvar replica
	qui bysort `id' (`treat' `touse') : gen `replica' =                  ///
		(`treat'[_n]==`treat'[_n-1] & `touse' & `touse'[_n-1])
	qui bysort `id' (`period' `touse') : replace `replica' = 1 if        ///
		(`period'[_n]==`period'[_n-1] & `touse' & `touse'[_n-1])
	qui count if `replica'
	if r(N)!=0 {
		di as err "replicate treatments detected"
		di as err "{p 4 4 2}"                                        ///
			  "Higher-order crossover designs are not "          ///
			  "supported."                                       ///
			  "{p_end}"
		exit 459
	}

	// Subjects in the same sequence must get treatments in the same order
	cap bysort `touse' `seq' `period': assert `treat'==`treat'[1] if `touse'
	local errcode = _rc
	cap bysort `touse' `seq' `treat':assert `period'==`period'[1] if `touse'
	local errcode = `errcode' + _rc
	if `errcode' {
		di as err "subjects in the same sequence must receive "      ///
			  "treatments in the same order"
		di as err "{p 4 4 2}"                                        ///
			  "Treatment and period variables, {bf:`treat'} "    ///
			  "and {bf:`period'}, are not consistent with "      ///
			  "respect to sequence variable {bf:`seq'}."         ///
			  "{p_end}"
		exit 459
	}
	
	************************************************************************
	* Generate new indicator variables (byte/int/long for subsequent ANOVA)
	*   newtrt: 1=reference, 2=test
	*   newper: `period' converted to sequential integers
	*   newseq: `seq' converted to sequential integers
	*   newid:  `id' converted to sequential integers
	************************************************************************
	// New treatment indicator: 1=reference, 2=test
	tempvar newtrt
	qui gen byte `newtrt' = cond(float(`treat')==float(`c1'),            ///
				     1,                                      ///
				     cond(float(`treat')==float(`c2'), 2, .) ///
				    ) if `touse'

	// Generate sequential integer versions of `period', `seq', & `id'
	tempvar newper newseq newid
	qui egen int `newper' = group(`period') if `touse'
	qui egen int `newseq' = group(`seq') if `touse'
	qui egen long `newid' = group(`id') if `touse'

	************************************************************************
	* Option -log- transforms -outcome- to enable validation against 
	* Schutz, Labes, and Fuglsang (2014) published results
	************************************************************************
	// Convert to log scale if user selects option -log-
	if "`log'" != "" {
		summarize `outcome' if `touse', meanonly
		if r(min) <= 0 {
			di as err "nonpositive values encountered"
			di as err "{p 4 4 2}"                                ///
				  "Outcome variable {bf:`outcome'} has "     ///
				  "nonpositive values and cannot be "        ///
				  "analyzed with option {bf:log}."           ///
				  "{p_end}"
			exit 411
		}
		
		// Switch to log scale. Reuse local `outcome' for log outcome
		tempvar logout
		qui gen double `logout' = log(`outcome') if `touse'
		local outcome `logout'
	}

	************************************************************************
	* Calculate CI: Classic CI first, then symmetric or Fieller if requested
	************************************************************************
	// Calculate classic CI
	classic `outcome' `newtrt' `newper' `newseq' `newid' `touse',        ///
	        lvl(`lvl') limit(`limit') reps(`reps')                       ///
	        `boot' `symmetric' `fieller' `tost' `anderson' `log'

	// Return CI and SD
	return scalar lci = r(lci)
	return scalar uci = r(uci)
	return scalar stddev = r(stddev)
	return hidden scalar diff = r(diff)
	
	// Calculate symmetric CI using some statistics from Classic CI
	if "`symmetric'" != "" {
		symmetric, lvl(`lvl') limit(`limit') se(`r(se)') df(`r(df)') ///
			   rmean(`r(rmean)') tmean(`r(tmean)')
		return scalar delta = r(delta)
	}
	
	// Calculate Fieller CI
	if "`fieller'" != "" {
		fieller `outcome' `newtrt' `newper' `newseq' `id' `touse',   ///
			lvl(`lvl') limit(`limit') rmean(`r(rmean)')          ///
			tmean(`r(tmean)') seq(`seq')
		return scalar l3 = r(l3)
		return scalar u3 = r(u3)
	}
	
	noi di _col(7) as txt "Note: Reference treatment = " as res `c1'
// end of pkequiv
end

********************************************************************************
* Classic CI
********************************************************************************
program define classic, rclass
	syntax varlist(numeric min=6 max=6) ///
	       ,                            ///
		lvl(real)                   /// as proportion in (0, 1)
		limit(real)                 ///
		reps(real)                  ///
		[                           ///
		 noBoot                     ///
		 symmetric                  ///
		 fieller                    ///
		 tost                       ///
		 anderson                   ///
		 log                        /// undocumented
		]
	
	// Parse varlist
	tokenize `varlist'
	local outcome "`1'"
	local newtrt  "`2'"
	local newper  "`3'"
	local newseq  "`4'"
	local newid   "`5'"
	local touse   "`6'"

	// Preserve the user's previous estimation results
	tempvar oldest
	_estimates hold `oldest' , restore nullok

	// -anova- to estimate treatment effect (`newid' is a fixed effect)
	qui anova `outcome' `newtrt' `newper' `newseq'                       ///
		  / `newid'|`newseq' if `touse'

	// Check that ANOVA has enough df; if not, error out
	if e(df_r) == 0 {
		di as err "insufficient observations to calculate "          ///
			  "confidence interval"
		exit 2001
	}
	if (e(df_1)==0 | e(df_2)==0 | e(df_3)==0 | e(df_4)==0) {
		di as err "unable to calculate confidence interval due to "  ///
			  "confounding"
		exit 459
	}
	
	// Extract treatment effect (diff), SE, df, & RMSE from ANOVA model
	return scalar diff = _b[2.`newtrt']
	return scalar se   = _se[2.`newtrt']
	return scalar df   = e(df_r)
	return scalar stddev = sqrt(0.5*e(rss)/e(df_r))
	
	// Calculate CI (backtransform if option -log-)
	tempname halfci
	local unlog = cond("`log'"=="", "", "exp")
	scalar `halfci' = invttail(return(df), (1-`lvl')/2) * return(se)
	if missing(`halfci') {
		di as err "unable to calculate test limits"
		exit 459
	}
	return scalar lci = `unlog'(return(diff) - `halfci')
	return scalar uci = `unlog'(return(diff) + `halfci')

	// -margins- to extract marginal means (a.k.a. least squares means) 
	// for both treatments (equal to sample means if design is balanced)
	qui margins `newtrt' , nose post
	return scalar rmean = _b[1.`newtrt']
	return scalar tmean = _b[2.`newtrt']

	// Limits for bioequivalence
	tempname llim ulim
	if "`log'"=="" {
		scalar `llim' = -`limit' * abs(return(rmean))
		scalar `ulim' =  `limit' * abs(return(rmean))
	} 
	else {
		scalar `llim' = 1 - `limit'
		scalar `ulim' = 1 + (`limit' / (1 - `limit'))
	}

	// Run bootstrap unless option noboot/symmetric/fieller or reps < 2
	local boot = cond(`reps' < 2, "noboot", "`boot'")
	if ("`boot'`symmetric'`fieller'"=="") {
		tempfile bootres
		tempvar bnewid
		cap noi qui bootstrap blci=e(blci) buci=e(buci)              ///
				      , reps(`reps') strata(`newseq')        ///
					cluster(`newid') idcluster(`bnewid') ///
					saving(`bootres')                    ///
				      : _btcmd `outcome' `newtrt' `newper'   ///
					       `newseq' `bnewid' if `touse'  ///
					       , lvl(`lvl') `log'

		if _rc {
			local errcode = cond(_rc == 460, 459, _rc)
			di as err "error during bootstrap; "                 ///
				  "try option {bf:noboot}"
			exit `errcode'
		}

		// Preserve data in memory & load bootstrap results
		preserve
		qui use "`bootres'", clear

		// Calculate coverage
		tempvar inci
		qui gen byte `inci' = ((`llim'<=blci) & (buci<=`ulim'))
		summarize `inci', meanonly
		local wilim = r(mean)
		
		// Restore dataset
		restore
	}

	// Restore user's previous estimation results
	_estimates unhold `oldest'

	// Display results if options symmetric and fieller are not specified
	if ("`symmetric'" == "" & "`fieller'" == "") {
		tempname rllim rulim rlci ruci
		// Standard (not log): report both difference & ratio
		if "`log'" == "" {
			scalar `rllim' = (1-`limit')*100
			scalar `rulim' = (1+`limit')*100
			scalar `rlci'  = (return(lci)/return(rmean)+1)*100
			scalar `ruci'  = (return(uci)/return(rmean)+1)*100
			di
			di as txt _col(7)  "Classic confidence interval "    ///
					   "for bioequivalence"
			di as txt _col(7)  "{hline 70}"
			di as txt _col(26) "[equivalence limits]"            ///
				  _col(54) "[    test limits   ]"
			di as txt _col(7)  "{hline 70}"
			di as txt _col(12) "difference:"                     ///
			   as res _col(24) %9.3f `llim'                      ///
				  _col(37) %9.3f `ulim'                      ///
				  _col(52) %9.3f return(lci)                 ///
				  _col(65) %9.3f return(uci)
			di as txt _col(17) "ratio:"                          ///
			   as res _col(23) %9.0g `rllim' "%"                 ///
				  _col(36) %9.0g `rulim' "%"                 ///
				  _col(52) %9.3f `rlci' "%"                  ///
				  _col(65) %9.3f `ruci' "%"
			di as txt _col(7)  "{hline 70}"
		}
		// log-scale: report ratio only (80%/125% rule or equiv)
		else {
			scalar `rllim' = `llim' * 100
			scalar `rulim' = `ulim' * 100
			scalar `rlci'  = return(lci) * 100
			scalar `ruci'  = return(uci) * 100
			di
			di as txt _col(7)  "Log-transformed confidence "     ///
					   "interval for bioequivalence ratio"
			di as txt _col(7)  "{hline 70}"
			di as txt _col(24) "[ equivalence limits ]"          ///
				  _col(52) "[ confidence interval ]"
			di as txt _col(7)  "{hline 70}" 
			di as txt _col(17) "ratio:"                          ///
			   as res _col(24) %9.0g `rllim' "%"                 ///
				  _col(36) %9.0g `rulim' "%"                 ///
				  _col(52) %9.3f `rlci' "%"                  ///
				  _col(64) %9.3f `ruci' "%"
			di as txt _col(7)  "{hline 70}"
			di as txt _col(47) "point estimate:"                 ///
			   as res _col(64) %9.3f exp(return(diff))*100 "%"
		}
		// Report bootstrap result
		if "`boot'" == "" {
			di as txt _col(7)  "Probability test limits are "    ///
					   "within equivalence limits = "    ///
					   as res %9.4f `wilim'
		}
		// Report two one-sided tests (Schuirmann's TOST)
		if "`tost'" != "" {
			tempname tostl tostu
			scalar `tostl' = (return(diff)-`log'(`llim'))/return(se)
			scalar `tostu' = (return(diff)-`log'(`ulim'))/return(se)
			di
			di as txt _col(7)  "Schuirmann's two one-sided tests"
			di as txt _col(7)  "{hline 70}"
			di as txt _col(7)  "upper test statistic ="          ///
			   as res _col(30) %9.3f `tostu'                     ///
			   as txt _col(58) "p-value ="                       ///
			   as res _col(68) %9.3f 1 - ttail(return(df), `tostu')
			di as txt _col(7)  "lower test statistic ="          ///
			   as res _col(30) %9.3f `tostl'                     ///
			   as txt _col(58) "p-value ="                       ///
			   as res _col(68) %9.3f ttail(return(df), `tostl')
		}
		// Report Anderson & Hauck's test
		if "`anderson'" != "" {
			tempname nonpar stat
			scalar `nonpar' = `log'(`ulim') / return(se)
			scalar `stat'   = return(diff) / return(se)
			di
			di as txt _col(7)  "Anderson and Hauck's test"
			di as txt _col(7)  "{hline 70}"
			di as txt _col(7)  "noncentrality parameter ="       ///
			   as res _col(33) %9.3f `nonpar'
			di as txt _col(16) "test statistic ="                ///
			   as res _col(33) %9.3f `stat'                      ///
			   as txt _col(48) "empirical p-value ="             ///
			   as res _col(68) %9.4f                             ///
				ttail(return(df), abs(abs(`stat')-`nonpar')) ///
				- ttail(return(df), abs(-abs(`stat')-`nonpar'))
		}			
	}
// end of classic
end

********************************************************************************
* Symmetric CI
********************************************************************************
program define symmetric, rclass
	syntax ,              ///
		lvl(real)     /// as proportion in (0, 1)
		limit(real)   ///
		se(real)      ///
		df(real)      ///
		rmean(real)   ///
		tmean(real)
	
	// Starting values for CI
	tempname k myp inc
	scalar `k' = (`rmean' - `tmean') / `se'
	scalar `myp' = 0
	scalar `inc' = 0
	
	// Iteratively widen CI until it is a 100*`lvl'% CI
	while `myp' <= `lvl' {
		scalar `inc' = `inc' + 0.001
		scalar `myp' = t(`df', `k'+`inc') - t(`df', `k'-`inc')
	}
	return scalar delta = ((`k'+`inc') * `se') - (`rmean' - `tmean') 
	local llim = `rmean' * (-`limit')
	local ulim = `rmean' * (`limit')

	// Print results
	di
	di as txt _col(7)  "Westlake's symmetric confidence interval "       ///
			   "for bioequivalence"
	di as txt _col(7)  "{hline 70}"
	di as txt _col(24) "[ equivalence limits ]"                          ///
		  _col(52) "[ confidence interval ]"
	di as txt _col(7)  "{hline 70}" 
	di as txt _col(12) "difference:"                                     ///
	   as res _col(24) %9.3f `llim'                                      ///
		  _col(36) %9.3f `ulim'                                      ///
		  _col(52) %9.3f -return(delta)                              ///
		  _col(64) %9.3f return(delta)
	di as txt _col(7)  "{hline 70}"
// end of symmetric
end

********************************************************************************
* Fieller's CI
********************************************************************************
program define fieller, rclass
	syntax varlist(numeric min=6 max=6) ///
	       ,                            ///
		lvl(real)                   /// as proportion in (0, 1)
		limit(real)                 ///
		rmean(real)                 ///
		tmean(real)                 ///
		seq(string)
	
	// Parse varlist
	tokenize `varlist'
	local outcome "`1'"
	local newtrt  "`2'"
	local newper  "`3'"
	local newseq  "`4'"
	local id      "`5'"
	local touse   "`6'"

	// Can only calculate Fieller CI with 2 sequences
	summarize `newseq', meanonly
	// Test for min technically unnecessary b/c would have errored already
	if !(r(max)==2 & r(min)==1) {
		di as err "too many sequences"
		di as err "{p 4 4 2}"                                        ///
			  "Two sequences are required to calculate the "     ///
			  "Fieller confidence interval, but " r(max) " "     ///
			  "values of sequence variable {bf:`seq'} were "     ///
			  "found."                                           ///
			  "{p_end}"
		exit 459
	}

	// Must have both treatments from each subject to calculate Fieller CI
	tempvar onetrt
	tempname onemat
	qui bysort `touse' `id' : gen `onetrt' = `id'                        ///
	                              if (_n==1 & `id'!=`id'[_n+1] & `touse')
	qui tabulate `onetrt' if `touse', matrow(`onemat')
	if r(r) > 0 {
		// Generate custom error message identifying bad IDs
		local onelast = min(r(r), 5)
		forvalues i = 1/`onelast' {
			local oneid = "`oneid' " + strofreal(`onemat'[`i',1])
		}
		local oneid = cond(r(r)>5, "`oneid' ...", "`oneid'")
		di as err "missing data for {bf:`id'} `oneid'"
		di as err "{p 4 4 2}"                                        ///
			  "The Fieller confidence interval requires valid "  ///
			  "data for both treatments."                        ///
			  "{p_end}"
		exit 459
	}

	// Calculate omega from Chow & Liu p. 89
	tempname omega n1 n2 df
	qui count if (`newseq' == 1 & `touse')
	scalar `n1' = r(N)/2
	qui count if (`newseq' == 2 & `touse')
	scalar `n2' = r(N)/2
	scalar `omega' = (1/`n1' + 1/`n2')/4
	scalar `df' = `n1' + `n2' - 2

	// Generate treatment/sequence indicator: 1=R1, 2=T1, 3=R2, 4=T2
	tempvar grp
	qui gen `grp' = (`newtrt'==2) + 2*`newseq'- 1 if `touse'
	
	// Group-specific means & deviations
	tempvar gmean gdev gdev2 gdevRT
	qui bysort `grp': egen double `gmean'=total(`outcome'/_N) if `touse'
	qui gen double `gdev' = `outcome' - `gmean' if `touse'
	qui gen double `gdev2' = (`gdev')^2 if `touse'
	qui bysort `touse' `id' : gen double `gdevRT' = `gdev'*`gdev'[_n+1]  ///
					     if (_n==1 & `touse')

	// Pooled-sample variances of the group-specific deviations
	tempname S2RR S2TT SRT
	summarize `gdev2' if (`newtrt'==1 & `touse'), meanonly
	scalar `S2RR' = r(sum)/`df'
	summarize `gdev2' if (`newtrt'==2 & `touse'), meanonly
	scalar `S2TT' = r(sum)/`df'
	summarize `gdevRT' if `touse', meanonly
	scalar `SRT' = r(sum)/`df'

	// Check whether a solution exists to Fieller quadratic equation
	tempname t rcheck tcheck
	scalar `t' = invttail(`df', (1-`lvl')/2)
	scalar `rcheck' = `rmean' / sqrt(`omega' * `S2RR')
	scalar `tcheck' = `tmean' / sqrt(`omega' * `S2TT')
	if (`rcheck' <= `t' | `tcheck' <= `t') {
		di as err "{p 0 4 2}"                                        ///
			  "no real solution to quadratic equation for "      ///
			  "Fieller confidence interval"                      ///
			  "{p_end}"
		exit 481
	}
	
	// Solve Fieller quadratic equation (Chow & Liu p. 90)
	tempname G mratio Gratio Gstar2 LHS3 RHS3
	scalar `mratio' = `tmean'/`rmean'
	scalar `G' = (`t'/`rcheck')^2
	scalar `Gratio' = `G' * (`SRT'/`S2RR')
	scalar `Gstar2' = (`mratio')^2 + (`S2TT'/`S2RR') * (1 - `G')         ///
	                  + (`SRT'/`S2RR') * (`Gratio' - 2 * `mratio')
	scalar `LHS3' = `mratio' - `Gratio'
	scalar `RHS3' = sqrt(`G' * `Gstar2')
	return scalar l3 = 100 * (`LHS3' - `RHS3') / (1 - `G')
	return scalar u3 = 100 * (`LHS3' + `RHS3') / (1 - `G')
	local rllim = 100 * (1-`limit')
	local rulim = 100 * (1+`limit')

	// Print results
	di
	di as txt _col(7)  "Confidence interval for bioequivalence based "   ///
		           "on Fieller's theorem"
	di as txt _col(7)  "{hline 70}"
	di as txt _col(24) "[ equivalence limits ]"                          ///
		  _col(52) "[ confidence interval ]"
	di as txt _col(7)  "{hline 70}" 
	di as txt _col(17) "ratio:"                                          ///
	   as res _col(24) %9.0g `rllim' "%"                                 ///
		  _col(36) %9.0g `rulim' "%"                                 ///
		  _col(52) %9.3f return(l3) "%"                              ///
		  _col(64) %9.3f return(u3) "%"
	di as txt _col(7)  "{hline 70}"
// end of fieller
end

exit


