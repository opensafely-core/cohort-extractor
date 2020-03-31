*! version 6.1.12  02mar2015
program define mhodds, rclass
	version 6, missing
	syntax varlist(min=2) [if] [in] [fweight] [, Binomial(string) /*
	  */ Compare(string) BY(string) Level(cilevel) ]

	marksample touse, strok
	tokenize `varlist'
	tempvar d order e
	/* checks that weight and binomial are not both present */
	if "`binomial'"!="" & "`weight'"!="" {
		di in re "weight not allowed with binomial() option"
		exit 198
	}

	_epitab_by_parse `by'
	local by `s(by)'
	local missing `s(missing)'
	sret clear
	if ("`missing'" == "") {
		markout `touse' `by', strok
	}
	qui count if `touse'
	if (r(N)==0) {
		error 2000
	}

	/* chk if response is coded 0/1 for individual or freq records */
	qui gen int `d'=`1' if `touse'
	if "`binomial'" == "" {
		capture assert `d'==0 | `d'==1 if `touse'

                	if _rc~=0 {
	   			di in re "Response `1' not coded 0/1"
	   			exit 198
			}
	}
	capture confirm string variable `2'
	if _rc==0 {
		noi di in red "nonnumeric variable `2' not allowed"
		exit 198
	}

	qui gen `e'=`2' if `touse'
	qui gen int `order'=_n
	local ne = "`2'"
	local abne = abbrev("`ne'",12)


	/* puts variables to be controlled for in local macro str */
	local str=""
	while "`3'" != "" {
		local str="`str' `3'"
		mac shift
	}

	/* if !compare & 2 levels for xvar: set compare & use the 2 levels */

	if "`compare'" == "" {
		qui inspect `e' 
		if r(N_unique) == 2 {
			local compare "compare"
      			quietly summarize `e' if `touse', meanonly
      			local grp1 = r(max)
      			local grp2 = r(min)
   		}
	}
	else {
		tokenize "`compare'", parse(",")
		local grp1 `1'
		local grp2 `3'
	}

	* sets  titles

	if "`compare'" != "" {

		if "`str'" != "" {
			local t2:word count `str'
			TITle `t2' `str'

			di in gr _n "Mantel-Haenszel estimate of the odds ratio"
			di in gr /*
			*/ "Comparing `abne'==`grp1' vs. `abne'==`grp2'," /*
			 */ " controlling for `r(t2)'"
   		}
		else {
			di in gr _n /*
			  */ "Maximum likelihood estimate of the odds ratio"
			di in gr "Comparing `abne'==`grp1' vs. `abne'==`grp2'"
		}
	}
	else {
		di in gr _n "Score test for trend of odds with `abne'"
		if "`str'" != "" {
			local t2:word count `str'
			TITle `t2' `str'

			di in gr "controlling for `r(t2)'"
		} 
	}
	if "`by'" != "" {
		local bycnt: word count `by'
		if `bycnt'>3 {
			di in red "only 3 by() variables allowed"
			exit 198
		}
		unabbrev `by'
		local by="`s(varlist)'"
		di in gr "by `by'"
	}


	* sets  the variable h for controls

	tempvar h 
	if "`binomial'" == "" {
		qui gen int  `h' = 1 - `d' if `touse'
	}
	else {
		qui gen int `h' = `binomial' - `d' if `touse'
	}

	tempvar wt
	qui gen long `wt' = 1 if `touse'
	if "`weight'" != "" {
	   qui replace `wt' `exp' if `touse'
	}

	capture noisily {

		/* sets variable to index strata which is 1 for no strata */ 
		tempvar strata
		if "`str'" != "" {
			qui egen int `strata' = group(`str') if `touse'
		}
		else {
			qui gen int `strata' = 1 if `touse'
		}
   
		tempvar d1 d2 h1 h2 p1 p2 dt ht pt q r u v rr ef sm
		* If compare not blank then use odds ratios

		if "`compare'" != "" {
			tempvar last
			qui replace `touse'=0 if `e' != `grp1' & `e' != `grp2'
			sort `touse' `strata' `by' 
			qui by `touse' `strata' `by': /*
			*/ gen double `d1'=sum(cond(`e'==`grp1',`d',0)*`wt') /*
			*/ if `touse'
			qui by `touse' `strata' `by': /*
			*/ gen double `d2'=sum(cond(`e'==`grp2',`d',0)*`wt') /*
			*/  if `touse'
			qui by `touse' `strata' `by': /*
			*/ gen double `h1'=sum(cond(`e'==`grp1',`h',0)*`wt') /*
			*/ if `touse'
			qui by `touse' `strata' `by': /*
			*/ gen double `h2'=sum(cond(`e'==`grp2',`h',0)*`wt') /*
			*/  if `touse'
			qui gen byte `last'=0
			qui by `touse' `strata' `by': /*
			*/ replace `last'=1 if _n == _N & `touse'
			qui gen double `dt' = `d1' + `d2' if `last'==1
			qui gen double `ht' = `h1' + `h2' if `last'==1
			qui gen double `p1' = `h1' + `d1' if `last'==1 
			qui gen double `p2' = `h2' + `d2'  if `last'==1
			qui gen double `pt' = `p1' + `p2' if `last'==1
			qui gen double `q' = `d1'*`h2'/`pt' if `last'==1
			qui gen double `r' = `d2'*`h1'/`pt' if `last'==1
			qui gen double `u' = `q' - `r' if `last'==1
			qui gen double `v' = /*
			*/ `p1'*`p2'*`dt'*`ht'/((`pt'-1)*(`pt'^2)) if `last'==1
			*qui replace `v'=. if `r'==0 | `q'==0 
			tempname cl
			qui count if `last'==1
			scalar `cl'=r(N)
			qui count if `v'>0 & `v'< . & `last'==1
			if r(N)<`cl' {
				noi di _n in gr "note: only " r(N) /*
				*/ " of the " `cl' " strata " /*
				*/ "formed in this analysis contribute" _n /*
*/ "      information about the effect of the explanatory variable"
      			}
      			drop `h1' `h2' `d1' `d2' `ht' `dt' `p1' `p2' `pt'
      
			/* if by not blank then do homogeneity test */
			if "`by'" != "" {
				sort `touse' `by'
				qui by `touse' `by': replace `q' = /*
					*/ sum(`q') if `touse'
				qui by `touse' `by': replace `r' = /*
					*/ sum(`r') if `touse'
				qui by `touse' `by': replace `u' = /*
					*/ sum(`u') if `touse'
				qui by `touse' `by': replace `v' = /*
					*/ sum(`v') if `touse'
				tempvar last
				qui by `touse' `by': /*
				      */ gen byte `last'=1 if _n == _N & `touse'
				local N1 = _N + 1
				qui set obs `N1'
				qui replace `last'=1 if _n==_N
				qui gen double `sm' = sum(`q') if `last'==1
				qui replace `q' = `sm' if _n == _N
			 	qui replace `sm' = sum(`r') if `last'==1
				qui replace `r' = `sm' if _n == _N
				qui replace `sm' = sum(`u') if `last'==1
				qui replace `u' = `sm' if _n == _N
				qui replace `sm' = sum(`v') if `last'==1
			 	qui replace `v' = `sm' if _n == _N
				local Q = `q'[_N]
				local R = `r'[_N]
		 		qui replace `sm' = /*
				*/ ((`q'*`R' - `r'*`Q')^2)/(`Q'*`R'*`v') /*
				*/ if _n < _N & `last'==1
				qui replace `sm' = 0 if _n == _N | `v' == 0
				qui inspect `sm'
				local hdf = r(N_pos)
				qui replace `sm' = sum(`sm') if `last'==1
				local het = `sm'[_N]
			}
			else {
				qui replace `q' = sum(`q')
				qui replace `r' = sum(`r')
				qui replace `u' = sum(`u')
				qui replace `v' = sum(`v')
				qui replace `last'=cond(_n==_N, 1, .)
			}
			qui gen double `rr' =`q'/`r' if `last'==1
			qui gen double `ef'= exp(invnorm(`level'*0.005 + 0.5) /*
			*/ * sqrt(`v'/(`q'*`r'))) if `last'==1
		} /* end of compare!="" */  	 

		/* if compare is blank then use trend with xvar*/
		else {
			sort `touse' `strata' `by' 
			qui by `touse' `strata' `by': /*
				*/ gen double `dt'=sum(`d'*`wt') if `touse'
		 	qui by `touse' `strata' `by': gen double `pt'= /*
				*/ sum((`d'+`h')*`wt') if `touse'
			qui by `touse' `strata' `by': /*
				*/ gen double `d1'=sum(`d'*`e'*`wt') /*
				*/  if `touse'
			qui by `touse' `strata' `by': gen double `p1'= /*
				*/ sum((`d'+`h')*`e'*`wt') if `touse'
			qui by `touse' `strata' `by': gen double `p2' = /*
				*/ sum((`d'+`h')*`e'*`e'*`wt') if `touse'
			tempvar last
			qui by `touse' `strata' `by': /*
				*/ gen byte `last'=1 if _n == _N & `touse'
			qui gen double `u' = `d1' -(`dt'*`p1'/`pt') if `last'==1 
			qui gen double `v' = `dt'*(`pt'-`dt')/*
			*/ *(`p2'-`p1'*`p1'/`pt')/(`pt'*(`pt'-1)) if `last'==1
			tempname cl 
			qui count if `last'==1 & `touse'
			scalar `cl'=r(N)
			qui count if `v'>0 & `v'< . & `last'==1
			if r(N)<`cl' {
				noi di _n in gr "note: only "  /*
				*/ r(N) " of the " `cl' " strata " /*
				*/ "formed in this analysis contribute" _n /*
				*/ "      information about the "/*
				*/"effect of the explanatory variable"
			}
     	 
			/* if by is not blank do homogeneity test */     
    	 
			if "`by'" != "" {
				tempvar last
				sort `touse' `by' 
				qui by `touse' `by': replace `u' = sum(`u') /*
					*/ if `touse'
				qui by `touse' `by': replace `v' = sum(`v') /*
					*/ if `touse'
				qui by `touse' `by': gen byte `last'=1 /*
					*/ if _n == _N & `touse'
				local N1 = _N + 1

				qui set obs `N1'
				qui replace `last'=1 if _n==_N
				qui gen double `sm' = sum(`u') if `last'==1
				qui replace `u' = `sm' if _n == _N
				qui replace `sm' = sum(`v')  if `last'==1
				qui replace `v' = `sm' if _n == _N
				qui replace `sm' = `u'^2/`v' if `last'==1
				qui replace `sm' = - `sm' if _n == _N
				qui inspect `sm'
				local hdf = _result(4)
				qui replace `sm' = sum(`sm')
				qui local het = `sm'[_N]
			}
			else {
				tempvar last
				qui gen byte `last'=1 if _n == _N
				qui replace `u' = sum(`u')
				qui replace `v' = sum(`v')
			}
		      drop `d1' `dt' `p1' `p2' `pt'
		      qui gen double `rr' = exp(`u'/`v')
		      qui gen double `ef' = /*
			*/ exp(invnorm(`level'*0.005 + 0.5)/sqrt(`v'))
		}
  	 
		* Calculate the OR or trend with confidence limits
		tempvar cl cu ch pv
		qui gen double `cl' = `rr'/`ef' if `touse'
		qui gen double `cu' = `rr'*`ef' if `touse'
		qui gen double `ch' = (`u'^2)/`v' if `touse'
		qui gen double `pv' = chiprob(1,`ch') if `touse'
		if "`compare'"!="" | "`by'"!="" {
		/*
			display ""
	di in gr "OR estimate, lower and upper " `"`=strsubdp("`level'")'"' /*
			*/ "% confidence limits, and"
			di in gr /*
			*/  "chi-squared test for OR=1 (1 degree of freedom)"
		*/
		}
		if "`compare'" == "" {
			di in gr _n /*
	   */ "(The Odds Ratio estimate is an approximation to the odds ratio "
			di in gr "for a one unit increase in `abne')"
		}

		if "`by'" != "" {
			if "`grp1'"!="" {
				if `grp1' == `grp2' {
					local cl=.
					local cu=.
					local ch=.
					local pv=.
				}
			}
			MTAb1 `rr' `cl' `cu' `ch' `pv' `level'  `last' `by'
local adj "`str' `by'"
local t2:word count `adj'
TITle `t2' `adj'
   			di in gr _n _col(5) /*
			*/ "Mantel-Haenszel estimate controlling for `r(t2)'"
			local odds=`rr'[_N]
			local lci=`cl'[_N]
			local uci=`cu'[_N]
			local chi2=`ch'[_N]
			local pval=`pv'[_N]
			if "`grp1'"!="" {
				if `grp1' == `grp2' {
					local lci=.
					local uci=.
					local chi2=.
					local pval=.
				}
			}
			MTAb2 `odds' `lci' `uci' `chi2' `pval' `level' 

			if `hdf' > 1 {
				di in gr _n /*
				*/ "Test of homogeneity of ORs (approx): " /*
				*/ "chi2(" in ye `hdf'-1 in gr ")" _col(48) "="/*
				*/ in ye %8.2f `het'
				di in gr _col(38) "Pr>chi2   =  " /*
				 */ in ye %5.4f chiprob(`hdf'-1, `het') 
				ret scalar chi2_hom = `het' 
				ret scalar df_hom = `hdf'-1 
				*ret scalar hom_p = chiprob(`hdf'-1, `het')  
			}
			else {
				di in gr _n "Too few informative strata" /*
				*/ " for test for unequal OR's"
			}
		}
		else {
			qui replace `last'=0 if `last'>=.
			sort `last'
			local odds=`rr'[_N]
			local lci=`cl'[_N]
			local uci=`cu'[_N]
			local chi2=`ch'[_N]
			local pval=`pv'[_N]
			if "`grp1'"!="" {
				if `grp1' == `grp2' {
					local lci=.
					local uci=.
					local chi2=.
					local pval=.
				}
			}
			di "" 
			MTAb2 `odds' `lci' `uci' `chi2' `pval' `level' 
		}
		ret scalar p =  `pv'[_N]
		ret scalar chi2 =  `ch'[_N]
		ret scalar ub_or  =  `cu'[_N]
		ret scalar lb_or =  `cl'[_N]
		ret scalar or  = `rr'[_N] 
		if "`grp1'"!="" {
			if `grp1' == `grp2' {
			ret scalar p = .
			ret scalar chi2 = .
			ret scalar ub_or  = .
			ret scalar lb_or =.

			}
		}

	} /* END CAPTURE */
		if "`by'" != "" { qui drop if _n==_N }
		sort `order'
		 local rc = _rc
                if _rc!=0 {
                        exit `rc'
                }
end
program define MTAb1
	args or lo up chisq pv l1 last 
	*d " `1' `2'   `3'   `4'    `5'    `6' `7' . . . "

	local lab8: value label `8'
	local lng 10
	if "`9'"!="" {
		local lng=20
		local lab9: value label `9'
	}
	if "`10'"!="" {
		local lng=30
		local lab10: value label `10'
	}
	local lng2=78-`lng'

	di _n in smcl in gr "{hline `lng'}{c TT}{hline `lng2'}"
	di in gr %9s abbrev("`8'",8) _c
	if "`9'"!="" {
		di in gr %10s abbrev("`9'",8) _c
	}
	if "`10'"!="" {
		di in gr %10s abbrev("`10'",8) _c
	}
	local spc=int((`lng2'-31)/3)
	di in smcl in gr " {c |} Odds Ratio" _c
	local sp=`spc'-3
  	di in gr _col(`sp') "chi2(1)" _c
	*di in gr _col(`spc') "df" _c
	local sp=`spc'-2
	di in gr _col(`sp') "P>chi2" _c
	local spl=(57-2*`spc'-`lng'-14)-1
	local cil `=string(`l1')'
	local cil `=udstrlen("`cil'")'
	local spl2 = `spl' + 2 - `cil'
	di in gr _col(`spl2')"[`l1'% Conf. Interval]"   
	*local spc = `spc' - 8
	di in smcl in gr "{hline `lng'}{c +}{hline `lng2'}"



	local i 1
	while `i'<_N {
                        local lst=`last'[`i']
                        if `lst'==1 {
				if "`lab8'"!="" {
					local x=`8'[`i']
					local labx1: label `lab8' `x' 8
					local labx = udsubstr(`"`labx1'"',1,8)
					local len=10-udstrlen("`labx'")
			 		 noi di in gr  _col(`len') /*
						*/ %8.0g "`labx'" _c
                                }
				else {
					cap confirm string var `8'
					if _rc==0 {
						local alab=udsubstr(`8'[`i'],1,8)
						local alen=8-udstrlen("`alab'")
						noi di in gr _col(2) /*
						*/ _skip(`alen') "`alab'" _c
					}
				 	else noi di in gr /*
						*/  _col(2) %8.0g `8'[`i'] _c
				}
				if "`lab9'"!="" {
					local x=`9'[`i']
					local labx1: label `lab9' `x' 8
					local labx = udsubstr(`"`labx1'"',1,8)
					local len=11-udstrlen("`labx'")
			 		 noi di in gr  _col(`len') /*
						*/ %8.0g "`labx'" _c
                                }

				else if "`9'"!="" {
					cap confirm string var `9'
					if _rc==0 {
						local alab=udsubstr(`9'[`i'],1,8)
						local alen=8-udstrlen("`alab'")
                                        	noi di _col(3)  in gr /*
						*/ _skip(`alen')  "`alab'" _c
                                	}
					else noi di in gr _col(3) /*
					*/  %8.0g `9'[`i'] _c
				}
				if "`lab10'"!="" {
					local x=`10'[`i']
					local labx1: label `lab10' `x' 8
					local labx = udsubstr(`"`labx1'"',1,8)
					local len=11-udstrlen("`labx'")
			 		 noi di in gr  _col(`len') /*
						*/ %8.0g "`labx'" _c
                                }
				else if "`10'"!="" {
					cap confirm string var `10'
                                        if _rc==0 {
						local alab=udsubstr(`10'[`i'],1,8)
						local alen=8-udstrlen("`alab'")
                                        	noi di _col(3)  in gr /*
						*/ _skip(`alen')  "`alab'" _c
                                        }
					else noi di in gr _col(3) /*
					*/  %8.0g `10'[`i'] _c
				}
				noi di in smcl in gr " {c |} " _c
				di in ye %10.6f `or'[`i'] _c
				local sp=`spc'-2
				di in ye _col(`sp') %6.2f `chisq'[`i'] _c
				di in ye _col(`sp') %5.4f `pv'[`i'] _c
				local sp=`spl'
				di in ye _col(`sp') %9.5f `lo'[`i'] _c
				di in ye _col(3) %9.5f `up'[`i'] 
                        }
                        local i=`i'+1
	}
	di in smcl in gr "{hline `lng'}{c BT}{hline `lng2'}"
end		

program define MTAb2
	args or lo up ch pv l1 
	local cil `=string(`l1')'
	local cil `=udstrlen("`cil'")'
	local spaces "        "
	if `cil' == 4 {
		local spaces "      "
	} 
	else if `cil' == 5 {
		local spaces "     "
	}
	di in smcl in gr _col(5) "{hline 64}"
	di in gr _col(5) /*
	*/ " Odds Ratio    chi2(1)        P>chi2`spaces'[`l1'% Conf. Interval]"
	di in smcl in gr _col(5) "{hline 64}"
	di in ye _col(6) %10.6f `or' _col(20) %7.2f `ch' _col(35) %5.4f `pv' /*
	*/ _col(48) %10.6f `lo' _col(59) %10.6f `up'
	di in smcl in gr _col(5) "{hline 64}"
end

program define TITle, rclass
        if `1'==1 {
                ret local t2 = abbrev("`2'",12)
                exit
        }
        if `1'==2 {
		local n2 = abbrev("`2'",12)
		local n3 = abbrev("`3'",12)
                ret local t2 "`n2' and `n3'"
                exit
        }
        local cnt=`1'
        local fi = abbrev("`2'", 8)
        mac shift
        local i 2
        while `i'<`cnt' {
		local n2 = abbrev("`2'",8)
                local fi="`fi', `n2'"
                local i=`i'+1
                mac shift
        }
	local n2 = abbrev("`2'",8)
        ret local t2 "`fi' and `n2'"
end
