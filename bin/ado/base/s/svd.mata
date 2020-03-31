*! version 1.0.1  18jan2005
version 9.0

mata:

void svd(numeric matrix A, U, s, VT)
{
	numeric matrix	Acopy

	if (isfleeting(A)) {
		_svd(A, s, VT)
		U = A
	}
	else {
		_svd(Acopy=A, s, VT)
		U = Acopy
	}	
}

end
