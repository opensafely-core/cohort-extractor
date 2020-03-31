*! version 1.0.1  20jan2005
version 9.0
mata:

/*
	numeric vector ftpad(numeric vector v)

	pads v to be of length 2^k by adding 0's to the end.
	Returns either v itself or padded vector
*/

numeric vector ftpad(numeric vector v)
{
	real scalar	n, newn, p
	numeric scalar	el
	numeric vector	newv

	if ((n=length(v))==0) return(J(rows(v), cols(v), missingof(v)))
	p = round(ln(n)/ln(2))
	if ((newn=round(2^p)) == n) return(v) 
	if (newn<n) newn = 2*newn
	el = (iscomplex(v) ? 0i : 0) 
	newv = (rows(v)==1 ? J(1,newn,el) : J(newn,1,el))
	newv[|1\n|] = v
	return(newv)
}

end
