*! version 1.0.0  15oct2004
version 9.0
mata:

real matrix corr(real matrix X)
{
	real matrix	X2

	X2 = X
	_corr(X2)
	return(X2)
}
end
