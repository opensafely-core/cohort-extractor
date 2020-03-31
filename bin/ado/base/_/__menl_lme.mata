*! version 1.1.0  23aug2018

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

real scalar _menl_panel_factor_cov(real scalar ipanel, 
		pointer (real matrix) vector vhinfo,
		real matrix pinfo, pointer (real matrix) vector Z, 
		class __ecovmatrix scalar var,
		pointer (real matrix) vector vR, real matrix R,
		real rowvector p, |real colvector select)
{
	real scalar i, n, m, k, i1, i2, j1, j2, k1, k2, kh
	real scalar ip, ip1, ip2, scale, rc, resid, kp, rank
	real scalar selection
	real colvector sel
	real rowvector tau
	real matrix Zi, hinfo, V, R1, Ve, A

	selection = (rows(select)>0)
	kh = length(vhinfo)
	hinfo = *vhinfo[1]
	ip1 = ipanel
	i1 = hinfo[ip1,1]
	i2 = hinfo[ip1,2]
	if (selection) {
		sel = panelsubmatrix(select,ip1,hinfo)
		n = sum(sel)
	}
	else {
		n = i2-i1+1
	}

	scale = `MENL_TRUE'
	resid = `MENL_TRUE'
	if (var.vtype()==var.HOMOSKEDASTIC & var.ctype()==var.INDEPENDENT) {
		if (!var.bycount(var.STDDEV)) {
			resid = `MENL_FALSE'
		}
	}
	if (!resid) {
		R = I(n)
		_diag(R,J(n,1,var.sigma()))
	}
	else {
		ip = 1
		while (pinfo[ip,1]<i1) {
			ip++
			if (ip > rows(pinfo)) {
				/* should not happen			*/
				errprintf("invalid residual panels; cannot " +
					"proceed\n")
				exit(498)
			}
		}
		R = J(n,n,0)
		j2 = 0
		while (j2 < n) {
			if (selection) {
				sel = panelsubmatrix(select,ip,pinfo)
				m = sum(sel)
			}
			else {
				m = pinfo[ip,2]-pinfo[ip,1]+1
			}
			j1 = j2 + 1
			j2 = j2 + m

			if (rc=var.compute_V(pinfo[ip,.],scale)) {
				errprintf("{p}%s{p_end}\n",var.errmsg())
				exit(rc)
			}
			Ve = var.V()
			if (cols(Ve) == 1) {
				if (selection) {
					Ve = select(Ve,sel)
				}
				Ve = diag(sqrt(Ve))
			}
			else {
				if (selection) {
					Ve = select(Ve,sel)
					Ve = select(Ve,sel')
				}
				Ve = _menl_sqrt_matrix(Ve)
			}
			R[|j1,j1\j2,j2|] = Ve
			ip++
			if (ip>rows(pinfo) & j2<n) {
				/* should not happen			*/
				errprintf("invalid residual panels; cannot " +
					"proceed\n")
				exit(498)
			}
		}
	}
	for (i=1; i<=kh; i++) {
		V = *vR[i]
		k = rows(V)
		kp = j2 = 0
		ip2 = ip1-1
		while (j2 < n) {
			ip2++
			if (selection) {
				sel = panelsubmatrix(select,ip2,hinfo)
				m = sum(sel)
			}
			else {
				m = hinfo[ip2,2]-hinfo[ip2,1]+1
			}
			kp++
			j2 = j2 + m
			if (ip2>rows(hinfo) & j2<n) {
				/* should not happen		*/
				errprintf("invalid hierarchy; cannot proceed\n")
				exit(498)
			}
		}
		R1 = J(k*kp,n,0)
		j2 = k2 = 0
		for (ip=ip1; ip<=ip2; ip++) {
			if (selection) {
				sel = panelsubmatrix(select,ip,hinfo)
				m = sum(sel)
			}
			else {
				m = hinfo[ip,2]-hinfo[ip,1]+1
			}
			j1 = j2 + 1
			j2 = j2 + m
			k1 = k2 + 1
			k2 = k2 + k
			Zi = panelsubmatrix(*Z[i],ip,hinfo)
			if (selection) {
				Zi = select(Zi,sel)
			}
			R1[|k1,j1\k2,j2|] = V*Zi'
		}
		A = (R\R1)
		tau = p = .
		_hqrdp(A,tau,R,p)
		// rank = rank(R)
		rank = _menl_rank_R(R)
		if (rank<m & (i<kh | resid)) {
			if (!rank) {	// edge condition
				R = J(0,n,0)
			}
			else {
				R = R[|1,1\rank,n|]
			}
		}
		if (i < kh) {
			if (rank) {
				R = R[.,invorder(p)]
			}
			hinfo = *vhinfo[i+1]
			ip1 = 1
			while (hinfo[ip1,1]<i1) {
				ip1++
				if (ip1 > rows(hinfo)) {
					/* should not happen		*/
					errprintf("invalid hierarchy; " +
						"cannot proceed\n")
					exit(498)
				}
			}
		}
	}
	return(rank)
}

void __menl_lme::new()
{
	clear()
}

void __menl_lme::destroy()
{
	clear()
}

void __menl_lme::clear()
{
	super.clear()

	m_kREvc = 0
	m_iREvar = m_iREcor = J(0,2,0)
	m_profile = `MENL_FALSE'
	m_vsehier = `MENL_FALSE'
}

real scalar __menl_lme::algorithm()
{
	if (m_profile) {
		return(`MENL_LBATES_LME_PROFILE')
	}
	return(`MENL_LBATES_LME')
}

real scalar __menl_lme::profile_like()
{
	return(m_profile)
}

/* virtual: must define							*/
real matrix __menl_lme::VCE()
{
	return(super.VCE())
}

real scalar __menl_lme::initialize(real scalar profile,
			struct _menl_mopts scalar mopts) 
{
	real scalar i, k, count, rc
	colvector fitted
	pointer (class __ecovmatrix) vector var

	pragma unset fitted

	if (rc=super.initialize(mopts)) {
		return(rc)
	}
	init_parameters()	// sets m_bFE from m_expr->FE_parameters()

	if (m_reml) {
		if (!m_kFEb) {
			m_errmsg = "{bf:reml} not allowed without fixed " +
				"effects"
			return(498)
		}
	}
	var = m_expr->res_covariance()
	if (var->vtype() == var->NONE) {
		m_errmsg = "{bf:menl} model is not properly constructed; " +
			"residual variance is required"
		var = NULL
		return(498)
	}
	/* use profile likelihood?					*/
	m_profile = profile
	/* use the efficient hierarchical likelihood algorithm for 
	 *  computing variance component standard errors		*/
	m_vsehier = (mopts.special=="vsehier")

	moptimize_init_which(m_M, "max")
	moptimize_init_evaluator(m_M, &_menl_lme_eval())
	moptimize_init_evaluatortype(m_M, "d2")
	moptimize_init_technique(m_M, "nr") 

	moptimize_init_search(m_M, "off")

	m_hasscale = !m_profile
	count = `MENL_TRUE'	// first pass count the # equations
	m_keq = m_kFEeq = 0
	init_var(count)
	m_keq = m_ksigrho + m_kREvc

	moptimize_init_eq_n(m_M, m_keq)

	count = `MENL_FALSE'	// now initialize moptimize object
	init_var(count)
	if (!m_profile) {
		if (m_vsehier) {
			/* full likelihood using hierarchical efficient
			 *  algorithm and scaling X and Z		*/
			m_resid_scale = `MENL_TRUE'
		}
		else {
			/* full likelihood includes residual covariance
			 *  no scaling X and Z				*/
			m_resid_scale = `MENL_FALSE'
		}
 		moptimize_init_conv_maxiter(m_M, 0)
	}
	if (m_mopts.itracelevel > `MENL_TRACE_NONE') {
		if (m_reml) {
			moptimize_init_valueid(m_M,
				"linearization log restricted-likelihood")
		}
		else {
			moptimize_init_valueid(m_M,
				"linearization log likelihood")
		}
		printf("\n")
		if (m_mopts.itracelevel > `MENL_TRACE_VALUE') {
			printf("{txt}{hline 78}\n")
		}
		printf("{txt}LME step 1\n")
	}
	if (m_reml) {
		m_cons = 0
	}
	else {
		m_cons = m_n*log(2*pi())/2
	}
	m_w = J(0,1,0)
	m_X = J(0,0,0)
	k = length(m_Z)
	for (i=1; i<=k; i++) {
		m_Z[i] = NULL
	}
	m_Z = J(1,0,NULL)
	if (rc=linearize()) {
		/* rc == `MENL_RC_MISSING', function evaluated to
		 *  missing for at least one observation		*/
		if (rc != `MENL_RC_MISSING') {
			var = NULL
			return(rc)
		}
		rc = 0
	}
	if (m_resid_scale == `MENL_RESID_SCALE_FITTED') {
		if (!(rc=eval_F(fitted))) {
			if (m_missing=missing(fitted)) {
				_editmissing(fitted,0)
			}
			var->set_fitted(fitted)
		}
	}
	var = NULL
	if (!rc & m_resid_scale) {
		rc = update_resid_scale()
	}
	return(rc)
}

void __menl_lme::init_var(real scalar count)
{
	real scalar i, k, n, m, i2, ieq
	class __stmatrix sdpar, corpar
	pointer (class __recovmatrix) vector covs

	covs = m_expr->re_covariances()
	k = length(covs)
	i2 = 0
	ieq = 0
	if (count) {
		m_kREvc = 0
	}
	else {
		m_iREvar = m_iREcor = J(k,2,0)
	}
	for (i=1; i<=k; i++) {
		sdpar = covs[i]->lnsigma()
		corpar = covs[i]->athrho()
		n = covs[i]->ksdpar()
		m = covs[i]->kcorpar()
		if (count) {
			m_kREvc = m_kREvc + m + n
			continue
		}
		_init_var(sdpar, corpar, i, i2, ieq)
	}
	covs = NULL
	super.init_var(count, ieq, i2)
}

void __menl_lme::_init_var(class __stmatrix sdpar,
		class __stmatrix corpar, real scalar k, real scalar i2,
		real scalar ieq)
{
	real scalar j, m, n, i1
	real rowvector b
	string matrix stripe

	n = sdpar.cols()
	m = corpar.cols()
	if (n) {
		i1 = i2 + 1
		i2 = i2 + n
		m_iREvar[k,.] = (i1,i2)
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
		m_iREcor[k,.] = (i1,i2)
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
}

/* required to define since it is virtual				*/
real scalar __menl_lme::init_constraints()
{
	return(0)
}

void __menl_lme::init_parameters()
{
	return(super.init_parameters())
}

real scalar __menl_lme::reinitialize(|real scalar iter)
{
	real scalar rc, validate
	real colvector fitted
	pointer (class __ecovmatrix) vector var

	pragma unset fitted

	if (rc=super.reinitialize()) {
		return(rc)
	}
	init_parameters()	// sets m_bFE from m_expr->FE_parameters()

	validate = `MENL_FALSE'
	if (rc=update_covariances(validate)) {
		return(rc)
	}
	if (rc=linearize()) {
		/* rc == `MENL_RC_MISSING', function evaluated to 
		 *  missing for at least one observation		*/
		if (rc != `MENL_RC_MISSING') {
			return(rc)
		}
		rc = 0
	}
	if (m_resid_scale == `MENL_RESID_SCALE_FITTED') {
		var = m_expr->res_covariance()
		if (!(rc=eval_F(fitted))) {
			if (m_missing=missing(fitted)) {
				_editmissing(fitted,0)
			}
			var->set_fitted(fitted)
		}
		var = NULL
	}
	if (m_mopts.itracelevel > `MENL_TRACE_NONE') {
		printf("\n")
		if (m_mopts.itracelevel > `MENL_TRACE_VALUE') {
			printf("{txt}{hline 78}\n")
		}
		if (missing(iter)) {
			printf("{txt}Final LME step\n")
		}
		else {
			printf("{txt}LME step %g\n",iter)
		}
	}
	return(rc)
}

real scalar __menl_lme::set_subexpr_coef(|real vector b, real scalar validate)
{
	real scalar i, k, i1, i2, rc
	real scalar kr, ks
	real vector bi
	pointer (class __recovmatrix) vector covs

	if (!args()) {
		b = m_b
		validate = `MENL_FALSE'
	}
	else {
		validate = (missing(validate)?`MENL_FALSE':validate)
	}
 	/* flag for linearization if var parameters change		*/
	covs = m_expr->re_covariances()
	k = length(covs)
	if (!k) {
		covs = NULL
		return(0)
	}
	ks = rows(m_iREvar)
	kr = rows(m_iREcor)
	if (!ks & !kr) {
		/* should not happen					*/
		m_errmsg = "lme object not properly initialized"
		return(498)
	}
	for (i=1; i<=k; i++) {
		i1 = m_iREvar[i,1]
		if (i1) {
			i2 = m_iREvar[i,2]
			bi = b[|i1\i2|]
			if (rc=covs[i]->set_lnsigma(bi)) {
				m_errmsg = covs[i]->errmsg()
				covs = NULL
				return(rc)
			}
		}
		i1 = m_iREcor[i,1]
		if (i1) {
			i2 = m_iREcor[i,2]
			bi = b[|i1\i2|]
			if (rc=covs[i]->set_athrho(bi)) {
				m_errmsg = covs[i]->errmsg()
				covs = NULL
				return(rc)
			}
		}
	}
	covs = NULL
	if (!(rc=update_covariances(validate))) {
		rc = super.set_subexpr_var_coef(b)
	}
	return(rc)
}

real scalar __menl_lme::run(|real scalar upbFE)
{
	real scalar rc, bFE, validate

	/* upbFE in (MENL_COMP_LF,MENL_COMP_BFE,MENL_COMP_BRE)		*/
	upbFE = (missing(upbFE)?`MENL_COMP_LF':upbFE)

	if (rc=super.run()) {
		return(rc)
	}
	/* would be nice to have bit operators				*/
	bFE = mod(upbFE,`MENL_COMP_REML')
	if (m_profile & bFE!=`MENL_COMP_LF') {
		set_todo(0)	// no derivatives
		/* make sure FE parameters and residual variance are
		 * computed at optimum					*/
		(void)evaluate(upbFE)

		validate = `MENL_FALSE'
		rc = set_subexpr_coef(m_b,validate)
	}
	return(rc)
}

real colvector __menl_lme::evaluate(|real scalar compbvar)
{
	real scalar i, j, k, lf, rank, todo, s2, lf1
	real vector det
	real colvector w, c0, c1
	real rowvector bFE, p
	real matrix X, pinfo, R
	pointer (real matrix) Zj
	pointer (real matrix) vector Z, V, bRE
	pointer (struct _lvhinfo) scalar hinfo
	pointer (class __pathcovmatrix) vector covs
	pointer (class __ecovmatrix) vector var
	struct _menl_hier_decomp vector vD

	pragma unset rank
	pragma unset s2
	pragma unset bFE
	pragma unset bRE
	pragma unset vD

	/* compbvar in (MENL_COMP_LF,MENL_COMP_BFE,MENL_COMP_BRE)	*/
	compbvar = (missing(compbvar)?`MENL_COMP_LF':compbvar)

	hinfo = m_hierarchy->current_hinfo()
	covs = m_expr->path_covariances()
	w = m_w
	X = m_X		// data modified; retain originals
	if (m_resid_scale) {
		/* could be more efficient if we scale all matrices 
		 *  on one pass through the panels			*/
		resid_scale(w)	
		resid_scale(X)
	}
	Z = J(1,hinfo->kpath,NULL)
	V = J(1,hinfo->kpath,NULL)
	if (m_profile | m_vsehier) {
		det = J(1,hinfo->kpath,0)
	}
	j = 0
	for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
		Zj = &J(1,1,*m_Z[i])
		if (m_resid_scale) {
			resid_scale(*Zj)
		}
		Z[++j] = Zj

		if (m_profile | m_vsehier) {
			V[j] = &J(1,1,*m_delta[i])
			det[j] = m_ldetdel[i]
		}
		else {
			V[j] = &J(1,1,(covs[i]->sqrt_matrix()))
		}
	}
	Zj = NULL
	covs = NULL
	if (m_profile) {
		if (!compbvar | m_todo) {
			todo = `MENL_COMP_LF'
			lf = _menl_decompose_hier(todo,hinfo->hinfo,Z,X,w,V,
					det,rank,bFE,bRE,vD,m_select)
			k = length(m_bRE)
			for (i=1; i<=k; i++) {
				m_bRE[i] = NULL
			}
			m_bRE = J(1,0,NULL)
			m_bFE = J(1,0,0)
			m_s2 = .
		}
		else {
			todo = compbvar
			lf = _menl_decompose_hier(todo,hinfo->hinfo,Z,X,w,V,
					det,rank,m_bFE,m_bRE,vD,m_select)
		}
		lf = lf + _menl_profile_lf_update(vD,m_reml,m_n,rank,s2)
		if (compbvar & !m_todo) {
			m_s2 = s2
		}
		_menl_clear_hier_decomp(vD)
	}
	else if (m_vsehier) {
		var = m_expr->res_covariance()
		s2 = exp(2*var->lnsigma0())
		var = NULL
		todo = `MENL_COMP_BFE'
		lf = _menl_decompose_hier(todo,hinfo->hinfo,Z,X,w,V,det,
				rank,bFE,bRE,vD,m_select)
		k = length(bRE)
		for (i=1; i<=k; i++) {
			bRE[i] = NULL
		}
		bRE = J(1,0,NULL)
		c1 = *vD[1].c[2]
		lf1 = c1'c1

		if (rank) {
			c0 = *vD[1].c[1]
			R = *vD[1].R[1,1]
			if (m_reml) {
				lf = lf -
				sum(log(abs(diagonal(R[|1,1\rank,rank|]))))
			}
			if (vD[1].p[1] != NULL) {
				p = *vD[1].p[1]
				R = R[,p]
			}
			/* use m_bFE, not bFE computed from inv(R)*c0	*/
			c0 = c0 - R*m_bFE'
			lf1 = lf1 + c0'c0
		}
		lf = lf - lf1/2
		_menl_clear_hier_decomp(vD)
	}
	else {
		/* hinfo is the hierarchy panels
		 * pinfo is the residual panels				*/
		pinfo = m_hierarchy->current_panel_info()
		lf = eval_lme(hinfo->hinfo,pinfo,Z,X,w,V,rank)
	}
	if (m_resid_scale) {
		lf = lf - m_res_ldet/2
	}
	if (m_reml & !m_cons) {
		m_cons = (m_n-rank)*log(2*pi())/2
	}
	lf = lf - m_cons

	hinfo = NULL
	k = length(Z)
	for (i=1; i<=k; i++) {
		Z[i] = NULL
		V[i] = NULL
	}
	Z = J(1,0,NULL)
	V = J(1,0,NULL)

	return(lf)
}

real scalar __menl_lme::eval_lme(pointer(real matrix) vector hinfo, 
			real matrix pinfo,
			pointer (real matrix) vector Z, real matrix X,
			real colvector w, pointer (real matrix) vector vR,
			real scalar rank)
{
	real scalar i, ldet, lf, lfi, kx, kp, rank1, kr
	real scalar selection
	real rowvector p, q, tau
	real colvector b, r, sel
	real matrix Xi, R, R1, hinfo1
	pointer (class __ecovmatrix) scalar var

	pragma unset ldet
	pragma unset p
	pragma unset R
	pragma unset R1

	selection = (rows(m_select)>0)
	kx = cols(X)
	b = (m_expr->FE_parameters())'
	lf = 0
	hinfo1 = *hinfo[1]	// top panel
	kp = rows(hinfo1)
	var = m_expr->res_covariance()
	for (i=1; i<=kp; i++) {
		rank1 = _menl_panel_factor_cov(i,hinfo,pinfo,Z,*var,vR,R,p,
			m_select)
		if (m_todo) {
			ldet = sum(log(abs(diagonal(R)[|1\rank1|])))
		}
		else {
			ldet = sum(log(abs(diagonal(R))))
		}
		if (missing(ldet)) {
			m_errmsg = sprintf("covariance for panel %g is not " +
				"positive definite",i)
			var = NULL
			return(.)
		}
		r = panelsubmatrix(w,i,hinfo1)
		if (selection) {
			sel = panelsubmatrix(m_select,i,hinfo1)
			r = select(r,sel)
		}
		if (kx) {
			Xi = panelsubmatrix(X,i,hinfo1)
			if (selection) {
				Xi = select(Xi,sel)
			}
			r = r - Xi*b
		}
		q = r[p']
		rank = _solvelower(R',q)
		lfi = q'q/2+ldet

		lf = lf - lfi
		if (m_reml & kx) {
			Xi = Xi[p',.]
			rank = _solvelower(R',Xi)
			tau = p = .
			if (i > 1) {
				Xi = (R1\Xi)
			}
			if ((kr=rows(Xi)) < kx) {
				/* our QR cannot handle this		*/
				Xi = (Xi\J(kx-kr,kx,0))
			}
			_hqrdp(Xi,tau,R1,p)
			if (i < kp) {
				R1 = R1[.,invorder(p)]
			}
		}
	}
	var = NULL
	if (m_reml & kx) {
		ldet = .
		rank = _menl_rank_R(R1)
		if (rank) {
			/* may not be full rank due to factor var	*/
			ldet = sum(log(abs(diagonal(R1)[|1\rank|])))
		}
		lf = lf - ldet
	}
	return(lf)
}

end
exit

