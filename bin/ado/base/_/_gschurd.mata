*! version 1.0.0  24feb2009
version 11.0

mata:

void _gschurd(numeric matrix T, R, U, V, w, beta)
{
	numeric matrix 	U0, lscale, rscale, R1
	real scalar 	needhess, needqr, info, ilo, ihi, n
	scalar 		zero
	
	
	if((rows(T) != cols(T)) || (rows(R) != cols(R))) {
		_error(3200)
		return
	} 
		
	if((rows(T) != rows(R)) || (cols(T) != cols(R))) {
		_error(3200)
		return
	}
	
 	if(isreal(T) != isreal(R)) {
		_error(3200)
		return
	}

	if(hasmissing(T) || hasmissing(R)) {
	 	T = R = U = V = J(rows(T), cols(T), .)
	 	w = beta = J(1, cols(T), .)
	 	return
 	}
 	
	zero 	= (iscomplex(T) ? 0i: 0)
	U0 	= .
	R1 	= .
	needqr 	= 0
	n 	= cols(R)
	
	_flopin(T)
	_flopin(R)

	if(iscomplex(T)) {
		(void)LA_ZGGBAL("P", ., T, ., R, ., ilo=., ihi=., lscale=., 
				rscale=., ., info=.)
	}
	else {
		(void)LA_DGGBAL("P", ., T, ., R, ., ilo=., ihi=., lscale=., 
				rscale=., ., info=.) 	
	}
	
	_flopout(R)
	_flopout(T)
	
	if(sublowertriangle(R, 1) != J(n, n, (iscomplex(R) ? 0i : 0))) {
		(void)qrd(R, U0, R1)	
		T 	= U0'*T
		R 	= R1
		needqr 	= 1
	}
		
	needhess = 0
	if(sublowertriangle(T, 2) != J(n, n, zero)) needhess = 1
	
	_flopin(T)
	_flopin(R)	

	if(needhess) {
		(void)_ghessenbergd_la(T, R, U=., V=., ilo, ihi, 1, 1)
	}
	else {
		U = I(n) + J(n, n,zero)  
		V = I(n) + J(n, n,zero)
		_flopin(U)
		_flopin(V)
	}

	if(needqr) {
		info = _gschurd_la(T, R, U, V, w=., beta=., ilo, ihi, 1, 0)
 	}
	else { 
		info = _gschurd_la(T, R, U, V, w=., beta=., ilo, ihi, 1, 1)
	}
	
	if(info) {
	 	T = R = U = V = J(rows(T), cols(T), .)
	 	w = beta = J(1, cols(T), .)
		return
	}

	if(needqr) {
		U = U0*U
		_flopin(U)
		_flopin(V)
	}	
	else {
		_flopout(T)
		_flopout(R)
	}

	if(iscomplex(T)) {
		(void)LA_ZGGBAK("P", "L", ., ilo, ihi, lscale, rscale,., U, 
				., info)
		(void)LA_ZGGBAK("P", "R", ., ilo, ihi, lscale, rscale,., V, 
				., info)
	}
	else {
		(void)LA_DGGBAK("P", "L", ., ilo, ihi, lscale, rscale,., U, 
				., info)
		(void)LA_DGGBAK("P", "R", ., ilo, ihi, lscale, rscale,., V, 
				., info) 	
	}

	_flopout(U)
	_flopout(V)
}

end
