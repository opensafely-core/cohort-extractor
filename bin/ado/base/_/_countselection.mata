*! version 1.0.0  24feb2009
version 11.0

mata:

real scalar _countselection(numeric rowvector w, select)
{
	real scalar n, m, i
	
	n = cols(w)
	if(n != cols(select)){
		_error(3200)
	}
	
	m = 0
	for(i=1; i<=n; i++) {
		if(Im(w[1, i]) != 0 ) {
			if(i == n) _error(3200)
			
			if(select[1, i]) {
				select[1, i+1] = 0
				m = m+2
			}
			else if(select[1, i+1]) {
				select[1, i+1] = 0
				select[1, i] = 1
				m = m+2
			}
			
			i++
		}
		else {
			if(select[1, i]) m++	
		}
	}
	return(m)
}

end
