*! version 2.0.0  29mar2011
version 12.0

mata:
mata set matastrict on

numeric matrix Toeplitz(numeric colvector fc, numeric rowvector fr)
{
	real scalar	r, c, i, j
	numeric matrix	T

	r = rows(fc)
	c = cols(fr)
	T = J(r, c, iscomplex(fc) | iscomplex(fr) ? 0i : 0)
	if (r==0 | c==0) return(T)

	T[1,.] = fr
	T[.,1] = fc

	for (i=2; i<=r; i++) {
		for (j=2; j<=c; j++) T[i,j] = T[i-1, j-1] 
	}
	return(T)
}

end
exit

