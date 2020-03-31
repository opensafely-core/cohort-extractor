*! version 1.0.1  28jun2018

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __stparam_vector.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

void __stparam_vector::new()
{
	erase()
}

void __stparam_vector::destroy()
{
}

void __stparam_vector::erase()
{
	super.erase()

	m_eqs = J(0,2,0)
}

real scalar __stparam_vector::set_rowstripe(string matrix stripe)
{
	real scalar k

	k = ::rows(stripe)
	if (k != 1) {
		m_errmsg = sprintf("expected a row stripe with 1 row, but " +
			"got %g",k)
		return(503)
	}
	return(super.set_rowstripe(stripe))
}

real scalar __stparam_vector::set_colstripe(string matrix stripe)
{
	real scalar rc

	rc = super.set_colstripe(stripe)

	if (!rc & cols()) {
		m_ieqs = panelsetup(m_colstripe,1)
		m_eqs = m_colstripe[m_ieqs[.,1],1]'
	}
	else {
		m_ieqs = J(0,2,0)
		m_eqs = J(1,0,"")
	}
	return(rc)
}

real scalar __stparam_vector::set_matrix(real matrix mat, |string scalar name)
{
	real scalar r, rc

	r = ::rows(mat)
	if (r != 1) {
		m_errmsg = sprintf("parameter vector must have 1 row, but " +
			"got %g",r)
		return(503)
	}
	if (!ustrlen(name)) {
		rc = super.set_matrix(mat,name)
	}
	else {
		rc = super.set_matrix(mat)
	}
	return(rc)
}

real scalar __stparam_vector::equation_index(string scalar eqname,
			real vector ind)
{
	real scalar k
	real vector i
	string scalar name

	ind = J(0,2,0)
	i = J(1,1,0)
	k = ::rows(m_eqs)
	if (k) {
		i = strmatch(m_eqs,eqname)
	}
	if (!any(i)) {
		if (ustrlen(m_name)) {
			name = sprintf(" {bf:%s}",m_name)
		}
		else {
			name = ""
		}
		m_errmsg = sprintf("equation {bf:%s} not found in parameter " +
			"vector%s",eqname,name)
		return(507)
	}
	i = selectindex(i)[1]
	ind = m_ieqs[i[1],]

	return(0)
}

real scalar __stparam_vector::set_equation(real vector b, string scalar eqname)
{
	real scalar rc
	real vector i, k, m, r, c, b0

	pragma unset i

	if (!ustrlen(eqname)) {
		return(0)
	}
	c = ::cols(b)
	r = ::rows(b)
	m = 0
	if (c == 1) {
		m = r
		b0 = b'
	}
	else {
		b0 = b
		m = c
	}
	k = ::rows(b0)
	if (!m | k!=1) {
		m_errmsg = sprintf("expected a vector, but got a %g x %g " +
			"matrix ",r,c)
		return(503)
	}
	if (rc=equation_index(eqname,i)) {
		return(rc)
	}
	k = i[2]-i[1]+1
	if (m != k) {
		m_errmsg = sprintf("expected a 1 x %g vector, but got a " +
			"1 x %g vector for equation {bf:%s}",k,m,eqname)
		return(503)
	}
	m_matrix[|1,i[1]\1,i[2]|] = b0

	return(0)		
}

real scalar __stparam_vector::set_coefficients(real rowvector b, 
			|transmorphic spec)
{
	real scalar k

	k = ::cols(b)
	if (args() == 1) {
		if (k != cols()) {
			m_errmsg == sprintf("expected a vector of length " +
				"%g but got %g",cols(),k)
			return(503)
		}
		return(super.set_matrix(b))
	}
	if (isreal(spec)) {
		return(set_coef_by_index(b,spec))
	}
	if (isstring(spec)) {
		return(set_coef_by_stripe(b,spec))
	}
	m_errmsg = "string matrix or real vector expected"
	return(498) 
}

real scalar __stparam_vector::set_coef_by_index(real rowvector b,
			real vector index)
{
	real scalar k, k1
	real rowvector b0

	k = ::cols(b)
	k1 = length(index)
	if (k1 != k) {
		m_errmsg = sprintf("expected an index vector of length %g " +
			"but got %g",k,k1)
		return(503)
	}
	if (!k) {
		return(0)
	}
	if (max(index)>cols()) {
		m_errmsg = sprintf("coefficient index cannot exceed %g",cols())
		return(503)
	}
	if (min(index)<1) {
		m_errmsg = "coefficient index cannot be less than 1"
		return(503)
	} 
	b0 = m()
	b0[index] = b

	return(super.set_matrix(b0))
}

real scalar __stparam_vector::set_coef_by_stripe(real rowvector b, 
			string matrix bstripe)
{
	real scalar i, k, found, cs, rs, slash
	real matrix io
	string scalar msg
	string rowvector stripe

	k = ::cols(b)
	rs = ::rows(bstripe)
	cs = ::cols(bstripe)
	if (rs!=k | cs!=2) {
		m_errmsg = "invalid stripe matrix"
		return(507)	// matrix name conflict error
	}
	for (i=1; i<=k; i++) {
		stripe = bstripe[i,.]
		io = strmatch(m_colstripe,stripe)
		io = io[.,1]:&io[.,2]
		found = any(io)
		if (!found) {
			slash = (usubstr(stripe[1],1,1) != "/")
			if (slash) {
				stripe[1] = "/"+stripe[1]
				io = strmatch(m_colstripe,stripe)
				io = io[.,1]:&io[.,2]
				found = any(io)
			}
		}
		if (!found) {
			if (strlen(bstripe[i,1])) {
				msg = invtokens(bstripe[i,.],":")
			}
			else {
				msg = bstripe[i,2]
			}
			m_errmsg = sprintf("coefficient {bf:%s} not found",msg)
			return(507)
		}
		io = selectindex(io)[1]
		m_matrix[1,io[1]] = b[i]
	}
	return(0)
}

real scalar __stparam_vector::equation_stripe(string scalar eqname,
			string matrix stripe)
{
	real scalar rc
	real vector i

	pragma unset i

	if (rc=equation_index(eqname,i)) {
		stripe = J(0,2,"")
	}
	else {
		stripe = m_colstripe[|i[1],1\i[2],2|]
	}
	return(rc)
}

end

exit


