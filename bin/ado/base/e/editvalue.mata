*! version 1.0.0  12nov2004
version 9.0

mata:

transmorphic matrix editvalue(transmorphic matrix A, scalar from, scalar to)
{
	transmorphic matrix	B

	if (isfleeting(A)) {
		_editvalue(A, from, to)
		return(A)
	}
	_editvalue(B=A, from, to)
	return(B)
}

end
