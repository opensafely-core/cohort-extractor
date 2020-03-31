*! version 1.0.1  06nov2017
version 9.0

mata:

void _lud(numeric matrix L, U, p)
{
	real scalar	m
	real colvector	r

	pragma unset r		// [sic]
	pragma unused r

	_lud2_la(L, r, .)

	U = uppertriangle(L, .)

	if (rows(L)==cols(L)) _lowertriangle(L, 1)
	else		      L = lowertriangle(L, 1)

	if ((m = rows(L)) == 0) p = J(0, 1, .)
	else 			_rowswap(p=1::m, r, -1)
}

/* static */ void _rowswap(numeric matrix A, real colvector p, real scalar d)
{
	real scalar r_p, i
	real matrix hold

	if (mata_representation(A)!="Array") _error(3103)

	r_p=rows(p)

	if (d==1) {
		for (i=1; i<=r_p; i++) {
			if (i != p[i]) {
				hold = A[i,.]
				A[i,.] = A[p[i],.]
				A[p[i],.] = hold
			}
		}
	}
	else if (d==-1) {
		for (i=r_p; i>=1; i--) {
			if ( i != p[i] ) {
				hold = A[i,.]
				A[i,.] = A[p[i],.]
				A[p[i],.] = hold
			}
		}
	}
	else 	_error(3300)
}
end
