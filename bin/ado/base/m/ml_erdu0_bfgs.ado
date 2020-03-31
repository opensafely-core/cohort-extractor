*! version 6.3.0  23aug2019
program define ml_erdu0_bfgs
	version 7
	args calltyp dottype

	local eps 1e-8
	local rstlmit 100

	tempname ll_sum
	tempvar ll_plus ll_subt

	qui gen double `ll_subt' = . in 1
	$ML_vers $ML_user 0 $ML_b `ll_subt'
	mlsum $ML_f = `ll_subt'
	ml_count_eval $ML_f `dottype'

	if `calltyp' == 0 | scalar($ML_f) == . { exit }

	mat $ML_g = J(1, $ML_k, 0)
	tempvar ll_plus ll_subt
	local i 1
	while `i' <= $ML_k {
					/*  calculate stepsize -- r(step)
					 *  ll_plus = f(X_i+step) and 
					 *  ll_subt = f(X_i-step) */

		noi ml_adjs erd `i' `ll_plus' `ll_subt'

					/* gradient calculation */

		mlsum `ll_sum' = (`ll_plus' - `ll_subt') / (2*r(step))
		capture mat $ML_g[1,`i'] = `ll_sum'
		if _rc {
			di as err "BFGS Gradient could not be "	/*
				*/ "updated; Gradient is unstable"
			exit 430
		}

		local i = `i' + 1

	}

					/* Update estimate of the Hessian
					 * using BFGS method */
	if $ML_ic != 0 {
		tempname dg db d dbdgp dgHdgp gPg bPb

		capture {
			mat `db' = $ML_b - $ML_dfp_b
			mat `dg' = $ML_g - $ML_dfp_g

			local H $ML_V		/* same matrix, short name */

			tempname dbdgp dgHdgp
			mat `dbdgp' = `db' * `dg'' 
			scalar `dbdgp' = `dbdgp'[1,1]
			mat `dgHdgp' = `dg' * `H' * `dg''
			scalar `dgHdgp' = `dgHdgp'[1,1]

							/* just for test */
			mat `gPg' = `dg' * `dg''
			mat `bPb' = `db' * `db''
			scalar `gPg' = `gPg'[1,1]
			scalar `bPb' = `bPb'[1,1]
		}
		if _rc {
			di as err "BFGS Hessian could not be "	/*
			*/ "updated; Hessian is unstable (1)"
			exit 430
		}

		if abs(`dbdgp'*`dgHdgp') > `eps'*`gPg'*`bPb' {
			capture {
				mat `d' = `db'' / `dbdgp' - `H'*`dg'' / `dgHdgp'

				mat `H' = `H' - `db''*`db' / `dbdgp' -    /*
				*/  (`H'*`dg'')*(`dg'*`H'') / `dgHdgp' +  /*
				*/  `dgHdgp'*`d'*`d''

				mat `H' = (`H' + `H'') / 2
			}
			if _rc {
				di as err "BFGS Hessian could not be " /*
				*/ "updated; Hessian is unstable (2)"
				exit 430
			}
		}
		else {
			if "$ML_rs_ct" == "" { global ML_rs_ct 0 }
			if $ML_rs_ct < `rstlmit' {
				if $ML_trace {
di as txt "BFGS stepping has contracted, resetting BFGS Hessian ($ML_rs_ct)"
				}
				mat $ML_V = I($ML_k)
				global ML_rs_ct = $ML_rs_ct + 1
			}
			else {
				di as err "flat $ML_crtyp encountered, " /*
					*/ "cannot find uphill direction"
				exit 430
			}

		}

	}
	else {
		mat $ML_V = I($ML_k)
	}

					/* Save current Beta and gradient */
	matrix $ML_dfp_b = $ML_b
	matrix $ML_dfp_g = $ML_g
end
exit

Derivatives and 2nd derivatives:

Centered first derivatives are:

	g_i_t = [f(X_t+hi)-f(Xt_t-hi)] / 2hi

We define hi = (|xi|+eps)*eps where eps is compute for each variable by
	ml_adjs.

end of file
