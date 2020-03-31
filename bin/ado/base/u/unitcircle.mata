*! version 1.0.0  15oct2004
version 9.0
mata:

complex colvector unitcircle(real scalar n) 
{
	real colvector	theta

	theta = rangen(0, 2*pi(), n)
	return(C(cos(theta), sin(theta)))
}

end
