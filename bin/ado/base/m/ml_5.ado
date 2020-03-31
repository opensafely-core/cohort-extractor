*! version 3.1.9  13feb2015
program define ml_5
	version 3.1, missing
	parse "`*'", parse(" ,")
	local cmd `1'
	mac shift
	local i=length("`cmd'")
	if ("`cmd'"==bsubstr("begin",1,`i')) { mx_begin `*' }
	else if ("`cmd'"==bsubstr("function",1,`i')) { mx_func `*' }
	else if ("`cmd'"==bsubstr("method",1,`i')) { mx_meth `*' }
	else if ("`cmd'"==bsubstr("model",1,`i')) { mx_model `*' }
	else if ("`cmd'"==bsubstr("depnames",1,`i')) { mx_depn `*' }
	else if ("`cmd'"==bsubstr("sample",1,`i')) { mx_samp `*' }
	else if ("`cmd'"==bsubstr("search",1,`i')) { mx_srch `*' }
	else if ("`cmd'"==bsubstr("maximize",1,`i')) { mx_mx1 `*' }
	else if ("`cmd'"==bsubstr("post",1,`i')) { mx_post `*' }
	else if ("`cmd'"==bsubstr("mlout",1,`i')) { mx_out `*' }
	else if ("`cmd'"==bsubstr("report",1,`i')) { mx_rept `*' }
	else if ("`cmd'"==bsubstr("query",1,`i')) { mx_q `*' }
	else { error 198 }
end


*  mx_begin:  version 1.0.1  06/20/93
program define mx_begin
	version 3.1, missing 
	global S_mldepn
	global S_mlfunc
	global S_mlmeth
	global S_mlwgt
	global S_mlmb
	global S_mlsf
	global S_mlmv
	global S_mlneq
	global S_mleqn
	global S_mlsag
	global S_mlag
	global S_ll0
	global S_mlmdf
end


*  mx_d0:  version 2.0.1  25mar1996
program define mx_d0
	version 4.0, missing
	local b "`1'"       /* starting values on entrance */
	local f "`2'"       /* scalar name to contain function value */
	local g "`3'"       /* gradient vector */
	local D "`4'"       /* matrix name to contain -2nd deriv matrix */

	mac shift 4
	local options "FIRSTIT LASTIT FAST(string) *"
	parse "`*'"

	if "`lastit'" != "" { 
		capture matrix drop S_mld0S
		exit 
	}

	$S_mlfunc `b' `f'		/* f to contain f(X)	*/
	if ("`fast'"=="0") { exit }


	tempname h bb fm0 fp0 fph fmh fpp fmm

	local n = colsof(matrix(`b'))

	if "`firstit'" != "" {
		mat S_mld0S = J(1,`n',1)
	}

	matrix `h' = J(1,`n',0)		/* perturbations 	*/
	matrix `D' = J(`n',`n',0)	/* -2nd deriv matrix 	*/
	matrix `g' = `b'		/* gradients, just want names */
	matrix `fph' = J(1,`n',0)	/* will contain f(X+h_i)	*/
	matrix `fmh' = J(1,`n',0)	/* will contain f(X-h_i)	*/

	local epsf 1e-3			/* see notes below	*/

	local i 1
	while `i' <= `n' {
		mat `h'[1,`i'] = (abs(`b'[1,`i'])+`epsf')*`epsf'

		mat `bb' = `b'
		mat `bb'[1,`i'] = `b'[1,`i'] - float(S_mld0S[1,`i']*`h'[1,`i'])
		$S_mlfunc `bb' `fm0'		/* fm0 = f(X-hi)	*/

					/* adjust S, combine with h */
		adjustS0 `fm0' `f' `h' `b' `bb' `i' `firstit'


		mat `fmh'[1,`i'] = `fm0'


		mat `bb' = `b'
		mat `bb'[1,`i'] = `b'[1,`i'] + `h'[1,`i']
		$S_mlfunc `bb' `fp0'		/* fp0 = f(X+hi)	*/

		mat `fph'[1,`i'] = `fp0'	/* fph[k] = f(X+hk)	*/

						/* Gradient		*/
		mat `g'[1,`i'] = (`fp0' - `fm0')/(2*`h'[1,`i'])

						/* Dii calculation	*/
		mat `D'[`i',`i'] =-(`fp0'-2*scalar(`f')+`fm0')/((`h'[1,`i'])^2)

		local j 1
		while `j' < `i' { 
			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] + `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] + `h'[1,`j']
			$S_mlfunc `bb' `fpp'

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] - `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] - `h'[1,`j']
			$S_mlfunc `bb' `fmm'

			mat `D'[`i',`j'] = - /*
			*/ (`fpp'+`fmm'+2*scalar(`f') /* 
			*/ -`fph'[1,`i']-`fmh'[1,`i'] /*
			*/ -`fph'[1,`j']-`fmh'[1,`j']) /*
			*/ / (2*`h'[1,`i']*`h'[1,`j'])

			mat `D'[`j',`i'] = `D'[`i',`j']
			local j=`j'+1
		}
		local i=`i'+1
	}
end

program define adjustS0 /* fm0 f h b bb i */
	version 4.0, missing
	local fm0	"`1'"	/* scalar, f(X-h[i])		*/
	local f		"`2'"	/* scalar, f(X)			*/
	local hvec	"`3'"	/* vector, value of h[]		*/
	local X		"`4'"	/* vector, base value of X[]	*/
	local XX	"`5'"	/* vector, X-h[i]		*/
	local i		"`6'"	/* i				*/

	local ep0 1e-8
	local ep1 1e-7
	local epmin 1e-10

	if "`7'"!="" {
		local ep0 1e-4
		local ep1 10e-4
	}

	local goal0 = (abs(scalar(`f'))+`ep0')*`ep0'
	local goal1 = (abs(scalar(`f'))+`ep1')*`ep1'
	local mgoal = (`goal0'+`goal1')/2
	local mingoal = (abs(scalar(`f'))+`epmin')*`epmin'

	local df = abs(scalar(`f'-`fm0'))

	tempname S newS h
	scalar `S' = S_mld0S[1,`i']
	scalar `h' = `hvec'[1,`i']
	local lastS .
	local iter 1

	while (`df'<`goal0' | `df'>`goal1') & `iter' <= 40 {
		if `df'<`mingoal' {
			scalar `newS' = `S'*2
		}
		else {
			if `lastS'>=. {
				scalar `newS'=`S'*cond(`df'<`goal0',2,.5)
			}
			else {
				/* f(0) = 0, f(S)=df, f(lastS)=lastdf */
				local a = (`lastdf'/`lastS'-`df'/`S') / /*
						*/ (`lastS'-`S')
				local b = `df'/`S' - `a'*`S'
				local r1 = ( /*
				*/ -`b' + sqrt(`b'*`b'+4*`a'*`mgoal') /* 
				*/ ) / (2*`a')
				scalar `newS'=`S'*cond(`df'<`goal0',2,.5)
				if `df'>`goal1' & `r1'>0 & `r1'<`S' {
					scalar `newS' = `r1'
				}
				else if `df'<`goal0' & `r1'>`S' & `r1'< . {
					scalar `newS' = `r1'
				}
			}
		}
		local lastS = `S'
		local lastdf= `df'
		scalar `S' = `newS'

		mat `XX' = `X'
		mat `XX'[1,`i'] = `X'[1,`i'] - float(`h'*`S')
		$S_mlfunc `XX' `fm0'		/* fm0 = f(X-hi)	*/

		local df = abs(scalar(`f'-`fm0'))
		local iter = `iter' + 1
	}
	if `df'<`goal0' | `df'>`goal1' { /* did not meet goal */
		di in red "$S_mlfunc does not compute a continuous " /*
		*/ "nonconstant function" _n /*
		*/ "could not calculate numerical derivatives"
		exit 430
	}
	matrix `hvec'[1,`i'] = float(scalar(`h')*`S')
	matrix S_mld0S[1,`i'] = `S'
end
			

/*
Derivatives and 2nd derivatives:

Notation:
	f(X)  means f(x1, x2, ...)
	f(X+h2) means f(x1, x2+h2, x3, ...)
	f(x+h_2+h_3) means f(x1, x2+h2, x3+h3,...)  etc.

Centered first derivatives are:

	g_i = [f(X+hi)-f(X-hi)]/2hi

Centered d^2 f/dx_i^2 are

	Dii = [ f(X+hi) - 2*f(X) + f(X-hi) ] / (hi)^2

Cross partials are:

	Dij = [ f(++) + f(--) + 2*f(00) - f(+0) - f(-0) - f(0+) - f(0-) ]
			/ (2*hi*hj)

We define hi = (|xi|+eps)*eps where eps is sqrt(machine precision) or
maybe cube root.

Program logic:
	calculate f(X)
	for i { 
		calculate hi
		calculate f(X-hi), optimizing hi, and save 
		calculate f(X+hi) and save
		obtain g_i
		calculate Dii
		for j<i { 
			calculate Dij and save in Dji too
		}
	}




For an even more expensive calculation of the 2nd, using formula:

	Dij = [f(++) - f(+-) - f(-+) + f(--)]/(4*hi*hj)

use the code:

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] + `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] + `h'[1,`j']
			$S_mlfunc `bb' `fpp'

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] + `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] - `h'[1,`j']
			$S_mlfunc `bb' `fpm'

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] - `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] + `h'[1,`j']
			$S_mlfunc `bb' `fmp'

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] - `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] - `h'[1,`j']
			$S_mlfunc `bb' `fmm'

			mat `D'[`i',`j'] = - /*
				*/ (`fpp'-`fpm'-`fmp'+`fmm')/ /*
				*/ (4*`h'[1,`i']*`h'[1,`j'])
*/


*  mx_d1:  version 1.2.0  01may1995
program define mx_d1
	version 4.0, missing
	local b "`1'"       /* starting values on entrance */
	local d "`3'"       /* derivative matrix */
	local f "`2'"       /* scalar name to contain function value */
	local v "`4'"       /* matrix name to contain variance matrix */

	mac shift 4
	local options "LASTIT FIRSTIT FAST(string)"
	parse "`*'"

	if ("`lastit'"~="") { exit }

	$S_mlfunc `b' `f' `d' , fast(`fast')
	if (`fast'==0) { exit }

	tempname bb dd1 ff h dd2
	local epsf 1e-4			/* was 1e-3, ought to be settable */
	cap mat drop `v'
	local i 1
	while (`i' <= colsof(matrix(`b'))) {
		scalar `h' = float((abs(`b'[1,`i'])+`epsf')*`epsf')
		mat `bb' = `b'
		mat `bb'[1,`i'] = `b'[1,`i'] + `h'
		$S_mlfunc `bb' `ff' `dd1'

		mat `bb' = `b'
		mat `bb'[1,`i'] = `b'[1,`i'] - `h'
		$S_mlfunc `bb' `ff' `dd2'

		scalar `h' = 1/(2*`h')
		mat    `dd2' = `dd2' - `dd1'
		mat    `dd2' = `h' * `dd2'
		mat    `v' = `v' \ `dd2'

		local i = `i' + 1
	}
	/* symmetrize */
	mat        `dd2' = `v' '
	mat        `v' = `v' + `dd2'
	mat        `v' = `v' * 0.5

	if "$S_mldbug" != "1" { exit }

/* debug code for user ml functions */
	mat colnames `d' = `pnames'
	mat coleq    `d' = `peq'
	mat colnames `v' = `pnames'
	mat coleq    `v' = `peq'
	mat rownames `v' = `pnames'
	mat roweq    `v' = `peq'
	mat list `d'
	mat list `v'
end


*  mx_depn:  version 1.0.1  06/20/93
program define mx_depn
	version 3.1, missing
	local varlist "req ex"
	parse "`*'"
	global S_mldepn "`varlist'"
end



*  mx_func:  version 1.0.1  07/20/93
program define mx_func
	version 3.1, missing
	if ("`1'"=="" | "`2'"!="") {
		error 198
	}
	global S_mlfunc `1'
end



*  mx_lf:  version 2.0.2  25mar1996
program define mx_lf
	version 4.0, missing
	local b "`1'"       /* starting values on entrance */
	local d "`3'"       /* derivative vector */
	local f "`2'"       /* matrix name to contain function value */
	local h "`4'"       /* matrix name to contain hessian matrix */

	mac shift 4
	local options "FAST(string) LASTIT FIRSTIT"
	parse "`*'"

	if "`firstit'" != "" {
		setup `b'
	}
	else if "`lastit'" != "" {
		alldone
		exit
	}

	tempname wrk
	tempvar ff sumff

	local i 1
	while `i'<=$S_mlfeq {
		tempname x`i'
		local se : word `i' of $S_mlfsd
		local ee : word `i' of $S_mlfed
		mat `wrk' = `b'[1,`se'..`ee']
		mat score double `x`i'' = `wrk' if $S_mlwgt
		local arglist "`arglist' `x`i''"
		local i = `i' + 1
	}

	qui gen double `ff' = .
	$S_mlfunc `ff' `arglist'
	qui count if `ff'>=. & $S_mlwgt!=0
	if _result(1)!=0 {
		scalar `f' = -1e30
		exit /* impossible value exit */
	}
	gen double `sumff' = sum(`ff'*$S_mlwgt)
	scalar `f' = `sumff'[_N]
	if `fast'==0 { exit }

	drop `sumff'
				/* we now continue to make derivative
				   calculations
				*/
	local epsf 1e-4
	tempname nfac
	tempvar one x0 grad xj0 fphh fmhh Dii Dij

				/* set initial scale to x`i' */
	if "`firstit'" != "" { 
		local i 1 
		while `i'<=$S_mlfeq { 
			local S : word `i' of $S_mlfS
			scalar `S' = 1
			local i=`i'+1
		}
	}

	mat `d' = J(1,$S_mlfn,0)
	mat `h' = J($S_mlfn,$S_mlfn,0)
	qui gen byte `one' = 1 if $S_mlwgt

	quietly {
		local i 1
		while `i'<=$S_mlfeq {
/* using wrk 	*/
			local se : word `i' of $S_mlfsd
			local ee : word `i' of $S_mlfed
			mat `wrk' = `b'[1,`se'..`ee']
			local vl`i' : colnames(`wrk')
			local i_cons = colnumb(`wrk',"_cons") 
			if `i_cons'< .  {
				parse "`vl`i''", parse(" ")
				local `i_cons' "`one'"
				local vl`i' "`*'"
			}
/* wrk now free */

			tempname h`i'
			tempvar fph`i' fmh`i'

			local S : word `i' of $S_mlfS
			qui summ `x`i'' [aw=$S_mlwgt]
			scalar `h`i'' = float((abs(_result(3))+`epsf')*`epsf')

			rename `x`i'' `x0'
			gen double `x`i'' = `x0' - float(`h`i''*`S')
			gen double `fmh`i'' = .
			noi $S_mlfunc `fmh`i'' `arglist'


			noi adjustS `S' `f' `x0' `fmh`i'' `x`i'' `h`i'' /*
				*/ "`arglist'"
			scalar `h`i'' = float(`h`i''*`S')


			replace `x`i'' = `x0' + `h`i''
			gen double `fph`i'' = .
			noi $S_mlfunc `fph`i'' `arglist'/* fph`i'=f(X+hi) */


			gen double `grad'=$S_mlwgt* /*
				*/ (`fph`i''-`fmh`i'')/(2*`h`i'')
			matrix vecaccum `wrk' = `grad' `vl`i'', nocons
			mat subst `d'[1,`se'] = `wrk'
			drop `grad'

					 		/* Dii calculation */
			gen double `Dii' = $S_mlwgt* /*
				*/ (`fph`i''-2*`ff'+`fmh`i'')/(`h`i''^2)
			summ `Dii' if $S_mlwgt
			scalar `nfac' = _result(3)
/* using wrk */
			matrix accum `wrk'= `vl`i'' [iw=-`Dii'/`nfac'], nocons
			if _result(1)!=0 { 
				mat `wrk' = `wrk' * `nfac'
				mat subst `h'[`se',`se'] = `wrk'
			}
/* wrk now free */

			/*
				update scale to min( sqrt(|f/f''|, |x|/epsf )
				unless f/f'' is missing, then use |x| as 
				scale.
				thus, maximum h next time is x.
				note, that S will be used on the next
				iteration to produce h`i'
			*/

			drop `Dii'


			if `fast'>1 {		/* Dij calculation */
				local nei = `ee' - `se' + 1
				local nei1 = `nei' + 1
				local j 1
				while `j' < `i' { /* wrap */
rename `x`j'' `xj0'
gen double `x`j'' = `xj0' + `h`j''
gen double `fphh' = . 
noi $S_mlfunc `fphh' `arglist'

drop `x`j''
gen double `x`j'' = `xj0' - `h`j''
replace `x`i'' = `x0' - `h`i''
gen double `fmhh' = . 
noi $S_mlfunc `fmhh' `arglist'
replace `x`i'' = `x0' + `h`i''
drop `x`j''

gen double `Dij' = $S_mlwgt * /*
*/ (`fphh'+`fmhh'+2*`ff'-`fph`i''-`fmh`i''-`fph`j''-`fmh`j'' ) /*
*/ / (2*`h`i''*`h`j'')

* gen double `Dij' = $S_mlwgt * (`fphh'-`fph`i''-`fph`j''+`ff')/(`h`i''*`h`j'')
summ `Dij' if $S_mlwgt
scalar `nfac' = _result(3)
								/* use wrk */
mat accum `wrk' = `vl`i'' `vl`j'' [iw=-`Dij'/`nfac'], nocons
if _result(1) != 0 {
	mat `wrk' = `wrk'[1..`nei',`nei1'...]
	mat `wrk' = `wrk' * `nfac'

	local sej : word `j' of $S_mlfsd

	mat subst `h'[`se',`sej'] = `wrk'
	mat `wrk' = `wrk' '
	mat subst `h'[`sej',`se'] = `wrk'
}
								/* wrk free */
drop `Dij' `fphh' `fmhh'
rename `xj0' `x`j''

local j=`j'+1
				} /* wrap */
			} /* Dij */

			drop `x`i''
			rename `x0' `x`i''

			local i=`i'+1
		} /* i loop */
	} /* quietly */


	if ("$S_mldbug"=="1") {
		mat list `d', title(derivative)
		mat list `h', title(Hessian)
	}
end

/*
	global assumptions:

		S_mlfeq		number of equations

		S_mlfsd		beginning index in b of equations
		S_mlfed		ending index in b of equations

		S_mlfn		dimension of problem
*/

program define setup /* b    (which is properly named) */
	version 4.0, missing

	local b "`1'"

	local vname : colnames(`b')
	local ename : coleq(`b')

	local i 1
	local eq 1
	local se 1
	local e1 : word 1 of `ename'
	while (`i'<=colsof(matrix(`b'))) {
		local vn : word `i' of `vname'
		local en : word `i' of `ename'
		if ("`en'"!="`e1'") {
			local ee = `i'-1
			local eq = `eq'+1
			local sdim "`sdim' `se'"
			local edim "`edim' `ee'"
			local e1 "`en'"
			local se "`i'"
		}
		local i = `i' + 1
	}
	local bdim = colsof(matrix(`b'))
	local sdim "`sdim' `se'"
	local edim "`edim' `bdim'"

	global S_mlfeq `eq'
	global S_mlfsd "`sdim'"
	global S_mlfed "`edim'"
	global S_mlfn `bdim'
end

program define alldone
	version 4.0, missing
	global S_mlfeq
	global S_mlfsd
	global S_mlfed
	global S_mlfn
	global S_mlfS
end

program define adjustS /* f x0 fmhi xi hi "arglist" */
	version 4.0, missing
	local S		"`1'"	/* scalar name	*/
	local f 	"`2'"	/* scalar name 	*/
	local x0 	"`3'"	/* varname	*/
	local fmhi 	"`4'"	/* varname	*/
	local xi 	"`5'"	/* varname 	*/
	local hi	"`6'"	/* scalar name	*/
	local arglist	"`7'"

	tempvar fatS

	qui gen double `fatS' = sum(`fmhi'*$S_mlwgt)

	local ep0 1e-8
	local ep1 1e-7
	local epmin 1e-10

	local goal0 = (abs(scalar(`f'))+`ep0')*`ep0'
	local goal1 = (abs(scalar(`f'))+`ep1')*`ep1'
	local mgoal = (`goal0'+`goal1')/2
	local mingoal = (abs(scalar(`f'))+`epmin')*`epmin'

	local df = abs(scalar(`f')-`fatS'[_N])

	tempname newS
	local lastS .
	local iter 1

	while (`df'<`goal0' | `df'>`goal1') & `iter' <= 40 {
		if `df'<`mingoal' {
			scalar `newS' = `S'*2
		}
		else {
			if `lastS'>=. {
				scalar `newS'=`S'*cond(`df'<`goal0',2,.5)
			}
			else {
				/* f(0) = 0, f(S)=df, f(lastS)=lastdf */
				local a = (`lastdf'/`lastS'-`df'/`S') / /*
						*/ (`lastS'-`S')
				local b = `df'/`S' - `a'*`S'
				local r1 = ( /*
				*/ -`b' + sqrt(`b'*`b'+4*`a'*`mgoal') /* 
				*/ ) / (2*`a')
				scalar `newS'=`S'*cond(`df'<`goal0',2,.5)
				if `df'>`goal1' & `r1'>0 & `r1'<`S' {
					scalar `newS' = `r1'
				}
				else if `df'<`goal0' & `r1'>`S' & `r1'< . {
					scalar `newS' = `r1'
				}
			}
		}
		local lastS = `S'
		local lastdf= `df'

		scalar `S' = `newS'
		qui replace `xi' = `x0' - float(`hi'*`S')
		qui replace `fmhi' = .
		$S_mlfunc `fmhi' `arglist'
		qui replace `fatS' = sum(`fmhi'*$S_mlwgt)
		local df = abs(scalar(`f')-`fatS'[_N])
		local iter = `iter' + 1
	}
	if `df'<`goal0' | `df'>`goal1' { /* did not meet goal */
		di in red "$S_mlfunc does not compute a continuous " /*
		*/ "nonconstant function" _n /*
		*/ "could not calculate numerical derivatives"
		exit 430
	}
end


*  mx_marq.ado:  version 3.0.2 18apr1995
program define mx_marq
	version 4.0, missing
	local inv `1'
	local hh `2'
	local add `3'
	local multipl `4'
	local bad `5'               /* must be a scalar */
	local ok 0
	tempname md iadd mult2

	local rr = colsof(`hh')

	while (!`ok') {
		if (`bad') {
			scalar `add' = (`add'+1) * 10
			scalar `multipl' = (`multipl'+2)^1.25
		}
		else {
			scalar `add' = (`add') / 10
			scalar `multipl' = `multipl'^0.8
		}
		* di "add = " `add' " multipl = " `multipl'
		if (`add'<.1 & `multipl'<1.1) { scalar `multipl' = 1 }
		if (`multipl'>1) {
			mat `md' = vecdiag(`hh')
			mat `iadd' = J(1,`rr',`add')
			mat `md' = `iadd' + `md'
			scalar `mult2' = `multipl' - 1
			mat `md' = `md' * `mult2'
			mat `md' = diag(`md')
			mat `inv' = `hh' + `md'
			mat `inv' = syminv(`inv')
		}
		else 	mat `inv' = syminv(`hh')

		local j 1
		local ok 1
		while (`j'<=`rr') {
			if (`inv'[`j',`j']==0 & `hh'[`j',`j']!=0) { local ok 0 }
			local j = `j' + 1
		}
		if (!`ok') { scalar `bad' = `bad' + 1 }
	}
end


*  mx_meth:  version 1.0.2  07/17/93
program define mx_meth
	version 3.1, missing
	if "`1'"=="user" & "`2'"!="" & "`3'"=="" {
		global S_mlmeth `2'
		exit
	}
	if ("`1'"=="" | "`2'"!="") {
		error 198
	}
	if ("`1'"=="lf") {global S_mlmeth mx_lf}
	else if ("`1'"=="deriv0") { global S_mlmeth mx_d0 }
	else if ("`1'"=="deriv1") { global S_mlmeth mx_d1 }
	else if ("`1'"=="deriv2") { global S_mlmeth mx_d2 }
	else {
		di in red "unknown method `1'"
		exit 198
	}
end


*  mx_model:  version 1.0.3  11dec1995
program define mx_model
	version 4.0, missing
	parse "`*'", parse(" =")
	local b `1'
	if "`2'" != "=" { error 198 }
	mac shift 2
	_crceprs `*'
	local options "NOCONstant CONstant(string) DEpv(string) FRom(string)"
	local eqnames "$S_1"
	parse "$S_2"
	if "`noconst'"!="" {
		if "`constan'"!="" { error 198 }
		local constan 0
	}
	else if "`constan'"=="" {
		local constan 1
	}
	if "`depv'"=="" { local depv "1" }
	parse "`eqnames'", parse(" ")
	tempname s bb
	global S_mlneq 0
	global S_mlmdf 0
	global S_mldepn
	cap mat drop `b'
	local k 0 
	while "`1'"!="" {
		local k = `k' + 1 
		local depve = bsubstr("`depv'",min(`k',length("`depv'")),1)
		confirm integer number `depve'
		local coneq = bsubstr("`constan'",min(`k',length("`constan'")),1)
		confirm integer number `coneq'
		if `coneq'!=0 & `coneq'!=1 {
			di in red "constant() must contain only 0's or 1's"
			error 198
		}
		eq ? `1'
		if `coneq' { global S_1 "$S_1 _cons" }
		local j : word count $S_1
		global S_mleqn = "$S_mleqn $S_3"
		local eqn "$S_3"
		global S_mlneq = $S_mlneq + 1
		global S_mlmdf = $S_mlmdf + `j' - `coneq'
		matrix `bb' = J(1,`j',0)
		matrix colnames `bb' = $S_1
		if `depve' {
			local i 1
			while `i'<=`depve' {
				local one : word `i' of $S_1
				if "`one'"=="" { 
					di in red /*
				*/ "equation `eqn' contains too few variables"
					exit 102
				}
				global S_mldepn "$S_mldepn `one'"
				matrix `bb' = `bb'[1,2...]
				global S_mlmdf = $S_mlmdf - 1 
				local i = `i' + 1
			}
		}
		matrix coleq `bb' = `1'
		cap matrix `s' = `from'[1,"`1':"]
		if _rc & $S_mlneq==1 {
			local 1 "_"
			cap matrix `s' = `from'[1,"`1':"]
		}
		if _rc==0 {
			local j  1
			local c: colnames(`s')
			while `j'<=colsof(`s') {
				local n : word `j' of `c'
				local cc = colnumb(`bb',"`n'")
				if `cc'< . {
					mat `bb'[1,`cc'] = `s'[1,`j']
				} 
				local j = `j' + 1
			}
		}
		matrix `b' = `b' , `bb'
		mac shift
	}
	if $S_mlneq==1 { matrix colnames `b' = _: }
	global S_mlmb `b'
end



*  mx_mx1:  version 1.0.8  20Apr1995
program define mx_mx1
	version 4.0, missing
	parse "`*'", parse(" ,")
	local b $S_mlmb     /* starting values on entrance */
	global S_mlsf `1'
	local f $S_mlsf     /* scalar name to contain function value */
	global S_mlmv `2'
	local v $S_mlmv     /* matrix name to contain variance matrix */


	mac shift 2
	local options "DACC(real 1e-5) Fcnlabel(string) STYLE(int 0) LTOLera(real 1e-6) TOLeran(real 1e-6) ITERate(int `c(maxiter)') TRace"
	parse "`*'"

	if "`fcnlabe'" == "" {
		local fcnlabe "Log Likelihood"
	}

	local method $S_mlmeth
	if ("`method'"=="mx_d2") { local method $S_mlfunc }
	else if "`method'"=="mx_lf" {
		local dim : coleq(`b')
		local dim : word count `dim'
		global S_mlfS
		local i 1
		while `i'<=`dim' {
			tempvar base		/* base just temporary */
			global S_mlfS "$S_mlfS `base'"
			local i=`i'+1
		}
	}

	global S_mlag `dacc'      /* accuracy goal if double precision */
	global S_mlsag 1
	local FUZZ 2e-10
	tempname taa tab tbb tdd fixlist sltollc dll ratio dllold add multipl cosine
	tempname fbase ftry d0 b0 f0 d1 b1 f1 d2 b2 f2 i2 dnorm step0 step1 step2 h hh
	tempname astep astep1 astep2 bad agoal fnext
	local dim = colsof("`b'")
	matrix `b0' = `b'
	matrix `astep' = `b' * 0
	matrix `fixlist'=J(1,`dim',0)
	scalar `dll' = 0
	if ("`trace'"!="") { mat list `b0', nohead nonames noblank }
	local myfast 2 /* start optimistic */
	`method' `b0' `f0' `d0' `h' , firstit fast(`myfast')
	if `f0' < -9.99e29 {
		di in red "Initial starting values not feasible."
		global S_mlfS
		exit 1400
	}
	scalar `f' = `f0'
	global S_ll0 = `f0'
	di in gr "Iteration 0:  `fcnlabe' = " in ye %10.0g `f0'
	local iter  0
	local base 0
	local try  1
	local next 2
	local conv  0
	local mycn : colnames(`b')
	local mycen : coleq(`b')
	scalar `add' = 0
	scalar `multipl' = 1

	while (!`conv' & `iter'<`iterate') {
		if (int(`style'/2) & $S_mlsag!=1) {
			/* change Nash's epsilon for derivative calculation */
			global S_mlag = $S_mlag * $S_mlsag
			global S_mlsag = 1
		}
		scalar `add' = 0
		scalar `multipl' = 1
		local   unprod 0
		scalar `bad' = 0 
		mx_marq `i2' `h' `add' `multipl' `bad'
		if (`bad'>0) {
			di in bl "(nonconcave function encountered)"
		}
		local ok 0
		scalar `fbase' = `f`base''
		while (!`ok') {
			matrix `step`try'' = `d`base'' * `i2'
			matrix `b`try'' = `step`try'' + `b`base''
			`method' `b`try'' `f`try'' `d`try'' `hh' , fast(0)
			scalar `ftry'  = `f`try''
			if (`fbase'-`FUZZ'*abs(`fbase')>`ftry' & !`conv') {
				if (`unprod'==0) { 
					di in bl "(unproductive step attempted)"
					local unprod 1
				}
				if (mod(`style',2)==1) { local myfast 1 }
				scalar `bad' = 1
				mx_marq `i2' `h' `add' `multipl' `bad'
			}
			else 	local ok 1
		}
		scalar `ratio' = 1
		local ok 0
		while (!`ok') {
			mat `b`next'' = `step`try'' + `b`try''
			`method' `b`next'' `f`next'' `d`next'' `hh' , fast(0)
			if (`f`next''>`f`try'') {
				scalar `f`try'' = `f`next''
				mat `step`try'' = `b`try''-`b`base''
				mat `b`try'' = `b`next''
			}
			else 	local ok 1 
		}

		/* if the lf values are a, b, and c, 
		   2A = c - 2b + a, B = c - b */

		scalar `ratio' = (2*`f`try''-0.5*`f`next''-1.5*`f`base'')/ /*
				*/ (2*`f`try''-`f`next''-`f`base'')
		if `ratio'<=0 | `ratio'>=2 {
			scalar `ratio' = 1
		}
		mat `step`try'' = `step`try''*`ratio'
		mat `b`try'' = `step`try'' + `b`base''
		if ("`trace'"!="") { mat list `b`try'', nohead nonames noblank }
		/* dont calculate derivatives you dont think you will use */
		`method' `b`try'' `f`try'' `d`try'' `h' , fast(`myfast')
		local myfast 2
/*
		if (`fbase'<=`ftry' & `fbase'>=`ftry'-`ltolera') {
*/
		if abs(`ftry'-`fbase')<`ltolera' {
			local conv 1
			mat `b' = `b`try'' /* Save successful iteration */
		}
		local iter = `iter' + 1
		mat S_mlbest = `b`try''
		di in gr "Iteration " `iter' ":  `fcnlabe' = " in ye %10.0g `f`try''
		local next `base'
		local base `try'
		local try = mod(`base'+1,3)
	}
	if (!`conv') {
		mat `b' = `b`base''
	}
	if (`iterate'>0) { `method' `b' `f' `d0' `h' , fast(2) }
	cap mat `v' = syminv(`h')
	mat rownames `v' = `mycn'
	mat roweq `v' = `mycen'
	mat colnames `v' = `mycn'
	mat coleq `v' = `mycen'
	`method' `b0' `f0' `d0' `h' , lastit
	global S_mlfS
end


*  mx_out:  version 1.0.1  07/17/93
program define mx_out
	version 3.1, missing
	parse "`*'", parse(" ,")
	local cmd `1'
	mac shift
	local options "*"
	parse "`*'"
	if ("`cmd'"!="$S_E_cmd") { error 301 }
	di
	di in gr "$S_E_ttl" _col(53) "Number of obs    =" in yel %8.0f $S_E_nobs
	di _col(53) in gre "Model chi2(" in ye "$S_E_mdf" in gr ")" /*
		*/ _col(70) "=" in yel %8.2f $S_E_chi2
	di _col(53) in gre "Prob > chi2      =" in yel %8.4f chiprob($S_E_mdf,$S_E_chi2)
	di in gre "Log Likelihood =" in yel %15.7f $S_E_ll _c
	if ("$S_E_pr2"!="") { 
		di _col(22) in gr "Pseudo R2        =" /*
			*/ in yel %8.4f $S_E_pr2 _c 
	}
	di _n

	matrix mlout, `options'
end


*  mx_parm:  version 1.0.1  07/17/93
program define mx_parm
	version 3.1, missing
	local vn : colnames(`1')
	local ntok = colnumb(`1',"_cons")
	if (`ntok' < .) {
		local ntok = `ntok' - 1
		tempname d
		mat `d' = `1'[1,1..`ntok']
		global S_1 : colnames(`d')
		global S_2
	}
	else {
		global S_1 : colnames(`1')
		global S_2 nocons
	}
end


*  mx_post:  version 1.0.3  07/17/93
program define mx_post, eclass
	version 3.1, missing
	parse "`*'", parse(" ,")
	local cmd `1'
	mac shift
	local options "LF0(string) PR2 OBs(string) TItle(string) DOF(string)"
	parse "`*'"
	local k : word count $S_mldepn
	if (`k'==1) { local depn "depn($S_mldepn)" }
	if ("`obs'"=="") {
		qui summ $S_mlwgt
		local obs = _result(1)*_result(3)
		if (abs(`obs'-round(`obs',1))<.01) { 
			local obs = round(`obs',1) 
		}
	}
	local tdf .
	if ("`dof'"!="") {
		local tdf `dof'
		local dof(`dof')
	}
	mat post $S_mlmb $S_mlmv $S_mlmc, `depn' `dof' obs(`obs')
	global S_E_tdf `tdf'
capture est scalar df_r = $S_E_tdf
	global S_E_ttl "`title'"
est local title "$S_E_ttl"
	global S_E_depv "$S_mldepn"

	est local depvar $S_E_depv


	global S_E_nobs "`obs'"
capture est scalar N = $S_E_nobs
	if "`lf0'"=="i0" {
		local lf0 "$S_ll0"
	}
	if "`lf0'"!="" {
		global S_E_chi2 = 2 * (scalar($S_mlsf) - `lf0')
	}
	else	global S_E_chi2 .
capture est scalar chi2 = $S_E_chi2
	global S_E_mdf $S_mlmdf
capture est scalar df_m = $S_E_mdf
	global S_E_ll  = scalar($S_mlsf)
capture est scalar ll = $S_E_ll
	global S_E_ll0 = $S_ll0
capture est scalar ll_0 = $S_E_ll0
	if ("`pr2'"!="" & "`lf0'"!="") { 
		global S_E_pr2 = (scalar($S_mlsf) - `lf0')/abs(`lf0') 
	}
	else global S_E_pr2
capture est scalar r2_p = $S_E_pr2
	capture matrix drop S_mlbest
	capture scalar drop $S_mlsf
	global S_E_cmd "`cmd'"
est local cmd "$S_E_cmd"
	ml_5 begin
end


*  mx_q:  version 1.0.0  06/27/93
program define mx_q
	version 3.1, missing

	di in gr "user-written function:" _col(30) _c
	if "$S_mlfunc"=="" { 
		di in gr "<unknown>"
	}
	else	di in ye "$S_mlfunc"

	di in gr "optimization method:" _col(30) _c
	if "$S_mlmeth"=="mx_lf" { di in ye "lf" }
	else if "$S_mlmeth"=="mx_d0" { di in ye "deriv0" }
	else if "$S_mlmeth"=="mx_d1" { di in ye "deriv1" }
	else if "$S_mlmeth"=="mx_d2" { di in ye "deriv2" }
	else if "$S_mlmeth"=="" { di in gr "<unknown>" }
	else di in ye "$S_mlmeth"

	di in gr "equation names:" _col(30) _c
	if "$S_mleqn"=="" { di in gr "<unknown>" }
	else di in ye "$S_mleqn"

	di in gr "dependent variables:" _col(29) _c
	if "$S_mldepn"=="" { di in gr " <none>" } 
	else di in ye "$S_mldepn"

	di in gr "parameter vector:" _col(30) _c
	if "$S_mlmb"=="" { di in gr "<unknown>" }
	else di in ye "$S_mlmb"

	di in gr "sample-inclusion variable:" _col(30) _c
	if "$S_mlwgt"=="" { di in gr "<unknown>" }
	else di in ye "$S_mlwgt"
end


*  mx_rept:  version 1.0.2 7/19/93
program define mx_rept, eclass
	version 3.1, missing
	if "$S_E_cmd"=="inprogress" {
		mat mlout
		exit
	}
	tempname b f v
	mat `b' = S_mlbest
	global S_mlmb `b'
	mx_mx1 `f' `v' , iter(0)
	mat post `b' `v'
	global S_E_ttl "Unfinished maximization"
est local title "$S_E_ttl"
	global S_E_cmd "inprogress"
est local cmd "$S_E_cmd"
	global S_E_depv "$S_mldepn"
	est local depvar $S_E_depv

	qui summ $S_mlwgt
	local obs = _result(1)*_result(3)
	if (abs(`obs'-round(`obs',1))<.01) { local obs = round(`obs',1) }
	global S_E_nobs "`obs'"
capture est scalar N = $S_E_nobs
	global S_E_chi2 .
capture est scalar S_E_chi2 = .
	global S_E_mdf $S_mlmdf
capture est scalar df_m = $S_E_mdf
	global S_E_ll  = scalar(`f')
capture est scalar ll = $S_E_ll
	global S_E_pr2
capture est scalar r2_p = $S_E_pr2
	mat mlout
end


*  mx_samp:  version 1.0.4  18sep1996
program define mx_samp
	version 3.1, missing
	global S_mlwgt `1'
	capture drop $S_mlwgt
	confirm new var $S_mlwgt
	tempvar touse
	quietly gen byte `touse'=.
	mac shift

	local varlist "req ex"
	local if "opt"
	local in "opt"
	local weight "aweight fweight pweight iweight"
	local options "noAuto"
	parse "`touse' `*'"
	parse "`varlist'", parse(" ")
	mac shift
	local varlist "`*'"
	quietly {
		drop `touse'
		mark `touse' [`weight'`exp'] `if' `in'
		markout `touse' `varlist'
		if "`auto'"=="" {
			parse "$S_mleqn", parse(" ")
			while "`1'"!="" {
				eq ? `1'
				markout `touse' $S_1
				mac shift
			}
		}
		count if `touse'
		if _result(1)==0 { error 2000 } 
		if "`weight'"=="" {
			rename `touse' $S_mlwgt
			exit
		}
		gen double $S_mlwgt `exp'
		replace $S_mlwgt = 0 if !`touse'
		if "`weight'"=="aweight" {
			sum $S_mlwgt if $S_mlwgt>0
			replace $S_mlwgt = $S_mlwgt/_result(3)
		}
	}
end


*  version 1.0.2 07/17/93
program define mx_srch
	version 3.1, missing
	local options "Limits(string) Iterate(integer 5)"
	parse "`*'"
	if ("$S_mlmeth"!="mx_lf") {
		di in red /*
*/ "Search technique not suitable for this style of likelihood function"
		error 499
	}
	if "`limits'"=="" { 
		di in red "limits() required"
		exit 198
	}
	local b $S_mlmb     /* problem definition / starting values */
	local enames : coleq(`b')
	local vnames : colnames(`b')
	local i 1
	local neq 0
	local thiseq : word 1 of `enames'
	local lasteq "***"
	tempname bb thislf bestll
	while ("`thiseq'"!="") {
		if ("`thiseq'"!="`lasteq'") {
			local neq = `neq' + 1
			local eqlist "`eqlist' `thiseq'"
			tempname x`neq'
			mat `bb' = `b'[1,"`thiseq':"]
			mat score float `x`neq'' = `bb'
			local varlist "`varlist' `x`neq''"
			local lasteq `thiseq'
			local k 1
			local v1 : word 1 of `limits'
			local foundit 0
			while ("`v1'"!="" & !`foundit') {
				qui cap conf number `v1'
				if (!_rc) {
					local k = `k' + 1
					if ("`thiseq'"=="_") {
						local llimit "`llimit' `v1'"
						local v3 : word `k' of `limits'
						local ulimit "`ulimit' `v3'"
						local foundit 1
					}
				}
				else  {
					local k = `k' + 1
					local v2 : word `k' of `limits'
					local k = `k' + 1
					local v3 : word `k' of `limits'
					if ("`thiseq'"=="`v1'") {
						local llimit "`llimit' `v2'"
						local v3 : word `k' of `limits'
						local ulimit "`ulimit' `v3'"
						local foundit 1
					}
				}
				local k = `k' + 1
				local v1 : word `k' of `limits'
			}
			if (!`foundit') {
				local llimit "`llimit' ."
				local ulimit "`ulimit' ."
			}
		}
		local i = `i' + 1
		local thiseq : word `i' of `enames'
	}
	local nfound 0
	scalar `bestll' = -1e30
	tempname ff
	qui gen double `ff' = .
	while (`nfound'<`iterate') {
		local j 1
		local thisvec
		while (`j'<=`neq') {
			local ll : word `j' of `llimit'
			local ul : word `j' of `ulimit'
			if ("`ll'"!=".") {
				local totry = `ll' + (`ul'-`ll')*uniform()
				local thisvec "`thisvec' `totry'"
				qui replace `x`j'' = `totry'
			}
			else { local thisvec "`thisvec' ." }
			local j = `j' + 1
		}
		qui replace `ff' = .
		$S_mlfunc `ff' `varlist'
		qui cap assert `ff'< . | $S_mlwgt<=0
		if (_rc) {
			di "(infeasible value attempted; skipped)"
		}
		else {
			qui summ `ff' [aw=$S_mlwgt]
			scalar `thislf' = _result(2)*_result(3)
			local nfound = `nfound' + 1
			di in gr "search " `nfound' ":  Log Likelihood = " /*
				*/ in ye %10.0g `thislf'
			if (`thislf'>`bestll') {
				scalar `bestll' = `thislf'
				local pvec "`thisvec'"
			}
		}
	}
	local j 1
	while (`j'<=`neq') {
		local ll : word `j' of `pvec'
		if (`ll'< .) {
			local thiseq : word `j' of `eqlist'
			local pn = colnumb(matrix(`b'),"`thiseq':_cons")
			if (`pn'>=.) { error 198 }
			matrix `b'[1,`pn'] = `ll'
		}
		local j = `j' + 1
	}
end
exit

/*
ml_5.ado is a conglomeration of the following Stata 5 files:

	ml.ado
	mx_begin.ado
	mx_d0.ado
	mx_d1.ado
	mx_depn.ado
	mx_func.ado
	mx_lf.ado
	mx_marq.ado
	mx_meth.ado
	mx_model.ado
	mx_mx1.ado
	mx_out.ado
	mx_parm.ado
	mx_post.ado
	mx_q.ado
	mx_rept.ado
	mx_samp.ado
	mx_srch.ado
<end>
