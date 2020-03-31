*! version 1.0.0  24feb2009
version 11.0

mata:

void hessenbergd(numeric matrix A, H, Q)
{
	if(rows(A) != cols(A)) {
		_error(3200)
		return
	}

	if(hasmissing(A)) {
		H = Q = J(rows(A), cols(A), .)
		return
	}
	
	if(rows(A) == 0) {
		H = A	
		if(isreal(A)) Q = J(0, 0, 1)
		else Q = J(0, 0, 1+0i)
		return
	}

	_hessenbergd(H=A, Q)
}

end
