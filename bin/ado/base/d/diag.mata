*! version 1.1.0  21mar2005
version 9.0
mata:
		/*
			matrix = diag(vector)
			matrix = diag(matrix)

			make a diagonal matrix or 
			extract principal diagonal from matrix
		*/

numeric matrix diag(numeric matrix v)
{
	real scalar	i, n, r, c
	numeric scalar	zero
	numeric matrix	res

	zero = isreal(v) ? 0 : 0i
	r    = rows(v)
	c    = cols(v)
	if (r==1) {
		res = J(c, c, zero)
		for (i=1; i<=c; i++) res[i,i] = v[i]
	}
	else if (c==1) {
		res = J(r, r, zero)
		for (i=1; i<=r; i++) res[i,i] = v[i]
	}
	else {
		n   = (r<c ? r : c)
		res = J(n, n, zero)
		for (i=1; i<=n; i++) res[i,i] = v[i,i]
	}
	return(res)
}
end
