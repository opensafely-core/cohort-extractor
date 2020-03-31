*! version 8.2.1  19oct2007
program define ml_erdu0_bhhh
	version 7
	args calltyp dottype

if `calltyp' != -1 {

	tempname t1 t2

	tempvar llvar ll_plus ll_subt
	qui gen double `llvar' = . in 1

	$ML_vers $ML_user 0 $ML_b `llvar'
	mlsum $ML_f = `llvar'
	ml_count_eval $ML_f `dottype'

	if `calltyp' == 0 | scalar($ML_f) == . { exit }
	drop `llvar'

	tempname delta 
	mat $ML_g = J(1, $ML_k, 0)

	if "$ML_wtyp" == "fweight" {
		local wt [$ML_wtyp=$ML_w]
	}
	else {
		local wstar "$ML_w*"
	}

	local i 1
	while `i' <= $ML_k {
					/*  calculate stepsize -- delta
					 *  ll_plus = f(X_i+delta) and 
					 *  ll_subt = f(X_i-delta) */

		noi ml_adjs erd `i' `ll_plus' `ll_subt'
		scalar `delta' = r(step)

					/* gradient calculation */

		tempvar grad`i'
		qui gen double `grad`i'' = /*
			*/ `wstar'(`ll_plus' - `ll_subt') / (2*`delta')
		local gradlst `gradlst' `grad`i''
		sum `grad`i'' `wt', meanonly
		mat $ML_g[1,`i'] = r(sum)

		local i = `i' + 1

	}

					/* Estimate Hessian as outer
					 * product of gradients_t */
	qui mat accum $ML_V = `gradlst' `wt', nocons
	exit
}
/* see if adequate storage avail */
local i 1
while `i' <= $ML_k + 6 {
	capture {
		tempvar t`i'
		gen double `t`i'' = . in 1
		local i = `i' + 1
	}
	if _rc {
		di as err "insufficient memory for "   /*
			*/ "BHHH/OPG gradient variables"
		exit 950
	}
}
end
exit

This is just like ml_ebhr0.ado, except it computes a derivative for each
	parameter regardless of whether the "linear" option is specified for
	an equation.

Derivatives and 2nd derivatives:

Centered first derivatives are:

	g_i_t = [f(X_t+hi)-f(Xt_t-hi)] / 2hi

We define hi = (|xi|+eps)*eps where eps is sqrt(machine precision) or
maybe cube root.

Program logic:
	calculate f(X)
	for i {
		calculate delta
		calculate f(X-delta), optimizing delta, and save
		calculate f(X+delta) and save
		obtain g_i
		calculate ML_V as outer product of observation g_i_t
	}


end of file
