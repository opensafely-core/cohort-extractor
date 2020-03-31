*! version 6.1.1  02feb2012
program define ml_erdu0
	version 7
	args calltyp dottype

if `calltyp' != -1 {

	local f $ML_f
	local g $ML_g
	local D $ML_V
	local b $ML_b

	tempname t1 t2
	tempvar llvar
	qui gen double `llvar' = . in 1

	$ML_vers $ML_user 0 $ML_b `llvar' 
	mlsum `f' = `llvar'
	ml_count_eval `f' `dottype'

	if `calltyp'==0 | scalar(`f')==. {
		exit
	}

	tempname h bb fph fmh grad fp fp0 fm0 t fpp fmm
	tempvar fm0v fp0v fppv fmmv
	qui gen double `fmmv' = . in 1
	qui gen double `fppv' = . in 1

	matrix `h' = J(1,$ML_k,0)	/* perturbations 		*/
	matrix `D' = J($ML_k,$ML_k,0)	/* -2nd deriv matrix 		*/
	matrix `g' = $ML_b		/* gradients, just want names 	*/
	matrix `fph' = J(1,$ML_k,0)	/* will contain f(X+h_i)	*/
	matrix `fmh' = J(1,$ML_k,0)	/* will contain f(X-h_i)	*/

	local i 1
	while `i' <= $ML_k {
					/* calculate stepsize `h'[1,`i'],
					   `fp0', and `fm0' */
   		ml_adjs erd `i' `fp0v' `fm0v'

		mat `h'[1,`i']   = r(step)
		mlsum `fp0' = `fp0v'
		mlsum `fm0' = `fm0v'
		mat `fph'[1,`i'] = `fp0'		/* fp0 = f(X+hi) */
		mat `fmh'[1,`i'] = `fm0'		/* fm0 = f(X-hi) */

						/* Gradient */
		mlsum `fp' = (`fp0v' - `fm0v') / (2 * r(step))
		mat `g'[1,`i'] = `fp'

						/* Dii calculation */
		mat `D'[`i',`i'] = -(`fp0'-2*scalar(`f')+`fm0') / (r(step)^2)

		local j 1
		while `j' < `i' {
			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] + `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] + `h'[1,`j']
			$ML_vers $ML_user 0 `bb' `fppv'
			mlsum `fpp' = `fppv'
			ml_count_eval `fpp' input

			mat `bb' = `b'
			mat `bb'[1,`i'] = `bb'[1,`i'] - `h'[1,`i']
			mat `bb'[1,`j'] = `bb'[1,`j'] - `h'[1,`j']

			$ML_vers $ML_user 0 `bb' `fmmv'
			mlsum `fmm' = `fmmv'
			ml_count_eval `fmm' input

			mat `D'[`i',`j'] = -				/*
				*/  ( `fpp' + `fmm' + 2*scalar(`f')	/*
				*/    - `fph'[1,`i'] - `fmh'[1,`i']	/*
				*/    - `fph'[1,`j'] - `fmh'[1,`j']	/*
				*/  )					/*
				*/  / (2*`h'[1,`i']*`h'[1,`j'])

			mat `D'[`j',`i'] = `D'[`i',`j']

			local j=`j'+1
		}
		local i=`i'+1
	}
	exit
}
/* see if adequate storage avail */
local i 1
while `i' <= 8 {
	capture {
		tempvar t`i'
		gen double `t`i'' = . in 1
		local i = `i' + 1
	}
	if _rc {
		di as err "insufficient memory for ML temporary variables"
		exit 950
	}
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

Computes numeric Hessian and leaves it in $ML_V.

Usually used as the evalf routine at the end of an optimizer that may
	not have left a good Hessian behind.

Also used to implement the standard Newton-Raphson optimizer w/ numeric 
        derivatives for -rd- style likelihood evaluators.

Uses the rd (recursively dependent) calling sequence for the user's likelihood
	evaluator.

