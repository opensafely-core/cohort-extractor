*! version 1.0.1  06nov2017
version 11.0

mata:

void _gschurdgroupby_la(numeric matrix T, R, pointer scalar f, 
	      	numeric matrix U, V, w, beta, real scalar m)
{
	real vector 	select, ar, ai, pl, pr, dif, iwork, info
	complex vector 	a
	numeric vector 	b, work 
	real scalar 	i, n, lwork, liwork

	pragma unset a 
	pragma unset pl		// [sic]
	pragma unused pl
	pragma unset pr		// [sic]
	pragma unused pr
	pragma unset dif	// [sic]
	pragma unused dif
	pragma unset info	// [sic]
	pragma unused info

	_gschurd(T, R, U, V, w, beta)

	if(hasmissing(T) || hasmissing(R)) {
		m = 0
		return
	}
	
	n 	= cols(T)
	select 	= J(1, n, 0)
	m 	= 0
	
	for(i = 1; i <= n; i++) {
		if((*f)(w[1, i], beta[1, i])) {
		       	m++
		       	select[1, i] = 1
		}
	} 	
	
	if(m == 0 || m == n) {
		return	
	}
	
	_flopin(T)
	_flopin(R)
	_flopin(U)
	_flopin(V)

	if(isreal(T)) {
		(void)LA_DTGSEN(0, 1, 1, select, n, T, n, R, n, 
				ar=., ai=., b=., U, n, V, n, m, 
				pl=., pr=., dif=., work=., -1, 
				iwork=., -1, info=0)
	}
	else {
		(void)LA_ZTGSEN(0, 1, 1, select, n, T, n, R, n, 
				a, b=., U, n, V, n, m, pl=., pr=., 
				dif=., work=., -1, iwork=., -1, info=0)
	}
	
	lwork 	= Re(work[1, 1])
	liwork 	= iwork[1, 1]

	if(isreal(T)) {
		(void)LA_DTGSEN(0, 1, 1, select, n, T, n, R, n, 
				ar=., ai=., b=., U, n, V, n, m, 
				pl=., pr=., dif=., work=., lwork, 
				iwork=., liwork, info=0)
		
		w 	= C(ar, ai)
		beta 	= b 
	}
	else {
		(void)LA_ZTGSEN(0, 1, 1, select, n, T, n, R, n, 
				a, b=., U, n, V, n, m, pl=., pr=., dif=., 
				work=., lwork, iwork=., liwork, info=0)
		
		_flopout(a)
		
		b 	= conj(_flopout(b))'
		w 	= a
		beta 	= b
	}
	
	_flopout(T)
	_flopout(R)
	_flopout(U)
	_flopout(V)

	if(isreal(T)) {
		for(i = 1; i <= n; i++) {
			if(ai[i] == 0) {
				if(Re(R[i, i]) < 0) {
					T[., i] = -T[., i]
					R[., i] = -R[., i]
					V[., i] = -V[., i]
				}
			}
			else {
				if(Re(R[i, i]) < 0) {
					T[., i] = -T[., i]
					R[., i] = -R[., i]
					V[., i] = -V[., i]
				}

				if(Re(R[i+1, i+1]) < 0) {
					T[., i+1] = -T[., i+1]
					R[., i+1] = -R[., i+1]
					V[., i+1] = -V[., i+1]
				}
				
				if((T[i+1, i] >= 0) && (T[i, i+1] <= 0)) {
					T[., i+1] = -T[., i+1]
					T[i+1, .] = -T[i+1, .]
					R[., i+1] = -R[., i+1]
					R[i+1, .] = -R[i+1, .]
					V[., i+1] = -V[., i+1]
					U[., i+1] = -U[., i+1]
				}
				
				i++ 				
			}
		}
	}
}

end
