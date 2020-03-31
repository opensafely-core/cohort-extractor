*! version 1.0.1  18nov2004
version 9.0

mata:

numeric matrix luinv(numeric matrix A, |real scalar tol)
{
	numeric matrix 	result

	if (isfleeting(A)) {
		_luinv(A, tol)
		return(A)
	}
	_luinv(result = A, tol)
	return(result)
}

end
