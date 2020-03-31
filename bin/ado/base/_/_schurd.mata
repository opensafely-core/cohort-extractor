*! version 1.0.0  24feb2009
version 11.0

mata:

void _schurd(numeric matrix T, Q)
{
        numeric matrix 	scale
	real scalar 	ilo, ihi, info

	if(rows(T) != cols(T)) {
		_error(3200)
		return
	}
	
	if(hasmissing(T)) {
		T = Q = J(rows(T), cols(T), .)
		return
	}
	
	info = 0
	
	_flopin(T)
	
	if(iscomplex(T)){
		(void)LA_ZGEBAL("P", ., T, ., ilo=0, ihi=0, scale=., info)
	}
	else {
		(void)LA_DGEBAL("P", ., T, ., ilo=0, ihi=0, scale=., info)
	}
	
	(void)_hessenbergd_la(T, Q=., ilo, ihi, 1, 1)
	
	_flopin(T)
	
	info = _schurd_la(T, Q, ., ilo, ihi, 1, 1)	
	
	if(info) {
		T = Q = J(rows(T), cols(T), .)
		return
	}
	
	if(iscomplex(T)){
		(void)LA_ZGEBAK("P", "L",  ., ilo, ihi, scale, ., Q, ., info)
	}
	else {
		(void)LA_DGEBAK("P", "L",  ., ilo, ihi, scale, ., Q, ., info)
	}
	
	_flopout(Q)
	_flopout(T)
}

end
