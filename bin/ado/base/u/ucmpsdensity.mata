*! version 1.0.0  10mar2011

version 12

mata:

mata set matastrict on

real matrix ucmpsdensity(real scalar n, real vector rho, real vector lambda,
			real vector order, real vector v, |real vector range)
{
	real scalar i, k, r, l, o, nv, n0
	real colvector lbda, ro, od, f, vv
	real matrix sd

	r = length(rho)
	l = length(lambda)
	o = length(order)
	nv = length(v)
	k = max((r,l,o,nv))
	if ((l!=1 & l!=k) | (r!=1 & r!=k) | (o!=1 & o!=k)) exit(3200)

	if (nv & nv!=1 & nv!=k) exit(3200)

	if (args() > 5) {
		if (length(range) != 2) {
			errprintf("{bf:range} must be a vector of length 2\n")
			exit(3200)
		}
		if (range[1]<0 | range[1]>range[2] | range[2]>pi()) {
			errprintf("{bf:range} must be in [0,pi()]\n")
			exit(3300)
		}
	}
	else range = (0,pi())

	if (r==1) ro = J(k,1,rho)
	else ro = rho

	if (l==1) lbda = J(k,1,lambda)
	else lbda = lambda

	if (o==1) od = J(k,1,order)
	else od = order

	if (nv) {
		if (nv==1) vv = J(k,1,v)
		else vv = v
	}

	n0 = floor(n+0.5)
	if (n0 < 2) {
		errprintf("{bf:n} must be an integer greater than 1\n")
		exit(3300) 
	}
	f = rangen(range[1],range[2],n0)

	sd = J(n0,k,.)
	for (i=1; i<=k; i++) {
		sd[.,i] = _ucm_spectralden(f,od[i],ro[i],lbda[i])

		/* power spectrum					*/
		if (nv) sd[.,i] = sd[.,i]:*vv[i]
	}
	return((sd,f))
}

/* spectral density of a cycle. Trimbur (2005), proposition 2.		*/
/* STATIC */
real matrix _ucm_spectralden(real colvector f, real scalar n, real scalar rho, 
		real scalar lbda)
{
	real scalar i, m, r2, p2, c, cl
	real colvector d, j, z, y
	real matrix Q, Z, Jm

	m = length(f)
	if (m<=0) return(J(0,1,.))

 	d = J(m,1,.)

	if (!n | m<=1) return(d)
	if (max(f)>pi() | min(f)<0) return(d)

	p2 = 2*pi()
	j = 0::(n-1)
	r2 = rho^2
	z = comb(n-1,j)
	c = p2*cross(z:^2,r2:^j)
	c = (1-r2)^(2*n-1)/c
	j = (j\n)

	z = comb(n,j)
	Q = (z*z'):*c

	cl = cos(lbda)
	y = ((1+4*r2*cl^2+r2*r2) :- ((4*rho*(1+r2)*cl):*cos(f)) :+ 
		((2*r2):*cos(2:*f))):^n

	z[.] = rho:^j
	Q[.,.] = Q:*(z*z')
	
	Jm = J(1,n+1,j):-j'
	Z = cos(lbda:*Jm)
	Q[.,.] = Q:*Z

	Q[.,.] = Q:*((-1):^(J(1,n+1,j):+j'))

	for (i=1; i<=m; i++) {
		d[i] = sum(Q:*cos(f[i]:*Jm))/y[i]
	}
	
	return(d)
}

end
exit

References:

Trimbur, T.M (2005) Properties of higher order stochastic cycles. 
   Journal of Time Series Analysis 27, 1-17.
