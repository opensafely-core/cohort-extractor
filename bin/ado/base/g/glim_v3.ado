*! version 1.1.0  02apr2009
program define glim_v3
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
		capture assert `y'==int(`y') if `touse'
		if _rc {
			di as txt `"note: `y' has noninteger values"'
		}
		global SGLM_vt "Poisson"
		global SGLM_vf "u"
		global SGLM_mu "glim_mu 0 ."
		exit
	}
	if `todo' == 0 {
		gen double `eta' = ln(`mu')
		exit 
	}
	if `todo' == 1 {			/* V(mu) */
		gen double `return' =  `mu'
		exit 
	}
	if `todo' == 2 {			/* (d V)/(d mu) */
		gen byte `return' = 1
		exit
	}
	if `todo' == 3 {			/* deviance */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = cond(`y'==0, 2*`mu', /*
                         */ 2*(`y'*ln(`y'/`mu')-(`y'-`mu')))
		exit
	}
	if `todo' == 4 {			/* Anscombe */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = 1.5*(`y'^(2/3)-`mu'^(2/3)) / `mu'^(1/6)
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
		gen double `return' = `sig2'*(-`mu'+`y'*ln(`mu')-lngamma(`y'+1))
		exit
	}
	if `todo' == 6 {
		gen double `return' = 1/(6*sqrt(`mu'))
		exit
	}
	noi di as err "Unknown call to glim variance function"
	error 198
end
