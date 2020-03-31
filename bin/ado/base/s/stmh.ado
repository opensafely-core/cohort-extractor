*! version 6.1.0  16apr2007
program define stmh, rclass byable(recall)
	version 6.0, missing
	local missing = cond(_caller()<=5, "noMissing", "Missing")
	st_is 2 analysis
	syntax varlist(min=1) [in] [if] [, Compare(string) BY(varlist) /*
	*/ `missing' Level(cilevel) noSHow  ]
	local missing = cond(_caller()>5, ///
		cond("`missing'"=="","nomissing",""),"`missing'")
	if "`show'"=="" { st_show }

	local aw : char _dta[st_w]
	local weight : char _dta[st_wt]
	local wv : char _dta[st_wv]
	local ttype : type _t
	local ftype : type _d

	tempvar d y
  
	qui gen `ttype' `y' = _t
	qui replace `y' = `y' - _t0
	 
	tokenize `varlist'
	local ne "`1'"
	mac shift
	local str "`*'"
	capture confirm string var `ne'
	if _rc==0 { error 108 }
	tempvar e
	qui gen `e'=`ne'
	if "`compare'" == "" {
		quietly inspect `e'
		if  r(N_unique) == 2 {
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
	if "`compare'" != "" {
		if "`str'" != "" {
			di in gr "Mantel-Haenszel estimate of the rate ratio"
		}
		else {
			di in gr "Maximum likelihood estimate of the rate ratio"
		}
		di in gr _col(3) "comparing " /*
		*/ in ye "`ne'==`grp1'" in gr " vs. " /*
		*/ in ye "`ne'==`grp2'" 
	}
	else {
		di in gr "Score test for trend of rates with " in ye "`ne'" 
		di in gr _col(3) "with an " in bl "approximate " in gr /*
		*/ "estimate of the " _n /*
		*/ _col(3) "rate ratio for a one unit increase in " in ye "`ne'"
	}
	if "`str'" != "" {
		di in gr _col(3) "controlling for " in ye "`str'"
	} 
	if "`by'" != "" {
		di in gr _col(3) "by " in ye "`by'"
	}
	if "`weight'"=="iweight" | "`weight'"=="pweight" {
		di in bl "  (`weight's used; "/*
		*/ "confidence intervals & p-values may be wrong)"
	}
	tempvar touse strata d1 d2 y1 y2 dt yt q r u v rr ef sm
	quietly {
		tempvar wt
		if "`wv'"=="" {
			gen byte `wt'=1
		}
		else {
			gen `wt'=`wv'
		}
		mark `touse' `if' `in' `aw'
		if "`compare'"!="" {
			recode `e' `grp1' = 1 `grp2' = 2  * = .
		}
		markout `touse' _d  `e' `y' `wt'
		if "`missing'"!="" {
			markout `touse' `by' `str'
		}
		replace `touse'=0 if _st==0
		preserve
		drop if `touse'==0
		tempvar last
		gen byte `last'=0
		tempvar order
		gen int `order'=_n
	}
	capture noi  {
		quietly {
			/* Two group comparison */
			if "`compare'"!="" {
				if "`str'`by'"!="" {
					sort `str' `by' 
					by `str' `by': gen double `d1' /*
					 */ = sum(`wt'*cond(`e'==1,_d ,0)) 
					by `str' `by': gen double `d2' = /* 
					*/ sum(`wt'*cond(`e'==2,_d ,0)) 
					by `str' `by': gen double `y1' =/* 
					*/  sum(`wt'*cond(`e'==1,`y',0))
					by `str' `by': gen double `y2' =/* 
					*/  sum(`wt'*cond(`e'==2,`y',0)) 
					by `str' `by': replace `last'= ( _n==_N)

				}
				else {
					gen double `d1' = /*
					*/  sum(`wt'*cond(`e'==1,_d ,0)) 
					gen double `d2' = /*
					*/  sum(`wt'*cond(`e'==2,_d ,0)) 
					gen double `y1' = /*
					*/  sum(`wt'*cond(`e'==1,`y',0))
					gen double `y2' = /*
					*/  sum(`wt'*cond(`e'==2,`y',0)) 
					replace `last'= ( _n==_N)
				}
				gen double `dt' = /*
				*/  `d1' + `d2' if  `last'==1
				gen double `yt' = /*
				*/  `y1' + `y2' if  `last'==1
				gen double `q' = /*
				*/  `d1'*`y2'/`yt' if `last'==1
				gen double `r' = /*
				*/  `d2'*`y1'/`yt' if `last'==1
				drop `d1'  `d2' 
				gen double `u' = `q' - `r' 
				gen double `v' =`dt'*`y1'*`y2'/(`yt'^2)
				drop `y1' `y2' `dt' `yt'
				if "`by'" != "" {
					sort `by' 
					by `by': replace `q' = sum(`q') 
					by `by': replace `r' = sum(`r')
					by `by': replace `u' = sum(`u')
					by `by': replace `v' = sum(`v')
					by `by': /*
					*/ replace `last'=(_n == _N & `v'>0)
					replace `q'=. if `last'!=1
					replace `r'=. if `last'!=1
					replace `u'=. if `last'!=1
					replace `v'=. if `last'!=1
					local N1 = _N + 1
					set obs `N1'
					tempvar lobs
					gen byte `lobs'=1 if _n==_N
					gen double `sm' = sum(`q')
					replace `q' = `sm' if _n == _N
					replace `sm' = sum(`r') 
					replace `r' = `sm' if _n == _N
					replace `sm' = sum(`u') 
					replace `u' = `sm' if _n == _N
					replace `sm' = sum(`v') 
					replace `v' = `sm' if _n == _N
					local Q = `q'[_N]
					local R = `r'[_N]
					replace `sm' = ((`q'*`R'-`r'*`Q')^2) /*
					*/ /(`Q'*`R'*`v') if _n < _N & `last'
					replace `sm' = 0 /* 
					*/ if _n == _N | `v' == 0 | `last'!=1
					inspect `sm'
					local hdf = r(N_pos)
					replace `sm' = sum(`sm')
					local het = `sm'[_N]
				}
				else {
					replace `q' = sum(`q')
					replace `r' = sum(`r')
					replace `u' = sum(`u')
					replace `v' = sum(`v')
					replace `last'= ( _n==_N)
					local hdf = 0
					local lobs= 0
				}
				gen double `rr' = `q'/`r' if `last'==1 | `lobs'==1
				gen double `ef' =exp(invnorm(`level'*0.005+0.5) /*
				*/ * sqrt(`v'/(`q'*`r')))
			}
			else {
				if "`str'`by'"!="" {
					sort `str' `by' 
					by `str' `by': gen double `dt' = /*
							*/ sum(`wt'*_d ) 
					by `str' `by': gen double `yt' = /*
							*/ sum(`wt'*`y') 
					by `str' `by': gen double `d1' = /* 
							*/  sum(`wt'*_d *`e') 
					by `str' `by': gen double `y1' = /*
							*/ sum(`wt'*`y'*`e')
					by `str' `by': gen double `y2' = /*
							*/ sum(`wt'*`y'*`e'*`e')
					by `str' `by': replace `last'= ( _n==_N)
				}
				else {
					gen double `dt' = sum(`wt'*_d ) 
					gen double `yt' = sum(`wt'*`y') 
					gen double `d1' = sum(`wt'*_d *`e') 
					gen double `y1' = sum(`wt'*`y'*`e')
					gen double `y2' = sum(`wt'*`y'*`e'*`e')
					replace `last'= ( _n==_N)
				}
				gen double `u' = `d1' - `dt'*`y1'/`yt'
				drop `d1'
				gen double `v' = `dt'*(`y2'-`y1'*`y1'/`yt')/`yt' 
/* OK to here */
				*  if `last'==1
				drop `y1' `y2' `yt' `dt' 
				if "`by'" != "" {
					sort `by' 
					*local u1="`u'"
					*local v1="`v'"
					replace `u' = . if `last'!=1
					replace `v' = . if `last'!=1
					by `by': replace `u' = sum(`u')
					by `by': replace `v' = sum(`v')
					replace `last'=0
					by `by': /*
					*/ replace `last'=(_n == _N & `v'>0)
					local N1 = _N + 1
					set obs `N1'
					tempvar lobs
					gen byte `lobs'=1 if _n==_N
			      		gen double `sm' = sum(`u')
			      		replace `u' = `sm' if _n == _N
			      		replace `sm' = sum(`v') 
			      		replace `v' = `sm' if _n == _N
			      		replace `sm' = `u'^2/`v'
			      		replace `sm' = - `sm' if _n == _N
					inspect `sm'
					local hdf = r(N_pos)
					replace `sm' = sum(`sm')
					local het = `sm'[_N]
				}
				else {
					replace `u' = . if `last'!=1
					replace `v' = . if `last'!=1
					replace `u' = sum(`u')
       					replace `v' = sum(`v')
       			 	}
       				gen double `rr' = exp(`u'/`v')
				gen double `ef' = /*
				*/  exp(invnorm(`level'*0.005 + 0.5)/sqrt(`v'))
			}	
			rename `rr' RR
			gen double Lower = RR/`ef'
			gen double Upper = RR*`ef'
			gen double chi2 = (`u'^2)/`v'
			gen double p_value = chiprob(1,chi2)
			noi di in gr _n /*
	*/ `"RR estimate, and lower and upper `=strsubdp("`level'")'%"' /*
			*/ " confidence limits"
			format RR Lower Upper chi2 %6.2f
			format p_value %8.4f
			if "`by'" != "" {
				sort `by'
				noi list `by' RR Lower Upper /*
				*/if `last'==1, /*
				*/  noobs nodisplay
				if "`str'"=="" {
					noi di in gr _n /*
					*/ "Overall estimate controlling for "/*
					*/ in ye "`by'"
				}
				else {
					noi di in gr _n /*
					*/ "Overall estimate controlling for "/*
					*/ in ye "`str' `by'"
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
				noi di in smcl _n in gr _col(9) "{hline 58}"
				noi di in gr _col(5) /*
				*/ "         RR       chi2        P>chi2 "/*
*/ `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
				noi di in smcl in gr _col(9) "{hline 58}"
				noi di in ye _col(6) %10.3f RR[_N] /*
				*/  _col(20) %7.2f chi2[_N] /*
				*/ _col(35) %5.4f p_value[_N] /*
				*/ _col(45) %10.3f Lower[_N] _col(56) /*
				*/  %10.3f Upper[_N]
				noi di in smcl in gr _col(9) "{hline 58}"
				if `hdf' > 1 {
					noi di in gr _n /*
					*/ "Approx test for unequal RRs" /*
					*/ " (effect modification): " /*
					*/ in gr "chi2(" in ye `hdf'-1 /*
					*/ in gr ") = " /*
					*/ in ye %8.2f =`het' 
					noi di _col(52) in gr "Pr>chi2 = " /*
					*/ in ye %8.4f = chiprob(`hdf'-1,`het') 
				}
				else {
					noi di in gr _n /*
					*/ "Too few informative strata for" /*
					*/ " test for unequal OR's"
				}
			}
			else {
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
				noi di in smcl _n in gr _col(9) "{hline 58}"
				noi di in gr _col(5) /*
				*/ "         RR       chi2        P>chi2 "/*
*/ `"`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
				noi di in smcl in gr _col(9) "{hline 58}"
				noi di in ye _col(6) %10.3f RR[_N] /*
				*/  _col(20) %7.2f chi2[_N] /*
				*/ _col(35) %5.4f p_value[_N] /*
				*/ _col(45) %10.3f Lower[_N] _col(56) /*
				*/  %10.3f Upper[_N]
				noi di in smcl in gr _col(9) "{hline 58}"
			}
		}
		/* Save overall RR in r(RR) */
		ret scalar RR  = RR[_N]
		global S_1 = RR[_N]
	}
		if "`lobs'"!="" {
			qui drop if `lobs'==1
		} 
		drop  RR Lower Upper chi2 p_value 
                local rc = _rc
		sort `order'
		if _rc!=0 {
			exit `rc'
		}
end

