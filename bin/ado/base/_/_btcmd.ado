*! version 2.0.0  30apr2019
program define _btcmd, eclass
	version 14
	syntax varlist(numeric min=5 max=5) ///
	       [if]                         ///
	       ,                            ///
		lvl(real)                   /// as proportion in (0, 1)
		[LOG]
	
	// Parse varlist & marksample
	tokenize `varlist'
	local outcome "`1'"
	local newtrt  "`2'"
	local newper  "`3'"
	local newseq  "`4'"
	local bnewid  "`5'"
	marksample touse

	// -anova- to estimate treatment effect (`bnewid' is a fixed effect)
	// set coeftabresults off for speed
	tempname bdiff bse bdf
	set coeftabresults off
	quietly anova `outcome' `newtrt' `newper' `newseq'       /// 
		      / `bnewid'|`newseq' if `touse'
	scalar `bdiff' = _b[2.`newtrt']
	scalar `bse'   = _se[2.`newtrt']
	scalar `bdf'   = e(df_r)
	
	// Calculate CI (backtransform if option -log-)
	tempname bhalfci
	scalar `bhalfci' = invttail(`bdf', (1-`lvl')/2) * `bse'
	local unlog = cond("`log'"=="", "", "exp")

	// Return e(sample), uCI and lCI
	ereturn post , esample(`touse')
	ereturn scalar blci = `unlog'(`bdiff' - `bhalfci')
	ereturn scalar buci = `unlog'(`bdiff' + `bhalfci')
end
