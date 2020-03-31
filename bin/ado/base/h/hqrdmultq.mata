*! version 1.0.1  06jan2005
version 9.0

mata:

numeric matrix hqrdmultq(numeric matrix H, numeric rowvector tau, 
			 numeric matrix X, real scalar trans)
{
	numeric matrix 	C

	_hqrdmult(H, tau, C=X, trans)
	return(C)
}

end
