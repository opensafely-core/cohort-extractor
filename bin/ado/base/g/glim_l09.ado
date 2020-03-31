*! version 1.0.1  28apr2000
program define glim_l09				/* Reciprocal */
	version 7
	args todo eta mu return

        if `todo' == -1 {                       /* Title */
                global SGLM_lt "Reciprocal"
		if "$SGLM_m" == "1" {
			global SGLM_lf "1/u"
		}
		else    global SGLM_lf "$SGLM_m/u"
                exit
        }
	if `todo' == 0 {			/* eta = g(mu) */
		gen double `eta' = $SGLM_m/`mu'
		exit 
	}
	if `todo' == 1 {			/* mu = g^-1(eta) */
		gen double `mu' = $SGLM_m/`eta'
		exit 
	}
	if `todo' == 2 {			/* (d mu)/(d eta) */
		gen double `return' = -`mu'*`mu'/$SGLM_m
		exit 
	}
	if `todo' == 3 {			/* (d^2 mu)(d eta^2) */
		gen double `return' = 2*`mu'*`mu'*`mu'/($SGLM_m*$SGLM_m)
		exit
	}
	noi di as err "Unknown call to glim link function"
	exit 198
end
