*! version 1.0.0  24feb2009
version 11.0

mata:

real scalar _gschurd_la(numeric matrix T, R, U, V, w, beta, 
		real scalar ilo, ihi, noflopin, noflopout)
{
        real scalar 	info, lwork
	numeric matrix 	wr, wi, work, rwork
	        
	info = 0
	
	if(!noflopin) {
		_flopin(T)
		_flopin(R)
		_flopin(U)
		_flopin(V)
	}
	
	if(iscomplex(T)) { 
		(void)LA_ZHGEQZ("S", "V", "V", ., ilo, ihi, T, ., R, ., w=., 
			beta=., U, ., V, ., work=., -1, rwork=., info)
	
		lwork = Re(work[1, 1])
	
		(void)LA_ZHGEQZ("S", "V", "V", ., ilo, ihi, T, ., R, ., w, 
			beta, U, ., V, ., work, lwork, rwork, info)
	
		_flopout(w)
		_flopout(beta)
	
		w 	= conj(w)'
		beta 	= conj(beta)'
	
	}
	else {
		(void)LA_DHGEQZ("S", "V", "V", ., ilo, ihi, T, ., R, ., wr=., 
			wi=., beta=., U, ., V, ., work=., -1, info)
		
		lwork = work[1, 1]
		
		(void)LA_DHGEQZ("S", "V", "V", ., ilo, ihi, T, ., R, ., wr, 
			wi, beta, U, ., V, ., work, lwork, info)
		
		w = C(wr, wi)
	}
	
	if(!noflopout) {
		_flopout(T)
		_flopout(R)
		_flopout(U)
		_flopout(V)
	}
	
	return(info)
}

end
