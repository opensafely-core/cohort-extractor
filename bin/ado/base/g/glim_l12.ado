*! version 1.0.1  28apr2000
program define glim_l12				/* Odds power(a) */
	version 7
	args todo eta mu return

        if `todo' == -1 {                       /* Title */
                global SGLM_lt "Odds power"
		if "$SGLM_m" == "1" {
			global SGLM_lf "((u/(1-u))^($SGLM_p)-1)/($SGLM_p)"
		}
		else    global SGLM_lf "((u/($SGLM_m-u))^($SGLM_p)-1)/($SGLM_p)"
                exit
        }
	if `todo' == 0 {			/* eta = g(mu) */
		gen double `eta' = ((`mu'/($SGLM_m-`mu'))^($SGLM_p)-1)/$SGLM_p
		exit 
	}
	if `todo' == 1 {			/* mu = g^-1(eta) */
		gen double `mu' = $SGLM_m*(1+$SGLM_p*`eta')^(1/$SGLM_p) / /*
				*/ (1 + (1+$SGLM_p*`eta')^(1/$SGLM_p)) 
		exit 
	}
	if `todo' == 2 {			/* (d mu)/(d eta) */
		gen double `return' = $SGLM_m*(`mu'/$SGLM_m)^(1-$SGLM_p) * /*
			*/ (1-`mu'/$SGLM_m)^(1+$SGLM_p)
		exit 
	}
	if `todo' == 3 {			/* (d^2 mu)(d eta^2) */
		gen double `return' = $SGLM_m*(`mu'/$SGLM_m)^(1-$SGLM_p) * /*
			*/ (1-`mu'/$SGLM_m)^(1+$SGLM_p)
		replace `return' = `return' * `return' * /*
			*/ ($SGLM_m*(1-$SGLM_p)/`mu' - /*
			*/ $SGLM_m*(1+$SGLM_p)/($SGLM_m-`mu'))
		exit
	}
	noi di as err "Unknown call to glim link function"
	exit 198
end
