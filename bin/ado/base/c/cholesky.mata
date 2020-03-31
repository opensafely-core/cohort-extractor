*! version 1.0.2  20jan2005
version 9.0

mata:

numeric matrix cholesky(numeric matrix A) 
{
	numeric matrix G

	if (isfleeting(A)) {
		_cholesky(A) ;
		return(A)
	}
	_cholesky(G=A)
	return(G)
}

end
