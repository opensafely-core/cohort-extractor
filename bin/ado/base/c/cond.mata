*! version 1.0.2  19nov2004
version 9.0

mata:

real scalar cond(numeric matrix A, |real scalar p) 
{
	numeric matrix	Ainv
	real colvector	s

	if (rows(A)==0 | cols(A)==0) return(1)
	if (missing(A)) return(.)
	if (args()==1) p = 2

	if (p==2) {
		s = (isfleeting(A) ? _svdsv(A) : svdsv(A))
		if (s[1]>=.) return(.)
		return(s[1]/s[rows(s)])
	}

	if (p==1 | p==0 | p>=.) {
		_luinv(Ainv=A)
		if (Ainv[1,1]>=.) return(.)
		return(norm(A,p)*norm(Ainv, p))
	}

	_error(3300)		/* MRC_range */
	/*NOTREACHED*/
}

end
