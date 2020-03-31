*! version 11.1.1  27feb2014
version 11

mata:

pointer scalar mopt__get_tmp_external(string scalar name)
{
	string	scalar	tmp
	pointer	scalar	ptr

	ptr	= NULL
	while (ptr == NULL) {
		tmp	= st_tempname()
		ptr	= crexternal(tmp)
	}
	st_local(name, tmp)
	return(ptr)
}

// logit and probit ---------------------------------------------------------

void mopt__pl_init(string scalar name)
{
	pointer(real rowvector) scalar	perf

	perf	= mopt__get_tmp_external(name)
	(*perf)	= J(1,4,0)
}

void mopt__pl_post(string scalar name)
{
	pointer(real rowvector) scalar perf

	perf = findexternal(name)
	if (perf == NULL) {
		st_numscalar("e(N_cdf)", 0)
		st_numscalar("e(N_cds)", 0)
	}
	else {
		if (st_local("weight") == "fweight") {
			st_numscalar("e(N_cdf)", ((*perf)[3]))
			st_numscalar("e(N_cds)", ((*perf)[4]))
		}
		else {
			st_numscalar("e(N_cdf)", ((*perf)[1]))
			st_numscalar("e(N_cds)", ((*perf)[2]))
		}
		rmexternal(name)
	}
}

// logit --------------------------------------------------------------------

void mopt__logit_d2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real rowvector	g,
	real matrix	H
)
{
	_mopt_logit_d2(	todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_offset_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g,
			H)
}

void mopt__logit_e2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real matrix	g_e,
	real matrix	H
)
{
	_mopt_logit_e2(	todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_offset_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g_e,
			H)
}

// probit -------------------------------------------------------------------

void mopt__probit_d2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real rowvector	g,
	real matrix	H
)
{
	_mopt_probit_d2(todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_offset_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g,
			H)
}

void mopt__probit_e2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real matrix	g_e,
	real matrix	H
)
{
	_mopt_probit_e2(todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_offset_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g_e,
			H)
}

// ologit and oprobit -------------------------------------------------------

pointer vector	mopt__ordpl_set(real	rowvector	cat,
				real	rowvector	cd)
{
	pointer	vector	ord

	ord	= J(1,2,NULL)
	ord[1]	= &cat
	ord[2]	= &cd
	return(ord)
}

void mopt__ordpl_get(	pointer	vector		ord,
			real	rowvector	cat,
			real	rowvector	cd)
{
	cat	= (*ord[1])
	cd	= (*ord[2])
}

void mopt__ordpl_init(string scalar name)
{
	pointer	scalar	ord

	ord	= mopt__get_tmp_external(name)
	(*ord)	= mopt__ordpl_set(st_matrix(st_local("cat")), J(1,2,0))
}

void mopt__ordpl_post(string scalar name)
{
	pointer	scalar		ord
	real	rowvector	cat
	real	rowvector	cd
	real	scalar		k
	pragma unset cat
	pragma unset cd

	ord = findexternal(name)
	if (ord != NULL) {
		mopt__ordpl_get(*ord, cat, cd)
		if (st_local("weight") == "fweight") {
			st_numscalar("e(N_cd)", cd[2])
		}
		else {
			st_numscalar("e(N_cd)", cd[1])
		}
		st_matrix("e(cat)", cat)
		k = cols(cat)
		st_numscalar("e(k_cat)", k)
		st_numscalar("e(k_aux)", k-1)
		rmexternal(name)
	}
}

// ologit -------------------------------------------------------------------

void mopt__ologit_d2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real rowvector	g,
	real matrix	H
)
{
	_mopt_ologit_d2(todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_offset_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g,
			H)
}

void mopt__ologit_e2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real matrix	g_e,
	real matrix	H
)
{
	_mopt_ologit_e2(todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_offset_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g_e,
			H)
}

// oprobit ------------------------------------------------------------------

void mopt__oprobit_d2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real rowvector	g,
	real matrix	H
)
{
	_mopt_oprobit_d2(todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_offset_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g,
			H)
}

void mopt__oprobit_e2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real matrix	g_e,
	real matrix	H
)
{
	_mopt_oprobit_e2(todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_offset_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g_e,
			H)
}

// mlogit -------------------------------------------------------------------

pointer vector	mopt__mu_set(	real	rowvector	out,
				real	scalar		ibase,
				real	rowvector	cd)
{
	pointer	vector	mu

	mu	= J(1,3,NULL)
	mu[1]	= &out
	mu[2]	= &ibase
	mu[3]	= &cd
	return(mu)
}

void mopt__mu_get(	pointer	vector		mu,
			real	rowvector	out,
			real	scalar		ibase,
			real	rowvector	cd)
{
	out	= (*mu[1])
	ibase	= (*mu[2])
	cd	= (*mu[3])
}

void mopt__mu_init(string scalar name, real scalar ibase)
{
	pointer	scalar	mu

	mu	= mopt__get_tmp_external(name)
	(*mu)	= mopt__mu_set(st_matrix(st_local("out")), ibase, J(1,2,0))
}

void mopt__mu_post(string scalar name)
{
	pointer	scalar		mu
	real	rowvector	out
	real	scalar		ibase
	real	rowvector	cd
	real	scalar		k
	pragma unset out
	pragma unset ibase
	pragma unset cd

	mu = findexternal(name)
	if (mu != NULL) {
		mopt__mu_get(*mu, out, ibase, cd)
		if (st_local("weight") == "fweight") {
			st_numscalar("e(N_cd)", cd[2])
		}
		else {
			st_numscalar("e(N_cd)", cd[1])
		}
		st_matrix("e(out)", out)
		st_numscalar("e(ibaseout)", ibase)
		st_numscalar("e(baseout)", out[ibase])
		k = cols(out)
		st_numscalar("e(k_out)", k)
		rmexternal(name)
	}
}

void mopt__mlogit_d2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real rowvector	g,
	real matrix	H
)
{
	_mopt_mlogit_d2(todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g,
			H)
}

void mopt__mlogit_e2(
	     scalar	M,
	real scalar	todo,
	real rowvector	beta,
	real scalar	lnf,
	real matrix	g_e,
	real matrix	H
)
{
	_mopt_mlogit_e2(todo,
			moptimize_util_depvar(M),
			moptimize_util_X_ptr(M,1),
			moptimize_util_w_ptr(M),
			beta,
			lnf,
			moptimize_util_userinfo(M,1),
			g_e,
			H)
}

// poisson ------------------------------------------------------------------

void mopt__poisson_e2(		scalar		M,
			real	scalar		todo,
			real	rowvector	beta,
			real	scalar		lnf,
			real	matrix		g_e,
			real	matrix		H)
{
	pointer(real colvector) scalar	py
	real colvector xb
	real colvector lj

	py	= &moptimize_util_depvar(M)
	xb	= moptimize_util_xb(M, beta, 1)
	lj	= -exp(xb) :+ xb:*(*py) :- lngamma((*py):+1)
	lnf	= moptimize_util_sum(M, lj)
	if (todo ==0 | missing(lnf)) {
		return
	}
	g_e	= (*py) :- exp(xb)
	if (todo ==1 | missing(g_e)) {
		return
	}
	H	= moptimize_util_matsum(M,1,1,exp(xb),lnf)
}

end

exit
