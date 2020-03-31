*! version 1.0.0  22dec2016
version 15
mata:

real scalar isminabbrev(
	string scalar s, 
	string scalar tomatch,
	real scalar minlen)
{
	if(ustrlen(s) < minlen) {
		return(0)
	}
	
	if(ustrpos(tomatch, s) == 1) {
		return(1)
	}
	
	return(0)
}

end
