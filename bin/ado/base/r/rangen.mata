*! version 1.0.0  15oct2004
version 9.0
mata:

numeric colvector rangen(numeric scalar a, numeric scalar b, numeric scalar n)
{
	real scalar		k, cx
	numeric colvector	res
	

	if ((k  = round(n))>=.) _error(3351)
	cx = (iscomplex(a)|iscomplex(b))

	if (k<=0) {
		if (k<0) _error(3300)
		return(J(0,1, cx ? 0i : 0))
	}
	if (k==1) return(a)

	k--
	res = (0::k):*((b-a)/k) :+ a
	res[1] = a
	res[n] = b
	return(res)
}

end
