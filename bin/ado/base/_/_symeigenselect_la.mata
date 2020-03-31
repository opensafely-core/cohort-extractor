*! version 1.0.2  11jan2011
version 11.0

mata:

real scalar _symeigenselect_la(numeric matrix A, X, L, ifail, 
		real scalar range, lower, upper, abstol)
{
	real scalar 	n, m, i, lwork, info, lower1, upper1
	real rowvector 	work
	scalar 		zero

	info 	= 0
	n 	= rows(A)
	zero 	= (iscomplex(A) ? 0i : 0)
	m 	= 1
	
	if(range) {
		if(reldif(lower, upper)<1e-16 || lower>=upper) m = 0
	}
	else {
		lower1 = floor(lower)
		upper1 = floor(upper)
		lower = n-upper1+1
		upper = n-lower1+1
		if((lower > upper) || (lower <= 0) || 
		   (lower > n) || (upper <= 0) || (upper > n)) {
		 	m = 0
		 }
	}
	
	if(m == 0) {
		X = J(n, 0, zero)
		L = J(1, 0, 0)
		return(0)
	}

	_flopin(A)
	
	if(iscomplex(A)) {
		if(range) {
			(void)LA_ZHEEVX("V", "V", "L", ., A, ., lower, upper, 
				0, 0, abstol, m, L=., X=., n, work=., -1, ., 
				., ifail=., info)

			lwork = Re(work[1, 1])

			(void)LA_ZHEEVX("V", "V", "L", ., A, ., lower, upper, 
				0, 0,  abstol, m, L, X, n, work, lwork, ., 
				., ifail, info)
		}
		else {
			(void)LA_ZHEEVX("V", "I", "L", ., A, ., 0, 0, lower, 
				upper, abstol, m, L=., X=., n, work=., -1, ., 
				., ifail=., info)

			lwork = Re(work[1, 1])

			(void)LA_ZHEEVX("V", "I", "L", ., A, ., 0, 0, lower, 
				upper, abstol, m, L, X, n, work, lwork, ., 
				., ifail, info)
	
		}
	}
	else {
		if(range) {
			(void)LA_DSYEVX("V", "V", "L", ., A, ., lower, upper, 
				0, 0, abstol, m, L=., X=., n, work=., -1, ., 
				ifail=., info)

			lwork = work[1, 1]

			(void)LA_DSYEVX("V", "V", "L", ., A, ., lower, upper, 
				0, 0,  abstol, m, L, X, n, work, lwork, ., 
				ifail, info)
		}
		else {
			(void)LA_DSYEVX("V", "I", "L", ., A, ., 0, 0, lower, 
				upper, abstol, m, L=., X=., n, work=., -1, ., 
				ifail=., info)

			lwork = work[1, 1]

			(void)LA_DSYEVX("V", "I", "L", ., A, ., 0, 0, lower, 
				upper, abstol, m, L, X, n, work, lwork, ., 
				ifail, info)
	
		}
	}

	_flopout(A)
	_flopout(X)
	
	if(m == 0) {
		X = J(n, 0, zero)
		L = J(1, 0, 0)
	}
	else {
		L = L[1, 1..m]
		X = X[., 1..m]
		
		if(info > 0) {
			for(i = 1; i <= m; i++) {
				if(ifail[i]>0) {
					X[., ifail[i]] = J(n, 1, .)
				}
			}
		}
		
		work 	= m..1
		L 	= L[., work]
		X 	= X[., work]
	}
	return(info)
}

end
