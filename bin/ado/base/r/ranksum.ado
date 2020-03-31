*! version 2.5.1  10sep2019
program define ranksum, rclass byable(recall)
	version 6, missing
	
	syntax varname [if] [in], BY(varname) [ PORDER NOEXACT EXACT ]
	
	local NEXACT   200
	local MAXEX   1000	
/*
	For r(N) <= `NEXACT', specifying nothing implies option -exact-.
	For r(N) >  `NEXACT', specifying nothing implies -noexact-.
*/	
	if ("`exact'" != "" & "`noexact'" != "") {
		opts_exclusive "exact noexact"
	}

	local origby "`by'"
	capture confirm numeric variable `by'
	if _rc {
		tempvar numby
		encode `by', generate(`numby')
		local by "`numby'"
	}
	marksample touse
	markout `touse' `by'

	local x `varlist'
	tempname g1 g2 w1 v unv z p p_l p_u
	tempvar ranks
	quietly {
		summarize `by' if `touse', meanonly
		if r(N) == 0 { noisily error 2000 }
		if r(min) == r(max) {
			di in red `"1 group found, 2 required"'
			exit 499
		}
		local n = r(N)   
		scalar `g1' = r(min)    
		scalar `g2' = r(max) 

		count if `by'!=`g1' & `by'!=`g2' & `touse'
		if r(N) != 0 {
			di in red `"more than 2 groups found, only 2 allowed"'
			exit 499
		}
		
		/* Determine EXACT option default conditional on sample size. 
		 */
		
		if (`n' <= `NEXACT' & "`noexact'" == "") {
			local exact exact
		}
		
		if ("`exact'" != "" & `n' > `MAXEX') {
			di in smcl as error /*
			*/ "number of observations must be <= " /*
			*/ %5.0fc `MAXEX' " for {bf:exact} option"
			exit(459)
		}

		egen double `ranks' = rank(`x') if `touse'

		summarize `ranks' if `by'==`g1' & `touse', meanonly
		local   n1   = r(N)
		scalar `w1'  = r(sum)

		summarize `ranks' if `touse'
		local   n    = r(N)
		local   n2   = `n' - `n1'
		scalar `v'   = `n1'*`n2'*r(Var)/`n'
		scalar `unv' = `n1'*`n2'*(`n'+1)/12
		scalar `z'   = (`w1'-`n1'*(`n'+1)/2)/sqrt(`v')
		scalar `p'   = 2*normprob(-abs(`z'))
		scalar `p_l' = normprob(`z')
		scalar `p_u' = normprob(-`z')
		
		if ("`exact'" != "") {
			
			/* Ranks if noninteger must be made into integers. */
			
			cap assert `ranks' == int(`ranks') if `touse' 
			if (_rc) {
				replace `ranks' = round(2*`ranks') if `touse'
			}
			
			mata: ranksum_exact("`ranks' `by'", "`touse'")
		}			
	}

	local holdg1 = `g1' 
	local g1 = `g1'
	local g2 = `g2'

	local valulab : value label `by'
	if `"`valulab'"'!=`""' {
		local g1 : label `valulab' `g1'
		local g2 : label `valulab' `g2'
	}

	local by "`origby'"
	di in gr _n `"Two-sample Wilcoxon rank-sum (Mann-Whitney) test"' _n
	di in smcl in gr %12s abbrev(`"`by'"',12) /*
		*/ " {c |}      obs    rank sum    expected"
	di in smcl in gr "{hline 13}{c +}{hline 33}"
	ditablin `"`g1'"' `n1' `w1' `n1'*(`n'+1)/2
	ditablin `"`g2'"' `n2' `n'*(`n'+1)/2-`w1' `n2'*(`n'+1)/2
	di in smcl in gr "{hline 13}{c +}{hline 33}"
	ditablin combined `n' `n'*(`n'+1)/2 `n'*(`n'+1)/2

	if `unv' < 1e7 { local vfmt `"%10.2f"' }
	else             local vfmt `"%10.0g"'

	local xab = abbrev("`x'",8)
	local byab = abbrev("`by'",8)
	#delimit ;
	di in smcl in gr _n `"unadjusted variance"' _col(22)
	   in ye `vfmt' `unv' _n
	   in gr `"adjustment for ties"' _col(22)
	   in ye `vfmt' `v'-`unv' _n
	   in gr _col(22) "{hline 10}" _n
	   in gr `"adjusted variance"' _col(22)
	   in ye `vfmt' `v' _n(2)
	   in gr `"Ho: `xab'(`byab'==`g1') = `xab'(`byab'==`g2')"' _n
	   in gr _col(14) `"z = "'
	   in ye %7.3f `z' _n
	   in gr _col(5) `"Prob > |z| = "'
	   in ye %8.4f `p' ;
	#delimit cr

	if ("`exact'" != "") {
		ret add
		di in smcl in gr _col(5) "Exact Prob = " /*
		*/ in ye %8.4f return(p_exact)
	}
	else if ("`noexact'" == "" & `n' > `NEXACT' & `n' <= `MAXEX') {
		di _n in smcl as text /*
		*/ "Note: Exact p-value is not computed by default for " /*
		*/ "sample sizes >" %4.0f `NEXACT' "." _n     /*
                */ "      Use option {bf:exact} to compute it."
	}
	
	return scalar  p_u     = `p_u'
	return scalar  p_l     = `p_l'
	return scalar  p       = `p'
	return scalar  z       = `z'
	return scalar  Var_a   = `v'
	return scalar  sum_exp = `n1'*(`n'+1)/2
	return scalar  sum_obs = `w1'
	return scalar  group1  = `holdg1' 
	return scalar  N_2     = `n2'
	return scalar  N_1     = `n1'
	return scalar  N       = `n'

	if "`porder'" == "porder" {
		tempname porder
		scalar `porder' = (`w1'-`n1'*(`n1'+1)/2)/(`n1'*`n2')
		return scalar porder = `porder'
		di _n in smcl as text /*
		  */ `"P{`xab'(`byab'==`g1') > `xab'(`byab'==`g2')} = "' /*
		        */ as result %4.3f `porder' 
	}
	/* Double saves */

	global S_1 "`return(group1)'"
	global S_2 "`return(sum_obs)'"
	global S_3 "`return(sum_exp)'"
	global S_4 "`return(z)'"
	global S_5 "`return(Var_a)'"
	global S_6 "`return(N_1)'"
	global S_7 "`return(N_2)'"
end

program define ditablin
	if length(`"`1'"') > 12 {
		local 1 = substr(`"`1'"',1,12)
	}
        #delimit ;
        di in smcl in gr %12s `"`1'"' " {c |}" in ye
                _col(17) %7.0g `2'
                _col(26) %10.0g `3'
                _col(38) %10.0g `4' ;
        #delimit cr
end

version 16.0
mata:

void ranksum_exact(string scalar varnames, string scalar tousename)
{
	real matrix     x
	real rowvector  p
	
	st_view(x=., ., varnames, tousename) 
	
	p = randomization_t_two_sample(x, 2)
	
	st_rclear()
	st_numscalar("r(p_u_exact)", p[3])
	st_numscalar("r(p_l_exact)", p[2])
	st_numscalar("r(p_exact)",   p[1])
}

end
