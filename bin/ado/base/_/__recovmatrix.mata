*! version 1.0.1  04apr2018

findfile __sub_expr_global.matah
quietly include `"`r(fn)'"'

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __recovmatrix.matah
quietly include `"`r(fn)'"'

mata:
mata set matastrict on

real matrix _menl_sqrt_matrix(real matrix C, |real scalar ldet)
{
	real colvector s
	real matrix U, V, S

	pragma unset s
	pragma unset V

	U = C
	_svd(U,s,V)
	s = sqrt(s)
	if (args()) {
		ldet = sum(log(s))
	}
	S = U*diag(s)*V
	/* assumption: C is symmetric					*/
	S = (S+S'):/2

	return(S)
}

void __recovmatrix::new()
{
	HOMOSKEDASTIC		= `VAR_RE_HOMOSKEDASTIC'
	HETEROSKEDASTIC		= `VAR_RE_HETEROSKEDASTIC'
	FIXED			= `VAR_RE_FIXED'
	PATTERN			= `VAR_RE_PATTERN'

	INDEPENDENT		= `COR_RE_INDEPENDENT'
	EXCHANGEABLE		= `COR_RE_EXCHANGEABLE'
	UNSTRUCTURED		= `COR_RE_UNSTRUCTURED'

	clear()
}

void __recovmatrix::destroy()
{
	clear()
	m_sd.clear()
}

void __recovmatrix::clear()
{
	m_sd.clear()
	m_cor.clear()

	m_path = ""
	m_names = J(1,0,"")

	m_fixpat.clear()
}

void __recovmatrix::erase()
{
	super.erase()

	clear()
}

real scalar __recovmatrix::set_rowstripe(string matrix stripe)
{
	return(super.set_rowstripe(stripe))
}

real scalar __recovmatrix::set_colstripe(string matrix stripe)
{
	return(super.set_colstripe(stripe))
}

real scalar __recovmatrix::set_matrix(real matrix mat, |string scalar name)
{
	return(super.set_matrix(mat,name))
}

string scalar __recovmatrix::path()
{
	return(m_path)
}

string vector __recovmatrix::LVnames()
{
	return(m_names)
}

string scalar __recovmatrix::svtype()
{
	return(m_sd.stype())
}

string scalar __recovmatrix::sctype()
{
	return(m_cor.stype())
}

string scalar __recovmatrix::identifier()
{
	return(sprintf("cov(%s)",invtokens(m_names,",")))
}

string scalar __recovmatrix::errmsg()
{
	return(m_errmsg)
}

class __stmatrix scalar __recovmatrix::fixpat()
{
	return(m_fixpat)
}

void __recovmatrix::compute_V()
{
	real matrix V
	real colvector s

	m_sd.compute_sd()
	s = m_sd.sd()
	if (!length(s)) {
		return
	}
	m_cor.compute_R()
	V = m_cor.R()

	V = s':*V:*s
	V = (V+V'):/2

	(void)set_matrix(V)
}

real matrix __recovmatrix::factor_matrix(|real scalar rank)
{
	real colvector s
	real matrix R

	/* assumption: compute_V() has been called			*/
	R = R()
	rank = _factorsym(R)
	s = sd()
	R = s:*R

	return(R)
} 

real matrix __recovmatrix::sqrt_matrix(|real scalar ldet)
{
	real matrix S

	/* assumption: compute_V() has been called			*/
	if (args()) {
		S = _menl_sqrt_matrix(m(),ldet)
	}
	else {
		S = _menl_sqrt_matrix(m())
	}
	return(S)
} 

real matrix __recovmatrix::precision_factor(|real scalar ldet)
{
	real colvector s
	real matrix U, V, delta

	pragma unset s
	pragma unset V

	/* assumption: compute_V() has been called			*/
	U = m()
	_svd(U,s,V)
	s = 1:/sqrt(s)
	if (args()) {
		ldet = sum(log(s))
	}
	_transpose(V)
	_transpose(U)
	delta = V*diag(s)*U
	delta = (delta+delta'):/2

	return(delta)
} 

real matrix __recovmatrix::V()
{
	return(m())
}

real matrix __recovmatrix::R()
{
	return(m_cor.R())
}

void __recovmatrix::update_v()
{
	m_sd.update_v()
	m_cor.update_v()
}

real colvector __recovmatrix::sd()
{
	return(m_sd.sd())
}

class __stmatrix scalar __recovmatrix::lnsigma()
{
	return(m_sd.lnsigma())
}

real scalar __recovmatrix::set_lnsigma(real rowvector b)
{
	return(m_sd.set_lnsigma(b))
}

class __stmatrix scalar __recovmatrix::athrho()
{
	return(m_cor.athrho())
}

real scalar __recovmatrix::set_athrho(real rowvector b)
{
	return(m_cor.set_athrho(b))
}

real scalar __recovmatrix::set_parameters(real vector lnsigma,
			|real vector athrho)
{
        real scalar rc, kcor, kvar

        kcor = m_cor.kpar()
        kvar = m_sd.kpar()

        if (!kvar & !kcor) {
                m_errmsg = "cannot set covariance parameters; covariance " +
                        "structure not constructed"
                return(119) // out of context
        }
        if (kvar) {
                if (rc=m_sd.set_parameters(lnsigma)) {
                        m_errmsg = m_sd.errmsg()
                        return(rc)
                }
        }
        if (kcor) {
                if (rc=m_cor.set_parameters(athrho)) {
                        m_errmsg = m_cor.errmsg()
                        return(rc)
                }
        }
        compute_V()

	return(0)
}

real scalar __recovmatrix::cov2parameters(real matrix V)
{
	real scalar order, r, c, rc
	real colvector sd
	real matrix R

	order = m_sd.rows()

	r = ::rows(V)
	c = ::cols(V)
	if (r != c) {
		m_errmsg = sprintf("failed to initialize random effects " +
			"covariance parameters for {bf:%s} using a " +
			"specified covariance; matrix not square",
			identifier())
		return(498)
	}
	if (r != order) {
		m_errmsg = sprintf("failed to initialize random effects " +
			"covariance parameters for {bf:%s} using a " +
			"specified covariance; expected a matrix of " +
			"order %g but got %g",identifier(),order,r)
		return(498)
	}
	sd = sqrt(diagonal(V))
	if (rc=m_sd.sd2parameters(sd)) {
		m_errmsg = m_sd.errmsg()
		return(rc)
	}
	sd = 1:/sd
	R = sd':*V:*sd
	if (rc=m_cor.R2parameters(R)) {
		m_errmsg = m_sd.errmsg()
		return(rc)
	}
	compute_V()

	return(rc)
}

class __stmatrix scalar __recovmatrix::params_est_metric(|real scalar noscale)
{
	real scalar kcor, kvar
	real matrix b
	string matrix stripe
	class __stmatrix scalar sb, athr, lns

	noscale = (missing(noscale)?0:(noscale!=0))
	kvar = m_sd.kpar()
	kcor = m_cor.kpar()
	b = J(1,0,0)
	stripe = J(0,2,"")
	if (kvar) {
		lns = m_sd.lnsigma()
		b = lns.m()
		stripe = lns.colstripe()
	}
	if (kcor) {
		athr = m_cor.athrho()
		b = (b,athr.m())
		stripe = (stripe\athr.colstripe())
	}
	(void)sb.set_matrix(b)
	(void)sb.set_colstripe(stripe)
	(void)sb.set_rowstripe(("","est"))

	return(sb)
}

class __stmatrix scalar __recovmatrix::params_var_metric(|real matrix J, 
		real vector trans)
{
	real scalar i, cjac, kt, kp, r, s1, s2, is1, is2
	real scalar s12, ic, ia, athi, kvar, kcor
	real rowvector athr, lns, rho, sigma
	real vector trans1
	real matrix bv, bc, Jv, Jc, T
	string matrix stripev, stripec
	class __stmatrix scalar sb, athrho, lnsigma

	if (cjac=args()) {
		J = J(0,0,0)
		trans = J(1,0,0)
	}
	kcor = m_cor.kpar()
	kvar = m_sd.kpar()
	if (kvar) {
		lnsigma = m_sd.lnsigma()
		bv = exp(2:*lnsigma.m())
		stripev = lnsigma.colstripe()
		stripev[.,2] = subinstr(stripev[.,2],"lnsd","var")
		if (cjac) {
			Jv = diag(2:*bv)
			trans  = J(1,kvar,`TRANSFORM_LOG')
		}
	}
	if (!kcor) {
		(void)sb.set_matrix(bv)
		(void)sb.set_colstripe(stripev)
		(void)sb.set_rowstripe(("","var"))
		if (cjac) {
			J = Jv
		}
		return(sb)
	}
	kp = kvar + kcor
	if (kvar & cjac) {
		Jv = (Jv\J(kcor,kvar,0))
	}
	athrho = m_cor.athrho()
	stripec = athrho.colstripe()
	stripec[.,2] = subinstr(stripec[.,2],"athcorr","cov")

	athr = athrho.m()
	lns = lnsigma.m()
	rho = tanh(athr)
	sigma = exp(lns)

	T = cov_index_table()
	kt = ::rows(T)

	bc = J(1,kt,0)
	Jc = J(kp,kt,0)
	if (cjac) {
		trans1 = J(1,kt,`TRANSFORM_NONE')
	}
	for (i=1; i<=kt; i++) {
		ia = T[i,1]
		ic = ia+kvar
		is1 = T[i,2]
		is2 = T[i,3]
		athi = athr[ia]
		r = rho[ia]
		s1 = sigma[is1]
		s2 = sigma[is2]
		s12 = s1*s2
		bc[i] = r*s12
		if (cjac) {
			Jc[ic,i] = 4*s12/(exp(athi)+exp(-athi))^2
			if (is1 <= kp) {
				/* s1 not a fixed parameter		*/
				Jc[is1,i] = bc[i]
			}
			if (is2 <= kp) {
				/* s2 not a fixed parameter		*/
				if (is1 == is2) {
					Jc[is2,i] = 2*Jc[is2,i]
				}
				else {
					Jc[is2,i] = bc[i]
				}
			}
		}
	}
	if (!kvar) {
		sb.set_matrix(bc)
		sb.set_colstripe(stripec)
		sb.set_rowstripe(("","var"))
		if (cjac) {
			J = Jc
			trans = trans1
		}
		return(sb)
	}
	(void)sb.set_matrix((bv,bc))
	stripev = (stripev\stripec)
	(void)sb.set_colstripe(stripev)
	(void)sb.set_rowstripe(("","var"))
	if (cjac) {
		J = (Jv,Jc)
		trans = (trans,trans1)
	}
	return(sb)
}

class __stmatrix scalar __recovmatrix::params_sd_metric(|real matrix J,
			real vector trans)
{
	real scalar cjac, kcor, kvar
	real matrix bs, bc, athr, Js, Jc
	string matrix stripes, stripec
	class __stmatrix scalar sb, lnsigma, athrho

	if (cjac=args()) {
		J = J(0,0,0)
		trans = J(1,0,0)
	}
	kvar = m_sd.kpar()
	kcor = m_cor.kpar()
	if (kvar) {
		lnsigma = m_sd.lnsigma()
		bs = exp(lnsigma.m())
		stripes = lnsigma.colstripe()
		stripes[.,2] = subinstr(stripes[.,2],"lnsd","sd")
		if (cjac) {
			Js = diag(bs)
			trans = J(1,kvar,`TRANSFORM_LOG')
		}
	}
	if (!kcor) {
		(void)sb.set_matrix(bs)
		(void)sb.set_colstripe(stripes)
		(void)sb.set_rowstripe(("","sd"))
		J = Js

		return(sb)
	}
	if (kvar) {
		Js = (Js,J(kvar,kcor,0))
	}
	athrho = m_cor.athrho()
	athr = athrho.m()
	bc = tanh(athr)
	stripec = athrho.colstripe()
	stripec[.,2] = subinstr(stripec[.,2],"athcorr","corr")
	if (cjac) {
		if (kvar) {
			Jc = (J(kcor,kvar,0),
				diag(4:/(exp(athr)+exp(-athr)):^2))
		}
		else {
			Jc = diag(4:/(exp(athr)+exp(-athr)):^2)
		}
		trans = (trans,J(1,kcor,`TRANSFORM_ATANH'))
	}
	if (!kvar) {
		sb.set_matrix(bc)
		sb.set_colstripe(stripec)
		sb.set_rowstripe("sd")

		return(sb)
	}
	(void)sb.set_matrix((bs,bc))
	(void)sb.set_colstripe((stripes\stripec))
	(void)sb.set_rowstripe(("","sd"))
	if (cjac) {
		J = (Js\Jc)
	}
	return(sb)
}

real matrix __recovmatrix::cov_index_table()
{
	real scalar i, j, k, m, kh, skip, kcor
	real rowvector ij
	real colvector hv
	matrix T, Hc, IJ

	T = J(0,5,0)
	IJ = J(0,3,0)
	kcor = m_cor.kpar()
	hv = m_sd.iv()
	Hc = invvech(m_cor.iv())
	kh = ::rows(Hc)
	for (j=1; j<=kh; j++) {
		for (i=j+1; i<=kh; i++) {
			if (Hc[i,j] > kcor) {
				/* fixed correlation			*/
				continue
			}
			/*    cor     sd_i  sd_j   indices		*/
			ij = (Hc[i,j],hv[i],hv[j])
			m = ::rows(IJ)
			skip = 0
			/* check if indices are already in the table	*/
			for (k=1; k<=m; k++) {
				if (all(ij:==IJ[k,.])) {
					skip = 1
				}
			}
			if (skip) {
				continue
			}
			IJ = (IJ\ij)	// new set of var,cor indices
			T = (T\(ij,i,j))
		}
	}
	return(T)
}

real scalar __recovmatrix::ksdpar()
{
	return(m_sd.kpar())
}

real scalar __recovmatrix::kcorpar()
{
	return(m_cor.kpar())
}

real scalar __recovmatrix::vtype()
{
	return(m_sd.type())
}

real scalar __recovmatrix::ctype()
{
	return(m_cor.type())
}

real scalar __recovmatrix::construct(string scalar path,
		string vector names, real vector types, |real matrix fixpat)
{
	real scalar k, k1, k2, rc, vtype, ctype
	string scalar stype
	string matrix stripe

	m_fixpat.erase()	// user's fixed/pattern matrix

	/* sanity checks						*/
	rc = 0
	if (!(k=length(types))) {
		/* programmer error					*/
		m_errmsg = "invalid random effects covariance specification"
		return(198)
	}
	m_path = path
	if (!ustrlen(m_path)) {
		m_errmsg = "invalid covariance specification; hierarchy " +
			"path required"
		return(198)
	}
	ctype = .
	vtype = types[1]
	if (floatround(vtype)!=vtype | vtype<HOMOSKEDASTIC | vtype>PATTERN) {
		m_errmsg = sprintf("invalid covariance type specification " +
			"for path {bf:%s}; type must be one of " +
			"{bf:HOMOSKEDASTIC}, {bf:HETEROSKEDASTIC}, " +
			"{bf:FIXED}, or {bf:PATTERN}",m_path)
		return(125)	// out of range
	}
	if (vtype==FIXED | vtype==PATTERN) {
		ctype = vtype
	}
	else if (k>1) {
		ctype = types[2]
		if (floatround(ctype)!=ctype | ctype<INDEPENDENT | 
			ctype>UNSTRUCTURED) {
				m_errmsg = sprintf("invalid correlation type " +
					"specification for path {bf:%s}; " +
					"type must be one of " + 
					"{bf:INDEPENDENT}, " +
					"{bf:EXCHANGEABLE}, or " +
					"{bf:UNSTRUCTURED}",m_path)
				return(125)	// out of range
		}
	}
	k = length(names)
	if (::cols(names) == k) {
		m_names = names
	}
	else {
		m_names = names'
	}
	if (!k | any(ustrlen(names):==0)) {
		m_errmsg = sprintf("invalid covariance specification " +
			"for path {bf:%s}; latent variable names required",
			m_path)
		return(198)
	}
	if (vtype==FIXED | vtype==PATTERN) {
		if (vtype == FIXED) {
			stype = "fixed"
		}
		else {	
			stype = "pattern"
		}
		k1 = ::cols(fixpat)
		k2 = ::rows(fixpat)
		if (!k1 | !k2) {
			m_errmsg = sprintf("invalid covariance specification " +
				"for path {bf:%s}; %s matrix required",m_path,
				stype)
			return(498)
		}
		if (k1!=k | k2!=k) {
			m_errmsg = sprintf("invalid %s matrix for path " +
				"{bf:%s}; expected a %g x %g matrix but " +
				"got %g x %g",stype,m_path,k,k,k1,k2)
			return(498)
		}
		ctype = vtype
	}
	if (rc=m_sd.construct(vtype,path,names,fixpat)) {
		m_errmsg = m_sd.errmsg()
		return(rc)
	}
	if (rc=m_cor.construct(ctype,path,names,fixpat)) {
		m_errmsg = m_cor.errmsg()
		return(rc)
	}
	compute_V()
	stripe = (J(k,1,""),(m_names':+sprintf("[%s]",m_path)))
	(void)set_stripe(stripe)
	if (vtype==FIXED | vtype==PATTERN) {
		(void)m_fixpat.set_matrix(fixpat)
		(void)m_fixpat.set_stripe(stripe)
	}
	return(0)
}

void __recovmatrix::set_stripe_index(real scalar ind)
{
	m_sd.set_stripe_index(ind)
	m_cor.set_stripe_index(ind)
}

void __recovmatrix::return_post(|string scalar id)
{
	string scalar sid
	class __stmatrix scalar b

	b = params_est_metric()
	if (strlen(id)) {
		sid = "_"+id
	}
	else {
		sid = ""
	}
	if (b.cols()) {
		b.st_matrix(sprintf("r(b%s)",sid))
	}
	st_matrix(sprintf("r(cov%s)",sid))

	m_sd.return_post(id)
	m_cor.return_post(id)
}

end
exit
