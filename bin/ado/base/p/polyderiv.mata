*! version 1.0.0  11jan2005
version 9.0
mata:

numeric rowvector polyderiv(numeric rowvector c, real scalar i)
{
	numeric rowvector	cprime

	if (i==0) return(c)
	if (i<0) return(polyinteg(c, -i))
	if (i>=cols(c)) return(isreal(c) ? 0 : 0i)
	cprime = c[|1,2\1,cols(c)|] :* (1..cols(c)-1)
	return(i==1 ? cprime : polyderiv(cprime, i-1))
}

end
