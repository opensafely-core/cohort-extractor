*! version 1.1.0  25jan2005
version 9.0

mata:

real scalar solve_tol(numeric matrix A, real scalar usertol)
{
	real scalar	tol, k
	real colvector	absdiag

	if ((tol=solve_tolscale(usertol))>0) {
		absdiag = abs(diagonal(A))
		k = nonmissing(absdiag)
		if (k) tol = tol*(colsum(absdiag)/k)
	}
	else if (tol<0) tol = -tol

	return(tol)
}

/* static */ real scalar solve_tolscale(real scalar tol)
{
	pointer(real scalar) scalar	p
	real scalar			_solvetolerance

	if (p = findexternal("_solvetolerance")) _solvetolerance = *p
	else 					 _solvetolerance = .

	if (_solvetolerance>=.) _solvetolerance = 1e-13

	return(tol>=. ? _solvetolerance : 
			(tol>0 ? _solvetolerance*tol : tol))
}

end
