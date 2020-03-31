*! version 1.0.0  25apr2018

/* implementation for
 *
 * class __recormatrix extends __stmatrix	RE correlation
*/

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __recovmatrix.matah
quietly include `"`r(fn)'"'

mata:
mata set matastrict on

/* __recormatrix implementation: correlation parameterization for
 *		random effects						*/
void __recormatrix::new()
{
	clear()
}

void __recormatrix::destroy()
{
	clear()
}

void __recormatrix::clear()
{
	m_type = `COV_UNDEFINED'

	m_cortypes = J(1,0,"")

	m_v = J(0,1,0)
	m_iv = J(0,1,0)
	m_fp = J(0,0,0)
	m_kpar = m_kfp = 0

	m_cortypes = (`COR_RE_TYPES')
	m_athrho.erase()
	m_fixpat.erase()
}

void __recormatrix::erase()
{
	super.erase()

	clear()
}

real scalar __recormatrix::set_matrix(real matrix mat, |string scalar name)
{
	return(super.set_matrix(mat,name))
}

real scalar __recormatrix::set_rowstripe(string matrix stripe)
{
	return(super.set_rowstripe(stripe))
}

real scalar __recormatrix::set_colstripe(string matrix stripe)
{
	return(super.set_colstripe(stripe))
}

void __recormatrix::compute_R()
{
	real matrix R

	R = invvech(m_v[m_iv])
	(void)set_matrix(R)
}

void __recormatrix::update_v()
{
	real rowvector vb

	/* caller must compute_R() after updating m_v			*/
	vb = J(1,0,0)
	if (m_kpar) {
		vb = tanh(m_athrho.m())
	}
	if (m_kfp) {
		m_v = (vb'\m_fp)
	}
	else {
		m_v = vb'
	}
}

real matrix __recormatrix::R()
{
	return(m())
}

real colvector __recormatrix::iv()
{
	return(m_iv)
}

class __stmatrix scalar __recormatrix::athrho()
{
	return(m_athrho)
}

real scalar __recormatrix::set_athrho(real rowvector b)
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
	if (rc=m_athrho.set_matrix(b)) {
		m_errmsg = m_athrho.errmsg()
		return(rc)
	}
	update_v()

	return(0)
}

real scalar __recormatrix::kpar()
{
	return(m_kpar)
}

real scalar __recormatrix::type()
{
	return(m_type)
}

string scalar __recormatrix::stype()
{
	return(m_cortypes[m_type+1])
}

string scalar __recormatrix::errmsg()
{
	return(m_errmsg)
}

real scalar __recormatrix::construct(real scalar type, string scalar path,
			string vector LVnames, |real matrix fixpat)
{
	real scalar rc, i, j, k, j1, j2
	real rowvector c
	real matrix Q
	string scalar eq
	string colvector cornames
	string matrix stripe

	m_kpar = m_kfp = 0
	m_athrho.erase()
	m_fp = J(0,1,0)
	m_type = `COV_UNDEFINED'
	m_fixpat.erase()
	m_path = path
	if (::rows(LVnames) == 1) {
		m_LVnames = LVnames
	}
	else {
		m_LVnames = LVnames'
	}
	rc = 0
	if (floatround(type)!=type | type<`COR_RE_INDEPENDENT' | 
		type>`COR_RE_PATTERN') {
		m_errmsg = sprintf("invalid correlation type specification " +
			"for path {bf:%s}; type must be one of " +
			"{bf:INDEPENDENT}, {bf:EXCHANGEABLE}, " +
			"{bf:UNSTRUCTURED}, {bf:FIXED}, or {bf:PATTERN}",m_path)
		return(125)	// out of range
	}
	k = length(m_LVnames)
	m_type = type
	if (k<=1 & m_type!=`COR_RE_INDEPENDENT') {
		m_errmsg = sprintf("invalid correlation specification " +
			"{bf:%s} for {bf:%s}; correlation must be " +
			"{bf:independent}, the default",stype(),m_LVnames[1])
		return(498)
	}
	/* get around not allowing # and > together in stripe group 
	 * name								*/
	if (ustrpos(m_path,"#") & ustrpos(m_path,">")) {
		eq = sprintf("/[%s]",m_path)
	}
	else {
		eq = sprintf("/%s",m_path)
	}
	if (m_type == `COR_RE_INDEPENDENT') {
		m_kpar = 0	// no correlation parameters
		m_kfp = 2
		m_fp = (0\1)
		Q = J(k,k,1)+I(k)
		m_iv = vech(Q)
	}
	else if (m_type == `COR_RE_EXCHANGEABLE') {
		m_kpar = 1
		m_kfp = 1
		m_fp = 1
		Q = J(k,k,1)+I(k)
		m_iv = vech(Q)
		stripe = (eq,"athcorr")
	}
	else if (m_type == `COR_RE_UNSTRUCTURED') {
		m_kpar = k*(k-1)/2
		m_kfp = 1
		m_fp = 1
		Q = J(k,k,0)
		m_iv = J(k*(k+1)/2,1,0)
		stripe = J(m_kpar,2,eq)
		j1 = 0
		j2 = 0
		for (i=1; i<=k; i++) {
			m_iv[++j2] = m_kpar+1		// 1 diagonal
			for (j=i+1; j<=k; j++) {
				m_iv[++j2] = ++j1
				stripe[j1,2] = sprintf("athcorr(%s,%s)",
					m_LVnames[j],m_LVnames[i])
			}
		}
	}
	else if (m_type == `COR_RE_FIXED') {
		rc = construct_fixed(fixpat,stripe)
	}
	else { 	// PATTERN
		rc = construct_pattern(fixpat,stripe)
	}
	if (rc) {
		return(rc)
	}
	if (m_kpar) {
		if (rc=m_athrho.set_colstripe(stripe)) {
			return(rc)
		}
	}
	cornames = m_LVnames':+"[":+m_path:+"]"
	stripe = (J(k,1,""),cornames)
	if (rc=set_stripe(stripe)) {
		return(rc)
	}
	if (m_type==`COR_RE_FIXED' | m_type==`COR_RE_PATTERN') {
		if (rc=m_fixpat.set_rowstripe(stripe)) {
			m_errmsg = m_fixpat.errmsg()
			return(rc)
		}
		if (rc=m_fixpat.set_colstripe(stripe)) {
			m_errmsg = m_fixpat.errmsg()
			return(rc)
		}
	}
	c = J(1,m_kpar,0)

	return(set_parameters(c))
}

void __recormatrix::set_stripe_index(real scalar ind)
{
	string matrix stripe

	if (m_type != `COR_RE_EXCHANGEABLE') {
		return
	}
	stripe = m_athrho.colstripe()
	/* resolve name conflict for multiple objects/path		*/
	stripe[1,2] = sprintf("%s%g",stripe[1,2],ind)
	(void)m_athrho.set_colstripe(stripe)
}

real scalar __recormatrix::construct_fixed(real matrix fixed,
		string matrix stripe)
{
	real scalar i, j, k, ki,rc
	real vector ic, ix, c, x
	real matrix fp, K, L
	string scalar eq

	k = ::rows(fixed)	// caller validated dimension
	x = c = J(0,1,0)
	ix = ic = J(0,1,0)
	m_kpar = m_kfp = 0
	m_fp = J(0,1,0)		// vech fixed parameter vector
	ki = 0
	/* get around not allowing # and > together in stripe group
	 *  name							*/
	if (ustrpos(m_path,"#") & ustrpos(m_path,">")) {
		eq = sprintf("/[%s]",m_path)
	}
	else {
		eq = sprintf("/%s",m_path)
	}
	stripe = J(0,2,"")
	if (k == 1) {	// no correlations
		ki++
		ix = ki
		ic = ix
		m_iv = ic
	}
	else {
		for (j=1; j<=k; j++) {
			for (i=j+1; i<=k; i++) {
				ki++
				if (missing(fixed[i,j])) { // free parameter
					ic = (ic\ki)
					c = (c\0)
					m_kpar++
					stripe = (stripe\(eq,
						sprintf("athcorr(%s,%s)",
							m_LVnames[i],
							m_LVnames[j])))
				}
				else {	// fixed
					ix = (ix\ki)
					x = (x\fixed[i,j])
					m_kfp++
				}
			}
		}
		ic = (ic\ix)
		ic = invorder(ic)
		K = invvech(ic)		// k-1 x k-1
		L = J(k,k,0)
		L[|2,1\k,k-1|] = K
		_diag(L,J(k,1,++ki))	// reference constant diagonal = 1
		m_iv = vech(L)
	}
	m_kfp++			// diagonal = 1
	x = (x\1)
	m_fp = x
	m_v = (c\x)
	/* retain user fixed matrix, diagonal fixed to 1		*/
	fp = fixed
	_diag(fp,J(k,1,1))
	if (rc=m_fixpat.set_matrix(fp)) {
		m_errmsg = m_fixpat.errmsg()
	}
	return(rc)
}

real scalar __recormatrix::construct_pattern(real matrix pattern,
		string matrix stripe)
{
	real scalar k, ki, i, j, i1, j1, ip, rc
	real colvector c, ic, jj
	real matrix pk, fp
	string scalar eq

	k = ::rows(pattern)	// caller validated dimension
	c = J(0,1,0)
	ic = J(0,1,0)
	m_kpar = m_kfp = 0
	m_fp = J(0,1,0)		// vech fixed parameter vector
	pk = J(0,2,0)
	ki = 0
	/* get around not allowing # and > together in stripe group 
	 * name								*/
	if (ustrpos(m_path,"#") & ustrpos(m_path,">")) {
		eq = sprintf("/[%s]",m_path)
	}
	else {
		eq = sprintf("/%s",m_path)
	}
	stripe = J(0,2,"")
	for (j=1; j<=k; j++) {
		for (i=j+1; i<=k; i++) {
			ip = pattern[i,j]
			i1 = .
			if (!missing(ip)) {
				jj = (ip:==pk[.,1])
				if (any(jj)) {
					i1 = selectindex(jj)[1]
				}
			}
			if (missing(i1)) {
				c = (c\0)
				ic = (ic\++ki)
				pk = (pk\(ip,ki))
				if (missing(ip)) {
					stripe = (stripe\(eq,
						sprintf("athcorr(%s,%s)",
						m_LVnames[i],m_LVnames[j])))
				}
				else {
					stripe = (stripe\(eq,
						sprintf("athcorr(%g)",ip)))
				}
			}
			else {
				ic = (ic\pk[i1,2])
			}

		}
	}
	fp = pattern
	_diag(fp,J(k,1,.z))	// mark diagonal extended missing .z
	if (rc=m_fixpat.set_matrix(pattern)) {
		m_errmsg = m_fixpat.errmsg()
		return(rc)
	}
	m_kpar = length(c)
	m_iv = J(k*(k+1)/2,1,0)
	i1 = j1 = 0
	for (i=1; i<=k; i++) {
		m_iv[++i1] = m_kpar+1	// diagonal fixed at 1
		for (j=i+1; j<=k; j++) {
			m_iv[++i1] = ic[++j1]
		}
	}
	m_kfp = 1		// diagonal 1's
	m_fp = 1
	m_v = (c\m_fp)

	return(0)
}

real scalar __recormatrix::set_parameters(real vector athrho)
{
	real scalar rc
	real rowvector b

	if (m_type == `COV_UNDEFINED') {
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
	update_v()
	compute_R()

	return(0)
}

real scalar __recormatrix::R2parameters(real matrix R)
{
	real scalar i, j, k, r, c, dim, rc, skipdiag
	real rowvector athrho, m
	real matrix fixpat

	r = ::rows(R)
	c = ::cols(R)
	dim = cols()
	rc = 0
	if ((r!=c) | (r!=dim)) {
		m_errmsg = sprintf("failed to convert correlation matrix " +
			"to parameters for {bf:%s}; expected a %g x %g " +
			"matrix but got %g x %g",invtokens(m_LVnames,","),dim,
			dim,r,c)
		return(503)
	} 
	skipdiag = 1
	if (m_type == `COR_RE_INDEPENDENT') {
		return(0)
	}
	else if (m_type == `COR_RE_EXCHANGEABLE') {
		athrho = atanh(mean(vech(R,skipdiag)))
	}
	else if (m_type == `COR_RE_UNSTRUCTURED') {
		athrho = atanh(vech(R,skipdiag))'
	}
	else if (m_type == `COR_RE_FIXED') {
		/* not used						 */
		athrho = J(1,m_kpar,0)
		fixpat = m_fixpat.m()
		k = 0
		for (j=1; j<=dim; j++) {
			for (i=j+1; i<=dim; i++) {
				if (missing(fixpat[i,j])) {
					athrho[++k] = atanh(R[i,j])
				}
			}
		}
	}
	else {	// m_type == `COR_RE_PATTERN')
		/* not used						 */
		athrho = J(1,m_kpar,0)
		m = J(1,m_kpar,0)
		fixpat = m_fixpat.m()
		k = 0
		for (j=1; j<=dim; j++) {
			for (i=j+1; i<=dim; i++) {
				k = fixpat[i,j]
				athrho[k] = athrho[k] + R[i,j]
				m[k] = m[k] + 1
			}
		}
		athrho = atanh(athrho:/m)
	}
	if (!(rc=set_athrho(athrho))) {
		update_v()
		compute_R()
	}
	return(rc)
}

void __recormatrix::return_post(|string scalar id)
{
	string scalar sid

	if (strlen(id)) {
		sid = "_"+id
	}
	else {
		sid = ""
	}
	::st_matrix(sprintf("r(c%s)",sid),m_v)
	::st_matrix(sprintf("r(ic%s)",sid),m_iv)
	st_numscalar(sprintf("r(kpar_cor%s)",sid),m_kpar)
	st_numscalar(sprintf("r(kfp_cor%s)",sid),m_kfp)

	if (m_type == `COR_RE_FIXED') {
		m_fixpat.st_matrix(sprintf("r(cfixed%s)",sid))
	}
	else if (m_type == `COR_RE_PATTERN') {
		m_fixpat.st_matrix(sprintf("r(cpattern%s)",sid))
	}
	if (m_kpar) {
		m_athrho.st_matrix(sprintf("r(b_re_cor%s)",sid))
	}
	st_global(sprintf("r(re_cor%s_type)",sid),m_cortypes[m_type])
}

string scalar __recormatrix::identifier()
{
	real scalar k

	if (!(k=length(m_LVnames))) {
		return("")
	}
	if (k == 1) {
		return(sprintf("var(%s)",m_LVnames[1]))
	}
	return(sprintf("cov(%s)",invtokens(m_LVnames,",")))
}

end
