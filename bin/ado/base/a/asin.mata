*! version 2.0.0  08oct2008
version 11.0
mata:

numeric matrix asin(numeric matrix x)
{
	if (isreal(x)) return(asinr(x))

	/*
		Re(asin()) in [-pi/2, pi/2]
		Note Im(asinh()) in [-pi/2, pi/2]
	*/

	return(asinh(x:*1i):/1i)
}

end
