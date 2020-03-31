*! version 6.2.2  09feb2015
program define stmc, rclass byable(recall)
        version 6, missing
	st_is 2 analysis

	local missing = cond(_caller()<=5, "noMissing", "Missing")
	syntax varlist(min=1 numeric) [in] [if] [, Compare(string) /*
		*/ BY(varlist) `missing' Level(cilevel) ]
	local missing = cond(_caller()>5, ///
		cond("`missing'"=="","nomissing",""),"`missing'")

	tokenize `varlist'
	local e "`1'"
	mac shift
	local str "`*'"
	st_show
	local tout _t
	local tin _t0
	local weight : char _dta[st_wt]
	local wt : char _dta[st_wv]
	local aw : char _dta[st_w]
	local control: char _dta[st_orig]         /*  time doe */
	tokenize "`control'"
	if "`2'"!="" {
		local control "`2'"	               
	}

	if "`compare'" == "" {
		qui inspect `e'
		if r(N_unique) == 2 {
			local compare "compare"
			quietly summarize `e'
			local grp1 = r(max)
			local grp2 = r(min)
		}
	}
	else {
		tokenize "`compare'", parse(",")
		local grp1 `1'
		local grp2 `3'
	}
	di
	di in gr "Mantel-Cox comparisons"
	di
	if "`compare'" != "" {
		di in gr "Mantel-Haenszel estimates of the rate ratio"
		di in gr _col(4) "comparing " in ye "`e'==`grp1'" /*
		*/  in gr " vs. " in ye "`e'==`grp2'" 
	}
	else {
		di in gr "Score tests for trend of rates with " in ye "`e'" 
		di in gr _col(4) "with an " in bl "approximate " in gr /*
		*/ "estimate of the " _n /*
		*/ _col(4) "rate ratio for a one unit increase in " in ye "`e'"
	}
	di in gr _col(4) "controlling for time (by clicks)" _continue
	if "`str'"!="" {
		di in gr " and " in ye "`str'"
	}
	else {
		di
	}
	if "`by'" != "" {
		di in gr _col(4) "by " in ye "`by'"
	}
	if "`weight'"=="iweight" | "`weight'"=="pweight" {
		di in bl "  (`weight's used; "/*
	*/ "confidence intervals & p-values may be wrong)"
	}

	tempvar touse id t rtype wx wx2 sw sx sx2 q r u v ef q2 r2 qr
	preserve
	quietly {
		mark `touse' `if' `in' 
		if "`compare'"!="" {
			recode `e' `grp1' = 1 `grp2' = 2  * = .
		}
		markout `touse' _d  `e' `tout' `tin' `control' `wt'
		if "`missing'"!="" {
			markout `touse' `by' `str'
		}
		replace `touse'=0 if _st==0
		keep if `touse' 
/*
		if "`control'"!="" {
			tempvar con
			gen double `con'= /*
			*/ (`control'-`_dta[st_o]')/`_dta[st_s]' 
			replace `tin' = cond(`touse'==1,`tin' - `con',.)
			replace `tout' =cond(`touse'==1,`tout' - `con',.)
			drop `con'
		} 
*/
		keep _d  `e' `tout' `tin' `by' `str' `wt' `control' 
		if "`wt'"=="" {
			tempvar wt
			gen `wt' = 1
		}
		if "`compare'" != "" {
			gen double `wx' = `wt'*(`e'==1)
			gen double `wx2' = `wx'
		}
		else {
			gen double `wx' = `wt'*`e'
			gen double `wx2' = `wt'*(`e'^2) 
		}     
		gen `c(obs_t)' `id'=_n
		expand 2
		sort `id'
		by `id': gen double `t' = cond(_n==1, `tin', `tout')
		by `id': gen int `rtype' = cond(_n==1, 2, _d ==0)
		by `id': replace `wt' = -`wt' if _n==2 
		by `id': replace `wx' = -`wx' if _n==2 
		by `id': replace `wx2' = -`wx2' if _n==2 
		sort `by' `str' `t' `rtype'
		by `by' `str' `t' `rtype': replace `wt'=sum(`wt')
		by `by' `str' `t' `rtype': replace `wx'=sum(`wx')
		by `by' `str' `t' `rtype': replace `wx2'=sum(`wx2')
		by `by' `str' `t' `rtype': keep if _n == _N
		if "`by'`str'"!="" {
			by `by' `str': gen double `sw' = sum(`wt')
			by `by' `str': gen double `sx' = sum(`wx')
			by `by' `str': gen double `sx2' = sum(`wx2')
		}
		else {
			gen double `sw' = sum(`wt')
			gen double `sx' = sum(`wx')
			gen double `sx2' = sum(`wx2')
		}
		keep if `rtype'==0
		* Now there is one record for each failure time
		gen `u' = -`wx' + `wt'*(`sx'-`wx')/(`sw'-`wt')
		gen `v' = -`wt'*((`sx2'-`wx2')/(`sw'-`wt') - /*
		*/ ((`sx'-`wx')/(`sw'-`wt'))^2)
	}
	/* Two group comparison */
	if "`compare'"!="" {
	
		qui gen `q' = -`wx'*(`sw'-`sx')/(`sw'-`wt')
		qui gen `r' = `sx'*(`wx'-`wt')/(`sw'-`wt')
		if "`by'"!="" {
			tempvar RR Lower Upper
			qui by `by': replace `u' = sum(`u')
			qui by `by': replace `v' = sum(`v')
			qui by `by': replace `q' = sum(`q')
			qui by `by': replace `r' = sum(`r')
			qui by `by': keep if _n==_N & `v'>0
			local hdf = _N - 1
			qui gen double `q2' = sum((`q'^2)/`v')
			qui gen double `r2' = sum((`r'^2)/`v')
			qui gen double `qr' = sum(`q'*`r'/`v')
			qui gen `RR' = `q'/`r'
			qui gen `ef' = /*
			*/ exp(invnorm(`level'*0.005+0.5) * sqrt(`v'/(`q'*`r')))
			qui gen `Lower' = `RR'/`ef' 
			qui gen `Upper' = `RR'*`ef'
			di in gr _n /*
	*/ `"RR estimate, and lower and upper `=strsubdp("`level'")'% "'/*
			*/ "confidence limits"
			format `RR' `Lower' `Upper' %6.3f
			char `RR'[varname] "RR"
			char `Lower'[varname] "Lower"
			char `Upper'[varname] "Upper"
			list `by' `RR' `Lower' `Upper', noobs subvar
			qui drop `ef' `RR' `Lower' `Upper'
         	}
         	else {
			local hdf = 0
		}
		qui replace `u' = sum(`u')
		qui replace `v' = sum(`v')
		qui replace `q' = sum(`q')
		qui replace `r' = sum(`r')
		qui keep if _n==_N
		qui gen _RR = `q'/`r'
		qui gen `ef' =/* 
		*/ exp(invnorm(`level'*0.005 + 0.5) * sqrt(`v'/(`q'*`r')))
		qui gen _Lower = _RR/`ef' 
		qui gen _Upper = _RR*`ef'
		qui gen _Chisq = `u'^2/`v'
		qui gen _p_value = chiprob(1, _Chisq)
		di 
		di in gr /*
	      */ "Overall Mantel-Haenszel estimate, controlling for " _continue 
		if "`control'"=="" {
			di in gr "time" _continue
		}
		else {
			di in gr "time from " in ye "`control'" _continue 
		}
		local cil `=string(`level')'
		local cil `=length("`cil'")'
		if `cil' == 2 {
			local spaces "     "
		}
		else if `cil' == 4 {
			local spaces "   "
		}
		else {
			local spaces "  "
		}
		RestLine `str' `by'
		noi di in smcl _n in gr _col(9) "{hline 58}"
		noi di in gr _col(5) /*
		*/ "         RR       chi2        P>chi2 "/*
		*/ `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
		noi di in smcl in gr _col(9) "{hline 58}"
		noi di in ye _col(6) %10.3f _RR /*
		*/  _col(20) %7.2f _Chisq /*
		*/ _col(35) %5.4f _p_value /*
		*/ _col(45) %10.3f _Lower _col(56) /*
		*/  %10.3f _Upper
		noi di in smcl in gr _col(9) "{hline 58}"

		if `hdf'>0 {
			local het = `q2'[1]/_RR[1] + `r2'[1]*_RR[1] - 2*`qr'[1] 
			di in gr _n /*
		      */ "Approx chisq for unequal RRs (effect modification)" /*
			*/ in ye %8.2f =`het' " (" `hdf' " df, p = " /*
			*/ %7.5f = chiprob(`hdf', `het') ")"
		}
	}
	else {
		if "`by'"!="" {
			tempvar RR Lower Upper
			qui by `by': replace `u' = sum(`u')
			qui by `by': replace `v' = sum(`v')
			qui by `by': keep if _n==_N & `v'>0
			local hdf = _N - 1
			qui gen `RR' = exp(`u'/`v')
			qui gen `ef' =/*
			 */ exp(invnorm(`level'*0.005 + 0.5) * sqrt(1/`v'))
			qui gen `Lower' = `RR'/`ef' 
			qui gen `Upper' = `RR'*`ef'
			char `RR'[varname] "RR"
			char `Lower'[varname] "Lower"
			char `Upper'[varname] "Upper"
			di in gr _n /*
			 */ "Approximate RR estimate, and lower and upper "/*
			 */ `"`=strsubdp("`level'")'% confidence limits"'
			 format `RR' `Lower' `Upper' %6.3f
			list `by' `RR' `Lower' `Upper', noobs subvar
			qui drop `ef' `RR' `Lower' `Upper'
		}
		else {
			local hdf = 0
		}
		qui replace `u' = sum(`u')
		qui replace `v' = sum(`v')
		qui gen _Chisq = sum(`u'^2/`v')
		local schi2 = _Chisq[_N]
		qui keep if _n==_N
		qui gen _RR = exp(`u'/`v')
		qui gen `ef' = exp(invnorm(`level'*0.005 + 0.5) * sqrt(1/`v'))
		qui gen _Lower = _RR/`ef' 
		qui gen _Upper = _RR*`ef'
		qui replace _Chisq = `u'^2/`v'
		qui gen _p_value = chiprob(1, _Chisq)
		format _RR _Lower _Upper _Chisq %6.3f
		format _p_value %8.5f
		di 
	       di in gr "Overall Mantel-Haenszel estimate, controlling for " _c 
		if "`control'"=="" {
		   di in gr "time" _continue
		}
		else {
			di in gr "time from " in ye "`control'" _continue 
		}
		local cil `=string(`level')'
		local cil `=length("`cil'")'
		if `cil' == 2 {
			local spaces "     "
		}
		else if `cil' == 4 {
			local spaces "   "
		}
		else {
			local spaces "  "
		}
		RestLine `str' `by'
		noi di in smcl _n in gr _col(9) "{hline 58}"
		noi di in gr _col(5) /*
		*/ "         RR       chi2        P>chi2 "/*
		*/ `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
		noi di in smcl in gr _col(9) "{hline 58}"
		noi di in ye _col(6) %10.3f _RR /*
		*/  _col(20) %7.2f _Chisq /*
		*/ _col(35) %5.4f _p_value /*
		*/ _col(45) %10.3f _Lower _col(56) /*
		*/  %10.3f _Upper
		noi di in smcl in gr _col(9) "{hline 58}"

		if `hdf'>0 {
			local het = `schi2' - _Chisq[1]
			di in gr _n /*
		       */ "Approx chisq for unequal RRs (effect modification)" /*
			*/ in ye %8.2f =`het' " (" `hdf' " df, p = " /*
			*/ %7.5f = chiprob(`hdf', `het') ")"
		}
	} /* end else */
	/* Save final rate ratio in S_1 */
	global S_1 = _RR[1]
	ret scalar RR=_RR[1]
end

program define RestLine /* <varnames> */
	local n : word count `*'
	if `n' == 0 { 
		di 
		exit
	}
	di in gr " and"
	if `n'==1 { 
		di in ye "`1'"
		exit
	}
	if `n'==2 { 
		di in ye "`1'" in gr " and " in ye "`2'"
		exit
	}
	local i 1 
	while `i' <= `n'-1 { 
		di in ye "``i''" in gr ", " _c
		local i = `i' + 1
	}
	di in gr "and " in ye "``n''"
end
