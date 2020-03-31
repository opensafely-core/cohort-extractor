*! version 1.0.0  26apr2017

findfile __stmatrix.matah
quietly include `"`r(fn)'"'

findfile __recovmatrix.matah
quietly include `"`r(fn)'"'

mata:
mata set matastrict on

void __pathcovmatrix::new()
{
	clear()
}

void __pathcovmatrix::destroy()
{
	clear()
}

void __pathcovmatrix::clear()
{
	real scalar i, k

	k = length(m_covs)
	for (i=1; i<=k; i++) {
		if (m_covs[i] != NULL) {
			m_covs[i]->clear()
		}
		m_covs[i] = NULL
		m_i[i] = NULL
	}
	m_covs = J(1,0,NULL)
	m_i = J(1,0,NULL)
	m_dim = 0
}

void __pathcovmatrix::erase()
{
	super.erase()

	clear()
}

real scalar __pathcovmatrix::set_rowstripe(string matrix stripe)
{
	return(super.set_rowstripe(stripe))
}

real scalar __pathcovmatrix::set_colstripe(string matrix stripe)
{
	return(super.set_colstripe(stripe))
}

real scalar __pathcovmatrix::set_matrix(real matrix mat, |string scalar name)
{
	return(super.set_matrix(mat,name))
}

real scalar __pathcovmatrix::vtype()
{
	real scalar k

	if (!(k=kcov())) {
		return(`COV_UNDEFINED')
	}
	if (k == 1) {
		return(m_covs[1]->vtype())
	}
	return(`VAR_RE_BLOCK_DIAG')
}

string scalar __pathcovmatrix::svtype()
{
	real scalar k

	if (!(k=kcov())) {
		return(`COV_UNDEFINED_STR')
	}
	if (k == 1) {
		return(m_covs[1]->svtype())
	}
	return(`VAR_RE_BLOCK_DIAG_STR')
}

real scalar __pathcovmatrix::ctype()
{
	real scalar k

	if (!(k=kcov())) {
		return(`COV_UNDEFINED')
	}
	if (k == 1) {
		return(m_covs[1]->ctype())
	}
	return(`VAR_RE_BLOCK_DIAG')
}

string scalar __pathcovmatrix::sctype()
{
	real scalar k

	if (!(k=kcov())) {
		return("undefined")
	}
	if (k == 1) {
		return(m_covs[1]->sctype())
	}
	return(`VAR_RE_BLOCK_DIAG_STR')
}

real scalar __pathcovmatrix::kcov()
{
	return(length(m_covs))
}

pointer (real matrix) scalar __pathcovmatrix::cov(real scalar i)
{
	if (i<1 | i>kcov()) {
		return(NULL)
	}
	return(m_covs[i])
}

pointer (real matrix) vector __pathcovmatrix::covs()
{
	return(m_covs)
}

real scalar __pathcovmatrix::ksdpar()
{
	real scalar i, k, kpar

	kpar = 0
	k = kcov()
	for (i=1; i<=k; i++) {
		kpar = kpar + m_covs[i]->ksdpar()
	}
	return(kpar)
}

real scalar __pathcovmatrix::kcorpar()
{
	real scalar i, k, kpar

	kpar = 0
	k = kcov()
	for (i=1; i<=k; i++) {
		kpar = kpar + m_covs[i]->kcorpar()
	}
	return(kpar)
}

real matrix __pathcovmatrix::V()
{
	return(m())
}

real matrix __pathcovmatrix::R()
{
	real scalar i, k
	real matrix R

	/* assumption compute_V() must be executed first		*/
	R = J(m_dim,m_dim,0)
	k = kcov()
	for (i=1; i<=k; i++) {
		R[|*m_i[i]|] = m_covs[i]->R()
	}
	return(R)
}

real colvector __pathcovmatrix::sd()
{
	real scalar i, k
	real colvector sd

	/* assumption compute_V() must be executed first		*/
	sd = J(m_dim,1,0)
	k = kcov()
	for (i=1; i<=k; i++) {
		sd[|(*m_i[i])[.,1]|] = m_covs[i]->sd()
	}
	return(sd)
}

string scalar __pathcovmatrix::path()
{
	if (!kcov()) {
		return("")
	}
	return(m_covs[1]->path())
}

string vector __pathcovmatrix::LVnames()
{
	real scalar i, k
	string vector lvs

	k = kcov()
	lvs = J(1,0,"")
	for (i=1; i<=k; i++) {
		lvs = (lvs,m_covs[i]->LVnames())
	}
	return(lvs)
}

void __pathcovmatrix::update_v()
{
	real scalar i, k

	k = kcov()
	for (i=1; i<=k; i++) {
		m_covs[i]->update_v()
	}
}

void __pathcovmatrix::set_re_covariances(
		pointer (class __recovmatrix) vector covs)
{
	real scalar i, k, j1, j2
	string matrix stripe

	m_covs = covs

	k = kcov()
	m_i = J(1,k,NULL)
	m_dim = 0
	if (!k) {
		erase()
		return
	}
	j2 = 0
	stripe = J(0,2,"")
	for (i=1; i<=k; i++) {
		j1 = j2 + 1
		if (k > 1) {
			m_covs[i]->set_stripe_index(i)
		}
		j2 = j2 + m_covs[i]->cols()
		m_i[i] = &J(1,1,(j1,j1\j2,j2))
		stripe = (stripe\m_covs[i]->colstripe())
	}
	m_dim = j2
	(void)set_stripe(stripe)
	compute_V()
}

void __pathcovmatrix::compute_V()
{
	real scalar i, k
	real matrix V

	k = kcov()
	V = J(m_dim,m_dim,0)
	for (i=1; i<=k; i++) {
		m_covs[i]->compute_V()
		V[|*m_i[i]|] = m_covs[i]->V()
	}
	(void)set_matrix(V)
}

real matrix __pathcovmatrix::factor_matrix(|real scalar rank)
{
	real scalar i, k, j1, j2, r
	real matrix R

	/* assumption: compute_V() has been called			*/
	R = J(rows(),cols(),0)
	k = kcov()
	j2 = r = 0
	for (i=1; i<=k; i++) {
		j1 = j2 + 1
		j2 = j2 + m_covs[i]->rows()
		R[|j1,j1\j2,j2|] = m_covs[i]->factor_matrix(r)
		rank = rank + r
	}
	return(R)
} 

real matrix __pathcovmatrix::sqrt_matrix(|real scalar rank)
{
	real scalar i, k, j1, j2, r
	real matrix S

	pragma unset r

	/* assumption: compute_V() has been called			*/
	k = kcov()
	if (k == 1) {
		S = m_covs[1]->sqrt_matrix(rank)
	}
	else {
		S = J(rows(),cols(),0)
		j2 = rank = 0
		for (i=1; i<=k; i++) {
			j1 = j2 + 1
			j2 = j2 + m_covs[i]->rows()
			S[|j1,j1\j2,j2|] = m_covs[i]->sqrt_matrix(r)
			rank = rank + r
		}
	}
	return(S)
} 

real matrix __pathcovmatrix::precision_factor(|real scalar ldet)
{
	real colvector s
	real matrix U, V, psi

	pragma unset s
	pragma unset V

	/* assumption: compute_V() has been called			*/
	U = m()
	_svd(U,s,V)
	s = 1:/sqrt(s)
	if (args()) {
		ldet = sum(log(s))
	}
	psi = U*diag(s)*V
	psi = (psi+psi'):/2

	return(psi)
} 

void __pathcovmatrix::return_post()
{
	real scalar i, k
	string scalar id, what

	if (!(k=kcov())) {
		return
	}
	if (k == 1) {
		m_covs[1]->return_post()
		return
	}
	id = invtokens(LVnames(),"_")
	what = subinstr(`VAR_RE_BLOCK_DIAG_STR'," ","_")
	st_global(sprintf("r(%s_cov_%s)",what,id),path())
	for (i=1; i<=k; i++) {
		id = invtokens(m_covs[i]->LVnames(),"_")
		m_covs[i]->return_post(id)
	}
}

end
exit
