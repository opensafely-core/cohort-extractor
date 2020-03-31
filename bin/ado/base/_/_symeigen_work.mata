*! version 1.0.3  21sep2007
version 9.0

mata:

/* 
syntax 1 returns eigenvalues only
	_symeigen_work(numeric matrix A, lambda)

syntax 2 returns eigenvalues and eigenvectors
	_symeigen_work(numeric matrix A, V, lambda)

A is matrix to be decomposed, A is destroyed in process of making
calculation

*/ 

void  _symeigen_work(numeric matrix A, arg1, | arg2)
{
	real scalar    		i, rc, dima, todo
	real rowvector 		p
	pointer(numeric matrix) V
	pointer(real rowvector) lambda
	
	dima= cols(A)

/* if args() ==2 arg1 is lambda and arg2 is not used
   if args() !=2 arg1 is V and arg2 is lambda 
*/   

	/* ------------------------------------------------------------ */

	if (args()==2){
		todo=0
		rc = _symeigen_la(0, A, arg2, arg1)
		lambda = &arg1
	}	
	else {
		todo=1
		rc = _symeigen_la(1, A, arg1, arg2)
		V      = &arg1
		lambda = &arg2
	}	

	if (rc) {
		(*lambda) = J(1, dima, .)
		if (todo==1) {
			(*V) = .
			(*V) = J(dima,dima,.)
		}
		return 
	}
	if (dima==0) return
	/* ------------------------------------------------------------ */

	// _symeigen_la() returns eigenvalues sorted in ascending order

	if (todo==0) {
		(*lambda) = (*lambda)[dima..1]
		return 
	}

	for (i=2; i<=dima; i++) {
		if ((*lambda)[i-1]==(*lambda)[i]) {
			_transposeonly((*lambda))
			p = order((*lambda, Re(*V)), -(1..(1+dima)))
			_collate(*lambda, p)
			_transposeonly(*lambda)
			*V = (*V)[.,p]
			return
		}
	}

	(*lambda) = (*lambda)[p=dima::1]
	_transposeonly(*V)
	_collate(*V, p)
	_transposeonly(*V)
}

end
