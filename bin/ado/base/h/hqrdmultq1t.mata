*! version 1.0.1  06jan2005
version 9.0

mata:

numeric matrix hqrdmultq1t(numeric matrix H, numeric rowvector tau, 
			   numeric matrix X)
{
	numeric matrix 	C

	_hqrdmult(H, tau, C=X, 1)
	return(C[|1,1 \ cols(H), .|])
}

end
