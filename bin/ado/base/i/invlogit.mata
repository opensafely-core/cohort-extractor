*! version 1.0.0  15oct2004
version 9.0
mata:

real matrix invlogit(real matrix x)
{
	real matrix	res
	real scalar	i, j

	res = exp(x)
	res = res :/ (1 :+ res)
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
