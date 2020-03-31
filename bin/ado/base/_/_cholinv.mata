*! version 1.0.4  21jan2005
version 9.0

mata:

void  _cholinv(numeric matrix A, |real scalar tol)  
{
	real scalar dimA

	dimA = cols(A)
						
	if (rows(A)!=dimA) _error(3205)		/* MRC_square		*/	
	if (isview(A))     _error(3104)         /* MRC_mm_view          */
	
        if (dimA==0) return

	_cholesky(A)
	if (_invlower(A,tol)<dimA) {
		_fillmissing(A)
		return
	}	
	A = A'A
}

end
