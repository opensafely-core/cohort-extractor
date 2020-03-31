*! version 1.0.0  10nov2004
version 9.0

mata:

void _equilr(numeric matrix A, r)
{
	A = (r=rowscalefactors(A)):*A
}

end
