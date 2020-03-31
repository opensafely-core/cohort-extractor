*! version 1.0.0  10nov2004
version 9.0

mata:

void _equilc(numeric matrix A, c)
{
	A = A:*(c=colscalefactors(A))
}

end
