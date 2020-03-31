*! version 2.1.0  11apr2018

mata:
mata set matastrict on

struct _mlexp_info {
	real scalar vn
	real scalar 	nobs
	string scalar	lfvar			// holds obs. level log-L var.
	string scalar	tousevar
	string scalar	parmvecname		// name of Stata param vector
						// used in subst. expr. v. 13-
	string vector   eqvars			// LF variables v. 14+
	string scalar	expression		// Holds expression for log-L
						// that can be evaluated by
						// -replace-
	string vector	paramnames		// names of params eq_var
	pointer(string vector) vector indepvars	// indepvars for each parameter
	real vector 	cons			// parameter constant flag
	real scalar	nparam
						
	string scalar	vcetype
	string scalar	clustvar
	
	string scalar	weightvar
	string scalar   weighttype

	real scalar	hasderiv		// 1 = analyt. derivs; 0 o.w.
	string vector	derivvar		// varnames to store derivs
	string vector	derivexpr		// expressions to evaluate
						// derivatives
}

struct _mlexp_info scalar _mlexp_setup(string scalar parmvec, 
	string scalar params, string scalar eqnames, string scalar xbvlist,
	string rowvector vlist, real rowvector cons, string scalar lfvar,
	string scalar touse, string scalar expr, string scalar wtype, 
	string scalar wvar, string scalar vce, string scalar cluster,
	real scalar hasderiv, string scalar dvlist, string rowvector delist,
	real scalar ver)
{
	real scalar i, k, i1
	struct _mlexp_info scalar M

	M.vn = ver
	M.parmvecname = parmvec
	if (M.vn < 14.0) {
		k = cols(st_matrix(M.parmvecname))
		M.nparam = k
		M.paramnames = tokens(params)
	}
	else {
		M.paramnames = tokens(eqnames)
		k = length(M.paramnames)
		M.nparam = k
		M.eqvars = tokens(xbvlist)
		M.indepvars = J(k,1,NULL)
		M.cons = J(k,1,0)
		vlist = tokens(vlist,"|")
		i1 = 0
		for (i=1; i<=k; i++) {
			if (vlist[++i1] != "_") {
				M.indepvars[i] = &J(1,1,tokens(vlist[i1]))
			}
			M.cons[i] = cons[i]
			(void)++i1
		}
	}
	M.lfvar = lfvar
	M.tousevar = touse
	M.nobs = sum(st_data(.,M.tousevar))
	M.expression = expr
	M.weighttype = wtype
	M.weightvar = wvar
	M.vcetype = vce
	M.clustvar = cluster
	
	M.hasderiv = (hasderiv == 1)
	if (M.hasderiv) {
		M.derivvar = tokens(dvlist)
		delist = tokens(delist,"|")
		i1 = 0
		M.derivexpr = J(1,k,"")
		for (i=1; i<=k; i++) {
			M.derivexpr[i] = delist[++i1]
			(void)++i1	// skip separator
		}
	}
	return(M)
}

void _mlexp_eval_ll(transmorphic scalar M, real scalar todo, 
	     real rowvector b, real colvector fv,
	     real matrix S, real matrix H)
{
	real scalar i, rc
	string scalar cmd
	real colvector xb
	struct _mlexp_info scalar MLEXP

	pragma unset H
	
	MLEXP = moptimize_util_userinfo(M,1)
	
	if (MLEXP.vn < 14) {
		st_matrix(MLEXP.parmvecname, b)
	}
	else {
		for (i=1; i<=MLEXP.nparam; i++) {
			xb = moptimize_util_xb(M,b,i)
			if (rows(xb) == 1) {
				// constant only equation
				xb = J(MLEXP.nobs,1,xb[1])
			}
			st_store(., MLEXP.eqvars[i], MLEXP.tousevar, xb)
		}
	}

	cmd = sprintf("replace %s = %s if %s",MLEXP.lfvar,MLEXP.expression,
		       MLEXP.tousevar)
	rc = _stata(cmd,1)
	if (rc) {
		rc = _stata(cmd,0)
		errprintf("could not evaluate likelihood function\n")
		exit(rc)
	}
	if (rows(fv) == MLEXP.nobs) {
		fv[.] = st_data(.,MLEXP.lfvar,MLEXP.tousevar)
	}
	else {
		fv = st_data(.,MLEXP.lfvar,MLEXP.tousevar)
	}
	if (todo == 0) return

	for(i=1; i<=MLEXP.nparam; ++i) {
		cmd = sprintf("replace %s = %s if %s", MLEXP.derivvar[i],
				MLEXP.derivexpr[i], MLEXP.tousevar)
		rc = _stata(cmd, 1)
		if (rc) {
			rc = _stata(cmd, 0)
			errprintf("could not evaluate derivative\n")
			exit(rc)
		}
	}
	if (rows(S) == MLEXP.nobs) {
		S[.,.] = st_data(., MLEXP.derivvar, MLEXP.tousevar)
	}
	else {
		S = st_data(., MLEXP.derivvar, MLEXP.tousevar)
	}
}

void _mlexp_wrk(string scalar parmvec, string scalar params, 
	string scalar eqnames, string scalar xbvlist, string rowvector vlist,
	real rowvector cons, string scalar lfvar, string scalar touse,
	string scalar expr, string scalar wtype, string scalar wvar,
	string scalar vce, string scalar cluster, real scalar hasderiv,
	string scalar dvlist, string rowvector delist, string scalar Cm,
	real scalar ver, real scalar nolog, string scalar debug, 
	string scalar mlopts, real scalar searchoff, |string scalar scrlist)
{
	real scalar i, ec, i1, i2, scoresonly
	real vector iparams
	real matrix scores
	string scalar lf, valueid
	struct _mlexp_info scalar MLEXP
	transmorphic scalar MOPT

	scoresonly = strlen(scrlist)>0

	MLEXP = _mlexp_setup(parmvec, params, eqnames, xbvlist, vlist,
		cons, lfvar, touse, expr, wtype, wvar, vce, cluster,
		hasderiv, dvlist, delist, ver)
	
	MOPT = moptimize_init()
	
	moptimize_init_touse(MOPT, MLEXP.tousevar)
	moptimize_init_eq_n(MOPT, MLEXP.nparam)
	if (MLEXP.vn < 14) {
		lf = "gf"
		moptimize_init_kaux(MOPT, MLEXP.nparam)
	}
	else {
		lf = "lf"
		i2 = 0
	}
	if (MLEXP.hasderiv) {
		moptimize_init_evaluatortype(MOPT, lf+"1"+debug)
	}
	else {
		moptimize_init_evaluatortype(MOPT, lf+"0"+debug)
	}
	if (searchoff) {
		moptimize_init_search(MOPT, "off")
	}
	moptimize_init_evaluator(MOPT, &_mlexp_eval_ll())
	moptimize_init_userinfo(MOPT, 1, MLEXP)
	moptimize_init_obs(MOPT, sum(st_data(., MLEXP.tousevar)))

	iparams = st_matrix(MLEXP.parmvecname)
	for(i=1; i <= MLEXP.nparam; ++i) {
		moptimize_init_eq_name(MOPT, i, MLEXP.paramnames[i])
		if (MLEXP.vn < 14) {
			moptimize_init_eq_coefs(MOPT, i, iparams[i])
		}
		else {
			/* ado code assures equation & variables are	*/
			/*  in the proper order				*/
			i1 = i2 + 1
			if (MLEXP.indepvars[i]) {
				moptimize_init_eq_indepvars(MOPT, i, 
						*MLEXP.indepvars[i])
				i2 = i2 + length(*MLEXP.indepvars[i])
			}
			if (MLEXP.cons[i]) {
				i2 = i2 + 1
				moptimize_init_eq_cons(MOPT, i, "on")
			}
			else {
				moptimize_init_eq_cons(MOPT, i, "off")
			}
			moptimize_init_eq_coefs(MOPT, i, iparams[|i1\i2|])
		}
	}
	valueid = "log likelihood"
	if (MLEXP.weighttype == "pweight") {
		valueid = "log pseudolikelihood"
	}
	
	if (MLEXP.weighttype != "") {
		moptimize_init_weighttype(MOPT, MLEXP.weighttype)
		moptimize_init_weight(MOPT, MLEXP.weightvar)
	}
	
	if (MLEXP.vcetype != "") {
		moptimize_init_vcetype(MOPT, MLEXP.vcetype)
		if (MLEXP.clustvar != "") {
			moptimize_init_cluster(MOPT, MLEXP.clustvar)
			valueid = "log pseudolikelihood"
		}
		if (moptimize_init_vcetype(MOPT) == "robust") {
			valueid = "log pseudolikelihood"
		}
	}
	else {
		moptimize_init_vcetype(MOPT, "oim")
	}
	moptimize_init_valueid(MOPT, valueid)
	
	// user ML options
	moptimize_init_mlopts(MOPT, mlopts)

	if (nolog) {
		moptimize_init_trace_value(MOPT, "off")
	}
	else {
		moptimize_init_trace_value(MOPT, "on")
	}
	if (strlen(Cm)) {
		moptimize_init_constraints(MOPT,st_matrix(Cm))
	}

	// the big bang
	ec = _moptimize(MOPT)
	if (ec) {
		exit(moptimize_result_returncode(MOPT))
	}
	if (scoresonly) {
		scores = moptimize_result_scores(MOPT)

		st_store(.,tokens(scrlist), MLEXP.tousevar, scores)
	}
	else {
		moptimize_result_post(MOPT)
		st_numscalar("e(ll)", moptimize_result_value(MOPT))
	}
}
end
exit
