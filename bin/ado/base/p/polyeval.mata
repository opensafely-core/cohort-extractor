*! version 1.0.1  20jan2005
version 9.0
mata:

numeric vector polyeval(numeric vector c, numeric vector x)
{
	real scalar	i
	real scalar	degree
	numeric matrix	res 

	degree=rowmax((rows(c),cols(c)))
	res = (rows(x)==1 ? J(1,cols(x),c[degree]) : J(rows(x),1,c[degree]))
	for (i=degree-1;i>=1;i--) res = res :* x :+ c[i]
	return(res)
}

end
