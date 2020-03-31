*! version 1.0.0  15nov2004
version 9.0
mata:
		
complex vector fft(numeric vector h)
{
	complex vector	H

	H = C(h)
	_fft(H)
	return(H)
}

end
