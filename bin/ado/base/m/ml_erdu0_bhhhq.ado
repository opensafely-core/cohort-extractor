*! version 6.1.0  02may2007
program define ml_erdu0_bhhhq
	version 7
	args calltyp dottype

	tempname t1 t2

	tempvar llvar ll_plus ll_subt
	qui gen double `ll_plus' = . in 1
	qui gen double `ll_subt' = . in 1

	$ML_vers $ML_user 0 $ML_b `ll_subt'
	mlsum $ML_f = `ll_subt'
	ml_count_eval $ML_f `dottype'

	if `calltyp' == 0 | scalar($ML_f) == . { exit }

	tempname delta 
	mat $ML_g = J(1, $ML_k, 0)

	tempname bb unused
	scalar `delta' = 1e-6

	local i 1
	while `i' <= $ML_k {
					/*  calculate stepsize -- delta
					 *  ll_plus = f(X_i+delta) and 
					 *  ll_subt = f(X_i-delta) */

		mat `bb' = $ML_b
		mat `bb'[1,`i'] = $ML_b[1,`i'] + 2*`delta'
		$ML_vers $ML_user 0 `bb' `ll_plus'
		ml_count_eval `ll_plus' input


					/* gradient calculation */
		tempvar grad`i'
		qui gen double `grad`i'' = /*
			*/ $ML_w * (`ll_plus' - `ll_subt') / (2*`delta')
		local gradlst `gradlst' `grad`i''
		sum `grad`i'', meanonly
		mat $ML_g[1,`i'] = r(sum)

		local i = `i' + 1

	}

					/* Estimate Hessian as outer
					 * product of gradients_t */
	qui mat accum $ML_V = `gradlst', nocons
end
exit

Derivatives and 2nd derivatives:

Centered first derivatives are:

	g_i_t = [f(X_t+2*delta)-f(Xt_t)] / 2delta

We define hi = (|xi|+eps)*eps where eps is sqrt(machine precision) or
maybe cube root.

Program logic:
	calculate f(X)
	for i {
		calculate hi
		calculate f(X-hi), optimizing hi, and save
		calculate f(X+hi) and save
		obtain g_i
		calculate D as outer product of observation g_i_t
	}


end of file
