*! version 1.0.3  06nov2017
version 9.0

mata:

void fullsvd(numeric matrix A, U, s, VT)
{
	numeric matrix	Acopy

	pragma unset Acopy		// [sic]
	pragma unused Acopy

	_fullsvd(Acopy=A, U, s, VT)
}

end
