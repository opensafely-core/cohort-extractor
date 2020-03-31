*! version 1.0.2  22dec2015
program sbsingle
	version 14.0

	tempname b LastEstimates
	tempvar  touse

/**get regressorlist from previous regression**/
	mat `b' = e(b)
	local varlist : colnames `b'
	local nvar : word count `varlist'
	local varlist : subinstr local varlist "_cons" "", word 	/*
		*/ count(local hascons)
	if (!`hascons') local cons "noconstant"

	qui gen byte `touse' = e(sample)

/**get time variables**/
        _ts timevar panelvar if `touse', sort onepanel
	local fmt : format `timevar'
	markout `touse' `timevar'

	qui tsreport if `touse', `detail'
	local gaps `r(N_gaps)'
	if (`gaps'!=0) {
		di as err "{p 0 8 2} gaps not allowed{p_end}"
		exit 198
	}


	tempname LastEstimates ModelEstimates
	_estimates hold `LastEstimates', copy restore
	estimates store `ModelEstimates'	

	local modelvars `varlist'

	syntax [, breakvars(string) swald awald ewald slr alr    	    ///
			elr all trim(numlist int min=0 max=1 >0 <=49) 	    ///
			ltrim(numlist int min=0 max=1 >0 <=99)		    ///
			rtrim(numlist int min=0 max=1 >0 <=99) nodots	    ///
			GENerate(namelist max=2) ]
	sbtest_unknown `modelvars', breakvars(`breakvars') `swald' 	    ///
			`awald' `ewald' `slr' `alr' `elr' `all'	    	    ///
			trim(`trim') ltrim(`ltrim') rtrim(`rtrim')  	    ///
			mcons(`cons') touse(`touse') 	    		    ///
			model_est(`ModelEstimates') tform(`fmt') `dots'	    ///
			gen(`generate') timevar(`timevar')

end


program sbtest_unknown, rclass
	syntax [anything] [, breakvars(string) swald awald ewald slr alr    ///
				elr all trim(numlist) ltrim(numlist) 	    ///
				rtrim(numlist) mcons(string) touse(string)  ///
				model_est(string) tform(string) nodots	    ///
				gen(string) timevar(string) ]

	local varlist `anything'
	if ("`mcons'"!="") 	local allvars `varlist'
	else 			local allvars `varlist' _cons
	if ("`breakvars'"!="") {
		_sbchkvars `varlist', breakvars(`breakvars') mcons(`mcons')
		if ("`s(breakcons)'"!="") local breakcons `s(breakcons)'
		if ("`s(breakvars)'"!="") tsunab tmpbvars: `s(breakvars)'
		else local tmpbvars `s(breakvars)'
		if ("`varlist'"!="")	tsunab varlist : `varlist'
		else local varlist `varlist'
		local nonbrkvars : list varlist - tmpbvars
		if ("`tmpbvars'"!="") local brkvars `tmpbvars'
		if ("`e(cmd)'"=="ivregress" & "`nonbrkvars'"=="" & 	    ///
							"`breakcons'"=="") {
			local nonbrkvars breakcons
		}
	}
	else if ("`breakvars'"=="") {
		local brkvars `varlist'
		if ("`mcons'"=="")	local breakcons constant
	}

/**Check trim option**/
	cap opts_exclusive "`trim' `ltrim'"
	if _rc {
		di as err "{p}option {bf:trim()} may not be combined with"
	        di as err "{bf:ltrim()}{p_end}"
		exit 198
	}
	cap opts_exclusive "`trim' `rtrim'"
	if _rc {
		di as err "{p}option {bf:trim()} may not be combined with"
	        di as err "{bf:rtrim()}{p_end}"
		exit 198
	}
	qui count if `touse'
	local nobs = `r(N)'


	if ("`trim'"=="")	local trim 15
	local pi0 `trim'/100
	if ("`ltrim'"=="" & "`rtrim'"=="") {
		local ltrim = ceil((`trim'/100)*`nobs')
		local rtrim = `nobs' - `ltrim' 
	}
	else if ("`ltrim'"=="" & "`rtrim'"!="" | 			    ///
					"`ltrim'"!="" & "`rtrim'"=="") {
		di as err "{p}{bf:ltrim()} and {bf:rtrim()} must be specified "
		di as err "simultaneously{p_end}"
		exit 198
	}
	else {
		if (`ltrim'==50 & `rtrim'==50) {
			di as err "{p} option {bf:ltrim()} and {bf:rtrim()}"
			di as err "may not be equal to {bf:50}{p_end}"
			exit 198
		}
		local lb = 100-`ltrim'
		if ("`lb'"<="`rtrim'") {
			di as err "{p}{bf:rtrim()} must be less than "
			di as err "1-{bf:ltrim()}{p_end}"
			exit 198
		}
		local lambda0 = ((100-`rtrim')*(100-`ltrim'))/(`ltrim'*(100 ///
					-(100-`rtrim')))
		local pi0 = 1/(1+sqrt(`lambda0'))
		local ltrim = ceil(`nobs'*(`ltrim'/100))+1
		local rtrim = ceil(`nobs'*((100-`rtrim')/100))+1
	}

	qui estimates restore `model_est'
	local bparams: list sizeof breakvars
	local nbparams = `e(rank)'-`bparams'
	local nparams = `bparams'*2 + `nbparams'

	tempvar __N
	qui gen `c(obs_t)' `__N' = _n
	qui sum `__N' if `touse'
	local mindate = `r(min)'
	local maxdate = `r(max)'
	local sdate = `mindate' + `ltrim'
	local edate = `mindate' + `rtrim'
	if (`sdate'<`mindate' | `edate'>`maxdate') {
		 di as err "{p}break date must be in the original sample{p_end}"
		 exit 198
	}

	local lminobs = `sdate'-`mindate'
	local rminobs = `maxdate'-`edate'
	if (`lminobs'<`nparams' | `rminobs'<`nparams') {
		di as err "{p}insufficient observations at the "
		di as err "specified trim level{p_end}"
		exit 198
	}
	local nbreaks = `edate'-`sdate'+1


/**Check test options**/
	opts_exclusive "`swald' `all'"
	opts_exclusive "`awald' `all'"
	opts_exclusive "`ewald' `all'"
	opts_exclusive "`slr' `all'"
	opts_exclusive "`alr' `all'"
	opts_exclusive "`elr' `all'"

	local testtype `swald' `awald' `ewald' `slr' `alr' `elr' `all'
	if ("`testtype'"=="")	local testtype swald
	if ("`testtype'"=="all") {
		if ("`e(cmd)'"=="regress") local testtype swald awald ewald slr alr elr
		else if ("`e(cmd)'"=="ivregress") local testtype swald awald ewald
	}
	foreach ttype of local testtype {
		if (strmatch("`ttype'","?wald"))	local wtest wald
		else if (strmatch("`ttype'","?lr"))	local ltest lr 
	}

	local test `wtest' `ltest'
	if ("`test'"=="") local test wald lr

	tempvar waldsupvals waldavgvals waldexpvals waldmaxval
	tempvar lrsupvals lravgvals lrexpvals lrmaxval
	foreach ttype of local test {
		qui gen ``ttype'supvals' = .
		local ttypesup `ttypesup' ``ttype'supvals'
	}

/**Check generate option**/
	if ("`gen'"!="")	confirm new var `gen'
	if (wordcount("`test'")<wordcount("`gen'")) {
		di as err "{p} you may only specify two variable names"
		di as err "in option {bf:generate()} when both Wald and LR are"
	       	di as err "specified{p_end}"
		exit 198
	}

/**Begin Chow test**/
	qui estimates restore `model_est'
	local vcetype    `e(vce)'
	local estcmd    "`e(cmd)'"
	local depvar    "`e(depvar)'"
	tempvar rsum
	gen `rsum' = sum(`touse')
	qui count if `rsum'==0
	local fobs `r(N)'

	if (e(cmd)=="regress") {
		local ll_R       `e(ll)'
		mata: sbs_est(`sdate',`edate', `fobs', `ll_R', "`depvar'",  ///
		"`brkvars'", "`nonbrkvars'", "`test'", "`mcons'",           ///
		"`breakcons'", "`touse'", "`estcmd'", "`dots'","`timevar'", ///
		"`vcetype'")
	}
	else if (e(cmd)=="ivregress") {
		if ("`ltest'"!="") {
			di as err "{p}LR-type test may not be specified with"
			di as err "{bf:ivregress}{p_end}"
			exit 198
		}

		local instd `e(instd)'
		local insts `e(insts)'
		local exogr `e(exogr)'
		local small `e(small)'

		local rvars:    list insts - exogr
		local brkinstd: list brkvars & instd
		local brkexog:  list brkvars - brkinstd
		mata: sbs_est_iv(`sdate',`edate', `fobs', "`depvar'",       ///
			"`brkvars'", "`nonbrkvars'", "`test'", "`mcons'",   ///
			"`breakcons'", "`touse'", "`estcmd'", "`dots'",	    ///
			"`timevar'", "`vcetype'","`instd'","`exogr'",	    ///
			"`rvars'","`brkinstd'","`brkexog'","`small'")
	}

	local df `r(df)'
/**End Chow test**/

	if ("`gen'"!="") {
		confirm new var `gen'
		if (wordcount("`test'")==wordcount("`gen'")) {
			tokenize `gen'
			args g1 g2
			if ("`test'"=="wald") {
				qui gen `g1' = `waldsupvals'
				label var `g1' "Wald test statistics"
			}
			else if ("`test'"=="lr") {
				qui gen `g1' = `lrsupvals'
				label var `g1' "LR test statistics"
			}
			else {
				qui gen `g1' = `waldsupvals'
				label var `g1' "Wald test statistics"
				qui gen `g2' = `lrsupvals'
				label var `g2' "LR test statistics"
			}
		}
		else {
			qui gen `gen' = `waldsupvals'
			label var `gen' "Wald test statistics"
		}
	}

	if ("`dots'"=="") if (mod(`cnt',50)!=0) di
	foreach ttype of local testtype {
		if ("`ttype'"=="swald") {
			qui sum `waldsupvals'
			local teststat_swald  = `r(max)'
			mata: pvalsup(`teststat_swald',`df',`pi0')
			local pval_swald `r(p)'
		}
		else if ("`ttype'"=="awald") {
			qui egen `waldavgvals' = total(`waldsupvals')
			qui sum `waldavgvals'
			local teststat_awald = ((1/(`edate'-`sdate'+1))*r(mean))
			mata: pvalavg(`teststat_awald',`df',`pi0')
			local pval_awald `r(p)'
		}
		else if ("`ttype'"=="ewald") {
			qui egen `waldexpvals' = total(exp(0.5*`waldsupvals'))
			qui sum `waldexpvals'
			local teststat_ewald = ln((1/(`edate'-`sdate'+1))*  ///
						r(mean))
			mata: pvalexp(`teststat_ewald',`df',`pi0')
			local pval_ewald `r(p)'
		}
		else if ("`ttype'"=="slr") {
			qui sum `lrsupvals'
			local teststat_slr  = `r(max)'
			mata: pvalsup(`teststat_slr',`df',`pi0')
			local pval_slr `r(p)'
		}
		else if ("`ttype'"=="alr") {
			egen `lravgvals' = total(`lrsupvals')
			qui sum `lravgvals'
			local teststat_alr = ((1/(`edate'-`sdate'+1))*r(mean))
			mata: pvalavg(`teststat_alr',`df',`pi0')
			local pval_alr `r(p)'
		}
		else if ("`ttype'"=="elr") {
			egen `lrexpvals' = total(exp(0.5*`lrsupvals'))
			qui sum `lrexpvals'
			local teststat_elr = ln((1/(`edate'-`sdate'+1))*r(mean))
			mata: pvalexp(`teststat_elr',`df',`pi0')
			local pval_elr `r(p)'
		}
	}

	if (wordcount("`testtype'")==1) {
		tempvar __N
		qui gen `__N' = _n if `touse'
		if ("`testtype'"=="swald") {
			egen `waldmaxval' = max(`waldsupvals')
			qui sum `waldmaxval'
			qui levelsof `__N' if reldif(`waldsupvals',	    ///
				`r(mean)')<1e-8, local(waldmval)
			local estbreak : di `timevar'[`waldmval']
		}
		else if ("`testtype'"=="slr") {
			egen `lrmaxval' = max(`lrsupvals')
			qui sum `lrmaxval'
			qui levelsof `__N' if reldif(`lrsupvals', 	    ///
				`r(mean)')<1e-8, local(lrmval)
			local estbreak : di `timevar'[`lrmval']
		}
	}


/**Output**/
	_ts timevar panelvar if `touse', sort onepanel
	qui tsset
	if ("`r(unit1)'"=="." | "`r(unit1)'"=="g") {
		local start_trim = `sdate'
		local end_trim   = `edate'
		local beg_samp   = `mindate'
		local end_samp   = `maxdate'
	}
	else {
		qui levelsof `timevar' if _n==`mindate', local(beg_samp)
		qui levelsof `timevar' if _n==`maxdate', local(end_samp)
		qui levelsof `timevar' if _n==`sdate', local(start_trim)
		qui levelsof `timevar' if _n==`edate', local(end_trim)
		local start_trim : di `tform' `start_trim'
		local end_trim   : di `tform' `end_trim'
		local beg_samp   : di `tform' `beg_samp'
		local end_samp   : di `tform' `end_samp'
		local estbreak   : di `tform' `estbreak'
	}

	local spacelen = 30 + length(`"`start_trim'"')
	di as txt _n "Test for a structural break: Unknown break date"
	di as txt _n "{col 30}Number of obs = " as res %10.0fc e(N) _n
	di as txt  "Full sample:" _col(30) as res "`beg_samp'" 		    ///
		_col(`spacelen') " - `end_samp'"
	di as txt  "Trimmed sample:" _col(30) as res "`start_trim' - `end_trim'"

	if ("`estbreak'"!="") {
		di as txt "Estimated break date: " _col(30) as res "`estbreak'"
		return local breakdate = "`estbreak'"
	}
	di as txt "Ho: No structural break" _newline
	tempname tabobj
	.`tabobj' = ._tab.new, col(3) lmargin(0)
	.`tabobj'.width 15 15 17
	.`tabobj'.titlefmt %9s %15s %17s
	.`tabobj'.pad . . .
	.`tabobj'.numfmt . %10.04f %10.04f
	.`tabobj'.strcolor result  .  .
	.`tabobj'.strfmt     %10s  .  .  
	.`tabobj'.strcolor   text  .  .  
	.`tabobj'.titles "Test"               	///
			"Statistic"       	/// 
			"p-value"      
	.`tabobj'.sep
	foreach ttype of local testtype {
		local dispteststat : di %10.04f `teststat_`ttype''
		local disppval: di %10.04f `pval_`ttype''
		.`tabobj'.row	"`ttype'" "`dispteststat'" "`disppval'" 
		return scalar chi2 = `teststat_`ttype''
		return scalar p = `pval_`ttype''
		return local test = "`ttype'"
	}
	.`tabobj'.sep, bot
	if ("`breakcons'"!="") local bcons _cons
	if ("`varlist'"!="") {
		if ("`e(cmd)'"=="regress") di in smcl "{p 0 35 0}{txt}Exogenous variables: {space 10}`varlist'{p_end}"
		di in smcl "{p 0 35 0}{txt}Coefficients included in test: `brkvars' `bcons'{p_end}"
	}
        else di as txt "Coefficients included in test: `bcons'"


/**Return result**/
	return scalar df = `df'
	return local breakvars = "`varlist' `bcons'"
	return local ltrim = "`start_trim'"
	return local rtrim = "`end_trim'"

end
