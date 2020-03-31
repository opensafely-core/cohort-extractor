*! version 1.0.1  28apr2000
program define glim_l08				/* Probit */
	version 7
	args todo eta mu return

	if `todo' == -1 {
		global SGLM_lt "Probit"
		if "$SGLM_m" == "1" {
			global SGLM_lf "invnorm(u)"
		}
		else    global SGLM_lf "invnorm(u/$SGLM_m)"
		exit
	}
	if `todo' == 0 {			/* eta = g(mu) */
		gen double `eta' = invnorm(`mu'/$SGLM_m)
		exit 
	}
	if `todo' == 1 {			/* mu = g^-1(eta) */
		gen double `mu' = $SGLM_m*normprob(`eta')
		exit 
	}
	if `todo' == 2 {			/* (d mu)/(d eta) */
		gen double `return' = $SGLM_m*normd(invnorm(`mu'/$SGLM_m))
		exit 
	}
	if `todo' == 3 {			/* (d^2 mu)(d eta^2) */
		gen double `return' = -$SGLM_m*invnorm(`mu'/$SGLM_m)* /*
			*/ normd(invnorm(`mu'/$SGLM_m))
		exit
	}
	noi di as err "Unknown call to glim link function"
	exit 198
end
