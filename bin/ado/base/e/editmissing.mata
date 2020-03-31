*! version 1.0.0  12nov2004
version 9.0

mata:

numeric matrix editmissing(numeric matrix a, numeric scalar v)
{
	numeric matrix	b

	if (isfleeting(a)) {
		_editmissing(a, v)
		return(a)
	}
	_editmissing(b=a, v)
	return(b)
}

end
