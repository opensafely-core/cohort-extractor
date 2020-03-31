*! version 1.0.1  06nov2017
version 9.0

mata:

complex rowvector polyroots(numeric rowvector userc) 
{
	numeric rowvector c
	numeric matrix    cmpn
	real scalar       n, nm1, i, cmplxc 
	numeric scalar    cn, scale, one

	c = polytrim(userc)

	n   = cols(c)
	if (n==0) _error(3200) 		/* MRC_conformability */
	nm1 = n-1

	if (missing(c)) return(J(1,n,C(.)))

	cmplxc = iscomplex(c) 
	cmpn   = J(nm1, nm1, (cmplxc ? 0i : 0))
	one    = (cmplxc ? C(1) : 1)

	cn   = c[n]
	
	if (!cmplxc) {
		scale = 1/cn
	}
	else {
		scale = Re(cn)^2 + Im(cn)^2
		scale = C(Re(cn)/scale, -Im(cn)/scale)
	}

	for(i=1; i<=nm1; i++) {
		cmpn[1,i] = -c[n-i]*scale
		if (i<nm1) cmpn[i+1, i] = one
	}

	return(eigenvalues(cmpn))
}

end
