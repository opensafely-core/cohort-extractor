*! version 1.0.6  23jan2019

local TS_EXPR_LORDER 3
local TS_FORDER 2
local TS_LORDER 1

if "$SUBEXPR_OBJECT_MATAH_INCLUDED" != "" {
	exit
}

mata:

mata set matastrict on

/* declaration: base virtual substitutable expression class		*/
class __sub_expr_object
{
    public:
	virtual transmorphic data()
	virtual real scalar update()
	virtual real scalar isequal()
	virtual void display()
}

class __sub_expr_elem extends __sub_expr_object
{
    private:
	/* next object in linked list					*/
	final pointer (class __sub_expr_elem) scalar m_next
	final pointer (class __sub_expr_elem) scalar m_prev

	final real scalar m_properties		// properties flags

    protected:
	final pointer (class __sub_expr) scalar m_data
	final pointer (class __component_base) scalar m_comp
	/* __sub_expr_group containing this				*/
	final pointer (class __sub_expr_elem) scalar m_group
	string matrix m_options
	real scalar m_info	// context specific flag

    private:
	void _clear()

    protected:
	void new()
	void destroy()

    protected:
	string scalar pt_stype()

	real scalar traverse_atop_node()

	void set_properties()
	real scalar properties()

    public:
	virtual transmorphic data()
	virtual real scalar update()
	virtual real scalar isequal()
	virtual void display()
	virtual string scalar traverse_expr()
	virtual real scalar _evaluate()
	virtual pointer (class __sub_expr_elem) scalar clone()
	virtual string scalar subexpr()
	virtual string scalar tempname()
	virtual real scalar lhstype()
	virtual real scalar estate()
	virtual real scalar set_component()
	virtual real scalar group_type()
	virtual void clear()
	virtual string scalar expression()

    public:
	void classname()
	string scalar name()
	string scalar group()
	real scalar type()
	string scalar stype()
	string vector key()

	void set_dataobj()
	void set_info()
	real scalar info()
	void set_groupobj()
	pointer (class __sub_expr_elem) scalar groupobj()
	void unlink()

	void set_next()
	void set_prev()
	pointer (class __sub_expr_elem) scalar next()
	pointer (class __sub_expr_elem) scalar prev()
	pointer (class __component_base) scalar component()

	void set_options()
	string vector options()
	real vector test_option()
	real scalar has_option()
	real scalar has_options()
	real scalar validate_options()

	real scalar traverse_LV()
	real scalar traverse_param()

	real scalar has_property()
	void add_property()
	void remove_property()
}

class __sub_expr_expr extends __sub_expr_elem
{
    protected:
	string scalar m_expression

    private:
	void _clear()

    protected:
	void new()
	void destroy()

    public:
	virtual transmorphic data()
	virtual real scalar update()
	virtual real scalar isequal()
	virtual void display()
	virtual string scalar traverse_expr()
	virtual real scalar _evaluate()
	virtual pointer (class __sub_expr_elem) scalar clone()
	virtual string scalar subexpr()
	virtual string scalar tempname()
	virtual real scalar lhstype()
	virtual real scalar estate()
	virtual real scalar set_component()
	virtual real scalar group_type()
	virtual void clear()
	virtual string scalar expression()
	
	void set_expression()
}


struct __LV_summary
{
	string scalar lvname	// latent variable name
	string scalar path	// latent variable path
	string scalar vexpr	// covariate string expression
	string scalar vname	// covariate name
	string scalar expr	// trace string expression
	real vector covariate	// covariate data (evaluate expression)
	real vector ib		// RE index vector
	real scalar iparam 	// scaling parameter index
	pointer (class __component_param) scalar param	// scaling parameter
}

class __sub_expr_group extends __sub_expr_expr
{
    protected:
	pointer (class __sub_expr_elem) scalar m_first
	pointer (class __sub_expr_elem) scalar m_last
	real scalar m_kexpr		// length of linked list
	real scalar m_hascons		// constant coef flag
	real scalar m_coefref		// LC coef reference flag
	real scalar m_eready		// evaluate ready flag
	real scalar m_instance		// instance index for LC's with
					//  same name but different varlists
	real vector m_tsorder		// time-series order, (lag,forward)
	string vector m_tsexpr		// named expressions with ts ops
	pointer (struct __component_state) scalar m_state
	struct nlparse_node scalar m_ptree	// nlparse tree

	string scalar m_LCexpr		// LC string expression
	string vector m_LVnames
	real scalar m_n

    private:
	pointer (struct __LV_summary) scalar construct_LV_summary()

    protected:
	void new()
	void destroy()

    protected:
	void _clear()

	real scalar add_LC_param()
	real scalar add_LC_latentvar()
	string scalar options_string()

	real scalar add_object()
	real scalar add_strexpression()

	real scalar traverse_LC_tree()
	real scalar traverse_LC_node()
	real scalar traverse_LC_operator()
	real scalar traverse_LC_param()
	real scalar traverse_LC_param_WC()	// parameter with wild card
	real scalar traverse_expr_tree()
	real scalar traverse_expr_node()

	real scalar factor_op_node()
	real scalar TS_op_node()
	real scalar LV_param_node()

	string scalar _traverse_eq()
	string scalar _traverse_expr()

	real scalar post_resolve_eq()
	real scalar post_resolve_expr()

    protected:
	virtual real scalar _evaluate_LC()
	virtual real scalar compose_LC_eval()	// compose evaluate information

    public:
	virtual transmorphic data()
	virtual real scalar update()
	virtual real scalar isequal()
	virtual void display()
	virtual string scalar traverse_expr()
	virtual string scalar expression()
	virtual real scalar _evaluate()
	virtual pointer (class __sub_expr_elem) scalar clone()
	virtual string scalar subexpr()
	virtual string scalar tempname()
	virtual string scalar touse()
	virtual real scalar lhstype()
	virtual real scalar estate()
	virtual real scalar set_component()
	virtual real scalar group_type()
	virtual void clear()
	virtual real scalar post_resolve()	// done resolve, set any flags

    public:
	void mark_dirty()
	real scalar mark_dirty_contained()
	real scalar expand_FVs()		// expand factor variables

	real scalar swap_objects()		// swap objects in expression
	real scalar set_group_type()
	real scalar has_component()
	real scalar hascons()
	void set_hascons()
	real scalar add_constant()
	real scalar kexpr()
	real scalar set_touse()
	real scalar coefref()
	void set_instance()		// LC instance index
	real scalar instance()
	void set_TS_order()		// time-series order (#1,#2), L#1. F#2.
	real vector TS_order()
	void resolve_TS_order()

	pointer (class __sub_expr_elem) scalar eqobj()

	pointer (class __sub_expr_elem) scalar first()
	pointer (class __sub_expr_elem) scalar last()

	pointer (struct __component_state) scalar state()
	void set_state()

	string scalar sgroup_type()
	real scalar update_group_type()

	real scalar group_size()
	string matrix element_names()

	struct nlparse_node scalar parse_tree()
	void set_parse_tree()

	string vector varlist()
	string vector LV_names()
	real scalar markout()
	void pt_display()

	real scalar isdefined()

	void unlink()
}

class __bayes_expr_group extends __sub_expr_group
{
    protected:
	/* LC evaluate information:  m_eready flag is set true when the
	 *  data members below are initialized in ::_evaluate_LC()	*/
	string vector m_exprLV		// LV evaluate expressions: matael()
	pointer (struct __LV_summary) vector m_lvlist	// quick eval LV struct
	string vector m_vlist		// X varlist for evaluate
	real matrix m_X
	real vector m_ib		// coef index vector for evaluate
	real scalar m_ibcons

    protected:
	void new()
	void destroy()

    protected:
	virtual real scalar _evaluate_LC()
	virtual real scalar compose_LC_eval()	// compose evaluate information

    public:
	virtual transmorphic data()
	virtual real scalar update()
	virtual real scalar isequal()
	virtual void display()
	virtual string scalar traverse_expr()
	virtual string scalar expression()
	virtual real scalar _evaluate()
	virtual pointer (class __sub_expr_elem) scalar clone()
	virtual string scalar subexpr()
	virtual string scalar tempname()
	virtual string scalar touse()
	virtual real scalar lhstype()
	virtual real scalar estate()
	virtual real scalar set_component()
	virtual real scalar group_type()
	virtual void clear()
	virtual real scalar post_resolve()	// done resolve, set any flags

    private:
	pointer (struct __LV_summary) scalar construct_LV_summary()

    public:
	real scalar evaluate_LC()
}

end

global SUBEXPR_OBJECT_MATAH_INCLUDED 1

exit
