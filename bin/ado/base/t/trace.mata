*! version 1.1.2  06nov2017
version 9.0
mata:

numeric scalar function trace(numeric matrix A, 
				|numeric matrix B, real scalar t)
{
	real scalar	i, n
	numeric scalar	sum

	pragma unset n	// [sic]
	pragma unused n

	if (args()==1) {
		if ((n=rows(A))!=cols(A)) _error(3200)
		sum = 0 
		for (i=1; i<=rows(A); i++) sum = sum + A[i,i] 
		return(sum)
	}
	if (args()==2) return(trace_prod(A, B, 0))
	return(trace_prod(A, B, t))
}


	// NB: transpose for complex matrices is conjugate transpose

/* static */ numeric scalar trace_prod(numeric matrix A, numeric matrix B,
				 real scalar t)
{
	real scalar 	i, rA, cA
	numeric scalar 	val

	rA  = rows(A)
	cA  = cols(A)
	val = iscomplex(A) | iscomplex(B) ? 0i : 0

	if (!t) {				/* do not transpose */
		if ( (rows(B)!=cA) | (rA!=cols(B)) )  _error(3200) 
							/* MRC_conformability */

		if (rA==0 | cA==0) return(val)		/* void case	*/
		if (rA<cA) {
			for(i=1; i<=rA; i++ ) val = val + A[i,.]*B[.,i]
		}
		else {
			for(i=1; i<=cA; i++ ) {
				val = val + (A[.,i]')*(B[i,.]')
			}
			val = conj(val)
		}
	}
	else {
		if ( (rows(B)!=rA) | (cA!=cols(B)) )  _error(3200) 
						/* MRC_conformability */

		if (rA==0 | cA==0) return(val)		/* void case 	*/
		if(rA<cA) {
			for(i=1; i<=rA; i++ ) val = val + A[i,.]*(B[i,.]')
			val = conj(val)
		}
		else {
			for(i=1; i<=cA; i++ ) val = val + (A[.,i]')*B[.,i]	
		}
	}
	return(val)
}

end
