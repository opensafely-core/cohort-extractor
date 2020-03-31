*! version 1.0.1  11nov2004
version 9.0

mata:

real rowvector colscalefactors(numeric matrix A)
{
	real rowvector	res

	_editmissing(res = 1:/colmaxabs(A), 1)
	return(res)
}

end
