*! version 1.0.0  24feb2009
version 11.0

mata:

void schurdgroupby(numeric matrix A, pointer scalar f, 
		numeric matrix T, Q, w, numeric scalar m)
{
	if(rows(A) != cols(A)) {
		_error(3200)
		return
	}
	
	if(hasmissing(A)) {
		T = Q = J(rows(A), cols(A), .)
		w = J(1, cols(A), .)
		m = 0
		return
	}
	
	if(rows(A) == 0) {
		T = A
		w = J(1, 0, 0i)
		if(isreal(A)) Q = J(0, 0, 1)
		else Q = J(0, 0, 1+0i)
		return
	}

	_schurdgroupby(T=A, f, Q, w, m)
}

end
