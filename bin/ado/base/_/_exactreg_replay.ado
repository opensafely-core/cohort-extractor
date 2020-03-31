*! version 1.2.0  15jan2015
* _exactreg_replay - replay exact logistic/poisson regression

program _exactreg_replay
	version 10

	syntax [, Test(string) COEF IRR level(string)]

	if "`level'" != "" {
		tempname lev
		cap scalar `lev' = `level'
		if `lev'>=. | reldif(`lev',`e(level)')>1e-6 {
			di as err "{p}confidence intervals are computed " ///
			 "concurrently with estimation; option level() "  ///
			 "must be specified at estimation and is not "    ///
			 "allowed at replay{p_end}"
			exit 198
		}
	}
	CheckTest, `test'
	local test `s(stat)'
	local ltest `s(ltest)'
	local ptest `s(ptest)'

	local vnames: colnames e(b)
	local bnames `vnames'
	local cons _cons
	if ("`e(cmd)'"=="expoisson") {
		if ("`irr'"!="") local coef irr
		else local coef coef
	}
	else if "`irr'" != "" {
		di as err "option irr is not allowed"
		exit 198
	}

	if ("`coef'" == "") {
		/* prevent displaying nothing if _cons only model */
		local vnames1: list vnames - cons
		if ("`vnames1'"!="") local vnames `vnames1'
	}

	if "`e(n_trials)'" != "" {
		if (`e(n_trials)' < 999) local fnt = 3
		else local fnt = trunc(log10(`e(n_trials)'))+1
	}

	cap mat li e(p_scoretest_m)
	local modtest = (_rc==0)
	if (`modtest') local modtest = (colsof(e(p_scoretest_m))-e(k_terms)>0)

	local depvar = abbrev("`e(depvar)'",12) 
	local sk = 12-strlen("depvar")
	local nsk = 50
	di in gr _n "`e(title)'" _c
	if e(k_groups) > 1 {
		local ns1 = 14
		local dec = 4
		local w = 9
		local cr _n
		tempname nmax nmin navg ni
		scalar `nmax' = 0
		scalar `nmin' = c(maxlong)
		scalar `navg' = 0
		forvalues i=1/`=e(k_groups)' {
			scalar `ni' = el(e(N_g),1,`i')
			if (`ni' > `nmax') scalar `nmax' = `ni'
			if (`ni' < `nmin') scalar `nmin' = `ni'
			scalar `navg' = ((`i'-1)*`navg' + `ni')/`i'
		} 
		di in gr _col(`=`nsk'-4') "Number of obs     = " ///
		 in ye %10.0fc e(N)
		di in gr `"Group variable: `=abbrev("`e(groupvar)'",24)'"' /// 
		 _col(`=`nsk'-4') "Number of groups  = " in ye %10.0fc     ///
		 e(k_groups) _n
		if "`e(binomial)'" != "" {
			di in gr "Binomial variable: " in ye    ///
			 abbrev("`e(binomial)'",21) _c
		}
		else if "`e(n_trials)'" != ""{
			di in gr "Binomial # of trials: " in ye ///
			 %`fnt'.0f e(n_trials) _c
		}
		di in gr _col(`=`nsk'-4') "Obs per group:"
		di in gr _col(`=`nsk'+10') "min =  " ///
		 in ye %9.0fc `nmin' _n _col(`=`nsk'+10') in gr "avg =  "  ///
		 in ye %9.1fc `navg' _n _col(`=`nsk'+10') in gr "max =  "  ///
		 in ye %9.0fc `nmax' 
	}
	else {
		local ns1 = 14
		local dec = 0
		local w = 9
		if "`e(binomial)'" != "" {
			di in gr _col(`nsk') "Number of obs" ///
			 _col(`=`nsk'+14') "= " in ye %10.0fc e(N)
			di in gr "Binomial variable: " in ye ///
			 abbrev("`e(binomial)'",21) _c
		}
		else if "`e(n_trials)'" != "" {
			di in gr _col(`nsk') "Number of obs"    ///
			 _col(`=`nsk'+14') "= " in ye %10.0fc e(N)
			di in gr "Binomial # of trials: " in ye ///
			 %`fnt'.0f e(n_trials) _c
		}
		else {
			if (!`modtest') di
			di in gr _col(`nsk') "Number of obs" ///
			 _col(`=`nsk'+14') "= " in ye %10.0g e(N)
		}
	}
	local ntests = 0
	if `modtest' {
		if "`test'"=="scoretest" || "`test'"=="sufficient" {
			di in gr `cr' _col(`=`nsk'-`dec'')       ///
			 "Model score" _col(`=`nsk'+`ns1'') "=  " ///
			 in ye %`w'.0g                           ///
			 el(e(scoretest_m),1,`=e(k_terms)+1')

			di in gr _col(`=`nsk'-`dec'')            ///
			 "Pr >= score" _col(`=`nsk'+`ns1'') "=  " ///
			 in ye %`w'.4f                           ///
			 el(e(p_scoretest_m),1,`=e(k_terms)+1')
		}
		else {
			di in gr `cr' _col(`=`nsk'-`dec'')       ///
			 "Model prob." _col(`=`nsk'+`ns1'') "=  " ///
			 in ye %`w'.0g                           ///
			 el(e(probtest_m),1,`=e(k_terms)+1')

			di in gr _col(`=`nsk'-`dec'')            ///
			 "Pr <= prob." _col(`=`nsk'+`ns1'') "=  " ///
			 in ye %`w'.4f                           ///
			 el(e(p_probtest_m),1,`=e(k_terms)+1')
		}
		local `++ntests'
	}
	else if ("`e(binomial)'"!="" | "`e(n_trials)'"!="") di

	if ("`coef'"=="") local tcoef Odds Ratio
	else if ("`coef'"=="irr") local tcoef IRR
	else local tcoef Coef.

	tempname Tab
	.`Tab' = ._tab.new, col(7) lmargin(0) ignore(.b)
	// column        1      2    3      4     5      6      7
	.`Tab'.width	13    |11    2     11    13     12     12
	.`Tab'.titlefmt  .   %11s    .      .     .   %24s      .
	.`Tab'.strfmt    .   %11s   %-2s     .     .      .      .
	.`Tab'.pad       .      2    0      1     5      3      3
	.`Tab'.numfmt    .  %9.0g    .  %9.0g %6.4f  %9.0g  %9.0g
	.`Tab'.strcolor  . result    .      .     . result result

	.`Tab'.sep, top

	.`Tab'.titles `"`=abbrev("`e(depvar)'",12)'"' /// 1
		       "`tcoef'"	/// 2
		       " "		/// 3
		       "`ltest'"	/// 4
		       "`ptest'" 	/// 5 
		       `"[`e(level)'% Conf. Interval]"' "" // 6 7

	local k = 0
	tempname b pt t lb ub ci mue mue1 bi pti ti
	mat `b' = e(b)
	local nb = colsof(`b')
	mat `ci' = e(ci)
	mat `t' = e(`test')
	mat `pt' = e(p_`test')
	mat `mue' = e(mue_indicators)
	mat `mue1' = J(1,`nb',0)
	if `e(midp)' {
		forvalues i=1/`=colsof(`mue')' {
			if `mue'[1,`i'] & (`ci'[1,`i']>=.|`ci'[2,`i']>=.) {
				mat `mue1'[1,`i'] = 1
				mat `mue'[1,`i'] = 0
			}
		}
	}
	if "`e(terms)'" != "" {
		local terms `e(terms)'

		local coleq : coleq e(b), quote
		local coleq : list clean coleq

		local i = 1
		foreach trm of local terms {
			mat `t' = e(`test'_m)
			scalar `ti' = `t'[1,`++k']
			if (`ti'>=.) local dti `""""'
			else local dti `ti'

			mat `pt' = e(p_`test'_m)
			scalar `pti' = `pt'[1,`k']
			if (`pti'>=.) local dpi `""""'
			else local dpi `pti'

			local ttrm = abbrev(`"`trm'"',12)
			.`Tab'.sep
			// columns           1       2  3     4    5   6  7
			.`Tab'.strfmt    %-12s       .  .     .    .   .  .
			.`Tab'.strcolor result       .  .     .    .   .  .
			.`Tab'.row   `"`ttrm'"'     "" "" `dti' `dpi' "" ""
			.`Tab'.strfmt     %12s       .  .     .     .  .  .
			.`Tab'.strcolor   text  result  .     .     .  .  .

			mat `t' = e(`test')
			mat `pt' = e(p_`test')
			local eqi : word `i' of `coleq'
			while "`eqi'" == "`trm'" {
				local vi: word `i' of `vnames'
				
				scalar `bi' = `b'[1,`i']
				if ("`coef'"=="") scalar `bi' = exp(`bi')

				scalar `ti' = `t'[1,`i']
				if (`ti'>=.) local dti `""""'
				else local dti `ti'

				scalar `pti' = `pt'[1,`i']
				if (`pti'>=.) local dpi `""""'
				else local dpi `pti'

				scalar `lb' = `ci'[1,`i']
				local lbi `lb'
				if `lb' >= . {
					if ("`coef'"=="") local lbi = 0
					else local lbi `""-Inf""'
				}
				else if ("`coef'"=="") scalar `lb' = exp(`lb')

				scalar `ub' = `ci'[2,`i']
				local ubi `ub'
				if (`ub' >= .) local ubi `""+Inf""'
				else if ("`coef'"=="") scalar `ub' = exp(`ub')

				local muei
				if (`mue'[1,`i'] != 0) local muei *
				if (`mue1'[1,`i'] != 0) local muei **

				.`Tab'.row `"`=abbrev("`vi'",12)'"' `bi' ///
					"`muei'" `dti' `dpi' `lbi' `ubi'
				local eqi : word `++i' of `coleq'
				local mnames `mnames' `vi'
				local `++ntests'
			}
		}
		local vnames: list vnames - mnames
	}
	if "`vnames'" != "" {
		.`Tab'.sep
		foreach vi of local vnames {
			local i : list posof "`vi'" in bnames
			scalar `bi' = `b'[1,`i']
			if ("`coef'"=="" | "`coef'"=="irr") ///
				scalar `bi' = exp(`bi')

			scalar `ti' = `t'[1,`i']
			if (`ti'>=.) local dti `""""'
			else local dti `ti'

			scalar `pti' = `pt'[1,`i']
			if (`pti'>=.) local dpi `""""'
			else local dpi `pti'

			scalar `lb' = `ci'[1,`i']
			local lbi `lb'
			if `lb' >= . {
				if ("`coef'"=="" | "`coef'"=="irr") ///
					local lbi = 0
				else local lbi `""-Inf""'
			}
			else if ("`coef'"==""|"`coef'"=="irr") ///
				scalar `lb' = exp(`lb')

			scalar `ub' = `ci'[2,`i']
			local ubi `ub'
			if (`ub' >= .) local ubi `""+Inf""'
			else if ("`coef'"=="" | "`coef'"=="irr") ///
				scalar `ub' = exp(`ub')

			local muei
			if (`mue'[1,`i'] != 0) local muei *
			if (`mue1'[1,`i'] != 0) local muei **

			.`Tab'.row `"`=abbrev("`vi'",12)'"' `bi' "`muei'" ///
				`dti' `dpi' `lbi' `ubi'
			local `++ntests'
		}
		if "`e(exposure)'" != "" {
			.`Tab'.row `"ln(`=abbrev("`e(exposure)'",9)')"' ///
				 1 "  (exposure)" "" "" "" ""
		}
		else if "`e(offset)'" != "" {
			.`Tab'.row `"`=abbrev("`e(offset)'",12)'"' ///
				 1 "  (offset)" "" "" "" ""
		}
	}
	.`Tab'.sep, bottom

	if (e(condcons)==0 & "`coef'"=="") ///
		local nc = colsof(e(mue_indicators)) - 1
	else local nc = colsof(e(mue_indicators))

	mat `mue' = `mue'*`mue''
	mat `mue1' = `mue1'*`mue1''
	if `mue'[1,1] {
		if (`mue1'[1,1]) local sp {space 2}
		else local sp {space 1}
		di in smcl in gr "{p}(*)`sp'median unbiased estimates " ///
		 "(MUE){p_end}"
	}
	if `mue1'[1,1] {
		di in smcl in gr "{p}(**) median unbiased estimates " ///
		 "(MUE) without mid-p rule{p_end}"
	}
	if `e(midp)' {
		if `mue'[1,1] + `mue1'[1,1] > 0 {
			di in smcl in gr "{p}mid-p-value computed for " ///
			 "the MUEs, probabilities, and CIs{p_end}"
		}	
		else {
			di in smcl in gr "{p}mid-p-value computed for " ///
			 "the probabilities and CIs{p_end}"
		}
	}
end

program CheckTest, sclass
	cap syntax [, SUFFicient Probability score ]

	if _rc {
		di as err "test() must be one of score, " ///
		 "probability, or sufficient (statistic)"
		exit 198
	}
	if `:word count `sufficient' `score' `probability'' > 1 {
		di as err "test() must be one of score, " ///
		 "probability, or sufficient (statistic)"
		exit 198
	}
	if "`score'" != "" {
		local test score
		local stat scoretest
		local ltest Score
		local ptest Pr>=Score
	}
	else if "`probability'" != "" {
		local test prob
		local stat probtest
		local ltest Prob.
		local ptest Pr<=Prob.
	}
	else { /* sufficient statistic */
		local test suff
		local stat sufficient
		local ltest Suff.
		local ptest 2*Pr(Suff.)
	}
	sreturn local test `test'
	sreturn local stat `stat'
	sreturn local ltest `ltest'
	sreturn local ptest `ptest'
end

exit
