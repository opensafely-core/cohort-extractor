*! version 1.0.4  25jan2005
version 9.0

mata:

real scalar _solveupper(
		numeric matrix A, numeric matrix b, | real scalar usertol,
		numeric scalar userd)
{
	real scalar		tol, rank, a_t, b_t, d_t
	real scalar		n, m, i, ip1, complex_case
	numeric rowvector	sum
	numeric scalar		zero, d

	d = userd

	if ((n=rows(A))!=cols(A)) _error(3205) 	/* MRC_square 		*/
	if (n != rows(b)) 	  _error(3200)	/* MRC_conformability 	*/
	if (isview(b))		  _error(3104)  /* MRC_mm_view		*/
	m = cols(b)
	rank = n

	a_t = iscomplex(A)
	b_t = iscomplex(b)
	d_t = d<. ? iscomplex(d) : 0

	complex_case = a_t | b_t | d_t

	if (complex_case) {
		if (!a_t) A = C(A)
		if (!b_t) b = C(b)
		if (d<. & !d_t) d = C(d)
		zero = 0i
	}
	else zero = 0 

	if (n==0 | m==0) return(0)

	tol = solve_tol(A, usertol)

	if (abs(d) >=. ) {
		if (abs(d=A[n,n])<=tol) {
			b[n,.] = J(1, m, zero)
			--rank
		}
		else {
			b[n,.] = b[n,.] :/ d
			if (missing(d)) rank = .
		}

		for (i=n-1; i>=1; i--) {
			ip1 = i + 1
			sum = A[|i,ip1\i,n|] * b[|ip1,1\n,m|]
			if (abs(d=A[i,i])<=tol) {
				b[i,.] = J(1, m, zero)
				--rank
			}
			else {
				b[i,.] = (b[i,.]-sum) :/ d
				if (missing(d)) rank = .
			}
		}
	}
	else {
		if (abs(d)<=tol) {
			rank = 0
			b = J(rows(b), cols(b), zero)
		}
		else {
			b[n,.] = b[n,.] :/ d

			for (i=n-1; i>=1; i--) {
				ip1 = i + 1 
				sum = A[|i,ip1\i,n|] * b[|ip1,1\n,m|]
				b[i,.] = (b[i,.]-sum) :/ d
			}
		}

	}

	return(rank)
}

end
