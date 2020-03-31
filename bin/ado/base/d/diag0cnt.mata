*! version 1.0.0  15oct2004
version 9.0
mata:

real scalar diag0cnt(real matrix X)
{
	real scalar     n
	real scalar     i
	real scalar     cnt
                                                                                
	if ((n=rows(X))!=cols(X)) _error(3205)
                                                                                
	cnt = 0
	for (i=1; i<=n; i++) {
		if (X[i,i]==0) cnt++
	}
	return(cnt)
}

end
