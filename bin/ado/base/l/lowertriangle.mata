*! version 1.0.3  06nov2017
version 9.0

mata:

numeric matrix lowertriangle(numeric matrix A, | numeric scalar d) 
{
	numeric matrix	U
	real matrix	idx
	real scalar	r_a, c_a, c_u, i, maxj
	real scalar	repdiag

	c_u = ((r_a=rows(A)) < (c_a=cols(A)) ? r_a : c_a ) 
	repdiag = (d<.)
	U = J(r_a, c_u, ((iscomplex(A) | (repdiag & iscomplex(d))) ? 0i : 0))
	if (c_u==0) return(U)

	for(i=1; i<=r_a; i++) {
		maxj = (i<c_u ? i : c_u)
		idx = (i,1 \ i,maxj)
		U[|idx|] = A[|idx|]
		if (repdiag & i<=maxj) U[i,i] = d
	}
	return(U)
}

end
