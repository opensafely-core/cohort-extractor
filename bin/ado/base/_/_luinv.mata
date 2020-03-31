*! version 1.0.1  18nov2004
version 9.0

mata:

void  _luinv(numeric matrix A, |real scalar tol)  
{
	(void) _luinv_la(A, ., tol)
}

end
