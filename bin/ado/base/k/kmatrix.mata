*! version 1.0.1  10apr2009
version 11.0
mata:

real matrix Kmatrix(real scalar m, real scalar n)
{

	real matrix	K
	real scalar	len, mt, nt

	mt = trunc(m)
	nt = trunc(n)

	if (mt<0 | nt<0 | mt>=. | nt>=.) _error(3300)
	if (mt==0 | nt==0) return(J(0, 0, 0))
	if (mt==1 & nt==1) return(1)

	len = mt*nt
	K = J(len, len, 0) 

	_kmatrix_u(K, mt, nt)
	
	return(K)
}

/* deprecated name kmatrix() retained for compatibility
*/
real matrix kmatrix(real scalar m, real scalar n)
{

	return(Kmatrix(m, n))

}

end

