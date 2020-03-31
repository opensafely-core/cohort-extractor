*! version 1.0.1  11nov2004
version 9.0

mata:

real colvector rowscalefactors(numeric matrix A)
{
	real colvector	res

	_editmissing(res = 1:/rowmaxabs(A), 1)
	return(res)
}

end
