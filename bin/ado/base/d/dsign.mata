*! version 1.0.0  15oct2004
version 9.0
mata:

/*
	FORTRAN DSIGN() function
*/

real scalar dsign(a,b) return(b>=0 ? abs(a) : -abs(a))

end
