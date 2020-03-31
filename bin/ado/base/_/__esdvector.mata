*! version 1.0.3  20jul2018

/* implementation for
 *
 * class __esdvector extends __stmatrix		residual standard deviations
*/

findfile __sub_expr_global.matah
quietly include `"`r(fn)'"'

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __ecovmatrix.matah
quietly include `"`r(fn)'"'

mata:
mata set matastrict on

/* __esdvector implementation: standard deviations for residual		*/
void __esdvector::new()
{
	clear()
}

void __esdvector::destroy()
{
	clear()
}

void __esdvector::clear()
{
	m_b.erase()
	m_trans = `TRANSFORM_NONE'
	m_sdtypes = (`VAR_RESID_TYPES')
	m_type = `COV_NONE'
	m_kpar = 0
	m_ksd = 0
}

real colvector __esdvector::sd()
{
	return(m())
}

real scalar __esdvector::kpar()
{
	return(m_kpar)
}

real scalar __esdvector::ksd()
{
	return(m_ksd)
}

real scalar __esdvector::type()
{
	return(m_type)
}

string scalar __esdvector::stype()
{
	return(m_sdtypes[m_type+1])
}

real scalar __esdvector::transform()
{
	return(m_trans)
}

string scalar __esdvector::errmsg()
{
	return(m_errmsg)
}

real scalar __esdvector::construct(real scalar type, |real colvector id,
			real colvector ilab, real scalar order, real scalar isd)
{
	real scalar rc
	real rowvector b
	string scalar symbol
	string matrix stripe
	
	m_type = `COV_NONE'
	m_kpar = m_ksd = 0
	m_b.erase()
	m_id = .
	if (type<`VAR_RESID_HOMOSKEDASTIC' | type>`VAR_RESID_EXPONENTIAL') {
		m_errmsg = "failed to construct standard deviation object; " +
			"invalid variance structure type"
		return(498)
	}
	m_type = type
	if (missing(isd)) {
		isd = 1		// no byvar
	}
	m_id = id	// byvar id, can be missing if no byvar
	if (m_type == `COV_NONE') {
		return(0)
	}
	if (m_type == `VAR_RESID_CONSTPOWER') {
		m_kpar = 2
		if (missing(m_id)) {
			stripe = (J(2,1,"/Residual"),("delta"\"ln_cons"))
		}
		else {
			stripe = (J(2,1,"/Residual"),
				(sprintf("delta_%g",m_id)\
				 sprintf("ln_cons_%g",m_id)))
		}
		m_trans = `TRANSFORM_LOG'
		b = (1,-2.3)	// log(.1) ~ -2.3
	}
	else if (m_type==`VAR_RESID_POWER' | m_type==`VAR_RESID_EXPONENTIAL') {
		if (m_type == `VAR_RESID_POWER') {
			symbol = "delta"
		}
		else { 	// m_type==`VAR_RESID_EXPONENTIAL'
			symbol = "gamma"
		}
		m_kpar = 1
		if (missing(m_id)) {
			stripe = ("/Residual",symbol)
		}
		else {
			stripe = ("/Residual",
				sprintf("%s_%g",symbol,m_id))
		}
		b = 1
	}
	else if (m_type == `VAR_RESID_HETEROSKEDASTIC') {
		if (missing(order) | floatround(order)!=order | order<1) {
			m_errmsg = "invalid heteroskedastic residual " +
				"variance order"
			return(498)
		}
		m_trans = `TRANSFORM_LOG' 
		m_kpar = m_ksd = order-1
		if (m_kpar) {
			m_ilab = ilab
			if (length(m_ilab) != order) {
				m_errmsg = "invalid heteroskedastic residual " +
					"variance indices"
				return(498)
			}
			stripe = (J(m_kpar,1,"/Residual"),
				"lnsigrat_":+strofreal(m_ilab[|2\order|]))
		}
		b = J(1,m_kpar,0)	// log(1)
	}
	else if (m_type == `VAR_RESID_HOMOSKEDASTIC') {
		if (isd > 1) {
			m_kpar = m_ksd = 1
			m_trans = `TRANSFORM_LOG' 
			stripe = (J(m_kpar,1,"/Residual"),
				sprintf("lnsigrat_%g",id))
			b = J(1,m_kpar,0)	// log(1)
		}
	}
	else if (m_type == `VAR_RESID_LINEAR') {
		if (isd > 1) {
			m_kpar = m_ksd = 1
			m_trans = `TRANSFORM_LOG' 
			stripe = (J(m_kpar,1,"/Residual"),
				sprintf("lndelta_%g",id))
			b = J(1,m_kpar,0)	// log(1)
		}
	}
	else {
		m_type = `COV_NONE'
		m_errmsg = "not implemented"
		return(498)
	}
	if (m_kpar) {
		if (rc=m_b.set_colstripe(stripe)) {
			return(rc)
		}
	}
	return(set_parameters(b))
}

void __esdvector::erase()
{
	super.erase()

	clear()
}

real scalar __esdvector::set_rowstripe(string matrix stripe)
{
	return(super.set_rowstripe(stripe))
}

real scalar __esdvector::set_colstripe(string matrix stripe)
{
	return(super.set_colstripe(stripe))
}

real scalar __esdvector::set_matrix(real matrix mat, |string scalar name)
{
	return(super.set_matrix(mat,name))
}

real scalar __esdvector::set_parameters(real vector b)
{
	real scalar rc, k

	rc = 0
	if (m_type == `COV_NONE') {
		m_errmsg = "cannot set standard deviation parameters; " +
			"standard deviation structure not constructed"
		return(119) // out of context
	}
	if ((k=length(b)) != m_kpar) {
		m_errmsg = sprintf("expected standard deviation parameter " +
			"vector of length %g but got %g for {bf:%s} with %s " +
			"structure",m_kpar,k,identifier(),stype())
		return(503)
	}
	if (m_kpar) {
		if (::rows(b) == 1) {
			rc = m_b.set_matrix(b)
		}
		else {
			rc = m_b.set_matrix(b')
		}
	}
	return(rc)
}

class __stmatrix scalar __esdvector::parameters()
{
	return(m_b)
}

real scalar __esdvector::compute_sd(real scalar m, |real colvector p)
{
	real scalar k, rc
	real rowvector b
	real colvector sd

        if (m_type == `COV_NONE') {
                return(0)
        }
	if (missing(m) | m<1) {
		m_errmsg = "failed to compute standard deviation vector; " +
			"invalid size"
		return(498)
	}
	rc = 0
	b = m_b.m()
	if (m_type == `VAR_RESID_HOMOSKEDASTIC') {
		if (!m_kpar) {
			sd = J(m,1,1)
		}
		else if (m_trans == `TRANSFORM_LOG') {
			sd = J(m,1,exp(b[1]))
		}
		else {
			sd = J(m,1,b[1])
		}
	}
	else if (m_type == `VAR_RESID_HETEROSKEDASTIC') {
		if (min(p)<1 | max(p)>m_kpar+1) {
			m_errmsg = "failed to compute standard deviation " + 
				"vector; invalid index vector"
			return(498)
		}
		if (m_trans == `TRANSFORM_LOG') {
			sd = exp((0\b')[p])
		}
		else {
			sd = (1\b')[p]	
		}
	}
	else if (m_type==`VAR_RESID_CONSTPOWER' | m_type==`VAR_RESID_POWER') {
		k = ::rows(p)
		if (k != m) {
			m_errmsg = "failed to compute standard deviation " + 
				"vector; invalid mean vector"
			return(498)
		}
		sd = abs(p):^b[1]
		if (missing(sd)) {
			/* p=0, b[1]<0					*/
			_editmissing(sd,0)
		}
		if (m_type==`VAR_RESID_CONSTPOWER') {
			if (m_trans == `TRANSFORM_LOG') {
				b[2] = exp(b[2])
			}
			sd = sd :+ b[2]
		}
	}
	else if (m_type == `VAR_RESID_LINEAR') {
		k = ::rows(p)
		if (k != m) {
			m_errmsg = "failed to compute standard deviation " + 
				"vector; invalid linear-variance vector"
			return(498)
		}
		sd = sqrt(p)
		if (m_kpar) {	// m_kpar == 1
			if (m_trans == `TRANSFORM_LOG') {
				b = exp(b)
			}
			sd = sd:*b[1]
		}
	}
	else if (m_type == `VAR_RESID_EXPONENTIAL') {
		k = ::rows(p)
		if (k != m) {
			m_errmsg = "failed to compute standard deviation " + 
				"vector; invalid exponential-variance vector"
			return(498)
		}
		sd = exp(b[1]*p)
	}
	else {
		m_errmsg = sprintf("%s std.dev not implemented",stype())
		return(498)
	}
	k = ::rows(sd)
	if (k) {
		rc = set_matrix(sd)
	}
	return(rc)
}

void __esdvector::return_post()
{
	if (m_type == `COV_NONE') {
		return
	}
	st_numscalar("r(kpar_res_var)",m_kpar)

	if (m_kpar) {
		if (!missing(m_id)) {
			m_b.st_matrix(sprintf("r(b_sd_%g)",m_id))
		}
		else {
			m_b.st_matrix("r(b_sd)")
		}
	}
	st_global("r(res_sd_type)",stype())
}

string scalar __esdvector::identifier()
{
	if (!missing(m_id)) {
		return(sprintf("var(Residual)_%g",m_id))
	}
	return("var(Residual)")
}


end
exit
