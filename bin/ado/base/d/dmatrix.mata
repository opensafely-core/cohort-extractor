*! version 1.0.0  06mar2008
version 10.0
mata:

real matrix Dmatrix(real scalar m) 
{
	real matrix 	D
	real scalar	mt

	mt = trunc(m)

	if (mt<0 | mt>=.) _error(3300)
	if(mt==0)  return(J(0,0,0))
	if(mt==1)  return(1)
	
	D = J(mt*mt, .5*mt*(mt+1), 0)

	_dmatrix_u(D, mt)

	return(D)
}

end

