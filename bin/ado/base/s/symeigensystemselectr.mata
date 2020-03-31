*! version 1.0.0  24feb2009
version 11.0

mata:

void symeigensystemselectr(numeric matrix A, real vector range, 
		numeric matrix X, L)
{
	real matrix 	k_a
	real scalar 	lower, upper, abstol, info

	k_a = .
	
	if(rows(A) != cols(A)) {
		_error(3200)
		return
	}
	
	if((rows(range) == 2) && (cols(range) == 1)) {
		range = range'
	}
	
	if((rows(range) == 1) && (cols(range) == 2)) {
		if(range[1, 1] >= range[1, 2]) {
			_error(3300)
			return
		}
	}
	else {
		_error(3200)
		return
	}
	
	if(hasmissing(A)) {
		X = J(rows(A), cols(A), .)
		L = J(1, rows(A), .)
		return
	}
	
	if(rows(A) == 0) {
		L = J(1, 0, 0)
		if(isreal(A)) X = J(0, 0, 0)
		else X = J(0, 0, 0i)
		return
	}


	lower  = range[1, 1]
	upper  = range[1, 2]
	abstol = 0	
	
	(void)LA_DLAMCH("S", abstol)
	
	abstol = 2*abstol
	
	if(isfleeting(A)) { 
		info = _symeigenselect_la(A, X, L, ., 1, lower, upper, abstol)
	}
	else {
		k_a = A
		info = _symeigenselect_la(k_a, X, L, ., 1, lower, upper, abstol)
	}
	
	if(info) {
		X = J(rows(A), cols(A), .)
		L = J(1, rows(A), .)
		return	
	}
}

end
