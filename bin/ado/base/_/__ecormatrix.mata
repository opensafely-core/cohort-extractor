*! version 1.0.6  27nov2018

/* implementation for
 *
 * class __ecormatrix extends __stmatrix	residual correlation
*/

findfile __sub_expr_global.matah
quietly include `"`r(fn)'"'

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __ecovmatrix.matah
quietly include `"`r(fn)'"'

mata:
mata set matastrict on

real matrix correlation_autoregress(real scalar m, real scalar order,
			real rowvector rho)
{
	real scalar i, j, r1, s1, rs
	real matrix K

	/* discrete time						*/
	if (order == 1) {
		r1 = rho[1]
		s1 = 1/sqrt(1-r1*r1)

		K = diag(J(m,1,s1))
		rs = r1*s1
		for (i=1; i<=(m-1); i++) {
			K[i,i+1] = -rs
		}
		K[m,m] = 1
	}
	else {
		K = I(m)
		for (j=1; j<=order; j++) {
			r1 = -rho[j]
			for (i=1; i<=(m-j); i++) {
				K[i+j,i] = K[i+j,i] + r1
			}
		}
		K = K*K'
		for (i=1; i<=order; i++) {
			for (j=1; j<=order; j++) {
				K[m-i+1,m-j+1] = K[i,j]
			}
		}
		// K = cholesky(K)'
		(void)_factorsym(K)
		K = K'/K[m,m]
	}
	K = pinv(K)
	K = K*K'

	return(K)
}

real matrix correlation_cautoregress1(real colvector t, real scalar rho)
{
	real scalar j, m
	real colvector dt, q
	real matrix K

	/* continuous time						*/
	m = rows(t)
	if (m == 1) {
		return(I(1))
	}
	K = J(m,m,0)
	dt = t:-t[1]
	for (j=2; j<m; j++) {
		dt = (dt\(t[|j\m|]:-t[j]))
	}
	dt = (dt\0)
	q = rho:^dt
	K = invvech(q)

	return(K)
}

real matrix correlation_movingaverage(real scalar m, real scalar order,
			real rowvector theta)
{
	real scalar j, k, s1, j1, j2, t1, t2
	real matrix K

	K = J(m,m,0)
	for (k=0; k<=order; k++) {
		s1 = 0
		for (j=0; j<=order-k; j++) {
			j1 = j
			j2 = j + k
			t1 = ((j1==0)?1:theta[j1])
			t2 = ((j2==0)?1:theta[j2])
			s1 = s1 + t1*t2                            
		}
		for (j=1; j<=m-k; j++) {
			K[j,j+k] = K[j+k,j] = s1
		}
	}
	K = K/K[1,1]

	return(K)
}

void __ecormatrix::new()
{
	clear()
}

void __ecormatrix::destroy()
{
	clear()
}

void __ecormatrix::clear()
{
	m_type = `COV_NONE'
	m_order = .
	m_id = .
	m_trans = `TRANSFORM_NONE'
	m_cortypes = (`COR_RESID_TYPES')
	m_kpar = m_kcor = 0
	m_b.erase()
}

real vector __ecormatrix::order()
{
	return(m_order)
}

real scalar __ecormatrix::kpar()
{
	return(m_kpar)
}

real scalar __ecormatrix::kcor()
{
	return(m_kcor)
} 

real scalar __ecormatrix::type()
{
	return(m_type)
}

string scalar __ecormatrix::stype()
{
	return(m_cortypes[m_type+1])
}

real scalar __ecormatrix::transform()
{
	return(m_trans)
}

real matrix __ecormatrix::R()
{
	return(m())
}

string scalar __ecormatrix::errmsg()
{
	return(m_errmsg)
}

void __ecormatrix::erase()
{
	super.erase()

	clear()
}

real scalar __ecormatrix::set_rowstripe(string matrix stripe)
{
	return(super.set_rowstripe(stripe))
}

real scalar __ecormatrix::set_colstripe(string matrix stripe)
{
	return(super.set_colstripe(stripe))
}

real scalar __ecormatrix::set_matrix(real matrix mat, |string scalar name)
{
	return(super.set_matrix(mat,name))
}

real scalar __ecormatrix::set_parameters(real vector athrho)
{
	real scalar rc
	real rowvector b

	if (m_type == `COV_NONE') {
		m_errmsg = "cannot set correlation parameters; correlation " +
			"structure not constructed"
		return(119) // out of context
	}
	if (length(athrho) != m_kpar) {
		m_errmsg = sprintf("expected correlation parameter vector of " +
			"length %g but got %g for {bf:%s} with %s structure",
			m_kpar,length(athrho),identifier(),stype())
		return(503)
	}
	if (m_kpar) {
		if (::rows(athrho) == 1) {
			b = athrho
		}
		else {
			b = athrho'
		}
		if (rc=set_athrho(b)) {
			return(rc)
		}
	}
	return(0)
}

real scalar __ecormatrix::set_athrho(real rowvector b)
{
        real scalar k, rc

        k = ::cols(b)
        if (m_kpar != k) {
                m_errmsg = sprintf("failed to initialize correlation " +
                        "parameters; expected a row vector of length %g " +
                        "but got %g",cols(),k)
                return(503)
        }
        if (!m_kpar) {
                return(0)
        }
        if (rc=m_b.set_matrix(b)) {
                m_errmsg = m_b.errmsg()
                return(rc)
        }
        return(0)
}

class __stmatrix scalar __ecormatrix::parameters()
{
	return(m_b)
}

real scalar __ecormatrix::set_parameters(real vector athrho)
{
	real scalar rc
	real rowvector b

	if (m_type == `COV_NONE') {
		m_errmsg = "cannot set correlation parameters; correlation " +
			"structure not constructed"
		return(119) // out of context
	}
	if (length(athrho) != m_kpar) {
		m_errmsg = sprintf("expected correlation parameter vector of " +
			"length %g but got %g for {bf:%s} with %s structure",
			m_kpar,length(athrho),identifier(),stype())
		return(503)
	}
	if (m_kpar) {
		if (::rows(athrho) == 1) {
			b = athrho
		}
		else {
			b = athrho'
		}
		if (rc=set_athrho(b)) {
			return(rc)
		}
	}
	return(0)
}

real scalar __ecormatrix::set_athrho(real rowvector b)
{
        real scalar k, rc

        k = ::cols(b)
        if (m_kpar != k) {
                m_errmsg = sprintf("failed to initialize correlation " +
                        "parameters; expected a row vector of length %g " +
                        "but got %g",cols(),k)
                return(503)
        }
        if (!m_kpar) {
                return(0)
        }
        if (rc=m_b.set_matrix(b)) {
                m_errmsg = m_b.errmsg()
                return(rc)
        }
        return(0)
}

string scalar __ecormatrix::identifier()
{
	if (!missing(m_id)) {
		return(sprintf("corr(Residual)_%g",m_id))
	}
	return("corr(Residual)")
}

real scalar __ecormatrix::construct(real scalar type, |real scalar id,
			real colvector ilab, real vector order,
			real scalar icor)
{
	real scalar i, j, k, k1
	real rowvector b
	string scalar rname, pname
	string colvector cstr, lab1, lab2
	string matrix stripe

	/* dimension of the correlation matrix is dynamic, depending
	 *  on the panel size						*/
	m_id = .
	m_kpar = m_kcor = 0
	m_b.erase()
	m_type = `COV_NONE'
	m_trans = `TRANSFORM_NONE'

	if (type<`COR_RESID_INDEPENDENT' | type>`COR_RESID_UNSTRUCTURED') {
		m_errmsg = "failed to construct residual correlation object; " +
			"invalid correlation structure type"
		return(498)
	}
	/* by() option if icor > 1, more than one __ecormatrix object	*/
	m_id = id	// byvar id, can be missing if no byvar
	if (missing(icor)) {
		icor = 1	// no byvar
	}
	m_type = type
	if (m_type == `COV_NONE') {
		return(0)
	}
	if (m_type == `COR_RESID_EXCHANGEABLE') {
		m_kpar = m_kcor = 1
		m_trans = `TRANSFORM_ATANH'
		b = 0		// atanh(0)
		if (!missing(m_id)) {
			stripe = ("/Residual",
				sprintf("athcorr_%g",m_id))
		}
		else {
			stripe = ("/Residual","athcorr")
		}
		rname = "exch"
	}
	else if (m_type==`COR_RESID_AUTOREGRESS' | 
		m_type==`COR_RESID_MOVINGAVERAGE') {

		if (missing(order)) {
			order = 1
		}
		if (order==1 & m_type==`COR_RESID_AUTOREGRESS') {
			m_kcor = 1
		}
		if (edittointtol(order,.5)!=order | order<1) {
			m_errmsg = "invalid "+
				(m_type==`COR_RESID_AUTOREGRESS'?"ar":"ma")+
				" correlation order"
			return(498)
		}
		m_kpar = order
		m_order = order
		if (m_type == `COR_RESID_MOVINGAVERAGE') {
			rname = "ma"
			if (m_order == 1) {
				pname = "aththeta"
				m_trans = `TRANSFORM_ATANH'
			}
			else {
				pname = "theta"
			}
		}
		else { 
			rname = "ar"
			if (m_order == 1) {
				pname = "athcorr"
				m_trans = `TRANSFORM_ATANH'
			}
			else {
				pname = "phi"
			}
		}
		b = J(1,m_kpar,0)
		if (m_kpar == 1) {
			if (!missing(m_id)) {
				stripe = ("/Residual",
					sprintf("%s_%g",pname,m_id))
			}
			else {
				stripe = ("/Residual",pname)
			}
		}
		else {
			if (!missing(m_id)) {
				stripe = (J(m_kpar,1,"/Residual"),
					(sprintf("%s",pname):+
					strofreal(1::m_kpar):+
					sprintf("_%g",m_id)))
			}
			else {
				stripe = (J(m_kpar,1,"/Residual"),
					(sprintf("%s",pname):+
					strofreal(1::m_kpar)))
			}
		}
	}
	else if (m_type == `COR_RESID_CONTINUOUSAR1') {
		m_order = 1
		m_kpar = 1
		rname = "car"
		pname = "logitcorr"
		m_trans = `TRANSFORM_LOGIT'
		b = J(1,m_kpar,-3)	// invlogit(-3) ~ .047
		if (!missing(m_id)) {
			stripe = ("/Residual",sprintf("%s_%g",pname,m_id))
		}
		else {
			stripe = ("/Residual",pname)
		}
	}
	else if (m_type == `COR_RESID_BANDED') {
		/* order[1] = max size, order[2] = # bands		*/
		if (length(order)!=2 | missing(order) | 
			any(floatround(order):!=order) | any(order:<1)) {
			m_errmsg = "invalid banded correlation information"
			return(498)
		}
		m_ilab = ilab
		if (length(m_ilab) != order[1]) {
			m_errmsg = "invalid banded correlation label indices"
			return(498)
		}
		m_order = order
		k = order[1]-order[2]
		if (k < 1) {
			m_errmsg = "invalid banded correlation information"
			return(498)
		}
		m_kpar = m_kcor = order[1]*(order[1]-1)/2
		if (k > 1) {
			m_kpar = m_kcor = m_kpar-(k*(k-1)/2)
		}
		m_trans = `TRANSFORM_ATANH'
		b = J(1,m_kpar,0)
		if (m_kpar == 1) {
			if (!missing(m_id)) {
				stripe = ("/Residual",
					sprintf("athcorr_%g",m_id))
			}
			else {
				stripe = ("/Residual","athcorr")
			}
		}
		else {
			/* label athcorr(i,j) indices, vech order	*/
			cstr = J(0,1,"")
			for (j=1; j<m_order[1]; j++) {
				k = m_order[2]
				i = j+1
				if ((k1=i+m_order[2]-1) > m_order[1]) {
					k1 = m_order[1]
					k = 1
				}
				lab1 = strofreal(m_ilab[i::k1])
				lab2 = strofreal(J(k,1,m_ilab[j]))
				if (!missing(m_id)) {
					cstr = (cstr\
						(J(k,1,"athcorr("):+lab1:+
						",":+lab2:+sprintf(")_%s",
						m_id)))
				}
				else {
					cstr = (cstr\
						(J(k,1,"athcorr("):+lab1:+
						",":+lab2:+")"))
				}
			}
			stripe = (J(m_kpar,1,"/Residual"),cstr)
		}
		rname = "banded"
	}
	else if (m_type == `COR_RESID_TOEPLITZ') {
		/* order[1] = max size, order[2] = # bands		*/
		if (length(order)!=2 | missing(order) | 
			any(floatround(order):!=order) | any(order:<1)) {
			m_errmsg = "invalid toeplitz correlation information"
			return(498)
		}
		m_order = order
		k = order[1]-order[2]
		if (k < 1) {
			m_errmsg = "invalid toeplitz correlation information"
			return(498)
		}
		m_kpar = m_kcor = order[2]
		m_trans = `TRANSFORM_ATANH'
		b = J(1,m_kpar,0)
		if (m_kpar == 1) {
			if (!missing(m_id)) {
				stripe = ("/Residual",
					sprintf("athcorr1_%g",m_id))
			}
			else {
				stripe = ("/Residual","athcorr1")
			}
		}
		else {
			/* label athcorr_j indices band order		*/
			if (!missing(m_id)) {
				stripe = (J(m_kpar,1,"/Residual"),
					J(m_kpar,1,"athcorr"):+
					strofreal(1::m_order[2]):+"_":+
					J(m_kpar,1,strofreal(m_id)))
			}
			else {
				stripe = (J(m_kpar,1,"/Residual"),
					J(m_kpar,1,"athcorr"):+
					strofreal(1::m_order[2]))
			}
		}
		rname = "toeplitz"
	}
	else if (m_type == `COR_RESID_UNSTRUCTURED') {
		if (missing(order) | floatround(order)!=order | order<1) {
			m_errmsg = "invalid unstructured correlation size"
			return(498)
		}
		m_order = order
		m_ilab = ilab
		if (length(m_ilab) != m_order) {
			m_errmsg = "invalid banded correlation label indices"
			return(498)
		}
		m_kpar = m_kcor = order*(order-1)/2
		m_trans = `TRANSFORM_ATANH'
		b = J(1,m_kpar,0)
		if (m_kpar == 1) {
			if (!missing(m_id)) {
				stripe = ("/Residual",
					sprintf("athcorr_%g",m_id))
			}
			else {
				stripe = ("/Residual","athcorr")
			}
		}
		else {
			/* label athcorr(i,j) indices			*/
			cstr = J(0,1,"")
			for (i=1; i<m_order; i++) {
				k = m_order-i
				lab1 = strofreal(m_ilab[(i+1)::m_order])
				lab2 = J(k,1,strofreal(m_ilab[i]))
				if (!missing(m_id)) {
					cstr = (cstr\
						(J(k,1,"athcorr("):+lab1:+",":+
						lab2:+sprintf(")_%s",m_id)))
				}
				else {
					cstr = (cstr\
						(J(k,1,"athcorr("):+lab1:+",":+
						lab2:+")"))
				}
			}
			stripe = (J(m_kpar,1,"/Residual"),cstr)
		}
		rname = "unstructured"
	}
	else if (m_type != `COR_RESID_INDEPENDENT') {
		m_type = `COV_NONE'
		m_errmsg = "not implemented"
		return(498)
	}
	if (m_kpar) {
		(void)m_b.set_colstripe(stripe)
		(void)m_b.set_rowstripe(("",rname))
	}
	return(set_parameters(b))
}

real scalar __ecormatrix::compute_R(real scalar m, |real colvector t)
{
	real scalar i, j, j1, j2, k, rc
	real rowvector b
	real colvector dt
	real matrix K

	rc = 0
	if (m_type == `COV_NONE') {
		return(rc)
	}
	if (missing(m) | m<1) {
		m_errmsg = "failed to compute correlation matrix; " +
			"invalid size"
		return(498)
	}
	if (m_type == `COR_RESID_INDEPENDENT') {
		K = I(m)
	}
	else if (m_type == `COR_RESID_EXCHANGEABLE') {
		if (m_trans == `TRANSFORM_ATANH') {
			b = tanh(m_b.m())
		}
		else {
			b = m_b.m()
		}
		K = J(m,m,b)
		_diag(K,J(m,1,1))
	}
	else if (m_type==`COR_RESID_AUTOREGRESS' |
		m_type==`COR_RESID_MOVINGAVERAGE') {
		if (m_trans == `TRANSFORM_ATANH') {
			b = tanh(m_b.m())
		}
		else {
			b = m_b.m()
		}
		k = length(t)
		if (k > 1) {
			dt = t:-t[1]
			m = dt[k]+1
			if (all(dt[|2\k|]-dt[|1\k-1|]:==1)) {
				k = 0	// no skips, don't subset
			}
		}
		if (m == 1) {
			K = J(1,1,1)
		}
		else if (m_type == `COR_RESID_AUTOREGRESS') {
			K = correlation_autoregress(m,m_order,b)
		}
		else if (m_type == `COR_RESID_MOVINGAVERAGE') {
			K = correlation_movingaverage(m,m_order,b)
		}
		if (k > 1) {
			dt = dt:+1
			K = K[dt,dt]
		}
	}
	else if (m_type == `COR_RESID_CONTINUOUSAR1') {
		if (m_trans == `TRANSFORM_LOGIT') {
			b = invlogit(m_b.m())
		}
		else {
			b = m_b.m()
		}
		if (!length(t)) {
			m_errmsg = "failed to compute correlation matrix; " +
				"time variable required"
			return(498)
		}
		K = correlation_cautoregress1(t,b[1])
	}
	else if (m_type==`COR_RESID_TOEPLITZ' | m_type==`COR_RESID_BANDED') {
		if (m_trans == `TRANSFORM_ATANH') {
			b = tanh(m_b.m())
		}
		else {
			b = m_b.m()
		}
		if (!length(t)) {
			m_errmsg = "failed to compute correlation matrix; " +
				"time variable required"
			return(498)
		}
		if (any(t:<=0)) {
			m_errmsg = "failed to compute correlation matrix; " +
				"invalid time variable"
			return(498)
		}
		K = I(m_order[1])
		/* fill lower triangular				*/
		k = 0
		if (m_type == `COR_RESID_BANDED') {
			/* vech order					*/
			for (j=1; j<m_order[1]; j++) {
				if ((j1=j+m_order[2]) > m_order[1]) {
					j1 = m_order[1]
				}
				for (i=j+1; i<=j1; i++) {
					K[i,j] = b[++k]
				}
			}
		}
		else {
			for (j=1; j<=m_order[2]; j++) {
				k++
				for (i=j+1; i<=m_order[1]; i++) {
					K[i,i-j] = b[k]
				}
			}
		}
		/* copy lower triangle to upper				*/
		_makesymmetric(K)
		K = K[t,t]	// subset
	}
	else if (m_type == `COR_RESID_UNSTRUCTURED') {
		if (min(t)<1 | max(t)>m_order) {
			m_errmsg = "failed to compute correlation matrix; " +
				"invalid unstructured index vector"
			return(498)
		}
		if (m_trans == `TRANSFORM_ATANH') {
			b = tanh(m_b.m())
		}
		else {
			b = m_b.m()
		}
		K = I(m_order)
		j2 = 0
		/* fill lower triangular				*/
		for (i=1; i<m_order; i++) {
			j1 = j2+1
			j2 = j2+m_order-i
			K[|i+1,i\m_order,i|] = b[|j1\j2|]'
		}
		/* copy lower triangle to upper				*/
		_makesymmetric(K)
		K = K[t,t]	// subset
	}
        else {
                errprintf("correlation type %s not implemented\n",stype())
                exit(498)
        }
        rc = set_matrix(K)

	return(rc)
}

void __ecormatrix::return_post()
{
	if (m_type == `COV_NONE') {
		return
	}
	st_numscalar("r(kpar_res_cor)",m_kpar)
	if (m_kpar) {
		if (!missing(m_id)) {
			m_b.st_matrix(sprintf("r(b_cor_%g)",m_id))
		}
		else {
			m_b.st_matrix("r(b_cor)")
		}
	}
	st_global("r(res_cor_type)",stype())
	if (m_type == `COR_RESID_AUTOREGRESS') {
		st_numscalar("r(ar_order)",m_order)
	}
	else if (m_type == `COR_RESID_MOVINGAVERAGE') {
		st_numscalar("r(ma_order)",m_order)
	}
	else if (m_type == `COR_RESID_CONTINUOUSAR1') {
		st_numscalar("r(car_order)",m_order)
	}
}

end
exit
