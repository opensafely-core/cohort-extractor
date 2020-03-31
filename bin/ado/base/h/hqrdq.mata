*! version 1.0.1  06jan2005
version 9.0

mata:

numeric matrix hqrdq(numeric matrix H, numeric rowvector tau) 
{
	numeric matrix Q

	if (iscomplex(H)) {
		Q = C(I(rows(H)),J(rows(H),rows(H),0) )
	}
	else {
		Q = I(rows(H))
	}
	_hqrdmult(H, tau, Q,0)
	return(Q)
}

end
