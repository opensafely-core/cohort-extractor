*! version 1.1.3  16nov2018

if "$MENLEXPR_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

struct _menl_expr_imap
{
	string scalar par_name		// param name substituted for pE
	pointer (class __sub_expr_elem) scalar pE  // expression object or
						   //  latent variable
	real scalar ib			// index into parameter matrix B
	real colvector ij		// ij[1] = cov ij[2] = s2 index
}

struct _menl_expr_init
{
	string scalar depvar
	string scalar eq	// condensed user's equation
	string scalar expr	// param substituted expression
	struct _menl_expr_imap vector imap // map for param's substituted
					   //  for named expr
	class __stmatrix vector sigma2  // estimated RE variances, m_cov order
	real colvector y	// predicted y using param model
	string matrix stripe	// stripe for columns of B
	real matrix B		// nls param model estimates for each panel
	real matrix Vb		// vech VCE's for B's
	real rowvector b	// weighted mean of rows of B
	real scalar s2		// residual variance
	real scalar klv		// # latent variables in imap
	real scalar kexpr	// # named expressions in imap
	real scalar kparam	// # free parameters in imap
}

class __menl_expr extends __sub_expr_cov
{
    protected:
	pointer (real matrix) vector m_seRE
	void expr_covariates()

    protected:
	void new()
	void destroy()

    protected:					// initialize parameters from:
	virtual real scalar set_param_from_spec()	// string specification
	virtual real scalar set_param_from_vec()	// Mata vector
	virtual real scalar set_param_by_stripe()	// Mata vector and 
							//  stripe matrix
	virtual real scalar set_param_by_index()	// Mata index vector
	virtual void update_dirty_ready()		// virtual: determine
							//  if DIRTY_READY
	virtual real scalar _resolve_group()
	virtual void error_code()

    protected:
	real scalar copy_group_obj()		// creating NULL object:
						//  copy object
    public:
	virtual real scalar _parse_expression()
	virtual real scalar _parse_equation()
	virtual real scalar _parse_expr_init()

	virtual real scalar _resolve_expressions()	// resolve all
							// expression components
	virtual void return_post()
	virtual void cert_post()		// for certification

	virtual string vector varlist()		// variables referenced

	virtual real scalar _gen_hierarchy_panel_info() // gen panel info;
							// sort assumed
	virtual void display_equations()
	virtual void display_expressions()

	virtual class __stmatrix scalar stparameters()	// FE param __stmatrix

	/* virtual for special Bayes handling, but must be implemented
	 *  in all extensions						*/
	virtual pointer (class __component_base) scalar lookup_component()

    public:
	void clear()			// reset

	real scalar parse_equation()		// depvar varlist, noconstant
	real scalar parse_expr_init()		// time-series init expression
	real scalar equation_type()		// type of equation
						//  NL expr or LC
	real scalar is_linear_equation()	// query if equation is linear

	real scalar _set_RE_stderr()
	pointer (real matrix) vector RE_stderr()
	real scalar _set_RE_parameters()
	real vector RE_parameters()

	string vector covariates()

	real scalar null_model()	// generate a __menl_expr null model
	real scalar traverse_tree()	// construct a group object from
					//  a parse tree
	void expression_sreturn()	// post expression info for dlg
	void LV_sreturn()		// post LV cov info for dialog

	real vector TS_order_expr()
}
end

global MENLEXPR_MATAH_INCLUDED 1

exit
