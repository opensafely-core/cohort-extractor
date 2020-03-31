*! version 1.0.1  06nov2017
version 9.0

mata:

void symeigensystem(numeric matrix A, V, lambda)
{
	numeric matrix Acpy

	pragma unset Acpy		// [sic]
	pragma unused Acpy

	if(isfleeting(A)) _symeigensystem(A,      V, lambda)
	else              _symeigensystem(Acpy=A, V, lambda)
}

end
