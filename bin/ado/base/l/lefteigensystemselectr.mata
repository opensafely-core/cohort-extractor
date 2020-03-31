*! version 1.0.1  06nov2017
version 11.0

mata:

void lefteigensystemselectr(numeric matrix A, real vector range, 
		numeric matrix X, L)
{
	numeric matrix ka
	
	pragma unset ka		// [sic]
	pragma unused ka

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
		L = J(1, cols(A), .)
		return
	}
		
	if(rows(A) == 0) {
		L = J(1, 0, 0)
		if(isreal(A)) X = J(0, 0, 0)
		else X = J(0, 0, 0i)
		return
	}

	if(isfleeting(A)) {
		_eigenselectr_la(A, X, ., L, "L", range) 
	}
	else {
		_eigenselectr_la(ka=A, X, ., L, "L", range)
	}
}

end
