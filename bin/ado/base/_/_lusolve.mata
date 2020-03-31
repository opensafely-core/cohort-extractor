*! version 1.0.3  02dec2004
version 9.0

mata:

void _lusolve(numeric matrix A, numeric matrix B, | real scalar tol )
{
	if (iscomplex(A) | iscomplex(B)) {
		if (!iscomplex(B)) B = C(B)
		if (!iscomplex(A)) A = C(A)
	}

	(void) _lusolve_la(A, B, tol)
	A = J(0, 0, iscomplex(A) ? 0i : 0)
}

end
