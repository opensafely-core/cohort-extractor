*! version 1.0.0  24feb2009
version 11.0

mata:

real scalar _geigen_la(numeric matrix H, R, VL, VR, w, select, 
		string scalar side, howmany)
{	
	real scalar n, ldvl, ldvr, m, mm, info
	scalar zero
	
	n 	= cols(H)
	zero 	= (iscomplex(H) ? 0i : 0)
	info 	= 0
	ldvr 	= 1
	ldvl 	= 1
	
	if(howmany == "B") {
		if(side == "L") {
			mm 	= cols(VL)
			ldvl 	= rows(VL)	
		}
		if(side == "R") {
			mm 	= cols(VR)
			ldvr 	= rows(VR)	
		}
		if(side == "B") {
			mm 	= cols(VR)
			ldvr 	= rows(VR)
			ldvl 	= rows(VL)
		}
	}
	else if(howmany=="A"){
		if(side != "R") {
			mm 	= n
			ldvl 	= n	
		}
		
		if(side != "L") {
			mm 	= n
			ldvr 	= n
		}
		
		VL = J(ldvl, mm, zero)
		VR = J(ldvr, mm, zero)
	}
	else {
		mm = 0
		
		if(iscomplex(H)) {
			mm = sum(select)
		}
		else {
			mm = _countselection(w, select)
		}
	
		if(mm == 0) {
			VL = J(n, 0, zero)
			VR = J(n, 0, zero)
			return(0)
		}
		
		if(side != "R") ldvl = n
		if(side != "L") ldvr = n
			
		VL = J(ldvl, mm, zero)
		VR = J(ldvr, mm, zero)
		
	}
	
	m = 0
	
	_flopin(H)
	_flopin(R)
	_flopin(VL)
	_flopin(VR)
	
	if(iscomplex(H)) {
		(void)LA_ZTGEVC(side, howmany, select, ., H, ., R, 
			., VL, ldvl, VR, ldvr, mm, m, ., ., info)
	}
	else {
		(void)LA_DTGEVC(side, howmany, select, ., H, ., R, ., VL, ldvl, 
			VR, ldvr, mm, m, ., info)
	}
	
	_flopout(H)
	_flopout(R)
	_flopout(VL)
	_flopout(VR)	
	
	return(info)
}

end
