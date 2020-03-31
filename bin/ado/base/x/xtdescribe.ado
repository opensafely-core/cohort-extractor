*! version 1.3.4  16feb2015
program define xtdescribe, byable(recall) sortpreserve
	version 6, missing

	syntax [if] [in] [, I(varname) Patterns(integer 9) t(varname) Width(integer 100)]

	if `pattern'<0 { error 198 } 
	if `pattern'>=1000 { local pattern . }

	 _xt, i(`i') t(`t') trequired
	local ivar "`r(ivar)'"
	local tvar "`r(tvar)'"
	local tvar2 `tvar'	// in case we make a temporary tvar
	tempname delta
	scalar `delta' = r(tdelta)

	qui xtset		// to get delta as a nice string
	local deltas `r(tdeltas)'
	tempname tmin
	sca `tmin' = r(tmin)
	
	preserve
	if `delta' != 1 {
		tempname t2
		bysort `ivar' : gen int `t2' = (`tvar'-`tmin')/`delta'
		local tvar `t2'
	}
	
	if `pattern'!=0 {
		capture assert `width'>2
		if _rc {
			di in red "width must be a positive integer greater than 2"
		}
	}
	marksample touse
	qui replace `touse' = 0 if `ivar' == . 
	qui keep if `touse'
	capture quietly tab `tvar'
	if _rc==0 & r(r) < 2 {
		di in red "`tvar' must have multiple distinct nonmissing values"
		exit 459
	}
	
	tempvar id tid marker cum cnt ncnt tot T_i dtv
	tempname val1 val2 valn tval1 tval2 tvaln
	tempname tval12 tval22 tvaln2	// for actual t var. in case tvar temp
	di
	quietly { 
		keep `ivar' `tvar' `tvar2'

					/* get sort tvar out of the way */
		sort `tvar'
		by `tvar': gen int `tid' = 1 if _n==1
		replace `tid' = sum(`tid')
		local T = `tid'[_N]
		summ `tvar', meanonly
		scalar `tval1' = r(min)
		scalar `tvaln' = r(max)
		local span = (r(max) - r(min)) + 1
		summ `tvar' if `tvar'>`tval1', meanonly
		scalar `tval2' = r(min)
		local tv0 = `tval1'
		local tv1 = `tvaln'
		// Do for the real t if we're using a temporary tvar
		if "`tvar'" != "`tvar2'" {
			summ `tvar2'
			scalar `tval12' = r(min)
			scalar `tvaln2' = r(max)
			summ `tvar2' if `tvar' > `tval1', meanonly
			scalar `tval22' = r(min)
		}
		else {
			scalar `tval12' = `tval1'
			scalar `tval22' = `tval2'
			scalar `tvaln2' = `tvaln'
		}
		gen int `dtv'=cond(`tvar'-`tvar'[_n-1]==0,.,`tvar'-`tvar'[_n-1])
		summ `dtv', meanonly
		drop `dtv'
		local dtv = r(min)    
		local dtv1 = r(min)
		if `pattern'!=0 {
			if int((`tvaln'-`tval1')/`dtv') + 1 > `width' {
				local dtv = int((`tvaln'-`tval1')/(`width'-1))
			}
		}
					/* from now on, sorted by ivar tvar */
		sort `ivar' `tvar'
		by `ivar': gen `c(obs_t)' `id' = 1 if _n==1
		replace `id' = sum(`id')
		local n = `id'[_N]
		summ `ivar', meanonly
		scalar `val1' = r(min)    
		scalar `valn' = r(max)    
		summ `ivar' if `ivar'>`val1', meanonly
		scalar `val2' = r(min)     

		by `ivar': gen `c(obs_t)' `T_i' = _N if _n==_N

		local skip = 8 - length("`ivar'")
		noi di in gr _skip(`skip') "`ivar':  " /*
			*/ in ye `val1' in gr ", " in ye `val2' /*
			*/ in gr ", ..., " in ye `valn' in gr /*
			*/ _col(62) "n =" in ye %11.0f `n'

		capture by `ivar' `tvar': assert _N==1
		if _rc { local unique 0 } 
		else 	local unique 1

                local line1
                local line2
                local line3
                PrettyPrintT 	///
                	line1 line2 line3 : `tvar2' `tval12' `tval22' `tvaln2'
                local skip = 8 - length("`tvar2'")
                noi di in gr _skip(`skip') "`tvar2':  "  /*
                        */ in ye "`line1'" _col(62)     /*
                        */ in gr "T =" in ye %11.0f `T'
                if "`line2'" != "" {
                        noi di in ye _col(12) "`line2'"
                }
                if "`line3'" != "" {
                        noi di in ye _col(12) "`line3'"
                }
                noi di in gr _col(12) "Delta(`tvar2') = " in ye "`deltas'"
                noi di in gr _col(12) "Span(`tvar2')  = " 	///
                	in ye `span' " periods"

		if `unique' {
			noi di in gr _col(12) /* 
*/ "(`ivar'*`tvar2' uniquely identifies each observation)"
		}
		else {
			noi di in gr _col(12) /*
*/ "(`ivar'*`tvar2' does not uniquely identify observations)"
		}

		noi di _n in gr "Distribution of T_i:   min      5%     25%       50%       75%     95%     max"

		summ `T_i',  detail 
		noi di in ye _col(21) %6.0f r(min) "  " /* 
			*/ %6.0f r(p5) "  " /*
			*/ %6.0f r(p25) "    " /* 
			*/ %6.0f r(p50) "    " /* 
			*/ %6.0f r(p75) "  " /* 
			*/ %6.0f r(p95) "  " /*
			*/ %6.0f r(max) 

		drop `T_i'

		if `pattern'==0 { exit }

		local l = `tv0' - .5
		local i = 0
		while `l'<`tv1' {
			local u  = `l' + `dtv' 
			gen int _T`++i' = 1 if `l'<`tvar' & `tvar'<=`u'
			by `ivar': replace _T`i' = sum(_T`i')
			local list "`list' _T`i'"
			local l = `l' + `dtv'	
		}
		local nT = `i'
		by `ivar': keep if _n==_N
		keep `list' 
		sort `list'
		by `list': gen `c(obs_t)' `cnt' = _N
		by `list': keep if _n==_N
		gen long `ncnt' = -`cnt'
		sort `ncnt' `list'
		drop `ncnt'
	}

	if `dtv' != 1 {
		local pats "*"
	}
	local dup = max(int((`tv1'-`tv0')/`dtv'+1.5),length("Pattern`pats'"))
	di in smcl in gr _n _col(6) /*
		*/ "Freq.  Percent    Cum. {c |}  Pattern`pats'" _n /*
		*/ " {hline 27}{c +}{c -}{c -}{hline `dup'}"

	gen long `cum' = sum(`cnt') 
	local N = min(_N,`pattern')  
	forvalues i = 1/`N' { 
		di in smcl in ye /*
			*/ %9.0f `cnt'[`i'] %10.2f 100*`cnt'[`i']/`cum'[_N] /*
			*/ %8.2f 100*`cum'[`i']/`cum'[_N] in gr " {c |}  " _c
		forvalues j = 1/`nT' { 
			if _T`j'[`i']==0 { di in ye "." _c }
			else if _T`j'[`i']<=9 { di in ye %1.0f _T`j'[`i'] _c } 
			else 	di in ye "X" _c
		}
		di
	}
	if `N'<_N { 
		di in smcl in ye %9.0f `cum'[_N]-`cum'[`N'] %10.2f /*
		*/ 100*(`cum'[_N]-`cum'[`N'])/`cum'[_N] /*
		*/ %8.2f 100 in gr " {c |} (other patterns)"
	}

	di in smcl in gr " {hline 27}{c +}{c -}{c -}{hline `dup'}"

	forvalues j = 1/`nT' { 
		gen long `tot' = sum(_T`j')
		qui replace _T`j' = cond(`tot'>9,10,`tot')
		drop `tot'
	}
	di in smcl in ye /*
	*/ %9.0f `cum'[_N] %10.2f 100 _skip(8) in gr " {c |}  " _c
	forvalues j = 1/`nT' { 
			if _T`j'[_N]==0 { di in ye "." _c }
/*
			else if _T`j'[_N]<=9 { di in ye %1.0f _T`j'[_N] _c } 
*/
			else 	di in ye "X" _c
	}
	if "`pats'" != "" {
		di in smcl in gr _n " {hline 27}{c BT}{c -}{c -}{hline `dup'}"
		di in smcl " *Each column represents `dtv' periods."
	}
	di
end


program PrettyPrintT

	args	out1		/*	output: macro to hold line 1
	  */	out2		/*	output: macro to hold line 2
	  */	out3		/*	output: macro to hold line 3
	  */	colon		/*	colon
	  */	tvar		/*	input: time variable (to get fmt)
	  */	tval1		/*	input: first period
	  */	tval2		/*	input: second period
	  */	tvaln		/*	input: last period		*/

	local tfmt : format `tvar'

	// First period
	local line1 : di `tfmt' `tval1'
	local line1 `=trim("`line1', ")'

	// Second period
	local per2 : di `tfmt' `tval2'
	local per2 `=trim("`per2'")'
	if length("`line1'") + length("`per2'") < 46 {
		local line1 `line1' `per2', ...,
		local lincnt 1
	}
	else {
		local line2 `per2', ...,
		local lincnt 2
	}
	
	// Last period
	local pern : di `tfmt' `tvaln'
	local pern `=trim("`pern'")'
	
	if length("`line`lincnt''") + length("`pern'") < 50 {
		local line`lincnt' `"`line`lincnt'' `pern'"'
	}
	else {
		local line`lincnt' `"`line`lincnt''"'
		local `++lincnt'
		local line`lincnt' `"`pern'"'
	}
	
	c_local `out1' `line1'
	c_local `out2' `line2' 
	c_local `out3' `line3'
end
