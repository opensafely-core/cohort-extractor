*! version 1.1.5  26jun2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_cov.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

local MENL_EM_DELTA_TRIANGULAR = 1

mata:

mata set matastrict on

void _menl_display_mopts(struct _menl_mopts scalar mopts)
{
	printf("\n")
	printf("maxiter    = %g\n",mopts.maxiter)
	printf("log        = %g\n",mopts.log)
	printf("ltype      = %s\n",mopts.ltype)
	printf("ltol       = %g\n",mopts.ltol)
	printf("tol        = %g\n",mopts.tol)
	printf("nrtol      = %g\n",mopts.nrtol)
	printf("nonrtol    = %g\n",mopts.nonrtol)
	printf("nostderr   = %g\n",mopts.nostderr)
	printf("tracelevel = %s\n",mopts.tracelevel[mopts.itracelevel])
	printf("metric     = %s\n",mopts.metric)
	printf("\n")
}

void _menl_parse_mopts(string scalar smopts, struct _menl_mopts scalar mopts,
			|real scalar mdefault)
{
	real scalar val
	string scalar tok
	transmorphic t

	mdefault = (missing(mdefault)?`MOPTS_DEFAULT_STANDARD':mdefault)
	/* defaults							*/
	if (mdefault == `MOPTS_DEFAULT_PNLS') {
		mopts.maxiter = 5
		mopts.debug = `MENL_FALSE'
		mopts.log = `MENL_FALSE'
		mopts.itracelevel = `MENL_TRACE_NONE'
	}
	else if (mdefault == `MOPTS_DEFAULT_LME') {
		mopts.maxiter = 5
		mopts.debug = `MENL_FALSE'
		mopts.log = `MENL_FALSE'
		mopts.itracelevel = `MENL_TRACE_NONE'
		mopts.special = "vseecov"	// tech for var comp std.errs.
	}
	else if (mdefault == `MOPTS_DEFAULT_EM') {
		mopts.maxiter = 5
		mopts.debug = `MENL_FALSE'
		mopts.log = `MENL_FALSE'
		mopts.itracelevel = `MENL_TRACE_NONE'
	}
	else {	// MOPTS_DEFAULT_STANDARD
		mopts.maxiter = st_numscalar("c(maxiter)")
		mopts.debug = `MENL_FALSE'
		mopts.log = `MENL_TRUE'
		mopts.itracelevel = `MENL_TRACE_VALUE'
	}
	mopts.ltol = 1e-7	// likelihood tolerance
	mopts.tol = 1e-6	// parameter tolerance
	mopts.nrtol = 1e-5	// scaled gradient tolerance
	mopts.nonrtol = `MENL_FALSE'	// convergence: use scaled gradient
	mopts.vce = "oim"
	mopts.nostderr = `MENL_FALSE'
	mopts.tracelevel = ("none",	// nothing
			"value",	// function value
            		"tolerance",    // previous + convergence values
               		"step",         // previous + stepping information
			"params",	// previous + parameter values
               		"gradient",     // previous + gradient vector
               		"hessian")      // previous + Hessian matrix
	mopts.metric = ""

	if (!strlen(smopts)) {
		return
	}

	/* assumption: ado did all error checking			*/
	t = tokeninit(" ")
	tokenset(t,smopts)
	while ((tok=tokenget(t))!="") {
		if (tok == "iterate") {
			tok = tokenget(t)
			val = strtoreal(tok)
			if (!missing(val)) {
				mopts.maxiter = val
			}
		}
		else if (tok == "nolog") {
			mopts.log = `MENL_FALSE'
			mopts.itracelevel = `MENL_TRACE_NONE'
		}
		else if (tok == "log") {
			mopts.log = `MENL_TRUE'
			if (mopts.itracelevel == `MENL_TRACE_NONE') {
				mopts.itracelevel = `MENL_TRACE_VALUE'
			}
		}
		else if (tok=="oim" | tok=="robust") {
			mopts.vce = tok
		}
		else if (tok=="mle" | tok=="reml") {
			mopts.ltype = tok
		}
		else if (tok == "ltolerance") {
			tok = tokenget(t)
			val = strtoreal(tok)
			if (!missing(val)) {
				mopts.ltol = val
			}
		}
		else if (tok == "tolerance") {
			tok = tokenget(t)
			val = strtoreal(tok)
			if (!missing(val)) {
				mopts.tol = val
			}
		}
		else if (tok == "nrtolerance") {
			tok = tokenget(t)
			val = strtoreal(tok)
			if (!missing(val)) {
				mopts.nrtol = val
			}
		}
		else if (tok == "nonrtolerance") {
			mopts.nonrtol = `MENL_TRUE'
		}		
		else if (tok == "showtolerance") {
			if (mopts.itracelevel <= `MENL_TRACE_TOLERANCE') {
				mopts.itracelevel = `MENL_TRACE_TOLERANCE'
			}
		}
		else if (tok == "showstep") {
			if (mopts.itracelevel <= `MENL_TRACE_STEP') {
				mopts.itracelevel = `MENL_TRACE_STEP'
			}
		}
		else if (tok == "trace") {
			if (mopts.itracelevel <= `MENL_TRACE_PARAMS') {
				mopts.itracelevel = `MENL_TRACE_PARAMS'
			}
		}
		else if (tok == "gradient") {
			if (mopts.itracelevel <= `MENL_TRACE_GRADIENT') {
				mopts.itracelevel = `MENL_TRACE_GRADIENT'
			}
		}
		else if (tok == "hessian") {
			if (mopts.itracelevel <= `MENL_TRACE_HESSIAN') {
				mopts.itracelevel = `MENL_TRACE_HESSIAN'
			}
		}
		else if (tok == "metric") {
			tok = tokenget(t)
			mopts.metric = tok
		}
		else if (tok == "debug") {
			tok = tokenget(t)
			val = strtoreal(tok)
			if (!missing(val)) {
				mopts.debug = val
			}
		}
		else if (tok == "nostderr") {
			mopts.nostderr = `MENL_TRUE'
		}
		else if (tok == "vsehier") {
			/* special lme opt: tech for comp var comp
			 *  std.errs.					*/
			mopts.special = tok
		}
	}
}

void _menl_constraint_matrix(string scns,
		struct _menl_constraints scalar cns)
{
	string vector sC
	real scalar rc

	cns.C.erase()
	cns.T.erase()
	cns.a.erase()
	sC = tokens(scns)
	if (length(sC) != 3) {
		return
	}
	if (rc=cns.C.st_getmatrix(sC[1])) {
		errprintf("{p}%s{p_end}\n",cns.C.errmsg())
		exit(rc)
	}
	if (rc=cns.T.st_getmatrix(sC[2])) {
		errprintf("{p}%s{p_end}\n",cns.T.errmsg())
		exit(rc)
	}
	if (rc=cns.a.st_getmatrix(sC[3])) {
		errprintf("{p}%s{p_end}\n",cns.a.errmsg())
		exit(rc)
	}
}

void _menl_lbates_trace(class __menl_expr scalar expr,
		class __menl_pnls scalar pnls, class __menl_lme scalar lme,
		real scalar iter,
		struct _menl_mopts scalar mopts, real rowvector bFE,
		real rowvector bcov, real vector rdif, real vector conv)
{
	real scalar i, k
	string matrix stripe
	class __stmatrix scalar b
	pointer (class __pathcovmatrix) vector covs
	pointer (class __ecovmatrix) scalar var

	if (!mopts.debug & mopts.itracelevel<=`MENL_TRACE_VALUE') {
		return
	}
	printf("\n{txt}{hline 78}\n")
	printf("{txt}PNLS/LME step %g relative differences\n",iter)
	printf("{txt}FE:{col 7}{res}%12.4e{col 30}{txt}" +
		"tolerance:{col 42}{res}%12.4e\n",rdif[1],mopts.tol)
	printf("{txt}cov:{col 7}{res}%12.4e\n",rdif[2])
	if (iter > 1) {
		printf("{txt}lf:{col 7}{res}%12.4e{col 30}{txt}" +
			"ltolerance:{col 42}{res}%12.4e\n",rdif[3],mopts.ltol)
	}
	printf("{txt}PNLS converged: {res}%s\n",(conv[1]?"yes":"no"))
	printf("{txt}LME converged:  {res}%s\n",(conv[2]?"yes":"no"))

	if (!mopts.debug & mopts.itracelevel<`MENL_TRACE_PARAMS') {
		return
	}
	b.erase()
	(void)b.set_matrix(bFE,"_parameters")
	stripe = pnls.stripe()
	(void)b.set_colstripe(stripe)
	b.display("Fixed effects")
	b.erase()
	(void)b.set_matrix(bcov,"_parameters")
	stripe = lme.stripe()
	stripe = (stripe\("/Residual","lnsigma"))
	(void)b.set_colstripe(stripe)
	b.display("Variance components")

	if (!mopts.debug) {
		return
	}
	covs = expr.path_covariances() // RE covariances
	var = expr.res_covariance() 
	k = length(covs)
	for (i=1; i<=k; i++) {
		covs[i]->display(sprintf("cov(%s)/sigma^2",covs[i]->path()))
	}
	covs = NULL
	var->compute_V(3)
	var->display("var(Residuals)/sigma^2")

	printf("\n{txt}scale matrix{res}\n")
	var->scale_matrix()

	printf("\n{txt}sigma = {res}%g\n\n",var->sigma())
	var = NULL
}

void _menl_lbates(class __menl_expr scalar expr, string scalar sCc,
		string scalar smopts, string scalar lmeopts, 
		string scalar pnlsopts, |string scalar touse)
{
	real scalar iter, rc, dfe, dcov, profile, upbFE
	real scalar conv1, conv2, converged
	real scalar noFE, lf0, lf, dlf
	real rowvector bFE0, bFE, bcov0, bcov
	class __menl_pnls scalar pnls
	class __menl_lme scalar lme
	struct _menl_mopts scalar mopts, popts, lopts
	struct _menl_constraints scalar cns

	rc = 0
	_menl_constraint_matrix(sCc,cns)

	_menl_parse_mopts(smopts, mopts, `MOPTS_DEFAULT_ALTERNATE')
	_menl_parse_mopts(lmeopts, lopts, `MOPTS_DEFAULT_LME')
	_menl_parse_mopts(pnlsopts, popts, `MOPTS_DEFAULT_PNLS')

	lme.clear()	// for grins, clear used memory
	pnls.clear()	// clear used memory
	lme.set_subexpr(expr,touse)
	pnls.set_subexpr(expr,touse)
	converged = 0
	bFE0 = expr.FE_parameters()
	if (mopts.ltype == "reml" & cols(bFE0)==0) {
		errprintf("{p}option {bf:reml} not allowed; no fixed " +
			"effects in the model{p_end}\n")
		exit(498)
	}
	/* scale variances by residual variance				*/
	expr.scale_covariances(`MENL_SCALE_DIVIDE', mopts.debug)

	if (mopts.maxiter == 0) {
		noFE = `MENL_TRUE'	// do not modify FE parameters
		/* get RE vectors					*/
		popts.maxiter = 50
		if (rc=pnls.initialize(cns,popts,noFE)) {
			errprintf("{p}%s{p_end}\n",pnls.errmsg())
			pnls.clear()
			lme.clear()
			exit(rc)
		}
		if (rc=pnls.run()) {
			errprintf("{p}%s{p_end}\n",pnls.errmsg())
			pnls.clear()
			lme.clear()
			exit(rc)
		}
		/* iterate 0 with fixed effects				*/
		popts.maxiter = 0
		if (rc=pnls.initialize(cns,popts)) {
			errprintf("{p}%s{p_end}\n",pnls.errmsg())
			pnls.clear()
			lme.clear()
			exit(rc)
		}
		if (rc=pnls.run()) {
			errprintf("{p}%s{p_end}\n",pnls.errmsg())
			pnls.clear()
			lme.clear()
			exit(rc)
		}
		/* unscale variances by residual variance		*/
		expr.scale_covariances(`MENL_SCALE_MULTIPLY', mopts.debug)

		lopts.nostderr = mopts.nostderr
		if (mopts.log & !mopts.debug & !mopts.nostderr) {
			printf("{txt}Computing standard errors:\n")
		}
		lopts.maxiter = 0
		/* clears pnls and lme					*/
		_menl_lbates_final(expr,lme,pnls,lopts)
		st_numscalar("r(converged)",0)
		return
	}
	conv1 = conv2 = `MENL_FALSE'

	if (mopts.log) {
		printf("{txt}Alternating PNLS/LME algorithm:\n")
		if (!popts.log & !lopts.log) {
			printf("\n")
		}
		displayflush()
	}
	lf0 = mindouble()
	bcov0 = expr.cov_parameters()
	profile = `MENL_TRUE' 	// profile likelihood
	for (iter=1; iter<=mopts.maxiter; iter++) {
		if (lopts.log | popts.log) {
			printf("{txt}\nIteration %g\n",iter)
		}
		if (iter == 1) {
			if (rc=pnls.initialize(cns,popts)) {
				errprintf("{p}%s{p_end}\n",pnls.errmsg())
				pnls.clear()
				lme.clear()
				exit(rc)
			}
		}
		else {
			if (rc=pnls.reinitialize(iter)) {
				errprintf("{p}%s{p_end}\n",pnls.errmsg())
				pnls.clear()
				lme.clear()
				exit(rc)
			}
		}
		if (rc=pnls.run()) {
			errprintf("{p}%s{p_end}\n",pnls.errmsg())
			pnls.clear()
			lme.clear()
			exit(rc)
		}
		conv1 = pnls.converged(`MENL_CONVERGED_MOPT')
		bFE = expr.FE_parameters()

		if (iter == 1) {
			if (rc=lme.initialize(profile,lopts)) {
				errprintf("{p}%s{p_end}\n",lme.errmsg())
				pnls.clear()
				lme.clear()
				exit(rc)
			}
		}
		else {
			if (rc=lme.reinitialize(iter)) {
				errprintf("{p}%s{p_end}\n",lme.errmsg())
				pnls.clear()
				lme.clear()
				return(rc)
			}
		}
		if (rc=lme.run()) {
			errprintf("{p}%s{p_end}\n",lme.errmsg())
			lme.clear()
			pnls.clear()
			exit(rc)
		}
		lf = lme.fun_value()
		dlf = reldif(lf0,lf)
		if (mopts.log & !lopts.log) {
			if (popts.log) {
				printf("\n{txt}Linearization ")
			}
			else {
				printf("{txt}Iteration %g:{col 16} " +
					"linearization ",iter)
			}
			if (lme.reml()) {
				printf("log restricted-likelihood = {res}%g\n",
					lf)
			}
			else {
				printf("log likelihood = {res}%g\n",lf)
			}
			displayas("txt")
		}
		conv2 = lme.converged(`MENL_CONVERGED_MOPT')
		bcov = expr.cov_parameters()

		dfe = mreldif(bFE0,bFE)
		dcov = mreldif(bcov0,bcov)
		if (mopts.debug | mopts.itracelevel>`MENL_TRACE_VALUE') {
			_menl_lbates_trace(expr,pnls,lme,iter,mopts,bFE,bcov,
				(dfe,dcov,dlf),(conv1,conv2))
		}
		if (converged=(conv1 & conv2)) {
			converged = ((dfe<mopts.tol & dcov<mopts.tol) | 
					dlf<mopts.ltol)
		}
		if (mopts.log | lopts.log | popts.log) {
			displayflush()
		}
		if (converged) {
			break
		}
		bFE0 = bFE
		bcov0 = bcov
		lf0 = lf
	}
	/* comp m_bFE & m_s2, use s2 to compute full likelihood		*/
	iter = .
	if (rc=lme.reinitialize(iter)) {
		errprintf("{p}%s{p_end}\n",lme.errmsg())
		lme.clear()
		pnls.clear()
		exit(rc)
	}
	upbFE = `MENL_COMP_BFE'
	if (rc=lme.run(upbFE)) {
		errprintf("{p}%s{p_end}\n",lme.errmsg())
		lme.clear()
		pnls.clear()
		exit(rc)
	}
	lme.set_altconverged(converged) // alternating algorithm converged?

	/* unscale variances by residual variance			*/
	expr.scale_covariances(`MENL_SCALE_MULTIPLY', mopts.debug)

	if (mopts.log & !mopts.debug & !mopts.nostderr) {
		printf("\n{txt}Computing standard errors:\n")
		displayflush()
	}
	lopts.nostderr = mopts.nostderr
	/* clears pnls and lme						*/
	_menl_lbates_final(expr,lme,pnls,lopts)

	st_numscalar("r(converged)",converged)
	st_numscalar("r(reldif_cov)",dcov)
	st_numscalar("r(reldif_FE)",dfe)
	st_numscalar("r(ic)",iter)
}

void _menl_lbates_final(class __menl_expr scalar expr,
		class __menl_lme scalar lme, 
		class __menl_pnls scalar pnls,
		struct _menl_mopts scalar lopts)
{
	real scalar profile, rc, rank, kFEeq, keq
	real scalar metric
	real rowvector b1, b2
	real vector trans0
	real matrix V0, V1, V2, J
	real matrix eqs
	string matrix stripe, stripe1, stripe2
	class __stmatrix scalar b, V, trans

	pragma unset J
	pragma unset trans0

	profile = `MENL_FALSE' 	// no profile likelihood
	lopts.maxiter = 0	// only evaluate likelihood
	if (lopts.debug) {
		lopts.itracelevel = `MENL_TRACE_VALUE'
		lopts.log = `MENL_TRUE'
	}
	else {
		lopts.itracelevel = `MENL_TRACE_NONE'
		lopts.log = `MENL_FALSE'
	}
	if (rc=lme.initialize(profile,lopts)) {
		errprintf("{p}%s{p_end}\n",lme.errmsg())
		pnls.clear()
		lme.clear()
		exit(rc)
	}
	if (!lopts.nostderr) {
		if (rc=lme.run()) {
			errprintf("{p}%s{p_end}\n",lme.errmsg())
			pnls.clear()
			lme.clear()
			exit(rc)
		}
	}
	b2 = lme.parameters()
	if (lopts.nostderr) {
		V2 = J(cols(b2),cols(b2),0)
	}
	else {
		V2 = lme.VCE()
	}
	stripe2 = lme.stripe()

	kFEeq = pnls.kFEb()
	if (kFEeq) {
		b1 = pnls.parameters()
		V1 = pnls.VCE()
		stripe1 = pnls.stripe()

		(void)b.set_matrix((b1,b2))
		(void)b.set_colstripe((stripe1\stripe2))

		(void)V.set_matrix(blockdiag(V1,V2))
		stripe = (stripe1\stripe2)
		(void)V.set_stripe(stripe)
	}
	else {
		(void)b.set_matrix(b2)
		(void)b.set_colstripe(stripe2)

		(void)V.set_matrix(V2)
		(void)V.set_stripe(stripe2)
		stripe = stripe2
	}

	eqs = panelsetup(stripe,1)
	keq = rows(eqs)
	rank = rank(V.m())

	b.st_matrix("r(b)")
	V.st_matrix("r(V)")
	st_numscalar("r(ll)",lme.fun_value())
	st_numscalar("r(rank)",rank)
	st_numscalar("r(missing)",pnls.missing_count())
	st_numscalar("r(keq)",keq)

	/* variance/covariance metric					*/
	metric = `SUBEXPR_METRIC_VAR'
	if (lopts.metric == "variances") {
		metric = metric + `SUBEXPR_METRIC_RESID'
	}
	b = expr.cov_stparameters(metric,J,trans0)
	stripe = b.colstripe()

	V0 = J'V2*J
	(void)V.set_matrix(V0)
	(void)V.set_stripe(stripe)
	(void)trans.set_matrix(trans0)
	(void)trans.set_colstripe(stripe)
	(void)trans.set_rowstripe(("","var"))

	(void)b.set_rowstripe(("","var"))
	b.st_matrix("r(b_var)")
	V.st_matrix("r(V_var)")
	trans.st_matrix("r(trans_var)")

	/* standard deviation/correlation metric			*/
	metric = `SUBEXPR_METRIC_SD'
	if (lopts.metric == "variances") {
		metric = metric + `SUBEXPR_METRIC_RESID'
	}
	b = expr.cov_stparameters(metric,J,trans0)
	stripe = b.colstripe()

	V0 = J'V2*J
	(void)V.set_matrix(V0)
	(void)V.set_stripe(stripe)
	(void)trans.set_matrix(trans0)
	(void)trans.set_colstripe(stripe)
	(void)trans.set_rowstripe(("","stdev"))

	(void)b.set_rowstripe(("","stdev"))

	b.st_matrix("r(b_sd)")
	V.st_matrix("r(V_sd)")
	trans.st_matrix("r(trans_sd)")

	lme.clear()
	pnls.clear()
}

real scalar _menl_coefficient_index(string vector stripe, string scalar cf0)
{
	real scalar found, k, kc
	real colvector io
	string scalar op, cf
	string rowvector toks
	transmorphic t

	kc = length(stripe)
	cf = cf0
	found = any(io=strmatch(stripe,cf))
	if (!found) {
		t = tokeninit("",".")
		tokenset(t,cf)
		toks = tokengetall(t)
		if (length(toks) == 3) {
			op = toks[1]
			k = ustrlen(op)
			if (k > 1) {
				if (usubstr(op,k,1) == "o") {
					/* omitted			*/
					toks[1] = usubstr(op,1,--k)
					cf = invtokens(toks,"")
				}
				else if (op == "o") {
					cf = toks[3]
				}
				found = any(io=strmatch(stripe,cf))
			}
		}
	}
	if (!found) {
		return(0)
	}
	return(select(1::kc,io)[1])
}

real scalar _menl_FE_constraints(struct _menl_constraints scalar cns, 
		string matrix festripe, struct _menl_constraints scalar FEcns,
		|string scalar errmsg)
{
	real scalar i, kc, kf, rc
	real colvector j, mr, c
	real rowvector a, mc
	real matrix C, T
	string vector fs, cs
	string matrix cstripe

	if (!cns.C.cols()) {
		return(0)
	}
	cstripe = cns.C.colstripe()
	cs = cstripe[.,1]:+":":+cstripe[.,2]
	fs = festripe[.,1]:+":":+festripe[.,2]

	kf = rows(festripe)
	kc = rows(cstripe)
	j = J(1,kf,0)
	/* should be sequential						*/
	for (i=1; i<=kf; i++) {
		j[i] = _menl_coefficient_index(cs,fs[i])
		if (!j[i]) {
			errmsg = sprintf("fixed effect {bf:%s} not found " +
			 "in coefficient vector with names {bf:%s}",fs[i],
			 invtokens(cs[|1\kc-1|]',", "))

			return(503)
		}
	}
	c = (cns.C.m())[.,kc]
	C = (cns.C.m())[.,j]
	T = (cns.T.m())[j',.]
	a = (cns.a.m())[j]

	mr = rowmax(C)
	if (!all(mr)) {
		j = select(1..rows(C),mr)
		C = C[j,.]
		c = c[j]
	}
	C = (C,c)
	if (rc=FEcns.C.set_matrix(C)) {
		return(rc)
	}
	if (rc=FEcns.C.set_colstripe((festripe\cstripe[kc,]))) {
		return(rc)
	}

	mc = colmax(T)
	if (!all(mc)) {
		j = select(1..cols(T),mc)
		T = T[.,j']
	}
	if (rc=FEcns.T.set_matrix(T)) {
		return(rc)
	}
	if (rc=FEcns.T.set_rowstripe(festripe)) {
		return(rc)
	}

	(void)FEcns.a.set_matrix(a)
	(void)FEcns.a.set_colstripe(festripe)

	return(0)
}

void _menl_initial_est(class __menl_expr scalar expr, string scalar sCc,
		real scalar fixed, string scalar smopts, real scalar title,
		|string scalar touse2)
{
	real scalar i, j, k, n, kh, klv, ih, rc, hascns, dFE, iswitch
	real scalar iter, ldet, lf, lf0, s2, s, rank, isetRE, evtype
	real scalar ectype, todo, reml, kfe, eq_LC, selection
	real vector b, bFE, bFE0, bFE1, ldetd
	real colvector r, y, sel
	real matrix X, R, B, V, pinfo
	string scalar path, seed, depvar
	string vector lvs
	string matrix paths, FEstripe
	pointer (real matrix) vector Z, bRE, delta, vhinfo
	struct _menl_mopts scalar mopts, nopts
	struct _menl_constraints scalar cns, FEcns
	pointer (struct _lvhinfo) scalar hinfo
	pointer (class __lvhierarchy) scalar hier
	pointer (class __ecovmatrix) scalar var
	pointer (class __pathcovmatrix) vector pcovs
	struct _menl_hier_decomp vector vD
	class __stmatrix scalar sbFE
	class __menl_gnls scalar nls

	pragma unset r
	pragma unset X
	pragma unset ldet
	pragma unset s2
	pragma unset bRE
	pragma unset vD
	pragma unset bFE1
	pragma unset R
	pragma unset V
	pragma unset rank
	_menl_constraint_matrix(sCc,cns)

	_menl_parse_mopts(smopts, mopts,`MOPTS_DEFAULT_EM')
	/* # iterations in NLS for fixed effects			*/
	nopts = mopts
	nopts.maxiter = 5
	nopts.ltype = "mle"
	
	hier = expr.hierarchy()
	hinfo = hier->current_hinfo()
	/* lowest panels, could be a group variable or lowest RE level	*/
	pinfo = hier->current_panel_info()
	if (hinfo == NULL) {
		kh = 0				// no random effects
	}
	else {
		kh = hinfo->kpath
		vhinfo = hinfo->hinfo		// vector of panel matrices

		Z = J(1,kh,NULL)

		paths = hier->paths()
		/* ensure all RE coefficients to zero			*/
		for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
			lvs = tokens(paths[i,`MENL_HIER_LV_NAMES'])
			klv = length(lvs)
			for (j=1; j<=klv; j++) {
				b = expr.RE_parameters(lvs[j])
				k = length(b)
				b = J(1,k,0)
				(void)expr._set_RE_parameters(b,lvs[j])
			}
		}
		hinfo = NULL
	}
	hier = NULL
	sbFE = expr.FE_stparameters()
	hascns = 0
	reml = (mopts.ltype=="reml")
	if (kfe=sbFE.cols()) {
		FEstripe = sbFE.colstripe()
		if (!_menl_FE_constraints(cns,FEstripe,FEcns)) {
			hascns = (FEcns.T.rows()==sbFE.cols())
		}
		bFE = sbFE.m()
	}
	else if (reml) {
		errprintf("{p}option {bf:reml} not allowed; no fixed effects " +
			"in the model{p_end}")
		exit(498)
	}
	else {
		bFE = J(1,0,0)
		FEstripe = J(0,2,"")
	}
	if (title)  {
		printf("{txt}Obtaining starting values%s:\n",(kh?" by EM":""))
	}
	depvar = expr.depvars()[1]
	s2 = .
	selection = (ustrlen(touse2)>0)
	sel = J(0,1,0)
	if (!fixed & kfe) {
		nls.set_subexpr(expr,touse2)
		
		/* initial estimates for fixed effects via nonlinear 
		 *  least squares					*/
		seed = rseed()
		rseed(21131351)	// in case nls random initialization
	       	if (!(rc=nls.initialize(`MENL_INITIAL_NLS',FEcns,nopts))) {
        		rc = nls.run()
		}
		rseed(seed)
		if (rc) {
       	        	errprintf("{p}%s{p_end}\n",nls.errmsg())
			nls.clear()
	               	exit(rc)
        	}
		if (mopts.log) {
			printf("\n")
		}
		s2 = nls.fun_value()
		n = nls.n()
		if (selection) {
			sel = nls.selection()
		}
	}
	else {
		if (selection) {
			sel = st_data(.,touse2,expr.touse(depvar))
			k = sum(st_data(.,expr.touse(depvar)))
			sel = J(k,1,1):&sel
		}
		if (mopts.log) {
			printf("\n")
		}
	}
 	if (kfe) {
		bFE = expr.FE_parameters()
		if (mopts.debug) {
			sbFE = expr.FE_stparameters()
			sbFE.display("NLS fixed effects")
		}
	}
	var = expr.res_covariance()
	evtype = var->vtype()
	ectype = var->ctype()
	if (!kh) {
		if (missing(s2)) {
			if (rc=expr._eval_equation(r,depvar)) {
				errprintf("{p}%s{p_end}\n",expr.errmsg())
				var = NULL
				exit(rc)
			}
			y = st_data(.,depvar,expr.touse(depvar))
			if (selection) {
				r = select(r,sel)
				y = select(y,sel)
			}
			n = length(r)
			r = y-r
			s2 = r'r
		}
		s2 = log(s2/(n-length(bFE)))/2
		var->set_lnsigma(s2)
		if (!selection & (evtype!=var->HOMOSKEDASTIC | 
			ectype!=var->INDEPENDENT)) {
			if (evtype != var->HOMOSKEDASTIC) {
				_menl_EM_update_residual_var(expr)
			}
			if (ectype != var->INDEPENDENT) {
				_menl_EM_update_residual_cor(expr,pinfo)
			}
		}
		var = NULL

		return
	}
	y = st_data(.,depvar,expr.touse(depvar))
	r = y
	if ((eq_LC=expr.is_linear_equation(depvar))) {
		rc = _menl_modelmatrix(expr,r,X,Z)
	}
	else if (hascns) {
		rc = _menl_linearize(expr,r,X,Z,FEcns.T.m(),FEcns.a.m())
	}
	else {
		rc = _menl_linearize(expr,r,X,Z)
	}
	if (rc) {
		if (rc == 480) {
			if (mopts.log) {
				printf("{txt}{p 0 6 2}note: %s{p_end}\n",
					expr.errmsg())
			}
			rc = 0
		}
		else {
			errprintf("{p}%s{p_end}\n",expr.errmsg())
			goto Clear
		}
	}
	_menl_initial_var_est(expr,Z,mopts.debug)
	pcovs = expr.path_covariances()		// covariances by path
	delta = J(1,kh,NULL)
	ldetd = J(1,kh,0)
	for (i=1; i<=kh; i++) {
		B = pcovs[i]->precision_factor(ldet)
		ldetd[i] = ldet
		delta[i] = &J(1,1,B)
	}
	n = length(r)
	s = 1
	lf0 = mindouble()
	/* # iterations in NLS						*/
	nopts.maxiter = 2
	bFE0 = J(1,cols(bFE),0)
	dFE = 1
	/* use NLS for fixed effects for first iswitch iterations	*/
	iswitch = 2
	/* leave RE at zero for first isetRE iterations			*/
	isetRE = 5
	todo = `MENL_COMP_BRE'
	iter = 0
	while (++iter<=mopts.maxiter) {
		ldet = 0
		/* use the profile likelihood evaluator to perform
		 *  orthogonal decomposition of X, Z, and delta
		 *  returned in data structure vD
		 *  also computes residual variance, fixed and random
		 *   effects 						*/
		lf = _menl_decompose_hier(todo,vhinfo,Z,X,r,delta,ldetd,
				rank,bFE1,bRE,vD,sel)

		lf = lf + _menl_profile_lf_update(vD,reml,n,rank,s2)
		if (mopts.debug) {
			printf("\n\niter = %g lf = %g s2 = %g rank = %g\n",
				iter,lf,s2,rank)
			printf("\nFE (NLS\profile)\n")
			(bFE\bFE1\bFE0)
		}
		if (missing(lf)) {
			errprintf(sprintf("{p}EM likelihood criterion is " +
				"missing on iteration %g; try specifying " +
				"initial estimates using the {bf:initial()} " +
				"option{p_end}",iter))
			exit(1400)
		}
		s = sqrt(s2)
		var->set_lnsigma(log(s))
		/* keep RE = 0 while iter < isetRE 			*/
		_menl_EM_update_delta(expr, vD, delta, ldetd, s, bRE,
				(iter>=isetRE), reml, mopts.debug)

		if (mopts.log) {
			/* ldet is log det of the residual covariance	*/
			if (reml) {
				lf = lf -  (n-rank)*log(2*pi())/2 - ldet
			}
			else {
				lf = lf - n*log(2*pi())/2 - ldet
			}
			printf("{txt}EM iteration %g: likelihood " +
				"criterion = {res}%g\n", iter,lf)
			displayflush()
		}
		if (reldif(lf,lf0) < mopts.ltol) {
			break
		}
		if (iter >= mopts.maxiter) {
			break
		}
		if (kfe & !fixed) { 
			/* fixed effects 				*/
			if (iter >= iswitch) {
				dFE = mreldif(bFE1,bFE0)
				if (dFE > 0) { //0.01) {
					(void)expr._set_FE_parameters(bFE1)
				}
				bFE0 = bFE1
			}
			else {
				dFE = mreldif(bFE,bFE0)
				bFE0 = bFE
				nopts.log = `MENL_FALSE'
				nopts.itracelevel = `MENL_TRACE_NONE'
	       			if (rc=nls.initialize(`MENL_INITIAL_NLS',FEcns,
					nopts)) {
       			       		errprintf("{p}%s{p_end}\n",nls.errmsg())
					goto Clear
			       	}
       				if (rc=nls.run()) {
               				errprintf("{p}%s{p_end}\n",nls.errmsg())
					goto Clear
		        	}
				bFE0 = bFE
				bFE = expr.FE_parameters()
			}
		}
		/* new FE estimates, re-linearize		*/
		r = y
		if (!eq_LC) {
			if (hascns) {
				rc = _menl_linearize(expr,r,X,Z,FEcns.T.m(),
					FEcns.a.m())
			}
			else {
				rc = _menl_linearize(expr,r,X,Z)
			}
		}
		if (rc) {
			if (rc == 480) {
				if (mopts.log) {
					printf("{txt}{p 0 6 2}note: %s" +
						"{p_end}\n",expr.errmsg())
				}
				rc = 0
			}
			else {
				errprintf("{p}%s{p_end}\n",expr.errmsg())
				goto Clear
			}
		}
		lf0 = lf
	} // end iter loop
	if (!selection & (evtype!=var->HOMOSKEDASTIC | 
		ectype!=var->INDEPENDENT)) {
		if (iter >= isetRE) {			
			if (0 & mopts.log) {
				printf("{txt}Updating residual covariance " +
					"parameters\n")
			}
			if (evtype != var->HOMOSKEDASTIC) {
				_menl_EM_update_residual_var(expr)
			}
			if (ectype != var->INDEPENDENT) {
				_menl_EM_update_residual_cor(expr,pinfo)
			}
			_menl_EM_resid_scale(expr,pinfo,r,X,Z,ldet)
		}
	}
	if (mopts.maxiter == 0) {
		lf = _menl_decompose_hier(todo,vhinfo,Z,X,r,delta,ldetd,
				rank,bFE1,bRE,vD,sel)
		lf = lf + _menl_profile_lf_update(vD,reml,n,rank,s2)
	}
	s = log(s2)/2
	var->set_lnsigma(s)
	if (mopts.debug) {
		printf("s2 = %g\n",s2)
	}
	for (ih=1; ih<=kh; ih++) {
		R = *delta[ih]
		if (`MENL_EM_DELTA_TRIANGULAR') {
			V = I(rows(R))
			k = _solvelower(R,V)
			V = s2:*(V*V')
		}
		else {
			V = s2*invsym(R'R)
		}
		/* convert unstructured covariance to use specified	*/
		_menl_cov2parameters(*pcovs[ih],V)
		path = paths[ih,`MENL_HIER_PATH']
		if (mopts.debug) {
			pcovs[ih]->display(path)
		}
	}
	Clear:
	nls.clear()
	vhinfo = NULL
	var = NULL
	pcovs = NULL
	kh = length(Z)
	for (ih=1; ih<=kh; ih++) {
		Z[ih] = NULL
	}
	kh = length(bRE)
	for (ih=1; ih<=kh; ih++) {
		bRE[ih] = NULL
	}
	kh = length(delta)
	for (ih=1; ih<=kh; ih++) {
		delta[ih] = NULL
	}
	Z = J(1,0,NULL)
	bRE = J(1,0,NULL)
	delta = J(1,0,NULL)
	_menl_clear_hier_decomp(vD)
	vD = _menl_hier_decomp(0)
	if (rc) {
		exit(rc)
	}
}

void _menl_EM_update_delta(class __menl_expr scalar expr,
		struct _menl_hier_decomp vector vD,
		pointer (real matrix) vector delta, real vector ldetd,
		real scalar s, pointer (real matrix) vector bRE,
		real scalar setRE, real scalar reml, real scalar debug)
{
	real scalar i, j, ih, jh, kh, ip, kp, klv, kr, kc, p0
	real scalar ipc, ipp, reml0
	real vector jp
	real rowvector tau, p
	real colvector s0
	real matrix RE, R1, R, Ri, Rj, Rij, R0, H, U, V
	string scalar path
	string vector lvs
	string matrix paths
	pointer (real matrix) vector vhinfo
	pointer (struct _lvhinfo) scalar hinfo
	pointer (class __lvhierarchy) scalar hier
	struct _menl_Rii vector Rii

	pragma unset s0
	pragma unset R
	pragma unset V

	hier = expr.hierarchy()

	hinfo = hier->current_hinfo()
	vhinfo = hinfo->hinfo		// vector of panel matrices
	paths = hier->paths()
	hier = NULL
	kh =  hinfo->kpath
	Rii = _menl_Rii(kh)
	reml0 = `MENL_FALSE'
	if (reml & vD[1].R[1,1]!=NULL) {
		R0 = *vD[1].R[1,1]
		Ri = I(cols(R0))
		if (rows(R0) < cols(R0)) {
			/* not full rank				*/
			Ri = Ri[|1,1\rows(R0),cols(Ri)|]
		}
		R0 = _menl_solveupper(R0,Ri,vD[1].p[1])
		reml0 = `MENL_TRUE'
	}
	ih = 0
	/* M step of EM algorithm from Bates & Pinheiro (199?) 		*/
	for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
		ih++
		jh = ih+1
		jp = J(1,kh,1)
		path = paths[i,`MENL_HIER_PATH']
		lvs = tokens(paths[i,`MENL_HIER_LV_NAMES'])
		RE = *bRE[ih]
		kp = rows(*vhinfo[ih])
		klv = cols(*bRE[ih])
		p0 = (klv==1) 	// column pivoting; p0 = 0
		Rii[ih].R = J(1,kp,NULL)
		if (setRE) {
			for (j=1; j<=klv; j++) {
				(void)expr._set_RE_parameters(RE[.,j]',lvs[j])
			}
		}
		RE = RE:/s
		for (jp[ih]=1; jp[ih]<=kp; jp[ih]=jp[ih]+1) {
			ip = jp[ih]
			R1 = *vD[jh].R[ip,ih]
			kr = rows(R1)
			kc = cols(R1)
			Ri = I(kc)
			if (kr < kc) {
				/* panel not full rank			*/
				Ri = Ri[|1,1\kr,kc|]
			}
			Ri = _menl_solveupper(R1,Ri,vD[jh].p[ip])
			H = (RE[ip,]\Ri')

			Rii[ih].R[ip] = &J(1,1,Ri)

			/* begin index panel				*/
			ipc = (*vhinfo[ih])[ip,1]
			for (i=1; i<ih; i++) {
				/* end index parent panel		*/
				ipp = (*vhinfo[i])[jp[i],2]
				if (ipc > ipp) {
					/* new parent			*/
					jp[i] = jp[i] + 1
				}
				Rij = *vD[jh].R[ip,i]
				if (kr < kc) {
					/* panel not full rank		*/
					Rij = (Rij\J(kc-kr,cols(Rij),0))
				}
				Rj = Ri*Rij*(*Rii[i].R[jp[i]])
				H = (H\-Rj')
			}
			if (reml0) {
				Rij = *vD[jh].X[ip,1]
				Rj = -Ri*Rij*R0

				H = (H\Rj')
			}

			if (ip > 1) {
				H = (R\H)
			}
			tau = .
			p = J(1,klv,p0)
			_hqrdp(H,tau,R,p)
			if (!p0) {
				p = invorder(p)
				/* columns in order			*/
				R = R[.,p]
			}
		}
		/* multiply by sqrt(kp) not divide as specified in 
		 *  Bates & Pinherio (1998)				*/
		/* invert R or use SVD for symmetric inverse		*/
		if (`MENL_EM_DELTA_TRIANGULAR') {
			H = R
			tau = .
			_hqrd(H,tau,R)	// retriangularize, no pivoting
			U = I(rows(R))
			kr = _solvelower(R',U)
			U = U:*sqrt(kp)		// D = V/s2
			ldetd[ih] = sum(log(abs(diagonal(U))))
		}
		else {
			U = R'R:/kp		// D = V/s2
			_svd(U,s0,V)
			s0 = sqrt(kp:/s0)
			ldetd[ih] = sum(log(s0))
			U = U*diag(s0)*V	// sym = V'diag(s0)*U'
			U = (U+U'):/2		// perfect sym
		}
		delta[ih] = &J(1,1,U)
		if (debug) {
			printf("\npath: %s\n",path)
			printf("\ndelta\n")
			*delta[ih]
			printf("\nlog det = %g\n",ldetd[ih])
		}
		if (missing(U)) {
			errprintf(sprintf("{p}EM precision matrix at level " +
				"%g has missing values; try specifying " +
				"initial estimates using the {bf:initial()} " +
				"option{p_end}",ih))
			exit(1400)
		}
	}
	_menl_clear_Rii(Rii)
	vhinfo = NULL
	hinfo = NULL
}

void _menl_EM_update_residual_var(class __menl_expr scalar expr) 
{
	real scalar iby, evtype, cons, rank, d0, ib, kby
	real vector b
	real rowvector b0
	real colvector r0, f0, r, f, r1, f1, byvar
	real rowvector p
	real matrix E,B,R
	string scalar depvar, pvar
	pointer (class __ecovmatrix) scalar var

	pragma unset rank
	pragma unset p
	pragma unset R
	pragma unset E
	pragma unset B

	var = expr.res_covariance()
	evtype = var->vtype()
	if (evtype!=var->POWER & evtype!=var->CONSTPOWER &
		evtype!=var->EXPONENTIAL) {
		_menl_EM_update_residual_var1(expr)
		var = NULL
		return
	}
	depvar = expr.depvars()[1]
	pvar = var->pvar_name()
	f0 = expr.eval_equation(depvar)
	if (pvar == `MENL_VAR_RESID_FITTED') {
		/* fitted used in _menl_EM_resid_scale()		*/
		var->set_fitted(f0)
	}
	r0 = st_data(.,depvar,expr.touse(depvar))
	r0 = (r0-f0)/var->sigma()
	kby = var->bycount(var->STDDEV)
	if (kby > 1) {
		byvar = var->byvector(var->STDDEV)
	}
	else if (!kby) {
		kby = 1
	}
	b0 = J(1,0,0)
	for (iby=1; iby<=kby; iby++) {
		cons = 1
		ib = 2
		if (kby > 1) {
			r = select(r0,byvar:==iby)
			f = select(f0,byvar:==iby)
		}
		else {
			r = r0
			f = f0
		}
		if (evtype == var->CONSTPOWER) {
			r1 = r
			f1 = f
			b = _lsfitqr(f1,r1,J(0,1,0),cons,rank,E,B,R,p)
			if (rank) {
				d0 = b[1] // log transformed, _cons = exp(d0)
			}
			else {
				d0 = -2.3 // ~log(0.1)
			}
		}
		r = log(abs(r))
		_editmissing(r,0)
		if (pvar != `MENL_VAR_RESID_FITTED') {
			f = var->pvar()
			if (kby > 1) {
				f = select(f,byvar:==iby)
			}
		}
		if (evtype != var->EXPONENTIAL) {
			f = log(abs(f))
		}
		_editmissing(f,0)

		b = _lsfitqr(f,r,J(0,1,0),cons,rank,E,B,R,p)
		if (rank < cols(f)) {
			if (evtype == var->CONSTPOWER) {
				b0 = (b0,1,d0)
			}
			else {
				b0 = (b0,1)
			}
		}
		else if (evtype == var->CONSTPOWER) {
			b0 = (b0,b[ib],d0)
		}
		else {
			b0 = (b0,b[ib])
		}
	}
	(void)var->set_sd_parameters(b0)
	var = NULL
}

void _menl_EM_update_residual_var1(class __menl_expr scalar expr) 
{
	real scalar i, k, evtype, lns
	string scalar depvar
	real colvector indvec, lnrsd, r
	real matrix indtable
	pointer (class __ecovmatrix) scalar var

	var = expr.res_covariance()
	evtype = var->vtype()
	if (evtype != var->HETEROSKEDASTIC) {
		var = NULL
		return
	}
	depvar = expr.depvars()[1]
	r = st_data(.,depvar,expr.touse(depvar))-expr.eval_equation(depvar)

	indvec = var->indvector(var->STDDEV)
	indtable = var->indtable(var->STDDEV)
	k = rows(indtable)
	lnrsd = J(k-1,1,0)
	lns = log(variance(select(r,indvec:==1)))/2
	if (missing(lns)) {
		lns = var->lnsigma0()
	}
	else {
		var->set_lnsigma(lns)
	}
	for (i=1; i<=k-1; i++) {
		lnrsd[i] = variance(select(r,indvec:==i+1))
		if (missing(lnrsd[i])) {
			lnrsd[i] = 0	// makes std.dev ratio = 1
		}
		else if (lnrsd[i]>1e-5) {
			lnrsd[i] = log(lnrsd[i])/2-lns
		}
	}
	(void)var->set_sd_parameters(lnrsd')
}

void _menl_EM_update_residual_cor(class __menl_expr scalar expr,
			real matrix hinfo)
{
	real scalar i, ectype, cons, rank, order, kp, ip, i1, i2
	real scalar kby, iby
	real vector b
	real colvector r0, r, f, byvar
	real rowvector p
	real matrix E, B, R, LR0, LR
	string scalar depvar
	pointer (class __ecovmatrix) scalar var
	pointer (class __ecormatrix) scalar cor

	pragma unset rank
	pragma unset p
	pragma unset R
	pragma unset E
	pragma unset B

	var = expr.res_covariance()
	ectype = var->ctype()
	if (ectype!=var->AUTOREGRESS & ectype!=var->CONTINUOUSAR1 &
		ectype!=var->MOVINGAVERAGE) {
		var = NULL
		return
	}
	cor = var->cor_obj(1)
	order = cor->order()

	depvar = expr.depvars()[1]
	f = expr.eval_equation(depvar)
	if (missing(f)) {
		if (0) {	// debug
			errprintf("{p}function evaluation resulted in " +
				"missing values{p_end}\n")
		}
		_editmissing(f,0)
	}
	r0 = st_data(.,depvar,expr.touse(depvar))
	r0 = r0-f

	kby = var->bycount(var->CORR)
	if (kby > 1) {
		byvar = var->byvector(var->CORR)
	}
	else if (!kby) {
		kby = 1
	}
	LR0 = J(1,order,r0)
	kp = rows(hinfo)
	for (ip=1; ip<=kp; ip++) {
		i1 = hinfo[ip,1]
		i2 = hinfo[ip,2]
		for (i=1; i<=order; i++) {
			if (i1+i <= i2) {
				LR0[|i1+i,i\i2,i|] = r0[|i1\i2-i|]
			}
		}
	}
	cons = 0
	for (iby=1; iby<=kby; iby++) {
		if (kby > 1) {
			LR = select(LR0,byvar:==iby)
			r = select(r0,byvar:==iby)
			cor = var->cor_obj(iby)
		}
		else {
			r = r0
			LR = LR0
		}
		if (ectype == var->MOVINGAVERAGE) {
			b = _lsfitqr(r,LR,J(0,1,0),cons,rank,E,B,R,p)
			if (rows(b) > 1) {
				b = b'
			}
		}
		else {
			b = _lsfitqr(LR,r,J(0,1,0),cons,rank,E,B,R,p)
		}
		if (var->ctransform() == var->NONE) {
			b = tanh(b)
		}
		if (cor->set_parameters(b)) {
			cor->errmsg()
		}
	}
	var = NULL
	cor = NULL
}

void _menl_EM_resid_scale(class __menl_expr scalar expr, real matrix hinfo,
			real colvector r, real matrix X, 
			pointer (real matrix) vector Z, real scalar ldet)
{
	real scalar rc, ip, kp, evtype, ectype, cx, cz, cr
	real scalar i1, i2, ih, kh, scale, ldeti
	real colvector f0
	real matrix R, Zi
	string scalar depvar, pvar
	pointer (class __ecovmatrix) scalar var

	pragma unset ldeti

	var = expr.res_covariance()
	evtype = var->vtype()
	ectype = var->ctype()
	if (evtype!=var->POWER & evtype!=var->CONSTPOWER & 
		evtype!=var->EXPONENTIAL) {
		if (ectype!=var->AUTOREGRESS) {
			var = NULL
			return
		}
	}
	pvar = var->pvar_name()
	if (pvar == `MENL_VAR_RESID_FITTED') {
		depvar = expr.depvars()[1]
		f0 = expr.eval_equation(depvar)
		/* fitted used in _menl_EM_resid_scale()		*/
		var->set_fitted(f0)
	}
	cx = cols(X)
	kp = rows(hinfo)
	kh = length(Z)
	ldet = 0
	scale = `MENL_FALSE'
	for (ip=1; ip<=kp; ip++) {
		if (rc=var->compute_V(hinfo[ip,.],scale)) {
			errprintf("{p}%s{p_end}\n",var->errmsg())
			var = NULL
			exit(rc)
		}
		R = var->scale_matrix(ldeti)
		cr = cols(R)
		ldet = ldet + ldeti
		i1 = hinfo[ip,1]
		i2 = hinfo[ip,2]
		if (cr == 1) {
			/* no correlations				*/
			X[|i1,1\i2,cx|] = R:*X[|i1,1\i2,cx|]
			r[|i1\i2|] = R:*r[|i1\i2|]
		}
		else {
			X[|i1,1\i2,cx|] = R*X[|i1,1\i2,cx|]
			r[|i1\i2|] = R*r[|i1\i2|]
		}
		for (ih=1; ih<=kh; ih++) {
			Zi = panelsubmatrix(*Z[ih],ip,hinfo)
			cz = cols(Zi)
			if (cr == 1) {
				/* no correlations			*/
				Zi = R:*Zi
			}
			else {
				Zi = R*Zi
			}
			(*Z[ih])[|i1,1\i2,cz|] = Zi
		}
	}			
	var = NULL
}

void _menl_initial_var_est(class __menl_expr scalar expr,
			pointer (real matrix) vector Z, real scalar debug)
{
	real scalar i, j, k, klv, m
	real colvector v, io
	real matrix V, Z0, zinfo
	string scalar path
	string vector lvs
	string matrix paths
	pointer (struct _lvhinfo) scalar hinfo
	pointer (class __lvhierarchy) scalar hier
	pointer (class __pathcovmatrix) vector pcovs

	pcovs = expr.path_covariances()		// covariances by path
	hier = expr.hierarchy()
	hinfo = hier->current_hinfo()
	paths = hier->paths()
	hier = NULL

	j = hinfo->kpath+1
	for (i=hinfo->hrange[2]; i>=hinfo->hrange[1]; i--) {
		j--
		path = paths[i,`MENL_HIER_PATH']
		lvs = tokens(paths[i,`MENL_HIER_LV_NAMES'])
		klv = length(lvs)
		Z0 = *Z[j]
		zinfo = *hinfo->hinfo[i]
		m = rows(zinfo)

		v = J(klv,1,0)
		for (k=1; k<=m; k++) {
			Z0 = panelsubmatrix(*Z[j],k,zinfo)
			v = v + colsum(Z0:*Z0)'
		}
		
		v = (0.375^2)*v:/m
		if (any(io=(v:<epsilon(1)))) {
			_replacevalues(v,io,1)
		}
		V = diag(1:/v)

		_menl_cov2parameters(*pcovs[j],V)

		if (debug) {
			pcovs[j]->display(path)
			printf("\nprecision factor\n")
			pcovs[j]->precision_factor()
		}
	}
	hinfo = NULL
	pcovs = NULL
}

void _menl_cov2parameters(class __pathcovmatrix pcov, real matrix V0)
{
	real scalar k, l, kc, kclv, klv
	real colvector v, io, iv
	real matrix V
	string vector clv, lvs
	pointer (class __recovmatrix) vector covs

	covs = pcov.covs()	// covs by LV specification
	kc = length(covs)
	v = diagonal(V0)
	if (any(v:==0)) {
		_editvalue(v,0,1e-4)
		_diag(V0,v)
	}
	lvs = pcov.LVnames()
	klv = length(lvs)

	for (k=1; k<=kc; k++) {
		clv = covs[k]->LVnames()
		kclv = length(clv)
		iv = J(kclv,1,0)
		for (l=1; l<=kclv; l++) {
			io = strmatch(lvs,clv[l])
			iv[l] = select(1..klv,io)[1]
		}
		V = V0[iv,iv']
		if (covs[k]->cov2parameters(V)) {
			errprintf("{p}%s{p_end}\n",covs[k]->errmsg())
		}
	}
	pcov.compute_V()
	covs = NULL
}

real matrix _menl_invert_R(real matrix R,  pointer (real colvector) scalar pp,
			| real scalar rank)
{
	real scalar kr, kc
	real rowvector p
	real matrix Ri

	kr = rows(R)
	kc = cols(R)
	if (kr < kc) {
		/* not full rank					*/
		R = R[|1,1\kr,kr|]
	}
	Ri = I(kr)
	rank = _solveupper(R,Ri)
	if (kr < kc) {
		/* panel not full rank					*/
		Ri = ((Ri,J(kr,kc-kr,0))\J(kc-kr,kc,0))
	}
	if (pp != NULL) {
		p = *pp
		/* column pivoting					*/
		Ri = Ri[p',.]
	}
	return(Ri)
}

/* rank of upper triangular matrix R					*/
real scalar _menl_rank_R(real matrix R)
{
	real scalar n, rank, qm, eps
	real colvector q
	real matrix Q

	/* assumption: R is upper triangular				*/
	if (0) {
		n = rows(R)
		Q = I(n)
		rank = _solveupper(R,Q)
	}
	else {	
		/* quick 						*/
		eps = epsilon(2^10)
		q = abs(diagonal(R))
		qm = max(q)
		rank = sum(q:>qm:*eps)
	}
	return(rank)
}

real matrix _menl_solveupper(real matrix R0, real matrix X0, 
			pointer (real rowvector) scalar pp, |real scalar rank)
{
	real scalar kr, kc, kx
	real rowvector p
	real matrix X, R

	R = R0
	kr = rows(R)
	kc = cols(R)
	if (kr < kc) {
		/* not full rank, R (rank x #LV)
		 *  see_menl_orthog_triang() below			*/
		R = R[|1,1\kr,kr|]
	}
	X = X0
	kx = cols(X)
	rank = _solveupper(R,X,1e2)
	if (kr < kc) {
		/* not full rank					*/
		X = (X\J(kc-kr,kx,0))
	}
	if (pp != NULL) {
		p = *pp
		/* column pivoting					*/
		X = X[p',.]
	}
	return(X)
}

void _menl_clear_Rii(struct _menl_Rii vector Rii)
{
	real scalar i, j, kc, kr

	kc = length(Rii)
	for (i=1; i<=kc; i++) {
		kr = length(Rii[i].R)
		for (j=1; j<=kr; j++) {
			Rii[i].R[j] = NULL
		}
		Rii[i].R = J(1,0,NULL)
	}
	Rii = _menl_Rii(0)
}

void _menl_clear_hier_decomp(struct _menl_hier_decomp vector vD)
{
	real scalar i, j, k, kd, kr, kc, kx

	kd = length(vD)
	for (i=1; i<=kd; i++) {
		kr = rows(vD[i].R)
		kc = cols(vD[i].R)
		kx = cols(vD[i].X)
		for (j=1; j<=kr; j++) {
			for (k=1; k<=kc; k++) {
				vD[i].R[j,k] = NULL
			}
			vD[i].p[j] = NULL
			vD[i].c[j] = NULL
			if (kx) vD[i].X[j] = NULL
		}
	}
	vD = _menl_hier_decomp(0)
}

real scalar _menl_profile_lf_update(struct _menl_hier_decomp vector vD,
		real scalar reml, real scalar n, real scalar rank,
		real scalar s2)

{
	real scalar r, lf
	real colvector c1
	real matrix R

	if (rows(vD[1].c) == 1) {
		/* fatal situation					*/
		c1 = J(1,1,0)
	}
	else {
		c1 = *vD[1].c[2]
	}
	r = c1'c1
	if (reml) {
		s2 = r/(n-rank)
		lf = (n-rank)*(log(n-rank)-1-log(r))/2
		if (rank) {
			R = *vD[1].R[1,1]
			lf = lf - sum(log(abs(diagonal(R)[|1\rank|])))
		}
	}
	else {
		s2 = r/n
		lf = n*(log(n)-1-log(r))/2
	}
	return(lf)
}

real scalar _menl_decompose_hier(real scalar todo,
			pointer (real matrix) vector vhinfo, 
			pointer (real matrix) vector Z, real matrix X,
			real colvector w, pointer (real matrix) vector delta,
			real vector ldetdel, real scalar rank, 
			real rowvector bFE, pointer (real matrix) vector bRE,
			struct _menl_hier_decomp vector vD,
			|real colvector select)
{
	real scalar i, j, kh, kh1, klv, kx, j1, ih, ih1, jh
	real scalar ip, ipp, ipc, ldeti, lf, p0, trans, selection
	real vector jp
	real colvector c, c1, b, sel
	real rowvector tau, p, m
	real matrix H, R, Xi, wi
	pointer (real matrix) vector Zi

	pragma unset R

	/* selection vector for recursive models			*/
	selection = (rows(select)>0)
	lf = 0
	kx = cols(X)	// kx can be 0
	kh = length(vhinfo)
	kh1 = kh - 1

	m = J(1,kh,0)
	j1 = kh+1
	vD = _menl_hier_decomp(j1)
	for (j=kh; j>=1; j--) {
		m[j] = rows(*vhinfo[j])
		lf = lf + m[j]*ldetdel[j]

		vD[j].R = J(m[j],j-1,NULL)
		vD[j].p = J(m[j],1,NULL)
		vD[j].c = J(m[j],1,NULL)
		if (kx) {
			vD[j].X = J(m[j],1,NULL)
		}
		if (missing(*delta[j])) {
			errprintf("{p}missing values found in precision " +
				"matrix at level %g; computations cannot " +
				"proceed{p_end}\n",kh-j+2)
			exit(498)
		}
	}
	vD[j1].R = J(m[kh],kh,NULL)
	vD[j1].p = J(m[kh],1,NULL)
	vD[j1].c = J(m[kh],1,NULL)
	if (kx) {
		vD[j1].X = J(m[kh],1,NULL)
	}

	Zi = J(1,kh1,NULL)
	for (ip=1; ip<=m[kh]; ip++) {
		wi = panelsubmatrix(w,ip,*vhinfo[kh])
		if (selection) {
			sel = panelsubmatrix(select,ip,*vhinfo[kh])
			wi = select(wi,sel)
			if (!rows(wi)) {
				/* programmer error			*/
				errprintf("{p}panel %g has no observations " +
					"for the likelihood computation; " +
					"cannot proceed{p_end}",ip)
				exit(498)
			}
		}
		if (kx) {
			Xi = panelsubmatrix(X,ip,*vhinfo[kh])
			if (selection) {
				Xi = select(Xi,sel)
			}
		}
		for (j=1; j<=kh1; j++) {
			Zi[j] = &panelsubmatrix(*Z[j],ip,*vhinfo[kh])
			if (selection) {
				Zi[j] = &select(*Zi[j],sel)
			}
		}
		H = panelsubmatrix(*Z[kh],ip,*vhinfo[kh])
		if (selection) {
			H = select(H,sel)
		}
		ldeti = _menl_orthog_triang(kh,ip,H,*delta[kh],wi,Xi,Zi,vD)
		lf = lf - ldeti
	}
	for (j=1; j<=kh1; j++) {
		Zi[j] = NULL
	}
	Zi = J(1,kh1,NULL)
	for (ih=kh-1; ih>=1; ih--) {
		ldeti = _menl_decompose_level(ih,vhinfo,vD,*delta[ih])
		lf = lf - ldeti
	}
	trans = `MENL_TRUE'	// transpose
	rank = 0
	if (kx) {
		H = J(0,kx,0)
		c = J(0,1,0)
		/* accumulate panel data				*/
		for (ip=1; ip<=m[1]; ip++) {
			if (vD[1].X[ip,1] != NULL) {
				H = (H\(*vD[1].X[ip,1]))
				c = (c\(*vD[1].c[ip]))
			}
		}
		p0 = (kx <= 1) // column pivoting
		tau = J(1,kx,0)
		p = J(1,kx,p0)
		_hqrdp(H,tau,R,p)
		c = hqrdmultq(H,tau,c,trans)
		rank = _menl_rank_R(R)
		c1 = c[|rank+1\rows(c)|]
	}
	else {
		c1 = J(0,1,0)
		for (ip=1; ip<=m[1]; ip++) {
			if (vD[1].c[ip] != NULL) {
				c1 = (c1\(*vD[1].c[ip]))
			}
		}
	}
	vD[1].R = J(1,1,NULL)
	vD[1].p = J(1,1,NULL)
	vD[1].c = J(2,1,NULL)
	vD[1].c[2] = &J(1,1,c1)		// s2 = c1'c1/n
	if (!rank) {
		if (kx) {
			/* set zero matrix for REML 
			 * computations				*/
			vD[1].R[1,1] = &J(kx,kx,0)
			vD[1].c[1] = &J(0,1,0)
		}
	}
	else if (!p0) {
		if (rank < kx) {
			R = R[|1,1\rank,kx|]
		}
		c = c[|1\rank|]

		vD[1].R[1,1] = &J(1,1,R)
		p = invorder(p)
		vD[1].p = &J(1,1,p)
		vD[1].c[1] = &J(1,1,c)
	}
	else {
		c = c[|1\kx|]
		vD[1].R[1,1] = &J(1,1,R)
		vD[1].c[1] = &J(1,1,c)
	}
	if (todo==`MENL_COMP_BFE' | todo==`MENL_COMP_BRE') {
		/* flag to compute FE parameters and residual variance	*/
		if (!rank) {
			bFE = J(1,kx,0)
		}
		else if (!p0) {
			bFE = _menl_solveupper(R,c,&p)'
		}
		else {
			bFE = _menl_solveupper(R,c,NULL)'
		}
	}
	if (todo != `MENL_COMP_BRE') {
		return(lf)
	}
	bRE = J(1,kh,NULL)
	for (ih=1; ih<=kh; ih++) {
		jp = J(1,kh,1)
		jh = ih + 1	// index 1 for level 0, fixed effects
		ih1 = ih - 1
		klv = cols(*vD[jh].R[1,ih])
		bRE[ih] = &J(m[ih],klv,0)
		for (jp[ih]=1; jp[ih]<=m[ih]; jp[ih]=jp[ih]+1) {
			ip = jp[ih]
			if (kx) {
				b = *vD[jh].c[ip] - (*vD[jh].X[ip])*bFE'
			}
			else {
				b = *vD[jh].c[ip]
			}
			/* begin index panel				*/
			ipc = (*vhinfo[ih])[ip,1]
			for (i=1; i<=ih1; i++) {
				/* end index parent panel		*/
				ipp = (*vhinfo[i])[jp[i],2]
				if (ipc > ipp) {
					/* new parent			*/
					jp[i] = jp[i] + 1
				}
				/* adjust child RE for parent panel	*/
				b = b - (*vD[jh].R[ip,i])*(*bRE[i])[jp[i],.]'
			}
			b = _menl_solveupper(*vD[jh].R[ip,ih],b,vD[jh].p[ip])

			(*bRE[ih])[ip,.] = b'
		}
	}
	return(lf)
}

real scalar _menl_decompose_level(real scalar ih, 
		pointer (real matrix) vector vhinfo,
		struct _menl_hier_decomp vector vD, real matrix delta)
{
	real scalar i, j, ip, ipp, ipc, jh, ih1, inext, icur
	real scalar kx, ldet, ldeti, q, q1, m
	real matrix H, X, c
	pointer (real matrix) vector Z

	ldet = 0
	jh = ih + 1	// 1 based indexing, map 0 to 1
	ih1 = ih - 1	// can be zero, fixed effects level
	q = cols(*vD[jh].R[1,ih])
	kx = 0
	if (length(vD[jh].X)) {
		kx = cols(*vD[jh].X[1])
		X = J(0,kx,0)
	}
	/* Z[ih] not used, _menl_Qtw_X_Z() requires it			*/
	Z = J(1,ih,NULL)
	for (i=1; i<=ih1; i++) {
		Z[i] = &J(0,cols(*vD[jh].R[1,i]),0)
	}
	H = J(0,q,0)
	c = J(0,1,0)
	ipc = 1	
	ipp = 1		// parent panel index
	inext = (*vhinfo[ih])[ipp,2]	// parent panel index
	m = rows(*vhinfo[ih+1])		// # panels in child

	for (ip=1; ip<=m; ip++) {
		/* accumulate parent data 				*/
		H = (H\(*vD[jh].R[ip,ih]))
		c = (c\(*vD[jh].c[ip]))
		if (kx) {
			X = (X\(*vD[jh].X[ip]))
		}
		for (i=1; i<=ih1; i++) {
			Z[i] = &J(1,1,(*Z[i]\*vD[jh].R[ip,i]))
		}
		icur = (*vhinfo[ih+1])[ip,2]
	
		if (icur < inext) {
			continue
		}
		/* done accumulating parent panel data			*/
		ldeti = _menl_orthog_triang(ih,ipp,H,delta,c,X,Z,vD)
		ldet = ldet + ldeti

		/* do not erase stored decomposition			*/
		if (ipc <= ipp) {
			ipc = ipp + 1
		}
		/* free memory						*/
		for (i=ipc; i<=ip; i++) {
			for (j=1; j<=ih; j++) {
				vD[jh].R[i,j] = NULL
			}
			vD[jh].p[i] = NULL
			vD[jh].c[i] = NULL
			if (kx) {
				vD[jh].X[i] = NULL
			}
		}
		ipc = ip + 1
		if (ipc <= m) {
			/* reset					*/
			for (i=ih1; i>=1; i--) {
				q1 = cols(*vD[jh].R[ipc,i])
				Z[i] = &J(0,q1,0)
			}
			H = J(0,q,0)
			c = J(0,1,0)
			X = J(0,kx,0)

			ipp++
			inext = (*vhinfo[ih])[ipp,2]
		}
	}
	for (i=1; i<=ih; i++) {
		Z[i] = NULL
	}
	Z = J(1,0,NULL)

	return(ldet)
}

real scalar _menl_orthog_triang(real scalar ih, real scalar ip,
		real matrix H, real matrix delta, real colvector c,
		real matrix X, pointer (real matrix) vector Z,
		struct _menl_hier_decomp vector vD)
{
	real scalar i, ldet, rank, q, q1, np, p0, jh, ih1
	real scalar jh1, r1, kx
	real rowvector p, tau
	real matrix R

	pragma unset R

	ldet = .
	kx = cols(X)
	jh = ih + 1	// zero based indexing on vD[]
	jh1 = ih
	ih1 = ih - 1	// can be zero, fixed effects level
	q = cols(H)
	p0 = (q <= 1) 	// column pivoting if q > 1
	H = (H\delta)
	np = rows(H)

	tau = J(1,q,0)
	p = J(1,q,p0)
	_hqrdp(H,tau,R,p)

	_menl_Qtw_X_Z(H,tau,q,ih,c,X,Z)
	rank = _menl_rank_R(R)
	if (rank) {
		ldet = sum(log(abs(diagonal(R)[|1\rank|])))
		if (rank < q) {
			/* retain column dimension = # RE, trim latter	*/
			R = R[|1,1\rank,q|]
		}
		if (p0) {
			vD[jh].p[ip] = NULL
		}
		else {
			/* save the pivot vector, for solving step	*/
			p = invorder(p)
			vD[jh].p[ip] = &J(1,1,p)
		}
		vD[jh].R[ip,ih] = &J(1,1,R)
		for (i=1; i<=ih1; i++) {
			q1 = cols(*Z[i])
			vD[jh].R[ip,i] = &J(1,1,(*Z[i])[|1,1\rank,q1|])
		}
		vD[jh].c[ip] = &J(1,1,c[|1\rank|])
		if (kx) {
			vD[jh].X[ip] = &J(1,1,X[|1,1\rank,kx|])
		}
	}
	if (rank < np) {
		/* parent						*/
		r1 = rank+1
		vD[jh1].c[ip] = &J(1,1,c[|r1\np|])
		for (i=1; i<=ih1; i++) {
			q1 = cols(*Z[i])
			vD[jh1].R[ip,i] = &J(1,1,(*Z[i])[|r1,1\np,q1|])
		}
		if (kx) {
			vD[jh1].X[ip] = &J(1,1,X[|r1,1\np,kx|])
		}
	}
	return(ldet)
}

void _menl_Qtw_X_Z(real matrix H, real rowvector tau, real scalar q,
			real scalar ih, real colvector w, real matrix X,
			|pointer(real matrix) vector Z)
{
	real scalar k, kx, kz, trans

	trans = `MENL_TRUE'	// transpose
	if (kx=cols(X)) {
		if (q) {
			X = (X\J(q,kx,0))
		}
		X = hqrdmultq(H,tau,X,trans)
	}
	if (q) {
		w = (w\J(q,1,0))
	}
	w = hqrdmultq(H,tau,w,trans)
	if (args() < 7) {
		return
	}

	for (k=1; k<=ih-1; k++) {
		kz = cols(*Z[k])
		if (q) {
			Z[k] = &(*Z[k]\J(q,kz,0))
		}
		Z[k] = &hqrdmultq(H,tau,*Z[k],trans)
	}
}

end
exit

References:

Bates, D.M. and J.C. Pinheiro (1998) Computational Methods for Multilevel
	Modeling.  In Technical Memorandum BL0112140-980226-01TM. Murray Hill,
	NJ: Bell Labs, Lucent Technologies.

Pinheiro J.C. and D.M. Bates (1995) Mixed-Effects Models in S and S-Plus.
	Springer.
