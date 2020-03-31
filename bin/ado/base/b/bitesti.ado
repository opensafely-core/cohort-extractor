*! version 4.2.0  19feb2019
program define bitesti, rclass
	version 6.0, missing
	tempname p kopp pp

/* Parse and check values. */

	parse "`*'", parse(", ")
	local n = `1'
	local k = `2'
	scalar `p' = `3'
	mac shift 3
	local options "XName(string) Detail"
	parse "`*'"

	confirm integer number `n'
	if `n' < 1 { error 2001 } 

	capture confirm integer number `k'
	if _rc { local k = round(`k'*`n',1) }
	if `k'< 0 | `k'>`n' { 
		di in red "number of successes invalid"
		exit 450
	}

	if (`p'<=0 | `p'>=1) { 
		di in red "p invalid"
		exit 450
	}

/* Set up display of `xname'. */

	local col 3

	if "`xname'"!="" {
		local varhead "    Variable {c |}"
		local dashes  "{hline 13}{c +}"
		local xname : di %12s abbrev("`xname'",12) " {c |}"
	}

/* Find kopp which gives k of opposite tail for two-sided p-value. */

	OppoTail `n' `k' `p' `kopp'

/* Print observed and expected k and p. */

	local expk = `n'*`p'
	local obsp = `k'/`n'

	#delimit 
	di in smcl _n in gr "`varhead'" _skip(8)
	   "N   Observed k   Expected k   Assumed p   Observed p"
	   _n "`dashes'{hline 60}" _n "`xname'" in ye 
	   %9.0f `n' %11.0f `k' "    " %9.0g `expk'
	   %14.5f `p' %13.5f `obsp' ;
	#delimit cr

/* Compute and print out one-sided p-values. */

	ret scalar p_u = Binomial(`n',`k',`p')
	ret scalar p_l = Binomial(`n',`n'-`k',1-`p')
	ret scalar N = `n'
	ret scalar P_p = `p'
	ret scalar k = `k'

	if `kopp' == -1 | `kopp' == `n' + 1 { /* empty opposite tail */

		local coleq = `col' + length("`k'") + 10
		di
		DiOne `k' `return(p_u)' `col' `coleq' ">" "one-sided test"
		DiOne `k' `return(p_l)' `col' `coleq' "<" "one-sided test"

		ret scalar k_opp = .

		if `k' > `n'*`p' {
			ret scalar p = return(p_u)
			DiOne `k' `return(p)' `col' `coleq' ">" "two-sided test"
			di in gr _n _col(`col') "note: lower tail of " /*
			*/ "two-sided p-value is empty"
		}
		else {
			ret scalar p = return(p_l)
			DiOne `k' `return(p)' `col' `coleq' "<" "two-sided test"
			di in gr _n _col(`col') "note: upper tail of " /*
			*/ "two-sided p-value is empty"
		}
	}
	else {
		local k1 = min(`k', `kopp')
		local k2 = max(`k', `kopp')
		ret scalar p = min(1, Binomial(`n',`k2',`p') /*
		*/	       + Binomial(`n',`n'-`k1',1-`p'))
		ret scalar k_opp = `kopp'

		local coleq = `col' + length("`k1'`k2'") + 19
		di
		DiOne `k' `return(p_u)' `col' `coleq' ">" "one-sided test"
		DiOne `k' `return(p_l)' `col' `coleq' "<" "one-sided test"

		#delimit ;
		di in gr _col(`col') "Pr(k <= " in ye "`k1'" in gr " or k >= "
		   in ye "`k2'" in gr ")" _col(`coleq') "= "
		   in ye %8.6f return(p) in gr "  (two-sided test)" ;
		#delimit cr
	}

	if "`detail'"!="" {
		BiDens `n' `k' `p' `pp'
		ret scalar P_k = `pp'
		di
		DiOne `k' `return(P_k)' `col' `coleq' "=" "observed"

		if return(k_opp) < . {
			local k1 = return(k_opp) - sign(return(k_opp) - `k')

			if `k1'!=`k' & `k1'!= return(k_opp) { 
				ret scalar k_nopp = `k1'
			}
		}
		else {
			if `kopp' == -1 { ret scalar k_nopp = 0 }
			else if `kopp' == `n' + 1 { ret scalar k_nopp = `n' }
		}
		if "`return(k_nopp)'"!="" {
			BiDens `n' `return(k_nopp)' `p' `pp'
			ret scalar P_noppk = `pp'
			DiOne `return(k_nopp)' `return(P_noppk)' `col' /*
				*/ `coleq' "="
		}
		if return(k_opp)<. {
			BiDens `n' `return(k_opp)' `p' `pp'
			ret scalar P_oppk = `pp'
			DiOne `return(k_opp)' `return(P_oppk)' `col'  /*
				*/ `coleq' "=" "opposite extreme"
		}
	}

	/* double save S_# and r()  */
	global S_1 "`return(p_u)'"     /* upper one-sided p-value  */
	global S_2 "`return(p_l)'"     /* lower one-sided p-value  */
	global S_3 "`return(p)'"       /* two-sided p-value        */
	global S_4 "`return(P_k)'"     /* p observed (detail only) */
	global S_5 "`return(P_oppk)'"  /* p opposite tail (detail) */
	global S_6 "`return(P_noppk)'" /* p next opposite (detail) */
	global S_7 "`return(N)'"       /* number of trials	   */
	global S_8 "`return(P_p)'"     /* assumed p trial          */
	global S_9 "`return(k)'"       /* observed k               */
	global S_10 "`return(k_opp)'"  /* opposite-tail k          */
	global S_11 "`return(k_nopp)'" /* next opposite k (detail) */
end

program define DiOne
	version 6.0, missing
	local k     "`1'"
	local pval  "`2'"
	local col   "`3'"
	local coleq "`4'"
	local sign  "`5'"
	local note  "`6'"

	di in gr _col(`col') "Pr(k `sign'= " in ye "`k'" in gr ")" /*
	*/ _col(`coleq') "= " in ye %8.6f `pval' _c
	
	if "`note'"!="" {
		di in gr "  (`note')"
	}
	else	di
end

program define OppoTail
	version 6.0, missing
	local n    "`1'"	/* Input:  n (literal)			*/
	local kobs "`2'"	/* Input:  k observed (literal)		*/
	local pin  "`3'"	/* Input:  p trial assumed (scalar)	*/
	local kopp "`4'"	/* Output: k opposite tail (scalar)	*/

/* This routine finds kopp on opposite tail such that Pr(X==kopp +/- 1) > pobs
   and Pr(X==kopp) <= pobs, where pobs = Pr(X==kobs) and +/- is taken to be
   toward the center (n*p).
*/
	tempname pobs popp p p1 lo hi
	local eps 1e-7
	local itmax 100

/* If pin = 0.5, it is symmetric. */

	if abs(`pin'-0.5) < `eps' {
		scalar `kopp' = `n' - `kobs'
		exit
	}

/* Compute pobs = Pr(X==kobs). */

	tempname pobs popp p p1 lo hi
	local eps 1e-7
	local itmax 100

	LnBiDens `n' `kobs' `pin' `pobs'

	local peps = `pobs'*`eps'

/* Arrange things so that opposite tail is upper tail. */

	if `kobs' > `n'*`pin' {
		scalar `p' = 1 - `pin'
		local k = `n'-`kobs'
	}
	else {
		scalar `p' = `pin'
		local k = `kobs'
	}

/* Compute bounds. */

	scalar `lo' = int(`n'*`p'+`eps')
	if `k'==`lo' {
		LnBiDens `n' `k'+1 `p' `popp'
		if `popp' >= `pobs' - `peps' {
			if `kobs' > `n'*`pin' {
				scalar `kopp' = `n' - `k' - 1
			}
			else	scalar `kopp' = `k' + 1
			exit
		}
		scalar `lo' = `k' + 1
	}
	scalar `hi' = `n'

/* Initial guess for `kopp'. */

	scalar `kopp' = round(2*`n'*`p'-`k', 1)
	scalar `popp' = 2

/* Search for `kopp'. */

	local i 0
	while `i' <= `itmax' {
		Step `p1' `popp' `kopp' `lo' `hi' `pobs' `n' `p'

		if `p1'<`pobs' & `popp'>=`pobs'-`peps' {
			if `kobs' > `n'*`pin' {
				scalar `kopp' = `n' - `kopp'
			}
			exit
		}
		local i = `i' + 1
	}

/* ERROR if here.  It could not find other tail. */

	scalar `kopp' = .
end

program define BiDens /* Returns scalar pout = Pr(Bin(n,p)==k). */
	version 6.0, missing
	local n    "`1'"
	local k  =  `2'
	local p    "`3'"
	local pout "`4'"

	if `k' < 0 | `k' > `n' {
		scalar `pout' = 0 /* important for empty tail return */
		exit
	}
	if `k' > `n'*`p' {
		scalar `pout' = Binomial(`n',`k',`p') /*
		*/      - cond(`k'<`n', Binomial(`n',`k'+1,`p'), 0)
		exit
	}
	scalar `pout' = Binomial(`n',`n'-`k',1-`p') /*
	*/      - cond(`k'>0, Binomial(`n',`n'-`k'+1,1-`p'), 0)
end

program define LnBiDens /* Returns scalar pout = -ln(Pr(Bin(n,p)==k). */
	version 6.0, missing
	local n    "`1'"
	local k  =  `2'
	local p    "`3'"
	local pout "`4'"

	if `k' < 0 | `k' > `n' {
		scalar `pout' = . /* important for empty tail return */
		exit
	}

	scalar `pout' = -lnfact(`n') + lnfact(`k') + lnfact(`n'-`k') /*
	*/ 		- `k'*ln(`p') - (`n'-`k')*ln1m(`p')

*di "k = `k'   pout = " %24.15e `pout'

end

program define Step
	version 6.0, missing
	local p1   "`1'"	/* p1 = Pr(X==k2-1)			*/
	local p2   "`2'"	/* p2 = Pr(X==k2)			*/
	local k2   "`3'"	/* k2 = X value for opposite tail	*/ 
	local lo   "`4'"	/* lo = lower bound for k2		*/
	local hi   "`5'"	/* hi = upper bound for k2		*/
	local pobs "`6'"	/* pobs = Pr(X==kobs)			*/
	local n    "`7'"	/* n = # of trials			*/
	local p    "`8'"	/* p = Pr(one trial == 1)		*/

/* This routine tries to find k2 such that p1 > pobs and p2 <= pobs. */

	if `p2'==2 { /* use initial guess */
		local k = `k2'
	}
	else { /* linear interpolation for `k' that gives `pobs' */

		local k = round(`k2' - (`p2'-`pobs')/(`p2'-`p1'), 1)
	}

	if      `k' < `lo' { local k = `lo' }
	else if `k' > `hi' { local k = `hi' }  /* handles `k' missing */

	LnBiDens `n' `k' `p' `p1'

*di "k = `k'   p1 = " %24.15e `p1' "   pobs = " %24.15e `pobs'

	if `p1' < `pobs' {
		scalar `k2' = `k' + 1
		scalar `lo' = `k2'
		LnBiDens `n' `k2' `p' `p2'
		exit
	}

	scalar `k2' = `k'
	scalar `hi' = `k2' - 1
	scalar `p2' = `p1'
	LnBiDens `n' `k2'-1 `p' `p1'
end
