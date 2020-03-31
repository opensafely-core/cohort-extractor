*! version 1.0.2  23feb2006
version 9.0
mata:

/*
	numeric vector ftwrap(numeric vector r, real scalar m)

	Given response vector r 1 x n or n x 1, where n is odd, assumed
	to be a response vector, e.g., 

		r[1]   r[2]    r[3]   r[4]    r[5]
		t=-2   t=-1    t= 0   t= 1    r= 2

	produce a wrapped-around response vector of length m >= n:

		w[1]   w[2]    w[3]   w[4]    w[5]   ...   w[m-1]   w[m]
		r[3]   r[4]    r[5]   0       0            r[1]     r[2]

	In general:
		k = (n-1)/2
		r[1\k]		represents t<0
		t[k+1]		represents t=0
		t[k+2\n]	represents t>0
*/

numeric vector ftwrap(numeric vector r, real scalar m)
{
	real scalar	n
	real scalar	k 

	numeric vector	w

	k = ( (n=length(r)) - 1 )/2
	if (k!=trunc(k) | m<n) _error(3200) 

	w = (rows(r)==1 ? J(1,m,0) : J(m,1,0))
	if (iscomplex(r)) w = C(w)
	w[|1\k+1|] = r[|k+1\n|]
	w[|m-k+1\m|] = r[|1\k|]
	return(w)
}

end
