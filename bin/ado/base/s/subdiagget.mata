*! version 1.0.0  30aug2016
version 14
mata:

transmorphic colvector subdiagget(transmorphic matrix X, real vector L, U) {

	real scalar i, j, N, n_L, n_U, NN, ix
	real vector sel
	real matrix ixx
	transmorphic colvector res
	
	if ((N=rows(X)) != cols(X)) _error(3205) // not square
	
	L = abs(L)
	U = abs(U)
	
	// remove invalid indices
	sel = (L:==0) :| (L:>=N)
	L = select(L,!sel)
	if (length(L)==0) L=0
	
	sel = (U:==0) :| (U:>=N)
	U = select(U,!sel)
	if (length(U)==0) U=0
	
	n_L = length(L)
	n_U = length(U)
	
	if (n_L==1 & L==0) n_L = 0
	if (n_U==1 & U==0) n_U = 0
			
	NN = N*n_L + N*n_U - sum(L) - sum(U)
	
	res = J(NN,1,missingof(X))
	ix = 0
	
	// upper off-diagonals
	for (i=1; i<=n_U; i++) {
		ixx = (1::N-U[i]),(U[i]+1::N)
		for (j=1; j<=rows(ixx); j++) res[++ix] = X[ixx[j,1],ixx[j,2]]
	}
	
	// lower off-diagonals
	for (i=1; i<=n_L; i++) {
		ixx = (L[i]+1::N),(1::N-L[i])
		for (j=1; j<=rows(ixx); j++) res[++ix] = X[ixx[j,1],ixx[j,2]]
	}
	
	return(res)
}

end

