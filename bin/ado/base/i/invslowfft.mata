*! version 1.0.1  20jan2005
version 9.0
mata:
/*

	h = invslowft(H)
		slow inverse Fourier transform.
		H: n x 1 contains Fourier transform for frequencies 
		f = 0, .., n-1.
		Returns h, h real or complex.


    {cmd:invslowft(}{it:H}{cmd:)} performs the inverse Fourier transform,but
    slowly.  Like {cmd:slowft()}, {cmd:invslowft()} does not require the
    length of the vector be a power of 2, but it will be slower than
    {cmd:invfft()}, even when you must pad.  Use of {cmd:invslowft()} is NOT
    recommended.  It is included for testing purposes.

    invslowft() edits the result to make values close to zero exactly zero.
    After (inverse) transforming the results, the editing is equivalent 
    to edittozero(h,100).
    invslowft(H) will cast the result down to real if possible.
*/


numeric vector invslowft(numeric vector H)
{
	real scalar		i, n 
	real scalar		k 
	complex scalar		w, wi, wk
	complex vector		h

	n = length(H)
	w = exp(-2*pi()*1i/n)
	h = J(rows(H),cols(H),0i)
	wi = 1 
	for (i=1;i<=n;i++) { 
		wk = 1
		for (k=1;k<=n;k++) { 
			h[i] = h[i] + wk*H[k]
			wk = wk * wi 
		}
		wi = wi * w
	}
	h = edittozero(h:/n, 100)
	return(allof(Im(h),0) ? Re(h) : h) 
}

end
