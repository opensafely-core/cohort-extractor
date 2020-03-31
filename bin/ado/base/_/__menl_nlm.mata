*! version 1.0.6  20sep2018

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __sub_expr.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_cov.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

/* implementation:: __menl_nlm						*/
void __menl_nlm::new()
{
	clear()
}

void __menl_nlm::destroy()
{
	clear()
}

void __menl_nlm::clear()
{
	super.clear()
}

real scalar __menl_nlm::algorithm()
{
	if (m_profile) {
		return(`MENL_NLM_PROFILE')
	}
	return(`MENL_NLM')
}

/* virtual: must define							*/
real matrix __menl_nlm::VCE()
{
	return(super.VCE())
}

real scalar _menl_ldet_X(real matrix X, |real scalar rank)
{
	real scalar ldet
	real rowvector tau, p
	real matrix R

	pragma unset R

	ldet = .
	p = .
	tau = J(1,cols(X),0)
	_hqrdp(X,tau,R,p)
	rank = _menl_rank_R(R)
	if (rank) {
		/* may not be full rank because of factor variables	*/
		ldet = sum(log(abs(diagonal(R)[|1\rank|])))
	}
	return(ldet)
}

real scalar __menl_nlm::initialize(real scalar profile,
		struct _menl_mopts scalar mopts, real scalar rankFE)
{
	real scalar count, rc
	real colvector f
	pointer (class __ecovmatrix) scalar var

	pragma unset f

	if (rc=super.initialize(mopts)) {
		return(rc)
	}
	moptimize_init_which(m_M, "max")
	moptimize_init_evaluator(m_M, &_menl_nlm_eval())
	moptimize_init_evaluatortype(m_M, "d2")
	moptimize_init_technique(m_M, "nr") 
	moptimize_init_search(m_M,"off")
 
	m_profile = (profile!=`MENL_FALSE')
 	m_hasscale = !m_profile
	count = `MENL_TRUE'	// first pass count the # equations
	init_var(count)

	m_keq = m_ksigrho
	moptimize_init_eq_n(m_M, m_keq)

	count = `MENL_FALSE'	// now initialize moptimize object
	init_var(count)
	if (m_resid_scale) {
		if (m_resid_scale == `MENL_RESID_SCALE_FITTED') {
			if (rc=eval_F(f)) {
				return(rc)
			}
			var = m_expr->res_covariance()
			var->set_fitted(f)
			var = NULL
		}
		if (rc=update_resid_scale()) {
			return(rc)
		}
	}
	if (m_reml) {
		moptimize_init_valueid(m_M, "log restricted-likelihood")
	}
	else {
		moptimize_init_valueid(m_M, "log likelihood")
	}
	if (m_reml) {
		m_cons = log(2*pi())
	}
	else if (m_profile) {
		if (`MENL_GNLS_UNBIASED_V') {
			m_cons = -m_n*log(2*pi()/(m_n-rankFE))/2 - 
				(m_n-rankFE)/2
		}
		else {
			m_cons = -m_n*(log(2*pi()/m_n)+1)/2 
		}
	}
	else {
		m_cons = -m_n*log(2*pi())/2
	}
	return(rc)
}

void __menl_nlm::init_var(real scalar count)
{
	real scalar ieq, i2

	if (count) {
		super.init_var(count)
	}
	else {
		ieq = m_kFEeq
		i2 = m_kFEb
		super.init_var(count, ieq, i2)
	}
}

real scalar __menl_nlm::reinitialize(real scalar maxiter, real scalar rankFE)
{
	real scalar rc
	real colvector f
	pointer (class __ecovmatrix) scalar var

	pragma unset f

	if (rc=super.reinitialize()) {
		return(rc)
	}
	if (m_resid_scale) {
		if (m_resid_scale==`MENL_RESID_SCALE_FITTED') {
			if (rc=eval_F(f)) {
				return(rc)
			}
			var = m_expr->res_covariance()
			var->set_fitted(f)
			var = NULL
		}
		rc = update_resid_scale()
		if (rc) {
			return(rc)
		}
	}
	if (m_reml) {
		m_cons = log(2*pi())
	}
	else if (m_profile) {
		if (`MENL_GNLS_UNBIASED_V') {
			m_cons = -m_n*log(2*pi()/(m_n-rankFE))/2 - 
				(m_n-rankFE)/2
		}
		else {
			m_cons = -m_n*(log(2*pi()/m_n)+1)/2 
		}
	}
	else {
		m_cons = -m_n*log(2*pi())/2
	}
	moptimize_init_conv_maxiter(m_M, maxiter)

	return(rc)
}

real scalar __menl_nlm::set_subexpr_coef(|real rowvector b,
		real scalar validate)
{
	real scalar rc

	if (!args()) {
		b = m_b
	}
	validate = (missing(validate)?`MENL_FALSE':(validate!=`MENL_FALSE'))

	rc = super.set_subexpr_var_coef(b)

	return(rc)
}

/* virtual: must define							*/
real scalar __menl_nlm::run()
{
	real scalar rc

	rc = super.run()

	return(rc)
}

real colvector __menl_nlm::evaluate()
{
	real scalar lns, lf, rc, s, cons, ldet, rank
	real scalar select
	real colvector r, y
	real rowvector a
	real matrix T
	pointer (class __ecovmatrix) scalar var

	pragma unset y
	pragma unset r
	pragma unset a
	pragma unset T

	select = rows(m_select)>0
	rc = 0
	if (eval_F(r)) {
		r = J(m_n,1,.)
		return(r)
	}

	r = m_y-r
	if (m_resid_scale) {
		if (rows(m_select)) {
			/* zero residuals to prevent scaling to create
			 *  a full missing vector			*/
			r[m_isel2zero] = J(rows(m_isel2zero),1,0)
		}
		resid_scale(r)
	}
	else {
		var = m_expr->res_covariance()
		lns = var->lnsigma0()
		s = exp(lns)
		r = r:/s
		m_res_ldet = 2*m_n*lns
		var = NULL	// decrement ref count
	}
	if (select) {
		r = select(r,m_select)
	}
	if (!m_todo) {
		m_missing = missing(r)
	}
	if (m_reml) {
		y = m_y
		if (m_eq_LC) {
			rc = _menl_modelmatrix(*m_expr,y,m_X,J(1,0,NULL))
		}
		else {
			if (constraint_T_a(T,a)) {
				rc = _menl_linearize(*m_expr,y,m_X,J(1,0,NULL),
					T,a)
			}
			else {
				rc = _menl_linearize(*m_expr,y,m_X,J(1,0,NULL))
			}
			if (rc) {
				m_errmsg = m_expr->errmsg()
				return(rc)
			}
		}
		rank = ldet = 0
		if (cols(m_X)) {
			if (m_resid_scale) {
				resid_scale(m_X)
			}
			if (select) {
				m_X = select(m_X,m_select)
			}
			ldet = _menl_ldet_X(m_X,rank)
		}
		if (m_profile) {
			cons = -(m_n-rank)*(m_cons-log(m_n-rank)+1)/2
		}
		else {
			cons = -(m_n-rank)*m_cons/2
		}
		if (m_profile) {
			lf = cons - (m_n-rank)*log(r'r)/2 - m_res_ldet/2 - ldet
		}
		else {
			lf = cons - (r'r)/2 - m_res_ldet/2 - ldet
			if (!m_resid_scale) {
				lf = lf + rank*lns
			}
		}
	}
	else if (m_profile) {
		lf = m_cons - m_n*log(r'r)/2 - m_res_ldet/2
	}
	else {
		lf = m_cons - (r'r)/2 - m_res_ldet/2
	}
	return(lf)
}

real scalar __menl_nlm::init_constraints(struct _menl_constraints scalar cns)
{
	real scalar rc

	if (!m_kFEb) {
		/* no FE or turned off estimation of FE because of	
		 *  iterate(0)						*/
		return(0)
	}
	if (!cns.C.cols()) {
		return(0)
	}
	if (!(rc=_menl_FE_constraints(cns,m_stripe,m_cns,m_errmsg))) {
		rc = super.init_constraints(m_cns)
	}
	return(rc)
}

end
exit
