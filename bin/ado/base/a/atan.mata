*! version 1.0.0  15oct2004
version 9.0
mata:

numeric matrix atan(numeric matrix x)
{
	return(isreal(x) ? atanr(x) : (atanh(x:*1i):/1i))
}

end
