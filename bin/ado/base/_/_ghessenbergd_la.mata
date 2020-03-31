*! version 1.0.0  24feb2009
version 11.0

mata:

void _ghessenbergd_la(numeric matrix H, R, U, V, 
		real scalar ilo, ihi, noflopin, noflopout)
{
	real scalar 	n, info
	scalar 		zero

	info 	= 0	
	zero 	= (iscomplex(H) ? 0i : 0)  
	n 	= cols(H)
	U 	= J(n, n, zero)
	V 	= J(n, n, zero)

	if(!noflopin) {
		_flopin(H)
		_flopin(R)
	}
	
	if(iscomplex(H)) {
		(void)LA_ZGGHRD("I", "I", ., ilo, ihi, H, ., R, ., 
				U, ., V, ., info)
	}        
	else {
		(void)LA_DGGHRD("I", "I", ., ilo, ihi, H, ., R, ., 
				U, ., V, ., info)
	}
	
	if(!noflopout) {
		_flopout(H)
		_flopout(R)
		_flopout(U)
		_flopout(V)
	}
}

end
