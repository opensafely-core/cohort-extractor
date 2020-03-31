*! version 1.0.1  06nov2017
version 11.0

mata:

void _normalize_geigen(numeric matrix H, R, VL, VR, w, beta, 
			select, select1, string scalar side)
{
	real scalar idx, idx1, i, n
	numeric matrix w1, beta1, U, V, p

	pragma unused R
	pragma unused select

	idx 	= 1
	n 	= rows(H) 
	w1 	= J(1, n, 0i)	

	if(iscomplex(H)) {
		beta1 = J(1, n, 0i)	

		for(i = 1; i <= n; i++) {	
			if(select1[1, i]) {
				w1[1, idx]    = w[1, i]
				beta1[1, idx] = beta[1, i]
				idx++
			}
		}
		VL = VL'
	}
	else {
		idx1 	= 1
		beta1	= J(1, n, 0)	
		U 	= J(n, n, 0i)
		V 	= J(n, n, 0i)
		
		for(i = 1; i <= n; i++) {
			if(Im(w[1, i]) != 0 ) {
				if(i == n) _error(3200)
				
				if(select1[1, i]) {
					w1[1, idx]    = w[1, i]
					beta1[1, idx] = beta[1, i]
				
					if(side != "R") {
U[., idx] = C(VL[., idx1], VL[., idx1+1])
					}
					
					if(side != "L") {
V[., idx] = C(VR[., idx1], VR[., idx1+1])
					}
					
					idx++
				}
		
				if(select1[1, i+1]) {
					w1[1, idx]    = w[1, i+1]
					beta1[1, idx] = beta[1, i+1]
					
					if(side != "R") {
U[., idx] = C(VL[., idx1], -VL[., idx1+1])
					}
					
					if(side != "L") {
V[., idx] = C(VR[., idx1], -VR[., idx1+1])
					}
					
					idx++
				}
					
				if(select1[1, i] || select1[1, i+1]) {
					idx1 = idx1+2
				}
				
				i++
			}
			else {
				if(select1[1, i]) {
					w1[1, idx]    = w[1, i]
					beta1[1, idx] = beta[1, i]
				
					if(side != "R") U[., idx] = VL[., idx1]
					if(side != "L") V[., idx] = VR[., idx1]
					
					idx++
					idx1++
				}
			}	
		}
			
		if(idx > 1) {
			if(side != "R") VL = U[., 1..idx-1]'
			if(side != "L") VR = V[., 1..idx-1]
		}
		else {
			if(side != "R") VL = J(0, n, 0i)
			if(side != "L") VR = J(n, 0, 0i)					
		}
	}
	
	if(idx > 1) {
		w     = w1[1, 1..idx-1]
		beta  = beta1[1, 1..idx-1]
		w1    = (abs(w) \ idx-1..1)
		beta1 = abs(beta)
		
		for(i = 1; i <= cols(w); i++) {
			if(beta1[1, i] == 0) w1[1, i] = -1
			else w1[1, i] = w1[1, i]/beta1[1, i]
		}
	
		p    = order(w1', (-1,-2))
		w    = w[., p]
		beta = beta[.,p]
		
		if(side != "R") VL = VL[p, .]
		if(side != "L") VR = VR[., p]
	}
	else {
		w = J(1, 0, 0i)
		
		if(iscomplex(H)) beta = J(1, 0, 0i)
		else beta = J(1, 0, 0)
	}
}

end
