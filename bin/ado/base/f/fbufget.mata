*! version 1.1.1  04aug2005
version 9.0
mata:

matrix fbufget(real matrix H, real scalar fh, string scalar bfmt, 
		|real scalar userr, real scalar userc)
{
	real scalar	len
	real scalar 	r, c
	real scalar	isnum
	string scalar	B

	if (args()==3) {
		r = c = 1 
	}
	else if (args()==4) {
		r = 1
		c = userr 
	}
	else {
		r = userr 
		c = userc 
	}
	
	len  = bufbfmtlen(bfmt)*r*c
	isnum= bufbfmtisnum(bfmt)
	B    = len*char(0)
	if((B = fread(fh,  len)) != J(0, 0, "")) {
		return(bufget(H, B, 0, bfmt, r, c))
	}
	else 	return(J(r, c, isnum ? . : ""))
}

end
