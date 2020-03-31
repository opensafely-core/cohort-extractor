*! version 1.0.0  15oct2004
version 9.0
mata:

numeric matrix gamma(numeric matrix Z)
{
	if (isreal(Z))  return(Re(exp(lngamma(C(Z)))))
	return(exp(lngamma(Z)))
}
		
end
