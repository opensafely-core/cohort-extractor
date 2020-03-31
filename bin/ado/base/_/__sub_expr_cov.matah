*! version 1.0.2  22apr2019

local MENL_SCALE_MULTIPLY	0
local MENL_SCALE_DIVIDE 	1

if "$SUBEXPR_COV_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

class __sub_expr_cov extends __sub_expr
{
    protected:
	pointer (class __recovmatrix) vector m_covs // RE covariances;
					// could have multiple recov's per path
	pointer (class __pathcovmatrix) vector m_pcovs	// RE path covariances;
					// only one pcov per hierarchy path
	real matrix m_ijc		// recov index ranges for each pcov:
					// 	 pcov[i] = recov[|ijc[.,i]|]
	class __ecovmatrix scalar m_var	// residual covariance

    public:
	/* ::cov_stparameters() 					*/
	static real scalar COV_METRIC_USER
	static real scalar COV_METRIC_EST
	static real scalar COV_METRIC_VAR
	static real scalar COV_METRIC_SD
	static real scalar COV_METRIC_RESID

    protected:
	void new()
	void destroy()

    protected:
	/* copy FE/LV/cov param values					*/
	virtual real scalar set_param_from_spec()	// string specification
	virtual real scalar set_param_from_vec()	// Mata vector
	virtual real scalar set_param_by_stripe()	// Mata vector and 
							//  stripe matrix
	virtual real scalar set_param_by_index()	// Mata index vector
	virtual void update_dirty_ready()		// virtual: determine
							//  if DIRTY_READY
	virtual real scalar _resolve_group()
	virtual void error_code()

    public:
	virtual void return_post()		// post model to return
	virtual void cert_post()		// for certification
	virtual string vector varlist()		// variables referenced

	virtual real scalar _parse_expression()
	virtual real scalar _parse_equation()
	virtual real scalar _parse_expr_init()

	virtual real scalar _resolve_expressions()	// resolve all
							// expression components
	virtual void display_equations()
	virtual void display_expressions()

	virtual class __stmatrix scalar stparameters()	// FE/cov/res param
							//  __stmatrix
	virtual real scalar _gen_hierarchy_panel_info() // gen panel info;

	/* virtual for special Bayes handling				*/
	virtual pointer (class __component_base) scalar lookup_component()
							// sort assumed
    public:
	void clear()				// reset

	void resolve_covariances()		// ensure all RE have 
	real scalar _resolve_covariances()	//  covariance structures

	void compute_path_covariances()

	void add_re_covariance()		// define a RE covariance
	real scalar _add_re_covariance()	//  structure
	real scalar _path_covariance()		// covariance for a LV path
	void set_res_covariance()
	real scalar _set_res_covariance()	// define the residual
						//  covariance structure
	pointer (class __recovmatrix) vector re_covariances()	// RE covs
	pointer (class __recovmatrix) vector path_covariances() // path covs 
	pointer (class __ecovmatrix) scalar res_covariance()  // residual cov

	real scalar _set_cov_parameters() 	// copy cov parameter values
	real scalar _set_res_parameters() 	// copy resid parameter values
	real scalar _set_residual_lnsd() 	// factored resid log std.dev
	string matrix cov_stripe()		// cov param vector stripe

	void set_FE_parameters() 		// copy FE parameter values
	real scalar _set_FE_parameters() 	// copy FE parameter values

	real rowvector FE_parameters()		// FE param vector
	real rowvector cov_parameters()		// cov param vector
	real scalar residual_var()              // residual scale variance

	class __stmatrix scalar FE_stparameters()  // FE param __stmatrix
	class __stmatrix scalar cov_stparameters() // cov param __stmatrix
	class __stmatrix scalar res_stparameters() // res param __stmatrix

	void scale_covariances()
	void display_covariances()

	real scalar has_LVs()		// TRUE/FALSE: model has latent vars
}

end

global SUBEXPR_COV_MATAH_INCLUDED 1

exit
