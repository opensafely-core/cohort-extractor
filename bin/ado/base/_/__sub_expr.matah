*! version 1.1.8  22apr2019

local SUBEXPR_LHS_OWN		1
local SUBEXPR_LHS_SHARED	2

if "$SUBEXPR_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

struct __RE_vectors
{
	pointer (real vector) vector b	// RE coefficients *b[i], i=1,..,k
	string vector names		// LV names associated with b[i]'s
	class __stmatrix scalar lohi	// lo hi from __word_of_mokeyaddr()
}

struct __FV_params
{
	pointer (class __component_param) vector pars
}

class __sub_expr
{
    private:
	transmorphic m_C		// asarray of components
	transmorphic m_loc		// iterator location

    protected:
	string vector m_equations	// array of eq names
	real scalar m_multi_eq		// flag for multiple equations
	string scalar m_base_eq		// multi equation base equation
	string scalar m_touse		// name of sample indicator
	string vector m_tlhs		// _evaluate() LHS tempname
	real scalar m_ilhs		// LHS name index m_tlhs[m_ilhs]
	real scalar m_application	// program application of __sub_expr
	real scalar m_trace
	real scalar m_parse_origin	// parsing equation/expression
	real scalar m_param_default_val
	real scalar m_markout_depvar
	real scalar m_n			// sample size

	class __stparam_vector scalar m_param	// FE coef/LV scale vector
	
	struct __RE_vectors scalar m_RE	// random effect coefficients

	class __lvpath scalar m_lvtree  // store static data
	class __lvhierarchy scalar m_hierarchy
	pointer (class __component_lv) vector m_LVs	// all latent vars

	real scalar m_dirty		// dirty flag

	class AssociativeArray scalar m_exprdep		// expr dependency lists
							// downward
	pointer (class __sub_expr_group) scalar m_nodep	// no dependency pointer
	string scalar m_tsvar		// stata time-series variable
	string scalar m_panelvar	// stata panel variable
						
	class __tempnames scalar m_tnames

	string scalar m_errmsg		// error message to display
	string scalar m_message		// paragraph error message
	string colvector m_warnings	// warnings

    public:	// global flags
	/* ::set_special()						*/
	static real scalar SPECIAL_HIERARCHY_SYMBOLS
	static real scalar SPECIAL_APP_QUADRATURE
	static real scalar SPECIAL_APP_REGRESS
	static real scalar SPECIAL_APP_BAYES
	static real scalar SPECIAL_APP_MENL
	/* ::equation()	& ::expression()				*/
	static real scalar EXPRESSION_FULL
	static real scalar EXPRESSION_CONDENSED
	static real scalar EXPRESSION_SUBSTITUTED
	/* equation types						*/
	static real scalar NULL_EXPRESSION
	static real scalar NONLINEAR_EXPRESSION
	static real scalar LINEAR_COMBINATION

	static string scalar LATENT_VARIABLE

	static string vector PT_TYPES

    protected:
	void new()
	void destroy()

    private:
	real scalar parse_depvars()

	real scalar resolve_param_group()
	real scalar resolve_param_expr_group()
	real scalar resolve_param_component()
	real scalar resolve_equation_LVs()

	real scalar make_param_stripe()
	real scalar make_param_vec()

	real scalar resolve_replace_LC_param()

	void construct_expr_depend()

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
	real scalar resolve_group()
	real scalar resolve_LC_group()
	real scalar mark_collinear_omit()
	real scalar add_component()
	void check_ref()
	pointer (class __component_group) scalar lookup_expression()
	real scalar create_touse()		// create sample ind tempvar
	real scalar traverse_expr_init()	// traverse TS expression
						//  initialization
	real scalar _evaluate()			// evaluate expression/equation
	pointer (class __sub_expr_group) scalar get_defined_expr()
	real scalar _get_group()

	real scalar _msparse()
	real scalar _parse()
	real scalar parse()
	real scalar parse_braces()
	real scalar parse_param()
	string vector expr_varlist()		// traverse expr and tally all
						//  used variables
	void construct_depend()			// construct downward expr
						//  dependency lists
	real scalar _TS_recursive()
	real vector _TS_order()

	void dirty_message()
	void error_and_exit()			// display error message and
						// call exit(rc)
    public:
	/* functions for extending __sub_expr				*/
	virtual void return_post()		// post model to return
	virtual void cert_post()		// for certification
	virtual string vector varlist()		// variables referenced

	virtual real scalar _gen_hierarchy_panel_info() // gen panel info;
							// sort assumed
	virtual real scalar _parse_expression()
	virtual real scalar _parse_equation()
	virtual real scalar _parse_expr_init()

	virtual real scalar _resolve_expressions()	// resolve all
							// expression components
	virtual void display_equations()
	virtual void display_expressions()

	virtual class __stmatrix scalar stparameters()	// FE param __stmatrix

	/* virtual for special Bayes handling				*/
	virtual pointer (class __component_base) scalar lookup_component()

	real scalar application()		// __sub_expr application flag
	real scalar parse_origin()

    public:
	/* user callable functions					*/
	void clear()				// reset

	void set_trace_on()
	void set_trace_off()
	real scalar trace()
	real scalar sample_size()

	void mark_dirty()			// mark named expr dirty

	void parse_expression()
	void parse_equation()
	void parse_expr_init()

	pointer (class __sub_expr_group) scalar new_group()
	pointer (class __sub_expr_group) scalar get_group()

	void set_param_default_value()
	real scalar param_default_value()
	string scalar pt_node_type()		// parse tree node type
	
	void set_base_eq()			// set base equation (scaling)
	string scalar base_eq()			// base equation (scaling)
	void set_multi_eq_on()			// set multiple eq flag TRUE
	real scalar has_multi_eq()		// multiple equation flag
	real scalar TS_recursive()		// expr has lag on named expr
	real vector TS_order()			// expr TS lag & forward order

	void set_stata_tsvar()
	string scalar stata_tsvar()
	void set_stata_panelvar()
	string scalar stata_panelvar()

	real scalar create_param_from_LC()	// create parameter in a group
						//  from define(group:param)

	void resolve_expressions()		// resolve all expression
						//  components
	real scalar resolve_lvhierarchy()
	string matrix hierarchy_paths()

	void resolve_LV_base_equation()		// determine eqs with LV scale
	real scalar _resolve_LV_base_equation()	//  parameter = 1

	real scalar reinit_hierarchy()
	void set_touse()			// set sample indicator name
	real scalar _set_touse()
	string scalar touse()			// sample indicator name
	real scalar markout_depvar()		// markout depvar flag
	void set_markout_depvar()		// set markout depvar flag
	real scalar _markout()			// generate estimation samples
	real scalar TS_init_markout()		// est sample for TS init expr's

	void set_parameters()			// call _set_parameters()
	real scalar _set_parameters()		// call set_param_from_vec() or
						// set_param_from_spec() or
						// set_param_by_stripe()
	void set_LV_parameters() 		// copy LV parameter values
	real scalar _set_LV_parameters() 	// copy LV parameter values

	string matrix param_stripe()		// param vector stripe

	real rowvector parameters()		// param vector
	real rowvector LV_parameters()		// RE param vector for LV

	real rowvector fixed_parameters()	// fixed parameter indicator
	class __stmatrix stfixed_parameters()	//  vector

	real scalar hier_count()		// # hierarchies
	pointer (class __lvhierarchy) scalar hierarchy() // full hierarchy
	pointer (struct _lvhinfo) scalar hier_info()	 // hier ih information
	real scalar gen_LV_indices()
	string vector hier_paths()		// hierarchy ih paths
	string vector hier_LVs()		// hierarchy ih LVs
	real colvector path_index_vector()	// hierarchy path index vector
						// egen group(index variables)
	real colvector LV_index_vector()	// LV index vector
						// computed from path
	string scalar LV_path()			// hierarchy path for LV
	string scalar LV_covariate()		// LV covariate (random slope)
	real scalar _set_LVnames()		// set names of known latent
						// variables
	real scalar path_hierarchy_index() 	// hierarchy index for path
	real colvector path_sort_order()	// sort order hierarchy
						//  containing path
	real scalar _hierarchy_sort_order()	// sort order for hierarchy
	real matrix gen_hierarchy_panel_info()  // gen panel info; sort
	real scalar _hierarchy_panel_vector()	// hierarchy panels index var
	real scalar _hierarchy_panel_info()	// hierarchy panels info matrix

	real colvector eval_equation()		// evaluate equation
	real scalar _eval_equation()

	string vector expr_names()		// expression names
	real matrix eval_expression() 		// evaluate an expression
	real scalar _eval_expression()

	real scalar eq_count()			// # equations

	string vector eq_names()		// equation names
	string scalar equation()		// equation as a string
	string scalar expression()		// expression as a string

	string vector depvars()			// dependent vars
	string vector expr_latentvars()		// expression latent vars
	string vector latentvars()		// latent or their ID vars

	string vector param_names()		// parameter names 

	string scalar new_tempname()		// new tempname

	void dump_components()			// display component table
	string matrix components()		// component table
	void dump_expr_depend()
	string scalar errmsg()
	string scalar message()
	string vector warnings()
	real scalar warning_count()

	void set_errmsg()
	void set_message()
	void add_warning()
	void clear_warnings()
	void set_special()			// set special parsing rules

    public:
	/* iterator							*/
	pointer (class __component_base) scalar iterator_init()
	pointer (class __component_base) scalar iterator_next()
	real scalar container_count()

    public:
	/* system functions						*/
	real scalar register_equation()
	real scalar register_group()
	real scalar register_component()
	real scalar remove_group()

	real scalar remove_component()

	string vector linear_combination()	// LC's as string vec
}

end

global SUBEXPR_MATAH_INCLUDED 1

exit
