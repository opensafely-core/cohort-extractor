*! version 1.0.0  22oct2007
version 10

findfile deriv_include.mata
quietly include `"`r(fn)'"'

mata:

// type 'd' evaluator utilities ---------------------------------------------

void deriv__call0user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		v)
	deriv__setdelta(D,i,.,p)
}

void deriv__call1user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		v)
	deriv__setdelta(D,i,.,p)
}

void deriv__call2user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		v)
	deriv__setdelta(D,i,.,p)
}

void deriv__call3user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		v)
	deriv__setdelta(D,i,.,p)
}

void deriv__call4user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		v)
	deriv__setdelta(D,i,.,p)
}

void deriv__call5user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		v)
	deriv__setdelta(D,i,.,p)
}

void deriv__call6user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		v)
	deriv__setdelta(D,i,.,p)
}

void deriv__call7user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		v)
	deriv__setdelta(D,i,.,p)
}

void deriv__call8user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		v)
	deriv__setdelta(D,i,.,p)
}

void deriv__call9user_d(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v_v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9]),
		v)
	deriv__setdelta(D,i,.,p)
}

// type 'v' evaluator utilities ---------------------------------------------

void deriv__call0user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

void deriv__call1user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

void deriv__call2user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

void deriv__call3user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

void deriv__call4user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

void deriv__call5user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

void deriv__call6user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

void deriv__call7user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

void deriv__call8user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

void deriv__call9user_v(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	colvector	v_v
)
{
	pragma unset v
	pragma unset k
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9]),
		v_v)
	deriv__setdelta(D,i,.,p)
	if (!isfleeting(v)) deriv__sum(D,v_v,v)
}

// type 't' evaluator utilities ---------------------------------------------

void deriv__call0user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

void deriv__call1user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

void deriv__call2user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

void deriv__call3user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

void deriv__call4user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

void deriv__call5user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

void deriv__call6user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

void deriv__call7user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

void deriv__call8user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

void deriv__call9user_t(
	`DerivStruct'		D,
	real	rowvector	p,
	real	scalar		k,
	real	scalar		i,
	real	scalar		h,
	real	scalar		v,
	real	vector		v_t
)
{
	pragma unset v_t
	deriv__setdelta(D,i,h,p)
	(*D.user)(
		p,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9]),
		v_t)
	deriv__setdelta(D,i,.,p)
	if (k) {
		v	= v_t[k]
	}
}

// users 'h' calculator utilities -------------------------------------------

void deriv__call0user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		h)
}

void deriv__call1user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		(*D.arglist[1]),
		h)
}

void deriv__call2user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		(*D.arglist[1]),
		(*D.arglist[2]),
		h)
}

void deriv__call3user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		h)
}

void deriv__call4user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		h)
}

void deriv__call5user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		h)
}

void deriv__call6user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		h)
}

void deriv__call7user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		h)
}

void deriv__call8user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		h)
}

void deriv__call9user_h(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_h)(
		(*D.params),
		i,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9]),
		h)
}

// users 'neq' calculator utilities -----------------------------------------

real scalar deriv__call0user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params)
	))
}

real scalar deriv__call1user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params),
		(*D.arglist[1])
	))
}

real scalar deriv__call2user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2])
	))
}

real scalar deriv__call3user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3])
	))
}

real scalar deriv__call4user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4])
	))
}

real scalar deriv__call5user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5])
	))
}

real scalar deriv__call6user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6])
	))
}

real scalar deriv__call7user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7])
	))
}

real scalar deriv__call8user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8])
	))
}

real scalar deriv__call9user_neq(`DerivStruct' D)
{
	return((*D.user_neq)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9])
	))
}

// users vecsum utilities ---------------------------------------------------

void deriv__call0user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		H)
}

void deriv__call1user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		(*D.arglist[1]),
		H)
}

void deriv__call2user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		H)
}

void deriv__call3user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		H)
}

void deriv__call4user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		H)
}

void deriv__call5user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		H)
}

void deriv__call6user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		H)
}

void deriv__call7user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		H)
}

void deriv__call8user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		H)
}

void deriv__call9user_vecsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_vecsum)(
		i,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9]),
		H)
}

// users matsum utilities ---------------------------------------------------

void deriv__call0user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		H)
}

void deriv__call1user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		(*D.arglist[1]),
		H)
}

void deriv__call2user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		H)
}

void deriv__call3user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		H)
}

void deriv__call4user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		H)
}

void deriv__call5user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		H)
}

void deriv__call6user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		H)
}

void deriv__call7user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		H)
}

void deriv__call8user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		H)
}

void deriv__call9user_matsum(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		j,
	real	colvector	score,
	real	matrix		H
)
{
	(*D.user_matsum)(
		i,
		j,
		score,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9]),
		H)
}

// users setdelta utilities -------------------------------------------------

void deriv__call0user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.params))
}

void deriv__call1user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.arglist[1]),
		(*D.params))
}

void deriv__call2user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.params))
}

void deriv__call3user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.params))
}

void deriv__call4user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.params))
}

void deriv__call5user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.params))
}

void deriv__call6user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.params))
}

void deriv__call7user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.params))
}

void deriv__call8user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.params))
}

void deriv__call9user_setdelta(
	`DerivStruct'		D,
	real	scalar		i,
	real	scalar		h
)
{
	(*D.user_setdelta)(
		i,
		h,
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9]),
		(*D.params))
}

// users setup utilities ----------------------------------------------------

void deriv__call0user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		i
	)
}

void deriv__call1user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		(*D.arglist[1]),
		i
	)
}

void deriv__call2user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		i
	)
}

void deriv__call3user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		i
	)
}

void deriv__call4user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		i
	)
}

void deriv__call5user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		i
	)
}

void deriv__call6user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		i
	)
}

void deriv__call7user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		i
	)
}

void deriv__call8user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		i
	)
}

void deriv__call9user_setup1(`DerivStruct' D, real scalar i)
{
	(*D.user_setup1)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9]),
		i
	)
}

void deriv__call0user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		i,
		j
	)
}

void deriv__call1user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		(*D.arglist[1]),
		i,
		j
	)
}

void deriv__call2user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		i,
		j
	)
}

void deriv__call3user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		i,
		j
	)
}

void deriv__call4user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		i,
		j
	)
}

void deriv__call5user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		i,
		j
	)
}

void deriv__call6user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		i,
		j
	)
}

void deriv__call7user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		i,
		j
	)
}

void deriv__call8user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		i,
		j
	)
}

void deriv__call9user_setup2(`DerivStruct' D, real scalar i, real scalar j)
{
	(*D.user_setup2)(
		(*D.params),
		(*D.arglist[1]),
		(*D.arglist[2]),
		(*D.arglist[3]),
		(*D.arglist[4]),
		(*D.arglist[5]),
		(*D.arglist[6]),
		(*D.arglist[7]),
		(*D.arglist[8]),
		(*D.arglist[9]),
		i,
		j
	)
}

end
