*! version 1.0.0  24feb2009
version 11.0

mata:

real scalar _schurd_la(numeric matrix T, Q, w, 
		real scalar ilo, ihi, noflopin, noflopout)
{
        real scalar 	lwork, info
        numeric matrix 	work, wr, wi

	info = 0
	
        if(!noflopin) {
       		_flopin(T)
       		_flopin(Q)
       	}
	
	if(iscomplex(T)) {
	       	(void)LA_ZHSEQR("S", "V", ., ilo, ihi, T, ., w=., Q, ., 
				work=., -1, info)
	       	
	       	lwork = Re(work[1,1])
	       	
	       	(void)LA_ZHSEQR("S", "V", ., ilo, ihi, T, ., w, Q, ., 
				work, lwork, info)
	       	
	       	_flopout(w)	
	       	
	       	w = conj(w)'
	}
	else {
		(void)LA_DHSEQR("S", "V", ., ilo, ihi, T, ., wr=., wi=., 
				Q, ., work=., -1, info)
       		
       		lwork = work[1,1]
       		
       		(void)LA_DHSEQR("S", "V", ., ilo, ihi, T, ., wr, wi, Q, ., 
				work, lwork, info)
       		
       		w = C(wr, wi)
       	}
       	
       	if(!noflopout) {
		_flopout(T)
		_flopout(Q)
	}
	
	return(info)
}

end
