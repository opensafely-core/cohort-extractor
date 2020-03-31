*! version 1.1.0  19feb2019
program define glim_l07				/* Cloglog */
	version 7
	args todo eta mu return

        if `todo' == -1 {                       /* Title */
                global SGLM_lt "Complementary log-log"
		if "$SGLM_m" == "1" {
			global SGLM_lf "ln(-ln(1-u))"
		}
		else    global SGLM_lf "ln(-ln(1-u/$SGLM_m))"
                exit
        }
	if `todo' == 0 {			/* eta = g(mu) */
		gen double `eta' = ln(-ln1m(`mu'/$SGLM_m))
		exit 
	}
	if `todo' == 1 {			/* mu = g^-1(eta) */
		gen double `mu' = $SGLM_m*(-expm1(-exp(`eta')))
		exit 
	}
	if `todo' == 2 {			/* (d mu)/(d eta) */
		gen double `return' = (`mu'-$SGLM_m)*ln1m(`mu'/$SGLM_m)
		exit 
	}
	if `todo' == 3 {			/* (d^2 mu)(d eta^2) */
		gen double `return' = (`mu'-$SGLM_m)*ln1m(`mu'/$SGLM_m)* /*
				*/ (1+ln1m(`mu'/$SGLM_m))
		exit
	}
	noi di as err "Unknown call to glim link function"
	exit 198
end
