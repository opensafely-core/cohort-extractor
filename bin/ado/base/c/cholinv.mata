*! version 1.0.0  11jan2005
version 9.0

mata:

numeric matrix cholinv(numeric matrix A,| real scalar tol)
{
	numeric matrix Ainv

	if(isfleeting(A)){
		_cholinv(A,tol)
		return(A)
	}
	else{
		_cholinv(Ainv=A,tol)
		return(Ainv)
	}
}

end
