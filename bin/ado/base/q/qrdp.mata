*! version 1.0.1  06jan2005
version 9.0

mata:

void qrdp(numeric matrix A, Q, R, real rowvector p)
{
	numeric rowvector tau
	numeric matrix	  H
	real scalar	  c_a, r_a
	scalar		  zero

	c_a   = cols(A)
	r_a   = rows(A)

	hqrdp(A ,H=., tau=., R=., p)
	zero = (iscomplex(A) ? 0i: 0)
	R = R \ J((r_a - c_a), c_a, zero)
	Q = hqrdq(H, tau)
}

end
