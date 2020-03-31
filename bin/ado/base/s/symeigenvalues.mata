*! version 1.0.2  06nov2017
version 9.0

mata:

real rowvector symeigenvalues(numeric matrix A)
{
	numeric matrix  Acpy

	pragma unset Acpy		// [sic]
	pragma unused Acpy

	if (isfleeting(A)) return(_symeigenvalues(A))
	else  		   return(_symeigenvalues(Acpy=A))

}

end
