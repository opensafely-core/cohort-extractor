*! version 1.0.7  27nov2018

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

/* implementation:: __menl_gnls						*/
void __menl_gnls::new()
{
	clear()
}

void __menl_gnls::destroy()
{
	clear()
}

void __menl_gnls::clear()
{
	super.clear()
	m_iter = 0
	/* must set to MENL_INITIAL_NLS or MENL_GNLS_FE			*/
	m_algorithm = `MENL_LBATES'
	m_rank = 0
}

real scalar __menl_gnls::algorithm()
{
	return(m_algorithm)
}

real scalar __menl_gnls::rank()
{
	return(m_rank)
}

/* virtual: must define							*/
real matrix __menl_gnls::VCE()
{
	return(super.VCE())
}

real scalar __menl_gnls::iterations()
{
	return(m_iter)
}

real scalar __menl_gnls::initialize(real scalar algorithm, 
		struct _menl_constraints scalar cns,
		struct _menl_mopts scalar mopts)
{
	real scalar count, rc
	real colvector f
	real rowvector a
	real matrix T
	pointer (class __ecovmatrix) scalar var

	pragma unset f
	pragma unset T
	pragma unset a

	m_algorithm = algorithm
	if (m_algorithm!=`MENL_GNLS_FE' & m_algorithm!=`MENL_INITIAL_NLS') {
		/* programmer error					*/
		m_errmsg = "invalid GNLS algorithm"
		return(498)
	}
	if (rc=super.initialize(mopts)) {
		return(rc)
	}
	moptimize_init_which(m_M, "min")
	moptimize_init_evaluator(m_M, &_menl_gnls_eval())
	moptimize_init_evaluatortype(m_M, "q1")
	moptimize_init_technique(m_M, "gn") 
	if (m_algorithm == `MENL_INITIAL_NLS') {
                moptimize_init_search(m_M,"quietly")
	}
	else {
		moptimize_init_search(m_M,"off")
	}
 	moptimize_init_search_random(m_M,"off")
 
	count = `MENL_TRUE'	// first pass count the # equations
	if (m_algorithm == `MENL_INITIAL_NLS') {
		/* turn off residual scaling				*/
		m_resid_scale = `MENL_FALSE'
	}
	init_FE(count)
	if (!m_kFEb) {
		m_errmsg = "no fixed effects"	// necessary?
		return(503)
	}
	m_iter = 0
	m_keq = m_kFEeq
	m_rank = m_kFEb		// this will do for now
	moptimize_init_eq_n(m_M, m_keq)

	count = `MENL_FALSE'	// now initialize moptimize object
	init_FE(count)
	if (m_resid_scale) {
		/* heteroskedastic error parameters			*/
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
	moptimize_init_valueid(m_M, "residual SS")

	if (rc=init_constraints(cns)) {
		return(rc)
	}
	if (constraint_T_a(T,a)) {
		m_rank = cols(T)	// this will do for now
	}
	return(0)
}

real scalar __menl_gnls::reinitialize(real scalar maxiter)
{
	real scalar rc
	real colvector f
	pointer (class __ecovmatrix) scalar var

	pragma unset f

	m_iter = 0
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
	moptimize_init_conv_maxiter(m_M, maxiter)

	return(rc)
}

void __menl_gnls::init_var(real scalar count)
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

real scalar __menl_gnls::init_constraints(struct _menl_constraints scalar cns)
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
	/* rename to _menl_subset_constraints()				*/
	if (!(rc=_menl_FE_constraints(cns,m_stripe,m_cns,m_errmsg))) {
		rc = super.init_constraints(m_cns)
	}
	return(rc)
}

real scalar __menl_gnls::set_subexpr_coef(|real rowvector b)
{
	real scalar rc

	if (!args()) {
		b = m_b
	}
	rc = super.set_subexpr_fe_coef(b)

	return(rc)
}

real scalar __menl_gnls::run()
{
	real scalar rc, lns, i1, i2
	real matrix VFE

	rc = super.run()
	if (rc) {
		return(rc)
	}
	if (m_kFEeq) {
		i1 = m_iFEeq[1,1]	// i1 = 1
		i2 = m_iFEeq[m_kFEeq,2]
		VFE = m_V[|i1,i1\i2,i2|]
		m_rank = ::rank(VFE)
	}
	else {
		m_rank = 0
	}
	if (m_reml) {
		lns = log((m_fun_value)/(m_n-m_rank))/2
	}
	else {
		lns = log((m_fun_value)/m_n)/2
	}
	(void)m_expr->_set_residual_lnsd(lns)

	m_iter = moptimize_result_iterations(m_M)

	return(rc)
}

real colvector __menl_gnls::evaluate()
{
	real scalar rc
	real colvector r

	pragma unset r

	if (rc=eval_F(r)) {
		r = J(m_n,1,.)
	}
	if (!m_todo) {
		m_missing = missing(r)
	}
	if (rc) {
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
	if (rows(m_select)) {
		r = select(r,m_select)
		if (!m_todo) {
			m_missing = missing(r)
		}
	}
	return(r)
}

end
exit
