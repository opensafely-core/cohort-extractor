*! version 1.1.2  06nov2017
version 9.0

mata:

real colvector _svdsv(numeric matrix A) 
{
	real colvector  s

	pragma unset s

	(void) _svd_la(A, s)
	return(s)
}

end
