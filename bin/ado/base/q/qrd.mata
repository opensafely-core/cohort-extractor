*! version 1.0.1  06jan2005
version 9.0

mata:

void qrd(numeric matrix A, Q, R)
{
	numeric rowvector tau
	real scalar	  c_a, r_a
	scalar 		  zero

	Q     = A
	r_a   = rows(A)
	c_a   = cols(A)

	_hqrd(Q, tau=., R)
	
	zero = (iscomplex(A) ? 0i: 0)

	R = R \ J((r_a - c_a), c_a, zero)
	Q = hqrdq(Q, tau)
}

end
