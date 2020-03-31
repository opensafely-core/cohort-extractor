*! version 1.0.0  06mar2008
version 10.0
mata:

real matrix Lmatrix( real scalar m)
{
	real matrix	L
	real scalar	mt

	mt = trunc(m)

	if (mt<0 | mt>=.) _error(3300)
		
	if(mt==0)  return(J(0,0,0))
	if(mt==1)  return(1)
	
	L = J(.5*mt*(mt+1), mt^2, 0)

	_lmatrix_u(L, mt)

	return(L)
}

end

