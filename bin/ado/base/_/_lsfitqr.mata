*! version 1.0.1  21feb2012

version 12.0

mata:
mata set matastrict on

real matrix _lsfitqr(real matrix X, real matrix Y, real colvector wt,
		real scalar cons, real scalar rank, real matrix E, 
		real matrix r, real matrix R, real rowvector p, 
		|real scalar tol) 
{
	real scalar k, n, m, ic, N, nx
	real rowvector tau
	real matrix b

	if (missing(tol)) tol = 2^10

	n = rows(Y)
	ic = (cons!=0)
	k = cols(X) + ic
	m = cols(Y)
	if (n==0) return(J(0,m,.))

	nx = rows(X)
	if (!nx) {
		if (cols(X)|!cons) exit(_error(3200))
	}
	else if (nx!=n) exit(_error(3200))

	p = J(1,k,0)

	if (ic) {
		if (nx) X = (J(n,1,1),X)
		else X = J(n,1,1)

		p[1] = 1
	}
	if (length(wt) == n) {
		N = sum(wt,1)
		wt[.] = sqrt(wt)
		X[.,.] = wt:*X
		Y[.,.] = wt:*Y
	}
	else N = n

	R = J(k,k,0)
	tau = J(1,k,0)

	_hqrdp(X, tau, R, p)
	Y[.,.] = hqrdmultq(X,tau,Y,1)
	b = Y[|1,1\k,m|]

	rank = _solveupper(R,b,tol)
	if (!rank) b = J(0,m,0)

	if (ic<rank) r = Y[|ic+1,1\rank,m|]
	else r = J(m,m,0)

	/* residuals							*/
	if (rank < n) {
		E = Y[|rank+1,1\n,m|]
		E = cross(E,E):/(N-rank)
	}
	else E = J(m,m,0)

	if (rank) {
		/* regression mean squares				*/
		r = cross(r,r)
		if (rank>ic) r[.,.] = r:/(rank-ic)

		/* regression coefficients				*/
		b[.,.] = b[invorder(p)',.]
		/* predicted values					*/
		if (rank<k) Y[.,.] = hqrdq1(X,tau)[|1,1\n,rank|]*Y[|1,1\rank,m|]
		else Y[.,.] = hqrdq1(X,tau)*Y[|1,1\k,m|]

		if (length(wt)==n) Y[.,.] = Y:/wt
	}
	else Y[.,.] = J(n,m,0)

	return(b)
}

end
exit

