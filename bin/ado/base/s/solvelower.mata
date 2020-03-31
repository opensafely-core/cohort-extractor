*! version 1.0.1  18jan2005
version 9.0

mata:

numeric matrix solvelower(numeric matrix A, numeric matrix b, 
				|rank, real scalar tol, numeric scalar d)
{
	numeric matrix 	x	

	if (isfleeting(b)) {
		rank = _solvelower(A, b, tol, d)
		return(b)
	}
	else {
		x = b
		rank = _solvelower(A, x, tol, d)
		return(x)
	}
}

end
