*! version 1.0.0  15nov2004
version 9.0
mata:

numeric vector invfft(numeric vector H)
{
	complex	vector	h 

	h = C(H)
	_invfft(h) 
	return(allof(Im(h),0) ? Re(h) : h)
}

end
