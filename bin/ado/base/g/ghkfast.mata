*! version 2.0.0  01jul2008
* ghk - GHK probit simulator using pre-generated points
* dependencies: ghk.mata ghkfastsetup.mata

version 10.1
mata:
mata set matastrict on

/* extends ghkparam in ghk.mata						*/
struct ghkfastpoints {
	struct ghkparam scalar param
	/* number of cases						*/
	real scalar n
	/* maximum integration dimension				*/
	real scalar dim
	pointer (real matrix) colvector U
	/* pivot level: 0=no pivoting, 1=integration interval pivoting,	*/
	/*              2=interval pivoting & generalized Cholesky	*/
	real scalar pivlev
	/* antithetics flag						*/
	real scalar anti
}

real colvector ghkfast(struct ghkfastpoints scalar S, real matrix X, 
	real matrix V, |transmorphic A, B, C, D, E)
{
	real scalar a, rank, i, anti

	pragma unset rank
	a = args()
	/* caller compiled under or set version <= 10, use old syntax	*/
	if (callersversion()<=10 | statasetversion()<=1000) {
		if (a==4) return(ghkfast_base(S,X,V,A))
		if (a==5) return(ghkfast_base(S,X,V,A,B)) 
		if (a==6) return(ghkfast_base(S,X,V,A,B,C)) 

		return(ghkfast_base(S,X,V,A,B,C,D,E)) 
	}
	if (a>5 | a==4) {
		errprintf("expected 3 or 5 arguments but received %g\n", a)
		exit(3001)
	}
	anti = S.anti
	i = .
	return(ghkfast_base(S,X,V,rank,i,anti,A,B)) 
}

real colvector ghkfast_i(struct ghkfastpoints scalar S, real matrix X, 
	real matrix V, real scalar i, |real vector dfdx, real vector dfdv)
{
	real scalar a, rank, ii

	ii = trunc(i)
	if (ii<0 | ii>S.n) {
		errprintf("index must be greater than 0 and less than ")
		errprintf("or equal to %g\n", S.n)
		exit(3200)
	}
	a = args()
	if (a == 5) {
		errprintf("expected 4 or 6 arguments but received %g\n", a)
		exit(3001)
	}
	pragma unset rank
	if (a==4) return(ghkfast_base(S,X,V,rank,i,S.param.anti))

	return(ghkfast_base(S,X,V,rank,i,S.param.anti,dfdx,dfdv))
}

/* static */
real colvector ghkfast_base(struct ghkfastpoints scalar S, real matrix X, 
	real matrix V, real scalar rank,| real scalar i, real scalar anti,
	real matrix dfdx, real matrix dfdv)
{
	real scalar j, i1, i2, k, n, nc, d, na
	real rowvector opt, p, x
	real colvector d1, d2, l
	real matrix T, Q
	pointer(real vector) vector res

	if (S.param.npts <= 0) {
		errprintf("invalid points structure: ")
		errprintf("number of integration points must be greater than ")
		errprintf("0\n")
		exit(3300)
	}
	if (S.n <= 0) {
		errprintf("invalid points structure: ")
		errprintf("length of the points structure must be greater ")
		errprintf("than 0\n")
		exit(3300)
	}
	if (S.dim<=0 | S.dim>20) {
		errprintf("invalid points structure: ")
		errprintf("dimension of the points structure must be greater ")
		errprintf("than 0 ")
		errprintf("and less than or equal to 20\n")
		exit(3200)
	}
	d = cols(X)
	if (rows(V)>S.dim || cols(V)>S.dim || rows(V)!= cols(V)) {
		errprintf("V must be square with dimension at most %g\n", 
			S.dim)
		exit(3200)
	}
	if (d < 2 | d > S.dim) {
		errprintf("number of columns of X, %g, must be at least ", d)
		errprintf("2 and cannot exceed the dimension of the points ")
		errprintf("structure, %g\n", S.dim)
		exit(3200)
	}
	if (rows(V) != d) {
		errprintf("number of columns in X, %g, does not equal the ", d)
		errprintf("dimension of V, %g\n", cols(V))
		exit(3200) 
	}
	if (length(S.U)!=S.n) {
		errprintf("invalid points structure: ")
		errprintf("vector containing the point set matrices is the ")
		errprintf("wrong length\n")
		exit(3200)
	}
	if (missing(V) > 0) {
		errprintf("matrix V has missing values\n")
		exit(3351)
	}
	n = rows(X)
	if (i>=. || i<=0) {
		if (n > S.n) {
			errprintf("number of rows in X, %g, exceeds the ", n)
			errprintf("length of the points structure, %g\n", 
				S.n)
			exit(3200)
		}
		i1 = 1
		i2 = n
	}
	else {
		i = round(i)
		if (i > S.n) {
			errprintf("index %g exceeds the length of the ", i)
			errprintf("points structure, %g\n", S.n)
			exit(3200)
		}
		else {
			i1 = i2 = round(i)
			if (n<i & n>1) {
				errprintf("index %g exceeds number of ", i)
				errprintf("rows in X, %g\n", n)
				exit(3200)
			}
		}
	}
	nc = i2-i1+1
	k = 0
	opt = J(1,6,0)
	/* request derivatives					*/
	if ((na=args()) == 8) {
		opt[1] = 1
		pragma unset d1
		pragma unset d2
		ghk_duplower(d, d1, d2)
		dfdx = J(nc,d,.)
	   	dfdv = J(nc,d*(d+1)/2,.)
	} 
	/* antithetics						*/
	if (na > 5) opt[5] = (anti<. && anti!=0)
	/* method, user points 					*/
	opt[2] = 4
	opt[3] = S.param.npts
	opt[6] = S.param.pivlev

	l = J(nc,1,.)
	for (j=i1; j<=i2; j++) {
		if (rows(*S.U[j]) != S.param.npts) {
			errprintf("invalid points structure: ")
			errprintf("point set %g has the wrong length\n", j)
			exit(3200)
		}
		if (cols(*S.U[j]) != S.dim-1) {
			errprintf("invalid points structure: ")
			errprintf("point set %g has the wrong dimension\n", j)
			exit(3200)
		}
		if (n == 1) x = X
		else x = X[j,]

		if (missing(x) > 0) {
			errprintf("X matrix has missing values\n")
			exit(3351)
		}
		res = _ghk(x,V,opt,*S.U[j])
		l[++k] = (*res[1])[1]
		rank = *res[4]
		/* covariance is not full rank				*/
		/* version <= 10: generalized Cholesky factorization	*/
		if (rank<d & opt[6]<2) return(l)

		if (opt[1]) {
			p = invorder(*res[3])
			T = (*res[2])[p,.]
			Q = I(d)[p,.]
			dfdx[k,] = (*res[5])[p]
			dfdv[k,] = (*res[6])*qrinv(((T#Q)[,d1]+(Q#T)[,d2])[d1,])
		}
	}
	return(l)
}

/* ghkfastpoints constructor						*/
struct ghkfastspoints scalar ghkfast_init(real scalar n, real scalar npts, 
		real scalar dim, string scalar method) 
{
	return(ghkfastsetup(n,npts,dim,method))
}

function ghkfast_init_pivot(struct ghkfastpoints scalar S, |real scalar pivot)
{
	if (args()==1) return(ghk_init_pivot(S.param))

	ghk_init_pivot(S.param, pivot)
}

function ghkfast_init_antithetics(struct ghkfastpoints scalar S, 
		|real scalar anti)
{
	if (args()==1) return(ghk_init_antithetics(S.param))

	ghk_init_antithetics(S.param, anti)
}

real scalar ghkfast_query_npts(struct ghkfastpoints scalar S)
{
	return(ghk_query_npts(S.param))
}

real scalar ghkfast_query_dim(struct ghkfastpoints scalar S)
{
	return(S.dim)
}

real scalar ghkfast_query_n(struct ghkfastpoints scalar S)
{
	return(S.n)
}

string scalar ghkfast_query_rseed(struct ghkfastpoints scalar S)
{
	return(S.param.seed)
}

string scalar ghkfast_query_method(struct ghkfastpoints scalar S) 
{
	return(("halton","hammersley","random","ghalton")[S.param.method])
}
 
real matrix ghkfast_query_pointset_i(struct ghkfastpoints scalar S, 
	real scalar i)
{
	real scalar ii

	ii = trunc(i)
	if (ii<1 | ii>S.n) {
		errprintf("index must be a positive integer less than or ")
		errprintf("equal to %g\n", S.n)
	}
	return(*S.U[ii])
}

end
exit
