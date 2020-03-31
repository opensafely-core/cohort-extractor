*! version 1.1.2  22apr2019

findfile __sub_expr_global.matah
quietly include `"`r(fn)'"'

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __ecovmatrix.matah
quietly include `"`r(fn)'"'

local BYVAR_INDEX 1
local BYVAR_COUNT 2

local IVAR_INDEX 1
local IVAR_COUNT 2

mata:
mata set matastrict on

void __ecovmatrix::new()
{
	clear()

	NONE		= `COV_NONE'
	LINEAR		= `VAR_RESID_LINEAR'
	HOMOSKEDASTIC	= `VAR_RESID_HOMOSKEDASTIC'
	HETEROSKEDASTIC	= `VAR_RESID_HETEROSKEDASTIC'
	POWER		= `VAR_RESID_POWER'
	CONSTPOWER	= `VAR_RESID_CONSTPOWER'
	EXPONENTIAL	= `VAR_RESID_EXPONENTIAL'

	FITTED  	= `VAR_RESID_FITTED'

	INDEPENDENT	= `COR_RESID_INDEPENDENT'
	EXCHANGEABLE	= `COR_RESID_EXCHANGEABLE'
	AUTOREGRESS	= `COR_RESID_AUTOREGRESS'
	MOVINGAVERAGE	= `COR_RESID_MOVINGAVERAGE'
	CONTINUOUSAR1	= `COR_RESID_CONTINUOUSAR1'
	TOEPLITZ	= `COR_RESID_TOEPLITZ'
	BANDED		= `COR_RESID_BANDED'
	UNSTRUCTURED	= `COR_RESID_UNSTRUCTURED'

	LOG 	= `TRANSFORM_LOG'
	ATANH	= `TRANSFORM_ATANH'
	LOGIT	= `TRANSFORM_LOGIT'

	STDDEV	= `RESID_STDDEV'
	CORR	= `RESID_CORR'
}

void __ecovmatrix::destroy()
{
	clear()
}

void __ecovmatrix::clear()
{
	m_sd = __esdvector(1)
	m_cor = __ecormatrix(1)
	m_isd = m_icor = 1

	m_bysdtable = m_bycortable = J(0,2,0)
	m_bysdvar = m_bycorvar = ""
	m_bysd = m_bycor = J(0,1,0)

	m_isdtable = m_icortable = J(0,2,0)
	m_isdvar = m_icorvar = ""
	m_indsd = m_indcor = J(0,1,0)

	m_tvar = m_pvar = ""
	m_t = m_p = J(0,1,0)

	m_mxsdind = m_mxcorind = 0

	m_lnsigma = 0
}

real scalar __ecovmatrix::set_bypanel(real scalar jsd, real scalar jcor)
{
	real scalar i, isd, icor, kp

	/* set the panel using the Stata variable values		*/
	isd = icor = 0
	kp = ::rows(m_bysdtable)
	for (i=1; i<=kp; i++) {
		if (m_bysdtable[i,`BYVAR_INDEX'] == jsd) {
			isd = i
			break
		}
	}
	if (!isd) {
		m_errmsg = sprintf("standard deviation panel %g not found",jsd)
		return(503)
	}
	kp = ::rows(m_bycortable)
	for (i=1; i<=kp; i++) {
		if (m_bycortable[i,`BYVAR_INDEX'] == jcor) {
			icor = i
			break
		}
	}
	if (!icor) {
		m_errmsg = sprintf("correlation panel %g not found",jcor)
		return(503)
	}
	return(set_byindex(isd,icor))
}

real scalar __ecovmatrix::set_byindex(real scalar isd, real scalar icor)
{
	/* set the panel using the Mata index colvector values;
	 * 	sequential 1, ..,length(m_sd) or length(,m_cor)		*/
	if (isd<1 | isd>length(m_sd)) {
		m_errmsg = "standard deviation panel index out of range"
		return(503)
	}
	if (icor<1 | icor>length(m_cor)) {
		m_errmsg = "correlation panel index out of range"
		return(503)
	}
	m_isd = isd
	m_icor = icor

	return(0)
}

real rowvector __ecovmatrix::bypanels()
{
	real scalar kp
	real rowvector panels

	panels = (1,1)
	kp = ::rows(m_bysdtable)
	if (kp) {
		panels[1] = m_bysdtable[m_isd,`BYVAR_INDEX']
	}
	kp = ::rows(m_bycortable)
	if (kp) {
		panels[2] = m_bycortable[m_icor,`BYVAR_INDEX']
	}
	return(panels)
}

real matrix __ecovmatrix::bytable(real scalar which)
{
	if (which == STDDEV) {
		return(m_bysdtable)
	}
	else if (which == CORR) {
		return(m_bycortable)
	}
	return(J(0,0,0))
}

string scalar __ecovmatrix::byvarname(real scalar which)
{
	if (which == STDDEV) {
		return(m_bysdvar)
	}
	else if (which == CORR) {
		return(m_bycorvar)
	}
	return("")
}

real colvector __ecovmatrix::byvector(real scalar which)
{
	if (which == STDDEV) {
		return(m_bysd)
	}
	else if (which == CORR) {
		return(m_bycor)
	}
	return(J(0,1,0))
}

real scalar __ecovmatrix::bycount(real scalar which)
{
	if (which == STDDEV) {
		if (!ustrlen(m_bysdvar)) {
			return(0)
		}
		return(length(m_sd))
	}
	else if (which == CORR) {
		if (!ustrlen(m_bycorvar)) {
			return(0)
		}
		return(length(m_cor))
	}
	return(0)
}


real matrix __ecovmatrix::indtable(real scalar which)
{
	if (which == STDDEV) {
		return(m_isdtable)
	}
	else if (which == CORR) {
		return(m_icortable)
	}
	return(J(0,0,0))
}

string scalar __ecovmatrix::indvarname(real scalar which)
{
	if (which == STDDEV) {
		return(m_isdvar)
	}
	else if (which == CORR) {
		return(m_icorvar)
	}
	return("")
}

real colvector __ecovmatrix::indvector(real scalar which)
{
	if (which == STDDEV) {
		return(m_indsd)
	}
	else if (which == CORR) {
		return(m_indcor)
	}
	return("")
}

real scalar __ecovmatrix::vtransform()
{
	if (!length(m_sd)) {
		return(`TRANSFORM_NONE')
	}	
	return(m_sd[1].transform())
}

real scalar __ecovmatrix::ctransform()
{
	if (!length(m_cor)) {
		return(`TRANSFORM_NONE')
	}	
	return(m_cor[1].transform())
}

void __ecovmatrix::erase()
{
	super.erase()

	clear()
}

real scalar __ecovmatrix::set_rowstripe(string matrix stripe)
{
	return(super.set_rowstripe(stripe))
}

real scalar __ecovmatrix::set_colstripe(string matrix stripe)
{
	return(super.set_colstripe(stripe))
}

real scalar __ecovmatrix::set_matrix(real matrix mat, |string scalar name)
{
	return(super.set_matrix(mat,name))
}

real scalar __ecovmatrix::compute_V(real rowvector i, |real scalar scale)
{
	real scalar sigma, k, m, rc, range, c, icor, isd
	real scalar vtype, ctype
	real colvector s, t
	real matrix V
	string scalar msg

	scale = (missing(scale)?0:(scale!=0))	// scale by sigma2
	m = 0
	c = ::cols(i)
	range = 0
	t = J(0,1,0)
	if (c >= 2) {
		range = 1	// range, subset m_t
		m = i[2]-i[1]+1	
		isd = icor = 1
		k = ::rows(m_bysd)
		if (k >= i[2]) {
			isd = m_bysd[i[2]]
		}
		k = ::rows(m_bycor)
		if (k >= i[2]) {
			icor = m_bycor[i[2]]
		}
		if (rc=set_byindex(isd,icor)) {
			return(rc)
		}
		k = max((m_mxsdind,m_mxcorind))
		if ((k & i[2]>k) | i[1]<1) {
			m_errmsg = "failed to compute residual covariance; " +
				"data index range invalid"
			return(498)
		}
		if (m <=0) {
			m_errmsg = "failed to compute residual covariance; " +
				"data index range invalid"
			return(498)
		}
	}
	else if (c == 1) {
		m = i[1]	// size
		if (m_mxsdind | m_mxcorind) {
			k = ::rows(m_p)
			if (m_mxcorind) {
				if (ctype() == UNSTRUCTURED) {
					msg = "index"
				}
				else {
					msg = "time"
				}
			}
			else if (vtype() == HETEROSKEDASTIC) {
				msg = "index"
			}
			else if (k) {
				msg = "covariate"
			}
			else { 
				msg = "by-variable"
			}
			m_errmsg = sprintf("failed to compute residual " +
				"covariance; data index range required for " +
				"a %s-dependent covariance",msg)
			return(498)
		}
		if (m <=0) {
			m_errmsg = "failed to compute residual covariance; " +
				"data index invalid"
			return(498)
		}
	}
	vtype = vtype()
	if (vtype != HOMOSKEDASTIC) {
		if (!range) {
			if (vtype == HETEROSKEDASTIC) {
				msg = "standard deviation"
			}
			else {
				msg = "covariate"
			}
			m_errmsg = sprintf("failed to compute residual " +
				"covariance; %s index range required",msg)
			return(498)
		}
		k = ::rows(m_p)
		if (vtype == HETEROSKEDASTIC) {

			t = m_indsd[|i[1]\i[2]|]
		}
		else if (!k) {
			/* did not set_fitted()				*/
			m_errmsg = sprintf("failed to compute residual " +
				"covariance; did not set %s variable",
				FITTED)
			return(498)
		}
		else {
			t = m_p[|i[1]\i[2]|]
		}
	}
	if (rc=m_sd[m_isd].compute_sd(m,t)) {
		m_errmsg = m_sd[m_isd].errmsg()
		return(rc)
	}
	s = m_sd[m_isd].sd()
	if (!length(s)) {
		m_errmsg = "failed to compute residual covariance; " +
			"invalid standard deviation object"
		return(498)
	}
	if (scale) {
		sigma = sigma()
		s = s:*sigma
	}
	ctype = ctype()
	if (range) {
		if (ctype==AUTOREGRESS | ctype==MOVINGAVERAGE |
			ctype==CONTINUOUSAR1 | ctype==TOEPLITZ) {
			t = m_t[|i[1]\i[2]|]
			if (m > 1) {
				if (any((t[|2\m|]:-t[|1\m-1|]):<=0)) {
					m_errmsg = sprintf("failed to " +
						"compute residual " +
						"covariance; time variable " +
						"on range [%g,%g] is not " +
						"increasing",i[1],i[2])
					return(498)
				}
			}
		}
		else if (ctype==UNSTRUCTURED | ctype==BANDED) {
			t = m_indcor[|i[1]\i[2]|]
		}
	}
	else if (ctype!=INDEPENDENT & ctype!=EXCHANGEABLE) {
		if (ctype == UNSTRUCTURED) {
			msg = "correlation"
		}
		else {
			msg = "time"
		}
		m_errmsg = sprintf("failed to compute residual " +
			"covariance; %s index range required",msg)
		return(498)
	}
	if (rc=m_cor[m_icor].compute_R(m,t)) {
		m_errmsg = m_cor[m_icor].errmsg()
		return(rc)
	}
	if (ctype == INDEPENDENT) {
		/* vector of variances to save memory			*/
		V = s:*s		
	}
	else {
		/* full covariance					*/
		V = m_cor[m_icor].R()
		V = s':*V:*s
		V = (V+V'):/2
	}

	rc = set_matrix(V)

	return(rc)
}

pointer (class __esdvector) scalar __ecovmatrix::sd_obj(real scalar i)
{
	real scalar ks

	ks = length(m_cor)
	if (i<1 | i>ks) {
		return(NULL)
	}
	return(&m_sd[i])
}

pointer (class __ecormatrix) scalar __ecovmatrix::cor_obj(real scalar i)
{
	real scalar kc

	kc = length(m_cor)
	if (i<1 | i>kc) {
		return(NULL)
	}
	return(&m_cor[i])
}

real matrix __ecovmatrix::V()
{
	return(m())
}

real matrix __ecovmatrix::scale_matrix(|real scalar lndet)
{
	real scalar c
	real colvector s
	real matrix psi, U, V

	pragma unset s
	pragma unset V

	if (rows() == 0) {
		return(J(0,0,0))
	}
	U = m()
	c = ::cols(U)
	if (c == 1) {
		if (args()) {
			lndet = sum(log(U))
		}
		psi = 1:/sqrt(U)
	}
	else {
		_svd(U,s,V)
		if (args()) {
			lndet = sum(log(s))
		}
		_transpose(V)
		_transpose(U)
		psi = V*diag(1:/sqrt(s))*U
		psi = (psi+psi'):/2
	}
	return(psi)	
}

real colvector __ecovmatrix::sd()
{
	return(m_sd[m_isd].sd())
}

real matrix __ecovmatrix::R()
{
	return(m_cor[m_icor].R())
}

real scalar __ecovmatrix::sigma()
{
	return(exp(m_lnsigma))
}

real scalar __ecovmatrix::sigma2()
{
	return(exp(2*m_lnsigma))
}

string scalar __ecovmatrix::errmsg()
{
	return(m_errmsg)
}

string scalar __ecovmatrix::tvar_name()
{
	return(m_tvar)
}

real colvector __ecovmatrix::tvar()
{
	return(m_t)
}

string scalar __ecovmatrix::pvar_name()
{
	return(m_pvar)
}

real colvector __ecovmatrix::pvar()
{
	return(m_p)
}

void __ecovmatrix::set_fitted(real colvector fitted)
{
	if (m_pvar == FITTED) {
		m_p = fitted
		m_mxsdind = ::rows(m_p)
	}
}

class __stmatrix scalar __ecovmatrix::sd_parameters()
{
	real scalar i, ksd
	real matrix b
	string matrix stripe
	class __stmatrix scalar parm

	if (!(ksd=bycount(STDDEV))) {
		return(m_sd[1].parameters())
	}
	b = J(1,0,0)
	stripe = J(0,2,"")
	for (i=1; i<=ksd; i++) {
		if (m_sd[i].kpar()) {
			parm = m_sd[i].parameters()
			b = (b,parm.m())
			stripe = (stripe\parm.colstripe())
		}
	}
	parm.erase()
	(void)parm.set_matrix(b)
	(void)parm.set_colstripe(stripe)
	(void)parm.set_rowstripe(("","res"))

	return(parm)
}

real scalar __ecovmatrix::set_sd_parameters(real rowvector b)
{
	real scalar i, i1, i2, kv, rc, kp, k

	kv = length(m_sd)
	kp = ::cols(b)
	i2 = 0
	for (i=1; i<=kv; i++) {
		if (!(k=m_sd[i].kpar())) {
			continue
		}
		i1 = i2 + 1
		i2 = i2 + k
		if (i2 <= kp) {
			if (rc=m_sd[i].set_parameters(b[|i1\i2|])) {
				m_errmsg = m_sd[i].errmsg()
				return(rc)
			}
		}
	}
	if (i2 > kp) {
		m_errmsg = sprintf("failed to set residual standard " +
			"deviation parameters; expected a vector of length " +
			"%g but got %g",i2,kp)
		return(503)
	}
	return(0)
}

class __stmatrix scalar __ecovmatrix::cor_parameters()
{
	real scalar i, kcor
	real matrix b
	string matrix stripe
	class __stmatrix scalar parm

	kcor = length(m_cor)
	if (kcor == 1) {
		return(m_cor[1].parameters())
	}
	b = J(1,0,0)
	stripe = J(0,2,"")
	for (i=1; i<=kcor; i++) {
		parm = m_cor[i].parameters()
		b = (b,parm.m())
		stripe = (stripe\parm.colstripe())
	}
	parm.erase()
	(void)parm.set_matrix(b)
	(void)parm.set_colstripe(stripe)
	(void)parm.set_rowstripe(("","cor"))

	return(parm)
}

real scalar __ecovmatrix::set_cor_parameters(real rowvector b)
{
	real scalar i, i1, i2, kc, rc, kp, k

	kc = length(m_cor)
	kp = ::cols(b)
	i2 = 0
	for (i=1; i<=kc; i++) {
		if (!(k=m_cor[i].kpar())) {
			continue
		}
		i1 = i2 + 1
		i2 = i2 + k
		if (i2 <= kp) {
			if (rc=m_cor[i].set_parameters(b[|i1\i2|])) {
				m_errmsg = m_cor[i].errmsg()
				return(rc)
			}
		}
	}
	if (i2 != kp) {
		m_errmsg = sprintf("failed to set residual correlation " +
			"parameters; expected a vector of length %g but " +
			"got %g",i2,kp)
		return(503)
	}
	return(0)
}

class __stmatrix scalar __ecovmatrix::lnsigma()
{
	class __stmatrix scalar var

	(void)var.set_colstripe(("/Residual","lnsigma"))
	(void)var.set_matrix(J(1,1,m_lnsigma))
	(void)var.set_rowstripe(("","scale"))

	return(var)
}

real scalar __ecovmatrix::lnsigma0()
{
	return(m_lnsigma)
}

void __ecovmatrix::set_lnsigma(real scalar lns)
{
	m_lnsigma = lns
}

real scalar __ecovmatrix::set_parameters(real scalar lnsigma,
			real rowvector bsd, real rowvector bcor)
{
	real scalar rc

	set_lnsigma(lnsigma)
	if (!(rc=set_sd_parameters(bsd))) {
		rc = set_cor_parameters(bcor)
	}
	return(rc)
}

class __stmatrix scalar __ecovmatrix::params_est_metric()
{
	real matrix b
	string matrix stripe
	class __stmatrix scalar x, parm

	stripe = J(0,2,"")
	b = J(1,0,0)
	x = lnsigma()
	b = x.m()
	stripe = x.colstripe()
	if (ksdpar()) {
		x = sd_parameters()
		b = (b,x.m())
		stripe = (stripe\x.colstripe())
	}
	if (kcorpar()) {
		x = cor_parameters()
		b = (b,x.m())
		stripe = (stripe\x.colstripe())
	}
	(void)parm.set_matrix(b)
	(void)parm.set_colstripe(stripe)
	(void)parm.set_rowstripe(("","est"))

	return(parm)
}

void _ecovmatrix_fill_Jvsc(real rowvector cvec, real matrix J, real matrix Ci)
{
	real scalar i, j, k, kc, kv

	kc = cols(J)
	kv = rows(J)
	/* loop in vech order (order of correlations)			*/
	for (i=1; i<=kc; i++) {
		/* all covariances are a function of sigma2		*/
		J[1,i] = 2*cvec[i]
	}
	/* covariances w.r.t. variance ratios				*/
	for (i=1; i<=kv; i++) {
		for (j=i+1; j<=kv; j++) {
			/* cvec index					*/
			if (k=Ci[j,i]) {
				if (i != 1) {
					J[i,k] = cvec[k]
				}
				J[j,k] = cvec[k]
			}
		}
	}
}

real scalar __ecovmatrix::sd_params_metric(real rowvector bs, 
		string matrix xstripe, string scalar which,
		real scalar noratio, string vector lab, 
		|real matrix Js, real matrix Jvs, real vector trans)
{
	real scalar i, ksd, ks, s, lns, vtype, jac
	class __stmatrix scalar x

	ksd = ksdpar()
	bs = J(1,0,0)
	Js = J(0,0,0)
	xstripe = J(0,2,"")
	if (!ksd) {
		return(0)
	}
	jac = (args() > 5)
	if (jac) {
		Jvs = J(0,0,0)
	}
	x = lnsigma()
	lns = x.m()

	vtype = vtype()
	x = sd_parameters()
	bs = x.m()
	ks = x.cols()
	xstripe = x.colstripe()
	if (vtype==HETEROSKEDASTIC | vtype==HOMOSKEDASTIC) {
		if (noratio) {
			xstripe[.,2] = subinstr(xstripe[.,2],"lnsigrat",lab[1])
			if (which == "var") {
				s = exp(2*lns)
				bs = exp(2:*bs):*s
				if (jac) {
					Js = I(ks)
					_diag(Js,2:*bs)
					Jvs = 2:*bs
				}
			}
			else {
				s = exp(lns)
				bs = exp(bs):*s
				if (jac) {
					Js = I(ks)
					_diag(Js,bs)
					Jvs = bs
				}
			}
		}
		else {
			xstripe[.,2] = subinstr(xstripe[.,2],"lnsigrat",lab[4])
			if (which == "var") {
				bs = exp(2:*bs)
				if (jac) {
					Js = diag(2:*bs)
				}
			}
			else {
				bs = exp(bs)
				if (jac) {
					Js = diag(bs)
				}
			}
		}
		if (jac) {
			trans = (trans,J(1,ks,`TRANSFORM_LOG'))
		}
	}
	else if (vtype == CONSTPOWER) {
		xstripe[.,2] = subinstr(xstripe[.,2],"ln_cons","_cons")
		for (i=2; i<=ks; i=i+2) {
			bs[i] = exp(bs[i])
		}
		if (jac) {
			Js = I(ks)
			for (i=2; i<=ks; i=i+2) {
				Js[i,i] = bs[i]
				trans = (trans,(`TRANSFORM_NONE',
					`TRANSFORM_LOG'))
			}
		}
	}
	else if (vtype == LINEAR) {
		/* ksd > 1 because ksdpar()>0				*/
		if (!noratio) {
			xstripe[.,2] = subinstr(xstripe[.,2],"lndelta","delta")
			bs = exp(bs)
			if (jac) {
				Js = I(ks)
				_diag(Js,bs')
				trans = (trans,J(1,ks,`TRANSFORM_LOG'))
			}
		}
		else {
			xstripe[.,2] = subinstr(xstripe[.,2],"lndelta",lab[2])
			if (which == "var") {
				s = exp(2*lns)
				bs = exp(2:*bs):*s
				if (jac) {
					Js = I(ks)
					_diag(Js,2:*bs)
					Jvs = 2:*bs
				}
			}
			else {
				s = exp(lns)
				bs = exp(bs):*s
				if (jac) {
					Js = I(ks)
					_diag(Js,bs)
					Jvs = bs
				}
			}
			if (jac) {
				trans = (trans,J(1,ks,`TRANSFORM_LOG'))
			}
		}
	}
	else if (jac) {
		Js = I(ks)
		trans = (trans,J(1,ks,`TRANSFORM_NONE'))
	}
	return(ks)
}

real scalar __ecovmatrix::cor_params_metric(real rowvector bc,
		 real rowvector bs0, string matrix xstripe, string scalar which,
		|real matrix Jc, real matrix Jvsc, real matrix Jv, 
		real matrix Js, real matrix Jvs, real vector trans)
{
	real scalar i, j, k, i1, i2, kc, ks, ctrans, jac, lns, sig
	real scalar ctype, vtype, nodiag, kbys, kbyc, ks1
	real vector o
	real rowvector ss, bs, bc0
	real matrix Ci, C, J0, J1, J2
	class __stmatrix scalar x

	xstripe = J(0,2,"")
	bc = J(1,0,0)
	if (!kcorpar()) {
		return(0)
	}
	vtype = vtype()
	ctype = ctype()
	jac = (args() > 4)
	if (jac) {
		Jvsc = J(0,0,0)
	}
	x = lnsigma()
	lns = x.m()
	if (which == "var") {
		sig = exp(2*lns)
	}
	else {
		sig = exp(lns)
	}
	bs = bs0
	ks = ::cols(bs)
	x = cor_parameters()
	kc = x.cols()
	bc = x.m()
	xstripe = x.colstripe()
	ctrans = ctransform()
	if (ctrans  == `TRANSFORM_ATANH') {
		if (jac) {
			Jc = diag(4:/(exp(bc)+exp(-bc)):^2)
		}
		bc = bc0 = tanh(bc)
		if (which == "var") {
			if (ctype==TOEPLITZ & vtype==HOMOSKEDASTIC) {
				if (ks) {
					bs = (sig,bs)
					ks++
				}
				else {
					bs = sig
				}
				kbys = bycount(STDDEV)
				kbyc = bycount(CORR)
				if (kbys>1 & kbys==kbyc) {
					if (mod(kc,ks)) {
						/* programmer error	*/
						errprintf("incompatible " +
							"residual standard " +
							"deviation and " +
							"correlation by " +
							"repetitions\n")
						exit(498)
					}
					ks1 = kbys
					if (kc > ks) {
						ks1 = kc/kbyc
						bs = vec(J(ks1,1,bs))'
					}
					bc = bc:*bs
				}
				else if (!kbys) {
					/* bs is a scalar = sig		*/
					bc = bc:*bs
				}
				else {
					/* programmer error		*/
					errprintf("incompatible residual " +
						"standard deviation and " +
						"correlation by repetitions\n")
					exit(498)
				}
				if (jac) {
					Jc = Jc:*bs
					if (kbys > 1) {
						/* by var & cor		*/
						i1 = ::rows(Js)
						i2 = ::cols(Js)
						J0 = J(i1,i2,0)
						if (kc > ks) {
							J1 = (J(1,ks1,Jv),
								J(1,ks1,Jvs))
							J2 = (J(1,ks1,J0),
								J(1,ks1,Js))
						}
						else {
							J1 = (Jv,Jvs)
							J2 = (J0,Js)
						}
						Jvsc = (J1\J2):*bc0
					}
					else {	// ks == 0
						Jvsc = 2:*bc
					}
				}
				xstripe[.,2] = subinstr(xstripe[.,2],
					"athcorr","cov")
				ctrans = `TRANSFORM_NONE'
			}
			else if ((ctype==EXCHANGEABLE | ctype==UNSTRUCTURED |
				ctype==BANDED) & vtype==HOMOSKEDASTIC) {
				if (ks) {
					bs = (sig,bs)
					ks++
				}
				else {
					bs = sig
				}
				bc = bc:*bs
				if (jac) {
					Jc = Jc:*bs
					if (ks == kc) {
						/* by var & cor		*/
						Jvsc = diag(2:*bc)
					}
					else {	// ks == 0
						Jvsc = 2:*bc
					}
				}
				xstripe[.,2] = subinstr(xstripe[.,2],
					"athcorr","cov")
				ctrans = `TRANSFORM_NONE'
			}
			else if ((ctype==UNSTRUCTURED | ctype==BANDED) &
				vtype==HETEROSKEDASTIC) {
				bs = sqrt((sig,bs))
				ks++
				Ci = J(ks,ks,0)
				if (ctype == BANDED) {
					/* o[1] == ks			*/
					o = m_cor[m_icor].order()
					C = J(1,ks,bs'):*bs
					ss = J(kc,1,0)
					k = 0
					for (j=1; j<o[1]; j++) {
						if ((i1=j+o[2])>o[1]) {
							i1 = o[1]
						}
						for (i=j+1; i<=i1; i++) {
							ss[++k] = C[i,j]

							Ci[i,j] = k
						}
					}
				}
				else {
					nodiag = `TRUE'
					ss = vech(J(1,ks,bs'):*bs,nodiag)
					i2 = 0
					for (i=1; i<ks; i++) {
						i1 = i2 + 1
						i2 = i2 + ks-i
						Ci[|i+1,i\ks,i|] = i1::i2
					}
				}
				bc = bc:*ss'	// covariances

				if (jac) {
					Jc = ss:*Jc
					Jvsc = J(ks,kc,0)
					_ecovmatrix_fill_Jvsc(bc,Jvsc,Ci)
				}
				xstripe[.,2] = subinstr(xstripe[.,2],"athcorr",
					"cov")
				ctrans = `TRANSFORM_NONE'
			}
			else {
				xstripe[.,2] = subinstr(xstripe[.,2],"ath","")
			}
		}
		else {
			xstripe[.,2] = subinstr(xstripe[.,2],"ath","")
		}
	}
	else if (ctrans == `TRANSFORM_LOGIT') {
		bc = invlogit(bc)
		if (jac) {
			Jc = diag(bc:*(1:-bc))
		}
		xstripe[.,2] = subinstr(xstripe[.,2],"logit","")
	}
	else {
		/* no transformation					*/
		if (jac) {
			Jc = I(kc)
		}
	}
	if (jac) {
		trans = (trans,J(1,kc,ctrans))
	}
	return(kc)
}

class __stmatrix scalar __ecovmatrix::params_metric(string scalar which,				|real matrix J, real vector trans, real scalar noratio)
{
	real scalar k, jac, sig, ks, kc, kv, i1, i2, ksd
	real scalar lns, vtype, ctype
	real rowvector b, bc, bs
	real matrix Js, Jv, Jc, Jvs, Jvsc
	string vector lab
	string matrix stripe, xstripe
	class __stmatrix scalar x, parm

	pragma unset bc
	pragma unset bs
	pragma unset Jc
	pragma unset Js
	pragma unset Jvsc
	pragma unset Jvs

	noratio = (missing(noratio)?0:(noratio!=0))
	ks = kc = 0
	jac = args()
	if (jac) {
		trans = J(1,0,0)
	}
	stripe = J(0,2,"")
	b = J(1,0,0)

	ksd = ksdpar()
	vtype = vtype()
	ctype = ctype()
	x = lnsigma()
	lns = x.m()
	kv = x.cols()
	xstripe = x.colstripe()
	if (which == "var") {
		sig = exp(2*lns)
		lab = ("var(e)","var","sigma2","var_ratio")
	}
	else {
		sig = exp(lns)
		lab = ("sd(e)","sd","sigma","sd_ratio")
	}
	if (vtype == HOMOSKEDASTIC) {
		if (ctype==AUTOREGRESS | ctype==MOVINGAVERAGE | 
			ctype==CONTINUOUSAR1 | ctype==TOEPLITZ) {
			if (!ksd) {
				xstripe[1,2] = lab[1]
			}
			else {
				xstripe[1,2] = sprintf("%s_%g",lab[1],
					m_bysdtable[1,1])
			}
		}
		else if (!ksd) {
			xstripe[1,2] = lab[2]
		}
		else if (ctype==INDEPENDENT | ctype==EXCHANGEABLE) {
			xstripe[1,2] = sprintf("%s_%g",lab[1],m_bysdtable[1,1])
		}
		else if (noratio) {
			xstripe[1,2] = sprintf("%s_%g",lab[3],m_bysdtable[1,1])
		}
		else {
			xstripe[1,2] = lab[3]
		}
	}
	else if (vtype==POWER | vtype==EXPONENTIAL) {
		xstripe[1,2] = subinstr(xstripe[1,2],"lnsigma",lab[3])
	}
	else if (vtype==HETEROSKEDASTIC & noratio) {
		xstripe[1,2] = sprintf("%s_%g",lab[1],m_isdtable[1,1])
	}
	else {
		xstripe[1,2] = subinstr(xstripe[1,2],"lnsigma",lab[3])
	}
	b = (b,sig)
	stripe = xstripe
	if (jac) {
		if (which == "var") {
			Jv = diag(2:*sig)
		}
		else {
			Jv = diag(sig)
		}
		trans = J(1,1,`TRANSFORM_LOG')
	}

	if (jac) {
		ks = sd_params_metric(bs,xstripe,which,noratio,lab,Js,Jvs,trans)
	}
	else {
		ks = sd_params_metric(bs,xstripe,which,noratio,lab)
	}
	b = (b,bs)
	stripe = (stripe\xstripe)

	if (jac) {
		kc = cor_params_metric(bc,bs,xstripe,which,Jc,Jvsc,Jv,Js,Jvs,
			trans)
	}
	else {
		kc = cor_params_metric(bc,bs,xstripe,which)
	}
	b = (b,bc)
	stripe = (stripe\xstripe)

	(void)parm.set_matrix(b)
	(void)parm.set_colstripe(stripe)
	(void)parm.set_rowstripe(("",which))

	if (jac) {
		J = I(kv+ks+kc) 	// ks includes lnsigma
		i2 = 0
		if (kv) {
			i1 = i2 + 1
			i2 = i2 + kv
			J[|i1,i1\i2,i2|] = Jv
		}
		if (ks) {
			i1 = i2 + 1
			i2 = i2 + ks
			
			J[|i1,i1\i2,i2|] = Js

			k = ::cols(Jvs)
			if (k & k==ks) {
				J[|1,i1\kv,i2|] = Jvs
			}
		}
		if (kc) {
			i1 = i2 + 1
			i2 = i2 + kc
			J[|i1,i1\i2,i2|] = Jc
			k = ::cols(Jvsc)
			if (ks+kv & k==kc) {
				J[|1,i1\ks+kv,i2|] = Jvsc
			}
		}
	}
	return(parm)
}

real scalar __ecovmatrix::ksdpar()
{
	real scalar i, kpar, kv

	if (!(kv=bycount(STDDEV))) {
		return(m_sd[1].kpar())
	}
	/* could use kv*m_sd[1].kpar()					*/
	kpar = 0
	for (i=1; i<=kv; i++) {
		kpar = kpar + m_sd[i].kpar()
	}
	return(kpar)
}

real scalar __ecovmatrix::ksd()
{
	real scalar i, ksd, kv

	kv = length(m_sd)
	if (kv == 1) {
		return(m_sd[1].ksd())
	}
	/* could use kv*m_sd[1].ksd()					*/
	ksd = 0
	for (i=1; i<=kv; i++) {
		ksd = ksd + m_sd[i].ksd()
	}
	return(ksd)
}

real scalar __ecovmatrix::kcorpar()
{
	real scalar i, kpar, kc

	kc = length(m_cor)
	if (kc == 1) {
		return(m_cor[1].kpar())
	}
	/* could use kc*m_cor[1].kpar()					*/
	kpar = 0
	for (i=1; i<=kc; i++) {
		kpar = kpar + m_cor[i].kpar()
	}
	return(kpar)
}

real scalar __ecovmatrix::kcor()
{
	real scalar i, kcor, kc

	kc = length(m_cor)
	if (kc == 1) {
		return(m_cor[1].kcor())
	}
	/* could use kc*m_cor[1].kcor()					*/
	kcor = 0
	for (i=1; i<=kc; i++) {
		kcor = kcor + m_cor[i].kcor()
	}
	return(kcor)
}

real scalar __ecovmatrix::cor_order()
{
	real scalar kc

	kc = length(m_cor)
	if (!kc) {
		return(0)
	}
	return(m_cor[1].order())
}

real scalar __ecovmatrix::construct(real scalar vtype, real scalar ctype,
			|string scalar vbyvar, real matrix vbyvals,
			string scalar cbyvar, real matrix cbyvals,
			string scalar pvar, real matrix pvals, 
			string scalar tvar, real matrix tvals, 
			real scalar vorder, real vector corder,
			string scalar touse)
{
	real scalar rc, bysd, bycor, ivar, discrete, k
	string scalar stype, msg

	/* covariance size is dynamic, depending on the panel;
	 *  setup std.dev and cor parameters, but do not compute
	 *  covariance until we have panel information
	 *  see ::compute_V()						*/
	rc = 0
	if (vtype<HOMOSKEDASTIC | vtype>EXPONENTIAL) {
		m_errmsg = "failed to construct residual covariance matrix; " +
			"invalid standard deviation type"
		return(498)
	}
	if (ctype<INDEPENDENT | ctype>UNSTRUCTURED) {
		m_errmsg = "failed to construct residual covariance matrix; " +
			"invalid correlation type"
		return(498)
	}
	if (vtype == NONE) {
		clear()
		return(0)
	}
	m_bysdvar = vbyvar
	m_bycorvar = cbyvar
	bysd = (ustrlen(m_bysdvar)>0)
	bycor = (ustrlen(m_bycorvar)>0)
	if (bycor | bysd) {
		if (!ustrlen(touse)) {
			m_errmsg = "cannot construct standard deviation " +
				"object; estimation sample indicator " +
				"variable required with a by-variable"
			return(498)
		}
	}
	if (bysd) {
		k = ::rows(vbyvals)
		if (k) {
			/* postestimation; vbyvar[2] is the matrix of by
			 * values at estimation time			*/
			m_bysd = st_data(.,m_bysdvar,touse)
			m_bysdtable = vbyvals
			m_mxsdind = ::rows(m_bysd)
		}
		else if (rc=initialize_byvar("sd",touse)) {
			return(rc)
		}
	}
	else  {
		m_bysdtable = J(1,2,.)
		if (ustrlen(touse)) {
			m_bysdtable[1,`BYVAR_COUNT'] = sum(st_data(.,touse))
		}
	}
	if (bycor) {
		if (ctype == INDEPENDENT) {
			m_errmsg = "invalid correlation specification; " +
				"by-variable not allowed with independent " +
				"correlation"
			return(498)
		}
		k = ::rows(cbyvals)
		if (k) {
			/* postestimation; cbyvar[2] is the matrix of by
			 * values at estimation time			*/
			m_bycor = st_data(.,m_bycorvar,touse)
			m_bycortable = cbyvals
			m_mxcorind = ::rows(m_bycor)
		}
		else if (rc = initialize_byvar("cor",touse)) {
			return(rc)
		}
	}
	else {
		m_bycortable = J(1,2,.)
		if (ustrlen(touse)) {
			m_bycortable[1,`BYVAR_COUNT'] = sum(st_data(.,touse))
		}
	}
	if (ustrlen(tvar)) {
		if (!ustrlen(touse)) {
			if (ctype == UNSTRUCTURED) {
				msg = "index"
			}
			else {
				msg = "time"
			}	
			m_errmsg = sprintf("cannot construct standard " + 
				"deviation object; estimation sample " +
				"indicator variable required with a " +
				"%s-variable",msg)
			return(498)
		}
		if (ctype==UNSTRUCTURED | ctype==BANDED) {
			/* from now on BANDED time variable is an index
			 *  variable; works better with variances	*/
			m_icorvar = tvar
			k = ::rows(tvals)
			if (k) {
				/* postestimation: tvar corr index
			 	 *  variable; levels in matrix tvals	*/
				m_indcor = st_data(.,m_icorvar,touse)
				m_mxcorind = ::rows(m_indcor)
				m_icortable = tvals
			}
			else if (rc = initialize_ivar("cor",touse)) {
				return(rc)
			}
		}
		else {
			discrete = (ctype==AUTOREGRESS|ctype==MOVINGAVERAGE|
				ctype==TOEPLITZ)
			m_tvar = tvar
			if (rc=initialize_tvar(touse,discrete)) {
				return(rc)
			}
		}
	}
	else if (ctype==UNSTRUCTURED | ctype==BANDED | ctype==TOEPLITZ |
		ctype==AUTOREGRESS | ctype==MOVINGAVERAGE |
		ctype==CONTINUOUSAR1) {
		if (ctype == AUTOREGRESS) {
			stype = "autoregressive"
			msg = "time index"
		}
		else if (ctype == MOVINGAVERAGE) {
			stype = "moving average"
			msg = "time index"
		}
		else if (ctype == CONTINUOUSAR1) {
			stype = "continuous AR(1)"
			msg = "time"	
		}
		else if (ctype == BANDED) {
			stype = "banded"
			msg = "time index"
		}
		else if (ctype == TOEPLITZ) {
			stype = "toeplitz"
			msg = "time index"
		}
		else {
			stype = "unstructured"
			msg = "index"
		}
		m_errmsg = sprintf("%s variable required for %s correlation",
				msg,stype)
		return(498)
	}
	if (vtype==POWER | vtype==CONSTPOWER) {
		ivar = .
		if (pvar != FITTED) {
			ivar = _st_varindex(pvar)
		}
		else {
			ivar = 0
		}
		if (missing(ivar)) {
			m_errmsg = "invalid standard deviation " +
				"specification; power covariate required"
			return(498)
		}
		m_pvar = pvar
		if (ivar) {
			st_view(m_p,.,m_pvar,touse)
			m_mxsdind = ::rows(m_p)
		}
		else {
			m_mxsdind = 0	// set in ::set_fitted()
		}
	}
	else if (vtype == LINEAR) {
		ivar = _st_varindex(pvar)
		if (missing(ivar)) {
			m_errmsg = "invalid standard deviation " +
				"specification; linear covariate required"
			return(498)
		}
		m_pvar = pvar
		st_view(m_p,.,m_pvar,touse)
		if (any(m_p:<=0)) {
			m_errmsg = "invalid standard deviation " +
				"specification; linear covariate must " +
				"contain positive values"
			return(498)
		}
		m_mxsdind = ::rows(m_p)
	}
	else if (vtype == EXPONENTIAL) {
		ivar = .
		if (pvar != FITTED) {
			ivar = _st_varindex(pvar)
		}
		else {
			ivar = 0
		}
		if (missing(ivar)) {
			m_errmsg = "invalid standard deviation " +
				"specification; exponential covariate required"
			return(498)
		}
		m_pvar = pvar
		if (ivar) {
			st_view(m_p,.,m_pvar,touse)
			m_mxsdind = ::rows(m_p)
		}
		else {
			m_mxsdind = 0	// set in ::set_fitted()
		}
	}
	else if (vtype == HETEROSKEDASTIC) {
		m_isdvar = pvar
		ivar = _st_varindex(pvar)
		if (missing(ivar)) {
			m_errmsg = "invalid standard deviation " +
				"specification; heteroskedastic index " +
				"variable required"
			return(498)
		}
		if (!ustrlen(touse)) {
			m_errmsg = "cannot construct standard deviation " +
				"object; estimation sample indicator " +
				"variable required with an index-variable"
			return(498)
		}
		k = ::rows(pvals)
		if (k) {
			/* postestimation: pvar stddev index
			 *  variable; levels in matrix pvals		*/
			m_indsd = st_data(.,m_isdvar,touse)
			m_mxsdind = ::rows(m_indsd)
			m_isdtable = pvals
		}
		else {
			if (rc = initialize_ivar("sd",touse)) {
				return(rc)
			}
		}
	}
	if (rc=construct_stddevs(vtype,vorder)) {
		return(rc)
	}
	if (rc=construct_correlations(ctype,corder)) {
		return(rc)
	}
	m_lnsigma = 0
	/* no stripe: dimension can be dynamic, depending on panel size	*/
	/* do not call compute_V() until data is sorted			*/

	return(rc)
}

real scalar __ecovmatrix::construct_stddevs(real scalar type, real scalar order)
{
	real scalar i, kby, rc, id
	real colvector ilab

	kby = ::rows(m_bysdtable)
	m_sd = __esdvector(kby)
	id = .
	ilab = J(1,1,.)
	for (i=1; i<=kby; i++) {
		if (kby > 1) { // has by variable
			id = J(1,1,m_bysdtable[i,`BYVAR_INDEX'])
		}
		if (type == HETEROSKEDASTIC) {
			ilab = m_isdtable[.,`IVAR_INDEX']
		}
		if (rc=m_sd[i].construct(type,id,ilab,order,i)) {
			m_errmsg = m_sd[i].errmsg()
			return(rc)
		}
	}
	return(0)
}

real scalar __ecovmatrix::construct_correlations(real scalar type,
			real vector order)
{
	real scalar i, rc, kby, id
	real colvector ilab

	kby = ::rows(m_bycortable)
	if (type==INDEPENDENT & kby>1) {
		m_errmsg = sprintf("invalid correlation specification; by " +
			"variable not allowed with independent correlation")
		return(498)
	}
	id = .
	ilab = J(1,1,.)
	m_cor = __ecormatrix(kby)
	for (i=1; i<=kby; i++) {
		if (kby > 1) {	// has by variable
			id = J(1,1,m_bycortable[i,`BYVAR_INDEX'])
		}
		if (type==BANDED | type==UNSTRUCTURED) {
			ilab = m_icortable[.,`IVAR_INDEX']
		}
		if (rc=m_cor[i].construct(type,id,ilab,order,i)) {
			m_errmsg = m_cor[i].errmsg()
			return(rc)
		}
	}
	return(0)
}

real scalar __ecovmatrix::initialize_tvar(string scalar touse,
			real scalar discrete)
{
	real scalar rc

	if (!ustrlen(m_tvar)) {
		return(0)
	}
	if (rc=__sub_expr_validate_var(m_tvar,m_errmsg)) { // unabbrev
		return(rc)
	}
	if (rc=__sub_expr_validate_touse(touse,m_errmsg)) {
		return(rc)
	}
	/* must be a view; sort order might change
	 *  see __sub_expr::_hierarchy_sort_order()			*/
	st_view(m_t,.,m_tvar,touse)
	if (discrete) {
		if (any(m_t:!=edittointtol(m_t,.5))) {
			m_errmsg = sprintf("discrete time variable {bf:%s} " +
				"must be integer valued",m_tvar)
			return(109)
		}
	}
	m_mxcorind = ::rows(m_t)

	return(0)
}

real scalar __ecovmatrix::initialize_byvar(string scalar which,
			string scalar touse)
{
	real scalar i, kby, rc
	real colvector io, vbyvar, by
	real matrix bytable
	string scalar tname, cmd, byvar

	pragma unset vbyvar

	if (which == "sd") {
		byvar = m_bysdvar
	}
	else {
		byvar = m_bycorvar
	}
	 /* validate/unabbreviate					*/
	if (rc=__sub_expr_validate_var(byvar,m_errmsg)) {
		return(rc)
	}
	if (rc=__sub_expr_validate_touse(touse,m_errmsg)) {
		return(rc)
	}
	tname = st_tempname()	
	/* assumption: by var is integer valued				*/
	/* make byvar sequential integer valued				*/
	cmd = sprintf("qui egen long %s = group(%s) if %s",tname,byvar,
			touse)
	if (rc=_stata(cmd)) {
		m_errmsg = sprintf("Stata command {bf:%s} failed",cmd)
		return(498)
	}
	by = st_data(.,tname,touse) 
	st_dropvar(tname)
	st_view(vbyvar,.,byvar,touse)	// original variable

	kby = colmax(by)
	bytable = J(kby,2,0)
	/* map new sequential index to true index, save freq		*/
	for (i=1; i<=kby; i++) {
		io = (by:==i)
		bytable[i,`BYVAR_INDEX'] = select(vbyvar,io)[1]
		bytable[i,`BYVAR_COUNT'] = sum(io)
	}
	if (which == "sd") {
		m_bysd = by
		m_bysdtable = bytable

		m_mxsdind = ::rows(by)
	}
	else {
		m_bycor = by
		m_bycortable = bytable

		m_mxcorind = ::rows(by)
	}
	return(0)
}

real scalar __ecovmatrix::initialize_ivar(string scalar which,
			string scalar touse)
{
	real scalar i, kind, rc
	real colvector io, vivar, index
	real matrix itable
	string scalar tname, cmd, ivar

	pragma unset vivar

	if (which == "sd") {
		ivar = m_isdvar
	}
	else {
		ivar = m_icorvar
	}
	 /* validate/unabbreviate					*/
	if (rc=__sub_expr_validate_var(ivar,m_errmsg)) {
		return(rc)
	}
	if (rc=__sub_expr_validate_touse(touse,m_errmsg)) {
		return(rc)
	}
	tname = st_tempname()	
	/* assumption: by var is integer valued				*/
	/* make ivar sequential integer valued				*/
	cmd = sprintf("qui egen long %s = group(%s) if %s",tname,ivar,
			touse)
	if (rc=_stata(cmd)) {
		m_errmsg = sprintf("Stata command {bf:%s} failed",cmd)
		return(498)
	}
	index = st_data(.,tname,touse) 
	st_dropvar(tname)
	st_view(vivar,.,ivar,touse)	// original variable

	kind = colmax(index)
	itable = J(kind,2,0)
	/* map new sequential index to true index, save freq		*/
	for (i=1; i<=kind; i++) {
		io = (index:==i)
		itable[i,`IVAR_INDEX'] = select(vivar,io)[1]
		itable[i,`IVAR_COUNT'] = sum(io)
	}
	if (which == "sd") {
		m_indsd = index
		m_isdtable = itable

		m_mxsdind = ::rows(index)
	}
	else {
		m_indcor = index
		m_icortable = itable

		m_mxcorind = ::rows(index)
	}
	return(0)
}

void __ecovmatrix::reestablish_views(string scalar touse, |real scalar noegen)
{
	noegen = (missing(noegen)?`FALSE':(noegen!=`FALSE'))
	if (strlen(m_bycorvar)) {
		(void)initialize_byvar("cor",touse)
	}
	if (strlen(m_bysdvar)) {
		(void)initialize_byvar("sd",touse)
	}
	if (strlen(m_tvar)) {
		st_view(m_t,.,m_tvar,touse)
	}
	if (strlen(m_pvar) & m_pvar!=FITTED) {
		st_view(m_p,.,m_pvar,touse)
	}
	if (strlen(m_icorvar)) {
		if (noegen) {
			/* just refresh data				*/
			m_indcor = st_data(.,m_icorvar,touse)
		}
		else {
			(void)initialize_ivar("cor",touse)
		}
	}
	if (strlen(m_isdvar)) {
		if (noegen) {
			/* just refresh data				*/
			m_indsd = st_data(.,m_isdvar,touse)
		}
		else {
			(void)initialize_ivar("sd",touse)
		}
	}
}

string scalar __ecovmatrix::identifier()
{
	real scalar kbysd, kbycor
	string scalar id

	kbysd = length(m_bysd)
	kbycor = length(m_bycor)
	if (kbysd & kbycor) {
		id = sprintf("cov(Residual)_%g_%g",
				m_bysdtable[m_isd,`BYVAR_INDEX'],
				m_bycortable[m_icor,`BYVAR_INDEX'])
	}
	else if (kbysd) {
		id = sprintf("cov(Residual)_%g",
				m_bysdtable[m_isd,`BYVAR_INDEX'])
	}
	else if (kbycor) {
		id = sprintf("cov(Residual)_%g",
				m_bycortable[m_icor,`BYVAR_INDEX'])
	}
	else {
		id = "cov(Residual)"
	}
	return(id)
}

real scalar __ecovmatrix::vtype()
{
	return(m_sd[m_isd].type())	// any one will do
}

real scalar __ecovmatrix::ctype()
{
	return(m_cor[m_icor].type())	// any one will do
}

string scalar __ecovmatrix::svtype()
{
	return(m_sd[m_isd].stype())	// any one will do
}

string scalar __ecovmatrix::sctype()
{
	return(m_cor[m_icor].stype())	// any one will do
}

void __ecovmatrix::return_post()
{
	real scalar i, ksd, kcor, vtype
	class __stmatrix scalar b

	st_numscalar("r(sigma)",exp(m_lnsigma))

	ksd = bycount(STDDEV)
	if (ksd) {
		st_numscalar("r(k_var_panels)",ksd)
	}
	else {
		ksd = 1
	}
	for (i=1; i<=ksd; i++) {
		m_sd[i].return_post()
	}

	kcor = length(m_cor)
	if (kcor) {
		st_numscalar("r(k_cor_panels)",kcor)
	}
	else {
		kcor = 1
	}
	for (i=1; i<=kcor; i++) {
		m_cor[i].return_post()
	}
	b = params_est_metric()
	if (b.cols()) {
		b.st_matrix("r(b_res_cov)")	
	}
	vtype = vtype()
	if (vtype==POWER | vtype==CONSTPOWER) {
		st_global("r(power_res_var)",m_pvar)
	}
	else if (vtype == LINEAR) {
		st_global("r(linear_res_var)",m_pvar)
	}
	else if (vtype == EXPONENTIAL) {
		st_global("r(exponential_res_var)",m_pvar)
	}
}

end
exit
