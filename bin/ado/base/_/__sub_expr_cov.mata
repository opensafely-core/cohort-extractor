*! version 1.0.5  04sep2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __stparam_vector.matah
quietly include `"`r(fn)'"'

findfile __recovmatrix.matah
quietly include `"`r(fn)'"'

findfile __ecovmatrix.matah
quietly include `"`r(fn)'"'

findfile __lvhierarchy.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __sub_expr.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_cov.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

void __sub_expr_cov::new()
{
	clear()

	/* estimation metrics for covariance parameters			*/
	COV_METRIC_USER = `SUBEXPR_METRIC_USER'
	COV_METRIC_EST = `SUBEXPR_METRIC_EST'
	COV_METRIC_VAR = `SUBEXPR_METRIC_VAR'
	COV_METRIC_SD = `SUBEXPR_METRIC_SD'
	COV_METRIC_RESID = `SUBEXPR_METRIC_RESID'
}

void __sub_expr_cov::destroy()
{
	clear()
}

void __sub_expr_cov::clear()
{
	real scalar i, k

	super.clear()

	k = length(m_pcovs)
	for (i=1; i<=k; i++) {
		if (m_pcovs[i] != NULL) {
			m_pcovs[i]->erase()
		}
		m_pcovs[i] = NULL
	}

	k = length(m_covs)
	for (i=1; i<=k; i++) {
		if (m_covs[i] != NULL) {
			m_covs[i]->erase()
		}
		m_covs[i] = NULL
	}
	m_covs = m_pcovs = J(1,0,NULL)	// RE and path covariances

	m_ijc = J(2,0,0)	// m_covs index range for each m_pcovs
	m_var.erase()		// residual covariance
}

real scalar __sub_expr_cov::set_param_from_spec(string scalar init, 
			|real scalar skip)
{
	real scalar rc, i, k, i1, i2, level
	string scalar errmsg
	real rowvector b, b1
	real matrix ix
	string matrix stripe
	class __stmatrix lnsig, athr, lnsd

	pragma unset errmsg

	if (has_LVs()) {
		level = `SUBEXPR_DIRTY_RESOLVED_COV'
	}
	else {
		level = `SUBEXPR_DIRTY_RESOLVED_EXP'
	}
	if (m_dirty > level) {
		m_errmsg = "parameter vector is not ready to be initialized"
		dirty_message()	// add error specifics
		return(301)
	}
	skip = (missing(skip)?`SUBEXPR_FALSE':(skip!=`SUBEXPR_FALSE'))
	b = m_param.m()
	stripe = m_param.colstripe()
	i2 = length(b)
	ix = (1,i2)
	k = length(m_covs)
	for (i=1; i<=k; i++) {
		if (m_covs[i]->ksdpar()) {
			lnsig = m_covs[i]->lnsigma()
			b = (b,lnsig.m())
			stripe = (stripe\lnsig.colstripe())
			i1 = i2 + 1
			i2 = i2 + lnsig.cols()
			ix = (ix\(i1,i2))
		}
		if (m_covs[i]->kcorpar()) {
			athr = m_covs[i]->athrho()
			b = (b,athr.m())
			stripe = (stripe\athr.colstripe())
			i1 = i2 + 1
			i2 = i2 + athr.cols()
			ix = (ix\(i1,i2))
		}
	}
	if (m_var.vtype() != m_var.NONE) {
		lnsd = m_var.lnsigma()
		b = (b,lnsd.m())
		stripe = (stripe\lnsd.colstripe())
		i1 = i2 + 1
		i2 = i1
		ix = (ix\(i1,i2))
		if (m_var.ksdpar()) {
			lnsig = m_var.sd_parameters()
			b = (b,lnsig.m())
			stripe = (stripe\lnsig.colstripe())
			i1 = i2 + 1
			i2 = i2 + lnsig.cols()
			ix = (ix\(i1,i2))
		}
		if (m_var.kcorpar()) {
			athr = m_var.cor_parameters()
			b = (b,athr.m())
			stripe = (stripe\athr.colstripe())
			i1 = i2 + 1
			i2 = i2 + athr.cols()
			ix = (ix\(i1,i2))
		}
	}
	rc = _parse_initial_vector(init,b,stripe,skip,errmsg)
	if (rc) {
		m_errmsg = errmsg
		return(rc)
	}
	b1 = b[|ix[1,1]\ix[1,2]|]
	(void)m_param.set_matrix(b1)
	i1 = 1
	for (i=1; i<=k; i++) {
		if (m_covs[i]->ksdpar()) {
			lnsig = m_covs[i]->lnsigma()
			i1++
			b1 = b[|ix[i1,1]\ix[i1,2]|]
			(void)m_covs[i]->set_lnsigma(b1)
		}
		if (m_covs[i]->kcorpar()) {
			athr = m_covs[i]->athrho()
			i1++
			b1 = b[|ix[i1,1]\ix[i1,2]|]
			(void)m_covs[i]->set_athrho(b1)
		}
		m_covs[i]->compute_V()
	}
	if (m_var.vtype() != m_var.NONE) {
		if (m_var.ksdpar()) {
			i1++
			b1 = b[|ix[i1,1]\ix[i1,2]|]
			(void)m_var.set_sd_parameters(b1)
		}
		if (m_var.kcorpar()) {
			i1++
			b1 = b[|ix[i1,1]\ix[i1,2]|]
			(void)m_var.set_cor_parameters(b1)
		}
		i1++
		b1 = b[ix[i1,1]]
		m_var.set_lnsigma(b1)
		/* do not compute residual variance without panel info	*/
	}
	k = length(m_pcovs)
	for (i=1; i<=k; i++) {
		m_pcovs[i]->compute_V()
	}
	return(0)
}

real scalar __sub_expr_cov::set_param_from_vec(real vector b)
{
	real scalar rc, k, k1, k2, kp, i

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_COV') {
		m_errmsg = "parameter vector is not ready to be initialized"
		dirty_message()	// add specifics

		return(301)
	}
	k1 = 1
	k2 = kp = m_param.cols()
	k = length(m_covs)
	for (i=1; i<=k; i++) {
		kp = kp + m_covs[i]->ksdpar() + m_covs[i]->kcorpar()
	}
	if (m_var.vtype() != m_var.NONE) {
		/* do not include factored variance			*/
		kp = kp + m_var.ksdpar() + m_var.kcorpar() + 1
	}
	if (kp != length(b)) {
		m_errmsg = sprintf("failed to initialize parameter vector; " +
			"expected a vector of length %g but got %g",
			kp,length(b))
		return(503)
	}
	if (k2) {
		if (rc=_set_FE_parameters(b[|k1\k2|])) {
			return(rc)
		}
	}
	if (k) {
		k1 = k2 + 1
		k2 = length(b)
		rc = _set_cov_parameters(b[|k1\k2|])
	}
	else if (m_var.vtype() != m_var.NONE) {
		k1 = k2 + 1
		k2 = cols(b)
		if (rc=_set_res_parameters(b[|k1\k2|])) {
			return(rc)
		}
	}
	return(rc)
}

real scalar __sub_expr_cov::set_param_by_stripe(real vector b,
			string matrix spec)
{
	return(super.set_param_by_stripe(b,spec))
}

real scalar __sub_expr_cov::set_param_by_index(real vector b, real vector index)
{
	return(super.set_param_by_index(b,index))
}

real scalar __sub_expr_cov::_set_cov_parameters(real vector b, 
			|real scalar resid)
{
	real scalar rc, k, k1, k2, kp, i, kk

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_COV') {
		m_errmsg = "parameter vector is not ready to be initialized"
		dirty_message()	// specifics

		return(301)
	}
	resid = (missing(resid)?`SUBEXPR_TRUE':`SUBEXPR_FALSE')
	kp = 0
	k = length(m_covs)
	for (i=1; i<=k; i++) {
		kp = kp + m_covs[i]->ksdpar() + m_covs[i]->kcorpar()
	}
	if (m_var.vtype()!=m_var.NONE & resid) {
		/* includes factored variance				*/
		kp = kp + m_var.ksdpar() + m_var.kcorpar() + 1
	}
	if (kp != length(b)) {
		m_errmsg = sprintf("failed to initialize covariance " +
			"parameter vector; expected a vector of length " +
			"%g but got %g",kp,length(b))
		return(503)
	}
	k2 = 0
	for (i=1; i<=k; i++) {
		kk = m_covs[i]->ksdpar()
		if (kk) {
			k1 = k2 + 1
			k2 = k2 + kk
			if (rc=m_covs[i]->set_lnsigma(b[|k1\k2|])) {
				m_errmsg = m_covs[i]->errmsg()
				return(rc)
			}
		}
		kk = m_covs[i]->kcorpar()
		if (kk) {
			k1 = k2 + 1
			k2 = k2 + m_covs[i]->kcorpar()
			if (rc=m_covs[i]->set_athrho(b[|k1\k2|])) {
				m_errmsg = m_covs[i]->errmsg()
				return(rc)
			}
		}
		m_covs[i]->compute_V()
	}
	if (resid & (m_var.vtype()!=m_var.NONE)) {
		k1 = k2 + 1
		k2 = cols(b)
		if (rc=_set_res_parameters(b[|k1\k2|])) {
			return(rc)
		}
	}
	k = length(m_pcovs)
	for (i=1; i<=k; i++) {
		m_pcovs[i]->compute_V()
	}
	return(0)
}

real scalar __sub_expr_cov::_set_residual_lnsd(real scalar lnsd)
{
	m_var.set_lnsigma(lnsd)

	return(0)
}

real scalar __sub_expr_cov::_set_res_parameters(real vector b)
{
	real scalar k1, k2, kk, rc

	rc = 0
	if (m_var.vtype() == m_var.NONE) {
		return(rc)
	}
	k2 = 1
	m_var.set_lnsigma(b[k2])

	kk = m_var.ksdpar()
	if (kk) {
		k1 = k2 + 1
		k2 = k2 + kk
		if (rc=m_var.set_sd_parameters(b[|k1\k2|])) {
			m_errmsg = m_var.errmsg()
			return(rc)
		}
	}
	kk = m_var.kcorpar()
	if (kk) {
		k1 = k2 + 1
		k2 = k2 + m_var.kcorpar()
		if (rc=m_var.set_cor_parameters(b[|k1\k2|])) {
			m_errmsg = m_var.errmsg()
			return(rc)
		}
	}
	return(rc)
}

class __stmatrix scalar __sub_expr_cov::stparameters()
{
	real scalar kfe, kcov
	class __stmatrix scalar cov, fe, vp

	fe = FE_stparameters()
	kfe = fe.cols()

	cov = cov_stparameters(COV_METRIC_USER)
	kcov = cov.cols()
	if (!kcov) {
		return(fe)
	}
	if (!kfe) {
		return(cov)
	}
	(void)vp.set_matrix((fe.m(),cov.m()))
	(void)vp.set_colstripe((fe.colstripe()\cov.colstripe()))
	(void)vp.set_rowstripe(fe.rowstripe())

	return(vp)
}

string matrix __sub_expr_cov::cov_stripe()
{
	string matrix stripe
	class __stmatrix scalar b

	b = cov_stparameters()
	/* must save in matrix before return				*/
	stripe = b.colstripe()

	return(stripe)
}

real rowvector __sub_expr_cov::cov_parameters()
{
	real rowvector b0
	class __stmatrix scalar b

	b = cov_stparameters()

	/* must save in matrix before return				*/
	b0 = b.m()

	return(b0)
}

void __sub_expr_cov::set_FE_parameters(real vector b, |string matrix spec)
{
	real scalar rc

	rc = _set_FE_parameters(b,spec)
	if (rc) {
		errprintf("{p}%s{p_end}\n",m_errmsg)
		exit(rc)
	}
}

real scalar __sub_expr_cov::_set_FE_parameters(real vector b,
			|string matrix spec)
{
	real scalar rc
	real rowvector b0

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		m_errmsg = "parameter vector is not ready to be initialized"
		dirty_message()	// specifics

		return(301)
	}
	rc = 0
	if (rows(spec)==0 | cols(spec)==0) { 	// set all parameters
		if (length(b) != m_param.cols()) {
			m_errmsg = sprintf("expected a vector of length %g " +
				"but got %g",m_param.cols(),length(b))
			rc = 503
		}
		else {
			if (rows(b) == 1) {
				rc = m_param.set_matrix(b)
			}
			else {
				rc = m_param.set_matrix(b')
			}
		}
	}
	else {
		if (rows(b) == 1) {
			b0 = b
		}
		else {
			b0 = b'
		}
		if (rc=m_param.set_coefficients(b0,spec)) {
			m_errmsg = m_param.errmsg()
		}
	}
	if (rc) {
		m_errmsg = sprintf("failed to initialize parameter vector; " +
				"%s",m_errmsg)
	}
	return(rc)
}

real rowvector __sub_expr_cov::FE_parameters()
{
	return(super.parameters())
}

class __stmatrix scalar __sub_expr_cov::FE_stparameters()
{
	return(super.stparameters())
}

class __stmatrix scalar __sub_expr_cov::cov_stparameters(|real scalar metric,
			real matrix J, real vector trans)
{
	real scalar i, k, rv, cv, re, ce, r1, c1, noratio
	real vector trans1
	real matrix b, Jv, Je, J1
	string matrix stripe
	class __stmatrix scalar bv, v

	pragma unset J1
	pragma unset trans1	// transformation flags

	metric = (missing(metric)?COV_METRIC_EST:metric)
	noratio = `SUBEXPR_FALSE'
	if (metric > COV_METRIC_RESID) {
		/* noratio only applies when the by() option is used	*/
		/* wish we had bit manipulation				*/
		metric = metric - COV_METRIC_RESID
		noratio = `SUBEXPR_TRUE'
	}
	k = length(m_covs)
	b = J(1,0,0)
	stripe = J(0,2,"")
	if (metric==COV_METRIC_VAR | metric==COV_METRIC_SD) {
		Jv = Je = J(0,0,0)
	}
	for (i=1; i<=k; i++) {
		if (metric == COV_METRIC_VAR) {
			v = m_covs[i]->params_var_metric(J1,trans1)
		}
		else if (metric == COV_METRIC_SD) {
			v = m_covs[i]->params_sd_metric(J1,trans1)
		}
		else { // metric == COV_METRIC_EST or COV_METRIC_USER
			v = m_covs[i]->params_est_metric()
		}
		if (v.cols()) {	// could be all fixed parameters
			b = (b,v.m())
			stripe = (stripe\v.colstripe())
			if (metric==COV_METRIC_VAR | metric==COV_METRIC_SD) {
				if (i == 1) {
					Jv = J1
					trans = trans1
				}
				else {
					/* should be square, r = c	*/
					rv = rows(Jv)
					cv = cols(Jv)
					r1 = rows(J1)
					c1 = rows(J1)
					Jv = ((Jv,J(rv,c1,0))\(J(r1,cv,0),J1))
					trans = (trans,trans1)
				}
			}
		}
	}
	if (m_var.vtype() != m_var.NONE) {
		if (metric == COV_METRIC_VAR) {
			v = m_var.params_metric("var",Je,trans1,noratio)
		}
		else if (metric == COV_METRIC_SD) {
			v = m_var.params_metric("sd",Je,trans1,noratio)
		}
		else { // metric == COV_METRIC_EST
			v = m_var.params_est_metric()
		}
		if (v.cols()) {
			/* can be empty if scaling			*/
			b = (b,v.m())
			stripe = (stripe\v.colstripe())
		}
	}
	(void)bv.set_matrix(b)
	(void)bv.set_colstripe(stripe)
	if (metric==COV_METRIC_VAR | metric==COV_METRIC_SD) {
		rv = rows(Jv)
		cv = cols(Jv)
		re = rows(Je)
		ce = cols(Je)
		if (!rv & !re) {
			/* unreachable, but just in case		*/
			return(bv)
		}
		if (!rv) {
			J = Je
			trans = trans1
		}
		else if (!re) {
			J = Jv
		}
		else {
			J = ((Jv,J(rv,ce,0))\(J(re,cv,0),Je))
			trans = (trans,trans1)
		}
	}
	return(bv)	
}

class __stmatrix scalar __sub_expr_cov::res_stparameters()
{
	return(m_var.params_est_metric())
}

class __stmatrix scalar __sub_expr_cov::stparameters()
{
	real scalar kfe, kcov
	class __stmatrix scalar cov, fe, vp

	fe = FE_stparameters()
	kfe = fe.cols()

	cov = cov_stparameters(COV_METRIC_USER)
	kcov = cov.cols()
	if (!kcov) {
		return(fe)
	}
	if (!kfe) {
		return(cov)
	}
	(void)vp.set_matrix((fe.m(),cov.m()))
	(void)vp.set_colstripe((fe.colstripe()\cov.colstripe()))
	(void)vp.set_rowstripe(fe.rowstripe())

	return(vp)
}

void __sub_expr_cov::compute_path_covariances()
{
	real scalar i, k

	k = length(m_pcovs)
	for (i=1; i<=k; i++) {
		m_pcovs[i]->compute_V()
	}
}

pointer (class __recovmatrix) vector __sub_expr_cov::re_covariances()
{
	return(m_covs)
}

pointer (class __recovmatrix) vector __sub_expr_cov::path_covariances()
{
	return(m_pcovs)
}

pointer (class __ecovmatrix) scalar __sub_expr_cov::res_covariance()
{
	if (m_var.vtype() != m_var.NONE) {
		return(&m_var)
	}
	return(NULL)
}

real scalar __sub_expr_cov::residual_var()
{
	if (m_var.vtype() == m_var.NONE) {
		return(.)
	}
	return(m_var.sigma2())
}

void __sub_expr_cov::display_covariances()
{
	real scalar i, k
	string scalar path, vtype, ctype

	k = length(m_covs)
	if (k) {
		printf("{txt}\nhierarchy covariances:\n")
		for (i=1; i<=k; i++) {
			path = m_covs[i]->path()
			vtype = m_covs[i]->svtype()
			ctype = m_covs[i]->sctype()
			printf("\n{res}%s{txt}:{res} %s{txt},{res} %s",
					path,vtype,ctype)
			m_covs[i]->display(path)
		}
	}
	if (m_var.vtype() != m_var.NONE) {
		vtype = m_var.svtype()
		ctype = m_var.sctype()
		printf("{txt}\nresidual covariance: {res}%s{txt}, {res}%s",
				vtype,ctype)
		if (m_var.cols()) {
			m_var.display("Residual")
		}
	}
}

void __sub_expr_cov::add_re_covariance(string vector LVnames, real scalar vtype,
			real scalar ctype, |real matrix fixpat)
{
	real scalar rc

	if (rc=_add_re_covariance(LVnames,vtype,ctype,fixpat)) {
		errprintf("{p}%s{p_end}\n",m_errmsg)
		exit(rc)
	}
}

real scalar __sub_expr_cov::_add_re_covariance(string vector LVnames,
			real scalar vtype, real scalar ctype,
			|real matrix fixpat)
{
	real scalar rc, i, j, k, k1
	real vector io, jo
	string scalar path
	string vector pnames, lvnames, allnames
	string matrix paths

	rc = 0
	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		m_errmsg = "not ready to set random effect covariance " +
			"structures"
		dirty_message()
		return(498)
	}
	LVnames = ustrtrim(LVnames)
	if (any(ustrlen(LVnames):==0)) {
		m_errmsg = sprintf("invalid %s name list specification",
			LATENT_VARIABLE)
		return(198)
	}
	/* paths = (LVnames,path), k x 2				*/
	paths = m_hierarchy.paths()
	if (!rows(paths)) {
		m_errmsg = sprintf("failed to add covariance for %s {bf:%s}; " +
			"model hierarchy is empty",LATENT_VARIABLE,LVnames[1])
		return(498)
	}
	k = length(LVnames)
	allnames = tokens(invtokens(paths[.,`HIERARCHY_LV_NAMES']'))
	if (!length(allnames)) {
		allnames = J(1,0,"")
	}
	/* expand wild card names based on latent variable names in RE
	 *  hierarchy paths, e.g. B* to B1 B2 B3			*/
	lvnames = J(1,0,"")
	for (i=1; i<=k; i++) {
		io = strmatch(allnames,LVnames[i])
		if (!any(io)) {
			if (ustrpos(LVnames[i],"*") | ustrpos(LVnames[i],"?")) {
				m_errmsg = sprintf("%s pattern {bf:%s} not " +
					"found",LATENT_VARIABLE,LVnames[i])
			}
			else {
				m_errmsg = sprintf("%s {bf:%s} not found",
					LATENT_VARIABLE,LVnames[i])
			}
			return(111)
		}
		lvnames = (lvnames,select(allnames,io))
	}
	lvnames = uniqrows(lvnames')'
	k = rows(paths)
	j = .
	for (i=1; i<=k; i++) {
		if (any(lvnames[1]:==tokens(paths[i,`HIERARCHY_LV_NAMES']))) {
			j = i
		}
	}
	pnames = tokens(paths[j,`HIERARCHY_LV_NAMES'])
	path = paths[j,`HIERARCHY_PATH']
	k = length(lvnames)
	k1 = length(pnames)
	jo = J(k,1,0)
	for (i=1; i<=k; i++) {
		io = (lvnames[i]:==pnames)
		if (!any(io)) {
			m_errmsg = sprintf("%ss {bf:%s} and {bf:%s} do not " +
				"share the same path; they cannot have a " +
				"covariance",LATENT_VARIABLE,lvnames[1],
				lvnames[i])
			return(198)
		}
		jo[i] = select(1..k1,io)[1]
	}
	/* keep lvnames in same order as hierarchy			*/
	jo = order(jo,1)
	if (cols(lvnames) == 1) {
		pnames = lvnames[jo]'
	}
	else {
		pnames = lvnames[jo]
	}
	if (!(k=length(m_covs))) {
		m_covs = &__recovmatrix(1)
	}
	else {
		m_covs = (m_covs,&__recovmatrix(1))
	}
	k++
	if (rc=m_covs[k]->construct(path,lvnames,(vtype,ctype),fixpat)) {
		m_errmsg = m_covs[k]->errmsg()
	}
	/* return reordered LV names					*/
	LVnames = lvnames

	return(rc)
}

real scalar __sub_expr_cov::_path_covariance(string scalar path,
			class __stmatrix scalar cov)
{
	real scalar i, kc, rc
	string scalar cpath, path0
	class __lvpath scalar lvpath

	if (!m_hierarchy.path_count()) {
		m_errmsg = sprintf("no %s paths have been defined",
				LATENT_VARIABLE)
		return(498)
	}
	if (rc=lvpath.init("tempname",path)) {
		m_errmsg = lvpath.errmsg()
		return(rc)
	}
	cpath = lvpath.path()
	/* assumption: covariances have been computed			*/
	kc = length(m_pcovs)
	i = 0
	while (++i <= kc) {
		path0 = m_pcovs[i]->path()
		if (cpath == path0) {
			break
		}
	}
	if (i > kc) {
		m_errmsg = sprintf("no covariance is defined for path %s",
			cpath)
		return(498)
	}
	(void)cov.set_matrix(m_pcovs[i]->m()) 
	(void)cov.set_stripe(m_pcovs[i]->colstripe())

	return(0)
}

void __sub_expr_cov::set_res_covariance(string scalar eq,
			real scalar vtype, |real scalar ctype,
			string vector vbyvar, string vector cbyvar,
			string vector tvar, string vector pvar,
			real scalar order)
{
	real scalar rc

	if (missing(ctype)) {
		ctype = m_var.INDEPENDENT
	}
	rc = _set_res_covariance(eq,vtype,ctype,vbyvar,cbyvar,pvar,tvar,order)
	if (rc) {
		errprintf("{p}%s{p_end}\n",m_errmsg)
		exit(rc)
	}
}

real scalar __sub_expr_cov::_set_res_covariance(string scalar eq, 
			real scalar vtype,
			|real scalar ctype, string vector vbyvar,
			string vector cbyvar, string vector pvar,
			string vector tvar, real scalar vorder,
			real vector corder)
{
	real scalar rc
	real matrix pvals, tvals, vbyvals, cbyvals

	pvals = tvals = J(0,0,0)
	if (missing(ctype) == 1) {
		ctype = m_var.INDEPENDENT
	}
	if (length(pvar) == 2) {
		/* must get matrix now; cannot access it within 
		 * __ecovmatrix::construct() method			*/
		pvals = st_matrix(pvar[2])
	}
	else if (!length(pvar)) {
		pvar = J(1,1,"")
	}
	if (length(tvar) == 2) {
		tvals = st_matrix(tvar[2])
	}
	else if (!length(tvar)) {
		tvar = J(1,1,"")
	}
	if (length(vbyvar) == 2) {
		/* retrieve levels matrix				*/
		vbyvals = st_matrix(vbyvar[2])
	}
	else if (!length(vbyvar)) {
		vbyvar = J(1,1,"")
	}
	if (length(cbyvar) == 2) {
		/* retrieve levels matrix				*/
		cbyvals = st_matrix(cbyvar[2])
	}
	else if (!length(cbyvar)) {
		cbyvar = J(1,1,"")
	}
	rc = m_var.construct(vtype,ctype,vbyvar[1],vbyvals,cbyvar[1],cbyvals,
		pvar[1],pvals,tvar[1],tvals,vorder,corder,touse(eq))
	if (rc) {
		m_errmsg = m_var.errmsg()
	}
	return(rc)
}

/* virtual function for special resolve handling 			*/
real scalar __sub_expr_cov::_resolve_group(
		pointer (class __component_group) scalar pG,
		pointer (class __component_group) vector pargrps)
{
	pragma unused pG
	pragma unused pargrps

	return(0)
}

void __sub_expr_cov::resolve_covariances()
{
	real scalar rc

	if (rc=_resolve_covariances()) {
		errprintf("{p}%s{p_end}\n",m_errmsg)
		exit(rc)
	}
}

real scalar __sub_expr_cov::_resolve_covariances()
{
	real scalar i, j, k, l, l1, kpath, kcov, kp, crossed, rc
	real vector io, types
	string scalar path
	string vector lvcov, lvnames, lvorder
	string matrix paths
	pointer (class __recovmatrix) scalar cov
	pointer (class __recovmatrix) vector covs

	if (m_dirty > `SUBEXPR_DIRTY_RESOLVED_EXP') {
		m_errmsg = "not ready to resolve random effect covariances"
		dirty_message()	// specifics

		return(498)
	}
	paths = m_hierarchy.paths()
	kpath = rows(paths)
	kcov = length(m_covs)
	for (i=1; i<=kpath; i++) {
		lvnames = tokens(paths[i,`HIERARCHY_LV_NAMES'])
		kp = length(lvnames)
		for (j=1; j<=kcov; j++) {
			lvcov = m_covs[j]->LVnames()
			k = length(lvcov)
			for (l=1; l<=k; l++) {
				if (any(io=(lvcov[l]:==lvnames))) {
					lvnames = select(lvnames,1:-io)
				}
			}
			if (!(kp=length(lvnames))) {
				break
			}
		}
		if (!kp) {
			/* all LV's for this path accounted for		*/
			continue
		}
		cov = &__recovmatrix(1)
		/* crossed effects currently not allowed		*/
		crossed = `SUBEXPR_FALSE'
		if (crossed | kp==1) {
			types = (cov->HOMOSKEDASTIC,cov->INDEPENDENT)
		}
		else {
			types = (cov->HETEROSKEDASTIC,cov->INDEPENDENT)
		}
		if (rc=cov->construct(paths[i,`HIERARCHY_PATH'],lvnames,
			types)) {
			m_errmsg = cov->errmsg()
			return(rc)
		}
		m_covs = (m_covs,cov)
		cov = NULL
	}
	/* order covariances using hierarchy order			*/
	m_ijc = J(2,0,0)
	covs = m_covs
	kcov = length(covs)
	l = 0
	m_pcovs = J(1,kpath,NULL)
	for (i=1; i<=kpath; i++) {
		l1 = l + 1
		lvorder = J(1,0,"")
		lvnames = tokens(paths[i,`HIERARCHY_LV_NAMES'])
		for (j=1; j<=kcov; j++) {
			lvcov = covs[j]->LVnames()
			if (any(lvcov[1]:==lvnames)) {
				m_covs[++l] = covs[j]
				/* ensure lv names in hierarchy are in
				 *  the same order as the covariances	*/
				lvorder = (lvorder,lvcov)
			}
		}
		m_ijc = (m_ijc,(l1\l))

		m_pcovs[i] = &__pathcovmatrix(1)
		m_pcovs[i]->set_re_covariances(m_covs[|l1\l|])

		path = paths[i,`HIERARCHY_PATH']
		/* potentially new order in the names			*/
		if (rc=m_hierarchy.set_path_LVname_order(path,lvorder)) {
			m_errmsg = m_hierarchy.errmsg()
			return(rc)
		}
	}
	for (i=1; i<=kcov; i++) {
		covs[i] = NULL
	}
	covs = J(1,0,NULL)

	m_dirty = `SUBEXPR_DIRTY_RESOLVED_COV'

	return(0)
}

void __sub_expr_cov::scale_covariances(real scalar scale,
			real scalar trace)
{
	real scalar i, k, s
	real rowvector sig
	string scalar smsg
	class __stmatrix scalar lnsig, lns

	lns = m_var.lnsigma()	     // log std.dev
	s = lns.m()
	if (scale == `MENL_SCALE_DIVIDE') {
		smsg = "/sigma^2"
	}
	k = length(m_covs)
	for (i=1; i<=k; i++) {
		lnsig = m_covs[i]->lnsigma()
		if (!lnsig.cols()) {
			continue
		}
		sig = lnsig.m()	// log std.dev
		if (scale == `MENL_SCALE_DIVIDE') {
			sig = sig:-s
		}
		else {
			sig = sig:+s
		}
		(void)m_covs[i]->set_lnsigma(sig)
	}
	/* recompute path covariances					*/
	k = length(m_pcovs)
	for (i=1; i<=k; i++) {
		m_pcovs[i]->compute_V()
		if (trace) {
			m_pcovs[i]->display(sprintf("cov(%s)%s",
				m_pcovs[i]->path(),smsg))
		}
	}
	if (trace) {
		m_var.display("Residual")

		printf("\n{txt}sigma = {res}%g\n\n",m_var.sigma())
	}
}

void __sub_expr_cov::cert_post()
{
	real scalar k, i
	string scalar name
	string matrix paths
	class __stmatrix scalar cov

	super.cert_post()

	paths = m_hierarchy.paths()
	k = rows(paths)
	for (i=1; i<=k; i++) {
		(void)_path_covariance(paths[i,`HIERARCHY_PATH'],cov)
		name = usubinstr(paths[i,`HIERARCHY_PATH'],">","_",100)
		name = usubinstr(name,"#","x",100)
		cov.st_matrix(sprintf("r(cov_%s)",name))
	}
	if (m_var.vtype() != m_var.NONE) {
		if (m_var.rows()) {
			/* caller did not use m_var.compute_V()		*/
			m_var.st_matrix("r(cov_Res)")
		}
	}
}

void __sub_expr_cov::return_post(|real scalar ereturn,string scalar eq)
{
	super.return_post(ereturn,eq)
}

string vector __sub_expr_cov::varlist(|string scalar ename, 
			real scalar nameonly)
{
	string scalar var
	string vector vlist

	vlist = super.varlist(ename,nameonly)

	var = m_var.byvarname(m_var.STDDEV)
	if (ustrlen(var)) {
		vlist = (vlist,var)
	}
	var = m_var.byvarname(m_var.CORR)
	if (ustrlen(var)) {
		vlist = (vlist,var)
	}
	var = m_var.indvarname(m_var.STDDEV)
	if (ustrlen(var)) {
		vlist = (vlist,var)
	}
	var = m_var.indvarname(m_var.CORR)
	if (ustrlen(var)) {
		vlist = (vlist,var)
	}
	var = m_var.tvar_name()
	if (ustrlen(var)) {
		vlist = (vlist,var)
	}
	var = m_var.pvar_name()
	if (ustrlen(var) & var!=`VAR_RESID_FITTED') {
		vlist = (vlist,var)
	}
	if (length(vlist)) {
		vlist = sort(uniqrows(vlist'),1)'
	}
	return(vlist)
}

real scalar __sub_expr_cov::_gen_hierarchy_panel_info(string scalar exprname,
			|string vector path, real scalar noegen)
{
	real scalar rc

	if (!(rc=super._gen_hierarchy_panel_info(exprname,path))) {
		noegen = (missing(noegen)?`SUBEXPR_FALSE':
				(noegen!=`SUBEXPR_FALSE'))
		/* residual covariance covariate, time-variable, and 
		 * by-variable view connections need to be 
		 * reestablished					*/
		m_var.reestablish_views(touse(exprname),noegen)
	}
	return(rc)
}

real scalar __sub_expr_cov::has_LVs()
{
	real scalar hasLV
	pointer (class __component_base) scalar pC

	hasLV = `SUBEXPR_FALSE'
	pC = iterator_init()
	while (pC != NULL) {
		if (pC->type() == `SUBEXPR_LV') {
			hasLV = `SUBEXPR_TRUE'
			break
		}
		pC = iterator_next()
	}
	pC = NULL

	return(hasLV)
}

void __sub_expr_cov::update_dirty_ready()
{
	real scalar level

	if (has_LVs()) {
		level = `SUBEXPR_DIRTY_RESOLVED_COV'
	}
	else {
		level = `SUBEXPR_DIRTY_RESOLVED_EXP'
	}
	if (m_dirty <= level) {
		m_dirty = `SUBEXPR_DIRTY_READY'
	}
}

void __sub_expr_cov::error_code(real scalar ec, |transmorphic arg1, 
		transmorphic arg2, transmorphic arg3, transmorphic arg4,
		transmorphic arg5)
{
	super.error_code(ec,arg1,arg2,arg3,arg4,arg5)
}

real scalar __sub_expr_cov::_parse_equation(string scalar expression,
			|string scalar eqname, string scalar touse)
{
	return(super._parse_equation(expression,eqname,touse))
}

real scalar __sub_expr_cov::_parse_expression(string scalar expression,
			|string scalar exname, string scalar touse)
{
	return(super._parse_expression(expression,exname,touse))
}

real scalar __sub_expr_cov::_parse_expr_init(string scalar exinit)
{
	return(super._parse_expr_init(exinit))
}

real scalar __sub_expr_cov::_resolve_expressions(|string scalar tvar,
			string scalar gvar)
{
	return(super._resolve_expressions(tvar,gvar))
}

void __sub_expr_cov::display_equations()
{
	super.display_equations()

	display_covariances()
}

void __sub_expr_cov::display_expressions()
{
	super.display_expressions()
}

end
exit
