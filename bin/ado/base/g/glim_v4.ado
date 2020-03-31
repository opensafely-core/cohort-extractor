*! version 1.1.0  02apr2009
program define glim_v4
	version 7
	args todo eta mu return

	if `todo' == -1 {			/* Title */
		global SGLM_vt "Gamma"
		global SGLM_vf "u^2"
		global SGLM_mu "glim_mu 0 ."
		exit 
	}
	if `todo' == 0 {
		gen double `eta' = 1/`mu'
		exit
	}
	if `todo' == 1 {			/* V(mu) */
		gen double `return' =  `mu'*`mu'
		exit 
	}
	if `todo' == 2 {			/* (d V)/(d mu) */
		gen double `return' =  2*`mu'
		exit
	}
	if `todo' == 3 {			/* deviance */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = -2*(ln(`y'/`mu') - (`y'-`mu')/`mu')
		exit
	}
	if `todo' == 4 {			/* Anscombe */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = 3*(`y'^(1/3)-`mu'^(1/3))/`mu'^(1/3)
		exit
	}
	if `todo' == 5 {			/* ln-likelihood */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
                tempname sig2 
		if $SGLM_s1 {
			scalar `sig2' = $SGLM_s1
		}
		else {
			if _caller() >= 11 {
				scalar `sig2' = ///
					$SGLM_ph*(($ML_N-$ML_kCns)/$ML_N)
			}
			else {
				scalar `sig2' = ///
                                        $SGLM_ph*(($ML_N-$ML_k)/$ML_N)
			}
		}
		gen double `return' = -`y'/`mu' + ln(1/`mu')

		exit
	}	
	if `todo' == 6 {			/* Adjustment to deviance */
		gen double `return' = 1/(3*sqrt(1/$SGLM_ph))
		exit
	}

	noi di as err "Unknown call to glim variance function"
	error 198
end
exit

OLD CODE FOR ln-likelihood

		scalar `sig2' = 1/`sig2'
		gen double `return' = (`y'/`mu' - ln(`sig2'/`mu') - /*
			*/ ((`sig2'-1)/`sig2')*ln(`y') /*
			*/ + lngamma(`sig2')/(`sig2'))/(-`sig2')
