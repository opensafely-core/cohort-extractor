*! version 6.0.12  02mar2015
program define tab_or, rclass
	version 6, missing
	syntax varlist(min=2 max=2) [if] [in] [fweight] [, Binomial(string) /*
	  */ ADJust(string) Level(cilevel) base(string) noadj]
	
	marksample touse, strok
	tokenize `varlist'
	tempvar d order
	local d ="`1'"
	local e = "`2'"          /* exposure variable */
	capture confirm string variable `2'
	if _rc==0 {
		noi di in red "non numeric variable `2' not allowed"
		exit 198
	}

	/* checks that weight and binomial are not both present */
	if "`binomial'"!="" {
		if "`weight'"!="" {
			di in re "weight not allowed with binomial option"
			exit 198
		}
		else {
			local bin="bin(`binomial')"
		}
	}

	/* chk if response is coded 0/1 for individual or freq records */
	tempvar h
	if "`binomial'" == "" {
		capture assert `d'==0 | `d'==1 if `touse'
                if _rc~=0 {
	   		di in re "Response `1' not coded 0/1"
	   		exit 198
		}
		qui gen int `h'= 1-`d'
	}
	else {
		qui gen int `h' = `binomial' - `d'
	}
 	if "`exp'"!="" {
		local wtopt "[fw `exp']"
	}

	/* puts variables to be controlled for in local macro str */
	if "`adjust'"=="" {
		di in red "must specify adjust() with tabor command"
		exit 198
	}
	
	tempvar pos pos2
	qui egen `pos'=group(`e') if `touse' 
	qui gen `pos2' = `pos'
	qui bys `pos2' (`touse'): replace `pos2'=. if _n~=1
	tempvar grp
	qui egen `grp'=group(`adjust')
	qui sum `pos',mean
	local max=r(max)
	sort `pos2'
	if "`base'"=="" {
		local base=`pos'[1]
	}
	local t2:word count `adjust'

	TITle `t2' `adjust' 
	if  "`adj'"=="" {
		di in gr _n /*
		*/ "Mantel-Haenszel odds ratios adjusted for " in ye r(t2)
	}
	local cil `=string(`level')'
	local cil `=udstrlen("`cil'")'
	if `cil' == 2 {
		local spaces "     "
	}
	else if `cil' == 4 {
		local spaces "   "
	}
	else {
		local spaces "  "
	}
        noi di _n in smcl in gr "{hline 13}{c TT}{hline 61}"
	noi di in smcl in gr %12s abbrev("`2'",12) " {c |} " /*
*/ `" Odds Ratio       chi2       P>chi2`spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
        noi di in smcl in gr "{hline 13}{c +}{hline 61}"
	local label: value label `2'

	local i 1
	while `i'<=`max' {
		local com=`pos'[`i']

		qui mhodds `d' `pos' `grp' `wtopt' if `touse', /*
			*/ `bin' comp(`com' ,`base') level(`level')

		if "`label'"!="" {
			local x = `2'[`i']
			local labx: label `label' `x' 32
			local labx = abbrev(`"`labx'"',9) 
		}
		else local labx : di %9.0g `2'[`i']
		local lng=13-udstrlen("`labx'")
		noi di in smcl in gr _col(`lng') "`labx'" /*
		*/ in gr " {c |}  " /*
        	*/ in ye _col(6) %10.6f r(or) _col(31) %7.2f r(chi2) /*
			*/ _col(45) %5.4f r(p) /*
        		*/ _col(55) %10.6f r(lb_or) _col(66) %10.6f r(ub_or)
		local i=`i'+1
	}
        noi di in smcl in gr "{hline 13}{c BT}{hline 61}"
	qui mhodds `d' `e' `grp' `wtopt' if `touse', /*
			*/ `bin' level(`level')
	if "`adj'"=="" {
		di in gr  "Score test for trend of odds: chi2(" /*
			*/ in ye "1" in gr ")  = " in ye %7.2f r(chi2)
		di in gr _col(31) "Pr>chi2  = " in ye %7.4f r(p)
	 ret scalar chi2  = r(chi2) 
	 ret scalar chi2_p  = r(p) 
	}
end
program define TITle, rclass
	if `1'==1 {
		ret local t2 `2'
		exit
	}
	if `1'==2 {
                ret local t2 "`2' and `3'"
                exit
        }
	local cnt=`1'
	local fi `2'
	mac shift
	local i 2
	while `i'<`cnt' {
		local fi="`fi', `2'"
		local i=`i'+1
		mac shift
	}
	ret local t2 "`fi' and `2'"
end
