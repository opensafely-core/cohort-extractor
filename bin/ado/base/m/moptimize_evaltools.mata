*! version 1.1.2  24oct2010
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'
findfile moptimize_include.mata
quietly include `"`r(fn)'"'

mata:

transmorphic moptimize_util_userinfo(`MoptStruct' M, real scalar i)
{
	return(moptimize_init_userinfo(M, i))
}

real matrix moptimize_calc_depvar(`MoptStruct' M, | real scalar i)
{
	if (args() == 1) {
		return(moptimize_util_depvar(M))
	}
	return(moptimize_util_depvar(M, i))
}

real matrix moptimize_util_depvar(`MoptStruct' M, | real scalar i)
{
	if (args() == 1) {
		i = 1
	}
	mopt__check_depvaridx(i, M.ndepvars)
	return((*M.depvars[i]))
}

real matrix moptimize_util_indepvars(`MoptStruct' M, real scalar eq)
{
	real matrix	X
	real scalar	rows

	mopt__check_eqnum(eq, M.neq)
	if (M.eqlist[eq] != NULL) {
		X = *M.eqlist[eq]
		rows = rows(X)
	}
	else {
		X = J(1,0,.)
		rows = 1
	}
	if (M.eqcons[eq]) {
		X = X, J(rows,1,1)
	}
	return(X)
}

pointer scalar moptimize_util_X_ptr(`MoptStruct' M, real scalar eq)
{
	mopt__check_eqnum(eq, M.neq)
	return(M.eqlist[eq])
}

pointer scalar moptimize_util_offset_ptr(`MoptStruct' M, real scalar eq)
{
	mopt__check_eqnum(eq, M.neq)
	return(M.eqoffset[eq])
}

pointer scalar moptimize_util_w_ptr(`MoptStruct' M)
{
	if (M.wtype == `OPT_wtype_none') {
		return(NULL)
	}
	return(M.weights)
}

real colvector moptimize_calc_xb(
	`MoptStruct'	M,
	real rowvector	p,
	real scalar	eq
) return(moptimize_util_xb(M,p,eq))

real colvector moptimize_util_xb(
	`MoptStruct'	M,
	real rowvector	p,
	real scalar	eq
)
{
	real	scalar		i0, i1
	real	colvector	xb
	pragma unset xb

	mopt__check_eqnum(eq, M.neq)
	if (M.valid & M.hold_xb == `OPT_onoff_on') {
		_mopt_holdxbi(M.xb, eq, xb)
	}
	else {
		i0 = M.eqdims[1,eq]
		i1 = M.eqdims[2,eq]
		xb = _mopt_xb(	M.eqlist[eq],
				M.eqcons[eq],
				p, i0, i1,
				M.eqoffset[eq],
				M.eqexposure[eq],
				M.eqdelta[eq]
			)
	}
	return(xb)
}

real scalar moptimize_util_sum(
	`MoptStruct'	M,
	real colvector	values
)
{
	if (missing(values)) {
		return(.)
	}
	if (M.wtype == `OPT_wtype_none') {
		return(quadcolsum(values))
	}
	return(quadcross((*M.weights), values))
}

real matrix moptimize_util_chainrule_scores(
	`MoptStruct'	M,
	real scalar	eq,
	real colvector	scores,
	real scalar	value
)
{
	mopt__check_eqnum(eq, M.neq)
	if (missing(value) | missing(scores)) {
		value = .
		return(J(rows(scores),mopt__eq_dim(M, eq),.))
	}

	if (M.eqlist[eq] != NULL) {
		if (M.eqcons[eq]) {
			return((scores :* (*M.eqlist[eq]), scores))
		}
		return(scores :* (*M.eqlist[eq]))
	}
	return(scores)
}

real rowvector moptimize_util_vecsum(
	`MoptStruct'	M,
	real scalar	eq,
	real colvector	scores,
	real scalar	value,
	|real scalar	drop_mv
)
{
	real	rowvector	g

	mopt__check_eqnum(eq, M.neq)
	if (missing(value)) {
		return(J(1,mopt__eq_dim(M, eq),.))
	}

	if (M.wtype == `OPT_wtype_none') {
		if (rows(scores) > 1) {
			g = _mopt_vecsum(	M.eqlist[eq],
						M.eqcons[eq],
						NULL,
						scores,
						1,
						value,
						drop_mv)
		}
		else if (!missing(scores)) {
			g = M.obs*scores
		}
		else {
			value = .
		}
	}
	else {
		g = _mopt_vecsum(	M.eqlist[eq],
					M.eqcons[eq],
					M.weights,
					scores,
					1,
					value,
					drop_mv)
	}
	return(g)
}

real matrix moptimize_util_matsum(
	`MoptStruct'	M,
	real scalar	eq1,
	real scalar	eq2,
	real colvector	scores,
	real scalar	value,
	|real scalar	drop_mv
)
{
	real	matrix	H

	mopt__check_eqnum(eq1, M.neq)
	mopt__check_eqnum(eq2, M.neq)
	if (missing(value) | missing(scores)) {
		value	= .
		return(J(mopt__eq_dim(M,eq1), mopt__eq_dim(M,eq2), 0))
	}

	if (eq1 == eq2) {
		if (M.eqlist[eq1] == NULL) {
			H = moptimize_util_vecsum(M,eq1,scores,value,drop_mv)
		}
		else if (M.wtype == `OPT_wtype_none') {
			H = _mopt_matsum_xx(	M.eqlist[eq1],
						M.eqcons[eq1],
						NULL,
						scores,
						value,
						drop_mv)
		}
		else {
			H = _mopt_matsum_xx(	M.eqlist[eq1],
						M.eqcons[eq1],
						M.weights,
						scores,
						value,
						drop_mv)
		}
	}
	else if (M.eqlist[eq1] != NULL & M.eqlist[eq2] != NULL) {
		if (M.wtype == `OPT_wtype_none') {
			H = _mopt_matsum_xy(	M.eqlist[eq1],
						M.eqcons[eq1],
						M.eqlist[eq2],
						M.eqcons[eq2],
						NULL,
						scores,
						value,
						drop_mv)
		}
		else {
			H = _mopt_matsum_xy(	M.eqlist[eq1],
						M.eqcons[eq1],
						M.eqlist[eq2],
						M.eqcons[eq2],
						M.weights,
						scores,
						value,
						drop_mv)
		}
	}
	else if (M.eqlist[eq1] != NULL) {
		H = moptimize_util_vecsum(M,eq1,scores,value,drop_mv)'
	}
	else {
		H = moptimize_util_vecsum(M,eq2,scores,value,drop_mv)
	}
	return(H)
}

pointer scalar moptimize_util_by(`MoptStruct' M)
{
	return(M.by)
}

real matrix moptimize_util_matbysum(
	`MoptStruct'	M,
			arg2,
			arg3,
			arg4,
			arg5,
	|		arg6,
			arg7
)
{
	if (args() == 5) {
		return(mopt__util_matbysum_within(
			M,
			arg2,		// eq
			arg3,		// a
			arg4,		// b
			arg5))		// value
	}
	if (args() == 6) {
		errprintf("invalid number of arguments")
		exit(3498)
	}
	return(mopt__util_matbysum_between(
		M,
		arg2,		// eq1
		arg3,		// eq2
		arg4,		// a
		arg5,		// b
		arg6,		// c
		arg7))		// value
}

real matrix moptimize_util_eq_indices(
	`MoptStruct'	M,
	real scalar	i,
	|real scalar	j
)
{
	if (args() == 2) {
		return(_2x2(1, M.eqdims[1,i], 1, M.eqdims[2,i]))
	}
	if (nonmissing(i) & nonmissing(j)) {
		return(_2x2(	M.eqdims[1,i], M.eqdims[1,j],
				M.eqdims[2,i], M.eqdims[2,j]))
	}
	if (nonmissing(i)) {
		return(_2x2(	M.eqdims[1,i], 1,
				M.eqdims[2,i], .))
	}
	if (nonmissing(j)) {
		return(_2x2(	1, M.eqdims[1,j],
				., M.eqdims[2,j]))
	}
	return(_2x2(1,1,.,.))
}

// utilities ----------------------------------------------------------------

void mopt_vecsum(
	`MoptStruct'	M,
	real matrix	scores,
	real scalar	v,
	real rowvector	g,
	|real scalar	drop_mv
)
{
	real scalar	i, neq, i0, i1
	real rowvector	gi

	neq = cols(scores)
	i0 = i1 = 1
	for (i=1; i<=neq; i++) {
		gi = _mopt_vecsum(
			M.eqlist[i],
			M.eqcons[i],
			M.weights,
			scores,
			i,
			v,
			drop_mv)
		i1 = i0 + cols(gi) - 1
		g[|i0\i1|] = gi
		i0 = i1 + 1
	}
}

/*STATIC*/ real matrix mopt__util_matbysum_within(
	`MoptStruct'	M,
	real scalar	eq,
	real colvector	a,
	real colvector	b,
	real scalar	value
)
{
	real	matrix 	H

	if (M.by == NULL) {
		errprintf("by vector not set")
		exit(3498)
	}
	mopt__check_eqnum(eq, M.neq)
	H = _mopt_matbysum_xx(	(*M.by),
				M.eqlist[eq],
				M.eqcons[eq],
				M.weights,
				a,
				b,
				value)
	return(H)
}

/*STATIC*/ real matrix mopt__util_matbysum_between(
	`MoptStruct'	M,
	real scalar	eq1,
	real scalar	eq2,
	real colvector	a,
	real colvector	b,
	real colvector	c,
	real scalar	value
)
{
	real	matrix	H
	pragma unset H

	if (M.by == NULL) {
		errprintf("by vector not set")
		exit(3498)
	}
	mopt__check_eqnum(eq1, M.neq)
	mopt__check_eqnum(eq2, M.neq)
	H = _mopt_matbysum_xy(	(*M.by),
				M.eqlist[eq1],
				M.eqcons[eq1],
				M.eqlist[eq2],
				M.eqcons[eq2],
				M.weights,
				a,
				b,
				c,
				value)
	return(H)
}

/*STATIC*/ real scalar mopt__eq_dim(`MoptStruct' M, real scalar eq)
{
	return(M.eqdims[2,eq]-M.eqdims[1,eq]+1)
}

end
