*! version 1.0.2  06nov2017
version 9.0

mata:

real scalar _perhapsequilr(numeric matrix A, r)
{
	real scalar	amax, small

	if (rows(A)) {
		r = rowscalefactors(A)
		amax = max(1:/r)
		small = epsilon(100)
		if (min(r)/max(r)<.1 | amax<small | amax>=1/small) {
			A = r:*A
			return(1)
		}
	}
	r = J(rows(A), 1, 1)
	return(0)
}

end
