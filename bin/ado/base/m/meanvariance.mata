*! version 1.0.2  06jun2006
version 9.0
mata:

real matrix meanvariance(real matrix X, |real colvector w)
{
	real rowvector	CP
	real rowvector	means
	real scalar	n 

	if (args()==1) w = 1

	CP = quadcross(w,0, X,1)
	n  = cols(CP)
	means = CP[|1\n-1|] :/ CP[n]
	if (missing(means)) return(means \ J(cols(X),cols(X),.))
	return(means \ crossdev(X,0,means, w, X,0,means) :/ (CP[n]-1))
}

end
