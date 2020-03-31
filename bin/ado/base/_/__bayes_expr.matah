*! version 1.0.1  16nov2018

if "$BAYES_EXPR_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

class __bayes_expr extends __sub_expr
{
    protected:
	class AssociativeArray scalar m_parind

    protected:
	void new()
	void destroy()

    protected:
	virtual real scalar set_param_from_spec()	// string specification
	virtual real scalar set_param_from_vec()	// Mata vector
	virtual real scalar set_param_by_stripe()	// Mata vector and 
							//  stripe matrix
	virtual real scalar set_param_by_index()	// Mata index vector
	virtual void update_dirty_ready()		// virtual: determine
							//  if DIRTY_READY
      	virtual real scalar _resolve_group()
	virtual void error_code()

    protected:					// initialize matrix from:
	real scalar set_matrix_from_spec()	// string specification 
	real scalar set_matrix_from_mat()	// Mata matrix

	real scalar _expr_stripe()		// stripe of parameters in 
	string matrix expand_FV_stripe()	// stripe FV utility

	real scalar update_parindex()		// update m_parind with expr
						//  name coef index vec
	real scalar group_stripe()

    public:
	virtual void return_post()		// post model to return
	virtual void cert_post()		// for certification
	virtual string vector varlist()		// variables referenced

	virtual real scalar _gen_hierarchy_panel_info() // gen panel info;
							// sort assumed

	virtual real scalar _parse_equation()
	virtual real scalar _parse_expression()
	virtual real scalar _parse_expr_init()
	virtual real scalar _resolve_expressions()	// resolve all
	virtual void display_equations()
	virtual void display_expressions()

	virtual class __stmatrix scalar stparameters()	// FE param __stmatrix
							// expression components
	virtual pointer (class __component_base) scalar lookup_component()

    public:
	void clear()

	void reset_parse()		// reset dirty flag post resolve

	string matrix mat_stripe()		// stripe of matrix parameters
						//  in an expression
	string matrix expr_stripe()		// stripe of parameters in 
						//  an expression
	string vector path_index_varlist() 	// hierarchy path index varnames
	real matrix path_index_matrix()		// hierarchy path index matrix
						// st_data(index variables)
	void set_mat_parameter()		// initialize ancillary matrix
	real scalar _set_mat_parameter()
	real matrix mat_parameter()		// ancillary Mata matrix
	class __stmatrix scalar mat_stparameter() // ancillary _stmatrix
}
end

global BAYES_EXPR_MATAH_INCLUDED 1

exit
