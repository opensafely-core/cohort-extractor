*! version 2.0.0  08oct2008
version 11.0
mata:

numeric matrix asinh(numeric matrix x)
{
	return(isreal(x) ? asinhr(x) : ln(x+sqrt(x:*x:+1)))
}

end
