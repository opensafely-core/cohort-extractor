*! version 1.4.2  24mar2008
program define ml_adjs, rclass
	version 7
	args caller i fpout fmout x0

/* Get `h' and initial `S' */

	tempname h

	if "`caller'" == "e0" {
		local epsf 1e-3
		scalar `h' = (abs($ML_b[1,`i'])+`epsf')*`epsf'
		tempname S
		scalar `S' = ML_d0_S[1,`i']
	}
	else if "`caller'" == "elf" {
		local epsf  1e-4
		if `"$ML_mlsc"' == "" {
			qui summarize `x0' [aw=$ML_w]
			scalar ${ML_hn`i'} = (abs(r(mean))+`epsf')*`epsf'
			local h ${ML_hn`i'}
		}
		else {
			local h ${ML_hn`i'}
		}
		local S ${ML_tn`i'}
	}
	else if "`caller'" == "erd" {
		local epsf 1e-3
		scalar `h' = (abs($ML_b[1,`i'])+`epsf')*`epsf'
		tempname S
		scalar `S' = ML_d0_S[1,`i']
	}

/* Compute optimal value of `S'. */

	if "$ML_mlsc" != "" {
		GetStep4Scores `h' `S' `0'
	}
	else if "$ML_brack" == "" {
		GetStep `h' `S' `0'
	}
	else	GetSBrac `h' `S' `0'

	if "`caller'" == "e0" | "`caller'" == "erd" {
		mat ML_d0_S[1,`i'] = `S'  /* save `S' */
	}

	return scalar step = float(`h'*`S')
end

// Only called by -ml score-, everything should be as it was when -ml-
// converged to the solution.
program define GetStep4Scores
	args h S caller i fpout fmout x0
	macro shift 7
	local list "`*'"

	tempname fm fp

	Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'

	Lik`caller' `h'*`S' `i' `fp' `fpout' `x0' `list'
end

program define GetStep
	args h S caller i fpout fmout x0
	macro shift 7
	local list "`*'"

	tempname S0 fm fm0 fp goal0 goal1 mingoal Sold1 Sold2 df dfold1 dfold2

/* Stepsize parameters (also see TwoStep program below): */

	local ep0   1e-8
	local ep1   1e-7
	local epmin 1e-10
	local itmax 20

	if ("`caller'$ML_00_S" == "e0" | "`caller'" == "erd" ) {
		if "$ML_ep0m" == "" {
			if "$ML_ic" == "0" {
				local ep0 1e-4
				local ep1 1e-3
			}
		}
		else {
			if "$ML_ep1m" != "" & "$ML_ic" != "0" {
				local epmin	$ML_ep1m
				local ep0	$ML_ep10
				local ep1	$ML_ep11
			}
			else {
				local epmin	$ML_ep0m
				local ep0	$ML_ep00
				local ep1	$ML_ep01
			}
		}
	}

	scalar `goal0'   = (abs(scalar($ML_f))+`ep0')*`ep0'
	scalar `goal1'   = (abs(scalar($ML_f))+`ep1')*`ep1'
	scalar `mingoal' = (abs(scalar($ML_f))+`epmin')*`epmin'


/* Get initial value of fm = f(X-h*S). */

	Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'

	if `fm'==. {
		MisStep `0'
		exit
	}

/* Save initial values of S and fm. */

	scalar `S0' = `S'
	scalar `fm0' = `fm'

/* Compute df.  We want goal0 <= df <= goal1. */

	scalar `df' = abs(scalar($ML_f)-`fm')

	scalar `Sold1' = 0
	scalar `Sold2' = .
	scalar `dfold1' = 0
	scalar `dfold2' = .
	local iter 1

	while (`df'<`goal0' | `df'>`goal1') & `iter'<=`itmax' {

		GetS `mingoal' `goal0' `goal1' `S' `df' /* interpolate ...
		*/ `Sold1' `dfold1' `Sold2' `dfold2'

		scalar `Sold2' = `Sold1'
		scalar `dfold2' = `dfold1'
		scalar `Sold1' = `S'
		scalar `dfold1' = `df'

		scalar `S' = r(S)

		Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'

		if `fm'==. {
			MisStep `0'
			exit
		}

		scalar `df' = abs(scalar($ML_f)-`fm')
		local iter = `iter' + 1
	}

	if `df'<`goal0' | `df'>`goal1' { /* did not meet goal */
		scalar `S' = `S0'	 /* go back to initial values */
		scalar `fm' = `fm0'	 /* guaranteed to be nonmissing */
	}

	Lik`caller' `h'*`S' `i' `fp' `fpout' `x0' `list'

	if `fp'==. {
		MisStep `0'
		exit
	}

	if `df'<`goal0' | `df'>`goal1' { /* did not meet goal; we redo
					    stepsize adjustment looking at
					    both sides; starting values are
					    guaranteed to be nonmissing
					 */

		TwoStep `fp' `fm' `0'
	}
end


/* Use a bracketed quadratic and bisection search to find an optimal 
 * delta for the derivatives. */

program define GetSBrac
	args h S caller i fpout fmout x0
	macro shift 7
	local list "`*'"

	tempname S0 fm fm0 fp ctrstep

/* Stepsize parameters (also see TwoStep program below): */

	local ep0	1e-8
	local ep1	1e-7
	local epmin	1e-10
	local magstep	3
	sca `ctrstep'	= 1 / `magstep'
	local maxmag	100
	local itmax	20

/*
	if $ML_ic<99 & ("`caller'"=="e0" | "`caller'"=="erd" ) {
		local ep0 1e-4
		local ep1 1e-3
	}
*/

	local goal0   = (abs(scalar($ML_f))+`ep0')*`ep0'
	local goal1   = (abs(scalar($ML_f))+`ep1')*`ep1'
	local mingoal = (abs(scalar($ML_f))+`epmin')*`epmin'


 	tempname s1 s2 s3 df1 df2 df3 df

/* Get initial value of fm = f(X-h*S). */

	Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'
	if `fm'==. {
		MisStep `0'
		exit
	}

/* Compute initial df.  We want goal0 <= df <= goal1. */
	scalar `df' = abs(scalar($ML_f)-`fm')

/* See if we are in range, if not fill a held point */
	if `df' >= `goal0' & `df' <= `goal1' {
		Lik`caller' `h'*`S' `i' `fp' `fpout' `x0' `list'
		exit
	}

/* Save initial values of S and fm. */

	scalar `S0' = `S'
	scalar `fm0' = `fm'

/* Bracket the mid-point of the target range.
 * If we hit the range, we are done */

	scalar `s3' = 0				/* (0,0) is a fine point */
	scalar `df3' =  0			/* on the delta/delta fn */

	scalar `s2' = `S'			/* so is the current point */
	scalar `df2' =  `df'

	local brdone 0
	local midgoal = (`goal0' + `goal1') / 2

	if `df' < `goal0' {
		scalar `S' = `magstep' * `S'			/* step */
	}
	else	scalar `S' = `S' / `magstep'

	Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'
	if `fm'==. {
		MisStep `0'
		exit
	}
	scalar `df' = abs(scalar($ML_f)-`fm')
	scalar `s1' = `S'
	scalar `df1'= `df'


	local swapi 3
	local iter 1
	while (`df'<`goal0' | `df'>`goal1') & `iter'<=`itmax' {

		SolvStep `S' : `midgoal' `s1' `df1' `s2' `df2' `s3' `df3'  /*
			*/ `ctrstep'
		Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'

		if `fm'==. {
			MisStep `0'
			exit
		}

		scalar `df' = abs(scalar($ML_f)-`fm')

		scalar `df`swapi'' = `df'
		scalar `s`swapi'' = `S'

		local swapi = mod(`swapi', 3) + 1
		local iter = `iter' + 1
	}

	if `df'<`goal0' | `df'>`goal1' { /* did not meet goal */
		scalar `S' = `S0'	 /* go back to initial values */
		scalar `fm' = `fm0'	 /* guaranteed to be nonmissing */
	}

	Lik`caller' `h'*`S' `i' `fp' `fpout' `x0' `list'

	if `fp'==. {
		MisStep `0'
		exit
	}

	if `df'<`goal0' | `df'>`goal1' { /* did not meet goal; we redo
					    stepsize adjustment looking at
					    both sides; starting values are
					    guaranteed to be nonmissing
					 */

		TwoStep `fp' `fm' `0'
	}
end

program define MisStep	/* This routine is called if missing values were
			   encountered in GetStep.
			*/

	/* di "in MisStep!"  */					/* diag */
	args h S caller i fpout fmout x0
	macro shift 7
	local list "`*'"

	local itmax 50

	tempname fm fp
	scalar `fm' = .
	scalar `fp' = .
	local iter 1
	while (`fm'==. | `fp'==.) & `iter'<=`itmax' {
		scalar `S' = `S'/2

		Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'

		if `fm'!=. {
			Lik`caller' `h'*`S' `i' `fp' `fpout' `x0' `list'
		}

		local iter = `iter' + 1
	}

	if `fm'==. | `fp'==. {
		di as err "could not calculate numerical derivatives" _n /*
		*/ "discontinuous region with missing values encountered"
		exit 430
	}

	TwoStep `fp' `fm' `0'
end

program define TwoStep	/* This routine is called if

				(1) goal was not reached, or

				(2) missing values were encountered
				    and MisStep then found nonmissing
				    values.

			   Note: Input is guaranteed to be nonmissing
			         on both sides.
			*/

	/* di "in two-step"  */					/* diag */
	args fp fm h S caller i fpout fmout x0
	macro shift 9
	local list "`*'"

	tempname bestS bestdf goal0 goal1 mingoal Sold1 Sold2 df dfold1 dfold2

	local ep0   1e-8
	local ep1   1e-7
	local epmin 1e-12
	local itmax 40

	scalar `goal0'   = (abs(scalar($ML_f))+`ep0')*`ep0'
	scalar `goal1'   = (abs(scalar($ML_f))+`ep1')*`ep1'
	scalar `mingoal' = (abs(scalar($ML_f))+`epmin')*`epmin'

	scalar `df' = (abs(scalar($ML_f)-`fp')+abs(scalar($ML_f)-`fm'))/2
	scalar `bestdf' = `df'
	scalar `bestS' = `S'
	scalar `Sold1' = 0
	scalar `Sold2' = .
	scalar `dfold1' = 0
	scalar `dfold2' = .
	local iter 1

	while (`df'<`goal0' | `df'>`goal1') & `iter'<=`itmax' {

*di "TwoStep   iter = `iter'   df = " %12.4e `df' "   S = "  %12.3e `S'

		GetS `mingoal' `goal0' `goal1' `S' `df' /* interpolate ...
		*/ `Sold1' `dfold1' `Sold2' `dfold2'

		scalar `Sold2' = `Sold1'
		scalar `dfold2' = `dfold1'
		scalar `Sold1' = `S'
		scalar `dfold1' = `df'

		scalar `S' = r(S)

		Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'

		if `fm'!=. {
			Lik`caller' `h'*`S' `i' `fp' `fpout' `x0' `list'
		}
		if `fm'==. | `fp'==. {
			if `bestdf' >= `mingoal' { /* go with best value */
			    scalar `S' = `bestS'
			    Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'
			    Lik`caller'  `h'*`S' `i' `fp' `fpout' `x0' `list'

			    di as txt /*
			    */ "numerical derivatives are approximate" /*
			    */ _n "nearby values are missing"
			    exit
			}

			di as err /*
			*/ "could not calculate numerical derivatives" /*
			*/ _n "missing values encountered"
			exit 430
		}

		local df = (abs(scalar($ML_f)-`fp')+abs(scalar($ML_f)-`fm'))/2

		if `df'>1.1*`bestdf' | (`df'>=0.9*`bestdf' & `S'<`bestS') {
			scalar `bestdf' = `df'
			scalar `bestS' = `S'
		}

		local iter = `iter' + 1
	}

*di "TwoStep   iter = `iter'   df = " %12.4e `df' "   S = "  %12.3e `S'

	if `df'<`goal0' | `df'>`goal1' { /* did not reach goal */

		if `bestdf' >= `mingoal' { /* go with best value */
			scalar `S' = `bestS'
			Lik`caller' -`h'*`S' `i' `fm' `fmout' `x0' `list'
			Lik`caller'  `h'*`S' `i' `fp' `fpout' `x0' `list'

			di as txt "numerical derivatives are approximate" /*
			*/ _n "flat or discontinuous region encountered"
		}
		else {
			di as err "could not calculate numerical derivatives" /*
			*/ _n "flat or discontinuous region encountered"
			exit 430
		}
	}
end

program define Likelf
	args delta i fscal fvar x0
	macro shift 5
	local xi : word `i' of `*'

	capture drop `fvar'
	capture drop `xi'

	quietly {
		gen double `xi' = `x0' + float(`delta')
		gen double `fvar' = . in 1
	}

	$ML_vers $ML_user `fvar' `*'

	mlsum `fscal' = `fvar'
	ml_count_eval `fscal' result
/*
	The following line is removed because mlsum handles overflows and 
	underflows
	if !(`fscal' > -1e300 & `fscal' < 1e300) { scalar `fscal' = .  }
*/
end

program define Like0
	args delta i f fout
	tempname bb t1 t2
	mat `bb' = $ML_b
	mat `bb'[1,`i'] = $ML_b[1,`i'] + float(`delta')

	$ML_vers $ML_user 0 `bb' `f' `t1' `t2' $ML_sclst
	ml_count_eval `f' result

	scalar `fout' = `f'
end

program define Likerd
	args delta i ll llvar

	tempname bb t1 t2
	mat `bb' = $ML_b
	mat `bb'[1,`i'] = $ML_b[1,`i'] + float(`delta')

	capture drop `llvar'
	qui gen double `llvar' = . in 1 

	$ML_vers $ML_user 0 `bb' `llvar'
	mlsum `ll' = `llvar'
	ml_count_eval `ll' result
/*
	The following line is removed because mlsum handles overflows and 
	underflows
	if !(`ll' > -1e300 & `ll' < 1e300) { scalar `ll' = .  }
*/
end



program define GetS, rclass
	args mingoal goal0 goal1 S df Sold1 dfold1 Sold2 dfold2

	if `df' < `mingoal' {
	/* di "GetS: below mingoal, doubling S --> 2*S" */	/* diag */
		return scalar S = 2*`S'
		exit
	}

/* Interpolate to get f(newS)=mgoal.

   When `Sold2' and `dfold2' are empty (on the first iteration), we do
   linear interpolation of f(S)=df, f(0)=0.

   Thereafter, we do quadratic interpolation with the current and previous
   two positions.
*/
	tempname newS mgoal
	scalar `mgoal' = (`goal0' + `goal1')/2

	Intpol `newS' `mgoal' `S' `df' `Sold1' `dfold1' `Sold2' `dfold2'

	if `newS'==. | `newS'<=0  | (`df'>`goal1' & `newS'>`S') /*
	*/                        | (`df'<`goal0' & `newS'<`S') {

		return scalar S = `S'*cond(`df'<`goal0',2,.5)
	}
	else	return scalar S = `newS'
end

program define Intpol
	args y x y0 x0 y1 x1 y2 x2

	if "`y2'"=="" { local linear 1 }
	else if `y2'==. | `x2'==. { local linear 1 }

	if "`linear'"!="" {
		scalar `y' = ((`y1')-(`y0'))*((`x')-(`x0'))/((`x1')-(`x0')) /*
		*/           + (`y0')
		exit
	}

	scalar `y' = /*
*/   (`y0')*((`x')-(`x1'))*((`x')-(`x2'))/(((`x0')-(`x1'))*((`x0')-(`x2'))) /*
*/ + (`y1')*((`x')-(`x0'))*((`x')-(`x2'))/(((`x1')-(`x0'))*((`x1')-(`x2'))) /*
*/ + (`y2')*((`x')-(`x0'))*((`x')-(`x1'))/(((`x2')-(`x0'))*((`x2')-(`x1')))
end

program define SolvStep
	args x colon f x1 f1 x2 f2 x3 f3 cont_rt

	SolvQuad `x' : `f' `x1' `f1' `x2' `f2' `x3' `f3'

	if `x' == . {		/* No quadratic solution, try linear */
		scalar `x' = ((`x3'-`x1') / (`f3'-`f1')) * (`f' - `f1') + `x1'
	/* di "Step:  quadratic ng, doing linear extrap/interp" */  /* diag */
	}

	if `x' <= 0 | `x' == . { /* negative delta not allowed, contract */
		tempname minx maxx
		scalar `minx' = `cont_rt' * min(min(`x1', `x2'), `x3') 
		if `minx' > 1e-12 {
			scalar `x' = `minx' * `cont_rt'
		}
		else {	
			scalar `maxx' = `cont_rt' * max(max(`x1', `x2'), `x3') 
			scalar `x' = `maxx'*`cont_rt' + (1-`cont_rt')*`minx'
		}
			/* added 1e... is to prevent duplicates */
		scalar `x' = `x' + 1e-6*`x1' + 1e-6*`x2' + 1e-6*`x3'
/*di "Step:  quadratic or linear gave negative delta, contracting" */ /* diag */
	}
end


program define SolvQuad			/* may return . ==> no solution */
	args x colon f x1 f1 x2 f2 x3 f3

/* We want the best local quadratic solution.  While we know the function goes
 * through (0,0) we may be nowhere near that region. */

	tempname X y b c

	scalar `x' = .

	capture mat `X' = ( 1 , `x1' , `x1'^2 \		/*
	*/		    1 , `x2' , `x2'^2 \		/*
	*/		    1 , `x3' , `x3'^2		/*
	*/		  )

	if _rc { exit }
		

	capture mat `y' = ( `f1' \ `f2' \ `f3' )
	if _rc { exit }

	capture mat `b' = inv(`X') * `y'
	if _rc { exit }
	scalar `c' = `b'[1,1] - `f'

	scalar `x' = (-`b'[2,1] + sqrt(`b'[2,1]^2 - 4*`b'[3,1]*`c')) / 	/*
	*/	     (2*`b'[3,1])

end


exit

lf globals
----------

	scale contained in   scalar ${ML_tn`i'}   i = 1, ..., $ML_n

d0 globals
----------

	scale contained in   matrix ML_d0_S[1,`i']   i = 1, ..., $ML_k


Error/warning messages
----------------------

from MisStep (highly unlikely):

	could not calculate numerical derivatives
	discontinuous region with missing values encountered
	r(430);

from TwoStep:

	could not calculate numerical derivatives
	missing values encountered
	r(430);

	numerical derivatives are approximate		[warning]
	nearby values are missing

	could not calculate numerical derivatives
	flat or discontinuous region encountered
	r(430);

	numerical derivatives are approximate		[warning]
	flat or discontinuous region encountered

end of file

/*
   Called by ml_e0 as

   	ml_adjs e0 `i' `fpout' `fmout'

   Called by ml_elf as

   	ml_adjs elf `i' `fpout' `fmout' `x0' `list'

   Called by ml_rd techniques (ml_edfp, ml_bhhh, ...)
   
   	ml_adjs erd `i' `fpout' `fmout'

   where

	fpout = scalar (ml_e0) or variable (ml_elf/erd) with f(X+h)
	fmout = scalar (ml_e0) or variable (ml_elf/erd) with f(X-h)
	x0   = initial value of xi (ml_elf only)
	list = x1 x2 ... (ml_elf only)

	returns:
		stepsize/delta in r(step)

*/
