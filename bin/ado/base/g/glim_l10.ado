*! version 1.0.1  28apr2000
program define glim_l10				/* Power(-2) */
	version 7
	args todo eta mu return

        if `todo' == -1 {                       /* Title */
                global SGLM_lt "Power(-2)"
                global SGLM_lf "1/(u^2)"
                exit
        }
	if `todo' == 0 {			/* eta = g(mu) */
		gen double `eta' = ($SGLM_m/`mu')*($SGLM_m/`mu')
		exit 
	}
	if `todo' == 1 {			/* mu = g^-1(eta) */
		gen double `mu' = $SGLM_m/sqrt(`eta')
		exit 
	}
	if `todo' == 2 {			/* (d mu)/(d eta) */
		gen double `return' = -(`mu'*`mu'*`mu')/(2*$SGLM_m*$SGLM_m)
		exit 
	}
	if `todo' == 3 {			/* (d^2 mu)(d eta^2) */
		gen double `return' = (3*`mu'*`mu'*`mu'*`mu'*`mu') / /*
			*/ (4*$SGLM_m*$SGLM_m*$SGLM_m*$SGLM_m)
		exit
	}
	noi di as err "Unknown call to glim link function"
	exit 198
end
