*! version 2.0.3  06nov2017
version 9.0

mata:

real scalar _pinv(numeric matrix A, |real scalar tol)
{
	real scalar 	r_a, c_a, rank, isa, thin
	numeric matrix 	U, Vt, s

	pragma unset U
	pragma unset Vt
	pragma unset s

	/* ------------------------------------------------------------ */
	thin = ((r_a=rows(A)) >= (c_a=cols(A))) 
	isa  = iscomplex(A) 

	/* ------------------------------------------------------------ */
	if (r_a == 0 | c_a==0 ) {		/* void			*/
		A = J(c_a, r_a, isa ? 0i : 0)
		return(0)
	}

	/* ------------------------------------------------------------ */
	if (thin) {
		_svd(A, s, Vt)
		swap(A, U)
	}
	else	_fullsvd(A, U, s, Vt)

	rank = rank_from_singular_values(s, tol)

	if (rank>=.) {
		A = J(c_a, r_a, isa ? C(.) : .)
		return(.)
	}
	if (rank==0) {
		A = J(c_a, r_a, isa ? 0i : 0)
		return(0)
	}
	
	/* ------------------------------------------------------------ */

		/*
			(E*F)[|1,1\r,c|] =   E[|1,1\r,.|] * F[|1,1\.,c|]

			we want 
				U  = (U'B)[|1,1 \ rank,r_a|]
		*/

	_transpose(Vt)
	s  = 1:/s[|1\rank|]

	_transpose(U)
	U = (r_a==c_a & rank==c_a ? U : U[|1,1 \ rank,r_a|])
	A = ( rank==c_a ?  Vt*(s:*U) : Vt[|1,1 \ c_a,rank|]*(s:*U) )

	return(rank)
}

end
