*! version 1.0.2  06nov2017
version 9.0

mata:

/* singular values s always real, but complex uses might be found for this
 * function so it works with complex
 * m > 0 for case when m > n
 * m < 0 for case when m < n
 * m = 0 for case when m == n
 */
numeric matrix fullsdiag(numeric colvector v, real scalar m)
{
	real scalar 	n
	numeric scalar	zero
	
	if(trunc(m) != m) _error(3) /* make out of range or not integer value*/

	n=rows(v)

	zero = iscomplex(v) ? 0i : 0

	if(m>0) return(diag(v) \ J(m,n,zero))		/* m >  0 */
	else if(m<0) return((diag(v),J(n,-m,zero)))	/* m <  0 */
	else return(diag(v))				/* m == 0 */

}

end
