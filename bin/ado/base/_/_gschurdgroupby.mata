*! version 1.0.0  24feb2009
version 11.0

mata:

void _gschurdgroupby(numeric matrix T, R, pointer scalar f, 
	      	numeric matrix U, V, w, beta, real scalar m)
{
	if((rows(T) != cols(T)) || (rows(R) != cols(R))) {
		_error(3200)
		return
	} 
		
	if((rows(T) != rows(R)) || (cols(T) != cols(R))) {
		_error(3200)
		return
	}

	if(isreal(T) != isreal(R)) {
		_error(3200)
		return
	}
	
	if(hasmissing(T) || hasmissing(R)) {
	 	T = R = U = V = J(rows(T), cols(T), .)
	 	w = beta = J(1, cols(T), .)
	 	m = 0
	 	return
	}
	 	
	if(rows(T) == 0) {
		if(isreal(T)) U = V = J(0, 0, 1)
		else U = V = J(0, 0, 1+0i)
		w = beta = J(1, 0, 0)
		return
	} 
			
	_gschurdgroupby_la(T, R, f, U=., V=., w=., beta=., m)
}

end
