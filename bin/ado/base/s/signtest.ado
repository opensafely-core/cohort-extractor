*! version 2.3.14  15dec2017
program define signtest, rclass byable(recall)
	version 6, missing
	syntax varlist =/exp [if] [in]
	tempname pp pn p2
	tempvar touse sign
	quietly {
		mark `touse' `if' `in'
		gen byte `sign' = sign(`varlist'-(`exp')) if `touse'
		markout `touse' `sign'

		count if `sign' == 1 & `touse'
		local np = r(N)

		count if `sign' == -1 & `touse'
		local nn = r(N)

		count if `sign' == 0 & `touse'
		local n0 = r(N)

		local ns = `np' + `nn'

		scalar `pp' = Binomial(`ns', `np', 0.5)
		scalar `pn' = Binomial(`ns', `nn', 0.5)
		scalar `p2' = min(1, 2*min(`pp', `pn'))
		local   max = max(`np', `nn')
	}

	if `"`exp'"'==`"0"' {
		local ho  = abbrev("`varlist'",10) + " = 0"
		local har = abbrev("`varlist'",10) + " > 0"
		local hal = abbrev("`varlist'",10) + " < 0"
		local ha2 = abbrev("`varlist'",10) + " != 0"
	}
	else {
		local ho  = abbrev("`varlist'",10) + " - `exp' = 0"
		local har = abbrev("`varlist'",10) + " - `exp' > 0"
		local hal = abbrev("`varlist'",10) + " - `exp' < 0"
		local ha2 = abbrev("`varlist'",10) + " - `exp' != 0"
	}

	di _n in gr `"Sign test"' _n
	di in smcl in gr `"        sign {c |}    observed    expected"'
	di in smcl in gr "{hline 13}{c +}{hline 24}"
	ditablin positive `np' `ns'/2
	ditablin negative `nn' `ns'/2
	ditablin zero     `n0' `n0'
	di in smcl in gr "{hline 13}{c +}{hline 24}"
	ditablin all `ns'+`n0' `ns'+`n0'

        #delimit ;
	di in gr _n `"One-sided tests:"' _n
	         `"  Ho: median of `ho' vs."' _n
		 `"  Ha: median of `har'"' _n
	         _col(7) `"Pr(#positive >= "' in ye `"`np'"' in gr `") ="' _n
		 _col(10) `"Binomial(n = "' in ye `ns' in gr `", x >= "'
	   in ye `np' in gr `", p = 0.5) = "'
	   in ye %7.4f `pp' _n ;

	di in gr `"  Ho: median of `ho' vs."' _n
		 `"  Ha: median of `hal'"' _n
	         _col(7) `"Pr(#negative >= "' in ye `"`nn'"' in gr `") ="' _n
		 _col(10) `"Binomial(n = "' in ye `ns' in gr `", x >= "'
	   in ye `nn' in gr `", p = 0.5) = "'
	   in ye %7.4f `pn' _n ;

	di in gr `"Two-sided test:"' _n
	         `"  Ho: median of `ho' vs."' _n
		 `"  Ha: median of `ha2'"' _n
	         _col(7) `"Pr(#positive >= "' in ye `"`max'"'
	   in gr `" or #negative >= "' in ye `"`max'"' in gr `") ="' _n
	         _col(10) `"min(1, 2*Binomial(n = "' in ye `ns'
	   in gr `", x >= "' in ye `max' in gr `", p = 0.5)) = "'
	   in ye %7.4f `p2' ;
	#delimit cr

	ret scalar p_u   = `pp'
	ret scalar p_l   = `pn'
	ret scalar p     = `p2'
	ret scalar N_tie = `n0'
	ret scalar N_neg = `nn'
	ret scalar N_pos = `np'
	ret scalar N     = `np' + `nn' + `n0'
	
	ret historical(16) scalar p_neg = `pn' 
	ret historical(16) scalar p_pos = `pp' 
	ret historical(16) scalar p_2   = `p2'	

	/* Double saves. */

	global S_1 `return(N_pos)'
	global S_2 `return(N_neg)'
	global S_4 `return(p_2)'
	global S_6 `return(N_tie)'

	 /* S_3 always contains smallest one-sided p-value. */

	if return(p_neg) < return(p_pos) {
		global S_3 = return(p_neg)
		global S_5 = return(p_pos)
	}
	else {
		global S_3 = return(p_pos)
		global S_5 = return(p_neg)
	}
end

program define ditablin
        #delimit ;
        di in smcl in gr %12s `"`1'"' " {c |}" in ye
                _col(17) %10.0g `2'
                _col(29) %10.0g `3' ;
end ;
