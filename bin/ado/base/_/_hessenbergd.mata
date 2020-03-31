*! version 1.0.0  24feb2009
version 11.0

mata:

void _hessenbergd(numeric matrix H, Q)
{
	real scalar 	ilo, ihi, info
	numeric matrix 	scale

	if(rows(H) != cols(H)) {
		_error(3200)
		return
	}
	
	if(hasmissing(H)) {
		H = Q = J(rows(H), cols(H), .)
		return
	}
	
	ilo 	= 0
	ihi 	= 0
	info	= 0

	_flopin(H)

	if(iscomplex(H)){
		(void)LA_ZGEBAL("P", ., H, ., ilo, ihi, scale=., info)
	}
	else {
		(void)LA_DGEBAL("P", ., H, ., ilo, ihi, scale=., info)
	}
	
	(void)_hessenbergd_la(H, Q, ilo, ihi, 1, 1)
	
	if(iscomplex(H)){
		(void)LA_ZGEBAK("P", "L",  ., ilo, ihi, scale, ., Q, ., info)
	}
	else {
		(void)LA_DGEBAK("P", "L",  ., ilo, ihi, scale, ., Q, ., info)
	}

	_flopout(Q)
}

end
