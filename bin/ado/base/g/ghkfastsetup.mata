*! version 2.1.4  06nov2017
* ghkfastsetup - generate halton/uniform sequences for ghkfast
* dependencies: ghkfast.mata

version 10.1
mata:
mata set matastrict on

struct ghkfastspoints scalar ghkfastsetup(real scalar n, real scalar npts, 
		real scalar dim, string scalar method, |real scalar start) 
{
	real scalar imethod, i, j, k, k1, l, d1, pr, d, nn, m
	real rowvector primes, u
	real matrix U
	struct ghkfastpoints scalar S

	primes = (2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71)

	d = trunc(dim)
	if (d<=0 || d>length(primes)) {
		errprintf("dimension must be a positive integer less than ") 
		errprintf("or equal to %g\n", length(primes))
		exit(3300)
	}
	nn = trunc(n)
	if (nn<=0 || missing(nn)) {
		errprintf("number of observations must be a positive ")
		errprintf("integer\n") 
		exit(3300)
	}
	S.dim = d
	S.n = nn

	S.param = ghk_init(npts)
	m = S.param.npts
	/* ghk() does not have the ghalton option			*/
	/* do not call ghk_init_method() but keep indices consistent	*/
	l = strlen(method)
	if (method==bsubstr("halton",1,max((3,min((l,6)))))) {
		imethod = 1
		S.param.method = imethod = 1
	}
	else if (method==bsubstr("hammersley",1,max((3,min((l,10)))))) {
		imethod = 2
		S.param.method = imethod = 2
	}
	else if (method==bsubstr("random",1,max((4,min((l,6)))))) {
		imethod = 3
		S.param.method = imethod = 3
	}
	else if (method==bsubstr("ghalton",1,max((4,min((l,7)))))) {
		imethod = 4
		S.param.method = imethod = 4
	}
	else {
		errprintf("method must be one of halton, hammersley, random, ")
		errprintf("or ghalton\n")
		exit(3300)
	}
	if (!missing(start)) {
		if (start<=0 || start!=trunc(start)) {
			errprintf("index of the first draw must be a ")
			errprintf("positive integer\n")
			exit(3300)
		}
		if (imethod > 2) {
			errprintf("start is not allowed with methods random ")
			errprintf("and ghalton\n")
			exit(300)
		}
	}
	else start = 1

	S.param.start = start

	d1 = d-1
	S.U = J(n,1,NULL)
	if (imethod == 3) {
		S.param.seed = uniformseed()

		for (i=1; i<=n; i++) S.U[i] = &uniform(m,d1)
	}
	else {
		U = J(m,d1,.)
		k1 = 0
		if (imethod == 2) {
			U[,1] = halton_mod1((2:*range(start,m+start-1,1):-1):/
					(2*m))
			--d1
			++k1
		}
		if (imethod == 4) {
			S.param.seed = uniformseed()
			u = uniform(1,d)
		}
		else u = J(1,d,0)

		j = start - 1 
		for (i=1; i<=n; i++) {
			for (k=1; k<=d1; k++) {
				pr = primes[k]
				if (imethod<3) U[,k+k1] = ghalton(m,pr,j)
				else U[,k+k1] = ghalton(m,pr,u[k+k1])
			}
			if (imethod==4) u = U[m,]
			else j = j + m

			S.U[i] = &J(1,1,U)
		}
	}
	return(S)
} 

end
exit
