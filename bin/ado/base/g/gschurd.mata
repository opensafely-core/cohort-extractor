*! version 1.0.0  24feb2009
version 11.0

mata:

void gschurd(numeric matrix A, B, T, R, U, V, w, beta)
{
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
 		T = R = U = V = J(rows(A), cols(A), .)
 		w = beta = J(1, cols(A), .)
 		return
 	}
 	
	if(rows(A)==0) {
		T = A
		R = B
		
		if(isreal(A)) {
			U = V = J(0, 0, 1)
		}
		else {
			U = V = J(0, 0, 1+0i)
		}
		
		w = beta = J(0, 0, 1)
		return
	} 
		
	_gschurd(T=A, R=B, U=., V=., w=., beta=.)
}

end
