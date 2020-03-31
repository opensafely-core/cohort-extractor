*! version 1.0.0  31mar2009
version 11

mata:

real scalar _cns_eigen(	real matrix Rr,	// in/out: constraint matrix
			real matrix T,	// output
			real matrix a)	// output
{
	real	scalar	kr		// # rows of Rr (unique)
	real	scalar	kc		// # cols of Rr
	real	scalar	p		// # of parameters (kc - 1)
	real	scalar	k		// # of free parameters
	real	scalar	kp1		// k + 1

	real	scalar	n, i, j
	real	vector	o, d
	real	matrix	R
	real	matrix	z
	real	matrix	X
	real	matrix	L
	pragma unset X
	pragma unset L

	kc	= cols(Rr)
	p	= kc - 1
	n	= rows(Rr)
	d	= J(1,n,0)
	o	= order(Rr, (1..kc))
	// look for duplicate rows of 'Rr'
	for (i=2; i<=n; i++) {
		if (all(Rr[o[i],.] :== Rr[o[i-1],.])) {
			d[i] = o[i] > o[i-1] ? o[i] : o[i-1]
		}
	}
	kr	= n - sum(d:>0)
	if (kr >= p) {
		// there are at least as many constraints as parameters
		return(1)
	}
	if (kr < n) {
		// only use the unique rows of 'Rr'
		R = J(kr, p, .)
		a = J(kr, 1, .)
		j = 1
		for (i=1; i<=n; i++) {
			if (all(i :!= d)) {
				R[j,]	= Rr[|_2x2(i,1,i,p)|]
				a[j]	= Rr[i,kc]
				j++
			}
		}
	}
	else {
		R = Rr[|_2x2(1,1,kr,p)|]
		a = Rr[|_2x2(1,kc,kr,kc)|]
	}

	k	= p - kr
	kp1	= k + 1

	z	= I(p) - R'*invsym(R*R')*R
	_makesymmetric(z)
	_symeigensystem(z, X, L)
	if (L[kp1] > .5) {
		// redundant or inconsistent constraints
		return(2)
	}
	T	= X[|_2x2(1,1,p,k)|]
	L	= X[|_2x2(1,kp1,p,p)|]
	if (kr < n) {
		Rr = R, a
	}
	a	= a'*qrinv(R*L)'*L'
	return(0)
}

end
