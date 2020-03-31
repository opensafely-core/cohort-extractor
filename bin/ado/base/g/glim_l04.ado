*! version 1.0.2  05dec2000
program define glim_l04				/* Negative binomial */
	version 7
	args todo eta mu return

        if `todo' == -1 {                       /* Title */
                global SGLM_lt "Neg. Binomial"
                global SGLM_lf "ln(u/(u+(1/$SGLM_a)))"
                exit
        }
	if `todo' == 0 {			/* eta = g(mu) */
		gen double `eta' = ln(`mu'/(`mu'+(1/$SGLM_a)))
		exit 
	}
	if `todo' == 1 {			/* mu = g^-1(eta) */
		gen double `mu' = (1/$SGLM_a)/(exp(-`eta')-1)
		exit 
	}
	if `todo' == 2 {			/* (d mu)/(d eta) */
		gen double `return' = `mu'*(1+`mu'*$SGLM_a)
		exit 
	}
	if `todo' == 3 {			/* (d^2 mu)(d eta^2) */
		gen double `return' = `mu'*(1+`mu'*$SGLM_a)*(1+2*`mu'*$SGLM_a)
		exit
	}
	noi di as err "Unknown call to glim link function"
	exit 198
end
