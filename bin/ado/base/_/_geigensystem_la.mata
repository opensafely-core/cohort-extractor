*! version 1.0.1  18mar2009
version 11.0

mata:

void _geigensystem_la(numeric matrix H, R, XL, XR, w, beta, 
		string scalar side)
{
	numeric matrix 	select, U0, lscale, rscale, w1, beta1, p
	real scalar 	needhess, needqr, info, ilo, ihi, i, n
	scalar zero

	zero 	= (iscomplex(H) ? 0i: 0)
	needqr 	= 0
	n 	= cols(R)

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

	XL = .

	if(sublowertriangle(R, 1) != J(n, n, (iscomplex(R) ? 0i : 0))) {
		(void)qrd(R, U0=., XL)	
		H 	= U0'*H
		R 	= XL
		needqr 	= 1
	}

	needhess = 0
	if(sublowertriangle(H, 2) != J(n, n, zero)) needhess = 1

	_flopin(H)
	_flopin(R)	

	if(needhess) {
		(void)_ghessenbergd_la(H, R, XL=., XR=., ilo, ihi, 1, 1)
	}
	else {
		XL = I(n) + J(n, n,zero)  
		XR = I(n) + J(n, n,zero)
		_flopin(XL)
		_flopin(XR)
	}

	info = _gschurd_la(H, R, XL, XR, w=., beta=., ilo, ihi, 1, 0)

	if(info) {
		XL = XR   = J(n, n, .)
		w  = beta = J(1, n, .)
		return
	}

	if(needqr) {
		XL = U0*XL
	}	
		
	select 	= J(1, n, 1)
	info 	= _geigen_la(H, R, XL, XR, w, select, side, "B")	
	
	if(info) {
		XL = XR   = J(n, n, .)
		w  = beta = J(1, n, .)
		return
	}

	if(side != "R") _flopin(XL)
	if(side != "L") _flopin(XR)
	
	if(iscomplex(H)) {
		if(side != "R") {
			(void)LA_ZGGBAK("B", "L", ., ilo, ihi, lscale, 
				rscale,., XL, ., info)
		}
		
		if(side != "L") { 
			(void)LA_ZGGBAK("B", "R", ., ilo, ihi, lscale, 
				rscale,., XR, ., info)
		}
	}
	else {
		if(side != "R") {
			(void)LA_DGGBAK("B", "L", ., ilo, ihi, lscale, 
				rscale,., XL, ., info)
		}
		
		if(side != "L") { 
			(void)LA_DGGBAK("B", "R", ., ilo, ihi, lscale, 
				rscale,., XR, ., info)
		}
	}
	
	if(side != "R") _flopout(XL)
	if(side != "L") _flopout(XR)


	if(iscomplex(H)) {
		if(side != "R") XL = XL'
		return
	}

	if(side != "R") XL = XL + J(n, n, 0i)
	if(side != "L") XR = XR + J(n, n, 0i)

	for(i = 1; i <= n; i++) {
		if(Im(w[1, i]) != 0) {		
			if(i == n) _error(3200)
			if(side != "R") {
				XL[.,   i] = C(Re(XL[., i]), Re(XL[., i+1]))
				XL[., i+1] = conj(XL[., i])
			}
			if(side != "L") {
				XR[.,   i] = C(Re(XR[., i]), Re(XR[., i+1]))
				XR[., i+1] = conj(XR[., i])
			}
			i++
		}
		else {
			if(side != "R") XL[., i] = XL[.,i]
			if(side != "L") XR[., i] = XR[.,i]
		}
	}
	
	w1 	= (abs(w) \ cols(w)..1)
	beta1 	= abs(beta)
	
	for(i = 1; i <= cols(w); i++) {
		if(beta1[1, i] == 0) w1[1, i] = -1
		else w1[1, i] = w1[1, i]/beta1[1, i]
	}
	
	p 	= order(w1', (-1,-2))
	w 	= w[., p]
	beta 	= beta[., p]
	
	if(side != "R") XL = XL[., p]'
	if(side != "L") XR = XR[., p]
}

end
