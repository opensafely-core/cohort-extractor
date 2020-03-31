*! version 1.0.1  06nov2017
version 11.0

mata:

void eigensystemselectf(numeric matrix A, pointer scalar f, 
		numeric matrix X, L)
{
	numeric matrix ka
	
	pragma unset ka		// [sic]
	pragma unused ka
	
	if(rows(A) != cols(A)) {
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
		_eigenselectf_la(A, ., X, L, "R", f)
	}
	else  {
		_eigenselectf_la(ka=A, ., X, L, "R", f)
	}
}

end
