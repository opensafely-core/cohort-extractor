*! version 6.5.3  09oct2013
program define kalarma1
	version 8
	args F v1 Q Ap H XI R w colon bARMA sigma2
					/* all but bARMA and sigma2 are just 
					   names for matrices, See note at 
					   bottom and Hamilton for meanings */
	if "`colon'" != ":" {
		di in red "kalama1 syntax is F v1 Ap x H w : beta_arma sigma
		exit 198
	}
	/* AR#_terms */			/* names used by convention */
	/* MA#_terms */			/* for the eqns of the B matrix */
	local coleqs : coleq `bARMA'		/* Fetch Xb part of B */
	gettoken xeqnam : coleqs
	if ! ("`xeqnam'" == "$Tdepvar" | "`xeqnam'" == "eq1") {
		local hasX = 0
		mat `Ap' = ( 0 )
		mat colnames `Ap' = _cons
	}
	else {
		local hasX = 1 
		mat `Ap' = `bARMA'[1, "`xeqnam':"]
	}
 					/* Build transition matrices */
	tempname bAR bMA F0 H0
 	foreach s in $Tseasons {
					/* Handle AR# and MA# parts of B */
		cap mat `bAR' = `bARMA'[1, "AR`s'_terms:"]
		if _rc == 0 {
			_mat_mult_arma `F0' `bAR' 1 `s' -
		}
		cap mat `bMA' = `bARMA'[1, "MA`s'_terms:"]
		if _rc == 0 {
			_mat_mult_arma `H0' `bMA' 1 `s' +
		}
	}
	capture di `F0'[1,1]
	if ! _rc {
		local r = colsof(`F0')
		local has_ar = 1
	}
	else	local r = 1
	capture di `H0'[1,1]
	if ! _rc { 
		local r = max(`r', colsof(`H0')+1)
		local has_ma = 1
	}

	mat `F' = J(1,`r', 0)
	if 0`has_ar' { 
		mat `F'[1,1] = `F0' 
	}

	mat `H' = J(`r', 1, 0)
	mat `H'[1,1] = 1
	if 0`has_ma' { 
		mat `H'[2,1] = `H0'' 
	}

	if `r' > 1 { 
		mat `F' = `F' \ I(`r'-1), J(`r'-1, 1, 0) 
	}

					/* Initial state vector */
	mat `XI' = J(`r', 1, 0)

					/* Expected state 
					   disturbances v_t+1 ?? */
	mat `v1' = J(`r', 1, 0)

					/* Covariance matrix of state
					   disturbances */
	mat `Q' = J(`r', `r', 0)
	mat `Q'[1,1] = `sigma2'

					/* Observation disturbance vector */
	mat `w' = J(1, 1, 0)

					/* Observation disturbance
					   covariance matrix */
	mat `R' = J(1, 1, 0)

end

exit

Uses notation from
Hamilton, Time Series Analysis, 1994, Princeton University Press, Ch. 13.

Here are the basic Kalman filter relations:

	XI_(t+1) = F*XI + v_(t+1)

	y = A'*x + H'*XI + w


	E(v_t*v_tt) =  Q for t = tt, 
	               0 otherwise

	E(w_t*w_tt) =  R for t = tt, 
	               0 otherwise

Assumes some global macros have been set:
	Tseason -- a list of all the multiplicative delta's by equation
	Tdepvar -- the dependent variable for the model

Assumes the AR and MA equations have been stripped
		"L#.name L#.name ..." 
	where name is constant for the equation. #'s assumed to be in 
	ascending order.

Note:
        The transition matrix F will be dimensioned by the largest AR or MA
        lag.  This could cause problems with matrix size if the problem is
        sparse and has just a few very long seasonal lags (say a 365 for
        annual/daily).  


Usage:  
	kalarma1 F v1 Q Ap H XI R w : bARMA sigma2

	where all items to the left of the : are names used to receive
		the matrices built by kalarma1
