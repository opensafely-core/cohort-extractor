*! version 1.0.1  20jan2005
version 9.0
mata:

/*
	Corrslowly(g,h,k)

	Corr(g,h,k)

	Return 2*k+1 row or colvector (depending whether g is row or 
	column) of correlations.  Middle element of returned vector 
	refers to lag 0, first element lag -K, etc.

    {cmd:Corrslowly(}{it:g}{cmd:,} {it:h}{cmd:,} {it:k}{cmd:)} obtains the
    same result as {cmd:Corr(}{it:g}{cmd:,} {it:h}{cmd:,} {it:k}{cmd:)} by
    direct calculation and is therefore slower.  Use of {cmd:Corrslowly()} is
    NOT recommended.  It is included for testing purposes.

*/

numeric vector Corrslowly(
numeric vector g,
numeric vector h,
real scalar K
) { 
	real scalar	j, jpk, n, k, l 
	real scalar	els
	numeric scalar	el

	numeric vector	res 

	els = 2*K + 1 
	el = (isreal(g) & isreal(h) ? 0 : 0i)
	res = (rows(g)==1 ? J(1,els,el) : J(els,1,el))

	n = length(g)
	if (n != length(h)) _error(3200)

	l = 1
	for (j= -K;j<=K;j++) { 
		for (k=1;k<=n;k++) { 
			jpk = j+k
/*
			if (jpk>=1 & jpk<=n) res[l] = res[l] + conj(g[jpk])*h[k]
*/
			if (jpk>=1 & jpk<=n) res[l] = res[l] + g[jpk]*conj(h[k])
		}
		l++
	}
	return(res)
}


end
