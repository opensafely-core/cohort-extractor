*! version 1.0.1  20jan2005
version 9.0

mata:

/*
	convoleslowly(r,s)
		convolution the old-fashioned way.
		used for testing.

    {cmd:convolveslowly(}{it:r}{cmd:,} {it:s}{cmd:)} returns the same result
    as {cmd:convolve(}{it:r}{cmd:,} {it:s}{cmd:)}, but obtains the result by
    direct calculation and is slow.  Use of {cmd:convolveslowly()} is NOT
    recommended.  It is included for testing purposes.
*/

numeric vector convolveslowly(numeric vector r, numeric vector users) 
{
	real scalar	i, ii, j 
	real scalar	n, m, ctr, ex
	real scalar	el 
	real vector	res
	numeric vector	s 

	s = ftretime(r,users)
	el = (iscomplex(r) | iscomplex(s) ? 0i : 0)
	res = J(rows(s),cols(s),el)

	n = length(s)
	m = length(r)
	ctr = (m-1)/2 + 1
	ex  = ctr - 1 

	for (i=1;i<=n;i++) { 
		res[i] = res[i] + s[i]*r[ctr]
		ii = i - ex
		for (j=1;j<ctr;j++) { 
			if (ii>0) res[ii] = res[ii] + r[j]*s[i]
			ii++
		}
		ii = i + 1 
		for (j=ctr+1;j<=m;j++) { 
			if (ii<=n) res[ii] = res[ii] + r[j]*s[i]
			ii++
		}
	}
	return(res)
}

end
