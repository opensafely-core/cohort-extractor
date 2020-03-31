*! version 1.0.2  06nov2017
version 9.0

mata:


/*
	lusolve(A, B) solves AX = B, returns X
*/


numeric matrix lusolve(numeric matrix A, numeric matrix B, |real scalar tol)
{
	numeric matrix 	Acopy, X
	numeric scalar 	Afleet, Bfleet

	pragma unset Acopy		// [sic]
	pragma unused Acopy

	Afleet = isfleeting(A)
	Bfleet = isfleeting(B)

	
	if ( Afleet & Bfleet ) {
		_lusolve(A, B, tol)
		return(B)
	}

	if ( Afleet & (!Bfleet) ) {
		_lusolve(A, X=B, tol)
		return(X)
	}

	if ( (!Afleet) & Bfleet ) {
		_lusolve(Acopy=A, B, tol)
		return(B)
	}
	_lusolve(Acopy=A, X=B, tol)
	return(X)
}

end
