*! version 1.0.2  20jan2005
version 9.0
mata:

numeric vector Corr(
numeric vector g,
numeric vector h,
real scalar K
) {
	real scalar	n
	numeric vector	G, H

	if (length(h) != length(g)) _error(3200)

	H = J(1,K,0)			/* temporary set of zeros	*/
	G = C( ftpad(( (rows(g)==1 ? g : transposeonly(g)) ,H)) )
	H = C( ftpad(( (rows(h)==1 ? h : transposeonly(h)) ,H)) )
	_fft(G)
	_fft(H)
	G = G:*conj(H)
	H = . 				/* free memory		*/
	_invfft(G)
	if (isreal(g) & isreal(h)) G = Re(G)
	n = cols(G)
	G = (G[|n-K+1\n|], G[|1\K+1|])
	return(rows(g)==1 ? G : transposeonly(G))
}

end
