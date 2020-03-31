*! version 1.3.0  30jun2008
program define ml_elf_bhhh
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
	tempname wrk h
	tempvar one x0

	mat $ML_g = J(1,$ML_k,0)
	qui gen byte `one' = 1 if $ML_samp
	mat `h' = J(1, $ML_n, 0)

	if "$ML_wtyp" == "" {
		local wt [fw=$ML_w]
	}
	else	local wt [$ML_wtyp=$ML_w]

	quietly {
		local i 1
		while `i'<=$ML_n {
			if "${ML_xc`i'}" == "nocons" {
				local vl`i' ${ML_x`i'}
			}
			else 	local vl`i' ${ML_x`i'} `one'

			local se ${ML_fp`i'}
			local ee ${ML_lp`i'}

			tempvar fph`i' fmh`i' g`i'
			local glist `glist' `g`i''

			rename `x`i'' `x0'

						/* calculate stepsize `hi',
						   `fph`i'', and `fmh`i'' */

  		 	noi ml_adjs elf `i' `fph`i'' `fmh`i'' `x0' `list'
			matrix `h'[1,`i'] = r(step)
			local hi `h'[1,`i']

						/* gradient calculation */

			gen double `g`i''=(`fph`i''-`fmh`i'')/(2*`hi')
			matrix vecaccum `wrk' = `g`i'' `vl`i'' `wt', nocons
			mat subst $ML_g[1,`se'] = `wrk'

			drop `x`i''
			rename `x0' `x`i''

			local i=`i'+1
		} /* i loop */
	} /* quietly */
					/* Estimate Hessian as outer
					 * product of gradients_t */
	mat $ML_V = I($ML_k)
	version 11: _cpmatnm $ML_b, square($ML_V)
	capture _robust2 `glist' `wt' if $ML_samp,	///
		variance($ML_V) minus(0)
	if c(rc) {
		di as err "bhhh requires observation level scores"
		exit 504
	}
	if "$ML_showh" != "" {
		ml_showh `h'
	}
end
exit

