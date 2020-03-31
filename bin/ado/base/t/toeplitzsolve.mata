*! version 1.0.1  01jun2013
version 12.0

mata:
mata set matastrict on

/* Durbin-Levinson algorithm						*/
/* Compute e = inv(L)*Y, where V = Toeplitz(acf,acf') = L*D*L'		*/
/*  L is lower triangular with 1's on the diagonal, D = diagonal(v)	*/
/*  v = var(e), ldet = logdet(V) = sum(log(v)), 			*/
/*  (Palma, 2007, section 4.1)						*/
real matrix _toeplitzscale(real colvector acf, real matrix Y, real colvector v,
		real scalar ldet)
{
	/* internal							*/
	return(_toeplitzscale_u(0,acf,Y,v,ldet))
}

/* Compute z = inv(R)*Y, where R = cholesky(Toeplitz(acf,acf'))		*/
/*  (Palma, 2007, section 4.1)						*/
real matrix toeplitzscale(real colvector acf, real matrix Y)
{
	/* internal							*/
	return(_toeplitzscale_u(0,acf,Y))
}

/* Compute cholinv(V)*Y, where V = Toepliz(acf,acf')			*/
/*  acf is the autocovariance vector, 					*/
/*	acf[1] = var(Y), acf[i] = cov(Y_{k},Y_{k+i}) 			*/
/*  _toeplitz_solve() seems to have about the same numerical stability	*/
/*  as Cholesky factorization						*/
/* (Golub & Van Loan, 1997, sections 4.7.2 and 4.7.3)			*/
real matrix toeplitzsolve(real colvector acf, |real matrix Y)
{
	if (args()>1) return(_toeplitz_solve(acf,Y))

	return(_toeplitz_solve_YW(acf))
}

real matrix _toeplitz_solve(real colvector acf, real matrix y) 
{
	real scalar k, k1, n, m, kn, p, v
	real colvector z, i, c
	real matrix x

	n = rows(y)
	p = cols(y)

	if ((m=length(acf))<n) c = (acf\J(n-m,1,0))
	else if (m>n) c = acf[|1\n|]
	else c = acf

	z = J(n,1,.)
	x = J(n,p,.)
	v = c[1]
	x[1,.] = y[1,.]/v
	z[1] = -c[2]/v

	i = range(n,1,-1)
	k1 = 1
	for (k=2; k<=n; k++) {
		kn = n-k1+1
		if (abs(z[k1]) >= 1) {
			errprintf("Toeplitz matrix not positive definite\n")
			return(x)
		}
		v = v*(1-z[k1]^2)
		x[k,.] = (y[k,.]:-cross(c[|2\k|],x[i[|kn\n|],.])):/v
		x[|1,1\k1,p|] = x[|1,1\k1,p|] + z[i[|kn\n|]]*x[k,.]
		if (k < n) {
			z[k] = (-c[k+1]-cross(c[|2\k|],z[i[|kn\n|]]))/v
			z[|1\k1|] = z[|1\k1|] + z[k]:*z[i[|kn\n|]]
			k1 = k
		}
	}
	return(x)
}

/* Golub & Van Loan example from section 4.7.3 (2nd ed)			*/
real colvector _toeplitz_solve_YW(real colvector c)
{
	real scalar k, n, a, b
	real colvector x, i

	n = length(c)

	x = J(n,1,.)
	x[1] = a = -c[1]
	b = 1

	for (k=1; k<n; k++) {
		i = range(k,1,-1)
		if (abs(a) >= 1) {
			return(x)
		}
		b = b*(1-a^2)
		a = -(c[k+1] + cross(c[i],x[|1\k|]))/b
		x[|1\k|] = x[|1\k|] + a:*x[i]
		x[k+1] = a
	}
	return(x)
}

/* Compute Z = T*X, where V = T*T', V(n x n) = Toeplitz(t,t')		*/
/*  column vector t (n x 1) contains the autocovariance			*/
/* Schur's algorithm to factor ARFIMA Toeplitz covariance 		*/
/* (Stewart, 1997)							*/
real matrix toeplitzchprod(real colvector t, real matrix X)
{
	real scalar i, n, p, r
	real matrix G, Z

	n = length(t)
	p = cols(X)
	if (rows(X)!=n) exit(_error(3200))
		
	/* G is the Toeplitz covariance generator			*/
	G = J(n,2,0)
	G[.,1] = t:/sqrt(t[1])
	G[|2,2\n,2|] = G[|2,1\n,1|] 
	Z = G[.,1]*X[1,.]
	G[|2,1\n,1|] = G[|1,1\n-1,1|]
	G[1,1] = 0
	for (i=2; i<=n; i++) {
		r = -G[i,2]/G[i,1]
		G[|i,1\n,2|] = G[|i,1\n,2|]*((1,r\r,1):/sqrt((1-r)*(1+r)))
		Z[|i,1\n,p|] = Z[|i,1\n,p|] + G[|i,1\n,1|]*X[i,.]

		if (i<n) G[|i+1,1\n,1|] = G[|i,1\n-1,1|]
		G[i,1] = 0
	}
	return(Z)
}

end
exit

References:

Golub, G.H, and C.F. Van Loan (1989) Matrix Computations. The Johns Hopkins 
   University Press. sections 4.7.2 and 4.7.3

Palma, W. (2007) Long-Memory Time Series. Wiley.

Stewart, M. (1997) Cholesky factorization of semidefinite Toeplitz matrices.
   Linear Algebra and its Applications. (254) 497-525.

