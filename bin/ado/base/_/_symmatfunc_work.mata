*! version 1.0.1  06nov2017
version 9.0

mata:

/*
	todo = 1             implies matrix log calculation
	todo = 2             implies matrix exp calculation 
	todo = anything else implies matrix power calculation
*/   

void _symmatfunc_work(real scalar todo, numeric matrix A, real scalar power)
{
	numeric rowvector	lambda
	numeric matrix		V
	real scalar		cx0, realel, n

	pragma unset lambda
	pragma unset V

	if ( (n=rows(A))==0 | cols(A)==0 ) return 
	/* ------------------------------------------------------------ */

	if (cx0 = iscomplex(A)) {
		if (isrealvalues(A)) {
			realel = 1
			A = Re(A)
		}
		else	realel = 0
	}
	else	realel = 1 

	_symeigensystem(A, V, lambda)	
	if (cx0) lambda  = C(lambda)

	/* ------------------------------------------------------------ */
	if (todo==1) 		lambda = ln(lambda) 
	else if (todo==2) 	lambda = exp(lambda)
	else 			lambda = lambda:^power
	/* ------------------------------------------------------------ */

	A = .
	if (missing(lambda)) {
		A = J(n, n, cx0 ? C(.) : .)
	}
	else {
		A = (lambda:*V)*(V')
		if (isrealvalues(lambda)) _makesymmetric(A)
		else if (realel) A = .5*(A+transposeonly(A))
	}
		
	/* ------------------------------------------------------------ */
}

end
