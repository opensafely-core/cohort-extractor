*! version 1.0.2  22nov2004
version 9.0

mata:

void _lowertriangle(numeric matrix A, | numeric scalar d)
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

	for (i=1; i<n /*sic*/; i++) {
		A[|i,i+1\i,n|] = J(1, n-i, zero)
		if (repdiag) A[i,i] = d
	}
	if (repdiag) A[n,n] = d
}

end
