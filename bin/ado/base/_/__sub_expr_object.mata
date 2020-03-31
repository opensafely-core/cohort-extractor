*! version 1.0.2  04sep2019

findfile __sub_expr_object.matah
quietly include `"`r(fn)'"'

findfile __sub_expr_macros.matah
quietly include `"`r(fn)'"'

mata:

mata set matastrict on

transmorphic __sub_expr_object::data(real scalar hint)
{
	transmorphic scalar null

	pragma unset null
	pragma unused hint

	return(null)
}

real scalar __sub_expr_object::update(transmorphic data, real scalar hint)
{
	pragma unused data
	pragma unused hint

	return(0)
}

real scalar __sub_expr_object::isequal(
		pointer (class __sub_expr_object) scalar pO)
{
	pragma unused pO

	return(`SUBEXPR_FALSE')
}

void __sub_expr_object::display()
{
}

end
exit
