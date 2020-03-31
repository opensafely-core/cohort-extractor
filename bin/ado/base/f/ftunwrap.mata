*! version 1.0.0  15nov2004	
version 9.0
mata:

numeric vector ftunwrap(numeric vector H)
{
	numeric vector	res
	real scalar	n, k

	res = H
	if ((n=length(H))==0) return(res)
	k = (2*trunc(n/2)==n ? (n/2)+2 : (n+3)/2)
	res[|1\n-k+1|] = H[|k\n|]
	res[|n-k+2\n|] = H[|1\k-1|]
	return(res)
}

end
