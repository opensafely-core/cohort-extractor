*! version 1.0.2  10feb2016
version 14.0
mata:

real rowvector mean(real matrix X, |real colvector w)
{
	real rowvector	CP
	real scalar	n 

	if (cols(X)==0) return(J(1, 0, .))
	if (rows(X)==0) return(J(1, cols(X), .))

	if (args()==1) w = 1

	CP = quadcross(w,0, X,1)
	n  = cols(CP)
	return(CP[|1\n-1|] :/ CP[n])
}

end
