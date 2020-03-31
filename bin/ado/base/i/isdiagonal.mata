*! version 1.1.0  18mar2005
version 9.0
mata:

real scalar isdiagonal(numeric matrix A)
{
	real scalar	i, j, r, c 

	r = rows(A)
	c = cols(A)
	for (i=1; i<=r; i++) {
		for (j=1; j<=c; j++) {
			if (i!=j) {
				if (A[i,j]!=0) return(0)
			}
		}
	}
	return(1) 
}
end
