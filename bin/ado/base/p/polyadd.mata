*! version 1.0.0  11jan2005
version 9.0
mata:

numeric rowvector polyadd(numeric rowvector c1, numeric rowvector c2)
{
	real scalar 	n1, n2

	n1 = cols(c1)
	n2 = cols(c2)
	if (!(n1&n2)) _error(3200)
	if (n1<n2) n1 = n2 
	return(polyadd_expand(c1,n1) + polyadd_expand(c2,n1) )
}

/*static*/ numeric rowvector polyadd_expand(numeric rowvector c, real scalar n)
{
	real rowvector	res
	real scalar	n0
	
	if ((n0=cols(c))==n) return(c)
	res = J(1, n, iscomplex(c) ? 0i : 0)
	if (n0) res[|1\n0|] = c
	return(res)
}

end
