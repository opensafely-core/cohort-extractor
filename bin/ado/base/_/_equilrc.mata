*! version 1.0.0  10nov2004
version 9.0

mata:

void _equilrc(numeric matrix A, r, c)
{
	_equilr(A, r)
	_equilc(A, c)
}

end
