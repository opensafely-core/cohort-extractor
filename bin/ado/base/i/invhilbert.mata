*! version 1.0.0  10sep2004
version 9.0

mata:

real matrix invHilbert(real scalar n)
{
	real matrix invH
	real scalar un, i, j

	un = trunc(n)
	invH = J(un, un, .)
	for (i=1; i<=un; i++) {
		for (j=1; j<=un; j++) {
			invH[i,j] = (-1)^(i+j) * (i+j-1) *
					comb(n+i-1, n-j) *
					comb(n+j-1, n-i) *
					comb(i+j-2, i-1)^2
		}
	}
	return(invH)
}

end
