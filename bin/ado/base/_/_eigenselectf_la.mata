*! version 1.0.0  24feb2009
version 11.0

mata:

void _eigenselectf_la(numeric matrix A, VL, VR, w, 
		string scalar side, pointer scalar f)
{
	numeric matrix Q, scale, select, select1
	real scalar n, i, ilo, ihi, m, info
	
	n = cols(A)
	info = 0
	
	_flopin(A)
	
	if(iscomplex(A)){
		(void)LA_ZGEBAL("B", ., A, ., ilo=0, ihi=0, scale=., info)
	}
	else {
		(void)LA_DGEBAL("B", ., A, ., ilo=0, ihi=0, scale=., info)
	}

	(void)_hessenbergd_la(A, Q=., ilo, ihi, 1, 1)

	_flopin(A)
	
	info = _schurd_la(A, Q, w=., ilo, ihi, 1, 1)	

	if(info) {
		VL = J(0, n, .)
		VR = J(n, 0, .)
		w  = J(1, 0, .)
		return
	}

	select = J(1, n, 0)
	
	for(i = 1; i <= n; i++) {
		if((*f)(w[1, i])) {
			select[1, i] = 1
		}
	}
	
	select1 = select

	info = _eigenselect_la(A, VL=., VR=., w, select, side, 1)
	if(info) {
		VL = J(0, n, .)
		VR = J(n, 0, .)
		w  = J(1, 0, .)
		return
	}

	m = sum(select)

	if(m == 0) {
		if(side != "R") VL = J(0, n, 0i)
		if(side != "L") VR = J(n, 0, 0i)
		w = J(1, 0, 0i)
		return
	}

	_flopout(Q)

	_flopout(A)

	if(side != "R") {
		VL = Q*VL
		_flopin(VL) 
	}
	
	if(side != "L") {
		VR = Q*VR
		_flopin(VR)
	}

	if(iscomplex(A)){
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

	_normalize_eigen(A, VL, VR, w, select, select1, side)
}

end
