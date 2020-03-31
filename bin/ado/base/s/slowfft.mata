*! version 1.0.1  20jan2005
version 9.0

mata:

/*
	H = slowft(h)
		slow Fourier transform.  
		h: n x 1 contains values of h at t = 0, .. n-1.  
		Returns H(f), H complex.


   {cmd:slowft(}{it:h}{cmd:)} performs the Fourier transform, but slowly.  The
   length of {it:h} is not required to be a power for 2, but in all cases,
   even after padding, {cmd:fft(}{it:h}{cmd:)} will be faster.  Use of
   {cmd:slowft()} is NOT recommended.  It is included for testing purposes.

*/

complex vector slowft(numeric vector h)
{
	real scalar		i, n 
	complex vector		H
	real scalar		k 
	complex scalar		w, wi, wk 

	n = length(h)
	w = exp(2*pi()*1i/n)
	H = J(rows(h),cols(h),0i)
	wi = 1
	for (i=1;i<=n;i++) { 
		wk = 1 
		for (k=1;k<=n;k++) { 
			H[i] = H[i] + wk*h[k]
			wk = wk * wi 
		}
		wi = wi * w
	}
	return(H)
}

end
