*! version 1.1.2  06nov2017
version 9.0

mata:

real scalar _qrsolve(numeric matrix A, numeric matrix B, | real scalar tol)
{
	real colvector    p
	real scalar       rank, isa, isb
	numeric colvector tau 
	numeric matrix	  R

	pragma unset tau
	pragma unset R

						/* MRC_conformability 	*/
	if (rows(A)!=rows(B) | rows(A)<cols(A)) _error(3200) 	
	if (isview(B))_error(3104)		/* MRC_mm_view		*/

	isa = iscomplex(A)
	isb = iscomplex(B)

	if (rows(A)==0 | cols(A)==0) {
		if (rows(A)!=cols(A)) B = J(cols(A), cols(B), isa|isb?0i:0)
		else if (isa & !isb)  B = C(B)
		return(0)
	}

	if (isa | isb) {
		if (!isa) A = C(A)
		if (!isb) B = C(B)
	}

	if (rows(A)==cols(A)) {
		_hqrdp(A, tau, R, p=.)
		_hqrdmult(A, tau, B, 1)
		rank = _solveupper(R, B, tol)
	}
	else {
		_hqrdp(A, tau, R, p=.)
		B = hqrdmultq1t(A, tau, B)
		rank = _solveupper(R, B, tol)
	}
	B = B[invorder(p),.]
	A = J(0, 0, iscomplex(A) ? 0i : 0)
	return(rank)
}

end
