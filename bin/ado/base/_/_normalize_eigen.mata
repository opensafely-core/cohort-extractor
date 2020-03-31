*! version 1.0.0  24feb2009
version 11.0

mata:

void _normalize_eigen(numeric matrix H, VL, VR, w, select, select1, 
		string scalar side)
{
	real scalar 	idx, idx1, i, n
		
	idx 	= 1
	n 	= rows(H)

	if(iscomplex(H)) {
		for(i = 1; i <= n; i++) {			
			if(select1[1, i]) {
				w[1, idx] = w[1, i]
				idx++
			}
		}
		if(side != "R") VL = VL'
	}
	else {
		idx1 = 1
		if(side != "R") VL = C(VL, J(rows(VL), cols(VL), 0))
		if(side != "L") VR = C(VR, J(rows(VR), cols(VR), 0))

		for(i = 1; i <= n; i++) {
			if(Im(w[1, i]) != 0 ) {
				if(i == n) _error(3200)
				if(select1[1, i]) {
					w[1, idx] = w[1, i]
					
					if(side != "R") {
VL[., idx] = C(Re(VL[.,idx1]), Re(VL[., idx1+1]))
					}
					
					if(side != "L") {
VR[., idx] = C(Re(VR[.,idx1]), Re(VR[., idx1+1]))
					}
					
					idx++
				}
				if(select1[1, i+1]) {
					w[1, idx] = w[1, i+1]
					if(!select1[1, i]) {
						if(side != "R") {
VL[., idx] = C(Re(VL[.,idx1]), -Re(VL[., idx1+1]))
						}
						
						if(side != "L") {
VR[., idx] = C(Re(VR[.,idx1]), -Re(VR[., idx1+1]))
						}
					} 
					else {
						if(side != "R") { 
VL[., idx] = conj(VL[.,idx-1])
						}
						
						if(side != "L") { 
VR[., idx] = conj(VR[.,idx-1])
						}
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
					w[1, idx] = w[1, i]
				
					if(side != "R") {
VL[., idx] = VL[.,idx1]
					}
					
					if(side != "L") {
VR[., idx] = VR[.,idx1]
					}
					
					idx++
					idx1++
				}
			}	
		}

		if(idx > 1) {
			if(side != "R") VL = VL[., 1..idx-1]'
			if(side != "L") VR = VR[., 1..idx-1]
		}
		else {
			if(side != "R") VL = J(0, n, 0i)
			if(side != "L") VR = J(n, 0, 0i)		
		}
	}

	if(idx > 1) {
		w 	= (w[1, 1..idx-1] \ idx-1..1)
		select 	= order(conj(w)', (-1, -2))
		w 	= w[1, select]	
		if(side != "R")VL = VL[select, .]
		if(side != "L")VR = VR[., select]
	}
	else {
		w = J(1, 0, 0i)
	}
}

end
