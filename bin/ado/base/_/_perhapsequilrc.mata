*! version 1.0.0  10nov2004
version 9.0

mata:

real scalar _perhapsequilrc(numeric matrix A, r, c)
{
	real scalar	rc

	rc = _perhapsequilr(A, r)		// two-part construction to
	return(rc + 2*_perhapsequilc(A, c))	// ensure order of operations
}

end
