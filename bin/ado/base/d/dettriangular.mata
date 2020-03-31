*! version 1.0.2  22feb2006
version 9.0

mata:

numeric scalar dettriangular(numeric matrix A)
{
	real scalar	i, n
	numeric vector	v
	numeric scalar	zum
	real scalar	sum, z, sgn

	
	if ((n=rows(A)) != cols(A)) _error(3205)
	if (n==0) return(iscomplex(A) ? C(1) : 1)

	v = diagonal(A)
	if (missing(v)) return(iscomplex(A) ? C(.) : .)
	if (anyof(v, 0)) return(iscomplex(A) ? 0i : 0)

	if (iscomplex(A)) {
		zum = 0i
		for (i=1; i<=n; i++) zum = zum + ln(v[i])
		return(exp(zum))
	}

	sum = 0 
	for(sgn=i=1; i<=n; i++) {
		if ((z=v[i])<0) {
			z = -z ; 
			sgn = -sgn ; 
		}
		sum = sum + ln(z)
	}
	return(sgn*exp(sum))
}

end
