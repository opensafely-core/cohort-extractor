*! version 1.0.9  18jun2018

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __ecovmatrix.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

void _menl_gnls_trace(real scalar iter, string scalar crit, real scalar val,
			real scalar rdifb, class __menl_expr scalar expr,
			struct _menl_mopts scalar mopts,
			struct _menl_mopts scalar gopts,
			struct _menl_mopts scalar nopts)
{
	class __stmatrix scalar b

	if (mopts.itracelevel == `MENL_TRACE_NONE') {
		return
	}
	if (!nopts.log & !gopts.log) {
		printf("{txt}Iteration %g:{col 16} %s = {res}%g\n",iter,crit,
			val)
	}
	else if (gopts.log) {
		printf("{txt}\n%s = {res}%g\n",crit,val)
	}
	if (mopts.itracelevel <= `MENL_TRACE_VALUE') {
		displayflush()
		return
	}
	printf("{txt}GNLS relative difference\n")
	printf("{txt}{col 7}{res}%12.4e{col 30}{txt}" +
		"tolerance:{col 42}{res}%12.4e\n",rdifb,mopts.tol)
	b = expr.stparameters()
	b.display("parameters")
	printf("\n")
	displayflush()
}

void _menl_gnls(class __menl_expr scalar expr, string scalar sCc,
		string scalar smopts, string scalar snopts,
		string scalar sgopts, |string scalar touse)
{
	real scalar rc, conv, conv_fe, iter, val, rdifb
	real scalar profile, lf
	real rowvector b, b0
	string scalar crit
	class __menl_gnls scalar gnls
	class __menl_nlm scalar nlm
	class __stmatrix stb
	pointer (class __ecovmatrix) scalar var
	struct _menl_mopts scalar mopts, gopts, nopts
	struct _menl_constraints scalar cns

	rc = 0
	_menl_constraint_matrix(sCc,cns)

	_menl_parse_mopts(smopts, mopts, `MOPTS_DEFAULT_STANDARD')
	_menl_parse_mopts(snopts, nopts, `MOPTS_DEFAULT_LME')

	var = expr.res_covariance()
	profile = ((var->ksdpar()+var->kcorpar()) > 0)
	var = NULL	// decrement ref count
	if (profile) {
		/* alternating algorithm for residual covariance
		 *  parameters						*/
		_menl_parse_mopts(sgopts, gopts, `MOPTS_DEFAULT_PNLS')
		gopts.ltype = mopts.ltype	// REML = unbiased var(e)
		if (!mopts.maxiter) {
			gopts.maxiter = mopts.maxiter
			gopts.itracelevel = `MENL_TRACE_NONE'
		}
	}
	else {
		crit = "SSE"
		_menl_parse_mopts(smopts, gopts, `MOPTS_DEFAULT_DEFAULT')
	}
	gnls.clear()
	gnls.set_subexpr(expr,touse)
	if (rc=gnls.initialize(`MENL_GNLS_FE',cns,gopts)) {
		errprintf("{p}%s{p_end}\n",gnls.errmsg())
		gnls.clear()
		nlm.clear()
		exit(rc)
	}
	if (profile) {
		/* alternating algorithm for residual covariance
		 *  parameters						*/
		if (mopts.ltype == "reml") {
			crit = "log restricted-likelihood"
		}
		else {
			crit = "log likelihood"
		}

		nlm.clear()
		nlm.set_subexpr(expr,touse)
		if (rc=nlm.initialize(profile,nopts,gnls.rank())) {
			errprintf("{p}%s{p_end}\n",nlm.errmsg())
			gnls.clear()
			nlm.clear()
			exit(rc)
		}
	}
	if (mopts.log & mopts.maxiter) {
		if (profile) {
			if (nopts.ltype == "reml") {
				printf("{txt}Alternating GNLS/REML " +
					"algorithm:\n")
			}
			else {
				printf("{txt}Alternating GNLS/ML algorithm:\n")
			}
		}
		else {
			printf("{txt}NLS algorithm:\n")
		}
		if (!nopts.log & !gopts.log) {
			printf("\n")
		}
		else if (gopts.log & !profile) {
			printf("\n")
		}
		displayflush()
	}
	stb = expr.stparameters()
	b0 = stb.m()
	rdifb = maxdouble()
	conv = conv_fe = `MENL_FALSE'
	/* outer loop for updating fitted values used in residual cov	*/
	iter = 0
	while (++iter <= mopts.maxiter) {
		if (profile & (nopts.log | gopts.log)) {
			printf("{txt}\nIteration %g\n",iter)
		}
		if (iter > 1) {
			if (rc=gnls.reinitialize(gopts.maxiter)) {
				errprintf("{p}%s{p_end}\n",gnls.errmsg())
				gnls.clear()
				nlm.clear()
				exit(rc)
			}
		}
		if (profile & gopts.log) {
			printf("{txt}\nGNLS step %g\n",iter)
		}
		if (rc=gnls.run()) {
			errprintf("{p}%s{p_end}\n",gnls.errmsg())
			gnls.clear()
			nlm.clear()
			exit(rc)
		}
		conv_fe = gnls.converged()
		if (!profile) {
			conv = conv_fe
			break
		}
		if (iter > 1) {
			if (rc=nlm.reinitialize(nopts.maxiter,gnls.rank())) {
				errprintf("{p}%s{p_end}\n",nlm.errmsg())
				nlm.clear()
				gnls.clear()
				exit(rc)
			}
		}
		if (nopts.log) {
			printf("{txt}\nML step %g\n",iter)
		}
		if (rc=nlm.run()) {
			errprintf("{p}%s{p_end}\n",nlm.errmsg())
			nlm.clear()
			gnls.clear()
			exit(rc)
		}
		stb = expr.stparameters()
		b = stb.m()
		rdifb = max(abs(b-b0):/(abs(b0):+`MENL_REL_ZERO'))
		if (rdifb < mopts.tol) {
			conv = `MENL_TRUE'
		}
		if (profile) {
			val = nlm.fun_value()
		}
		else {
			val = gnls.fun_value()
		}
		_menl_gnls_trace(iter, crit, val, rdifb, expr, mopts, gopts,
			nopts)

		if (conv_fe & conv) {
			break
		}
		b0 = b
	}
	if (!mopts.maxiter) {
		/* iterate(0)						*/
		if (rc=gnls.run()) {
			errprintf("{p}%s{p_end}\n",gnls.errmsg())
			gnls.clear()
			nlm.clear()
			exit(rc)
		}
	}
	if (mopts.log & !mopts.nostderr) {
		printf("\n{txt}Computing standard errors:\n")
		displayflush()
	}
	nlm.clear()
	nlm.set_subexpr(expr,touse)
	conv = (iter<mopts.maxiter & conv_fe & conv)
	profile = `MENL_FALSE'
	mopts.maxiter = 0
	mopts.itracelevel = `MENL_TRACE_NONE'
	if (rc=nlm.initialize(profile,mopts,gnls.rank())) {
		errprintf("{p}%s{p_end}\n",nlm.errmsg())
		gnls.clear()
		nlm.clear()
		exit(rc)
	}
	if (!mopts.nostderr) {
		if (rc=nlm.run()) {
			errprintf("{p}%s{p_end}\n",nlm.errmsg())
			gnls.clear()
			nlm.clear()
			exit(rc)
		}
		lf = nlm.fun_value()
	}
	else {
		lf = nlm.evaluate()
	}
	_menl_gnls_post(gnls, nlm, mopts.nostderr, conv, lf)
}

void _menl_gnls_post(class __menl_gnls scalar gnls, class __menl_nlm scalar nlm,
			real scalar nostderr, real scalar converged,
			real scalar lf)
{
	real scalar rank, keq, metric
	real vector trans0
	real rowvector br, bf
	real matrix eqs, J, Vr, Vf, V0
	string matrix stripe, rstripe, fstripe
	class __stmatrix scalar V, b, trans
	pointer (class __menl_expr) scalar expr

	pragma unset trans0
	pragma unset J

	/* fixed effects parameters					*/
	fstripe = gnls.stripe()
	bf =  gnls.parameters()
	Vf = gnls.VCE()

	/* residual covariance parameters				*/
	rstripe = nlm.stripe()
	br = nlm.parameters()
	if (nostderr) {
		Vr = J(cols(br),cols(br),0)
	}
	else {
		Vr = nlm.VCE()
	}
	stripe = (fstripe\rstripe)
	(void)b.set_matrix((bf,br))
	(void)b.set_colstripe(stripe)

	(void)V.set_matrix(blockdiag(Vf,Vr))
	(void)V.set_colstripe(stripe)
	(void)V.set_rowstripe(stripe)

	eqs = panelsetup(stripe,1)
	keq = rows(eqs) 
	rank = rank(V.m())

	b.st_matrix("r(b)")
	V.st_matrix("r(V)")
	st_numscalar("r(ll)",lf)
	st_numscalar("r(N)",nlm.n())
	st_numscalar("r(keq)",keq)
	st_numscalar("r(missing)",gnls.missing_count())
	st_numscalar("r(converged)",converged)
	st_numscalar("r(rank)",rank)

	expr = nlm.subexpr()
	/* variance/covariance metric					*/
	metric = `SUBEXPR_METRIC_VAR' + `SUBEXPR_METRIC_RESID'
	b = expr->cov_stparameters(metric,J,trans0)
	stripe = b.colstripe()

	V0 = J'Vr*J

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
	metric = `SUBEXPR_METRIC_SD' + `SUBEXPR_METRIC_RESID'
	b = expr->cov_stparameters(metric,J,trans0)
	stripe = b.colstripe()

	V0 = J'Vr*J

	(void)V.set_matrix(V0)
	(void)V.set_stripe(stripe)
	(void)trans.set_matrix(trans0)
	(void)trans.set_colstripe(stripe)
	(void)trans.set_rowstripe(("","stdev"))

	(void)b.set_rowstripe(("","stdev"))

	b.st_matrix("r(b_sd)")
	V.st_matrix("r(V_sd)")
	trans.st_matrix("r(trans_sd)")
	expr = NULL
}

end

exit
