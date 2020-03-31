*! version 1.0.2  06nov2017
version 9.0

mata:

real colvector svdsv(numeric matrix A) 
{
	numeric matrix	Acopy

	pragma unset Acopy		// [sic]
	pragma unused Acopy

	return(_svdsv(Acopy=A))
}

end
