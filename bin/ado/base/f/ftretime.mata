*! version 1.0.0  15nov2004
version 9.0
mata:

numeric vector ftretime(numeric vector r, numeric vector s)
{
	real scalar	retrow
	real scalar	ex
	real vector	zeros

	ex = ( length(r)-1 ) / 2

	if (rows(s)==1) {
		retrow = (cols(s)==1 ? (rows(r)==1) : 1)
	}
	else 	retrow = 0

	if (retrow) {
		zeros = J(1, ex, 0)
		return((zeros,s,zeros))
	}
	zeros = J(ex, 1, 0)
	return((zeros\s\zeros))
}

end
