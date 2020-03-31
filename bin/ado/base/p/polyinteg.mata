*! version 1.0.0  11jan2005
version 9.0
mata:

numeric rowvector polyinteg(numeric rowvector c, real scalar i)
{
	numeric rowvector	cplus 

	if (i==0) return(c)
	if (i<0) return (polyderiv(c, -i))
	if (i>=.) _error(3300)				/* out of range	*/
	cplus = ( 0, ( c :/ (1..cols(c)) ) )
	return(i==1 ? cplus : polyinteg(cplus, i-1))
}

end
