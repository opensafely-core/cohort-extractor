*! version 1.0.2  20jan2005
version 9.0

mata:

void _svd(numeric matrix A, s, Vt)
{
	real scalar 	m, n

	if ((m = rows(A))<(n = cols(A)))  _error(3200)  /* MRC_conformability */
	if (isview(A))                    _error(3104)	/* MRC_mm_view	*/

	if (m==0 | n==0) {
		if (iscomplex(A)) {
			A  = C(I(m,n))
			Vt = C(I(n))
		}
		else {
			A  = I(m,n) 
			Vt = I(n)
		}
		s  = J(0,1,.)
		return 
	}
	(void) _svd_la(A, s, Vt)
}

end
