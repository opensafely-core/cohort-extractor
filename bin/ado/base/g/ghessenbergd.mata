*! version 1.0.0  24feb2009
version 11.0

mata:

void ghessenbergd(numeric matrix A, B, H, R, U, V)
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
		H = R = U = V = J(rows(A), cols(A), .)
		return
	}

	if(rows(A) == 0) {
		H = A
		R = B
		
		if(isreal(A)) {
			U = V = J(0, 0, 1)
		}
		else {
			U = V = J(0, 0, 1+0i)
		}
		return
	} 

	_ghessenbergd(H=A, R=B, U, V)
}

end
