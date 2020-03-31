*! version 1.0.0  15oct2004
version 9.0
mata:

void _corr(real matrix X)
{	
	real scalar	i, j

	if (rows(X)!=cols(X)) _error(3205)

	for (i=1; i<=rows(X); i++) {
		X[i,i] = sqrt(X[i,i])
		for (j=1; j<i; j++) {
			X[i,j] = X[j,i] = X[i,j]/(X[i,i]*X[j,j])
		}
	}
	for (i=1; i<=rows(X); i++) X[i,i] = 1
}

end
