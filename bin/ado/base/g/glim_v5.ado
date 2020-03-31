*! version 1.1.0  02apr2009
program define glim_v5
	version 7
	args todo eta mu return

	if `todo' == -1 {			/* Title */
                local y     "$SGLM_y"
                local m     "$SGLM_m"
                local touse "`eta'"

                capture assert `y'>=0 if `touse'
                if _rc {
                        di as err `"dependent variable `y' has negative values"'
                        exit 499
                }

		global SGLM_vt "Inverse Gaussian"
		global SGLM_vf "u^3"
		global SGLM_mu "glim_mu 0 ."
		exit
	}
	if `todo' == 0 {
		gen double `eta' = 1/(`mu'*`mu')
		exit 
	}
	if `todo' == 1 {			/* V(mu) */
		gen double `return' =  `mu'*`mu'*`mu'
		exit 
	}
	if `todo' == 2 {			/* (d V)/(d mu) */
		gen double `return' = 3*`mu'*`mu'
		exit
	}
	if `todo' == 3 {			/* deviance */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = (`y'-`mu')^2/(`mu'^2*`y')
		exit
	}
	if `todo' == 4 {			/* Anscombe */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = (ln(`y')-ln(`mu'))/sqrt(`mu')
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
		gen double `return' = /*
			*/ -.5*((`y'-`mu')^2/(`y'*`mu'*`mu') + /*
			*/ ln(`y'*`y'*`y') + ln(2*_pi))
		exit
	}
	if `todo' == 6 {
		gen double `return' = `mu'*`mu'*`mu'*sqrt(`mu')/(2*$SGLM_ph*$SGLM_ph)
		exit 198
	}

	noi di as err "Unknown call to glim variance function"
	error 198
end
exit
