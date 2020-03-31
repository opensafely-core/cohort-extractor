*! version 1.0.3  06nov2017
version 9.0
mata:

numeric vector deconvolve(numeric vector r, numeric vector s)
{
	numeric vector	R, S
	real scalar	n, ex
	
	n  = length(s)
	ex = (length(r)-1)/2 

	S = C(ftpad( ( (rows(s)==1 ? s : transposeonly(s)), J(1,ex+2,0)) ))
	R = C(ftpad( ftwrap(rows(r)==1 ? r : transposeonly(r), cols(S)) ))
	_fft(S)
	_fft(R)
	R = S :/ R
	S = .				/* free memory	*/
	_invfft(R)
	if (isreal(r) & isreal(s)) R = Re(R)
	return(R[|1+ex\n-ex|])
}

end
