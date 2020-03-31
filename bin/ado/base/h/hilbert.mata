*! version 1.0.0  10sep2004
version 9.0

mata:

real matrix Hilbert(real scalar n) 
{
	real matrix H
	real scalar un, i, j

	un = trunc(n)
	H = J(un, un, .)
	for (i=1; i<=un; i++) {
		for (j=1; j<=un; j++) H[i,j] = 1/(i+j-1)
	}
	return(H)
}

end
