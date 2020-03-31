*! version 1.2.2  22oct2010
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'

mata:

void opt__calluser0_d(
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
	pragma unset arg
	(*user)(
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

void opt__calluser1_d(
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
		todo,
		p,
		(*(arg[1])),
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

void opt__calluser2_d(
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
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
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

void opt__calluser3_d(
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
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
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

void opt__calluser4_d(
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
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
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

void opt__calluser5_d(
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
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
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

void opt__calluser6_d(
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
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
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

void opt__calluser7_d(
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
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
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

void opt__calluser8_d(
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
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		(*(arg[8])),
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

void opt__calluser9_d(
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
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		(*(arg[8])),
		(*(arg[9])),
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

void opt__calluser0_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// INPUT  : weights
	real colvector	by_w,		// INPUT  : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	pragma unset arg
	(*user)(
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

void opt__calluser1_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// INPUT  : weights
	real colvector	by_w,		// INPUT  : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
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

void opt__calluser2_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// OUTPUT : weights
	real colvector	by_w,		// OUTPUT : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
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

void opt__calluser3_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// OUTPUT : weights
	real colvector	by_w,		// OUTPUT : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
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

void opt__calluser4_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// OUTPUT : weights
	real colvector	by_w,		// OUTPUT : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
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

void opt__calluser5_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// OUTPUT : weights
	real colvector	by_w,		// OUTPUT : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
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

void opt__calluser6_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// OUTPUT : weights
	real colvector	by_w,		// OUTPUT : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
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

void opt__calluser7_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// OUTPUT : weights
	real colvector	by_w,		// OUTPUT : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
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

void opt__calluser8_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// OUTPUT : weights
	real colvector	by_w,		// OUTPUT : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		(*(arg[8])),
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

void opt__calluser9_v(
	pointer(function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real scalar		minimize,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	w,		// OUTPUT : weights
	real colvector	by_w,		// OUTPUT : by weights
	real scalar	v,		// OUTPUT : value
	real rowvector	g,		// OUTPUT : gradient by obs matrix
	real matrix	H,		// OUTPUT : Hessian matrix
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		(*(arg[8])),
		(*(arg[9])),
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

void opt__calluser0_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	pragma unset arg
	(*user)(
		todo,
		p,
		v_v,
		g_v
	)
}

void opt__calluser1_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		v_v,
		g_v
	)
}

void opt__calluser2_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		v_v,
		g_v
	)
}

void opt__calluser3_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		v_v,
		g_v
	)
}

void opt__calluser4_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		v_v,
		g_v
	)
}

void opt__calluser5_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		v_v,
		g_v
	)
}

void opt__calluser6_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		v_v,
		g_v
	)
}

void opt__calluser7_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		v_v,
		g_v
	)
}

void opt__calluser8_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		(*(arg[8])),
		v_v,
		g_v
	)
}

void opt__calluser9_q(
	pointer(function)	scalar		user,
	pointer			rowvector	arg,
	real scalar	todo,		// INPUT  : instructions
	real rowvector	p,		// INPUT  : parameter vector
	real colvector	v_v,		// OUTPUT : values by obs vector
	real matrix	g_v		// OUTPUT : gradient by obs matrix
)
{
	(*user)(
		todo,
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		(*(arg[8])),
		(*(arg[9])),
		v_v,
		g_v
	)
}

// numerical derivative routines --------------------------------------------

void opt__d0_calluser(
	real	rowvector	p_alt,
	`OptStruct'		S,
	real	scalar		v
)
{
	real	rowvector	g0
	real	matrix		H0
	real	scalar		doCns
	pragma unset g0
	pragma unset H0

	doCns = 0
	if (S.hasCns) {
		doCns	= cols(p_alt)==cols(S.T)
		if (doCns) {
			p_alt = p_alt*S.T'+S.a
		}
	}
	(*S.calluser)(S.user,S.arglist,S.minimize,0,p_alt,v,g0,H0)
	opt__cnt_eval(S,0,v)
	if (doCns) {
		p_alt = (p_alt-S.a)*S.T
	}
}

void opt__v0_calluser(
	real	rowvector	p_alt,
	`OptStruct'		S,
	real	colvector	v_v
)
{
	real	scalar		v
	real	rowvector	g0
	real	matrix		g0_v
	real	matrix		H0
	real	scalar		doCns
	pragma unset v
	pragma unset g0
	pragma unset g0_v
	pragma unset H0

	doCns = 0
	if (S.hasCns) {
		doCns	= cols(p_alt)==cols(S.T)
		if (doCns) {
			p_alt = p_alt*S.T'+S.a
		}
	}
	(*S.calluser)(S.user,S.arglist,S.minimize,
		0,p_alt,S.weights,S.by_weights,v,g0,H0,v_v,g0_v)
	opt__cnt_eval(S,0,v)
	if (doCns) {
		p_alt = (p_alt-S.a)*S.T
	}
}

void opt__q0_calluser(
	real	rowvector	p_alt,
	`OptStruct'		S,
	real	colvector	v_v
)
{
	real	scalar		doCns
	real	matrix		g0_v
	pragma unset g0_v

	doCns = 0
	if (S.hasCns) {
		doCns	= cols(p_alt)==cols(S.T)
		if (doCns) {
			p_alt = p_alt*S.T'+S.a
		}
	}
	(*S.calluser)(S.user,S.arglist,0,p_alt,v_v,g0_v)
	opt__cnt_eval(S, 0, (missing(v_v) ? . : 0) )
	if (doCns) {
		p_alt = (p_alt-S.a)*S.T
	}
}

void opt__lf_calluser(
	real	rowvector	p_alt,
	`OptStruct'		S,
	real	colvector	v_v
)
{
	real	scalar		v
	real	rowvector	g0
	real	matrix		H0
	pragma unset v
	pragma unset p_alt
	pragma unset g0
	pragma unset H0
	(*S.calluser)(S.user,S.arglist,S.minimize,0,S.params,v,g0,H0,v_v,.)
	opt__cnt_eval(S,.,v)
}

void opt__lf2_calluser(
	real	rowvector	p_alt,
	`OptStruct'		S,
	real	colvector	v_v
)
{
	real	scalar		v
	real	rowvector	g0
	real	rowvector	g_e0
	real	matrix		H0
	pragma unset v
	pragma unset p_alt
	pragma unset g0
	pragma unset g_e0
	pragma unset H0
	(*S.calluser)(S.user,S.arglist,S.minimize,0,S.params,v,g0,H0,v_v,g_e0)
	opt__cnt_eval(S,.,v)
}

void opt__callprolog0(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		v
	)
}

void opt__callprolog1(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		(*(arg[1])),
		v
	)
}

void opt__callprolog2(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		(*(arg[1])),
		(*(arg[2])),
		v
	)
}

void opt__callprolog3(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		v
	)
}

void opt__callprolog4(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		v
	)
}

void opt__callprolog5(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		v
	)
}

void opt__callprolog6(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		v
	)
}

void opt__callprolog7(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		v
	)
}

void opt__callprolog8(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		(*(arg[8])),
		v
	)
}

void opt__callprolog9(
	pointer(real function)	scalar		user,
	pointer(matrix)		rowvector	arg,
	real			rowvector	p,
	real			matrix		v
)
{
	pragma unset arg
	(*user)(
		p,
		(*(arg[1])),
		(*(arg[2])),
		(*(arg[3])),
		(*(arg[4])),
		(*(arg[5])),
		(*(arg[6])),
		(*(arg[7])),
		(*(arg[8])),
		(*(arg[9])),
		v
	)
}

end
