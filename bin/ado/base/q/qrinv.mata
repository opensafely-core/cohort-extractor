*! version 1.0.0  27nov2004
version 9.0

mata:

numeric matrix qrinv(numeric matrix A, | rank, real scalar tol)
{
	numeric matrix Ainv

	if(isfleeting(A)) {
		rank =_qrinv(A,tol)
		return(A)
	}

	rank =_qrinv(Ainv=A,tol)
	return(Ainv)

}

end
