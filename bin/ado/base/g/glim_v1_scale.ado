*! version 1.0.0  08mar2017
program define glim_v1_scale
	version 7
	args todo eta mu return
	if `todo' == -1 {			/* Title */
		global SGLM_vt "Gaussian"
		global SGLM_vf "1"
		global SGLM_mu "*"		
		exit
	}
	if `todo' == 0 {			/* Initialize eta */
		gen double `eta' = `mu'
		exit
	}
	if `todo' == 1 {			/* V(mu) */
		scalar `return' = 1 
		exit 
	}
	if `todo' == 2 {			/* (d V)/(d mu) */
		scalar `return' = 0 
		exit
	}
	if `todo' == 3 {			/* deviance */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = (`y'-`mu')^2
		exit
	}
	if `todo' == 4 {			/* Anscombe */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		gen double `return' = (`y'-`mu')
		exit
	}
	if `todo' == 5 {			/* ln-likelihood */
		local y "$SGLM_y"
		if "`y'" == "" {
			local y "`e(depvar)'"
		}
		tempname sig2
		scalar `sig2' = $SGLM_scale

		gen double `return' = -.5*((`y'-`mu')^2/`sig2' + /*
			*/ ln(2*_pi*`sig2'))
		exit
	}
	if `todo' == 6 {		/* Adjustment to deviances */
		gen double `return' = 0
		exit
	}	noi di as err "unknown call to glim variance function"
	error 198
end
