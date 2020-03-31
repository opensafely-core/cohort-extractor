*! version 1.0.0  10sep2004
version 9.0

mata:

numeric matrix Vandermonde(numeric colvector x)
{
	real scalar		n, i
	numeric matrix		V
	numeric colvector	vec

	n = rows(x)
	V = J(n, n, missingof(x))
	if (n==0) return(V)

	vec = J(n,1,iscomplex(x) ? C(1) : 1)
	for (i=1; i<=n; i++) {
		V[.,i] = vec
		vec = vec :* x
	}
	return(V)
}

end
