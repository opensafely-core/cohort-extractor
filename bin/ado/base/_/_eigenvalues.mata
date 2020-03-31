*! version 1.0.2  06nov2017
version 9.0

mata:

complex vector _eigenvalues(numeric matrix A, |cond, real scalar nobalance)
{
	complex vector evals

	pragma unset evals

	if (args()==1) cond = .

	_eigen_work(0, A, .,  evals, cond, nobalance)
	
	return(evals)
}

end
