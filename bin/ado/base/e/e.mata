*! version 1.0.1  14dec2004
version 9.0
mata:

/*
	unit (row) vector = e(i,n)

	return 1 x n unit vector with 1 in position i
*/

real rowvector e(real scalar i, real scalar n)
{
	real rowvector	res 

	res = J(1,n,0)
	res[i] = 1 
	return(res)
}

end
