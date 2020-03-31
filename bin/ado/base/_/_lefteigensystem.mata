*! version 1.0.1  04jan2005
version 9.0

mata:

void _lefteigensystem(numeric matrix A, V, lambda, |cond, real scalar nobalance)
{
	if (args()==3) cond = .

	_eigen_work(2, A, V, lambda, cond, nobalance)
	
}

end
