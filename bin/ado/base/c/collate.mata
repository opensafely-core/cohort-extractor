*! version 1.0.0  15oct2004
version 9.0
mata:

transmorphic matrix collate(transmorphic matrix x, real colvector ii)
{
	real scalar 	i
	real matrix 	res

	res = x[ii[1],] 
	for (i=2;i<=rows(ii);i++) res = res \ x[ii[i],]
	return(res)
}

end
