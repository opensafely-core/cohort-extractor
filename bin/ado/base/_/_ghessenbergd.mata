*! version 1.0.0  24feb2009
version 11.0

mata:

void _ghessenbergd(numeric matrix H, R, U, V)
{    
	numeric matrix 	R1, U1, lscale, rscale 
	real scalar 	needqr, n, ilo, ihi, info
	
	if((rows(H) != cols(H)) || (rows(R) != cols(R))) {
		_error(3200)
		return
	} 
		
	if((rows(H) != rows(R)) || (cols(H) != cols(R))) {
		_error(3200)
		return
	}
		
	if(isreal(H) != isreal(R)) {
		_error(3200)
		return
	}
		
	if(hasmissing(H) || hasmissing(R)) {
		H = R = U = V= J(rows(H), cols(R), .)
		return
	}

	R1 	= U1 = .
	needqr 	= 0
	n 	= cols(H)
		
	_flopin(H)
	_flopin(R)

	if(iscomplex(H)) {
		(void)LA_ZGGBAL("P", ., H, ., R, ., ilo=., ihi=., lscale=., 
			rscale=., ., info=.)
	}
	else {
		(void)LA_DGGBAL("P", ., H, ., R, ., ilo=., ihi=., lscale=., 
			rscale=., ., info=.) 	
	}

	_flopout(H)
	_flopout(R)

	if(sublowertriangle(R, 1) != J(n, n, (iscomplex(R) ? 0i : 0))) {	
		(void)qrd(R, U1, R1)	
		H 	= U1'*H
		R 	= R1
		needqr 	= 1
	}
	
	if(needqr) {
		(void)_ghessenbergd_la(H, R, U, V, ilo, ihi, 0, 0) 
		
		U = U1*U
		
		_flopin(U)
		_flopin(V)
	
	}
	else {
		(void)_ghessenbergd_la(H, R, U, V, ilo, ihi, 0, 1)
		
		_flopout(H)
		_flopout(R)
	}
	
	if(iscomplex(H)) {
		(void)LA_ZGGBAK("P", "L", ., ilo, ihi, lscale, rscale,., 
				U, ., info)
		(void)LA_ZGGBAK("P", "R", ., ilo, ihi, lscale, rscale,., 
				V, ., info)
	}
	else {
		(void)LA_DGGBAK("P", "L", ., ilo, ihi, lscale, rscale,., 
				U, ., info)
		(void)LA_DGGBAK("P", "R", ., ilo, ihi, lscale, rscale,., 
				V, ., info) 	
	}

	_flopout(U)
	_flopout(V)
}

end
