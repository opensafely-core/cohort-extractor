*! version 1.0.7  25apr2018

local STMATRIX_COLUMN	1
local STMATRIX_ROW	2

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

void __stmatrix::new()
{
	clear()
	if (missing(m_tol)) {
		m_tol = sqrt(epsilon(1))
	}
	/* static globals						*/
	COLUMN = `STMATRIX_COLUMN'
	ROW = `STMATRIX_ROW'
}

void __stmatrix::destroy()
{
	clear()
}

void __stmatrix::clear()
{
	m_matrix = J(0,0,0)
	m_colstripe = J(0,2,"")
	m_rowstripe = J(0,2,"")
	m_name = ""
}

real matrix __stmatrix::m()
{
	return(m_matrix)
}

string scalar __stmatrix::name()
{
	return(m_name)
}

real scalar __stmatrix::rows()
{
	return(::rows(m_matrix))
}

real scalar __stmatrix::cols()
{
	return(::cols(m_matrix))
}

void __stmatrix::erase()
{
	clear()
}

real scalar __stmatrix::set_matrix(real matrix mat, |string scalar name)
{
	real scalar rc

	rc = 0
	m_matrix = mat
	if (ustrlen(name)) {
		rc = set_name(name)
	}
	if (!rc) {
		rc = validate()
	}
	return(rc)
}

real scalar __stmatrix::set_name(string scalar name)
{
	if (ustrlen(name)) {
		if (!st_isname(name)) {
			m_errmsg = sprintf("invalid matrix name %s",name)
			return(198)
		}
	}
	m_name = name

	return(0)
}

real scalar __stmatrix::set_stripe(string matrix stripe, |real scalar dim)
{
	real scalar r, c, d, ds
	string scalar sdim
	string matrix stripe0

	/* set matrix first to ensure dimension compatibility	*/
	r = rows()
	c = cols()
	if (::cols(stripe) != 2) {
		m_errmsg = "matrix stripe should have 2 columns"
		return(503)
	}
	if (::rows(stripe) == 0) {
		if (dim == COLUMN) {
			m_colstripe = J(0,2,"")
		}
		else if (dim == ROW) {
			m_rowstripe = J(0,2,"")
		}
		else {
			m_rowstripe = m_colstripe = J(0,2,"")
		}
		return(0)
	}
	/* 32 = max length of a stripe					*/
	if (ustrpos(stripe[1,2],"[")) {
		stripe0 = stripe	// latent variables in stripe
	}
	else {
		stripe0 = (stripe[.,1],abbrev(stripe[.,2],32))
	}
	if (r & c) {
		ds = ::rows(stripe0)
		if (dim == COLUMN) {
			sdim = "column"
			d = c
		}
		else if (dim == ROW) {
			sdim = "row"
			d = r
		}
		else {	// row and column stripe
			if (r!=1 & r!=c) {
				m_errmsg = "cannot set the same row and " +
					"column stripe on a matrix that is " +
					"not square"
				return(503)
			}
			d = r
		}
		if (ds != d) {
			m_errmsg = sprintf("invalid %s stripe; expected " +
				"%g labels but got %g",sdim,d,ds)
			return(503)
		}
	}
	if (dim == COLUMN) {
		m_colstripe = stripe0
	}
	else if (dim == ROW) {
		m_rowstripe = stripe0
	}
	else {
		m_colstripe = stripe0
		m_rowstripe = stripe0
	}
	return(0)
}

real scalar __stmatrix::set_colstripe(string matrix stripe)
{
	return(set_stripe(stripe,COLUMN))
}

real scalar __stmatrix::set_rowstripe(string matrix stripe)
{
	return(set_stripe(stripe,ROW))
}

string matrix __stmatrix::stripe(|real scalar dim)
{
	if (dim == ROW) {
		return(m_rowstripe)
	}
	return(m_colstripe)
}

string matrix __stmatrix::rowstripe()
{
	return(m_rowstripe)
}

string matrix __stmatrix::colstripe()
{
	return(m_colstripe)
}

real scalar __stmatrix::isequal(class __stmatrix scalar mat)
{
	if (cols()==0 | rows()==0) {
		return(0)
	}
	if (rows() != mat.rows()) {
		return(0)
	}
	if (cols() != mat.cols()) {
		return(0)
	}
	if (mreldif(m(),mat.m()) > m_tol) {
		return(0)
	}
	return(1)
}

string scalar __stmatrix::errmsg()
{
	return(m_errmsg)
}

void __stmatrix::st_matrix(|string scalar name, real scalar nostripe)
{
	if (!rows() | !cols()) {
		return
	}
	if (!args()) {
		name = m_name
	}
	if (!ustrlen(name)) {
		return
	}
	nostripe = (missing(nostripe)?0:(nostripe!=0))
	::st_matrix(name,m())
	if (!nostripe) {
		if (::rows(m_rowstripe)) {
			st_matrixrowstripe(name,m_rowstripe)
		}
		if (::rows(m_colstripe)) {
			st_matrixcolstripe(name,m_colstripe)
		}
	}
}

void __stmatrix::st_matrix_ns()
{
	if (!rows() | !cols()) {
		return
	}
	::st_matrix(m_name,m())
}

real scalar __stmatrix::st_getmatrix(|string scalar name)
{
	real scalar r, c, rc
	real matrix b
	string matrix stripe

	if (!args()) {
		name = m_name
	}
	if (!ustrlen(name)) {
		return
	}
	b = ::st_matrix(name)	
	r = ::rows(b)
	c = ::cols(b)
	if (!r | !c) {
		m_errmsg = sprintf("matrix {bf:%s} does not exist",name)
		return(111)
	}
	if (rc=set_matrix(b)) {
		return(rc)
	}
	stripe = st_matrixrowstripe(name)
	if (!(rc=set_rowstripe(stripe))) {
		stripe = st_matrixcolstripe(name)
		rc = set_colstripe(stripe)
	}
	return(rc)
}

real scalar __stmatrix::el(real scalar i, real scalar j)
{
	i = floor(i)
	j = floor(j)
	if (i<0 | i>rows()) {
		return(.)
	}
	if (j<0 | j>cols()) {
		return(.)
	}
	return(m_matrix[i,j])
}

real scalar __stmatrix::set_el(real scalar i, real scalar j, real scalar val)
{
	real scalar r, c

	i = floor(i)
	j = floor(j)
	if (i<0 | i>rows() | j<0 | j>cols()) {
		r = rows()
		c = cols()
		m_errmsg = sprintf("invalid matrix index (%g,%g) for a " +
			"%g x %g matrix",i,j,r,c)
		return(503)
	}
	m_matrix[i,j] = val

	return(0)
}

real scalar __stmatrix::set_block(real matrix x, real matrix ij)
{
	real scalar k1, k2, r, c, ri, ci

	r = ::rows(x)
	c = ::cols(x)
	if (any(ij:<=0)) {
		m_errmsg = "invalid index matrix"
		return(503)
	}
	ri = ::rows(ij)
	ci = ::cols(ij)
	if (ri==2 & ci==2) {
		if (ij[1,1]>ij[2,1] | ij[1,2]>ij[2,2]) {
			m_errmsg = "invalid index matrix"
			return(503)
		}

		k1 = ij[2,1]-ij[1,1]+1
		k2 = ij[2,2]-ij[1,2]+1
	
		if (r!=k1 | c !=k2) {
			m_errmsg = sprintf("expected a %g x %g matrix, but " +
				"got %g x %g",k1,k2,r,c)
			return(503)
		}
		if (ij[2,1]>rows()) {
			m_errmsg = sprintf("maximum row index is %g, but got " +
				"index %g",rows(),ij[2,1])
			return(503)
		}
		if (ij[2,2]>cols()) {
			m_errmsg = sprintf("maximum column index is %g, but " +
				"got index %g",cols(),ij[2,2])
			return(503)
		}
		m_matrix[|ij[1,1],ij[1,2]\ij[2,1],ij[2,2]|] = x
	}
	else if ((ri==2 & ci==1) | (ri==1 & ci==2)) {
		k1 = ij[2]-ij[1]+1
		if (r==1 & k1>c) {
			m_errmsg = sprintf("expected a vector of length %g, " +
				"but got %g",k1,c)
			return(503)
		}
		else if (c==1 & k1>r) {
			m_errmsg = sprintf("expected a vector of length %g, " +
				"but got %g",k1,r)
			return(503)
		}
		else if (r>1 & c>1) {
			m_errmsg = sprintf("expected a vector, but " +
				"got a %g x %g matrix",r,c)
			return(503)
		}
		if (rows()>1 & cols()>1) {
			m_errmsg = sprintf("attempting to reference a matrix " +
				"with vector range [|%g\%g|]",ij[1],ij[2])
			return(503)
		}
		if (cols()>1 & ij[2]>cols()) {
			m_errmsg = sprintf("maximum column index is %g, but " +
				"got index %g",cols(),ij[2])
			return(503)
		}
		else if (rows()>1 & ij[2]>rows()) {
			m_errmsg = sprintf("maximum row index is %g, but got " +
				"index %g",rows(),ij[2])
			return(503)
		}
		m_matrix[|ij[1]\ij[2]|] = x
	}		
	else {
		m_errmsg = "invalid index matrix"
		return(503)
	}
	return(0)
}

void __stmatrix::display(|string scalar label)
{
	string scalar name

	name = name()
	if (!ustrlen(name)) {
		name = st_tempname()
	}
	if (!rows() | !cols()) {
		errprintf("cannot display %s; matrix is empty\n",name)
		displayas("txt")
		return
	}
	st_matrix(name)
	if (strlen(label)) {
		(void)_stata(sprintf("matrix list %s, title(%s)",name,label))
	}
	else {
		(void)_stata(sprintf("matrix list %s",name))
	}
	::st_matrix(name,J(0,0,0))
}

real scalar __stmatrix::validate()
{
	real scalar k

	if ((k=::rows(m_colstripe))) {
		if (cols() != k) {
			m_errmsg = sprintf("matrix {bf:%s} conformity error; " +
				"column stripe has %g entries for %g columns",
				m_name,k,cols())
			return(503)
		}
	}
	if ((k=::rows(m_rowstripe))) {
		if (rows() != k) {
			m_errmsg = sprintf("matrix {bf:%s} conformity error; " +
				"row stripe has %g entries for %g rows",
				m_name,k,cols())
			return(503)
		}
	}
	return(0)
}

end 
exit
