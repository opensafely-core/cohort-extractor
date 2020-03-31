*! version 1.0.0  24feb2009
version 11.0

mata:

void _eigenselecti_la(numeric matrix H, VL, VR, w, 
		string scalar side, real vector index)
{
	numeric matrix Q, scale, select, select1, w1, p
	real scalar n, i, ilo, ihi, m, info, il, iu
	
	n 	= cols(H)
	info 	= 0
	il 	= index[1, 1]
	iu 	= index[1, 2]	
			
	_flopin(H)

	if(iscomplex(H)){
		(void)LA_ZGEBAL("B", ., H, ., ilo=0, ihi=0, scale=., info)
	}
	else {
		(void)LA_DGEBAL("B", ., H, ., ilo=0, ihi=0, scale=., info)
	}

	(void)_hessenbergd_la(H, Q=., ilo, ihi, 1, 1)

	_flopin(H)

	info = _schurd_la(H, Q, w=., ilo, ihi, 1, 1)	
	
	if(info) {
		VL = J(0, n, .)
		VR = J(n, 0, .)
		w  = J(1, 0, .)
		return
	}

	w1 	= conj((w \ cols(w)..1))'
	p  	= order(w1, (-1,-2)) 
	select 	= J(1, n, 0)		
	
	for(i = il; i <= iu; i++) {
		select[1, i] = 1
	}
	
	select  = select[1, invorder(p)]
	select1 = select
	info 	= _eigenselect_la(H, VL=., VR=., w, select, side, 1)
	
	if(info) return

	m = sum(select)
	
	if(m == 0) {
		if(side != "R") VL = J(0, n, 0i)
		if(side != "L") VR = J(n, 0, 0i)
		w = J(1, 0, 0i)
		return
	}

	_flopout(Q)
	_flopout(H)
	
	if(side != "R") {
		VL = Q*VL
		_flopin(VL) 
	}
	
	if(side != "L") {
		VR = Q*VR
		_flopin(VR)
	}
					
	if(iscomplex(H)){
		if(side != "R") {
			(void)LA_ZGEBAK("B", "L",  ., ilo, ihi, scale, ., 
				VL, ., info)
		}
		
		if(side != "L") {
			(void)LA_ZGEBAK("B", "R",  ., ilo, ihi, scale, ., 
				VR, ., info)
		}
	}
	else {
		if(side != "R") {
			(void)LA_DGEBAK("B", "L",  ., ilo, ihi, scale, ., 
				VL, ., info)
		}
		
		if(side != "L") {
			(void)LA_DGEBAK("B", "R",  ., ilo, ihi, scale, ., 
				VR, ., info)
		}
	}

	if(side != "R") _flopout(VL) 
	if(side != "L") _flopout(VR)

	_normalize_eigen(H, VL, VR, w, select, select1, side)
}

end
