*! version 1.0.0  30nov2004
version 9.0

mata:

numeric matrix transposeonly(numeric matrix A)
{
	numeric matrix	B

	if (isfleeting(A)) {
		_transposeonly(A)
		return(A)
	}
	_transposeonly(B=A)
	return(B)
}

end
