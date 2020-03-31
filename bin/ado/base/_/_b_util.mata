*! version 1.0.3  05feb2017
version 11

mata:

real scalar _b_linesize()
{
	return(max((79, c("linesize")))-1)
}

/* 
	p if from p = strpos(dv, ".")
*/
void _b_compute_multi_line_tsop(string	vector	op,
				string	scalar	dv,
				real	scalar	p,
				real	scalar	width)
{
	string	scalar	myop, t
	real	scalar	n, i, j

	myop = bsubstr(dv, 1, p-1)

	if (strlen(myop) < width) {
		op = myop + "."
		dv = abbrev(bsubstr(dv, p+1, .), width)
		return
	}

	n = ceil(strlen(myop)/width)
	op = J(1,n-1,"")
	j = 1
	for (i=1; i<n; i++) {
		op[i] = substr(myop, j, j+11)
		j = j + width
	}
	myop = substr(myop, j, .)
	if (strlen(myop) == 0) {
		dv = abbrev(bsubstr(dv, p+1, .), width)
	}
	else {
		t = myop + "." + bsubstr(dv, p+1, .)
		if (udstrlen(t) <= width) {
			swap(dv, t)
		}
		else {
			op = op, (myop + ".")
			dv = abbrev(bsubstr(dv, p+1, .), width)
		}
	}
}

real	scalar	_b_get_scalar(string scalar name, |real scalar dflt)
{
	real	scalar	x

	x = st_numscalar(name)
	if (length(x) == 0) {
		x = dflt
		if (strlen(st_global(name))) {
			x = strtoreal(st_global(name))
		}
	}
	return(x)
}

void _b_check_rows(string scalar name, real matrix mat, real scalar r)
{
	real	scalar	cmp

	cmp = rows(mat) - r
	if (cmp != 0) {
		errprintf("conformability error;\n")
		errprintf("matrix %s has too %s rows\n",
			name,
			(cmp > 0 ? "many" : "few"))
		exit(503)
	}
}

void _b_check_cols(string scalar name, real matrix mat, real scalar c)
{
	real	scalar	cmp

	cmp = cols(mat) - c
	if (cmp != 0) {
		errprintf("conformability error;\n")
		errprintf("matrix %s has too %s columns\n",
			name,
			(cmp > 0 ? "many" : "few"))
		exit(503)
	}
}

/* _b_eq_select()
 *
 * Input
 *	stripe		- string matrix from a Stata stripe
 *	eqlist		- vector of equations to select
 *
 * Output
 *	eq_select	- indicator for selected equations
 *	el_select	- indicator for selected elements
 */
void _b_eq_select(
	string	matrix	stripe,
	string	vector	eqlist,
	real	vector	eq_select,
	real	vector	el_select)
{
	real	matrix	eq_info
	real	scalar	neq
	real	scalar	dim
	real	scalar	eq

	real	scalar	i0
	real	scalar	i1
	real	scalar	keep
	string	scalar	cmd
	real	scalar	rc
	string	scalar	type
	string	scalar	ts_op
	string	scalar	name
	real	scalar	k

	eq_info	= panelsetup(stripe, 1)
	neq	= rows(eq_info)
	dim	= rows(stripe)

	if (cols(eqlist) == 0) {
		eq_select = J(1,neq,1)
		el_select = J(1,dim,1)
		return
	}

	eq_select = J(1,neq,0)
	el_select = J(1,dim,0)
	for (eq=1; eq<=neq; eq++) {
		i0	= eq_info[eq,1]
		i1	= eq_info[eq,2]
		keep	= anyof(eqlist, stripe[i0,1])
		if (keep == 0) {
			cmd	= sprintf("_ms_parse_parts %s", stripe[i0,1])
			rc	= _stata(cmd,1)
			type	= st_global("r(type)")
			ts_op	= st_global("r(ts_op)")
			name	= st_global("r(name)")
			keep	= rc == 0 & type == "factor" &
				  ts_op == "" & anyof(eqlist, name)
		}
		if (keep == 0) {
			keep	= anyof(eqlist, sprintf("#%f",eq))
		}
		if (keep) {
			eq_select[eq] = 1
			k = i1 - i0 + 1
			el_select[|i0\i1|] = J(1,k,1)
		}
	}
}

end
