*! version 1.0.1  06jun2006
version 9.0
mata:

real matrix correlation(real matrix X, |real colvector w)
{
	real rowvector	CP
	real rowvector	means
	real matrix	res
	real scalar	i, j
	real scalar	n 

	if (args()==1) w = 1

	CP = quadcross(w,0, X,1)
	n  = cols(CP)
	means = CP[|1\n-1|] :/ CP[n]
	res = crossdev(X,0,means, w, X,0,means)

	for (i=1; i<=rows(res); i++) {
		res[i,i] = sqrt(res[i,i])
		for (j=1; j<i; j++) {
			res[i,j] = res[j,i] = res[i,j]/(res[i,i]*res[j,j])
		}
	}
	for (i=1; i<=rows(res); i++) res[i,i] = 1
	return(res)
}

end
