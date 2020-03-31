*! version 1.0.2  20jan2005
version 9.0
mata:

numeric vector convolve(numeric vector r, numeric vector s)
{
	numeric vector	R, S
	real scalar	n, ex, m

	n  = length(s)
	ex = (length(r)-1)/2 

	S = C(ftpad( ( (rows(s)==1 ? s : transposeonly(s)), J(1,2*ex,0)) ))
	R = C(ftpad( ftwrap(rows(r)==1 ? r : transposeonly(r), cols(S)) ))
	_fft(S)
	_fft(R)
	R = R :* S
	S = .				/* free memory	*/
	_invfft(R)
	if (isreal(r) & isreal(s)) R = Re(R)
	if (rows(s)==1) { 
		m = cols(R)
		return(R[|m-ex+1\m|], R[|1\n+ex|])
	}
	m = cols(R)
	return(transposeonly(R[|m-ex+1\m|]) \ transposeonly(R[|1\n+ex|]))
}

end
