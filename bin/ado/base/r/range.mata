*! version 1.0.0  15oct2004
version 9.0
mata:

numeric colvector range(numeric scalar a, 
			numeric scalar b, 
			numeric scalar delta)
{
	real scalar	n

	if (a>=. | b>=. | delta>=.) _error(3351)
	if (a==b) return(a)

	n = round(abs(b-a)/abs(delta)) + 1
	if (n>=.) _error(3300)
	if (n<2) n = 2
	return(rangen(a, b, n))
}

end
