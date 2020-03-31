*! version 1.1.1  22feb2019

local BND_NONE = 0
local BND_LOWER = 1
local BND_UPPER = 2
local BND_INTERVAL = 3

mata:

mata set matastrict on

struct _ivtobit {
	string scalar depvar
	string colvector endog
	real scalar kendog 
	real rowvector bounds
	real scalar normalc
}

void ivtobit_eval(transmorphic M, real scalar todo, real rowvector b,
		real colvector lf, real matrix S, real matrix H)
{
	real scalar i, j, k, n, i1, j1, sij
	real colvector y, xb, r, z
	real rowvector ba
	real matrix R, T
	struct _ivtobit scalar P

	pragma unset H

	P = moptimize_util_userinfo(M,1)
	/* exogenous equation						*/
	y = moptimize_util_depvar(M,1)
	xb = moptimize_util_xb(M,b,1)

	n = rows(y)
	R = J(n,P.kendog,0)
	r = J(n,1,0)
	k = P.kendog+1
	T = J(k,k,0)
	ba = J(1,k*(k-1)/2,0)
	T[1,1] = 1
	i1 = k
	j1 = 0
	for (j=1; j<=k; j++) {
		if (j < k) {
			/* endogenous equation				*/
			/* make a copy in case of TS op			*/
			z = moptimize_util_depvar(M,j+1)
			r[.] = moptimize_util_xb(M,b,j+1)
			R[.,j] = z - r
		}
		/* correlations						*/
		for (i=j+1; i<=k; i++) {
			sij =  moptimize_util_xb(M,b,++i1)
			T[i,j] = tanh(sij)
			ba[++j1] = sij
		}
	}
	/* standard deviations						*/
	for (j=1; j<=k; j++) {
		sij =  moptimize_util_xb(M,b,++i1)
		T[j,j] = exp(sij)
	}
	_ivtobit_eval(todo, y, xb, R, T, ba, P.normalc, lf, S, P.bounds)
}

void _ivtobit_eval(real scalar todo, real colvector y, real colvector xb,
		real matrix R, real matrix T, real rowvector ba,
		real scalar normalc, real colvector lf, real matrix S,
		real rowvector bounds, |real scalar notrans)
{
	real scalar i, j, k, k1, kv, ki, ken, keq, kvec, krho
	real scalar n, d, vc, sc, bndt
	real colvector jl, ju, jlu, ji, ind, a, s, c
	real colvector z, z2, zi, zl, zu
	real colvector F, Fl, Fu 
	real colvector lf1, lf2, dl1dz
	real rowvector iv, jv, lv, ir, ii, jj, v, i1, j1
	real matrix V, C, RV, D, DV

	notrans = (missing(notrans)?0:notrans!=0)
	kv = rows(T)
	keq = kv + kv*(kv+1)/2
	n = rows(y)
	if (!notrans) {
		s = diagonal(T)
		_makesymmetric(T)
		/* set diagonal to 1's					*/
		_replacevalues(T,I(kv),J(kv,1,1))

		V = s:*T:*s'
		V = (V+V'):/2
		C = T[|2,2\kv,kv|]
		_cholesky(C)
		C = s[|2\kv|]:*C

		c = V[|2,1\kv,1|]
	}
	else {
		V = makesymmetric(T)
		V = (V+V'):/2
		C = V[|2,2\kv,kv|]
		c = V[|2,1\kv,1|]
		_cholesky(C)
	}
	R = solvelower(C,R')'
	(void)_solvelower(C,c)
	vc = V[1,1]-c'c
	if (vc <= 0) {
		if (!todo) {
			/* line search: force a step half		*/
			lf = J(n,1,.)
			return
		}
		/* trouble						*/
		vc = epsilon(1)
	}
	sc = sqrt(vc)
	xb = xb:+R*c
	d = sum(log(diagonal(C)))

	bndt = `BND_NONE'
	ind = (1::n)
	lf1 = J(n,1,.)
	if (!missing(bounds[1])) {
		jl = select(ind,(y:<=bounds[1]))
		if (rows(jl)) {
			z = J(n,1,.)
			zl = (xb[jl]:-bounds[1]):/sc
			z[jl] = zl
			/* 1-normal()					*/
			lf1[jl] = lnnormal(-zl) 
			bndt = `BND_LOWER'
		}
	}
	if (!missing(bounds[2])) {
		ju = select(ind,(y:>=bounds[2]))
		if (rows(ju)) {
			if (!rows(z)) z = J(n,1,.)

			zu = (xb[ju]:-bounds[2]):/sc
			z[ju] = zu
			lf1[ju] = lnnormal(zu)
			bndt = bndt + `BND_UPPER'
		}
	}
	if (bndt == `BND_LOWER') {
		ji = select(ind,(y:>bounds[1]))
	}
	else if (bndt == `BND_UPPER') {
		ji = select(ind,(y:<bounds[2]))
	}
	else if (bndt == `BND_INTERVAL') {
		ji = select(ind,((y:>bounds[1]):&(y:<bounds[2])))
	}
	if (bndt == `BND_NONE') {
		ji = 1::n
		z = zi = (y:-xb):/sc
		lf1[.] =  lnnormalden(zi):-log(sc)
	}
	else if (rows(ji)) {
		zi = (y[ji]:-xb[ji]):/sc
		z[ji] = zi
		lf1[ji] = lnnormalden(zi):-log(sc)
	}
	z2 = rowsum(R:*R,1)
	lf2 = (normalc - d) :- z2:/2

	lf = lf1 + lf2

	if (!todo) {
		return
	}

	S = J(n,keq,.)
	dl1dz = J(n,1,.)
	/* dlf1/zd							*/
	if (bndt != `BND_NONE') {
		F = J(n,1,.)
		if (bndt==`BND_LOWER' | bndt==`BND_INTERVAL') {
			Fl = exp(lf1[jl])
			F[jl] = Fl
			dl1dz[jl] = -normalden(zl):/Fl
			jlu = jl
		}
		if (bndt==`BND_UPPER' | bndt==`BND_INTERVAL') {
			Fu = exp(lf1[ju])
			F[ju] = Fu
			dl1dz[ju] = normalden(zu):/Fu
			jlu = (jlu\ju)
		}
		jlu[.] = sort(jlu,1)
	}
	ki = length(ji)

	if (ki) {
		dl1dz[ji] = zi
	}

	S[.,1] = dl1dz:/sc

	/*  dlf1/dxb + dlf2/dxb						*/
	k = cols(R)+1
	RV = solveupper(C',R')'
	a = solveupper(C',c)
	S[|1,2\n,k|] = dl1dz:*J(n,1,-a':/sc) + RV

	/* DV(n x kv*(kv+1)/2)						*/
	DV = _ivtobit_dl1dV(RV,a,vc,sc,dl1dz,z,jlu,ji)

	ken = kv-1
	kvec = ken*(ken+1)/2
	/* location of dl/dvech(V22)					*/
	k = ken + 1
	k1 = k + kvec
	k = k + 1

	DV[|1,k\n,k1|] = DV[|1,k\n,k1|] + ivtobit_dl2dV22(RV,C)
	kvec = kv*(kv+1)/2
	krho = kv*(kv-1)/2
	D = invvech(1::kvec)
	/* variance index						*/
	iv = diagonal(D)'
	/* covariance index						*/
	ir = select(vech(D),vech(J(kv,kv,1)-I(kv)))'

	if (notrans) {
		/* only used for testing				*/
		k = ken+2
		k1 = ken+krho+1
		/* covariances						*/
		S[|1,k\n,k1|] = DV[.,ir]
		/* variances						*/
		k = ken+krho+2
		S[|1,k\n,keq|] = DV[.,iv]
		return
	}

	/* atanh and log transformations				*/
	jj = select(vech(J(kv,1,1..kv)),vech(J(kv,kv,1)-I(kv)))'
	ii = select(vech(J(1,kv,1::kv)),vech(J(kv,kv,1)-I(kv)))'

	v = vech(V)'

	k = ken+krho+2
	S[|1,k\n,keq|] = DV[.,iv]:*(2:*v[iv])
	j = 0
	for (i=k; i<=keq; i++) {
		(void)++j
		i1 = (ii:==j)
		j1 = (jj:==j)
		jv = J(1,0,0)
		if (any(i1)) {
			jv = select(ir,i1)
		}
		if (any(j1)) {
			jv = (jv,select(ir,j1))
		}

		S[.,i] = S[.,i] + rowsum(DV[.,jv]:*v[jv],1)
	}

	/* std.dev. index for correlations				*/
	jv = select(vech(J(kv,1,1..kv)),vech(J(kv,kv,1)-I(kv)))
	lv = select(vech(J(1,kv,1::kv)),vech(J(kv,kv,1)-I(kv)))
	k = ken+2
	k1 = ken+krho+1
	S[|1,k\n,k1|] = DV[.,ir]:*(s[jv]':*s[lv]':/cosh(ba):^2)
}

real matrix _ivtobit_dl1dV(real matrix RV, real colvector a, real scalar vc,
		real scalar sc, real colvector dl1dz, real colvector z,
		real colvector jlu, real colvector ji)
{
	real scalar n, i, j, k, k1, kv, ken, kvec, ki, klu
	real colvector dldzlu, dldzi, zlu, zi, k2
	real colvector dvVv, rv, dm
	real matrix DV, K2, D, dldVlu, dldVi

	dldzlu = dl1dz[jlu]
	zlu = z[jlu]
	dldzi = dl1dz[ji]
	zi = z[ji]

	n = rows(RV)
	ken = cols(RV)
	kvec = ken*(ken+1)/2
	kv = ken+1
	ki = rows(ji)
	klu = rows(jlu)
	DV = J(n,kv*(kv+1)/2,.)
	/* dlf1/dv11							*/
	k = 1
	DV[jlu,k] = -dldzlu:*zlu:/(2*vc)
	DV[ji,k] = (dldzi:*zi :- 1):/(2*vc)

	/* dlf1/dv21							*/
	k1 = k+ken
	k = k+1

	DV[jlu,k..k1] = dldzlu:*(J(1,ken,zlu):*(a':/sc)+RV[jlu,.]):/sc
	DV[ji,k..k1] = dldzi:*(J(1,ken,-zi):*(a':/sc)+RV[ji,.]):/sc +
			J(ki,1,a':/vc)

	/* dlf1/dV22							*/
	k = k1
	k1 = k + kvec
	k = k + 1
	k2 = J(ken,ken,2)-I(ken)
	k2 = vech(k2)	// symmetry multiplier
	K2 = J(ken,ken,1)+I(ken)
	// D = J(ken,ken,.)	// faster to replace
	// rv = J(ken,1,.)
	// dm = J(kvec,1,.)
	dvVv = vech(colshape(a#a,ken)):*k2
	dldVlu = J(klu,kvec,.)
	for (i=1; i<=klu; i++) {
		j = jlu[i]
		rv = RV[j,.]'
		D = colshape(a#rv,ken)	// not symmetric
		D = (D+D'):/K2
		dm = vech(D)
		dldVlu[i,.] = -dldzlu[i]:*(dm':/sc + dvVv':*(zlu[i]/(2*vc)))
	}
	dldVi = J(ki,kvec,.)
	for (i=1; i<=ki; i++) {
		j = ji[i]
		rv = RV[j,.]'
		D = colshape(a#rv,ken)	// not symmetric
		D = (D+D'):/K2
		dm = -vech(D)
		dldVi[i,.] = dldzi[i]:*(dm':/sc + dvVv':*(zi[i]/(2*vc))) - 
				dvVv':/(2*vc)
	}
	DV[jlu,k..k1] = dldVlu
	DV[ji,k..k1] = dldVi

	return(DV)
}

real matrix ivtobit_dl2dV22(real matrix RV, real matrix C)
{
	real scalar n, kvec, ken
	real colvector ddet, dzVz //, rv
	real matrix k2, Vi, dl2dV

	n = rows(RV)
	ken = cols(RV)
	kvec = ken*(ken+1)/2
	k2 = J(ken,ken,1)
	_replacevalues(k2,I(ken),.5)
	k2 = vech(k2)	// symmetry multiplier
	Vi = solveupper(C',solvelower(C,I(ken)))

	ddet = -vech(Vi):*k2	// log determinant derivative
	dl2dV = J(n,kvec,.)
	dzVz = J(kvec,1,.)
/*	
	rv = J(ken,1,.)
	for (i=1; i<=n; i++) {
		rv[.] = RV[i,.]'
		dzVz[.] = vech(colshape(rv#rv,ken)):*k2
		/* dlf2/dV22						*/
		dl2dV[i,.] = (ddet+dzVz)'
	}
*/	
	__ivtobit_dl2dV22_loop(RV, ddet, dzVz, dl2dV)

	return(dl2dV)
}

void ivtobit_mopt(string scalar sb,
		string scalar depvar,
		real scalar kendog,
		real scalar ll,
		real scalar ul,
		string scalar touse,
		string scalar weight,
		string scalar wvar,
		string scalar vcetype,
		string scalar vceclvar,
		string scalar sC,
		real scalar log,
		string rowvector mlopts,
		real scalar debug,
		|string scalar scrvars)
{
	real scalar i, j, ib, k1, k2, keq, ec, scrsonly
	string scalar eq, valueid
	real rowvector b
	string rowvector vars
	real matrix eqinfo, scores, C
	string matrix stripe
	struct _ivtobit scalar P
	transmorphic M

	M = moptimize_init()

	stripe = st_matrixcolstripe(sb)
	eqinfo = panelsetup(stripe, 1)
	keq = rows(eqinfo)
	b = st_matrix(sb)

	moptimize_init_touse(M, touse)

	/* endogenous variables are the first in the depvar equation	*/
	P.kendog = kendog
	P.endog = stripe[|1,2\kendog,2|]
	/* cannot use 1st equation name as depvar, TS op allowed	*/
	P.depvar = depvar
	P.bounds = (ll,ul)

	for (i=1; i<=keq; i++) {
		k1 = eqinfo[i,1]
		k2 = eqinfo[i,2]
		eq = stripe[k1,1]
		if (eq == "/") {	// version 16+, free parameters
			for (j=i; j<=i+k2-k1; j++) {
				moptimize_init_eq_freeparm(M, j, "on")
				moptimize_init_eq_cons(M, j, "on")
				ib = k1+j-i
				moptimize_init_eq_coefs(M, j, b[ib])
				moptimize_init_eq_name(M, j, stripe[ib,2])
			}
		}
		else {
			moptimize_init_eq_name(M, i, eq)
			if (i == 1) {
				moptimize_init_depvar(M, i, P.depvar)
			}
			else if (i <= kendog+1) {
				moptimize_init_depvar(M, i, P.endog[i-1])
			}
			if (strmatch(stripe[k2,2],"_cons")) {
				moptimize_init_eq_cons(M, i, "on")
				(void)--k2
			}
			else {
				moptimize_init_eq_cons(M, i, "off")
			}
			if (k2>=k1) {
				vars = stripe[|k1,2\k2,2|]'
				moptimize_init_eq_indepvars(M, i, vars)
			}
			k2 = eqinfo[i,2]
			moptimize_init_eq_coefs(M, i, b[|k1\k2|])
		}
	}
	P.normalc = -P.kendog/2*log(2*pi())
	if (1) {
		if (debug) {
			moptimize_init_evaluatortype(M, "lf1debug")
		}
		else {
			moptimize_init_evaluatortype(M, "lf1")
		}
	}
	else {
		moptimize_init_evaluatortype(M, "lf0")
	}
	moptimize_init_search(M, "off")
	if (strlen(sC)) {
		C = st_matrix(sC)
		moptimize_init_constraints(M, C)
	}
	valueid = "log likelihood"

	if (strlen(weight)) {
		moptimize_init_weighttype(M, weight)
		moptimize_init_weight(M, wvar)
		if (strmatch(weight,"pweight")) {
			valueid = "log pseudolikelihood"
		}
	}
	if (strlen(vcetype)) {
		if (strlen(vceclvar)) {
			valueid = "log pseudolikelihood"
			moptimize_init_cluster(M, vceclvar)
		}
		else {
			moptimize_init_vcetype(M, vcetype)
			if (strmatch(vcetype,"robust")) {
				valueid = "log pseudolikelihood"
			}
		}
	}
	else {
		moptimize_init_vcetype(M, "oim")
	}
	moptimize_init_valueid(M, valueid)
	moptimize_init_userinfo(M, 1, P)

	/* users ML options contained in mlopt macro			*/
	moptimize_init_mlopts(M, mlopts)
	scrsonly = strlen(scrvars)
	if (scrsonly) {
		moptimize_init_conv_maxiter(M, 0)
	}

	if (!log) {
		moptimize_init_trace_value(M, "off")
	}
	else {
		moptimize_init_trace_value(M, "on")
	}

	moptimize_init_evaluator(M, &ivtobit_eval())

	if (scrsonly) {
		ec = _moptimize_evaluate(M)
	}
	else {
		ec = _moptimize(M)
	}
	if (ec) {
		exit(moptimize_result_returncode(M))
	}
	if (scrsonly) {
		scores = moptimize_result_scores(M)
		st_store(., tokens(scrvars), touse, scores)
	}
	else {
		moptimize_result_post(M)
		st_numscalar("e(ll)", moptimize_result_value(M))
	}
}

end

exit

