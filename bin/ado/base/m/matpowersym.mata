*! version 1.0.0  06jan2005
version 9.0

mata:

numeric matrix matpowersym(numeric matrix A, real scalar p)
{
	numeric matrix Acpy 

	if (isfleeting(A)){
		_matpowersym(A, p)
		return(A)
	}
	else {
		_matpowersym(Acpy=A, p)
		return(Acpy)
	}
}

end
