*! version 1.2.0  02dec2004
version 9.0

mata:

numeric matrix pinv(numeric matrix A, |rank, real scalar tol)
{
	numeric matrix	Ainv

	rank = _pinv(Ainv=A, tol)
	return(Ainv)
}

end
