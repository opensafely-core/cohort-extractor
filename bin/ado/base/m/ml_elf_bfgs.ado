*! version 1.1.0  09may2007
program define ml_elf_bfgs
	version 8.0
	args calltype dottype
	// no need to check memory requirements
	if (`calltype' == -1) exit

	local i 1
	while `i' <= $ML_n {
		tempname x`i'
		qui mat score double `x`i'' = $ML_b if $ML_samp, eq(#`i')
		if "${ML_xo`i'}${ML_xe`i'}" != "" {
			if "${ML_xo`i'}" != "" {
				qui replace `x`i'' = `x`i'' + ${ML_xo`i'}
			}
			else 	qui replace `x`i'' = `x`i'' + ln(${ML_xe`i'})
		}
		local list `list' `x`i''
		local i = `i' + 1
	}

	tempvar f
	qui gen double `f' = . in 1

	$ML_vers $ML_user `f' `list'
	ml_count_eval `f' `dottype'

	mlsum $ML_f = `f'

	if (`calltype'==0 | scalar($ML_f)==.) exit


				/* we now continue to make derivative
				   calculations
				*/
	tempname nfac wrk h
	tempvar one x0 grad

	qui gen byte `one' = 1 if $ML_samp
	mat $ML_g = J(1, $ML_k, 0)
	mat `h' = J(1, $ML_n, 0)

	quietly {
		local i 1
		while `i'<=$ML_n {
			if "${ML_xc`i'}" == "nocons" {
				local vl`i' ${ML_x`i'}
			}
			else 	local vl`i' ${ML_x`i'} `one'

			local se ${ML_fp`i'}
			local ee ${ML_lp`i'}

			tempvar fph`i' fmh`i'

			rename `x`i'' `x0'

						/* calculate stepsize `hi',
						   `fph`i'', and `fmh`i'' */

  		 	noi ml_adjs elf `i' `fph`i'' `fmh`i'' `x0' `list'
			matrix `h'[1,`i'] = r(step)
			local hi `h'[1,`i']

						/* gradient calculation */

			gen double `grad'=$ML_w*(`fph`i''-`fmh`i'')/(2*`hi')
			matrix vecaccum `wrk' = `grad' `vl`i'', nocons
			mat subst $ML_g[1,`se'] = `wrk'
			drop `grad'

			drop `x`i''
			rename `x0' `x`i''

			local i=`i'+1
		} /* i loop */
	} /* quietly */
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
	if "$ML_showh" != "" {
		ml_showh `h'
	}
end
exit

