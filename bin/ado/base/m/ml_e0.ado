*! version 6.2.1  02feb2012
program define ml_e0 /* 0 */
	version 8.0
	args calltype dottype
	// no need to check memory requirements
	if (`calltype' == -1) exit

	local f $ML_f
	local g $ML_g
	local D $ML_V
	local b $ML_b

	tempname t1 t2

	$ML_vers $ML_user 0 $ML_b /* -> */ `f' /* ignored */ `t1' `t2' $ML_sclst
	ml_count_eval `f' `dottype'

	if `calltype'==0 | scalar(`f')==. {
		exit
	}

	tempname h bb fm0 fp0 fph fmh fpp fmm

	matrix `h' = J(1,$ML_k,0)	/* perturbations 		*/
	matrix `D' = J($ML_k,$ML_k,0)	/* -2nd deriv matrix 		*/
	matrix `g' = $ML_b		/* gradients, just want names 	*/
	matrix `fph' = J(1,$ML_k,0)	/* will contain f(X+h_i)	*/
	matrix `fmh' = J(1,$ML_k,0)	/* will contain f(X-h_i)	*/

	local i 1
	while `i' <= $ML_k {
					/* calculate stepsize `h'[1,`i'],
					   `fp0', and `fm0' */
   		ml_adjs e0 `i' `fp0' `fm0'

		mat `h'[1,`i']   = r(step)
		mat `fph'[1,`i'] = `fp0'	/* fp0 = f(X+hi) */
		mat `fmh'[1,`i'] = `fm0'	/* fm0 = f(X-hi) */

						/* Gradient */
		mat `g'[1,`i'] = (`fp0' - `fm0')/(2*`h'[1,`i'])

						/* Dii calculation */
		mat `D'[`i',`i'] =-(`fp0'-2*scalar(`f')+`fm0')/((`h'[1,`i'])^2)

		local j 1
		while `j' < `i' {
			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] + `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] + `h'[1,`j']
			$ML_vers $ML_user 0 `bb' `fpp' `t1' `t2' $ML_sclst
			ml_count_eval `fpp' input

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] - `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] - `h'[1,`j']

			$ML_vers $ML_user 0 `bb' `fmm' `t1' `t2' $ML_sclst
			ml_count_eval `fmm' input

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
	if "$ML_showh" != "" {
		ml_showh `h'
	}
end
exit

Derivatives and 2nd derivatives:

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
			$ML_vers $ML_user 0 `bb' `fpp' ..

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] + `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] - `h'[1,`j']
			$ML_vers $ML_user 0 `bb' `fpm' ..

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] - `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] + `h'[1,`j']
			$ML_vers $ML_user 0 `bb' `fmp' ...

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] - `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] - `h'[1,`j']
			$ML_vers $ML_user 0 `bb' `fmm' ...

			mat `D'[`i',`j'] = - /*
				*/ (`fpp'-`fpm'-`fmp'+`fmm')/ /*
				*/ (4*`h'[1,`i']*`h'[1,`j'])
end of file
