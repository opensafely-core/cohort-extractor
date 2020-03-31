*! version 1.1.1  06nov2017
version 9.0
mata:
mata set matastrict on


real matrix halton(real scalar n, d, |real scalar start, real scalar hammersley)
{
	real matrix x

	if (d<=0 || round(d)!=d) {
		errprintf("dimension must be a positive integer\n") 
		exit(3300)
	}
	if (n<0 || round(n)!=n) {
		errprintf("sequence length must be a nonnegative integer\n") 
		exit(3300)
	}
	x = J(n,d,.)
	if (n > 0) {
		if (start >= .) start = 1
		if (hammersley >= .) hammersley = 0
		_halton(x, start, hammersley)
	}
	return(x)
}

void _halton(real matrix x, |real scalar start, real scalar hammersley)
{
	real scalar n, d, d1, k, k1, pr
	real rowvector g_pr

	g_pr = (2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71)

	n = rows(x)
	d = cols(x)
	if (d == 0) {
		errprintf("dimension is zero\n") 
		exit(3200)
	}
	if (d > length(g_pr)) {	
		errprintf("maximum dimension is %g\n", length(g_pr))
		exit(3200)
	}
	if (n == 0) return

	if (start < .) {
		if (round(start)!=start || start<1) {
			errprintf("start must be a positive integer\n")
			exit(3300)
		}
	}
	else start = 1

	if (hammersley >= .) hammersley = 0
	else hammersley = (hammersley != 0)

	k1 = 0
	d1 = d 
	x = J(n,d,0)
	if (hammersley) {
		/* Hammersley */
		x[,1] = halton_mod1((2:*range(start,start+n-1,1):-1):/(2*n))
		k1 = 1
		--d1
	}

	for (k=1; k<=d1; k++) {
		pr = g_pr[k]
		x[,k+k1] = ghalton(n,pr,start-1)
	}
}

real vector function halton_mod1(real vector a)
{
	return(a:-floor(a))
}

end
