*! version 1.0.2  04feb2008
version 9.0

mata:

real scalar _invlower(numeric matrix A, | real scalar usertol)
{
	real scalar i, dimA, cmplxA, one, tol, d, rank

	dimA=rows(A)
	if(dimA!=cols(A)) _error(3205) 			/* MRC_square   */
	if (isview(A))    _error(3104)         		/* MRC_mm_view  */

	if (dimA==0) return(0)

	tol = solve_tol(A, usertol)

	cmplxA = iscomplex(A)
	
	one   = (cmplxA ? C(1): 1)
	
	rank = 0
	for(i=1; i<=dimA; i++) {
		if (abs(d=A[i,i])>tol) {
			++rank
			A[i,i] = one/d
			if (i>1) {
				A[|i,1 \ i,i-1|] = 
				   (-1/d)*(A[|i,1 \ i,i-1|]*A[|1,1 \ i-1,i-1|])
			}
		}
		else 	{
			if(i>1) {
				A[|i,1 \ i,i-1|] = J(1, i-1, (cmplxA ? 0i: 0))
			}
		}
	}
	return(rank)
}

end
