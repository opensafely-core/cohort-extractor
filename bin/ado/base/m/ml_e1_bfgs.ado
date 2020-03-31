*! version 1.1.0  02may2007
program define ml_e1_bfgs
	version 8.0
	args calltype dottype
	// no need to check memory requirements
	if (`calltype' == -1) exit

	if "$ML_nosc" == "" {
		local sclist $ML_sclst
	}
	tempname tr	
	if `calltype' == 0 | `calltype' == 1 {
		$ML_user `calltype' $ML_b $ML_f $ML_g `tr' `sclist'
		ml_count_eval $ML_f `dottype'
		exit
	}
	$ML_user 1 $ML_b $ML_f $ML_g `tr' `sclist'
	ml_count_eval $ML_f input

					/* Update estimate of the Hessian
					 * using BFGS method */
	local eps 1e-8
	local rstlmit 100
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
			if "$ML_rs_ct" == "" {
				global ML_rs_ct 0
			}
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

