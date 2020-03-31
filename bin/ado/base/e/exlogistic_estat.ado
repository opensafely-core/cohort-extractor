*! version 1.1.0  14mar2018
program exlogistic_estat, rclass
	version 10

	if "`e(cmd)'" != "exlogistic" {
		di as err "{help exlogistic##|_new:exlogistic} estimation " ///
		 "results not found"
		exit 301
	}

	gettoken sub rest: 0, parse(" ,")

	local lsub = length("`sub'")
	if "`sub'" == "ic" | "`sub'" == "vce" {
		di as error "{p}options ic, information criterion, or vce, " ///
		 "variance-covariance estimate, are not valid estat "	     ///
		 "options after exlogistic{p_end}"
		exit 198
	}
	if "`sub'" == "se" {
		_exactreg_replayse `rest'
		return add
	}
	else if "`sub'" == bsubstr("predict",1,max(4,`lsub')) {
		Predict `rest'
		return add
	}
	else if "`e(binomial)'"!="" & ///
		"`sub'"==bsubstr("summarize",1,max(3,`lsub')) {
		di as err "{p}{cmd:estat summarize} is not allowed after " ///
		 "{cmd:exlogistic} when the binomial() option is used{p_end}"
		exit 198
	}
	else estat_default `0'
end

program Predict, rclass
	syntax, [ Pr xb AT(string) Level(cilevel) NOLOg LOg ///
		MEMory(string) HASHsize(integer 0) midp trace ]

	/* hashsize is undocumented; controls the size of the	*/
	/* hash table: index 1 <= hashsize <= 42		*/

	local stat `pr' `xb'
	local ns : word count `stat'
	if `ns' > 1 {
		di as error "pr and xb may not be combined"
		exit 184
	}
	if (`ns'==0) local stat pr

	if "`e(groupvar)'" != "" {
		di as error "{p}estat predict is not allowed for exact " ///
		 "logistic models that used group(){p_end}"
		exit 322
	}
	cap checkestimationsample
	if _rc {
		qui count if e(sample)
		if r(N) == 0 {
			di as err "{p}e(sample) is missing; use "       ///
			 "{help estimates:estimates esample} to reset " ///
			 "it after {cmd: estimates use}{p_end}"
			exit 322
		}
		di as err "{p}data have changed since estimation; "       ///
		 "predictions require rerunning exlogistic, or the "      ///
		 "specification for {help estimates:estimates esample} "  ///
		 "after {cmd: estimates use} did not reset e(sample) to " ///
		 "its estimation state{p_end}"
		exit 459
	}
	preserve 
	tempname touse
	qui gen byte `touse' = e(sample)
	qui keep if `touse'
	if (_N == 0) error 2000

	if "`e(wtype)'" != "" {
		local weight `e(wtype)'
		tempvar f
		qui gen long `f'`e(wexp)'
		local exp "=`f'"
		local wopt weight(`f')
	}
	if "`e(binomial)'`e(n_trials)'" != "" {
		if "`e(wtype)'" == "" {
			tempvar f
			local weight fweight
			gen long `f' = 1
			local exp "=`f'"
			local wopt weight(`f')
		}
		_binomial2bernoulli `e(depvar)', fw(`f') ///
			binomial(`e(binomial)'`e(n_trials)')
	}
	else _float2binary `e(depvar)' `f', nolog

	local level level(`level')
	local allvars `"`e(indvars)' `e(condvars)'"'
	local nv : word count `allvars'

	if "`at'" != "" {
		if `nv' == 0 {
			di as err "{p}option at() is not allowed for the " ///
			 "constant only model{p_end}"
			exit 198
		}
		ParseAtStat "`at'"
		local atstat `r(atstat)'
		local at `"`r(at)'"'
	}
	if ("`atstat'"=="") local atstat median

	tempname pred se ci imue 

	if `nv' > 0 {
		local statvars `allvars'
		tempname vals 
		mat `vals' = J(1,`nv',.)
		mat colnames `vals' = `allvars'
		if "`atstat'" == "mean" {
			local sumopt meanonly
			local rval r(mean)
		}
		else {
			local sumopt detail
			local rval r(p50)
		}
		if "`at'" != "" {
			ParseEvalAt `"`at'"' "`vals'"
			local vars `"`r(vars)'"'
			local statvars 

			foreach vi of local allvars {
				if (!`:list posof "`vi'" in vars') ///
					local statvars `statvars' `vi'
			}
		}	
		foreach vi of local statvars {
			qui summarize `vi' [`weight'`exp'], `sumopt'
			qui replace `vi' = `vi' - `rval'
			local k : list posof "`vi'" in allvars
			mat `vals'[1,`k'] = `rval'
		}
		local condopt condvars(`allvars')
		tempvar cons f

		if "`memory'" != "" {
			_parsememsize "`memory'"
			local memopt memory(`s(size)')
		}
		/* 1 <= hashsize <= 42: index of prime to use	*/
		/* for hashtable 				*/
		if (`hashsize'>0) local hashopt hashsize(`hashsize')

		_exactreg_sort `allvars', `wopt'

		gen byte `cons' = 1
		local X `"`cons' `allvars'"'
		tempname eps
		scalar `eps' = e(eps)

		_parse_iterlog, `log' `nolog'
		local log "`s(nolog)'"
		_exact_msa `e(depvar)' `X' [`weight'`exp'], f(`f') ///
			eps(`eps') `condopt' `memopt' `hashopt' `log' 

		if _N == 1 {
			di as error "only one observation in the " ///
			 "conditional distribution"
			exit 498
		}
		tempname yx N sy b0 est
		scalar `N' = r(N)
		mat `yx' = r(yx)	
		scalar `sy' = r(sy)
		mat `b0' = J(1,1,0)
		mat colnames `b0' = `cons'

		estimates store `est'
		/* estimated constant is the predicted value	*/
		_exactreg_coef `cons', f(`f') yx(`yx') b0(`b0') `mue' ///
			eps(`eps') `level' constant(`cons') `midp' `trace'

		scalar `pred' = el(r(b),1,1)
		scalar `imue' = el(r(imue),1,1)
		if (`imue'==0) scalar `se' = el(r(se),1,1)
		mat `ci' = r(ci)'
		mat colnames `ci' = lb ub
		mat rownames `ci' = pred
		local level = round(`r(level)',.01)
		local level = bsubstr("`level'",1,5) 
		qui estimates restore `est'
	}
	else {
		if ("`midp'"!="" & e(midp)==0) {
			di as err "mid-p-value rule is applied during " ///
			 "estimation for the constant only model"
			exit 498
		}
		/* constant only model				*/
		scalar `pred' = _b[_cons]
		scalar `imue' = el(e(mue_indicators),1,1)
		if (`imue'==0) scalar `se' = el(e(se),1,1)
		mat `ci' = e(ci)'
		mat colnames `ci' = lb ub
		mat rownames `ci' = pred
		local level = round(`e(level)',.01)
		local level = bsubstr("`level'",1,5) 
	}

	if "`stat'" == "pr" {
		scalar `pred' = invlogit(`pred')
		mat `ci'[1,1] = invlogit(`ci'[1,1])
		mat `ci'[1,2] = invlogit(`ci'[1,2])

		if (`imue'==0) scalar `se' = `pred'*(1-`pred')*`se'
	}

	if `nv' > 0 {
		tempname vali
		local k = 0
		local ll = 1
		di in gr _n "Predicted value at " _c
		foreach vi of local allvars {
			scalar `vali' = `vals'[1,`++k']
			if int(`vali')==`vali' {
				local w = int(log10(abs(`vali')+1))+1
				local f 0f
			}
			else if int(`vali') > 0 {
				local w = int(log10(abs(`vali')+1))+1
				local w = `w' + 2
				local f 2f
			}
			else {
				local w = 9
				local f 0g
			}
			local dvi = abbrev("`vi'",12)
			local ll = `ll' + `w'+length("`dvi'") + 4
			if `ll' >= 45 {
				di _n _col(21) _c
				local ll = 1
			}
			else if (`k' > 1) di in gr ", " _c
			di in gr "`dvi' = " %`w'.0`f' in ye `vali' _c
		}
	}
	di 
	if `imue' {
		local muei *
		local dse `""N/A ""'
		if `ci'[1,1] >= . {
			if ("`stat'"=="pr") local lb 0
			else local lb `""-Inf""'
		}
		else local lb `ci'[1,1]

		if `ci'[1,2] >= . {
			if ("`stat'"=="pr") local ub 1
			else local ub `""+Inf""'
		}
		else local ub `ci'[1,2]
	}
	else {
		local dse `se'
		local lb `ci'[1,1]
		local ub `ci'[1,2]
	}

	tempname Tab
	.`Tab' = ._tab.new, col(6) lmargin(0) ignore(.b)
	// column        1      2     3      4      5      6 
	.`Tab'.width	13    |11     1     13     0      25
	.`Tab'.titlefmt  .   %11s     .      .      .   %25s
	.`Tab'.strfmt    .   %11s   %1s    %~6s     .      .
	.`Tab'.pad       .      2     0      4      0      3
	.`Tab'.strcolor  result .     . result result result
	.`Tab'.sep, top
	.`Tab'.titles	`"`=abbrev("`e(depvar)'",12)'"'	/// 1
			"Predicted"	/// 2
			""		/// 3
			"Std. Err."	/// 4
			"" `"[`=strsubdp("`level'")'% Conf. Interval]"' //  5 6

	.`Tab'.sep
	.`Tab'.strcolor text result     .     .     .     .
	.`Tab'.width      13    |11     1    13    11     14
	if "`stat'" == "pr" {
		.`Tab'.numfmt  .  %6.4f  . %6.4f %6.4f %6.4f 
		.`Tab'.pad     .      5  0     5     6     6
		local lab Probability
	}
	else {
		.`Tab'.numfmt  .  %9.0g  . %9.0g %9.0g %9.0g 
		.`Tab'.pad     .      2  0     2     1     1
		local lab Xb
	}
	.`Tab'.row "`lab'" `pred' "`muei'" `dse' `lb' `ub'
	.`Tab'.sep, bottom
	if `imue' {
		di in smcl in gr "{p}(*) identifies median unbiased " ///
		 "estimates (MUE); because an MUE{p_end}"
		di in smcl in gr "{p 4}is computed, there is no SE "  ///
		 "estimate{p_end}"
	}
	if "`midp'" != "" {
		di in smcl in gr "{p}mid-p-value computed for the " ///
		 "CI{p_end}"
	}

	return local level `level'
	return local estimate `stat'
	if (`nv' > 0) return matrix x = `vals'
	return scalar pred = `pred'
	if (`imue'==0) return scalar se = `se'
	return matrix ci = `ci'
	return scalar imue = `imue'
end

program ParseAtStat, rclass
	args at

	gettoken first at1: at, parse(" =")
	gettoken tok at1: at1, parse(" =")
	if ("`tok'" == "=") {
		return local at `at'
		exit 0
	}
	/* secretly allow mean */
	if "`first'"!="mean" & "`first'"!="median" {
		di as error "{p} invalid statistic specified in at(), only " ///
		 "median is allowed; see help "				     ///
	 	 `"{helpb exlogistic postestimation##estatmfx:exlogistic "'  ///
		 "postestimation}{p_end}"
		exit 198
	}
	return local atstat `first'
	return local at `at1'
end

program ParseEvalAt, rclass
	args at vals
	
	local exp `at'
	local na = _N
	tempname val
	local names : colnames `vals'

	while `"`at'"' != "" {
		gettoken var at: at, parse(" =")
		gettoken tok at: at, parse(" =")
		if ("`tok'"!="=") ParseError `"`exp'"'

		/* allow space or comma to delimit expressions */
		gettoken tok at: at, parse(" ,")
		cap scalar `val' = `tok'
		if (_rc) ParseError `"`exp'"'
		unab var : `var'
		if `:list posof "`var'" in vars' { 
			di as error "{p}variable `var' included more than " ///
			 "once in at(){p_end}"
			exit 198
		}
		cap qui replace `var' = `var'-`val'
		if (_rc) ParseError `"`exp'"'

		local k : list posof "`var'" in names
		if `k' == 0 {
			di as error "{p}variable `var' is not in the model{p_end}"
			exit 322
		}
		mat `vals'[1,`k'] = `val'

		local vars `vars' `var'
		local exp `at'

		cap gettoken tok at: at, parse(",")

		if ("`tok'"==",") local exp `at'
		else local at `exp'

	}
	return local vars `vars'
end

program ParseError
	args exp

	di as error `"{p}invalid at() expression "`exp'"; see help "'   ///
"{helpb exlogistic postestimation##estatmfx:exlogistic postestimation}" ///
	 "{p_end}"

	exit 198
end

exit
