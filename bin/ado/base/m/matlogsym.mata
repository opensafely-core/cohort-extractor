*! version 1.0.0  29dec2004
version 9.0

mata:

numeric matrix matlogsym(numeric matrix A)
{
	numeric matrix Acpy

	if (isfleeting(A)) {
		_matlogsym(A)
		return(A)
	}
	else {
		_matlogsym(Acpy=A)
		return(Acpy)
	}
}
end
