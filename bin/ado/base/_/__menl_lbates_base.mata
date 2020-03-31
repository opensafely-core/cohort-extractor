*! version 1.1.4  04sep2019

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

/* implementation: __menl_lbates_base					*/
void __menl_lbates_base::new()
{
	clear()
	if (missing(m_eps)) {
		m_eps = sqrt(epsilon(1))
	}
}

void __menl_lbates_base::destroy()
{
	clear()
}

void __menl_lbates_base::clear()
{
	real scalar i, k

	m_keq = m_kFEeq = m_kFEb = m_ksigrho = 0
	m_iFEeq = J(0,2,0)
	m_cons = .
	m_isigma = J(0,0,0)
	m_irho = J(0,0,0)
	m_b = J(1,0,0)
	m_V = J(0,0,0)
	m_stripe = J(0,2,"")
	m_X = J(0,0,0)
	m_expr = NULL		// release reference
	m_n = m_missing = 0
	m_hierarchy = NULL
	m_fun_value = .
	m_reml = `MENL_FALSE'
	m_todo = 0
	m_pinfo = J(0,2,0)
	m_cns = _menl_constraints(1)
	m_mopts = _menl_mopts(1)
	m_M = NULL
	m_errmsg = ""
	m_depvar = ""
	m_converged = J(1,2,0)

	k = length(m_res_psi)
	for (i=1; i<=k; i++) {
		m_res_psi[i] = NULL
	}
	m_res_psi = J(1,0,NULL)
	m_resid_scale = `MENL_FALSE'
	m_hasscale = `MENL_FALSE'
	m_eq_LC = `MENL_FALSE'
	m_touse = ""
	m_y = J(0,1,0)
	m_select = m_isel2zero = J(0,1,0)
}

real scalar __menl_lbates_base::algorithm()
{
	return(`MENL_LBATES')	// base virtual class
}

real rowvector __menl_lbates_base::parameters()
{
	return(m_b)
}

real matrix __menl_lbates_base::VCE()
{
	return(m_V)
}

string matrix __menl_lbates_base::stripe()
{
	return(m_stripe)
}

real scalar __menl_lbates_base::fun_value()
{
	return(m_fun_value)
}

real scalar __menl_lbates::reml()
{
	return(m_reml)
}

real scalar __menl_lbates_base::rscale()
{
	return(m_resid_scale)
}

string scalar __menl_lbates_base::depvar()
{
	return(m_depvar)
}

real scalar __menl_lbates_base::missing_count()
{
	return(m_missing)
}

real scalar __menl_lbates_base::converged()
{
	return(m_converged[`MENL_CONVERGED_MOPT'])
}

real scalar __menl_lbates_base::constraint_T_a(real matrix T, real rowvector a)
{
	real scalar k

	if (k=m_cns.T.rows()) {
		T = m_cns.T.m()
		a = m_cns.a.m()
	}
	return(k)
}

void __menl_lbates_base::set_subexpr(class __sub_expr scalar expr,
			|string scalar touse)
{
	real colvector tu, sel

	m_expr = &expr
	m_depvar = expr.depvars()[1]
	if (strlen(touse)) {
		/* override estimation sample
		 *  used for recursive models, e.g. y = f(L.{y}...)	*/
		m_touse = touse
		/* selection vector for __sub_expr estimation sample	*/
		tu = st_data(.,expr.touse(m_depvar))
		sel = st_data(.,touse,expr.touse(m_depvar))
		m_select = J(sum(tu),1,1):&sel
		m_isel2zero = select(1::rows(m_select),!m_select)
	}
	else {
		m_touse = m_expr->touse(m_depvar)
		m_select = m_isel2zero = J(0,1,0)
	}
}

pointer (class __sub_expr) scalar __menl_lbates_base::subexpr()
{
	return(m_expr)
}

string scalar __menl_lbates_base::errmsg()
{
	return(m_errmsg)
}

real matrix __menl_lbates_base::iFEeq()
{
	return(m_iFEeq)
}

real scalar __menl_lbates_base::kFEb()
{
	return(m_kFEb)
}

real matrix __menl_lbates_base::isigma()
{
	return(m_isigma)
}

real matrix __menl_lbates_base::irho()
{
	return(m_irho)
}

void __menl_lbates_base::set_todo(real scalar todo)
{
	m_todo = todo
}

real scalar __menl_lbates_base::n()
{
	return(m_n)
}

string scalar __menl_lbates_base::touse()
{
	return(m_touse)
}

real colvector __menl_lbates_base::selection()
{
	return(m_select)
}

real scalar __menl_lbates_base::initialize(struct _menl_mopts scalar mopts)
{
	real scalar i, k, vtype, ctype, n
	real colvector ind
	string scalar path, tracelevel
	string matrix paths
	pointer (class __ecovmatrix) scalar var
	pointer (class __pathcovmatrix) scalar covs

	if (m_expr == NULL) {
		m_errmsg = "substitutable expression object not available"
		return(498)
	}
	m_missing = 0
	m_mopts = mopts
	m_reml = (m_mopts.ltype=="reml")
	/* use equation m_depvar estimation sample			*/
	m_y = st_data(.,m_depvar,m_expr->touse(m_depvar))
	n = rows(m_y)
	if (rows(m_select) == n) {
		/* zero dependent values not in the selection vector	*/
		m_n = sum(m_select)
		if (m_n == n) {
			m_select = J(0,1,0)
			m_touse = m_expr->touse(m_depvar)
		}
		else {
			/* zero out unselected elements of the depvar
 			*  will typically be missing in a recursive 
 			*  model					*/
			ind = select(1::n,1:-m_select)
			m_y[ind] = J(rows(ind),1,0)
		}
	}
	else {
		m_n = n
	}

	var = m_expr->res_covariance()
	if (var == NULL) {
		m_errmsg = "no residual variance structure is defined"
		return(498)
	}
	m_resid_scale = `MENL_RESID_SCALE'
	vtype = var->vtype()
	ctype = var->ctype()
	if (vtype==var->HOMOSKEDASTIC & ctype==var->INDEPENDENT) {
		if (!var->bycount(var->STDDEV)) {
			m_resid_scale = `MENL_FALSE'
		}
	}
	else if (vtype==var->POWER | vtype==var->CONSTPOWER | 
		vtype==var->EXPONENTIAL) {
		if (var->pvar_name() == `MENL_VAR_RESID_FITTED') {
			m_resid_scale = `MENL_RESID_SCALE_FITTED'
		}
	}

	m_hierarchy = m_expr->hierarchy()
	if (m_hierarchy == NULL) {
		m_errmsg = "random effects hierarchy has not been created"
		var = NULL
		return(498)
	}
	if (k=m_hierarchy->path_count()) {
		m_pinfo = m_hierarchy->current_panel_info()
		covs = m_expr->path_covariances()
		paths = m_hierarchy->paths()
		for (i=1; i<=k; i++) {
			path = paths[i,`MENL_HIER_PATH']
			if (covs[i]->path() != path) {
				/* programmer error			*/
				m_errmsg = sprintf("hierarchical model is " +
					"not properly set up; path conflict " +
					"at level %g, %s != %s",k-i+2,path,
					covs[i]->path())
				covs = NULL
				var = NULL
				return(498)
			}
		}
		covs = NULL
	}
	else { // if (m_resid_scale) {
		m_pinfo = m_hierarchy->current_panel_info()
	}
	if (m_resid_scale & !rows(m_pinfo)) {
		m_errmsg = sprintf("specified %s residual variance and " +
			"%s residual correlation, but there are no " +
			"panels in the data",var->svtype(),var->sctype())
		return(498)
	}
	var = NULL
	if (algorithm() != `MENL_LBATES_PNLS') {
		m_M = moptimize_init()

		/* m_touse possibly subsample for recursive models	*/
		moptimize_init_touse(m_M, m_touse)
		moptimize_init_ndepvars(m_M, 1)
		moptimize_init_depvar(m_M, 1, m_depvar)
		moptimize_init_nuserinfo(m_M, 1)
		moptimize_init_userinfo(m_M, 1, &this)
		moptimize_init_singularHmethod(m_M,"hybrid")
		moptimize_init_conv_warning(m_M, "off")

		/* user specified options				*/
		tracelevel = m_mopts.tracelevel[m_mopts.itracelevel]
		moptimize_init_tracelevel(m_M, tracelevel)
		moptimize_init_conv_maxiter(m_M, m_mopts.maxiter)
		moptimize_init_vcetype(m_M, m_mopts.vce)	// OIM always
		/* tolerances						*/
		moptimize_init_conv_ptol(m_M, m_mopts.tol)
		moptimize_init_conv_vtol(m_M, m_mopts.ltol)
		if (m_mopts.nonrtol) {
			moptimize_init_conv_ignorenrtol(m_M, "on")
		}
		else {
			moptimize_init_conv_nrtol(m_M, m_mopts.nrtol)
		}
	}
	m_kFEeq = m_kFEb = m_keq = 0
	m_iFEeq = m_isigma = m_irho = J(0,2,0)
	m_ksigrho = 0
	m_b = J(1,0,0)
	m_stripe = J(0,2,"")
	m_eq_LC = (m_expr->is_linear_equation(m_depvar))

	return(0)
}

real scalar __menl_lbates_base::reinitialize()
{
	if (m_M != NULL) {
		moptimize_reset_p0(m_M)	// copy last estimates to initial 
	}
	return(0)
}

real scalar __menl_lbates_base::init_constraints(
			struct _menl_constraints scalar cns)
{
	real scalar kc

	if (!(kc=cns.C.cols())) {
		return(0)
	}
	if (kc != m_kFEb+m_ksigrho+1) {
		m_errmsg = sprintf("constraint matrix has %g columns, but " +
			"%g is expected",kc,m_kFEb+1)
		return(503)
	}
	moptimize_init_constraints(m_M,cns.C.m())

	return(0)
}

void __menl_lbates_base::init_FE(real scalar count)
{
	real scalar i, j, j1, k, n, lc, lf, i1, i2, cons
	real rowvector b, bi
	real matrix sinfo
	string scalar eq, eq0
	string vector cnames
	string matrix stripe, eqstr, bstr

	m_iFEeq = J(m_kFEeq,2,0)
	m_kFEeq = m_kFEb = 0
	
	i2 = j1 = 0
	b = m_expr->FE_parameters()
	if (!(m_kFEb=length(b))) {
		return		// no fixed effects
	}
	stripe = m_expr->param_stripe()
	sinfo = panelsetup(stripe,1)
	n = panelstats(sinfo)[1]
	for (i=1; i<=n; i++) {
		eqstr = panelsubmatrix(stripe,i,sinfo)
		k = rows(eqstr)
	
		eq = eqstr[1,1]
		lf = `MENL_FALSE' 
		if ((lc=ustrlen(eq))) {
			lf = (usubstr(eq,1,1)!="/")
			lc = (lc>1)
		}
		if (lf) {	// linear form
			if (count) {
				++m_kFEeq
				continue
			}
			i1 = i2 + 1
			i2 = i2 + k
			moptimize_init_eq_name(m_M, ++m_kFEeq, eq)
			cons = strmatch(eqstr[k,2],"_cons")
			if (cons) {
				moptimize_init_eq_cons(m_M, m_kFEeq, "on")
			}
			else {
				moptimize_init_eq_cons(m_M, m_kFEeq, "off")
			}
			if (!(cons & k==1)) {
				if (cons) k--
				/* has covariates			*/
				cnames = eqstr[|1,2\k,2|]'
				moptimize_init_eq_indepvars(m_M, m_kFEeq, 
					cnames)
			}
			/* index range into moptimize coefficient vector */
			m_iFEeq[++j1,.] = (i1,i2)
			bi = b[|i1\i2|]
			moptimize_init_eq_coefs(m_M, m_kFEeq, bi)
			m_b = (m_b,bi)
			m_stripe = (m_stripe\eqstr)

			continue
		}
		if (count) {
			m_kFEeq = m_kFEeq + k
			continue
		}
		/* linear combination or free parameter; treat them all
		 *  as free parameters in moptimize
		 * __sub_expr will evaluate linear combinations as
		 *  	... + b[i]*var[i] + b[i+1]*var[i+1] + ...	*/
		bstr = J(k,2,"")
		if (lc) {
			/* lose the slash '/'				*/
			eq = usubstr(eq,2,ustrlen(eq)-1)
			eq0 = eq
		}

		for (j=1; j<=k; j++) {
			i2++
			cons = strmatch(eqstr[j,2],"_cons")
			if (lc & cons) {
				moptimize_init_eq_cons(m_M, ++m_kFEeq, "on")
				eq = eq0
				bstr[j,1] = eq0
				bstr[j,2] = "_cons"
			}
			else {
				moptimize_init_eq_freeparm(m_M, ++m_kFEeq, "on")
				if (lc) {
					eq = sprintf("%s_%s",eq0,eqstr[j,2])
					eq = usubinstr(eq,".","_",.)
				}
				else {
					eq = eqstr[j,2]
					if (usubstr(eq,1,1) == "/") {
						/* lose the slash '/'	*/
						eq = usubstr(eq,2,ustrlen(eq)-1)
					}
					bstr[j,2] = eq
				}
			}
			moptimize_init_eq_name(m_M, m_kFEeq, eq)
			/* index into moptimize coefficient vector	*/
			m_iFEeq[++j1,.] = (i2,i2)
			bi = b[i2]
			moptimize_init_eq_coefs(m_M, m_kFEeq, bi)
			m_b = (m_b,bi)
		}
		m_stripe = (m_stripe\eqstr)
	}
}

void __menl_lbates_base::init_var(real scalar count, |real scalar ieq,
			real scalar i2)
{
	real scalar j, k, n, m, i1, lnsig, kres
	real rowvector b
	string matrix stripe
	class __stmatrix sdpar, corpar
	pointer (class __ecovmatrix) vector var

	var = m_expr->res_covariance()
	n = var->ksdpar()
	m = var->kcorpar()
	kres = n + m
	if (m_hasscale) {
		kres++
	}
	if (count | !kres) {
		m_ksigrho = kres
		var = NULL
		return
	}
	k = 1
	m_isigma = m_irho = J(0,2,0)
	ieq = (args()==1?0:ieq)
	i2 = (args()==1?0:i2)
	lnsig = .
	if (m_hasscale) {
		sdpar = var->lnsigma()
		lnsig = sdpar.m()

		/* setting residual covariance parameters first
		 *  parameter is the scale (profiled) parameter		*/
		i2++
		m_isigma = (m_isigma\(i2,i2))
		m_irho = (m_irho\(0,0))
		m_stripe = (m_stripe\("/Residual","lnsigma"))
		moptimize_init_eq_name(m_M, ++ieq, "lnsigma")
		moptimize_init_eq_freeparm(m_M, ieq, "on")
		moptimize_init_eq_coefs(m_M, ieq, lnsig)
		m_b = (m_b,lnsig)
		k++
	}
	if (m+n == 0) {
		var = NULL
		return
	}
	sdpar = var->sd_parameters()
	corpar = var->cor_parameters()

	m_isigma = (m_isigma\J(1,2,0))
	m_irho = (m_irho\J(1,2,0))
	if (n) {
		i1 = i2 + 1
		i2 = i2 + n
		m_isigma[k,.] = (i1,i2)
		b = sdpar.m()
		stripe = sdpar.colstripe()
		m_stripe = (m_stripe\stripe)
		/* moptimize does not like parentheses			*/
		stripe[.,2] = usubinstr(stripe[.,2],"(","_",1)
		stripe[.,2] = usubinstr(stripe[.,2],")","_",1)
		stripe[.,2] = usubinstr(stripe[.,2],",","_",1)
		stripe[.,1] = J(n,1,"")
		for (j=1; j<=n; j++) {
			moptimize_init_eq_name(m_M, ++ieq, stripe[j,2])
			moptimize_init_eq_freeparm(m_M, ieq, "on")
			moptimize_init_eq_coefs(m_M, ieq, b[j])
		}
		m_b = (m_b,b)
	}
	if (m) {
		i1 = i2 + 1
		i2 = i2 + m
		m_irho[k,.] = (i1,i2)
		b = corpar.m()
		stripe = corpar.colstripe()
		m_stripe = (m_stripe\stripe)
		/* moptimize does not like parentheses			*/
		stripe[.,2] = usubinstr(stripe[.,2],"(","_",1)
		stripe[.,2] = usubinstr(stripe[.,2],")","_",1)
		stripe[.,2] = usubinstr(stripe[.,2],",","_",1)
		stripe[.,1] = J(m,1,"")
		for (j=1; j<=m; j++) {
			moptimize_init_eq_name(m_M, ++ieq, stripe[j,2])
			moptimize_init_eq_freeparm(m_M, ieq, "on")
			moptimize_init_eq_coefs(m_M, ieq, b[j])
		}
		m_b = (m_b,b)
	}
	var = NULL
}

real scalar __menl_lbates_base::set_subexpr_coef(real vector b)
{
	pragma unused b

	return(0)	// base virtual, do nothing
}

real scalar __menl_lbates_base::set_subexpr_fe_coef(real vector b)
{
	real scalar rc, i1, i2, kb
	real vector bi

	if (!m_kFEeq) {
		return(0)
	}
	kb = cols(b)
	i1 = m_iFEeq[1,1]
	i2 = m_iFEeq[m_kFEeq,2]
	if (kb < i2) {
		m_errmsg = sprintf("failed to set substitutable expression " +
			"coefficients; expected a vector of length at least " +
			"%g but got %g",i2,kb)
		return(503)
	}
	bi = b[|i1\i2|]
	if (rc=m_expr->_set_FE_parameters(bi)) {
		m_errmsg = m_expr->errmsg()
		return(rc)
	}
	return(0)
}

real scalar __menl_lbates_base::set_subexpr_var_coef(real vector b)
{
	real scalar rc, i1, i2, k, lnsd
	real vector bi
	pointer (class __ecovmatrix) vector var

	rc = 0
	if (!m_ksigrho) {
		if (!m_todo & !missing(m_s2)) {	
			/* set the computed s2				*/
			var = m_expr->res_covariance()
			lnsd = log(m_s2)/2
			var->set_lnsigma(lnsd)
		}
		return(rc)
	}
	var = m_expr->res_covariance()
	i1 = k = 0
	if (m_hasscale) {
		i1 = m_isigma[++k,1]	// residual variance
		i2 = m_isigma[k,2]
		bi = b[|i1\i2|]
		var->set_lnsigma(bi[1])
	}
	else if (!m_todo & !missing(m_s2)) {	
		/* set the computed s2					*/
		lnsd = log(m_s2)/2
		var->set_lnsigma(lnsd)
	}
	k++
	if (k<=rows(m_isigma)) {
		i1 = m_isigma[k,1]
		if (i1) {
			i2 = m_isigma[k,2]
			bi = b[|i1\i2|]
			if (rc=var->set_sd_parameters(bi)) {
				m_errmsg = var->errmsg()
				var = NULL
				return(rc)
			}
		}
	}
	if (k<=rows(m_irho)) {
		i1 = m_irho[k,1]
		if (i1) {
			i2 = m_irho[k,2]
			bi = b[|i1\i2|]
			if (rc=var->set_cor_parameters(bi)) {
				m_errmsg = var->errmsg()
				var = NULL
				return(rc)
			}
		}
	}
	var = NULL
	if (m_resid_scale) {
		rc = update_resid_scale()
	}
	return(rc)
}

real scalar __menl_lbates_base::run()
{
	real scalar ec, rc

	ec = _moptimize(m_M)
	if (ec) {
		if (ec == 401) {
			/* Stata program evaluator returned an error	*/
			m_errmsg = m_expr->errmsg()
		}
		if (!ustrlen(m_errmsg)) {
			m_errmsg = moptimize_result_errortext(m_M)
		}
		rc = moptimize_result_returncode(m_M)
		return(rc)
	}
	m_fun_value = moptimize_result_value(m_M)
	m_b = moptimize_result_coefs(m_M)
	m_V = moptimize_result_V(m_M)
	m_converged[`MENL_CONVERGED_MOPT'] = moptimize_result_converged(m_M)
	rc = set_subexpr_coef()

	return(rc)
}

real colvector __menl_lbates_base::evaluate()
{
	return(J(0,1,0))		// virtual
}

real scalar __menl_lbates_base::eval_F(real colvector yhat)
{
	real scalar rc

	if (rc=_menl_eval_F(*m_expr,m_depvar,yhat)) {
		m_errmsg = m_expr->errmsg()
	}
	return(rc)
}
 
real scalar __menl_lbates_base::dFdBeta(real matrix X, real vector b)
{
	real scalar rc

	if (rc=_menl_dFdBeta(*m_expr,m_depvar,X,b)) {
		m_errmsg = m_expr->errmsg()
	}
	return(rc)
}

real scalar __menl_lbates_base::update_resid_scale()
{
	real scalar i, kp, ldet, rc, sel
	real colvector select
	real matrix V
	pointer (class __ecovmatrix) scalar var

	pragma unset ldet

	var = m_expr->res_covariance()

	kp = rows(m_pinfo)
	m_res_psi = J(1,kp,NULL)
	m_res_ldet = 0
	sel = (rows(m_select)>0)
	for (i=1; i<=kp; i++) {
		if (rc=var->compute_V(m_pinfo[i,.],m_hasscale)) {
			m_errmsg = var->errmsg()
			var = NULL
			return(rc)
		}
		m_res_psi[i] = &(var->scale_matrix(ldet))
		if (missing(*m_res_psi[i]) | missing(ldet)) {
			m_errmsg = "residual covariance is not positive " +
				"definite"
			var = NULL
			return(506)
		}
		if (sel) {
			/* recompute determinate based on selection	*/
			V = var->m()
			select = panelsubmatrix(m_select,i,m_pinfo)
			if (cols(V) == 1) {
				V = select(V,select)
				ldet = sum(log(V))
			}
			else {
				V = select(V,select)
				V = select(V,select')
			}
		}
		m_res_ldet = m_res_ldet + ldet
	}
	var = NULL

	return(0)
}

real scalar __menl_lbates_base::update_resid_ldet()
{
	real scalar i, kp, ldet, rc
	pointer (class __ecovmatrix) scalar var

	pragma unset ldet

	var = m_expr->res_covariance()

	kp = rows(m_pinfo)
	for (i=1; i<=kp; i++) {
		if (rc=var->compute_V(m_pinfo[i,.],m_hasscale)) {
			m_errmsg = var->errmsg()
			var = NULL
			return(rc)
		}
		(void)var->scale_matrix(ldet)
		if (missing(ldet)) {
			m_errmsg = "residual covariance is not positive " +
				"definite"
			var = NULL
			return(506)
		}
		m_res_ldet = m_res_ldet + ldet
	}
	var = NULL

	return(0)
}

void __menl_lbates_base::resid_scale(real matrix Q)
{
	real scalar i, kp, i1, i2, c

	if (!m_resid_scale) {
		return
	}
	c = cols(Q)
	if (!c) {
		return
	}
	kp = rows(m_pinfo)
	if (kp==1 & m_pinfo[1,2]==rows(Q)) {
		if (cols(*m_res_psi[1]) == 1) {
			/* vector, no correlations			*/
			Q = (*m_res_psi[1]):*Q
		}
		else {
			Q = (*m_res_psi[1])*Q
		}
		return
	}
	for (i=1; i<=kp; i++) {
		i1 = m_pinfo[i,1]
		i2 = m_pinfo[i,2]
		if (cols(*m_res_psi[i]) == 1) {
			/* vector, no correlations			*/
			Q[|i1,1\i2,c|] = (*m_res_psi[i]):*Q[|i1,1\i2,c|]
		}
		else {
			Q[|i1,1\i2,c|] = (*m_res_psi[i])*Q[|i1,1\i2,c|]
		}
	}
}

end

exit

