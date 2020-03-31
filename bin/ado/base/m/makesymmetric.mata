*! version 1.0.1  21dec2004
version 9.0
mata:

numeric matrix makesymmetric(numeric matrix X)
{
	numeric matrix	Z

	if (isfleeting(X)) {
		_makesymmetric(X)
		return(X)
	}
	_makesymmetric(Z = X)
	return(Z)
}

end
