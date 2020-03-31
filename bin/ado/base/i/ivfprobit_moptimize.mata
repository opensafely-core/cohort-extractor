*! version 1.1.1  22feb2019
mata:

mata set matastrict on

struct _ivfprobit {
	string scalar depvar
	string colvector endog
	real scalar kendog 
	real scalar normalc
	real scalar binary
	real scalar fzero
}

void ivfprobit_eval(transmorphic M, real scalar todo, real rowvector b,
		real colvector lf, real matrix S, real matrix H)
{
	real scalar i, j, k, i1, j1, n, sij
	real colvector y, z, xb, r
	real rowvector ba
	real matrix R, T
	struct _ivfprobit scalar P

	pragma unused H

	P = moptimize_util_userinfo(M,1)
	/* exogenous equation						*/
	y = moptimize_util_depvar(M,1)
	if (P.binary) {
		y[.] = (y :> 0)
	}
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
			/* make a copy incase of TS op			*/
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
	for (j=2; j<=k; j++) {
		sij =  moptimize_util_xb(M,b,++i1)
		T[j,j] = exp(sij)
	}
	_ivfprobit_eval(todo, y, xb, R, T, ba, P.normalc, lf, S, 1, P.fzero)
}

void _ivfprobit_eval(real scalar todo, real colvector y, real colvector xb,
		real matrix R, real matrix T, real rowvector ba,
		real scalar normalc, real colvector lf, real matrix S,
		real scalar trans, real scalar fzero)
{
	real scalar i, i1, j, j1, j2, k, k1, k2, kv, keq, n, d, rs, rv
	real colvector s, c, F, F1, f, dlf, lnr, z, b
	real rowvector ba1, ba2, cV, ip
	real matrix C, V, DV, Dv, RV

	kv = rows(T)
	n = rows(y)
	if (trans) {
		s = diagonal(T)
		_makesymmetric(T)
		/* set diagonal to 1's					*/
		_replacevalues(T,I(kv),J(kv,1,1))

		V = s:*T:*s'
		C = T[|2,2\kv,kv|]
		_cholesky(C)
		s = s[|2\kv|]
		C = s:*C

		c = V[|2,1\kv,1|]
	}
	else {
		V = makesymmetric(T)
		C = V[|2,2\kv,kv|]
		c = V[|2,1\kv,1|]
		_cholesky(C)
	}

	R = solvelower(C,R')'
	(void)_solvelower(C,c)
	rv = 1-c'c
	if (rv <= 0) {
		if (!todo) {
			/* line search: force a step half		*/
			lf = J(n,1,.)
			return
		}
		/* trouble						*/
		rv = epsilon(1)
	}
	rs = sqrt(rv)

	xb = xb:+R*c
	d = sum(log(diagonal(C)))

	z = xb:/rs
	F = normal(z)
	F1 = normal(-z)	 // 1-F
	b = (F:<fzero)
	if (any(b)) {
		_replacevalues(F,b,fzero)
	}
	b = (F1:<fzero)
	if (any(b)) {
		_replacevalues(F1,b,fzero)
	}
	/* k = kv - 1							*/
	k = cols(R)
		
	lnr = normalc :- rowsum(R:*R):/2 :- d
	lf = y:*log(F) + (1:-y):*log(F1) :+ lnr

	if (!todo) {
		return
	}

	f = normalden(z)
	dlf = y:*f:/F - (1:-y):*f:/F1

	/* +1 for depvar eq and -1 for V[1,1]=1 eq			*/
	keq = k + kv*(kv+1)/2

	RV = solveupper(C',R')'
	cV = solveupper(C',c)'

	S = J(n,keq,.)
	/* exogenous equation						*/
	S[.,1] = dlf:/rs
	/* endogenous equations						*/
	k1 = 2
	k2 = k+1
	S[|1,k1\n,k2|] = RV - (dlf:/rs):*J(n,1,cV)
	/* ancillary parameters						*/
	k1 = k2+1
	k2 = k2 + k
	ba1 = ba[|1\k|]
	/* Dlf/Dv							*/
	Dv = dlf:*(RV:+xb*cV:/rv):/rs
	if (trans) {
		S[|1,k1\n,k2|] = Dv:*(s':/cosh(ba1):^2)
	}
	else {
		S[|1,k1\n,k2|] = Dv
	}

	k1 = k2+1
	j = k*(k+1)/2
	k2 = k2 + j
	if (k > 1) {
		ba2 = ba[|k+1\j|]
	}
	else {	
		ba2 = J(1,0,0)
	}
	/* Dlf/DV							*/
	DV = dlf:*_ivfprobit_DxbDV(xb,RV,cV,rs) + _ivfprobit_DlnrDV(RV,C) 
	if (trans) {
		DV = _ivfprobit_DVDT(DV, Dv, V, s, ba2)
	}
	if (k == 1) {
		S[|1,k1\n,k2|] = DV
	}
	else {
		/* pivot vector, take out the vech order		*/
		ip = J(1,j,0)
		j1 = i1 = 0
		j2 = j-k
		for (i=1; i<=k; i++) {
			ip[++j2] = ++i1
			for (j=i+1; j<=k; j++) {
				ip[++j1] = ++i1
			}
		}
		S[|1,k1\n,k2|] = DV[.,ip]
	}
}

real matrix _ivfprobit_DlnrDV(real matrix RV, real matrix C)
{
	real scalar k, m, n
	real rowvector DC
	real matrix D, Dk, I2, Ci

	k = rows(C)
	m = k*(k+1)/2
	n = rows(RV)
	
	D = J(n,m,0)
	I2 = J(k,k,1)+I(k)

	Ci = solvelower(C,I(k))
	Dk = Ci'Ci
	/* account for vij = vji 					*/
	Dk = (Dk + Dk'):/I2
	DC = vech(Dk)':/2
/*	
	for (i=1; i<=n; i++) {
		Dk[.,.] = colshape(RV[i,.]#RV[i,.],k)
		/* account for vij = vji 				*/
		Dk[.,.] = (Dk + Dk'):/I2
		D[i,.] = vech(Dk)':/2 - DC
	}
*/
	__ivfprobit_DlnrDV_loop(D, RV, DC)
	return(D)
}

real matrix _ivfprobit_DxbDV(real colvector xb, real matrix RV, 
		real rowvector cV, real scalar rs)
{
	real scalar k, m, n
	real rowvector dVd
	real matrix DV, D, I2

	/* xb[.] = (xb:+R*c)/sqrt(1-c'c)				*/
	k = cols(cV)
	n = rows(RV)

	I2 = J(k,k,1)+I(k)
	/* Lutkepohl, section 10.6.1					*/
	/* denominator: symmetric					*/
	D = colshape(cV#cV,k)
	/* account for vij = vji, i!=j					*/
	D = (D+D'):/I2
	dVd = -vech(D)'/(2*rs^3)

	m = k*(k+1)/2
	DV = J(n,m,0)
/*
	D = J(k,k,0)
	for (i=1; i<=n; i++) {
		/* numerator: not symmetric				*/
		D[.,.] = colshape(cV#RV[i,.],k)
		/* account for vij = vji, i!=j				*/
		D[.,.] = (D+D'):/I2
		DV[i,.] = -vech(D)':/rs + xb[i]:*dVd
	}
*/
	__ivfprobit_DxbDV_loop(DV, cV, RV, rs, xb, dVd)
	return(DV)
}

real matrix _ivfprobit_DVDT(real matrix DV, real matrix Dv, real matrix V, 
		real colvector s, real rowvector ba)
{
	real scalar i, j, k, m, n, i1, i2
	real colvector id, dv, v
	real rowvector dVdx
	real matrix D, V1

	k = rows(V)
	v = V[|2,1\k,1|]
	V1 = V[|2,2\k,k|]
	(void)--k
	m = k*(k+1)/2
	n = rows(DV)
	dVdx = J(1,m,0)
	D = J(n,m,0)
	dv = J(n,1,0)
	id = J(k,1,0)
	i1 = i2 = 0
	for (i=1; i<=k; i++) {
		dVdx[++i1] = 2*V1[i,i]
		id[i] = i1
		for (j=i+1; j<=k; j++) {
			dVdx[++i1] = s[i]*s[j]/cosh(ba[++i2])^2
		}
	}
	D = DV:*dVdx
	i1 = 0
	for (i=1; i<=k; i++) {
		(void)++i1
		D[.,id[i]] = D[.,id[i]] + Dv[.,i]:*v[i]
		for (j=i+1; j<=k; j++) {
			dv[.] =  V1[j,i]:*DV[.,++i1]
			D[.,id[i]] = D[.,id[i]] + dv
			D[.,id[j]] = D[.,id[j]] + dv
		}
	}
	return(D)
}

void ivfprobit_mvreg(string rowvector ylist, string rowvector xlist,
		string scalar touse, string scalar wvar, string rowvector rlist,
		string scalar sb, string scalar vce, string scalar sr,
		string scalar sE, string scalar srank)
{
	real scalar k, m, rank
	real rowvector p
	real colvector wt
	string rowvector eqs
	real matrix Y, Yh, X, B, E, r, R, V
	string matrix stripe

	pragma unset rank
	pragma unset p
	pragma unset E
	pragma unset R
	pragma unset rank
	pragma unset r

	rlist = tokens(rlist)
	ylist = tokens(ylist)
	xlist = tokens(xlist)
	Y = Yh = st_data(.,ylist,touse)
	X = st_data(.,xlist,touse)
	if (strlen(wvar)) {
		wt = st_data(.,wvar,touse)
	}
	/* on output Yh contains predicted Y; constant in model		*/
	B = _lsfitqr(X,Yh,wt,1,rank,E,r,R,p)

	Yh = Y - Yh
	st_store(.,rlist,touse,Yh)
	k = rows(B)
	m = cols(Yh)
	eqs = ylist
	/* replace ts ops with underscores				*/
	eqs = usubinstr(ylist,".","_",.)
	stripe = (vec(J(k,1,eqs)),J(m,1,xlist'\"_cons"))

	/* pivot constant to last coefficient				*/
	p = (2::k\1)
	if (strlen(sb)) {
		/* coefficients; p x m, p=# regressors w/ constant 	*/
		st_matrix(sb,vec(B[p,.])')
		st_matrixcolstripe(sb,stripe)
	}
	if (strlen(vce)) {
		/* R'R = X'X						*/
		V = I(rows(R))
		/* solveupper handles zeros on diagonal; G-2 inverse	*/
		_solveupper(R,V)
		V = (V*V')
		V = V[p,p']
		V = E#V
		st_matrix(vce,V)
		st_matrixcolstripe(vce,stripe)
		st_matrixrowstripe(vce,stripe)
	}
	stripe = (J(m,1,""),ylist')
	if (strlen(sE)) {
		/* residual covariance					*/
		st_matrix(sE,E)
		st_matrixcolstripe(sE,stripe)
		st_matrixrowstripe(sE,stripe)
	}
	if (strlen(sr)) {
		/* regression mean square matrix			*/
		st_matrix(sr,r)
		st_matrixcolstripe(sr,stripe)
		st_matrixrowstripe(sr,stripe)
	}
	if (strlen(srank)) {
		st_matrix(srank,rank)
	}
}

void ivfprobit_mopt(string scalar sb,
		string scalar depvar,
		real scalar kendog,
		string scalar touse,
		string scalar weight,
		string scalar wvar,
		string scalar vcetype,
		string scalar vceclvar,
		string scalar offset,
		string scalar sC,
		string scalar log,
		string rowvector mlopts,
		real scalar binary,
		real scalar debug,
		|string scalar scrvars)
{
	real scalar i, j, ib, k1, k2, keq, ec, scrsonly
	real rowvector b
	real matrix eqinfo, scores, C
	string scalar eq, valueid
	string rowvector vars
	string matrix stripe
	struct _ivfprobit scalar P
	transmorphic M

	string scalar usrname
	usrname = st_local("moptobj")
	
	M = moptimize_init()

	stripe = st_matrixcolstripe(sb)
	eqinfo = panelsetup(stripe, 1)
	keq = rows(eqinfo)
	b = st_matrix(sb)

	moptimize_init_touse(M, touse)
	if (strlen(offset)) moptimize_init_eq_offset(M, 1, offset)

	/* endogenous variables are the first in the depvar equation	*/
	P.kendog = kendog
	P.endog = stripe[|1,2\kendog,2|]
	/* cannot use 1st equation name as depvar, TS op allowed	*/
	P.depvar = depvar
	P.binary = binary
	P.fzero = normal(-25)

	for (i=1;i<=keq;i++) {
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
	if (!binary) {
		valueid = "log pseudolikelihood"
	}
	else {
		valueid = "log likelihood"
	}
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
	else if (!binary) {
		moptimize_init_vcetype(M, "robust")
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

	if (log == "nolog") {
		moptimize_init_trace_value(M, "off")
	}
	else {
		moptimize_init_trace_value(M, "on")
	}
	moptimize_init_evaluator(M, &ivfprobit_eval())

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

	if (usrname != "") {
		pointer (struct mopt__struct scalar) scalar pM
		pM = crexternal(usrname)
		(*pM) = M
	}
	
}

end
exit
