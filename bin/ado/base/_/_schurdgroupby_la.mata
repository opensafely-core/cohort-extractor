*! version 1.0.0  24feb2009
version 11.0

mata:

real scalar _schurdgroupby_la(numeric matrix T, Q, w, select, 
		real scalar noflopin, noflopout, m, s, sep)
{
	real scalar 	lwork, liwork, info
	numeric matrix 	work, iwork, wr, wi

	info = 0
	
	if(!noflopin) {
		_flopin(T)
		_flopin(Q)
       	}
       	
	if(iscomplex(T)) {     	
       		(void)LA_ZTRSEN("N", "V", select, ., T, ., Q, ., 
			w=., m=., s=., sep=., work=., -1, info)
       	
       		lwork = Re(work[1, 1])
	
		(void)LA_ZTRSEN("N", "V", select, ., T, ., Q, ., 
			w, m, s, sep, work, lwork, info)
	
		_flopout(w)

       		w = conj(w)'
	}
	else {
		(void)LA_DTRSEN("N", "V", select, ., T, ., Q, ., wr=., wi=., 
			m=., s=., sep=., work=., -1, iwork=., -1, info)

		lwork = work[1, 1]

		liwork = iwork[1, 1]

		(void)LA_DTRSEN("N", "V", select, ., T, ., Q, ., wr, wi, 
			m, s, sep, work, lwork, iwork, liwork, info)

		w = C(wr, wi)
	}

	if(!noflopout) {
		_flopout(T)
		_flopout(Q)
	}

       	return(info)	
}

end
