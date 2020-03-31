*! version 1.1.3  14jan2019

if "$COMPONENT_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

struct __component_state 
{
	string scalar tname
	string scalar subexpr
	real scalar estate
	real scalar lhstype
	string scalar touse
	real scalar markout
	string scalar touse_init	// TS initialize estimation sample
	real scalar markout_init
}

/* declaration: base virtual class substitutable expression __component	*/
class __component_base
{
    protected:
	final string scalar m_name	// object name, key[2]
	final string scalar m_group	// group name, key[1]
	final real scalar m_ref		// reference counter
	final struct __component_state scalar m_state

	static m_errmsg

    protected:
	void new()
	void destroy()

    public:
	string scalar name()
	string scalar group()
	string vector key()
	pointer (struct __component_state) scalar state()
	string scalar errmsg()
	real scalar refcount()

	virtual void set_name()
	virtual void set_group()
	virtual real scalar type()
	virtual string scalar stype()
	virtual real scalar isequal()
	virtual real scalar validate()
	virtual real scalar update()
	virtual transmorphic data()
	virtual void display()
	virtual string scalar expression()
	virtual string scalar subexpr()
}

class __component_var extends __component_base
{
    private:
	string scalar m_operator	// ts or fv operator

    protected:
	void new()
	void destroy()

    public:
	virtual void set_name()
	virtual void set_group()
	virtual real scalar type()
	virtual string scalar stype()
	virtual real scalar isequal()
	virtual real scalar validate()
	virtual real scalar update()
	virtual transmorphic data()
	virtual void display()
	virtual string scalar expression()
	virtual string scalar subexpr()

    public:
	void set_operator()
	string scalar _operator()
}

class __component_lv extends __component_base
{
    private:
	/* random slope, LV#c.var					*/
	string scalar m_covariate
	pointer (class __lvpath scalar) scalar m_path
	/* scale coefficients						*/	
	pointer (class __component_param) vector m_param

    protected:
	void new()
	void destroy()

    public:
	real scalar parse_path()
	string scalar varlist()
	string scalar path()
	string vector hierarchy()
	void set_covariate()
	string scalar covariate()
	pointer (class __lvpath) scalar path_tree()
	void set_path_tree()
	void add_param()
	void remove_param()
	real scalar param_index()
	pointer (class __component_param) scalar param()
	pointer (class __component_param) vector param_vec()

	virtual void set_name()
	virtual void set_group()
	virtual real scalar type()
	virtual string scalar stype()
	virtual real scalar isequal()
	virtual real scalar validate()
	virtual real scalar update()
	virtual transmorphic data()
	virtual void display()
	virtual string scalar expression()
	virtual string scalar subexpr()
}

class __component_param extends __component_base
{
    protected:
	real scalar m_value		// value set at parse time
	real scalar m_iparam		// index into param vector
	real scalar m_param_type	// LC parm, factor var,
					//  free parm, LV param
	real scalar m_fixed		// fixed parameter (set with @#)
	pointer (class __component_param) vector m_fvex
						// expand factor var
    protected:
	void new()
	void destroy()

    public:
	virtual void set_name()
	virtual void set_group()
	virtual real scalar type()
	virtual string scalar stype()
	virtual real scalar validate()
	virtual real scalar update()
	virtual transmorphic data()
	virtual void display()
	virtual string scalar expression()
	virtual string scalar subexpr()

	void add_factor_var()
	void clear_factors()
	real scalar fv_count()
	real scalar param_index()
	real scalar value()
	void set_value()
	real scalar is_fixed()
	void set_fixed()
	pointer (class __component_param) vector factor_vars()
}

class __component_matrix extends __component_base
{
    protected:
	class __stmatrix scalar m_stmatrix

    protected:
   	void new()
	void destroy()

    public:
	real scalar set_stmatrix()
	real scalar set_matrix()
	class __stmatrix scalar stmatrix()
	real scalar set_stripe()
	string matrix stripe()

	virtual void set_name()
	virtual real scalar type()
	virtual string scalar stype()
	virtual real scalar validate()
	virtual real scalar update()
	virtual transmorphic data()
	virtual void display()
	virtual string scalar expression()
	virtual string scalar subexpr()
}

class __component_group extends __component_base
{
    protected:
	/* back pointers to __sub_expr_group holding on to this		*/
	pointer (class __sub_expr_object) vector m_exprobj
	pointer (class __sub_expr_object) scalar m_initobj
	real scalar m_kunique
	real scalar m_instance_count
	real scalar m_eval_status	// expression evaluation status:
					//  IDLE, EVAL
	real scalar m_tsinit_req	// flag denoting a TS initialization
					//  expression is required
	real scalar m_group_type	// type of group

    public:
	static string vector m_sgroup_types

    protected:
	void new()
	void destroy()

    public:
	virtual void set_name()
	virtual void set_group()
	virtual real scalar type()
	virtual string scalar stype()
	virtual real scalar isequal()
	virtual real scalar set_group_type()
	virtual real scalar validate()
	virtual real scalar update()
	virtual transmorphic data()
	virtual void display()
	virtual string scalar expression()
	virtual string scalar subexpr()

	real scalar group_type()
	string scalar sgroup_type()

	void set_eval_status()
	real scalar eval_status()

	void set_TS_init_req()		// time-series needs an initialization
	real scalar TS_init_req()	//  expression

	real scalar group_count()
	pointer (class __sub_expr_object) scalar get_object()
	void set_TS_initobj()
	pointer (class __sub_expr_object) scalar TS_initobj()
}

end

global COMPONENT_MATAH_INCLUDED 1

exit
