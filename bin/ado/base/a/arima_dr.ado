*! version 6.2.1  09sep2019
program define arima_dr
	version 6
	args 	    todo	/*  whether to calculate gradient
		*/  bc		/*  Name of full beta matrix
		*/  llvar	/*  Name of variable to hold LL_t */

	tempname sigma2 F v1 Q Ap H XI R w P Qvec Pvec
	tempvar ApX y_pred y_mse    /* y_mse returned by kalman but not used */

				/* handle constraints, if any */
	if "$TT" != "" {
		tempname b
		mat `b' = `bc' * $TT' + $Ta
		mat colnames `b' = $Tstripe
	}
	else	local b `bc'

	qui gen double `y_pred' = . in 1
	qui gen double `y_mse' = . in 1

	scalar `sigma2' = `b'[1, colsof(`b')]^2

	kalarma1 `F' `v1' `Q' `Ap' `H' `XI' `R' `w' : `b' `sigma2'

				/* Initial conditions for filter */

	if "$Tstate0" != "" { 
		mat `XI' = $Tstate0 
	}
	if "$Tp0" == "" {
		mata : kalman_solve_P0("`P'", "`F'", "`Q'")
	}
	else	mat `P' = $Tp0

	_kalman1 `y_pred' `y_mse' `llvar' :  /*
		*/ $Tdepvar `F' `v1' `Q' `Ap' `H' `XI' `w' `R' `P'  /*
		*/ if $ML_samp , p0

	tempname ll
	mlsum `ll' = `llvar'

	if missing(`ll') {
		quietly replace `llvar' = .
	}
end

version 9
mata:

void kalman_solve_P0(P0n, string scalar Fn, 
		     string scalar Qn) 
{
	real matrix F, vecQ, vecP0, P0
	real scalar i, m
	
	F = st_matrix(Fn)
	vecQ = vec(st_matrix(Qn))
	vecP0 = lusolve((I(rows(F)^2) - F#F), vecQ)
	/* Un-vec vecP0 */
	m = rows(F)
	P0 = J(m,m,.)
	for(i=1; i<=m; ++i) {
		P0[.,i] = vecP0[m*(i-1)+1 .. m*i]
	}
			
	st_matrix(P0n, P0)
}
end

exit

+
-

_mvec and _mfrmvec no longer used by -arima-.
