*! version 1.0.1  06jan2005
version 9.0

mata:

numeric matrix hqrdq1(numeric matrix H, numeric rowvector tau) 
{
	numeric matrix Q1

	_hqrdq1(Q1=H, tau)
	return(Q1)
}

end
