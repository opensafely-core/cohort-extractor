*! version 1.0.0  24feb2009
version 11.0

mata:

void symeigensystemselecti(numeric matrix A, real vector index, 
		numeric matrix X, L)
{
	real matrix 	k_a
	real scalar 	lower, upper, abstol, info

	k_a = .
	
	if(rows(A) != cols(A)) {
		_error(3200)
		return
	}

	if(hasmissing(A)) {
		X = J(rows(A), cols(A), .)
		L = J(1, rows(A), .)
		return
	}
	
	index = floor(index)
	
	if((rows(index) == 2) && (cols(index) == 1)) {
		index = index'
	}
	
	if((rows(index) == 1) && (cols(index) == 2)) {
		if((index[1, 1] < 1) || (index[1, 1] > rows(A)) || 
		   (index[1, 2] < 1) || (index[1, 2] > rows(A)) || 
		   (index[1, 1] > index[1, 2])) {
		   
			_error(3300)
			return
		}
	}
	else {
		_error(3200)
		return
	}
	
	if(rows(A) == 0) {
		L = J(1, 0, 0)
		if(isreal(A)) X = J(0, 0, 0)
		else X = J(0, 0, 0i)
		return
	}


	lower  = index[1, 1]
	upper  = index[1, 2]	
	abstol = 0	
	
	(void)LA_DLAMCH("S", abstol)
	
	abstol = 2*abstol
	
	if(isfleeting(A)) { 
		info = _symeigenselect_la(A, X, L, ., 0, lower, upper, abstol)
	}
	else {
		k_a  = A
		info = _symeigenselect_la(k_a, X, L, ., 0, lower, upper, abstol)
	}
	
	if(info) {
		X = J(rows(A), cols(A), .)
		L = J(1, cols(A), .)
	}
}

end
