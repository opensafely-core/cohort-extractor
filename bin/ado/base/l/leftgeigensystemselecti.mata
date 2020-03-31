*! version 1.0.1  06nov2017
version 11.0

mata:

void leftgeigensystemselecti(numeric matrix A, B, real vector index, 
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
		_geigenselecti_la(A, B, X, ., w, beta, index, "L")
	}
	else if(isfleeting(A)) { 
		_geigenselecti_la(A, kb=B, X, ., w, beta, index, "L")
	}
	else if(isfleeting(B)) { 
		_geigenselecti_la(ka=A, B, X, ., w, beta, index, "L")
	}
	else { 
		_geigenselecti_la(ka=A, kb=B, X, ., w, beta, index, "L")
	}
}

end
