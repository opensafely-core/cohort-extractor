*! version 1.0.0  11jan2005
version 9.0

mata:

numeric rowvector polytrim(numeric rowvector c)
{
	real scalar	i

	if (c[cols(c)]) return(c) 
	for (i=cols(c)-1; i>1; i--) {
		if (c[i]) break 
	}
	return(i<=1 ? c[1] : c[|1\i|])
}

end
