*! version 1.0.1  06nov2017
version 11.0

mata:

void leftgeigensystemselectf(numeric matrix A, B, pointer scalar f,
			     numeric matrix X, w, beta)
{
	numeric matrix ka, kb
	
	pragma unset ka		// [sic]
	pragma unused ka
	pragma unset kb		// [sic]
	pragma unused kb

	if(rows(A) != cols(A) || rows(B) != cols(B)) {
		_error(3200)
		return
	} 

	if(rows(A) != rows(B) || cols(A) != cols(B)) {
		_error(3200)
		return
	}

	if(isreal(A) != isreal(B)) {
		_error(3200)
		return
	}

	if(hasmissing(A) || hasmissing(B)) {
		X = J(rows(A), cols(A), .)
		w = beta = J(1, cols(A), .)
		return
	}

	if(rows(A) == 0) {
		X = J(0, 0, 0)
		w = beta = J(1, 0, 0)
		return
	} 

	if(isfleeting(A) && isfleeting(B)) { 
		_geigenselectf_la(A, B, X, ., w, beta, f, "L")
	}
	else if(isfleeting(A)) { 
		_geigenselectf_la(A, kb=B, X, ., w, beta, f, "L")
	}
	else if(isfleeting(B)) {
		_geigenselectf_la(ka=A, B, X, ., w, beta, f, "L")
	}
	else {
		_geigenselectf_la(ka=A, kb=B, X, ., w, beta, f, "L")
	}
}

end
