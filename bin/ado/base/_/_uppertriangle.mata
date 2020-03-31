*! version 1.0.2  22nov2004
version 9.0

mata:

void _uppertriangle(numeric matrix A, |numeric scalar d)
{
	real scalar	i, n
	real scalar	repdiag
	numeric scalar	zero

	if ((n=rows(A))!=cols(A)) _error(3205)
	if (n==0) return ; 

	repdiag = (d<.)
	if (repdiag & iscomplex(d)) {
		if (isreal(A)) A = C(A)
	}
	zero = (iscomplex(A) ? 0i : 0)

	if (repdiag) A[1,1] = d
	for (i=2; i<=n; i++) {
		A[|i,1\i,i-1|] = J(1, i-1, zero)
		if (repdiag) A[i,i] = d
	}
}

end
