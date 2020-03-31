*! version 1.2.1  04sep2019

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __component.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

/* implementation: __sub_expr_expr				*/
void __sub_expr_expr::new()
{
	m_expression = ""
}

void __sub_expr_expr::destroy()
{
	/* call private version here				*/
	_clear()
}

void __sub_expr_expr::_clear()
{
	m_expression = ""
}

void __sub_expr_expr::clear()
{
	super.clear()
	_clear()
}

transmorphic __sub_expr_expr::data(real scalar hint)
{
	return(super.data(hint))
}

real scalar __sub_expr_expr::update(transmorphic data, real scalar hint)
{
	return(super.update(data,hint))
}

real scalar __sub_expr_expr::isequal(pointer (class __sub_expr_elem) scalar pE)
{
	real scalar iseq
	pointer (class __sub_expr_expr) scalar pS
	pointer (class __component_base) scalar comp

	iseq = `SUBEXPR_FALSE'
	comp = pE->component()
	if (m_comp == NULL) { 
		if (comp == NULL) {
			pS = pE
			iseq = strmatch(m_expression,pS->expression())
			pS = NULL
		}
		return(iseq)
	}
	if (comp == NULL) {
		return(`SUBEXPR_FALSE')
	}
	comp = NULL
	return(super.isequal(pE))
}

void __sub_expr_expr::display(real scalar lev)
{
	real scalar ind

	ind = (lev-1)*4
	if (ustrlen(m_expression)) {
		printf("{txt}{col %g}string expression: {res}%s\n",ind,
				m_expression)
	}
	if (m_comp) {
		m_comp->display(lev)
	}
}

void __sub_expr_expr::set_expression(string scalar expression)
{
	m_expression = ustrtrim(expression)
}

string scalar __sub_expr_expr::expression()
{
	return(m_expression)
}

string scalar __sub_expr_expr::subexpr()
{
	return(super.subexpr())
}

real scalar __sub_expr_expr::estate()
{
	return(super.estate())
}

real scalar __sub_expr_expr::group_type()
{
	return(super.group_type())
}

real scalar __sub_expr_expr::lhstype()
{
	return(super.lhstype())
}

string scalar __sub_expr_expr::tempname()
{
	return(super.tempname())
}

real scalar __sub_expr_expr::set_component(
			pointer (class __component_base) scalar pC)
{
	return(super.set_component(pC))
}

pointer (class __sub_expr_elem) scalar __sub_expr_expr::clone(
			|pointer (class __sub_expr_elem) scalar pE)
{
	return(super.clone(pE))
}

string scalar __sub_expr_expr::traverse_expr(real scalar which)
{
	pragma unused which

	return(m_expression)
}

real scalar __sub_expr_expr::_evaluate(string scalar expr, |transmorphic extra)
{
	if (type() == `SUBEXPR_EXPRESSION') {
		expr = m_expression
		return(0)
	}
	else if (args() > 1) {
		return(super._evaluate(expr,extra))
	}
	return(super._evaluate(expr))
}

end
exit
