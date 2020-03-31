*! version 1.0.1  28apr2000
program define glim_l03				/* Log */
	version 7
	args todo eta mu return

        if `todo' == -1 {                       /* Title */
                global SGLM_lt "Log"
		if "$SGLM_m" == "1" {
			global SGLM_lf "ln(u)"
		}
		else    global SGLM_lf "ln(u/$SGLM_m)"
                exit
        }
	if `todo' == 0 {			/* eta = g(mu) */
		gen double `eta' = ln(`mu'/$SGLM_m)
		exit 
	}
	if `todo' == 1 {			/* mu = g^-1(eta) */
		gen double `mu' = $SGLM_m*exp(`eta')
		exit 
	}
	if `todo' == 2 {			/* (d mu)/(d eta) */
		gen double `return' = `mu'
		exit 
	}
	if `todo' == 3 {			/* (d^2 mu)(d eta^2) */
		gen double `return' = `mu'
		exit
	}
	noi di as err "Unknown call to glim link function"
	exit 198
end
