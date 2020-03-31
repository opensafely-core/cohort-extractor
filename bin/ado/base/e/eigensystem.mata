*! version 1.0.2  06nov2017
version 9.0

mata:

void eigensystem(numeric matrix A, V, lambda, |cond, real scalar nobalance)
{
	numeric matrix Acpy

	pragma unset Acpy		// [sic]
	pragma unused Acpy

	if (args()==3) cond = .

	if(isfleeting(A)) _eigensystem(A,      V, lambda, cond, nobalance)
	else 		  _eigensystem(Acpy=A, V, lambda, cond, nobalance)
}

end
