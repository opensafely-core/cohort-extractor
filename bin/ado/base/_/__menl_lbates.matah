*! version 1.1.1  20sep2018

local MENL_HIER_LV_NAMES	1	// sync with __lvhierarchy.matah
local MENL_HIER_PATH		2

local MENL_VAR_RESID_FITTED `""_yhat""'	// sync with __ecovmatrix.matah
local MENL_COV_STDDEV		1
local MENL_COV_CORR		2

local MENL_LBATES		0
local MENL_INITIAL_NLS		1
local MENL_INITIAL_EM		2
local MENL_LBATES_PNLS		3
local MENL_LBATES_LME		4
local MENL_LBATES_LME_PROFILE	5
local MENL_GNLS_FE		6
local MENL_NLM_PROFILE		7
local MENL_NLM			8

local MENL_CONVERGED_BOTH	0
local MENL_CONVERGED_ALT	1
local MENL_CONVERGED_MOPT	2

local MENL_REL_ZERO = 1E-4
local MENL_RC_MISSING		480

local MENL_ALT_ITERATE		5

local MENL_COMP_LF		0
local MENL_COMP_BFE		1
local MENL_COMP_BRE		2
local MENL_COMP_REML		10

local MENL_LINEARIZATION_OFF	0
local MENL_LINEARIZATION_ON	1

local MENL_FALSE		0
local MENL_TRUE			1

local MENL_RESID_SCALE		`MENL_TRUE'
local MENL_RESID_SCALE_FITTED	2

local MENL_GNLS_UNBIASED_V     `MENL_FALSE'

local MENL_COR_LIMIT		0.99999
local MENL_SD_MIN_LIMIT		1e-5

local MENL_TRACE_NONE		1
local MENL_TRACE_VALUE		2
local MENL_TRACE_TOLERANCE	3
local MENL_TRACE_STEP		4
local MENL_TRACE_PARAMS		5
local MENL_TRACE_GRADIENT 	6
local MENL_TRACE_HESSIAN	7

local MOPTS_DEFAULT_STANDARD	0
local MOPTS_DEFAULT_PNLS	1
local MOPTS_DEFAULT_LME		2
local MOPTS_DEFAULT_EM		3

if "$MENL_LBATES_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

struct _menl_hier_decomp {
	pointer (real matrix) matrix R
	pointer (real rowvector) vector p
	pointer (real colvector) vector c
	pointer (real matrix) vector X
}

struct _menl_Rii
{
	pointer (real matrix) vector R
}

struct _menl_mopts
{
	real scalar maxiter	// # iterations
	real scalar debug	// debug log on/off
	real scalar log		// iteration log on/off
	string scalar vce	// VCE type: oim
	string scalar ltype	// likelihood type: reml, mle
	real scalar ltol	// likelihood tolerance
	real scalar tol		// coefficient tolerance
	real scalar nrtol	// scaled gradient tolerance
	real scalar nonrtol	// NR tolerance on/off
	real scalar nostderr	// do not compute var comp stderr
	real scalar itracelevel	// optimize trace level
	string vector tracelevel
	string scalar metric	// coef table metric request
	string scalar special	// technique specific option
}

struct _menl_constraints
{
	class __stmatrix scalar C
	class __stmatrix scalar T
	class __stmatrix scalar a
}

/* declaration: __menl_lbates_base					*/
class __menl_lbates_base
{
    protected:
	transmorphic m_M		// moptimize object

	real scalar m_cons		// N*log(2*pi)/2

	real scalar m_keq	// # equations
	real scalar m_kFEeq	// # FE equations
	real scalar m_kFEb	// # FE parameters
	real matrix m_iFEeq	// FE equation first/last index matrix

	real matrix m_isigma	// indices to sigma parameters, m_kcov x 2
	real matrix m_irho	// indices to rho parameters, m_kcov x 2
	real scalar m_ksigrho	// # stdev/cor parameters

	pointer (class __lvhierarchy) m_hierarchy 	// hierarchy
	real matrix m_pinfo		// residual panel info

	real scalar m_hasscale	// flag to include scale (residual) parameter
	real scalar m_s2		// residual variance/scaling param
	real scalar m_resid_scale	// resid covariance scaling
	real scalar m_res_ldet		// sum log det residual cov
	pointer (real matrix) vector m_res_psi

	string scalar m_depvar
	real colvector m_y		// dependent variable
	string scalar m_touse		// special estimation sample
	real colvector m_select		// boolean est sample selection
	real colvector m_isel2zero	// index est sample selection == 0
	real scalar m_n			// # observations
	real scalar m_fun_value		// last evaluator function value
	real scalar m_reml		// reml flag (lme, nlm, gnls)
	real scalar m_todo
	real scalar m_missing
	real vector m_converged
	real matrix m_X			// dFdBeta
	real scalar m_eq_LC		// equation is LC flag

	real rowvector m_b	// moptimize coefficient vector
	string matrix m_stripe	// moptimize coefficient stripe
	real matrix m_V		// moptimize VCE

	struct _menl_constraints scalar m_cns		// constraint matrices
	struct _menl_mopts scalar m_mopts
	pointer (class __menl_expr) scalar m_expr	// expression object

	string scalar m_errmsg

	static real scalar m_eps

    protected: 
	void new()
	void destroy()

	void init_FE()
	void init_var() 
	real scalar dFdBeta()

	void resid_scale()			// scale data by resid cov
	real scalar update_resid_scale()	// compute resid scale matrices
	real scalar update_resid_ldet()		// compute resid log det

	real scalar set_subexpr_fe_coef()
	real scalar set_subexpr_var_coef()

	virtual real scalar init_constraints()

    public:
	virtual real scalar initialize()
	virtual real scalar reinitialize() // alternating algorithm initialize
	virtual void clear()
	virtual real scalar set_subexpr_coef()
	virtual real scalar run()
	virtual real colvector evaluate()
	virtual real scalar algorithm()
	virtual real matrix VCE()

	void set_subexpr()
	pointer (class __menl_expr) scalar subexpr()

	real scalar eval_F()
	real scalar n()
	string scalar touse()
	real colvector selection()
	real scalar fun_value()
	real rowvector parameters()
	string matrix stripe()
	real matrix iFEeq()		// FE equation indices
	real scalar kFEb()		// # FE parameters
	real matrix isigma()		// variance equation indices
	real matrix irho()		// correlation equation indices
	real scalar rscale()		// residual scale flag
	real scalar constraint_T_a()
	string scalar depvar()
	real scalar missing_count()

	void set_todo()
	string scalar errmsg()
	real scalar converged()		// converged flag
}

/* declaration: __menl_lbates						*/
class __menl_lbates extends __menl_lbates_base
{
    protected:
	pointer (real matrix) vector m_delta	// precision factors
	real vector m_ldetdel			// det(delta[i])

	real rowvector m_bFE		// fixed effect parameters
	pointer (real matrix) vector m_bRE	// random effect parameters
					// computed from profile likelihood
	pointer (real matrix) vector m_Z	// dFdb
	real colvector m_w		// Taylor series linearization of F

    protected: 
	void new()
	void destroy()
	real scalar dFdb()
	real scalar linearize()		// Taylor series linearization

	virtual real scalar init_constraints()
	virtual void init_parameters()

    public:
	virtual real scalar initialize()
	virtual real scalar reinitialize() // alternating algorithm initialize
	virtual void clear()
	virtual real scalar set_subexpr_coef()
	virtual real colvector evaluate()
	virtual real scalar algorithm()
	virtual real scalar run()
	virtual real matrix VCE()

	real scalar update_covariances()	// compute RE precision factors
	pointer (real matrix) vector psi()	// precision factors
	real vector ldetpsi()			// log determinant psi

	real rowvector FE_parameters()
	pointer (real matrix) vector RE_parameters()

	real scalar reml()		// REML flag
	real scalar converged()		// converged flag
	void set_altconverged()		// set alternating algorithm converged
}

/* declaration: __menl_pnls						*/
class __menl_pnls extends __menl_lbates
{
    protected:
	real scalar m_condFE	// condition on the FE
	real matrix m_R		// FE R matrix
	real rowvector m_p	// FE R matrix pivot vector
	pointer (real matrix) vector m_seRE	// RE standard errors

    protected:
	void new()
	void destroy()

	real scalar eval_GN()
	real scalar linearize_scale()
	void display_trace()
	real scalar compute_scaled_grad()
	void compute_RE_stderrs()
	real colvector penalize_vector()

	virtual real scalar init_constraints()
	virtual void init_parameters()

    public:
	virtual real scalar initialize()
	virtual real scalar reinitialize() // alternating algorithm initialize
	virtual void clear()
	virtual real scalar set_subexpr_coef()
	virtual real colvector evaluate()
	virtual real scalar algorithm()
	virtual real scalar run()
	virtual real matrix VCE()
}

/* declaration: __menl_lme						*/
class __menl_lme extends __menl_lbates
{
    protected:
	real scalar m_profile
	real matrix m_iREvar
	real matrix m_iREcor
	real scalar m_kREvc
	real scalar m_vsehier

    protected:
	void new()
	void destroy()

	void init_var() 
	void _init_var() 

	real scalar eval_lme()

	virtual real scalar init_constraints()
	virtual void init_parameters()

    public:
	virtual real scalar initialize()
	virtual real scalar reinitialize() // alternating algorithm initialize
	virtual void clear()
	virtual real scalar set_subexpr_coef()
	virtual real colvector evaluate() // returns scalar
	virtual real scalar algorithm()
	virtual real scalar run()
	virtual real matrix VCE()

	real scalar profile_like()
}

/* declaration: __menl_gnls						*/
class __menl_gnls extends __menl_lbates_base
{
    protected:
	real scalar m_iter
	real scalar m_algorithm
	real scalar m_rank

    protected:
	void new()
	void destroy()

	void init_var() 

	virtual real scalar init_constraints()

    public:
	virtual real scalar initialize()
	virtual real scalar reinitialize() // resid var uses fitted values
	virtual void clear()
	virtual real scalar set_subexpr_coef()
	virtual real colvector evaluate()
	virtual real scalar run()
	virtual real scalar algorithm()
	virtual real matrix VCE()

	real scalar iterations()
	real scalar rank()
}

/* declaration: __menl_nlm						*/
class __menl_nlm extends __menl_lbates_base
{
    protected:
	real scalar m_profile

    protected:
	void new()
	void destroy()

	void init_var() 

	virtual real scalar init_constraints()

    public:
	virtual real scalar initialize()
	virtual real scalar reinitialize()
	virtual void clear()
	virtual real scalar set_subexpr_coef()
	virtual real colvector evaluate()
	virtual real scalar run()
	virtual real scalar algorithm()
	virtual real matrix VCE()
}
end

global MENL_LBATES_MATAH_INCLUDED 1
exit

