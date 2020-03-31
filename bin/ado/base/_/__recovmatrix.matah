*! version 1.0.1  26apr2018

local COV_UNDEFINED		0
local COV_UNDEFINED_STR		`""undefined""'

local VAR_RE_HOMOSKEDASTIC	1
local VAR_RE_HETEROSKEDASTIC 	2
local VAR_RE_FIXED 		4
local VAR_RE_PATTERN 		5

local VAR_RE_TYPES `"`COV_UNDEFINED_STR',"homoskedastic","heteroskedastic""'
local VAR_RE_TYPES `"`VAR_RE_TYPES',"","fixed","pattern""'

local COR_RE_INDEPENDENT 	1
local COR_RE_EXCHANGEABLE 	2
local COR_RE_UNSTRUCTURED 	3
local COR_RE_FIXED 		4
local COR_RE_PATTERN 		5

local COR_RE_TYPES `"`COV_UNDEFINED_STR',"independent","exchangeable""'
local COR_RE_TYPES `"`COR_RE_TYPES',"unstructured","fixed","pattern""'

local VAR_RE_BLOCK_DIAG		6
local VAR_RE_BLOCK_DIAG_STR	`""block diagonal""'

if "$RECOVMATRIX_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

/* random effects standard deviation vector				*/
class __resdvector extends __stmatrix
{
    protected:
	class __stmatrix scalar m_lnsigma	// log trans std.dev. param
	real scalar m_kpar			// # variance parameters
	real scalar m_type	// std.dev structure type
	string vector m_sdtypes

	real colvector m_v	// sd/fixed param
				// m_v = (exp(m_lnsigma)\m_fix)
	real colvector m_iv	// std.dev permutation vector
				// sd = m_v[m_iv], std.devs

	real colvector m_fp	// fixed/pattern sd param
	real scalar m_kfp	// # fixed/pattern param

	class __stmatrix scalar m_fixpat	// fixed/pattern stddev vec
	string scalar m_path		// LV path
	string vector m_LVnames		// LV names
	string scalar m_errmsg

    protected:
	void new()
	void destroy()
	void clear()

    protected:
	real scalar construct_fixed()
	real scalar construct_pattern()

    public:
	virtual void erase()
	virtual real scalar set_rowstripe()
	virtual real scalar set_colstripe()
	virtual real scalar set_matrix()

    public:
	real scalar construct()	// construct data structure

	void compute_sd()
	real colvector sd()	// standard deviations
	real colvector iv()
	void update_v()
	real scalar kpar()
	real scalar type()
	string scalar stype()
	string scalar errmsg()

	class __stmatrix scalar lnsigma()
	real scalar set_lnsigma()
	real scalar set_parameters()	// set parameter vector
	real scalar sd2parameters()	// convert std.dev. vector to param

	void return_post()
	string scalar identifier()
	void set_stripe_index()		// set stddev index (block diag)
}

/* random effects correlation matrix 					*/
class __recormatrix extends __stmatrix
{
    protected:
	class __stmatrix scalar m_athrho	// atanh trans rho parameters
	real scalar m_kpar		 	// # cor parameters

	real scalar m_type	// cor structure type
	string vector m_cortypes

	real colvector m_v	// cor/fixed param
				// m_v = (tanh(m_athro)\m_fix)
	real colvector m_iv	// cor vech permutation
				// R = invvec(m_v)[m_iv]), off-diag cor's

	real colvector m_fp	// fixed/pattern cor param
	real scalar m_kfp	// # fixed/pattern param
	string scalar m_errmsg

    protected:
	class __stmatrix scalar m_fixpat	// fixed/pattern cor matrix
	string scalar m_path		// LV path
	string vector m_LVnames		// LV names

    protected:
	void new()
	void destroy()
	void clear()

    protected:
	real scalar construct_fixed()
	real scalar construct_pattern()

    public:
	virtual void erase()
	virtual real scalar set_rowstripe()
	virtual real scalar set_colstripe()
	virtual real scalar set_matrix()

    public:
	real scalar construct()	// construct data structure

	void compute_R()
	real matrix R()		// correlations
	void update_v()
	real colvector iv()
	real scalar kpar()
	real scalar type()
	string scalar stype()
	string scalar errmsg()

	class __stmatrix scalar athrho()
	real scalar set_athrho()
	real scalar set_parameters()	// set parameter vector
	real scalar R2parameters()	// convert correlation matrix to param

	void return_post()
	string scalar identifier()
	void set_stripe_index()		// set correlation index (block diag)
}

/* random effects covariance matrix					*/
class __recovmatrix extends __stmatrix
{
    protected:
	class __resdvector scalar m_sd
	class __recormatrix scalar m_cor

	string scalar m_path		// LV path
	string vector m_names		// latent variable names

	class __stmatrix scalar m_fixpat	// fixed/pattern var/cov matrix

    public:
	/* stddev types							*/
	static real scalar HOMOSKEDASTIC
	static real scalar HETEROSKEDASTIC
	static real scalar FIXED
	static real scalar PATTERN

	/* correlation types						*/
	static real scalar INDEPENDENT
	static real scalar EXCHANGEABLE
	static real scalar UNSTRUCTURED

    protected: 
	void new()
	void destroy()
	void clear()

	real matrix cov_index_table()
	void update_v()

    public:
	virtual void erase()
	virtual real scalar set_rowstripe()
	virtual real scalar set_colstripe()
	virtual real scalar set_matrix()

    public:
	real scalar construct()	// construct data structure

	real matrix V()		// variance-covariance
	real scalar ksdpar()
	real scalar kcorpar()
	real scalar vtype()
	string scalar svtype()	// variance structure type
	real scalar ctype()
	string scalar sctype()	// correlation structure type

	void compute_V()	// construct covariance
	real matrix R()		// correlations
	real colvector sd()	// standard deviations
	real matrix factor_matrix()	// _factorsym(V), Cholesky
	real matrix sqrt_matrix()	// V^(1/2), SVD
	real matrix precision_factor()	// V^(-1/2)

	class __stmatrix scalar lnsigma()
	class __stmatrix scalar athrho()
	class __stmatrix scalar fixpat()

	real scalar set_lnsigma()
	real scalar set_athrho()
	real scalar set_parameters()	// set parameter vector
	real scalar cov2parameters()	// initialize cov parameters using
					//  contents of a covariance matrix
	string scalar path()
	string vector LVnames()

	class __stmatrix scalar params_est_metric()
	class __stmatrix scalar params_var_metric()
	class __stmatrix scalar params_sd_metric()

	string scalar identifier()	// covariance identifier
	void set_stripe_index()		// set covariance index (block diag)
	void return_post()
}

class __pathcovmatrix extends __stmatrix
{
    protected:
	pointer (class __recovmatrix) vector m_covs
	pointer (real matrix) vector m_i
	real scalar m_dim

    protected: 
	void new()
	void destroy()
	void clear()

	void update_v()

    public:
	virtual void erase()
	virtual real scalar set_rowstripe()
	virtual real scalar set_colstripe()
	virtual real scalar set_matrix()

    public:
	real matrix V()
	real matrix R()
	real colvector sd()
	real matrix factor_matrix()	// _factorsym(V), Cholesky
	real matrix sqrt_matrix()	// V^(1/2), SVD
	real matrix precision_factor()	// V^(-1/2)
	void compute_V()
	void set_re_covariances()

	pointer (real matrix) scalar cov()
	pointer (real matrix) vector covs()

	real scalar kcov()
	real scalar ksdpar()
	real scalar kcorpar()
	real scalar vtype()
	string scalar svtype()	// variance structure type
	real scalar ctype()
	string scalar sctype()	// correlation structure type

	string scalar path()
	string vector LVnames()

	void return_post()
}

end

global RECOVMATRIX_MATAH_INCLUDED 1
exit
