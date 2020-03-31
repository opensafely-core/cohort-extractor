*! version 1.0.0  15nov2004
version 9.0
mata:

real vector ftfreqs(numeric vector h, real scalar delta)
{
	real scalar	n, m, k
	real vector	res

	if ((m=length(h))==0) return(J(rows(h), cols(h), .))
	n = (m==1 ? h : m) 
	if ((n/2)!=trunc(n/2)) _error(3200) 
	res = (cols(h)==1 ? 0::(n-1) : 0..(n-1))
	k = (n/2)
	res[|n-k+2\n|] = (cols(h)==1 ? -k+1 :: -1 : -k+1 .. -1)
	return(delta:*res)
}

end
