*! version 1.1.4  04sep2019

findfile __sub_expr_cov.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

mata

mata set matastrict on

real scalar _menl_lv2data(class __menl_expr scalar expr,
			real matrix Z, string vector lvs)
{
	real scalar j, klv, n
	string scalar touse, covariate, depvar

	depvar = expr.depvars()[1]
	touse = expr.touse(depvar)
	n = sum(st_data(.,touse))
	lvs = tokens(lvs)
	klv = length(lvs)
	Z = J(n,klv,1)
	for (j=1; j<=klv; j++) {
		covariate = expr.LV_covariate(lvs[j])
		if (!strlen(covariate)) {
			continue
		}
		Z[.,j] = st_data(.,covariate,touse)
	}
	return(0)
}

real scalar _menl_dFdb(class __menl_expr scalar expr, string scalar depvar,
			real matrix Z, real matrix B, string scalar path,
			string vector lvs, real colvector idx)
{
	real scalar j, k, kb, klv, rc, eps, n
	real rowvector b, b0, io, i
	real colvector f1, f2, del, d

	pragma unset f1
	pragma unset f2

	n = 0 
	eps = epsilon(1)^(1/3)
	lvs = tokens(lvs)
	klv = length(lvs)
	idx = expr.path_index_vector(path,depvar)
	b0 = expr.RE_parameters(lvs[1])
	kb = cols(b0)
	B = J(kb,klv,0)
	del = J(kb,1,0)
	for (j=1; j<=klv; j++) {
		b0 = expr.RE_parameters(lvs[j])
		if (any(io=!b0)) {
			del = J(kb,1,eps)
			io = 1:-io
			if (any(io)) {
				i = select(1..kb,io)
				del[i'] = eps:*(abs(b0[i]'):+eps)
			}
		}
		else {
			del = eps:*(abs(b0'):+eps)
		}
		b = b0 + del'
		(void)expr._set_RE_parameters(b,lvs[j])
		if (rc=_menl_eval_F(expr,depvar,f1)) {
			return(rc)
		}
		b = b0 - del'
		(void)expr._set_RE_parameters(b,lvs[j])
		if (rc=_menl_eval_F(expr,depvar,f2)) {
			return(rc)
		}
		del = 2:*del
		if (!n) {
			n = length(f1)
			Z = J(n,klv,0)
		}
		d = del[idx]
		if (cols(d) > 1) {
			/* if idx is constant del[idx] becomes a row
			 *  vector					*/
			d = d'
		}
		/* quadrowsum treats missings as zero			*/
		Z[.,j] = quadrowsum((f1,-f2)):/d
		(void)expr._set_RE_parameters(b0,lvs[j])
		B[.,j] = b0'
	}
	if (k=missing(Z)) {
		/* not likely to happen, missings treated as zeros	*/
		expr.set_errmsg(sprintf("%g missing values found in random " +
			"effects derivative matrix",k))
		return(498)
	}
	return(0)
}

real scalar _menl_eval_F(class __menl_expr scalar expr, string scalar depvar,
			real colvector yhat)
{
	return(expr._eval_equation(yhat,depvar))
}

real scalar _menl_stripe2data(class __menl_expr scalar expr, 
			string matrix stripe, real matrix X)
{ 
	real scalar j, k1, k2, keq, n, cons
	real matrix eq, Xj
	string scalar vars, touse, depvar

	depvar = expr.depvars()[1]
	touse = expr.touse(depvar)
	n = sum(st_data(.,touse))
	X = J(n,0,0)

	eq = panelsetup(stripe,1)
	keq = rows(eq)
	for (j=1; j<=keq; j++) {
		k1 = eq[j,1]
		k2 = eq[j,2]
		Xj = J(n,0,0)
		if (cons=(stripe[k2,2]=="_cons")) {
			k2--
		}
		if (k2 >= k1) {
			vars = invtokens(stripe[|k1,2\k2,2|]')
			Xj = st_data(.,vars,touse)
			if (cols(Xj) != k2-k1+1) {
				/* should not happen			*/
				errprintf("stripe {bf:%s} generated a " +
					"model matrix with %g columns",vars,
					cols(X))
				return(492)
			}
		}
		if (cons) {
			Xj = (Xj,J(n,1,1))
		}
		X = (X,Xj)
	}
	return(0)
}

real scalar _menl_dFdBeta(class __menl_expr scalar expr, string scalar depvar,
			real matrix X, real vector b0, |real matrix T,
			real rowvector a)
{
	real scalar i, k, eps, del, bi, n, rc, cns, m
	real rowvector b, b1
	real colvector f1, f2

	pragma unset f1
	pragma unset f2

	eps = epsilon(1)^(1/3)
	b0 = b = expr.FE_parameters()
	k = cols(b)
	if (!k) {
		return(0)
	}
	cns = (rows(T) == k)
	if (cns) {
		b = b*T
		k = cols(b)
	}
	n = 0
	for (i=1; i<=k; i++) {
		bi = b[i]
		if (!bi) {
			del = eps
		}
		else {
			del = eps*(abs(bi)+eps)
		}

		b[i] = bi + del
		if (cns) {
			b1 = b*T' + a
		}
		else {
			b1 = b
		}
		(void)expr._set_FE_parameters(b1)
		if (rc=_menl_eval_F(expr,depvar,f1)) {
			/* put back originals				*/
			(void)expr._set_FE_parameters(b0)

			return(rc)
		}

		b[i] = bi - del
		if (cns) {
			b1 = b*T' + a
		}
		else {
			b1 = b
		}
		(void)expr._set_FE_parameters(b1)
		if (rc=_menl_eval_F(expr,depvar,f2)) {
			/* put back originals				*/
			(void)expr._set_FE_parameters(b0)

			return(rc)
		}
		if (!n) {
			n = length(f1)
			X = J(n,k,0)
		}
		/* quadrowsum treats missings as zero			*/
		X[.,i] = quadrowsum((f1,-f2)):/(2*del)	
		b[i] = bi
	}
	(void)expr._set_FE_parameters(b0)	// put back originals
	if (m=missing(X)) {
		/* not likely to happen, missings treated as zeros	*/
		expr.set_errmsg(sprintf("%g missing values found in fixed " +
				"effects derivative matrix",m))
		return(498)
	}
	if (cns) {
		X = X*T'
	}
	return(0)
}

real scalar _menl_modelmatrix(class __menl_expr scalar expr, 
		real colvector w, real matrix X,
		pointer (real matrix) vector vZ)
{
	real scalar rc, i, k
	string vector lvs
	real matrix Z
	string matrix stripe, paths
	pointer (struct _lvhinfo) scalar hinfo
	pointer (class __lvhierarchy) scalar hier

	pragma unset Z
	pragma unused w

	/* assumption: model is linear					*/
	/* w contains the depvar on input				*/
	/* TODO: use depvar name					*/
	stripe = expr.param_stripe()
	rc = _menl_stripe2data(expr,stripe,X)
	if (rc) {
		return(rc)
	}
	hier = expr.hierarchy()
	k = length(vZ)
	for (i=1; i<=k; i++) {
		vZ[i] = NULL
	}
	if (!hier->current_hierarchy_index()) {
		hier = NULL
		vZ = J(1,0,NULL)
		return(rc)
	}
	paths = hier->paths()
	hinfo = hier->current_hinfo()
	vZ = J(1,hinfo->kpath,NULL)
	hier = NULL
	k = 0
	for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
		lvs = paths[i,`MENL_HIER_LV_NAMES']
		if (rc=_menl_lv2data(expr,Z,lvs)) {
			break
		}
		vZ[++k] = &J(1,1,Z)
	}
	if (rc) {
		for (i=1; i<=k; i++) {
			vZ[i] = NULL
		}
		vZ = J(1,0,NULL)
	}
	hinfo = NULL

	return(rc)
}

real scalar _menl_linearize(class __menl_expr scalar expr,
			real colvector w, real matrix X,
			pointer (real matrix) vector vZ,
			|real matrix T, real rowvector a)
{
	real scalar i, k, rc, rc0
	real vector b
	real colvector y, idx
	real matrix Z, B
	string scalar path, depvar
	string vector lvs
	string matrix paths
	pointer (struct _lvhinfo) scalar hinfo
	pointer (class __lvhierarchy) scalar hier

	pragma unset y
	pragma unset b
	pragma unset idx
	pragma unset Z
	pragma unset B

	depvar = expr.depvars()[1]
	/* w contains depvar on input					*/
	y = w
	w = J(0,1,0)		// prevent no colvector error
	if (rc=_menl_eval_F(expr,depvar,w)) {
		return(rc)
	}
	rc0 = 0
	if (k=missing(w)) {
		expr.set_errmsg(sprintf("function evaluation resulted in " +
			"{bf:%g} missing %s",k,(k>1?"values":"value")))
		rc0 = 480
		_editmissing(w,0)
	}
	w = y-w
	if (rc=_menl_dFdBeta(expr,depvar,X,b,T,a)) {
		return(rc)
	}
	if (cols(b)) {
		w = w + X*b'
	}

	hier = expr.hierarchy()
	k = length(vZ)
	for (i=1; i<=k; i++) {
		vZ[i] = NULL
	}
	if (!hier->current_hierarchy_index()) {
		hier = NULL
		vZ = J(1,0,NULL)
		return(rc)
	}
	paths = hier->paths()
	hinfo = hier->current_hinfo()
	vZ = J(1,hinfo->kpath,NULL)

	hier = NULL
	k = 0
	for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
		lvs = paths[i,`MENL_HIER_LV_NAMES']
		path = paths[i,`MENL_HIER_PATH']
		if (rc=_menl_dFdb(expr,depvar,Z,B,path,lvs,idx)) {
			hinfo = NULL
			return(rc)
		}
		vZ[++k] = &J(1,1,Z)
		Z = rowsum(Z:*B[idx,.])
		w = w + Z
	}
	hinfo = NULL

	return(rc0)
}

void _menl_compute_precision_factor(class __stmatrix scalar cov,
		class __stmatrix psi, real scalar ldet)
{
	real scalar k
	real colvector s
	real matrix U, V, R
	string colvector lvc
	string matrix stripe

	pragma unset s
	pragma unset V

	k = cov.rows()
	psi.erase()
	if (!k | k!=cov.cols()) {
		return
	}
	U = cov.m()
	lvc = cov.colstripe()[.,2]
	lvc = usubstr(lvc,1,ustrpos(lvc,"["):-1)
	stripe = (J(k,1,""),lvc)

	_svd(U,s,V)
	if (any((s:<smallestdouble()))) {	
		R = J(rows(U),cols(V),.)
		ldet = .
	}
	else {	
		s = 1:/sqrt(s)
		ldet = sum(log(s))
		_transpose(V)
		_transpose(U)
		R = V*diag(s)*U
		R = (R+R'):/2
	}
	(void)psi.set_matrix(R)
	(void)psi.set_stripe(stripe)
}

void _menl_compute_ginv(real matrix cov, real matrix  ginv, real scalar ldet)
{
	real scalar k
	real colvector s
	real matrix U, V

	pragma unset s
	pragma unset V

	k = rows(cov)
	if (!k) {
		ldet = .
		ginv = J(0,0,0)
		return
	}
	U = cov
	_svd(U,s,V)
	ldet = sum(log(s))
	s = 1:/s
	_transpose(V)
	_transpose(U)
	ginv = V*diag(s)*U

	if (cols(cov) == k) {
		ginv = (ginv+ginv'):/2
	}
}

/* implementation: __menl_lbates					*/
void __menl_lbates::new()
{
	clear()
}

void __menl_lbates::destroy()
{
	clear()
}

void __menl_lbates::clear()
{
	real scalar i, k

	super.clear()

	k = length(m_delta)
	for (i=1; i<=k; i++) {
		m_delta[i] = NULL
	}
	m_delta = J(1,0,NULL)
	m_ldetdel = J(1,0,0)
	m_res_ldet = .
	m_s2 = .
	k = length(m_Z)
	for (i=1; i<=k; i++) {
		m_Z[i] = NULL
	}
	m_Z = J(1,0,NULL)
	k = length(m_bRE)
	for (i=1; i<=k; i++) {
		m_bRE[i] = NULL
	}
	m_bRE = J(1,0,NULL)
	m_bFE = J(1,0,0)
	m_w = J(0,1,0)
	m_missing = 0
}

real scalar __menl_lbates::algorithm()
{
	return(`MENL_LBATES')
}

void __menl_lbates::set_altconverged(real scalar converged)
{
	m_converged[`MENL_CONVERGED_ALT'] = (missing(converged)?0:converged!=0)
}

real scalar __menl_lbates::converged(|real scalar which)
{
	real scalar conv
	which = (missing(which)?`MENL_CONVERGED_BOTH':which)

	if (which==`MENL_CONVERGED_ALT' | which==`MENL_CONVERGED_MOPT') {
		return(m_converged[which])
	}
	conv = (m_converged[`MENL_CONVERGED_ALT']&
			m_converged[`MENL_CONVERGED_ALT'2])
	return(conv)
}

real rowvector __menl_lbates::FE_parameters()
{
	return(m_bFE)
}

real matrix __menl_lbates::VCE()
{
	return(super.VCE())
}

pointer (real matrix) vector __menl_lbates::RE_parameters()
{
	return(m_bRE)
}

pointer (real matrix) vector __menl_lbates::psi()
{
	return(m_delta)
}

real vector __menl_lbates::ldetpsi()
{
	return(m_ldetdel)
}

real scalar __menl_lbates::initialize(struct _menl_mopts scalar mopts)
{
	real scalar rc, vtype, ctype
	pointer (class __ecovmatrix) scalar var

	if (rc=super.initialize(mopts)) {
		return(rc)
	}
	m_converged[`MENL_CONVERGED_MOPT'] = `MENL_FALSE'

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
	var = NULL
	m_missing = 0

	return(rc)
}

real scalar __menl_lbates::reinitialize()
{
	return(super.reinitialize())
}

real colvector __menl_lbates::evaluate()
{
	return(J(0,1,0))
}

real scalar __menl_lbates::init_constraints(
			struct _menl_constraints scalar cns)
{
	if (!cns.C.rows()) {
		return
	}
	return(super.init_constraints(cns))
}

void __menl_lbates::init_parameters()
{
	m_bFE = m_expr->FE_parameters()
	m_kFEb = cols(m_bFE)
}

real scalar __menl_lbates::set_subexpr_coef(real vector b)
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
		m_errmsg = sprintf("{bf:__menl_lbates::set_subexpr_coef()}: " +
			"expected a vector of length at least %g but got %g",
			i2,kb)
		return(503)
	}
	bi = b[|i1\i2|]
	if (rc=m_expr->_set_FE_parameters(bi)) {
		m_errmsg = m_expr->errmsg()
		return(rc)
	}
	return(0)
}

real scalar __menl_lbates::run()
{
	return(super.run())
}

real scalar __menl_lbates::update_covariances(real scalar validate)
{
	real scalar i, k, rc, ldet, skipdiag
	real colvector r, sd, io
	real matrix R
	string scalar path, has, s
	string vector lvs
	pointer (class __pathcovmatrix) vector covs

	pragma unset ldet

	rc = 0
	covs = m_expr->path_covariances()
	k = length(covs)
	m_delta = J(1,k,NULL)
	m_ldetdel = J(1,k,.)
	if (!k) {
		return(0)
	}
	for (i=1; i<=k; i++) {
		covs[i]->compute_V()
		path = covs[i]->path()
		if (missing(covs[i]->m())) {
			if (0) {	// debug
				covs[i]->display(sprintf("cov[%s]",path))
			}
			m_errmsg = sprintf("covariance for path {bf:%s} " +
				"has missing values",path)
			covs = NULL
			return(506)
		}
		else if (validate) {
			sd = covs[i]->sd()
			io = (sd:<`MENL_SD_MIN_LIMIT')
			if (any(io)) {
				if (0) {   // debug
				 	printf("sd[%s]\n",path)
					sd
				}
				io = select(1::rows(sd),io)
				if (length(io) > 1) {
					has = "have"
					s = "s"
				}
				else {
					has = "has"
					s = ""
				}
				lvs = covs[i]->LVnames()
				lvs = lvs[io]:+"[":+path:+"]"
				lvs = invtokens(lvs,", ")
				/* validate is used during a line search
				 *  to determine if a step halve is
				 *  necessary				*/
				m_errmsg = sprintf("standard deviations for " +
					"%s%s {bf:%s} %s become smaller " +
					"than the limit of %g",
					m_expr->LATENT_VARIABLE,s,lvs[1],has,
					`MENL_SD_MIN_LIMIT')
				covs = NULL
				return(506)
			}
			R = covs[i]->R()
			skipdiag = `MENL_TRUE'
			r = vech(R,skipdiag)
			if (any(abs(r):>`MENL_COR_LIMIT')) {
				if (0) {	// debug
				 	printf("cor[%s]\n",path)
					R
				}
				/* validate is used during a line search
				 *  to determine if a step halve is
				 *  necessary				*/
				m_errmsg = sprintf("covariance for path " +
					"{bf:%s} has correlations exceeding " +
					"%g",path,`MENL_COR_LIMIT')
				covs = NULL
				return(506)
			}
		}
		m_delta[i] = &(covs[i]->precision_factor(ldet))

		if (missing(*m_delta[i])) {
			if (0) {	// debug
				covs[i]->display(sprintf("cov[%s]",path))
				printf("psi\n")
				*m_delta[i]
			}
			m_errmsg = sprintf("covariance for path {bf:%s} " +
				"is not positive definite",path)
			return(506)
		}
		m_ldetdel[i] = ldet
	}
	covs = NULL
	return(rc)
}

real scalar __menl_lbates::dFdb(real matrix Z, real matrix B, 
			string scalar path, string vector lvs,
			real colvector idx)
{
	return(_menl_dFdb(*m_expr,m_depvar,Z,B,path,lvs,idx))
}

real scalar __menl_lbates::linearize()
{
	real scalar rc
	real rowvector a
	real matrix T

	pragma unset a
	pragma unset T

	rc = 0
	m_w = m_y
	if (m_eq_LC) {	// equation is a linear combination
		rc = _menl_modelmatrix(*m_expr,m_w,m_X,m_Z)
	}
	else if (constraint_T_a(T,a)) {
		rc = _menl_linearize(*m_expr,m_w,m_X,m_Z,T,a)
	}
	else {
		rc = _menl_linearize(*m_expr,m_w,m_X,m_Z)
	}
	if (rc) {
		m_errmsg = sprintf("linearization failed: %s",m_expr->errmsg())
	}
	return(rc)
}

end
exit
