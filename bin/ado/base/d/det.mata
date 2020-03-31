*! version 1.0.1  06nov2017
version 9.0

mata:

numeric scalar det(numeric matrix A)
{
	numeric matrix	LU
	real colvector	r
	real scalar	n, i, sgn
	
	pragma unset r		// [sic]
	pragma unused r

	if ((n=rows(A)) != cols(A)) _error(3205)
	if (n==0) return(iscomplex(A) ? C(1) : 1)

	_lud2_la(LU=A, r, .)
	n = rows(r)
	for (sgn=i=1; i<=n; i++) {
		if (r[i]!=i) sgn = -sgn
	}
	return(sgn*dettriangular(LU))
}

end
