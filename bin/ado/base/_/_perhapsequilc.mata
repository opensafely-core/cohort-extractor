*! version 1.0.1  06nov2017
version 9.0

mata:

real scalar _perhapsequilc(numeric matrix A, c)
{
	real scalar	amax, small

	if (cols(A)) {
		c = colscalefactors(A)
		amax = max(c)
		small = epsilon(100)
		if (min(c)/max(c)<.1 | amax<small | amax>=1/small) {
			A = A:*c
			return(1)
		}
	}
	c = J(1, cols(A), 1)
	return(0) 
}

end
