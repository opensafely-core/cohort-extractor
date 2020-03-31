*! version 1.0.2  20jan2005
version 9.0

mata:

void _cholsolve(numeric matrix A, numeric matrix B, | real scalar tol )
{
	real scalar cA, rB, cmplxa, cmplxb

	cA = cols(A)
	rB = rows(B)
						
	if (rows(A)!=cA) _error(3205)		/* MRC_square		*/	
	if (cA!=rB)      _error(3200)		/* MRC_conformability   */	
	if (isview(A))   _error(3104)           /* MRC_mm_view          */
	if (isview(B))   _error(3104)           /* MRC_mm_view          */
	
	cmplxa = iscomplex(A)
        cmplxb = iscomplex(B)

        if (cA==0) {
		if (cmplxa & !cmplxb) B = C(B)
		return
	}	
	
	_cholesky(A)
	if ( _solvelower(A, B, tol)<cA) {
		_fillmissing(B)
		return
	}	
	if (_solveupper(A', B, tol)<cA) {
		_fillmissing(B)
		return
	}	

	A = J(0, 0, missingof(A))
}

end
