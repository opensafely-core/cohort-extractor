*! version 6.0.1  05nov1998
program define ml_bhhhs
	version 6
	tempvar ll_plus ll_subt

	local i 1
	while `i' <= $ML_k {
					/*  calculate stepsize -- delta
					 *  ll_plus = f(X_i+delta) and 
					 *  ll_subt = f(X_i-delta) */

		noi ml_adjs erd `i' `ll_plus' `ll_subt'

					/* gradient calculation */

		qui gen double ``i'' = (`ll_plus' - `ll_subt') /	/*
			*/  (2*r(step)) if $ML_samp

		local i = `i' + 1

	}

end
exit


Computes and returns score variables for method rdu0
