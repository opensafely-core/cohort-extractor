*! version 1.0.2  06nov2017
version 9.0

mata:

complex vector eigenvalues(numeric matrix A, |cond, real scalar nobalance)
{
	numeric matrix  Acpy

	pragma unset Acpy		// [sic]
	pragma unused Acpy

	if (args()==1) cond = .

	if (isfleeting(A)) return(_eigenvalues(A,      cond, nobalance))
	else  		   return(_eigenvalues(Acpy=A, cond, nobalance)) 

}

end
