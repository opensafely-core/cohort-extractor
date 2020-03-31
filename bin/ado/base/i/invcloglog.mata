*! version 1.1.0  19feb2019
version 9.0
mata:

real matrix invcloglog(real matrix x)
{
	real matrix	res 
	real scalar	i, j

	res = -expm1(-exp(x))
	if (missing(res)) {
		for (i=1; i<=rows(x); i++) {
			for (j=1; j<=cols(x); j++) {
				if (x[i,j]<. & x[i,j]>500) res[i,j] = 1
			}
		}
	}
	return(res)
}

end
