*! version 1.1.4  06nov2017
version 9.0

mata:

real scalar _svsolve(numeric matrix A, numeric matrix B, |real scalar tol)
{
	real scalar 	r_a, c_a, c_b, r_b, rank
	numeric matrix 	U, Vt, s
	real scalar 	isa, isb, reltol, thin

	pragma unset U
	pragma unset Vt
	pragma unset s

	/* ------------------------------------------------------------ */
	thin = ((r_a=rows(A)) >= (c_a=cols(A))) 

	r_b = rows(B)
	c_b = cols(B)
	if (r_a!=r_b) _error(3200)	/* MRC_conformability		*/

	isa = iscomplex(A)
	isb = iscomplex(B)

	/* ------------------------------------------------------------ */
	if (r_a == 0 | c_a==0 ) {		/* void			*/
		B = J(c_a, c_b, isa|isb ? 0i : 0)
		return(0)
	}

	if (isa | isb) {
		if (!isa) A = C(A)
		if (!isb) B = C(B)
	}

	/* ------------------------------------------------------------ */
	if (thin)     _svd(A,    s, Vt)
	else      _fullsvd(A, U, s, Vt)

	if (s[1]>=.) {			/* missing or not converged 	*/
		B = J(c_a, c_b, .)
		return(0)
	}
	reltol = (tol>=.    ? 1       : tol)
	reltol = (reltol<=0 ? -reltol : (r_a)*s[1]*epsilon(1)*reltol)

	if (s[1] <= reltol) {
		B = J(c_a, c_b, isa|isb ? 0i : 0)
		return(0)
	}
	for (rank=c_a<r_a ? c_a : r_a; rank>=1; rank--) {
		if (s[rank] > reltol) break 
	}
	
	/* ------------------------------------------------------------ */

		/*
			(E*F)[|1,1\r,c|] =   E[|1,1\r,.|] * F[|1,1\.,c|]

			we want 
				U  = (U'B)[|1,1 \ rank,c_b|]
		*/

	_transpose(Vt)
	s  = 1:/s[|1\rank|]

	if (thin) {
		_transpose(A)
		A = (r_a==c_a & rank==c_a ? A*B : A[|1,1 \ rank,r_a|] * B)
		B = ( rank==c_a ?  Vt*(s:*A) : Vt[|1,1 \ c_a,rank|]*(s:*A) )
	}
	else {
		_transpose(U)
		U = (r_a==c_a & rank==c_a ? U*B : U[|1,1 \ rank,r_a|] * B)
		B = ( rank==c_a ?  Vt*(s:*U) : Vt[|1,1 \ c_a,rank|]*(s:*U) )
	}	

	return(rank)
}

end
