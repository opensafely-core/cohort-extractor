*! version 1.1.5  11dec2018

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __menl_expr.matah
quietly include `"`r(fn)'"'

findfile __menl_lbates.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

void __menl_pnls::new()
{
}

void __menl_pnls::destroy()
{
}

void __menl_pnls::clear()
{
	real scalar i, k

	super.clear()

	m_condFE = `MENL_FALSE'
	m_R = J(0,0,0)
	m_p = J(1,0,0)
	k = length(m_seRE)
	for (i=1; i<=k; i++) {
		m_seRE[i] = NULL
	}
	m_seRE = J(1,0,NULL)
}

real scalar __menl_pnls::algorithm()
{
	return(`MENL_LBATES_PNLS')
}


real scalar __menl_pnls::initialize(struct _menl_constraints scalar cns,
			struct _menl_mopts scalar mopts,
			|real scalar condFE)
{
	real scalar validate, rc
	real colvector f
	pointer (class __ecovmatrix) scalar var

	pragma unset f

	if (rc=super.initialize(mopts)) {
		return(rc)
	}
	m_condFE = (missing(condFE)?`MENL_FALSE':(condFE!=`MENL_FALSE'))
	if (m_mopts.itracelevel>`MENL_TRACE_NONE') {
		if (m_mopts.itracelevel > `MENL_TRACE_VALUE') {
			printf("{txt}{hline 78}\n")
		}
		else {
			printf("\n")
		}
		printf("{txt}PNLS step 1\n")
	}
	if (m_resid_scale == `MENL_RESID_SCALE_FITTED') {
		if (rc=eval_F(f)) {
			return(rc)
		}
		var = m_expr->res_covariance()
		var->set_fitted(f)
		var = NULL
	}
	validate = `MENL_FALSE'
 	/* computes precision factors					*/
	if (rc=update_covariances(validate)) {
		return(rc)
	}
	if (m_resid_scale) {
		if (rc=update_resid_scale()) {
			return(rc)
		}
	}
	init_parameters()
	if (!m_kFEb) {
		m_condFE = `MENL_FALSE'
		m_stripe = J(0,2,"")
		m_iFEeq = J(0,2,0)
		m_kFEeq = 0
	}
	else {
		m_stripe = m_expr->param_stripe()
		m_iFEeq = panelsetup(m_stripe,1)
		m_kFEeq = rows(m_iFEeq)
		rc = init_constraints(cns)
	}
	return(rc)
}

real scalar __menl_pnls::reinitialize(real scalar iter)
{
	real scalar rc, validate
	real colvector f
	pointer (class __ecovmatrix) scalar var

	pragma unset f

	if (rc=super.reinitialize()) {
		return(rc)
	}
	validate = `MENL_FALSE'
 	/* computes precision factors					*/
	if (rc=update_covariances(validate)) {
		return(rc)
	}
	if (m_resid_scale==`MENL_RESID_SCALE_FITTED') {
		if (rc=eval_F(f)) {
			return(rc)
		}
		var = m_expr->res_covariance()
		var->set_fitted(f)
		var = NULL
	}
	if (m_resid_scale) {
		rc = update_resid_scale()
		if (rc) {
			return(rc)
		}
	}
	if (!m_condFE & m_mopts.itracelevel>`MENL_TRACE_NONE' & 
		m_mopts.maxiter>0) {
		printf("\n")
		if (m_mopts.itracelevel > `MENL_TRACE_VALUE') {
			printf("{txt}{hline 78}\n")
		}
		printf("{txt}PNLS step %g\n",iter)
	}
	init_parameters()

	return(rc)
}

void __menl_pnls::init_parameters()
{
	real scalar i, j, k, klev, klv
	real rowvector b
	real matrix B
	string vector lv
	string matrix paths
	pointer (struct _lvhinfo) scalar hinfo

	super.init_parameters()

	paths = m_hierarchy->paths()
	hinfo = m_hierarchy->current_hinfo()
	klev = hinfo->kpath
	m_bRE = J(1,klev,NULL)
	k = 0
	for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
		lv = tokens(paths[i,`MENL_HIER_LV_NAMES'])
		klv = length(lv)
		b = m_expr->RE_parameters(lv[1])
		B = J(1,klv,b')
		for (j=2; j<=klv; j++) {
			b = m_expr->RE_parameters(lv[j])
			B[.,j] = b'
		}
		m_bRE[++k] = &J(1,1,B)
	}
	hinfo = NULL
}

real scalar __menl_pnls::init_constraints(struct _menl_constraints scalar cns)
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
	rc = _menl_FE_constraints(cns,m_stripe,m_cns,m_errmsg)

	return(rc)
}

real scalar __menl_pnls::set_subexpr_coef(|real rowvector bFE, 
			pointer (real matrix) vector bRE)
{
	real scalar i, j, k, rc, klev, klv, ka
	string vector lv
	string matrix paths
	real vector b
	pointer (struct _lvhinfo) scalar hinfo

	hinfo = m_hierarchy->current_hinfo()
	klev = hinfo->kpath
	paths = m_hierarchy->paths()
	if ((ka=args())) {
		if (m_condFE == `MENL_FALSE') {
			if (rc=m_expr->_set_FE_parameters(bFE)) {
				m_errmsg = m_expr->errmsg()
				hinfo = NULL
				return(rc)
			}
			/* sanity check					*/
			if (length(bRE) != klev) {
				hinfo = NULL
				m_errmsg = sprintf("failed to set model " +
					"parameters; expected matrix pointer " +
					"vector of length %g but got %g",ka,
					length(bRE))
				return(502)
			}
		}
	}
	else if (m_condFE == `MENL_FALSE') {
		if (rc=m_expr->_set_FE_parameters(m_bFE)) {
			m_errmsg = m_expr->errmsg()
			hinfo = NULL
			return(rc)
		}
	}
	k = 0
	for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
		lv = tokens(paths[i,`MENL_HIER_LV_NAMES'])		
		klv = length(lv)
		k++
		if (ka) {
			/* sanity check					*/
			if (cols(*bRE[k]) != klv) {
				hinfo = NULL
				m_errmsg = sprintf("failed to set model " +
					"parameters; expected matrix with %g " +
					"columns but got %g",klv,cols(*bRE[i]))
				return(502)
			}
		}
		for (j=1; j<=klv; j++) {
			if (ka == 2) {
				b = (*bRE[k])[.,j]'
			}
			else {
				b = (*m_bRE[k])[.,j]'
			}
			if (rc=m_expr->_set_RE_parameters(b,lv[j])) {
				m_errmsg = m_expr->errmsg()
				hinfo = NULL
				return(rc)
			}
		}
	}
	hinfo = NULL
	return(rc)
}

real colvector __menl_pnls::evaluate()
{
	real scalar sel, rc
	real colvector r, r1

	pragma unset r

	if (rc=eval_F(r)) {
		errprintf("{p}%s{p_end}",m_errmsg)
		exit(rc)
	}
	sel = (rows(m_select)>0)
	if (sel) {
		r1 = r
	}
	if (m_missing=missing(r)) {
		_editmissing(r,0)
	}
	r = m_y-r
	if (m_resid_scale) {
		resid_scale(r)
	}
	if (sel) {
		if (m_missing) {
			r1 = select(r1,m_select)
			m_missing = missing(r1)
		}
		r = select(r,m_select)
	}
	r = (r\penalize_vector())

	return(r)
}

void __menl_pnls::display_trace(real scalar iter, real scalar sse,
			|real vector prd, real scalar sgrad)
{
	class __stmatrix scalar b

	if (m_mopts.itracelevel == `MENL_TRACE_NONE') {
		return
	}
	printf("{txt}Iteration %f: {col 15} SSE = {res}%12.0g\n",iter,sse)
	if (m_mopts.itracelevel<=`MENL_TRACE_VALUE') {
		return
	}
	if (iter > 0) {
		printf("{txt}Max relative differences:\n")
		printf("{txt}FE:{col 7}{res}%12.4e{col 30}{txt}" +
			"tolerance:{col 42}{res}%12.4e\n",prd[1],m_mopts.tol)
		printf("{txt}RE:{col 7}{res}%12.4e\n",prd[2])
		printf("{txt}SSE:{col 7}{res}%12.4e{col 30}{txt}" +
			"ltolerance:{col 42}{res}%12.4e\n",prd[3],m_mopts.ltol)
		if (!missing(sgrad)) {
			printf("\n{txt}scaled grad:{col 7}{res}%12.4e{col 30}" +
				"{txt}nrtolerance:{col 42}{res}%12.4e\n",
				sgrad,m_mopts.nrtol)
		}
	}
	if (m_mopts.itracelevel <= `MENL_TRACE_TOLERANCE') {
		return
	}
	(void)b.set_matrix(m_bFE,"_parameters")
	(void)b.set_colstripe(m_stripe)
	(void)b.set_rowstripe(("","FE"))
	
	b.display("fixed effects")
	b.erase()
	printf("{txt}{hline 78}\n")
}

real scalar  __menl_pnls::run(|real scalar reses)
{
	real scalar i, j, k, iter, rc, sse0, sse, condFE
	real scalar klev, khalf, mxd, mxf, mxr, mx, conv, kx
	real scalar missing, conv1, sgrad, srdif
	real rowvector bFE
	real colvector r
	pointer (real matrix) vector bRE
	pointer (struct _lvhinfo) scalar hinfo
	struct _menl_hier_decomp vector vD

	pragma unset bFE
	pragma unset bRE
	pragma unset vD

	reses = (args()?(reses!=`MENL_FALSE'):`MENL_FALSE')
	m_errmsg = ""
	rc = 0
	khalf = 10
	hinfo = m_hierarchy->current_hinfo()
	klev = hinfo->kpath

	missing = `MENL_FALSE'	// ignore missings, report later
	sse0 = sse = sum(evaluate():^2,missing)
	display_trace(0,sse0)
	conv = `MENL_FALSE'
	kx = (m_condFE==`MENL_TRUE'?0:m_kFEb)
	if (!m_mopts.maxiter) {
		condFE = `MENL_FALSE'
		if (!(rc=eval_GN(bFE,bRE,*hinfo,vD,condFE))) {
			if (m_kFEb) {
				m_b = m_bFE
				m_R = *vD[1].R[1,1]
				if (vD[1].p[1] != NULL) {
					m_p = *vD[1].p[1]
				}
				else {
					m_p = J(1,0,0)
				}
			}
			else {
				m_b = J(1,0,0)
				m_R = J(0,0,0)
				m_p = J(1,0,0)
			}
			if (reses) {
				compute_RE_stderrs(*hinfo,vD,m_seRE)
				rc = m_expr->_set_RE_stderr(m_seRE)
			}
		}
		goto Clean
	}
	mxd = 0
	sgrad = .
	conv1 = `MENL_FALSE'
	for (iter=1; iter<=m_mopts.maxiter; iter++) {
		sse0 = sse
		if (rc=eval_GN(bFE,bRE,*hinfo,vD,m_condFE)) {
			goto Clean
		}
		/* line search						*/
		for (j=1; j<=khalf; j++) {
			/* ignores bFE if m_condFE == `MENL_TRUE'	*/
			if (rc=set_subexpr_coef(bFE,bRE)) {
				goto Clean
			}
			r = evaluate()
			sse = sum(r:^2,missing)
			mxd = mxf = mxr = 0
			if (kx) {
				mxf = max(abs(bFE-m_bFE):/(abs(m_bFE):+
					`MENL_REL_ZERO'))
			}
			for (i=1; i<=klev; i++) {
				mx = max(abs(*bRE[i]-*m_bRE[i]):/
					(abs(*m_bRE[i]):+
					`MENL_REL_ZERO'))
				if (mx > mxr) {
					mxr = mx
				}
			}
			mxd = max((mxf,mxr))
			if (!missing(sse)) {
				if (sse-sse0 < 0) {
					break
				}
			}
			if (kx) {
				bFE = (bFE+m_bFE):/2
			}
			for (i=1; i<=klev; i++) {
				bRE[i] = &J(1,1,((*bRE[i])+(*m_bRE[i])):/2)
			}
		}
		if (missing(sse) | sse-sse0>sse0*m_eps) {
			srdif = .
			if (kx) {
				m_b = bFE = m_bFE
				for (i=1; i<=klev; i++) {
					bRE[i] = &J(1,1,(*m_bRE[i]):/2)
				}
				(void)eval_GN(bFE,bRE,*hinfo,vD,m_condFE)

				m_R = *vD[1].R[1,1]
				if (vD[1].p[1] != NULL) {
					m_p = *vD[1].p[1]
				}
				else {
					m_p = J(1,0,0)
				}
			}
			break
		}
		srdif = abs(sse-sse0)/(sse0+`MENL_REL_ZERO')
		conv1 = (srdif<m_mopts.ltol | mxd<m_mopts.tol)
		if (conv1) {
			sgrad = compute_scaled_grad(kx,*hinfo,r,vD)
		}
		if (kx) {
			m_bFE = m_b = bFE
			m_R = *vD[1].R[1,1]
			if (vD[1].p[1] != NULL) {
				m_p = *vD[1].p[1]
			}
			else {
				m_p = J(1,0,0)
			}
		}
		j = 0
		for (i=hinfo->hrange[1]; i<=hinfo->hrange[2]; i++) {
			m_bRE[i] = &J(1,1,*bRE[++j])
		}
		display_trace(iter,sse,(mxf,mxr,srdif),sgrad)
		if (conv1 & (sgrad<m_mopts.nrtol|m_mopts.nonrtol)) {
			conv = `SUBEXPR_TRUE'
			break
		}
	}
	m_fun_value = sse
	if (m_missing & !m_condFE) {
		printf("{p 0 6 2}{txt}note: function evaluation " +
			"resulted in {res}%g {txt}missing %s" +
			"{p_end}\n",m_missing,(m_missing>1?"values":"value"))
		conv = `MENL_FALSE'
	}
	else if (!conv & (missing(sse) | sse-sse0>sse0*m_eps)) {
		if (m_mopts.log == `MENL_TRUE') {
			printf("{p 0 6 2}{txt}note: reduction in the sum of " +
				"squares could not be achieved in %g step " +
				"reductions{p_end}",khalf)
		}
		conv = `MENL_FALSE'
		sse = m_fun_value = sse0
		m_converged[`MENL_CONVERGED_MOPT'] = `MENL_FALSE'
	}
	else if (conv == `MENL_FALSE') {
		m_errmsg = sprintf("convergence not achieved in %g iterations",
			m_mopts.maxiter)
		m_converged[`MENL_CONVERGED_MOPT'] = `MENL_FALSE'
		rc = 0 
	}
	else {
		m_converged[`MENL_CONVERGED_MOPT'] = `MENL_TRUE'
	}

	/* ignores bFE if m_condFE == `MENL_TRUE'			*/
	if (rc=set_subexpr_coef()) {
		goto Clean
	}
	if (reses) {
		condFE = `MENL_FALSE'
		if (!(rc=eval_GN(bFE,bRE,*hinfo,vD,condFE))) {
			compute_RE_stderrs(*hinfo,vD,m_seRE)
			rc = m_expr->_set_RE_stderr(m_seRE)
		}
	}

	Clean:			// clean up pointer use
	hinfo = NULL
	k = length(bRE)
	for (i=1; i<=k; i++) {
		bRE[i] = NULL
	}
	bRE = J(1,0,NULL)
	_menl_clear_hier_decomp(vD)

	return(rc)
}

real scalar __menl_pnls::compute_scaled_grad(real scalar kx,
			struct _lvhinfo scalar hinfo, real colvector r,
			struct _menl_hier_decomp vector vD)
{
	real scalar sgrad, sgrad1, k, i
	real colvector g
	real matrix R
	pointer (real matrix) vector seRE
	
	pragma unset sgrad1
	pragma unset seRE

	sgrad = 0
	r = r[|1\m_n|]
	if (kx) {
		R = *vD[1].R[1,1]
		if (cols(R) > rows(R)) {
			/* not full rank	*/
			R = R[|1,1\rows(R),rows(R)|]
		}
		if (rows(m_select)==rows(m_X)) {
			g = 2:*colsum(r:*select(m_X,m_select))'
		}
		else {
			g = 2:*colsum(r:*m_X)'
		}
		if (vD[1].p[1] != NULL) {
			/* must reinvert order	*/
			g = g[invorder(*vD[1].p[1])]
		}
		k = rows(R)
		if (k < rows(g)) {
			g = g[|1\k|]
		}
		(void)_solvelower(R',g)
		sgrad = g'g
	}
	compute_RE_stderrs(hinfo,vD,seRE,r,sgrad1)
	sgrad = sgrad + sgrad1
	k = length(seRE)
	for (i=1; i<=k; i++) {
		seRE[i] = NULL
	}
	seRE = J(1,0,NULL)

	return(sgrad)
}

real scalar __menl_pnls::eval_GN(real rowvector bFE,
		pointer (real matrix) vector bRE,
		struct _lvhinfo scalar hinfo,
		struct _menl_hier_decomp vector vD,
		real scalar condFE)
{
	real scalar rc, todo, rank, lf, k, i, s2
	real colvector w
	pointer (real matrix) vector Z

	pragma unset s2
	pragma unset rank
	pragma unset Z

	if (rc=linearize_scale(hinfo,Z)) {
		goto Clean
	}
	todo = `MENL_COMP_BRE'
	if (condFE) {
		/* condition on fixed effects; iterate(0) or postestimation,
		 *  need random effect BLUPs 				*/
		w = m_w - m_X*m_bFE'
		lf = _menl_decompose_hier(todo,hinfo.hinfo,Z,J(0,0,0),w,
			m_delta,m_ldetdel,rank,bFE,bRE,vD,m_select)
	}
	else {
		if (m_reml) {
			/* do not really need REML for PNLS
			 *  REML influences RE standard errors		*/
			todo = todo + `MENL_COMP_REML'
		}
		lf = _menl_decompose_hier(todo,hinfo.hinfo,Z,m_X,m_w,
			m_delta,m_ldetdel,rank,bFE,bRE,vD,m_select)
	}
	if (0) { 	// debug
		lf = lf + _menl_profile_lf_update(vD,m_reml,m_n,rank,s2)
		if (m_resid_scale) {
			lf = lf - m_res_ldet/2
		}
		if (m_reml) {
			lf = lf - (m_n-rank)*log(2*pi())/2
		}
		else {
			lf = lf - m_n*log(2*pi())/2
		}
	}
	Clean:
	k = length(Z)
	for (i=1; i<=k; i++) {
		Z[i] = NULL
	}
	Z = J(1,0,NULL) 

	return(rc)
}

real scalar __menl_pnls::linearize_scale(struct _lvhinfo scalar hinfo,
		pointer (real matrix) vector Z)
{
	real scalar i, j, klev, rc
	pointer (real matrix) scalar Zi

	klev = hinfo.kpath
	Z = J(1,klev,NULL)
	if (rc=linearize()) {
		/* missing value code, let through for now		*/
		if (rc != `MENL_RC_MISSING') {
			return(rc)
		}
		rc = 0
	}
	if (m_resid_scale) {
		resid_scale(m_w)
		resid_scale(m_X)
	}
	j = 0
	/* for now hinfo.hrange[1] starts at 1, but create a new
	 *  Z vector of length klev anyway				*/
	for (i=hinfo.hrange[1]; i<=hinfo.hrange[2]; i++) {
		Z[++j] = m_Z[i]
		if (m_resid_scale) {
			Zi = Z[j]
			/* pass by reference lost for array elements	*/
			resid_scale(*Zi)
		}
	}
	Zi = NULL

	return(rc)
}

void __menl_pnls::compute_RE_stderrs(struct _lvhinfo scalar hinfo,
			struct _menl_hier_decomp vector vD,
			pointer (real matrix) vector seRE,
			|real colvector r, real scalar sgrad)
{
	real scalar i, j, ih, klev, kp, klv, kr, kc
	real scalar j1, ip, ipp, ipc, s, rank, FEadj, select
	real scalar k1, k2
	real vector compsg, jp
	real rowvector b, p, tau, rj
	real colvector g, sel
	real matrix R, R0, Ri, Rj, Rij, H, SE, Zj, pinfo, B
	string vector lvs
	string matrix paths
	struct _menl_Rii vector Rii
	pointer (class __ecovmatrix) scalar var

	pragma unset R

	select = (rows(m_select)>0)
	/* compsg: flag to compute scaled gradient for convergence
	 * 	 check							*/
	if (compsg=(args()>3)) {
		sgrad = 0
	}
	paths = m_hierarchy->paths()
	klev = hinfo.kpath
	seRE = J(1,klev,NULL)	// RE standard errors
	Rii = _menl_Rii(klev)
	/* if conditioning on FE (postestimation RE BLUPs),
	 *  m_condFE==`MENL_TRUE', there will be no R matrix for the 
	 *  FE even if computing REML					*/
	FEadj = (m_reml & vD[1].R[1,1]!=NULL)
	if (FEadj) {
		R0 = *vD[1].R[1,1]
		Ri = I(cols(R0))
		if (rows(R0) < cols(R0)) {
			/* not full rank				*/
			Ri = Ri[|1,1\rows(R0),cols(Ri)|]
		}
		R0 = _menl_solveupper(R0,Ri,vD[1].p[1])
	}
	var = m_expr->res_covariance()
	s = var->sigma()
	var = NULL
	j = 0
	for (ih=hinfo.hrange[1]; ih<=hinfo.hrange[2]; ih++) {
		lvs = tokens(paths[ih,`MENL_HIER_LV_NAMES'])
		k2 = 0
		klv = length(lvs)

		pinfo = *hinfo.hinfo[++j]
		j1 = j+1
		jp = J(1,klev,1)
		kp = rows(pinfo)
		SE = J(kp,klv,0)
		Rii[j].R = J(1,kp,NULL)

		if (compsg) {
			b = m_expr->RE_parameters(lvs[1])
			B = J(1,klv,b')
			for (i=2; i<=klv; i++) {
				B[.,i] = m_expr->RE_parameters(lvs[i])'
			}
			B = B*(*m_delta[ih])
		}
		for (jp[j]=1; jp[j]<=kp; jp[j]=jp[j]+1) {
			ip = jp[j]
			Rj = *vD[j1].R[ip,j]
			kr = rows(Rj)
			kc = cols(Rj)
			Ri = I(kc)
			if (kr < kc) {
				/* panel not full rank			*/
				Ri = Ri[|1,1\kr,kc|]
			}
			Ri = _menl_solveupper(Rj,Ri,vD[j1].p[ip])
			H = Ri'

			/* begin index panel				*/
			ipc = pinfo[ip,1]
			for (i=1; i<j; i++) {
				/* end index parent panel		*/
				ipp = (*hinfo.hinfo[i])[jp[i],2]
				if (ipc > ipp) {
					/* new parent			*/
					jp[i] = jp[i] + 1
				}
				Rij = *vD[j1].R[ip,i]
				if (kr < kc) {
					/* panel not full rank		*/
					Rij = (Rij\J(kc-kr,cols(Rij),0))
				}

				Rj = -Ri*Rij*(*Rii[i].R[jp[i]])
				H = (H\Rj')
			}
			if (FEadj) {
				Rij = *vD[j1].X[ip,1]
				if (kr < kc) {
					/* panel not full rank	*/
					Rij = (Rij\J(kc-kr,cols(Rij),0))
				}
				Rj = -Ri*Rij*R0
				H = (H\Rj')
			}
			p = tau = .
			_hqrdp(H,tau,R,p)
			if (compsg) {
				rank = _menl_rank_R(R)
				Zj = panelsubmatrix(*m_Z[ih],ip,pinfo)
				if (select) {
					sel = panelsubmatrix(m_select,ip,pinfo)
					Zj = select(Zj,sel)
				}
				Zj = (Zj\*m_delta[ih])
				if (select) {
					k1 = k2 + 1
					k2 = k2 + sum(sel)
					rj = r[|k1\k2|]
				}
				else {
					rj = panelsubmatrix(r,ip,pinfo)
				}
				rj = (rj\-B[ip,.]')
				g = 2*colsum(rj:*Zj)'
				g = g[p']
				if (rank < rows(R)) {
					Rj = R[|1,1\rank,rank|]
					g = g[|1\rank|]
					g = Rj*g
				}
				else {
					g = R*g
				}
				sgrad = sgrad + g'g
			}
			R = R[.,invorder(p)]
			/* save sqrt covariance for lower level
			 * computations					*/
			Rii[j].R[ip] = &J(1,1,R')

			SE[ip,.] = sqrt(diagonal(R'R)'):*s
		}
		seRE[ih] = &J(1,1,SE)
	}
	_menl_clear_Rii(Rii)
}

real matrix __menl_pnls::VCE()
{
	real scalar s, r
	real matrix Ri
	pointer (real rowvector) scalar p
	pointer (class __ecovmatrix) vector var

	if (!m_kFEb) {
		m_V = J(0,0,0)
		return
	}
	/* r = rank							*/
	r = rows(m_R)
	if (!r) {
		m_V = J(m_kFEb,m_kFEb,0)
		return
	}
	
	Ri = I(r)
	p = NULL
	if (cols(m_p)) {
		p = &m_p
	}
	Ri = _menl_solveupper(m_R,Ri,p)
	var = m_expr->res_covariance()
	s = var->sigma()
	var = NULL
	p = NULL

	/* scale by sigma and small sample adjustment			*/
	Ri = Ri:*(s*sqrt(m_n/(m_n-r)))

	m_V = Ri*Ri'

	return(m_V)
}

real colvector __menl_pnls::penalize_vector()
{
	real scalar i, j, ih, klev, klv
	real colvector p, b
	real matrix B
	string vector lv
	string matrix paths
	pointer (struct _lvhinfo) scalar hinfo

	hinfo = m_hierarchy->current_hinfo()
	paths = m_hierarchy->paths()
	klev = hinfo->kpath
	if (length(m_delta)!=klev | m_delta==NULL) {
		/* should not happen					*/
		hinfo = NULL
		errprintf("invalid hierarchy; cannot proceed\n")
		exit(498)
	}
	p = J(0,1,0)
	if (!klev) {
		hinfo = NULL
		return(p)
	}
	i = 0
	for (ih=hinfo->hrange[1]; ih<=hinfo->hrange[2]; ih++) {
		lv = tokens(paths[ih,`MENL_HIER_LV_NAMES'])
		klv = cols(lv)
		b = m_expr->RE_parameters(lv[1])'
		B = J(1,klv,b)
		for (j=2; j<=klv; j++) {
			B[.,j] = m_expr->RE_parameters(lv[j])'
		}
		B = B*(*m_delta[++i])
		p = (p\vec(B))
	}
	hinfo = NULL

	return(p)
}

end
exit
