*! version 1.0.1  06nov2017
version 9.0

mata:

real rowvector _symeigenvalues(numeric matrix A)
{
	real rowvector lambda

	pragma unset lambda

	_symeigen_work(A, lambda)

	return(lambda)
}

end
