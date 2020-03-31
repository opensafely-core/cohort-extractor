*! version 1.0.1  28apr2000
program define glim_v7
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

		global SGLM_vt "Power"
		global SGLM_vf "u^($SGLM_p)"
		global SGLM_mu "glim_mu 0 ."
		exit
	}
	if `todo' == 0 {
		if $SGLM_a < 1e-7 {
			gen double `eta' = ln(`mu')
		}
		else {
			gen double `eta' = `mu'^$SGLM_a
		}
		exit
	}
	if `todo' == 1 {			/* V(mu) */
		gen double `return' =  `mu'^$SGLM_p
		exit 
	}
	if `todo' == 2 {			/* (d V)/(d mu) */
		gen double `return' = $SGLM_p*`mu'^($SGLM_p-1)
		exit
	}
	if `todo' == 3 {			/* deviance */
		gen double `return' = .
		exit
	}
	if `todo' == 4 {			/* Anscombe */
		gen double `return' = .
		exit
	}
	if `todo' == 5 {
		noi di as err "Power family supported by IRLS only"
		exit 198
	}
	noi di as err "Unknown call to glim variance function"
	error 198
end
