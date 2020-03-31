*! version 1.0.1  06nov2017
version 11.0

mata:

void _geigenselectf_la(numeric matrix H, R, VL, VR, w, beta, 
		pointer scalar f, string scalar side)
{
	numeric matrix 	select, select1, U, V
	numeric matrix 	U0, lscale, rscale
	real scalar 	needhess, needqr, info, ilo, ihi, i, n
	scalar zero
	
	n 	= cols(R)
	zero 	= (iscomplex(H) ? 0i: 0)
	U0 	= .
	needqr 	= 0
			
	_flopin(H)
	_flopin(R)

	if(iscomplex(H)) {
		(void)LA_ZGGBAL("B", ., H, ., R, ., ilo=., ihi=., lscale=., 
				rscale=., ., info=.)
	}
	else {
		(void)LA_DGGBAL("B", ., H, ., R, ., ilo=., ihi=., lscale=., 
				rscale=., ., info=.) 	
	}
	
	_flopout(R)
	_flopout(H)
	
	if(sublowertriangle(R, 1) != J(n, n, (iscomplex(R) ? 0i : 0))) {
		(void)qrd(R, U0, VL=.)	
		H 	= U0'*H
		R 	= VL
		needqr 	= 1
	}
		
	needhess = 0
	
	if(sublowertriangle(H, 2) != J(n, n, zero)) needhess = 1
		
	_flopin(H)
	_flopin(R)	
	if(needhess) {
		(void)_ghessenbergd_la(H, R, VL=., VR=., ilo, ihi, 1, 1)
	}
	else {
		VL = I(n) + J(n, n,zero)  
		VR = I(n) + J(n, n,zero)
		_flopin(VL)
		_flopin(VR)
	}
	
	info = _gschurd_la(H, R, VL, VR, w=., beta=., ilo, ihi, 1, 0)
	if(info) {
		VL = VR   = J(n, n, .)
		w  = beta = J(1, n, .)
		return
	}

	if(needqr) {
		VL = U0*VL
	}	

	select = J(1, n, 0)
	
	for(i = 1; i <= n; i++) {
		if((*f)(w[1, i], beta[1,i])) select[1, i] = 1
	}

	select1 = select
	
	info = _geigen_la(H, R, U=., V=., w, select, side, "S")	

	if(info) {
		VL = VR   = J(n, n, .)
		w  = beta = J(1, n, .)
		return
	}
	
	if(side != "R") VL = VL*U
	if(side != "L") VR = VR*V

	if(sum(select) == 0) {
		if(side != "R") VL = J(0, n, 0i)
		if(side != "L") VR = J(n, 0, 0i)
		w 	= J(1, 0, 0i)
		beta 	= J(1, 0, 0i)
		return
	}

	if(side != "R") _flopin(VL)
	if(side != "L") _flopin(VR)
	
	if(iscomplex(H)) {
		if(side != "R") { 
			(void)LA_ZGGBAK("B", "L", ., ilo, ihi, lscale, 
				rscale,., VL, ., info)
		}
		
		if(side != "L") { 
			(void)LA_ZGGBAK("B", "R", ., ilo, ihi, lscale, 
				rscale,., VR, ., info)
		}
	}
	else {
		if(side != "R") { 
			(void)LA_DGGBAK("B", "L", ., ilo, ihi, lscale, 
				rscale,., VL, ., info)
		}
		
		if(side != "L") { 
			(void)LA_DGGBAK("B", "R", ., ilo, ihi, lscale, 
				rscale,., VR, ., info)
		}
	}

	if(side != "R") _flopout(VL)
	if(side != "L") _flopout(VR)
	
	_normalize_geigen(H, R, VL, VR, w, beta, select, select1, side)
}

end
