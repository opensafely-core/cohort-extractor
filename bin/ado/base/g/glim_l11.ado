*! version 1.0.1  28apr2000
program define glim_l11				/* Power(a) */
	version 7
	args todo eta mu return

        if `todo' == -1 {                       /* Title */
                global SGLM_lt "Power"
		if "$SGLM_m" == "1" {
			global SGLM_lf "u^($SGLM_p)"
		}
		else    global SGLM_lf "(u/$SGLM_m)^($SGLM_p)"
                exit
        }
	if `todo' == 0 {			/* eta = g(mu) */
		gen double `eta' = (`mu'/$SGLM_m)^($SGLM_p)
		exit 
	}
	if `todo' == 1 {			/* mu = g^-1(eta) */
		gen double `mu' = $SGLM_m*`eta'^(1/$SGLM_p)
		exit 
	}
	if `todo' == 2 {			/* (d mu)/(d eta) */
		gen double `return' = `mu'^(1-$SGLM_p)*$SGLM_m^$SGLM_p/$SGLM_p
		exit 
	}
	if `todo' == 3 {			/* (d^2 mu)(d eta^2) */
		gen double `return' = `mu'^(1-2*$SGLM_p)*(1/$SGLM_p)* /*
					*/ (1/$SGLM_p-1)*$SGLM_m^$SGLM_p
		exit
	}
	noi di as err "Unknown call to glim link function"
	exit 198
end
