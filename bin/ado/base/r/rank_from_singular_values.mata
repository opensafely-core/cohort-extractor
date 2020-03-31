*! version 1.0.0  20jan2005
version 9.0

mata:

/*
	real scalar rank_from_singular_values(s, tol)

	s is the vector of singular values
	tol is standard tolerance (positive, negative)

	returns rank; s and tol unchanged.

	rank may be ., 0, or >0.
*/

real scalar rank_from_singular_values(real colvector s, real scalar tol)
{
	real scalar	n, rank,  reltol

	if ((n=rows(s))==0) return(0) 
	if (s[1]>=.) return(.) 

	reltol = (tol>=.    ? 1       : tol)
	reltol = (reltol<=0 ? -reltol : n*s[1]*epsilon(1)*reltol)

	if (s[1] <= reltol) return(0) ; 

	for (rank=n; rank>=1; rank--) {
		if (s[rank] > reltol) break 
	}
	return(rank)
}

end
