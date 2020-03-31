*! version 1.0.3  06nov2017
version 9.0
mata:

numeric matrix uppertriangle(numeric matrix A, | numeric scalar d) 
{
	numeric matrix	U
	real matrix	idx
	real scalar	r_a, c_a, r_u, i
	real scalar	repdiag

	r_u = ((r_a=rows(A)) < (c_a=cols(A)) ? r_a : c_a ) 
	repdiag = (d<.)
	U = J(r_u, c_a, ((iscomplex(A) | (repdiag & iscomplex(d))) ? 0i : 0))

	for(i=1; i<=r_u; i++) {
		idx = (i,i \ i,c_a)
		U[|idx|] = A[|idx|]
		if (repdiag) U[i,i] = d
	}
	return(U)
}

end
