*! version 1.2.2  22oct2010
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'

mata:

void mopt__calluser_d(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient vector
	real matrix	H		// OUTPUT : Hessian matrix
)
{
	(*user)(
		(*(arg[1])),
		todo,
		p,
		v,
		g,
		H)
	if (minimize) {
		_negate(v)
		if (todo > 0) {
			_negate(g)
			if (todo > 1) {
				_negate(H)
			}
		}
	}
}

void mopt__calluser_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// INPUT  : weights
	real colvector	by_w,		// INPUT  : group weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		(*(arg[1])),
		todo,
		p,
		v_v,
		g_v,
		H)
	if (minimize) {
		_negate(v_v)
		if (todo > 0) {
			_negate(g_v)
			if (todo > 1) {
				_negate(H)
			}
		}
	}
	opt__check_v(todo,w,by_w,v_v,g_v,v,g)
}

void mopt__calluser_e(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient vector
	real matrix	H,		// OUTPUT : Hessian matrix
	real matrix	g_e		// OUTPUT : equation-level scores
)
{
	(*user)(
		(*(arg[1])),
		todo,
		p,
		v,
		g_e,
		H)
	if (minimize) {
		_negate(v)
		if (todo > 0) {
			_negate(g_e)
			if (todo > 1) {
				_negate(H)
			}
		}
	}
	mopt__check_e(todo,(*(arg[1])),g_e,v,g)
}

void mopt__calluser_lf(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v
)
{
	pragma unset todo
	pragma unset g
	pragma unset H
	pragma unset g_v
	(*user)(
		(*(arg[1])),
		p,
		v_v)
	if (minimize) {
		_negate(v_v)
	}
	v = moptimize_util_sum((*(arg[1])),v_v)
}

void mopt__calluser_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		(*(arg[1])),
		todo,
		p,
		v_v,
		g_v
	)
}

void mopt__calluser_lf2(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient vector
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_e		// OUTPUT : equation-level scores
)
{
	(*user)(
		(*(arg[1])),
		todo,
		p,
		v_v,
		g_e,
		H)
	if (minimize) {
		_negate(v_v)
		if (todo > 0) {
			_negate(g_e)
			if (todo > 1) {
				_negate(H)
			}
		}
	}
	v = moptimize_util_sum((*(arg[1])),v_v)
	mopt__check_e(todo,(*(arg[1])),g_e,v,g)
}

end
