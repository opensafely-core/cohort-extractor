*! version 1.0.0  24feb2009
version 11.0

mata:

real scalar _eigenselect_la(numeric matrix A, VL, VR, w, select, 
		string scalar side, real scalar noflopin)
{
	real scalar n, m, mm, ldvl, ldvr, info
	scalar  zero

	n 	= cols(A)
	info 	= 0
	
	if(iscomplex(A)) {
		zero 	= 0i
		mm 	= sum(select)
	}
	else {
		zero 	= 0
		mm 	= _countselection(w, select)
	}
		
	if(mm == 0) {
		m 	= 0
		VR 	= J(n, 0, zero)
		VL 	= J(n, 0, zero)
		w  	= J(1, 0, 0)
		return(0)
	}
		
	if(side == "R" ) {
		ldvl = 1
		ldvr = n	
	}
	else if (side == "L") {
		ldvl = n
		ldvr = 1
		
	}
	else if (side == "B") {
		ldvr = n
		ldvl = n
		
	}
	else {
		_error(3200)
		return(0)
	}
	
	VL = J(mm, ldvl, zero)
	VR = J(mm, ldvr, zero)
	
	if(!noflopin) _flopin(A)
	
	if(iscomplex(A)) {
		(void)LA_ZTREVC(side, "S", select, ., A, ., VL, ldvl, VR, 
			ldvr, mm, m=., ., ., info) 
	}
	else {
		(void)LA_DTREVC(side, "S", select, ., A, ., VL, ldvl, VR, 
			ldvr, mm, m=., ., info) 
	
	}
	
	_flopout(A)
	
	if(side != "R") _flopout(VL)
	if(side != "L") _flopout(VR)
	
	if(info) {
		m  	= 0
		VL 	= J(n, m, .)
		VR 	= J(n, m, .)
		w 	= J(1, m, .)
		return(info)
	}
	
	if(m>0) {
		if(side != "R") VL = VL[., 1..m]
		if(side != "L") VR = VR[., 1..m]
	}
	else {
		VL = J(n, m, zero)
		VR = J(n, m, zero)
	}
	return(0)
}

end
