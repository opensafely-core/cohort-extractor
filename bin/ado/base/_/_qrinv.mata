*! version 1.1.0  01dec2004
version 9.0

mata:

real scalar _qrinv(numeric matrix A, | real scalar tol)
{
	real scalar    rank
	numeric matrix Ainv 

	if (rows(A)<cols(A)) _error(3200)	/* MRC_conformability	*/

	Ainv    = iscomplex(A) ? C(I(rows(A))) : I(rows(A))
	rank = _qrsolve(A, Ainv, tol)

	swap(A, Ainv)
	return(rank)
}

end
