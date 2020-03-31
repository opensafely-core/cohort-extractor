*! version 1.1.1  02feb2012
program define ml_e0_dfp
	version 8.0
	args calltype dottype
	// no need to check memory requirements
	if (`calltype' == -1) exit

	tempname unused
	$ML_vers $ML_user 0 $ML_b $ML_f `unused'
	ml_count_eval $ML_f `dottype'

	if (`calltype' == 0 | scalar($ML_f) == .) exit

	mat $ML_g = J(1, $ML_k, 0)
	tempname ll_plus ll_subt h
	matrix `h' = J(1,$ML_k,0)	/* perturbations 		*/
	local i 1
	while `i' <= $ML_k {
					/*  calculate stepsize -- r(step)
					 *  ll_plus = f(X_i+step) and 
					 *  ll_subt = f(X_i-step) */

		noi ml_adjs e0 `i' `ll_plus' `ll_subt'
		mat `h'[1,`i']   = r(step)

					/* gradient calculation */

		capture mat $ML_g[1,`i'] = (`ll_plus' - `ll_subt') / (2*r(step))
		if _rc {
			di as err "DFP Hessian could not be "	/*
			*/ "updated; Hessian is unstable"
			exit 430
		}

		local i = `i' + 1

	}
	if "$ML_showh" != "" {
		ml_showh `h'
	}

					/* Update estimate of the Hessian
					 * using DFP method */
	local eps 1e-8
	local rstlmit 10
	if $ML_ic != 0 {
		tempname dbdgp dgHdgp gPg bPb dg db 

		capture {
			mat `db' = $ML_b - $ML_dfp_b
			mat `dg' = $ML_g - $ML_dfp_g

			local H $ML_V		/* same matrix, short name */

			mat `dbdgp' = `db' * `dg'' 
			scalar `dbdgp' = `dbdgp'[1,1]
			mat `dgHdgp' = `dg' * `H' * `dg''
			scalar `dgHdgp' = `dgHdgp'[1,1]
			mat `gPg' = `dg' * `dg''
			mat `bPb' = `db' * `db''
			scalar `gPg' = `gPg'[1,1]
			scalar `bPb' = `bPb'[1,1]
		}
		if _rc {
			di as err "DFP Hessian could not be "	/*
			*/ "updated; Hessian is unstable"
			exit 430
		}

		if abs(`dbdgp'*`dgHdgp') > `eps'*`gPg'*`bPb' {
			capture {
				mat `H' = `H' - `db''*`db' / `dbdgp' -	/*
				*/ (`H'*`dg'')*(`dg'*`H'') / `dgHdgp'

				mat `H' = (`H' + `H'') / 2
			}
			if _rc {
				di as err "DFP Hessian could not be "	/*
				*/ "updated; Hessian is unstable"
				exit 430
			}
		}
		else {
			if "$ML_rs_ct" == "" {
				global ML_rs_ct 0
			}
			if $ML_rs_ct < `rstlmit' {
				if $ML_trace {
di as txt "DFP stepping has contracted, resetting DFP Hessian"
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

We define hi = (|xi|+eps)*eps where eps is sqrt(machine precision) or
maybe cube root.

end of file
