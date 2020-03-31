*! version 1.0.0  11jan2005
version 9.0

mata:

numeric matrix invlower(numeric matrix A, | rank, real scalar tol)
{
	numeric matrix Ainv

	if (isfleeting(A)) {
		rank = _invlower(A, tol)
		return(A)
	}
	else {
		rank = _invlower(Ainv=A, tol)
		return(Ainv)
	}	
}

end
