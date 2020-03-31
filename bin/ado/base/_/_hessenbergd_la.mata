*! version 1.0.0  24feb2009
version 11.0

mata:

void _hessenbergd_la(numeric matrix H, Q, 
		real scalar ilo, ihi, noflopin, noflopout)
{
        real scalar 	n, iscomplex, lwork, info
        numeric matrix 	tau, work
        scalar 		zero
            
	info 		= 0 
        n 		= rows(H)
        iscomplex 	= iscomplex(H)
        zero 		= (iscomplex ? 0i: 0)
        Q 		= I(n) + J(n, n, zero)
        
	if(n <= 1) return

        if(!noflopin) _flopin(H)
        
	if(iscomplex) {
        	(void)LA_ZGEHRD(., ilo, ihi, H, ., tau=., work=., -1, info)		
		
		lwork = Re(work[1, 1]) 
		
		(void)LA_ZGEHRD(., ilo, ihi, H, ., tau, work, lwork, info)			

        }
        else { 
        	(void)LA_DGEHRD(., ilo, ihi, H, ., tau=., work=., -1, info)			

		lwork = work[1, 1] 			

		(void)LA_DGEHRD(., ilo, ihi, H, ., tau, work, lwork, info)		
	}
	
	_flopout(H)

	Q = sublowertriangle(H, 2)
	H = H - Q
	
	_flopin(Q)		
	
	if(iscomplex) {
		(void)LA_ZUNGHR(., ilo, ihi, Q, ., tau, work, -1, info)		
	
		_flopout(work)
		lwork = Re(work[1, 1]) 
		
		(void)LA_ZUNGHR(., ilo, ihi, Q, ., tau, work, lwork, info)	
	}
	else {
		(void)LA_DORGHR(., ilo, ihi, Q, ., tau, work, -1, info)		
		
		lwork = work[1, 1] 
		
		(void)LA_DORGHR(., ilo, ihi, Q, ., tau, work, lwork, info)	
	}

	if(!noflopout) _flopout(Q)	
}

end
