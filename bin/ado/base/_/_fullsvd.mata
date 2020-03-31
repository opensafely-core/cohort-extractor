*! version 1.1.2  20jan2005
version 9.0

mata:

void _fullsvd(numeric matrix A, U, s, Vt)
{
	real scalar 	m, n

	m = rows(A)
	n = cols(A)

	if (m==0 | n==0) {
		if (iscomplex(A)) {
			U  = C(I(m))
			Vt = C(I(n))
		}
		else {
			U  = I(m)
			Vt = I(n)
		}
		s  = J(0,1,.)
		return 
	}

	if (iscomplex(A) && n > m) {
		/* what follows is a workaround for a problem in 
		   _svd_la(), which has been communicated to 
		   authors of LAPACK
		*/
		A   = A'
		(void) _svd_la(A, U, s, Vt)
		A   = U
		U   = Vt'
		Vt  = A'
	}
	else {
		(void) _svd_la(A, U, s, Vt)
	}	
}
		
end
