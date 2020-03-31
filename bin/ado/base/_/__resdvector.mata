*! version 1.0.1  25apr2018

/* implementation for
 *
 * class __resdvector extends __stmatrix        RE standard deviations
*/


findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __recovmatrix.matah
quietly include `"`r(fn)'"'

mata:
mata set matastrict on

/* __resdvector implementation: standard deviation parameterization
 *  for random effects							*/ 
void __resdvector::new()
{
	clear()
}

void __resdvector::destroy()
{
	clear()
}

void __resdvector::clear()
{
	m_type = `COV_UNDEFINED'

        m_v = J(0,1,0)
        m_iv = J(0,1,0)         // sd = m_v[m_iv]
        m_fp = J(0,1,0)         // fixed parameters
        m_kpar = m_kfp = 0      // # std.dev & # fixed parameters

	m_sdtypes = (`VAR_RE_TYPES')
        m_lnsigma.erase()       // log transformed parameters
	m_fixpat.erase()	// diag of user's fixed/pattern matrix
}

void __resdvector::erase()
{
	super.erase()

	clear()
}

real scalar __resdvector::set_rowstripe(string matrix stripe)
{
	return(super.set_rowstripe(stripe))
}

real scalar __resdvector::set_colstripe(string matrix stripe)
{
	return(super.set_colstripe(stripe))
}

real scalar __resdvector::set_matrix(real matrix mat, |string scalar name)
{
	return(super.set_matrix(mat,name))
}

void __resdvector::update_v()
{
	real rowvector vb

	/* caller must compute_sd() after updating m_v			*/
	vb = J(1,0,0)
	if (m_kpar) {
		vb = exp(m_lnsigma.m())
	}
	if (m_kfp) {
		m_v = (vb'\m_fp)
	}
	else {
		m_v = vb'
	}
}

real colvector __resdvector::sd()
{
	return(m())
}

real colvector __resdvector::iv()
{
	return(m_iv)
}

class __stmatrix scalar __resdvector::lnsigma()
{
	return(m_lnsigma)
}

real scalar __resdvector::set_lnsigma(real rowvector b)
{
	real scalar k, rc

	k = ::cols(b)
	if (m_kpar != k) {
		m_errmsg = sprintf("failed to initialize standard deviation " +
			"parameters; expected a row vector of length %g " +
			"but got %g",cols(),k)
		return(503)
	}
	if (!m_kpar) {
		return(0)
	}
	if (rc=m_lnsigma.set_matrix(b)) {
		m_errmsg = m_lnsigma.errmsg()
		return(rc)
	}
	update_v()

	return(0)
}

real scalar __resdvector::kpar()
{
	return(m_kpar)
}

real scalar __resdvector::type()
{
	return(m_type)
}

string scalar __resdvector::stype()
{
	return(m_sdtypes[m_type+1])
}

string scalar __resdvector::errmsg()
{
	return(m_errmsg)
}

real scalar __resdvector::set_parameters(real vector lnsigma)
{
	real scalar rc, k

	rc = 0
	if ((k=length(lnsigma)) != m_kpar) {
		m_errmsg = sprintf("expected variance parameter vector of " +
			"length %g but got %g for {bf:%s} with %s structure",
			m_kpar,k,identifier(),stype())
		return(503)
	}
	if (m_kpar) {
		if (::rows(lnsigma) == 1) {
			rc = set_lnsigma(lnsigma)
		}
		else {
			rc = set_lnsigma(lnsigma')
		}
	}
	if (!rc) {
		update_v()
		compute_sd()
	}
	return(rc)
}

real scalar __resdvector::sd2parameters(real colvector sd)
{
	real scalar i, j, k, ksd, rc
	real rowvector lnsig, m
	real colvector fixpat

	k = rows()
	ksd = ::rows(sd)
	if (ksd != k) {
		m_errmsg = sprintf("failed to convert standard deviations " +
			"to parameters for {bf:%s}; expected a vector of " +
			"length %g but got %g",invtokens(m_LVnames,","),k,ksd)
		return(503)
	}
	if (m_type == `VAR_RE_HOMOSKEDASTIC') {
		lnsig = mean(log(sd))
	}
	else if (m_type == `VAR_RE_HETEROSKEDASTIC') {
		lnsig = log(sd')
	}
	else if (m_type == `VAR_RE_FIXED') {
		/* not used yet				 		*/
		fixpat = m_fixpat.m()
		lnsig = J(1,m_kpar,0)
		j = 0
		for (i=1; i<=k; i++) {
			if (missing(fixpat[i])) {
				lnsig[++j] = log(sd[i])
			}
		}
	}
	else { // (m_type == `VAR_RE_PATTERN')
		/* not used yet						*/
		fixpat = m_fixpat.m()
		lnsig = m = J(1,m_kpar,0)
		for (i=1; i<=k; i++) {
			j = fixpat[i]
			lnsig[j] = lnsig[j] + log(sd[i])
			m[j] = m[j] + 1
		}
		lnsig = lnsig:/m
	}
	if (!(rc=set_lnsigma(lnsig))) {
		update_v()
		compute_sd()
	}
	return(rc)
}

real scalar __resdvector::construct(real scalar type, string scalar path,
		string vector LVnames, |real matrix fixpat)
{
	real scalar rc, k
	real rowvector v
	string scalar eq
	string colvector sdnames
	string matrix stripe

	rc = 0
	m_kpar = m_kfp = 0
	m_lnsigma.erase()	// rowvector transformed variance parameters
	m_fp = J(0,1,0)		// vech fixed parameter vector
	m_type = `COV_UNDEFINED'
	m_fixpat.erase()	// diag of user's fixed/pattern matrix
	m_path = path
	if (::rows(LVnames) == 1) {
		m_LVnames = LVnames
	}
	else {
		m_LVnames = LVnames'
	}
	if (floatround(type)!=type | type<`VAR_RE_HOMOSKEDASTIC' | 
		type>`VAR_RE_PATTERN') {
		m_errmsg = sprintf("invalid standard deviation type " +
			"specification for path {bf:%s}; type must be one " +
			"of {bf:homoskedastic}, {bf:heteroskedastic}, " +
			"{bf:fixed}, or {bf:pattern}",m_path)
		return(125)	// out of range
	}
	m_type = type
	k = length(m_LVnames)
	/* get around not allowing # and > together in stripe group
	 *  name							*/
	if (ustrpos(m_path,"#") & ustrpos(m_path,">")) {
		eq = sprintf("/[%s]",m_path)
	}
	else {
		eq = sprintf("/%s",m_path)
	}
	if (m_type == `VAR_RE_HETEROSKEDASTIC') {
		/* k+1 element 0 for covariance				*/
		m_kpar = k
		m_iv = 1::k
		stripe = (J(k,1,eq),"lnsd(":+m_LVnames':+")")
	}
	else if (m_type == `VAR_RE_HOMOSKEDASTIC') {
		m_kpar = 1
		m_iv = J(k,1,1)
		if (k == 1) {
			stripe = (eq,sprintf("lnsd(%s)",m_LVnames[1]))
		}
		else {
			stripe = (eq,"lnsd")
		}
	}
	else if (m_type == `VAR_RE_FIXED') {
		rc = construct_fixed(fixpat,stripe)
	}
	else { 	// PATTERN
		rc = construct_pattern(fixpat,stripe)
	}
	if (rc) {
		return(rc)
	}
	if (m_kpar) {
		if (rc=m_lnsigma.set_colstripe(stripe)) {
			return(rc)
		}
	}
	sdnames = m_LVnames':+"[":+m_path:+"]"
	stripe = (J(k,1,""),sdnames)
	if (rc=set_rowstripe(stripe)) {
		return(rc)
	}
	if (m_type==`VAR_RE_FIXED' | m_type==`VAR_RE_PATTERN') {
		if (rc=m_fixpat.set_rowstripe(stripe)) {
			m_errmsg = m_fixpat.errmsg()
			return(rc)
		}
		if (m_type == `VAR_RE_FIXED') {
			(void)m_fixpat.set_colstripe(("","fixed"))
		}
		else {
			(void)m_fixpat.set_colstripe(("","pattern"))
		}
	}
	v = J(1,m_kpar,0)

	return(set_parameters(v))
}

void __resdvector::set_stripe_index(real scalar ind)
{
	string matrix stripe

	if (m_type != `VAR_RE_HOMOSKEDASTIC') {
		return
	}
	if (length(m_LVnames) == 1) {
		/* already decorated with LV name			*/
		return
	}
	stripe = m_lnsigma.colstripe()
	/* resolve name conflict for multiple objects/path		*/
	stripe[1,2] = sprintf("%s%g",stripe[1,2],ind)
	(void)m_lnsigma.set_colstripe(stripe)
}

real scalar __resdvector::construct_fixed(real matrix fixed,
		string matrix stripe)
{
	real scalar j, k, rc
	real vector iv, ix, v, x
	real colvector fp
	string scalar eq

	k = ::rows(fixed)	// caller validated dimension
	x = v = J(0,1,0)
	ix = iv = J(0,1,0)
	m_kpar = m_kfp = 0
	m_fp = J(0,1,0)	// vech fixed parameter vector
	stripe = J(0,2,"")
	/* get around not allowing # and > together in stripe group 
	 * name								*/
	if (ustrpos(m_path,"#") & ustrpos(m_path,">")) {
		eq = sprintf("/[%s]",m_path)
	}
	else {
		eq = sprintf("/%s",m_path)
	}
	for (j=1; j<=k; j++) {
		if (missing(fixed[j,j])) {	// free parameter
			iv = (iv\j)
			v = (v\0)
			m_kpar++
			stripe = (stripe\
				(eq,sprintf("lnsd(%s)",m_LVnames[j])))
		}
		else if (fixed[j,j] <= 0) {
			m_errmsg = sprintf("invalid fixed matrix for path " +
				"{bf:%s}; variance %g is %g",m_path,j,
				fixed[j,j])
			return(508)	// zero or neg diag
		}
		else {
			ix = (ix\j)
			x = (x\fixed[j,j])
			m_kfp++
		}
	}
	iv = (iv\ix)
	m_iv = invorder(iv)
	m_v = (v\x)
	m_fp = x
	fp = diagonal(fixed)
	/* retain diagonal of user fixed matrix				*/
	if (rc=m_fixpat.set_matrix(fp)) {
		m_errmsg = m_fixpat.errmsg()
	}
	return(rc)
}

real scalar __resdvector::construct_pattern(real matrix pattern,
		string matrix stripe)
{
	real scalar k, ki, j, i1, ip, rc
	real colvector v, iv, jj
	real rowvector fp
	real matrix pk
	string scalar eq

	rc = 0
	k = ::rows(pattern)	// caller validated dimension
	v = J(0,1,0)
	iv = J(0,1,0)
	m_kpar = m_kfp = 0
	m_fp = J(0,1,0)	// vech fixed parameter vector
	pk = J(0,2,0)
	ki = 0
	/* get around not allowing # and > together in stripe group
	 *  name							*/
	if (ustrpos(m_path,"#") & ustrpos(m_path,">")) {
		eq = sprintf("/[%s]",m_path)
	}
	else {
		eq = sprintf("/%s",m_path)
	}
	for (j=1; j<=k; j++) {
		ip = pattern[j,j]
		if (j == 1) {
			v = (v\0)
			++ki
			iv = (iv\ki)
			pk = (pk\(ip,ki))
		}
		else {
			i1 = .
			if (!missing(ip)) {
				jj = (ip:==pk[.,1])
				if (any(jj)) {
					i1 = selectindex(jj)[1]
				}
			}
			if (missing(i1)) {
				v = (v\0)
				++ki
				iv = (iv\ki)
				pk = (pk\(ip,ki))
			}
			else {
				iv = (iv\pk[i1,2])
			}
		}
	}
	fp = diagonal(pattern)
	m_kpar = length(v)
	m_iv = iv
	m_v = v
	if (rc=m_fixpat.set_matrix(fp)) {
		m_errmsg = m_fixpat.errmsg()
	}
	else if (m_kpar) {
		stripe = (J(m_kpar,1,eq),("lnsd(":+strofreal(pk[.,1]):+")"))
	}
	return(rc)
}

void __resdvector::compute_sd()
{
	real scalar r, c
	real colvector sd

	sd = m_v[m_iv]
	r = ::rows(sd)
	c = ::cols(sd)
	if (r==1 & c>1) {
		sd = sd'
	}
	(void)set_matrix(sd)
}

void __resdvector::return_post(|string scalar id)
{
	string scalar sid

	if (strlen(id)) {
		sid = "_"+id
	}
	else {
		sid = ""
	}
	::st_matrix(sprintf("r(v%s)",sid),m_v)
        ::st_matrix(sprintf("r(iv%s)",sid),m_iv)
	st_numscalar(sprintf("r(kpar_var%s)",sid),m_kpar)
        st_numscalar(sprintf("r(kfp_var%s)",sid),m_kfp)

	if (m_type == `VAR_RE_FIXED') {
		m_fixpat.st_matrix(sprintf("r(vfixed%s)",sid))
	}
	else if (m_type == `VAR_RE_PATTERN') {
		m_fixpat.st_matrix(sprintf("r(vpattern%s)",sid))
	}
	if (m_kpar) {
		m_lnsigma.st_matrix(sprintf("r(b_re%s_sd)",sid))
	}
	st_global(sprintf("r(re_sd%s_type)",sid),stype())
}

string scalar __resdvector::identifier()
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
exit
