*! version 1.2.0  19feb2019
program define glim_v6
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
		global SGLM_vt "Neg. Binomial"
		local SGLM_a = round($SGLM_a,0.0001)
		global SGLM_vf "u+(`SGLM_a')u^2"
		global SGLM_mu "glim_mu 0 ."
		exit
	}
	if `todo' == 0 {
		gen double `eta' = -ln1p($SGLM_a/`mu')
		exit 
	}
	if `todo' == 1 {			/* V(mu) */
		gen double `return' =  `mu'+`mu'*`mu'*$SGLM_a
		exit 
	}
	if `todo' == 2 {			/* (d V)/(d mu) */
		gen double `return' = 1 + 2*`mu'*$SGLM_a
		exit
	}
	if `todo' == 3 {			/* deviance */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = cond(`y'==0, /*
                         */ 2*ln1p(`mu'*$SGLM_a)/$SGLM_a, /*
                         */ 2*(`y'*ln(`y'/`mu') - /*
			*/ (1+`y'*$SGLM_a)/$SGLM_a *  /*
                         */ ln((1+`y'*$SGLM_a)/(1+`mu'*$SGLM_a))))
		exit
	}
	if `todo' == 4 {			/* Anscombe */
		local y "$SGLM_y"
		local k "$SGLM_a"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = ((_hyp2f1(-`k'*`y') - /*
			*/ _hyp2f1(-`k'*`mu')) /*
		        */ + 3/2*(`y'^(2/3) /*
		        */ -`mu'^(2/3)))/((`mu'+`k'*`mu'^2)^(1/6))
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
		local m       = 1/$SGLM_a
		local lnalpha = ln(`m')
		gen double `return' = `sig2'*(lngamma(`m'+`y')-lngamma(`y'+1) /*
			*/ - lngamma(`m') - `m'*ln1p(`mu'/`m') /*
			*/ + `y'*ln(`mu'/(`mu'+`m')))
		exit
	}
	if `todo' == 6 {
		noi di as err "Adjusted deviance residuals not supported for this family"
		gen double `return' = (2 - `mu') / sqrt(`mu'+`mu'*`mu'*$SGLM_a)
		exit 198
	}
	noi di as err "Unknown call to glim variance function"
	error 198
end
