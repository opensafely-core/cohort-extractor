*! version 1.0.1  06nov2017
version 9.0
mata:

numeric rowvector polysolve(numeric vector y, numeric vector x)
{
	numeric rowvector	res, c
	real scalar		j, i  
	real scalar		n 


	if (cols(y) != cols(x) | rows(y) != rows(x)) _error(3200)
	if ((n = length(x))==0) _error(3200)
	res = (iscomplex(y) | iscomplex(x) ? 0i : 0)
	for (j=1;j<=n;j++) { 
		c = (1)
		for (i=1;i<=n;i++) { 
			if (i!=j) { 
				c = polymult(c,(-x[i],1):/(x[j]-x[i]))
			}
		}
		res = polyadd(res,y[j]:*c)
	}
	while (res[cols(res)]==0) res = res[|1,1\1,cols(res)-1|]
	return(res)
}

end
