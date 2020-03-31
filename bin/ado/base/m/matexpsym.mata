*! version 1.0.0  29dec2004
version 9.0

mata:

numeric matrix matexpsym(numeric matrix A) 
{
	numeric matrix Acpy

	if (isfleeting(A)) {
		_matexpsym(A)
		return(A)
	}
	else {
		_matexpsym(Acpy=A)
		return(Acpy)
	}
}
end
