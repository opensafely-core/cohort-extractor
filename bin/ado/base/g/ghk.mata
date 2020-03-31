*! version 2.0.3  06nov2017
* ghk - GHK probit simulator

version 10.1
mata:

struct ghkparam {
	/* method of point set: 1=Halton, 2=Hammersley, 3=random	*/
	real scalar method
	/* number of points to use in the simulation			*/
	real scalar npts
	/* index of the first draw of the Halton sequence		*/
	real scalar start
	/* antithetics flag						*/
	real scalar anti
	/* pivot level: 0=no pivoting, 1=integration interval pivoting,	*/
	/*              2=interval pivoting & generalized Cholesky	*/
	real scalar pivlev
	/* random variate seed						*/
	string scalar seed
}
 
real scalar ghk(transmorphic A, B, C, |transmorphic D, E, F)
{
	real scalar a, l, rank
	real vector opt
	real matrix mopt
	pointer(struct ghkparam scalar) scalar S

	pragma unset rank

	/* caller compiled under or set version <= 10, use old syntax	*/
	if (callersversion()<=10 | statasetversion()<=1000) {
		mopt = C
		if (rows(mopt) > 1) {
			if (cols(mopt)>1) exit(_error(3201))
			opt = mopt'
		}
		else opt = mopt

		if ((l=length(opt)) < 2) {
			errprintf("minimum length of the opt vector is 2\n")
			exit(3200)
		}
		if (l==2) opt = (opt,1,0,2)
		else if (l==3) opt = (opt,0,2)
		else if (l==4) opt = (opt,2)
		else opt[5] = 2

		if ((a=args())==6) return(ghk_base(A,B,opt,D,E,F))
		if (a==4) return(ghk_base(A,B,opt,D))
		
		errprintf("expected 4 or 6 arguments but received %g\n", a)
		exit(3001)
	}
	S = &A
	opt = (S->method,S->npts,S->start,S->anti,S->pivlev)
	if ((a=args())==3) return(ghk_base(B,C,opt,rank))
	if (a==5) return(ghk_base(B,C,opt,rank,D,E))

	errprintf("expected 3 or 5 arguments but received %g\n", a)
	exit(3001)
}

/* static */
real scalar ghk_base(real vector x, real matrix V, real vector opt, 
	scalar rank, |real vector dfdx, real vector dfdv)
{
	real scalar m, l, a
	real vector opt1, p, d1, d2
	real matrix T, P
	pointer(real vector) vector res

	pragma unused rank

	m = length(x)
	if (rows(V)!=m || cols(V)!=m) {
		errprintf("x is of length %g, but V is %g x %g\n", 
			m, rows(V), cols(V))
		exit(3200)
	}
	if (missing(x) > 0) {
		errprintf("x vector has missing values\n")
		exit(3351)
	}
	if (missing(V) > 0) {
		errprintf("matrix V has missing values\n")
		exit(3351)
	}
	a = args()
	if (a != 4 && a != 6) {
		errprintf("ghk() must have 4 or 6 arguments\n")
		exit(3001)
	}
	if ((l=length(opt)) < 2) {
		errprintf("minimum length of the opt vector is 2\n")
		exit(3200)
		
	}
	if (opt[1]!=1 && opt[1]!=2 && opt[1]!=3) {
		errprintf("method option, opt[1], must equal 1, 2, or 3\n")
		exit(3300)
	}
	if (opt[2] <= 0 ) {
		errprintf("number of simulation points option, opt[2], must ")
		errprintf("be greater than 0\n")
		exit(3300)
	}
	if (a==6) opt1 = (1, opt)
	else opt1 = (0, opt)

	if (l>2 && opt[1]<3) {
		opt1[4] = round(opt1[4])
		if (opt1[4] < 1) {
			errprintf("index of the first draw must be greater ")
			errprintf("than 0\n")
			exit(3300)
		}
		opt1[4] = opt1[4] - 1
	}
	/* antithetics flag						*/
	if (l > 3) opt1[5] = (opt1[5] != 0)
	
	if ((callersversion()<=10.0|statasetversion()<=1000) & l<5) {
		/* use generalized Cholesky factorization 		*/
		if (l==2) opt1 = (opt1,0,0,2)
		else if (l==3) opt1 = (opt1,0,2)
		else if (l==4) opt1 = (opt1,2)
	}
	res = _ghk(x, V, opt1)
	if (opt1[1]) {
		p = invorder(*res[3])
		dfdx = (*res[5])[p]
		T = (*res[2])[p,.]
		P = I(m)[p,.]

		pragma unset d1
		pragma unset d2
		ghk_duplower(m, d1, d2)

		dfdv = (*res[6])*qrinv(((T#P)[,d1]+(P#T)[,d2])[d1,])
	}
	return((*res[1])[1])
}

void ghk_duplower(real scalar m, real vector d, real vector dt)
{
        real scalar i, j, k, l

	d = dt = J(m*(m+1)/2,1,.)
        k = l = 0

        for (j=1; j<=m; j++) {
                for (i=j; i<=m; i++) {
			d[++l] = ++k
			dt[l] = (i-1)*m+j
                }
                k = k + j
        }
}

struct ghkparam scalar ghk_init(real scalar npts)
{
	real scalar m

	struct ghkparam scalar S

	m = trunc(npts)
	if (m<=0 || missing(m)) {
		errprintf("sequence length must be a positive integer\n") 
		exit(3300)
	}
	S.npts = m
	/* Halton sequences						*/
	S.method = 1
	/* do not discard any of the initial sequences			*/
	S.start = 1
	/* no antithetics						*/
	S.anti = 0
	/* S.pivlev=1: the integration intervals so that the widest	*/
	/*  are on the inside						*/
	/* version <= 10 used generalized Cholesky factorization	*/
	/* version > 10  uses LAPACK Cholesky factorization		*/
	if (statasetversion()<=100) S.pivlev = 2
	else S.pivlev = 1

	return(S)
}

/* method of point set: RANDom, HALton, HAMmersley, GHALton		*/
function ghk_init_method(struct ghkparam scalar S, |string scalar method)
{
	real scalar l

	if (args()==1) return(("halton","hammersley","random")[S.method])
		
	l = strlen(method)
	if (method==bsubstr("halton",1,max((3,min((l,6)))))) {
		S.method = 1
	}
	else if (method==bsubstr("hammersley",1,max((3,min((l,10)))))) {
		S.method = 2
	}
	else if (method==bsubstr("random",1,max((4,min((l,6)))))) {
		S.method = 3
		S.seed = uniformseed()
	}
	else {
		errprintf("method must be one of halton, hammersley, or ")
		errprintf("random\n")
		exit(3300)
	}
}

function ghk_init_start(struct ghkparam scalar S, |real scalar start)
{
	if (args()==1) return(S.start)

	if (start<1) {
		errprintf("index of the first draw must be positive\n")
		exit(3300)
	}
	S.start = start
}

function ghk_init_pivot(struct ghkparam scalar S, |real scalar pivot)
{
	if (args()==1) return(S.pivlev!=0)

	S.pivlev = (pivot!=0)
}

function ghk_init_antithetics(struct ghkparam scalar S, |real scalar anti)
{
	if (args()==1) return(S.anti)

	S.anti = (anti!=0)
}

real scalar ghk_query_npts(struct ghkparam scalar S)
{
	return(S.npts)
}

end
exit
