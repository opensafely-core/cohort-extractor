*! version 1.4.0  07mar2019
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'
findfile moptimize_include.mata
quietly include `"`r(fn)'"'

mata:

void mopt__check_need_views(`MoptStruct' M, name)
{
	if (M.need_views) {
		errprintf(
		"invalid %s argument for Stata program evaluators\n", name
		)
		exit(3498)
	}
}

real matrix mopt__st_getdata(
	`MoptStruct'	M,
	string	scalar	vlist
)
{
	real	matrix	data
	pragma unset data

	if (M.view == `OPT_onoff_on') {
		st_view(data, ., vlist, M.st_touse)
	}
	else {
		data = st_data(., vlist, M.st_touse)
	}
	return(data)
}

string scalar mopt__check_varnames(
	transmorphic	varlist,
	real	scalar	nmin,
	real	scalar	nmax,
	string	scalar	name,
	|real	scalar	tsops
)
{
	real	scalar		n
	real	scalar		opsok, ec
	string	rowvector	vlist
	pragma unset tsops

	if (!isstring(varlist)) {
		errprintf("invalid %s argument\n", name)
		exit(198)
	}

	// NOTE:  The 'tsops' arg is a place holder that identifies whether TS
	// or FV operators are allowed.

	opsok	= (args() == 5)
	n	= length(varlist)
	if (! n) {
		errprintf("invalid %s argument\n", name)
		exit(198)
	}
	vlist	= strtrim(invtokens(rowshape(varlist,1)))

	if (strlen(vlist) == 0) {
		n	= 0
	}
	else {
		ec = _st_varlist(vlist, opsok, opsok)
		if (ec) exit(ec)
		vlist = _st_ivarlist(varlist)
		n	= length(vlist)
	}
	if (n < nmin | n > nmax) {
		errprintf("invalid %s argument\n", name)
		if (n < nmin) {
			exit(102)
		}
		exit(103)
	}
	if (n == 0) {
		return("")
	}

	return(invtokens(vlist))
}

string scalar mopt__tsrevar(string scalar varname)
{
	real	scalar	rc

	rc = _stata(sprintf("tsrevar %s", varname))
	if (rc) exit(rc)
	return(st_global("r(varlist)"))
}

void mopt__check_e(
	real scalar	todo,		// INPUT  : instructions
	`MoptStruct'	M,		// INPUT  : mopt__struct
	real matrix	g_e,		// INPUT  : equation-level scores
	real scalar	v,		// OUTPUT : value
	real rowvector	g		// OUTPUT : gradient
)
{
	if (todo > 0) {
		mopt_vecsum(M,g_e,v,g)
	}
}

void mopt__check_depvaridx(real scalar idx, real scalar nid)
{
	if (idx < 1 | idx > nid | missing(idx) | idx!=trunc(idx)) {
		errprintf("invalid depvar index\n")
		exit(3498)
	}
}

void mopt__check_eqnum(real scalar eq, real scalar neq)
{
	if (eq < 1 | eq > neq | missing(eq) | eq!=trunc(eq)) {
		errprintf("invalid equation number\n")
		exit(3498)
	}
}

function mopt__set_ndepvars(
	`MoptStruct' M,
	real scalar ndepvars,
	| real scalar update
)
{
	transmorphic	t
	real	scalar	n0

	if (args() == 2) {
		update = 0
	}
	if (update) {
		if (ndepvars == M.ndepvars) {
			// nothing to do
			return
		}
		n0 = min((ndepvars, M.ndepvars))
	}

	if (ndepvars) {
		mopt__check_depvaridx(ndepvars, .)
	}
	if (n0 == 0) {
		update	= 0
	}
	M.ndepvars	= ndepvars

	if (update) {
		swap(t=., M.depvars)
		M.depvars	= J(1,ndepvars,`MOPT_depvars_default')
		M.depvars[|1\n0|] = t[|1\n0|]
		swap(t="", M.st_depvars)
		M.st_depvars	= J(1,ndepvars,`MOPT_st_depvars_default')
		M.st_depvars[|1\n0|] = t[|1\n0|]
	}
	else {
		M.depvars	= J(1,ndepvars,`MOPT_depvars_default')
		M.st_depvars	= J(1,ndepvars,`MOPT_st_depvars_default')
	}

}

function mopt__set_eqsize(
	`MoptStruct' M,
	real scalar neq,
	| real scalar update
)
{
	transmorphic	t
	real	scalar	neq0

	if (args() == 2) {
		update = 0
	}
	if (update) {
		if (neq == M.neq) {
			// nothing to do
			return
		}
		neq0 = min((neq, M.neq))
	}

	mopt__check_eqnum(neq, .)
	M.neq	= neq

	if (update) {
		swap(t=., M.eqlist)
		M.eqlist	= J(1,neq,`MOPT_eqlist_default')
		M.eqlist[|1\neq0|] = t[|1\neq0|]
		swap(t=., M.st_eqlist)
		M.st_eqlist	= J(1,neq,`MOPT_st_eqlist_default')
		M.st_eqlist[|1\neq0|] = t[|1\neq0|]
	}
	else {
		M.eqlist	= J(1,neq,`MOPT_eqlist_default')
		M.st_eqlist	= J(1,neq,`MOPT_st_eqlist_default')
	}

	if (update) {
		swap(t=., M.eqcons)
		M.eqcons	= J(1,neq,`MOPT_eqcons_default')
		M.eqcons[|1\neq0|] = t[|1\neq0|]
	}
	else {
		M.eqcons	= J(1,neq,`MOPT_eqcons_default')
	}

	if (update) {
		swap(t=., M.eqnames)
		M.eqnames	= J(1,neq,`MOPT_eqnames_default')
		M.eqnames[|1\neq0|] = t[|1\neq0|]
	}
	else {
		M.eqnames	= J(1,neq,`MOPT_eqnames_default')
	}

	if (update) {
		swap(t=., M.eqcolnames)
		M.eqcolnames	= J(1,neq,`MOPT_eqcolnames_default')
		M.eqcolnames[|1\neq0|] = t[|1\neq0|]
	}
	else {
		M.eqcolnames	= J(1,neq,`MOPT_eqcolnames_default')
	}

	if (update) {
		swap(t=., M.eqcoefs)
		M.eqcoefs	= J(1,neq,`MOPT_eqcoefs_default')
		M.eqcoefs[|1\neq0|] = t[|1\neq0|]
	}
	else {
		M.eqcoefs	= J(1,neq,`MOPT_eqcoefs_default')
	}

	if (update) {
		swap(t=., M.eqbounds)
		M.eqbounds	= J(2,neq,`MOPT_eqbounds_default')
		M.eqbounds[|1,1\2,neq0|] = t[|1,1\2,neq0|]
	}
	else {
		M.eqbounds	= J(2,neq,`MOPT_eqbounds_default')
	}

	if (update) {
		swap(t=., M.eqoffset)
		M.eqoffset	= J(1,neq,`MOPT_eqoffset_default')
		M.eqoffset[|1\neq0|] = t[|1\neq0|]
		swap(t=., M.st_eqoffset)
		M.st_eqoffset	= J(1,neq,`MOPT_st_eqoffset_default')
		M.st_eqoffset[|1\neq0|] = t[|1\neq0|]
		swap(t=., M.st_eqoffset_revar)
		M.st_eqoffset_revar	= J(1,neq,`MOPT_st_eqoffset_default')
		M.st_eqoffset_revar[|1\neq0|] = t[|1\neq0|]
	}
	else {
		M.eqoffset	= J(1,neq,`MOPT_eqoffset_default')
		M.st_eqoffset	= J(1,neq,`MOPT_st_eqoffset_default')
		M.st_eqoffset_revar	= J(1,neq,`MOPT_st_eqoffset_default')
	}

	if (update) {
		swap(t=., M.eqexposure)
		M.eqexposure	= J(1,neq,`MOPT_eqexposure_default')
		M.eqexposure[|1\neq0|] = t[|1\neq0|]
	}
	else {
		M.eqexposure	= J(1,neq,`MOPT_eqexposure_default')
	}

	if (update) {
		swap(t=., M.eqfreeparm)
		M.eqfreeparm	= J(1,neq,`MOPT_eqfreeparm_default')
		M.eqfreeparm[|1\neq0|] = t[|1\neq0|]
	}
	else {
		M.eqfreeparm	= J(1,neq,`MOPT_eqfreeparm_default')
	}

}

real scalar mopt__dim(`MoptStruct' M)
{
	real scalar	i, dim

	dim = 0
	for (i=1; i<=M.neq; i++) {
		if (M.eqlist[i] != NULL) {
			dim = dim + cols(*M.eqlist[i]) + M.eqcons[i]
		}
		else	dim = dim + M.eqcons[i]
	}
	return(dim)
}

real scalar mopt__eqdim(`MoptStruct' M, real scalar eq)
{
	real	scalar	dim

	if (eq > M.neq) {
		return(0)
	}
	dim	= M.eqcons[eq] != 0
	if (M.eqlist[eq] != NULL) {
		dim = dim + cols(*M.eqlist[eq])
	}
	return(dim)
}

void mopt__build_eqdims(`MoptStruct' M)
{
	real	scalar	i, ibegin, iend

	if (M.neq < 1) {
		errprintf("no model equations specified\n")
		exit(3498)
	}
	M.eqdims = J(2,M.neq,0)
	ibegin = iend = 0
	for (i=1; i<=M.neq; i++) {
		ibegin	= iend + 1
		iend	= iend + mopt__eqdim(M,i)
		M.eqdims[1,i] = ibegin
		M.eqdims[2,i] = iend
	}
	if (cols(M.eqdelta) < iend) {
		M.eqdelta = J(1,iend,0)
	}
}

`Errcode' mopt__eval(`OptStruct' S, real scalar todo)
{
	return( opt__eval(S,todo,0) )
}

`Errcode' mopt__feasible(`MoptStruct' M)
{
	`Errcode'	ec

	displayas("txt")
	if (M.S.trace > `OPT_tracelvl_tol') {
		printf("searching for feasible values ")
	}

	if (M.search_random == `OPT_onoff_off') {
		ec = mopt__trycons(M)
		if (ec) return(ec)
	}

	if (missing(M.S.value)) {
		ec = mopt__random(M, 0, M.search_feasible)
		if (ec) return(ec)
	}
	if (M.S.trace > `OPT_tracelvl_tol') {
		printf("\n")
		displayflush()
	}
	if (missing(M.S.value)) {
		M.S.errorcode = `Errcode_search_feasible'
		M.S.errortext = `Errtext_search_feasible'
		opt__errorhandler(M.S)
		return(M.S.errorcode)
	}
	return(0)
}

`Errcode' mopt__random(	
	`MoptStruct' M,
	real scalar best,
	real scalar attempts)
{
	`Errcode'	ec
	real scalar	i, ir, eq
	real scalar	cons
	real scalar	v0
	real rowvector	p0
	real rowvector	range
	real scalar	nrange
	     scalar	trace

	range	= 1, 5, 10, 25, 100, 1000
	nrange	= cols(range)

	// for 'best != 0' search for the best parameter values among all
	// possible attempts; otherwise, exit the first time we find feasible
	// parameter values

	if (best) {
		v0	= M.S.value
		p0	= M.S.params
	}

	displayas("txt")
	trace	 = M.S.trace

	ir = 1
	for (i=1; i<=attempts; i++) {
		for (eq=1; eq<=M.neq; eq++) {
			if (missing(M.eqbounds[,eq])) {
				cons = (2*uniform(1,1)+1)*range[ir]
			}
			else {
				cons = M.eqbounds[1,eq] +
					uniform(1,1) * 
					(M.eqbounds[2,eq] -
						M.eqbounds[1,eq])
			}
			mopt__set_eqcons(M, eq, cons)
		}
		M.S.dot_type = "text"
		ec = mopt__eval(M.S,0)
		if (ec) return(ec)
		if (!missing(M.S.value)) {
			if (!best) {
				if (trace > `OPT_tracelvl_tol') {
					printf("{res:+}\n")
					displayflush()
				}
				return(0)
			}
			else if (M.S.value > v0) {
				if (trace > `OPT_tracelvl_tol') {
					printf("{res:+}")
					displayflush()
				}
				v0 = M.S.value
				p0 = M.S.params
			}
			else if (trace > `OPT_tracelvl_tol') {
				printf("{txt:.}")
				displayflush()
			}
		}
		else if (trace > `OPT_tracelvl_tol') {
			printf("{txt:.}")
			displayflush()
		}

		ir++
		if (ir > nrange) ir = 1
	}
	if (trace > `OPT_tracelvl_tol') {
		printf("\n")
		displayflush()
	}

	if (best) {
		M.S.value	= v0
		M.S.params	= p0
	}
	return(0)
}

`Errcode' mopt__rescale_eq(
	`MoptStruct' M,
	real scalar eq,
	real scalar rescaled
)
{
	`Errcode'		ec
	real	scalar		v0, size
	real	rowvector	p0, eqp0
	real	scalar		i0, i1
		scalar		trace
	pointer	scalar		eqoffset

	trace	= M.S.trace
	i0	= M.eqdims[1,eq]
	i1	= M.eqdims[2,eq]

	p0	= M.S.params
	v0	= M.S.value

	eqp0	= M.S.params[|i0 \ i1|]
	eqp0	= 0.5 * eqp0

	M.S.params[|i0 \ i1|] = eqp0
	M.S.dot_type = "text"
	ec = mopt__eval(M.S,0)
	if (ec) return(ec)
	if (!missing(M.S.value) & M.S.value > v0
	    & reldif(M.S.value,v0) > 1e-12) {
		while (!missing(M.S.value) & M.S.value > v0
		    & reldif(M.S.value,v0) > 1e-12) {
			if (trace > `OPT_tracelvl_tol') {
				printf("{res:+}")
				displayflush()
			}
			p0	= M.S.params
			v0	= M.S.value
			eqp0	= 0.5 * eqp0
			M.S.params[|i0 \ i1|] = eqp0
			M.S.dot_type = "text"
			ec = mopt__eval(M.S,0)
			if (ec) return(ec)
		}
		eqp0 = 2 * eqp0
		M.S.params[|i0 \ i1|] = eqp0
		eqoffset = M.eqoffset[eq]
		M.eqoffset[eq] = NULL
		size = mean(moptimize_util_xb(M, p0, eq))
		M.eqoffset[eq] = eqoffset
		if (abs(size) < 1e-8) {
			if (trace > `OPT_tracelvl_tol') {
				printf(".\nsign reverse {res:+}")
				displayflush()
			}
			eqp0	= -4 * eqp0
			M.S.params[|i0 \ i1|] = eqp0
			M.S.dot_type = "text"
			ec = mopt__eval(M.S,0)
			if (ec) return(ec)
			while (!missing(M.S.value) & M.S.value > v0
			    & reldif(M.S.value,v0) > 1e-12) {
				if (trace > `OPT_tracelvl_tol') {
					printf("{res:+}")
					displayflush()
				}
				p0	= M.S.params
				v0	= M.S.value
				eqp0	= 2 * eqp0
				M.S.params[|i0 \ i1|] = eqp0
				M.S.dot_type = "text"
				ec = mopt__eval(M.S,0)
				if (ec) return(ec)
			}
		}
		rescaled	= 1
	}
	else {
		if (trace > `OPT_tracelvl_tol') {
			printf("{txt:.}")
			displayflush()
		}
		M.S.value = .
		eqp0 = 4 * eqp0
		M.S.params[|i0 \ i1|] = eqp0
		M.S.dot_type = "text"
		ec = mopt__eval(M.S,0)
		if (ec) return(ec)
		while (!missing(M.S.value) & M.S.value > v0) {
			if (trace > `OPT_tracelvl_tol') {
				printf("{res:+}")
				displayflush()
			}
			p0	= M.S.params
			v0	= M.S.value
			eqp0	= 2 * eqp0
			M.S.params[|i0 \ i1|] = eqp0
			M.S.dot_type = "text"
			ec = mopt__eval(M.S,0)
			if (ec) return(ec)
			rescaled	= 1
		}
	}
	if (trace > `OPT_tracelvl_tol') {
		printf("{txt:.}")
		displayflush()
	}
	M.S.value	= v0
	M.S.params	= p0
	return(0)
}

`Errcode' mopt__rescale_eqns(
	`MoptStruct' M,
	real scalar	rescaled)
{
	`Errcode'	ec
	real scalar	eq

	rescaled = 0
	displayas("txt")
	if (M.S.trace > `OPT_tracelvl_tol') {
		printf("rescaling equations ")
		displayflush()
	}
	for (eq=1; eq<=M.neq; eq++) {
		ec = mopt__rescale_eq(M, eq, rescaled)
		if (ec) return(ec)
	}
	if (M.S.trace > `OPT_tracelvl_tol') {
		printf("\n")
		displayflush()
	}
	return(0)
}

`Errcode' mopt__rescale(`MoptStruct' M)
{
	`Errcode'	ec
	real scalar	v0
	real rowvector	p0
	real scalar	len
	     scalar	trace

	v0	= M.S.value
	p0	= M.S.params
	trace	= M.S.trace

	displayas("txt")

	len = p0 * p0 '
	if (len == 0) {
		if (trace > `OPT_tracelvl_tol') {
			printf("trying nonzero initial values ")
			displayflush()
		}
		M.S.value = .
		ec = mopt__trycons(M)
		if (ec) return(ec)
		if (M.S.trace > `OPT_tracelvl_tol') {
			printf("\n")
			displayflush()
		}
		if (missing(M.S.value)) {
			M.S.value	= v0
			M.S.params	= p0
			if (trace > `OPT_tracelvl_none') {
				printf("final:{col 16}%s = {res:%10.8g}\n",
					M.S.value_id,
					(M.S.minimize ?
						-M.S.value : M.S.value))
				displayflush()
			}
			M.search_rescale = `OPT_onoff_off'
			return(0)
		}
		if (trace > `OPT_tracelvl_none') {
			printf("alternative:{col 16}%s = {res:%10.8g}\n",
				M.S.value_id,
				(M.S.minimize ?
					-M.S.value : M.S.value))
		}
		v0 = M.S.value
		p0 = M.S.params
	}
	if (M.S.trace > `OPT_tracelvl_tol') {
		printf("rescaling entire vector ")
		displayflush()
	}
	M.S.params = 0.5 * p0
	M.S.dot_type = "text"
	ec = mopt__eval(M.S,0)
	if (ec) return(ec)
	if (!missing(M.S.value) & M.S.value > v0) {
		while (!missing(M.S.value) & M.S.value > v0) {
			if (trace > `OPT_tracelvl_tol') {
				printf("{res:+}")
				displayflush()
			}
			v0	= M.S.value
			p0	= M.S.params
			M.S.params = 0.5 * p0
			M.S.dot_type = "text"
			ec = mopt__eval(M.S,0)
			if (ec) return(ec)
		}
	}
	else {
		if (trace > `OPT_tracelvl_tol') {
			printf("{txt:.}")
			displayflush()
		}
		M.S.value = .
		M.S.params = 2 * p0
		M.S.dot_type = "text"
		ec = mopt__eval(M.S,0)
		if (ec) return(ec)
		while (!missing(M.S.value) & M.S.value > v0) {
			if (trace > `OPT_tracelvl_tol') {
				printf("{res:+}")
				displayflush()
			}
			v0	= M.S.value
			p0	= M.S.params
			M.S.params = 2 * p0
			M.S.dot_type = "text"
			ec = mopt__eval(M.S,0)
			if (ec) return(ec)
		}
	}
	if (trace > `OPT_tracelvl_tol') {
		printf("{txt:.}\n")
		displayflush()
	}
	M.S.value	= v0
	M.S.params	= p0
	return(0)
}

`Errcode' mopt__search(`MoptStruct' M)
{
	`Errcode'	ec
	real scalar	rescaled
	     scalar	trace

	if (M.S.maxiter < 1) return(0)

	trace	 = M.S.trace
	if (missing(M.S.value) & trace == `OPT_tracelvl_none') {
		if (M.search_quietly == `OPT_onoff_off') {
			trace = `OPT_tracelvl_value'
		}
	}
	if (trace > `OPT_tracelvl_none') {
		if (missing(M.S.value)) {
			displayas("txt")
			printf("initial:{col 16}%s = {res:%10s}%s\n",
				M.S.value_id,
				(M.S.minimize ? "<inf>" : "-<inf>"),
				"  (could not be evaluated)")
		}
		else {
			displayas("txt")
			printf("initial:{col 16}%s = {res:%10.8g}\n",
				M.S.value_id,
				(M.S.minimize ?
					-M.S.value : M.S.value))
		}
		displayflush()
	}
	if (missing(M.S.value)) {
		ec = mopt__feasible(M)
		if (ec) return(ec)
		if (trace > `OPT_tracelvl_none') {
			displayas("txt")
			printf("feasible:{col 16}%s = {res:%10.8g}\n",
				M.S.value_id,
				(M.S.minimize ?
					-M.S.value : M.S.value))
			displayflush()
		}
	}
	if (M.search_random == `OPT_onoff_on' |
			M.search_repeat != `MOPT_repeat_default') {
		if (M.search_repeat > 0) {
			if (trace > `OPT_tracelvl_tol') {
				printf("improving initial values ")
			}
			ec = mopt__random(M, 1, M.search_repeat)
			if (ec) return(ec)
			if (trace > `OPT_tracelvl_none') {
				displayas("txt")
				printf("improve:{col 16}%s = {res:%10.8g}\n",
					M.S.value_id,
					(M.S.minimize ?
						-M.S.value : M.S.value))
				displayflush()
			}
		}
	}
	if (M.search_rescale == `OPT_onoff_on') {
		ec = mopt__rescale(M)
		if (ec) return(ec)
		if (trace > `OPT_tracelvl_none') {
			displayas("txt")
			printf("rescale:{col 16}%s = {res:%10.8g}\n",
				M.S.value_id,
				(M.S.minimize ?
					-M.S.value : M.S.value))
			displayflush()
		}
	}
	if (M.search_rescale == `OPT_onoff_on' & M.neq > 1) {
		rescaled = 0
		ec = mopt__rescale_eqns(M, rescaled)
		if (ec) return(ec)
		if (rescaled) {
			ec = mopt__rescale_eqns(M, rescaled)
			if (ec) return(ec)
		}
		if (trace > `OPT_tracelvl_none') {
			displayas("txt")
			printf("rescale eq:{col 16}%s = {res:%10.8g}\n",
				M.S.value_id,
				(M.S.minimize ?
					-M.S.value : M.S.value))
			displayflush()
		}
	}

	// reset the starting values
	M.S.v0 = M.S.value
	moptimize_reset_p0(M)
	return(0)
}

function mopt__set_allcons(
	`MoptStruct' M,
	real scalar constant)
{
	real scalar	i, neq

	neq	= M.neq
	for (i=1; i<=neq; i++) {
		mopt__set_eqcons(M, i, constant)
	}
}

function mopt__set_eqcons(
	`MoptStruct' M,
	real scalar eq,
	real scalar constant)
{
	real scalar	i, j
	real matrix	XpX, XpC

	if (M.eqcons[eq]) {
		i = M.eqdims[2,eq]
		M.S.params[i] = constant
	}
	else {
		XpX = cross(*M.eqlist[eq], *M.eqlist[eq])
		XpC = cross(constant, *M.eqlist[eq])'
		(void) _qrsolve(XpX,XpC)
		i = M.eqdims[1,eq]
		j = M.eqdims[2,eq]
		M.S.params[|i\j|] = XpC'
	}
}

`Errcode' mopt__trycons(`MoptStruct' M)
{
	`Errcode'	ec
	real scalar	i, ngrid
	real rowvector	grid
	real scalar	v0
	real rowvector	p0
	     scalar	trace

	if (!missing(M.S.value)) {
		return(0)
	}

	grid	= .5, 1.25, 2.5, 10
	ngrid	= cols(grid)

	v0	= M.S.value
	p0	= M.S.params
	trace	= M.S.trace

	// look for feasible starting values on this simple grid first
	for (i=1; i<=ngrid; i++) {
		mopt__set_allcons(M, -grid[i])
		M.S.dot_type = "text"
		ec = mopt__eval(M.S,0)
		if (ec) return(ec)
		if (!missing(M.S.value)) {
			if (trace > `OPT_tracelvl_tol') {
				printf("{res:+}")
				displayflush()
			}
			v0	= M.S.value
			p0	= M.S.params
		}
		else if (trace > `OPT_tracelvl_tol') {
			printf("{txt:.}")
			displayflush()
		}
		mopt__set_allcons(M, grid[i])
		M.S.dot_type = "text"
		ec = mopt__eval(M.S,0)
		if (ec) return(ec)
		if (!missing(M.S.value)
		 &  (M.S.value > v0 | missing(v0))) {
			if (trace > `OPT_tracelvl_tol') {
				printf("{res:+}")
				displayflush()
			}
			v0	= M.S.value
			p0	= M.S.params
		}
		else if (trace > `OPT_tracelvl_tol') {
			printf("{txt:.}")
			displayflush()
		}
		if (!missing(M.S.value)) break
	}
	if (!missing(v0)) {
		M.S.value	= v0
		M.S.params	= p0
	}
	return(0)
}

/*STATIC*/ void mopt__build_colstripe(`MoptStruct' M)
{
	real scalar	dim, i, j, k
	string	vector	names
	string	matrix	colstripe
	real	scalar	pos

	// build the matrix column stripes for the Stata parameter vector
	colstripe = J(M.eqdims[2,M.neq], 2, "")
	k	= 1
	for (i=1; i<=M.neq; i++) {
		names	= moptimize_init_eq_colnames(M,i)
		dim	= cols(names)
		if (M.eqfreeparm[i]) {
		}
		if (!strlen(M.eqnames[i])) {
			M.eqnames[i] = sprintf("eq%f", i)
		}
		for (j=1; j<=dim; j++) {
			if (M.eqfreeparm[i]) {
				if (names[j] != "_cons") {
					M.S.errorcode = `Errcode_freeparm'
					M.S.errortext = `Errtext_freeparm'
					opt__errorhandler(M.S)
					return(M.S.errorcode)
				}
				colstripe[k,1] = "/"
				pos = strpos(M.eqnames[i], ":")
				if (pos) {
					colstripe[k,1] = sprintf("/%s", substr(M.eqnames[i], 1, pos-1))
					colstripe[k,2] = substr(M.eqnames[i], pos+1, .)
				}
				else {
					colstripe[k,2] = M.eqnames[i]
				}
			}
			else {
				colstripe[k,1] = M.eqnames[i]
				colstripe[k,2] = names[j]
			}
			k++
		}
	}
	optimize_init_colstripe(M.S, colstripe)
}

/*STATIC*/ real rowvector mopt__build_b0(`MoptStruct' M)
{
	real	scalar		neq, dim, i, c1, c2
	real	rowvector	b0

	neq	= M.neq
	mopt__build_eqdims(M)
	dim	= M.eqdims[2,neq]
	b0	= J(1,dim,0)
	for (i=1; i<=neq; i++) {
		if (M.eqcoefs[i] != NULL) {
			c1	= M.eqdims[1,i]
			c2	= M.eqdims[2,i]
			b0[|c1\c2|] = *M.eqcoefs[i]
		}
	}
	_editmissing(b0, 0)
	return(b0)
}

`Errcode' mopt__validate(`MoptStruct' M)
{
	`Errcode'	ec
	real	scalar	i
	real	scalar	nobs
	real	scalar	ucall

	if (M.st_sample == "") {
		M.st_sample = M.st_touse
	}

	// initialize Stata specific entities
	ec = mopt__st_validate(M)
	if (ec) {
		return(ec)
	}

	if (M.valid) {
		mopt__st_post_extra(M)
		// Nothing has changed since the last call to this function.
		return(0)
	}

	mopt__build_colstripe(M)
	optimize_init_params(M.S, mopt__build_b0(M))

	ucall		= M.S.ucall
	M.S.ucall	= 1
	mopt__link(M)
	M.S.oerrorcode = opt__validate(M.S, 1)
	mopt__unlink(M)
	M.S.ucall	= ucall
	if (M.S.oerrorcode) {
		if (! ucall) {
			exit(optimize_result_returncode(M.S))
		}
		return(M.S.oerrorcode)
	}
	M.wtype		= opt__wtype_num(M.S)
	M.weights	= &opt__weight(M.S)

	if (M.uvcetype == `MOPT_vcetype_none') {
		// determine the default vce
		if (M.vce == `MOPT_vcetype_none') {
			if (moptimize_init_weighttype(M) == "pweight") {
				M.vce	= `MOPT_vcetype_robust'
			}
			else if (moptimize_init_technique(M) == "bhhh") {
				M.vce	= `MOPT_vcetype_opg'
			}
		}
	}

	if (M.wtype != `OPT_wtype_none') {
		nobs = rows(*M.weights)
		if (M.by != NULL) {
			ec = mopt__check_by_weight(M)
			if (ec) return(ec)
		}
		goto gotnobs
	}
	if (M.ndepvars) {
		for (i=1; i<=M.ndepvars; i++) {
			if (M.depvars[i] != NULL) {
				nobs = rows(*M.depvars[i])
				goto gotnobs
			}
		}
	}
	for (i=1; i<=M.neq; i++) {
		if (M.eqlist[i] != NULL) {
			nobs = rows(*M.eqlist[i])
			goto gotnobs
		}
		if (M.eqoffset[i] != NULL) {
			nobs = rows(*M.eqoffset[i])
			goto gotnobs
		}
	}
	nobs	= 1
gotnobs:
	if (M.obs == `MOPT_obs_default') {
		if (M.wtype == `OPT_wtype_f') {
			M.obs = sum(*M.weights)
		}
		else {
			M.obs = nobs
		}
	}
	if (!strlen(M.st_user) & M.S.evaltype_f == "lf") {
		M.xb	= J(nobs,M.neq,.)
	}

	// We're settings 'h' and 'scale' here instead of before calling
	// 'opt__validate()' because we only want to accept them if they are
	// of the correct dimension.
	if (cols(M.scale) == M.S.dim & !missing(M.scale)) {
		optimize_init_deriv_scale(M.S, M.scale)
		if (cols(M.h) == M.S.dim & !missing(M.h)) {
			optimize_init_deriv_h(M.S, M.h)
			optimize_init_deriv_search(M.S, "off")
		}
		if (M.S.evaltype != `OPT_evaltype_lf' &
		    M.S.evaltype != `OPT_evaltype_q') {
			deriv_init_weak_goals(M.S.D, !M.S.userscale)
		}
	}

	if (any(M.S.evaltype_f :== tokens("e1 lf1"))) {
		M.rescore = `OPT_onoff_on'
	}

	if (M.S.evaltype_f == "lf") {
		if (moptimize_init_technique(M) != "nm") {
			M.hold_xb = `OPT_onoff_on'
		}
	}
	mopt__st_post_extra(M)

	M.eqdelta = J(1,M.neq,0)
	M.valid	= `OPT_onoff_on'

	return(0)
}

function mopt__wtype(`MoptStruct' M, |scalar wtype)
{
	if (args() == 1) {
		return(opt__wtype_str(M.S))
	}
	opt__wtype(M.S, wtype)
}

function mopt__wtype_num(`MoptStruct' M, |real scalar wtype)
{
	if (args() == 1) {
		return(opt__wtype_num(M.S))
	}
	opt__wtype_num(M.S, wtype)
}

function mopt__wtype_str(`MoptStruct' M, |string scalar wtype)
{
	if (args() == 1) {
		return(opt__wtype_str(M.S))
	}
	opt__wtype_str(M.S, wtype)
}

/*STATIC*/ `Errcode' mopt__check_by_weight(`MoptStruct' M)
{
	real	matrix	info
	real	scalar	k
	real	scalar	i
	real	vector	w
	real	matrix	sub

	info = panelsetup((*M.by), 1)
	k = rows(info)
	if (k == rows(M.S.weights)) {
		return(0)
	}
	w = J(k,1,.)
	for (i=1; i<=k; i++) {
		sub = panelsubmatrix(M.S.weights, i, info)
		if (any(sub[1] :!= sub)) {
			M.S.errorcode = `Errcode_by_weights'
			M.S.errortext = `Errtext_by_weights'
			opt__errorhandler(M.S)
			return(M.S.errorcode)
		}
		w[i] = sub[1]
	}
	M.S.by_weights	= w
	M.by_weights	= &(M.S.by_weights)
	deriv_init_weights(M.S.D, M.S.by_weights)
	return(0)
}

real matrix mopt__opg_e(`MoptStruct' M)
{
	real	scalar	i
	real	scalar	neq
	real	vector	sel
	real	matrix	scores
		scalar	R

	neq = M.neq
	R = robust_init()
	if (rows(M.S.weights) > 1) {
		robust_init_weight(R, M.S.weights)
		robust_init_weighttype(R, moptimize_init_weighttype(M))
	}
	robust_init_eq_n(R, neq)
	for (i=1; i<=neq; i++) {
		if (M.eqlist[i] != NULL) {
			robust_init_eq_indepvars(R,i,(*M.eqlist[i]))
		}
		robust_init_eq_cons(R,i,M.eqcons[i])
	}
	if (isview(M.S.gradient_v)) {
		robust_init_touse(R, M.st_touse)
		robust_init_scores(R, invtokens(M.st_scores))
	}
	else {
		if (M.st_touse != M.st_sample) {
			sel = st_data(., M.st_touse, M.st_sample)
			scores = J(rows(sel), cols(M.S.gradient_v), 0)
			scores[selectindex(sel),] = M.S.gradient_v
			robust_init_scores(R, scores)
		}
		else {
			robust_init_scores(R, M.S.gradient_v)
		}
	}
	robust_init_minus(R,0)
	return(robust(R))
}

void opt__lf_h(
	real rowvector	p,
	real scalar	i,
	`OptStruct'	S,
	real scalar	h
)
{
	mopt__lf_h(p,i,(*S.arglist[1]),h)
}

void mopt__lf_h(
	real rowvector	p,
	real scalar	i,
	`MoptStruct'	M,
	real scalar	h
)
{
	real colvector	xb

	h  = 1e-4
	xb = _mopt_xb(	M.eqlist[i],
			M.eqcons[i],
			p,
			M.eqdims[1,i],
			M.eqdims[2,i],
			M.eqoffset[i],
			M.eqexposure[i],
			0
		)
	if (rows(xb) == 1) {
		h = (abs(xb)+h)*h
	}
	else {
		if (M.wtype == `OPT_wtype_none') {
			h = (abs(mean(xb))+h)*h
		}
		else {
			h = (abs(mean(xb, *M.weights))+h)*h
		}
	}
}

real scalar opt__lf_neq(
	real rowvector	p,
	`OptStruct'	S
)
{
	pragma unset p
	return(moptimize_init_eq_n(*S.arglist[1]))
}

void opt__lf_vecsum(
	real scalar	i,
	real colvector	score,
	`OptStruct'	S,
	real rowvector	g
)
{
	real rowvector	gi
	pragma unset gi
	gi = moptimize_util_vecsum((*S.arglist[1]), i, score, S.value, 1)
	g[|moptimize_util_eq_indices((*S.arglist[1]), i)|] = gi
}

void opt__lf_matsum(
	real scalar	i,
	real scalar	j,
	real colvector	score,
	`OptStruct'	S,
	real matrix	H
)
{
	real matrix Hij
	pragma unset Hij
	Hij = moptimize_util_matsum((*S.arglist[1]), i, j, score, S.value, 1)
	H[|moptimize_util_eq_indices((*S.arglist[1]), i, j)|] = Hij
	if (i != j) {
		H[|moptimize_util_eq_indices((*S.arglist[1]), j, i)|] = Hij'
	}
}

void opt__lf_setdelta(
	real	scalar		i,
	real	scalar		h,
	`OptStruct'		S,
	real	rowvector	p_alt
)
{
	pragma unset p_alt
	mopt__lf_setdelta((*S.arglist[1]), i, h)
}

void opt__lf2_setdelta(
	real	scalar		i,
	real	scalar		h,
	`OptStruct'		S,
	real	rowvector	p_alt
)
{
	pragma unset p_alt
	mopt__lf2_setdelta((*S.arglist[1]), i, h)
}

`Errcode' opt__eval_bfgs_lf0(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)

	return(opt__bfgs(S))
}

`Errcode' opt__eval_bfgs_lf1(`OptStruct' S, real scalar todo)
{
	real matrix	H0			// ignored
	pragma unset H0

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.value,S.gradient,H0,S.value_v,S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (todo != 2 | missing(S.value)) return(0)

	return(opt__bfgs(S))
}

`Errcode' opt__eval_bfgs_lf2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_bfgs_lf1(S,todo))
}

`Errcode' opt__eval_bfgs_lf(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec

	mopt__build_xb((*S.arglist[1]), S.params)
	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)

	return(opt__bfgs(S))
}

`Errcode' opt__eval_bfgs_e1(`OptStruct' S, real scalar todo)
{
	real matrix	H0			// ignored
	pragma unset H0

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.value,S.gradient,H0,S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (todo != 2 | missing(S.value)) return(0)

	return(opt__bfgs(S))
}

`Errcode' opt__eval_bfgs_e2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_bfgs_e1(S, todo))
}

`Errcode' opt__eval_bhhh_lf0(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)

	S.H = -mopt__opg_e((*S.arglist[1]))
	return(0)
}

`Errcode' opt__eval_bhhh_lf1(`OptStruct' S, real scalar todo)
{
	real scalar	dim
	real matrix	H0			// ignored
	pragma unset H0

	dim	= S.dim
	H0	= J(dim,dim,.)

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,
		S.value,S.gradient,H0,
		S.value_v,S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (todo != 2 | missing(S.value)) return(0)

	S.H = -mopt__opg_e((*S.arglist[1]))
	return(0)
}

`Errcode' opt__eval_bhhh_lf2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_bhhh_lf1(S,todo))
}

`Errcode' opt__eval_bhhh_lf(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec

	mopt__build_xb((*S.arglist[1]), S.params)
	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)

	S.H = -mopt__opg_e((*S.arglist[1]))
	return(0)
}

`Errcode' opt__eval_bhhh_e1(`OptStruct' S, real scalar todo)
{
	real scalar	dim
	real matrix	H0			// ignored
	pragma unset H0

	dim	= S.dim
	H0	= J(dim,dim,.)

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,
		S.value,S.gradient,H0,
		S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (todo != 2 | missing(S.value)) return(0)

	S.H = -mopt__opg_e((*S.arglist[1]))
	return(0)
}

`Errcode' opt__eval_bhhh_e2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_bhhh_e1(S, todo))
}

`Errcode' opt__eval_dfp_lf0(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)

	return(opt__dfp(S))
}

`Errcode' opt__eval_dfp_lf1(`OptStruct' S, real scalar todo)
{
	real matrix	H0			// ignored
	pragma unset H0

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.value,S.gradient,H0,S.value_v,S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (todo != 2 | missing(S.value)) return(0)

	return(opt__dfp(S))
}

`Errcode' opt__eval_dfp_lf2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_dfp_lf1(S,todo))
}

`Errcode' opt__eval_dfp_lf(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec

	mopt__build_xb((*S.arglist[1]), S.params)
	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)

	return(opt__dfp(S))
}

`Errcode' opt__eval_dfp_e1(`OptStruct' S, real scalar todo)
{
	real matrix	H0			// ignored
	pragma unset H0

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.value,S.gradient,H0,S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (todo != 2 | missing(S.value)) return(0)

	return(opt__dfp(S))
}

`Errcode' opt__eval_dfp_e2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_dfp_e1(S, todo))
}

`Errcode' opt__eval_nm_lf0(`OptStruct' S, real scalar todo)
{
	pragma unset todo
	(*S.calluser)(
		S.user,
		S.arglist,
		S.minimize,
		0,
		S.params,
		S.value,
		S.gradient,
		S.H,
		S.value_v,
		S.gradient_v
	)
	opt__cnt_eval(S,0,0)
	return(0)
}

`Errcode' opt__eval_nm_lf1(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nm_lf0(S,todo))
}

`Errcode' opt__eval_nm_lf2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nm_lf0(S,todo))
}

`Errcode' opt__eval_nm_lf(`OptStruct' S, real scalar todo)
{
	mopt__build_xb((*S.arglist[1]), S.params)
	pragma unset todo
	(*S.calluser)(
		S.user,
		S.arglist,
		S.minimize,
		0,
		S.params,
		S.value,
		S.gradient,
		S.H,
		S.value_v,
		S.gradient_v
	)
	opt__cnt_eval(S,0,0)
	return(0)
}

`Errcode' opt__eval_nr_lf0(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 2)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
 	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)
	_deriv_result_Hessian(S.D, S.H)

	return(0)
}

`Errcode' opt__eval_nr_lf1debug(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nr_lf2debug(S, todo))
}

`Errcode' opt__eval_nr_lf1(`OptStruct' S, real scalar todo)
{
	real scalar	dim, eps, h, i, j
	real rowvector	p_alt, ui, gp, gm
	real matrix	gp_v, gm_v
	real scalar	doCns
	real scalar	dimCns
	pointer(struct mopt__struct) scalar pM
	real scalar	neq
	real scalar	v0			// ignored
	real colvector	v_v0			// ignored
	real matrix	H0			// ignored
	real scalar	mytodo
	pragma unset v0
	pragma unset v_v0
	pragma unset H0
	pragma unset gp_v
	pragma unset gm_v

	doCns = 0
	if (S.hasCns) {
		doCns	= cols(S.params)==cols(S.T)
		if (doCns) {
			opt__cns_off(S, todo>0)
		}
	}
	dim	= S.dim
	H0	= J(dim,dim,.)

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,
		S.value,S.gradient,H0,
		S.value_v, S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (doCns) {
		opt__cns_on(S, todo>0)
	}
	if (todo != 2 | missing(S.value)) return(0)

	S.dot_type = "input"
	eps	= 1e-4

	pM	= S.arglist[1]
	if (strlen(pM->st_user)) {
		mytodo = todo
	}
	else {
		mytodo = 1
	}

	// NOTE: pass mytodo==2 to ensure using 'view's with ado-file
	// evaluators does not get in the way of taking second
	// derivatives.

	if (doCns) {
		dimCns	= cols(S.params)
		S.H	= J(dimCns,dimCns,.)
		gp	= J(1,dim,.)
		gm	= J(1,dim,.)
		ui	= J(1,dimCns,0)
		for (i=1; i<=dimCns; i++) {
			h	= (abs(S.params[i]) + eps)*eps
			ui[i]	= h
	
			p_alt	= (S.params + ui)*S.T' + S.a
			(*S.calluser)(S.user,S.arglist,S.minimize,
				mytodo,p_alt,
				v0,gp,H0,v_v0,gp_v)
			opt__cnt_eval(S,1,v0)
	
			p_alt	= (S.params - ui)*S.T' + S.a
			(*S.calluser)(S.user,S.arglist,S.minimize,
				mytodo,p_alt,
				v0,gm,H0,v_v0,gm_v)
			opt__cnt_eval(S,1,v0)
			S.H[i,] = ((gp - gm)*S.T)/(2*h)
	
			ui[i]	= 0
		}
		S.H = (S.H + S.H')/2
	}
	else {
		neq	= pM->neq
		S.H	= J(dim,dim,0)
		gp	= J(1,dim,.)
		gm	= J(1,dim,.)
		for (i=1; i<=neq; i++) {
			mopt__lf_h(S.params,i,(*pM),h)
			pM->eqdelta[i] = h
			(*S.calluser)(S.user,S.arglist,S.minimize,
				mytodo,S.params,
				v0,gp,H0,v_v0,gp_v)
			opt__cnt_eval(S,1,v0)
	
			pM->eqdelta[i] = -h
			(*S.calluser)(S.user,S.arglist,S.minimize,
				mytodo,S.params,
				v0,gm,H0,v_v0,gm_v)
			opt__cnt_eval(S,1,v0)
			pM->eqdelta[i] = 0
			gp_v = (gp_v - gm_v)/(2*h)
			for (j=i; j<=neq; j++) {
			    S.H[|moptimize_util_eq_indices((*pM),j,i)|] =
				moptimize_util_matsum((*pM),j,i,gp_v[,j],v0)
			}
		}
		if (neq > 1 ) {
			_makesymmetric(S.H)
		}
	}
	return(0)
}

`Errcode' opt__eval_nr_lf2debug(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec

	// call lf0 method, and exit if no derivatives were requested
	ec = opt__eval_nr_lf0(S, todo)
	if (ec) return(ec)
	if (todo == 0) return(0)

	real scalar	dim
	real scalar	v
	real scalar	v_v
	real rowvector	p, g
	real matrix	g_e
	real matrix	H
	pragma unset v
	pragma unset v_v
	pragma unset g_e

	dim	= S.dim
	p	= S.params
	g	= J(1,dim,.)
	H	= J(dim,dim,.)
	// call user to compute some derivatives to compare with d0
	if (S.evaltype_s == "lf2debug") {
		(*S.calluser)(S.user,S.arglist,S.minimize,
			todo,p,
			v,g,H,v_v,g_e)
		if (S.negH & todo == 2) {
			_negate(H)
		}
		opt__cnt_eval(S,todo,v)
	}
	else {
		(*S.calluser)(S.user,S.arglist,S.minimize,
			todo>0,p,
			v,g,H,v_v,g_e)
		opt__cnt_eval(S,todo>0,v)
	}

	opt__eval_nr_debug_report(S,todo,p,v,g,H)
	return(0)
}

`Errcode' opt__eval_nr_lf2(`OptStruct' S, real scalar todo)
{
	(*S.calluser)(
		S.user,
		S.arglist,
		S.minimize,
		todo,
		S.params,
		S.value,
		S.gradient,
		S.H,
		S.value_v,
		S.gradient_v
	)
	if (S.negH & todo == 2) {
		_negate(S.H)
	}
	opt__cnt_eval(S,todo,S.value)
	return(0)
}

`Errcode' opt__eval_nr_lf(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec

	mopt__build_xb((*S.arglist[1]), S.params)
	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 2)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		return(ec)
 	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)
	_deriv_result_Hessian(S.D, S.H)

	return(0)
}

`Errcode' opt__eval_nr_e1debug(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nr_e2debug(S, todo))
}

real scalar mopt__set_holdCns(`MoptStruct' M)
{
	return(cols(M.S.T) < M.neq)
}

`Errcode' opt__eval_nr_e1(`OptStruct' S, real scalar todo)
{
	real scalar	dim, eps, h, i, j
	real rowvector	p_alt, ui, gp, gm
	real matrix	gp_v, gm_v
	real scalar	doCns
	real scalar	dimCns
	pointer(struct mopt__struct) scalar pM
	real scalar	neq
	real scalar	v0			// ignored
	real matrix	H0			// ignored
	real scalar	mytodo
	pragma unset v0
	pragma unset H0
	pragma unset gp_v
	pragma unset gm_v

	doCns = 0
	if (S.hasCns) {
		doCns	= cols(S.params)==cols(S.T)
		if (doCns) {
			opt__cns_off(S, todo>0)
		}
	}
	dim	= S.dim
	H0	= J(dim,dim,.)

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,
		S.value,S.gradient,H0,
		S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (doCns) {
		opt__cns_on(S, todo>0)
	}
	if (todo != 2 | missing(S.value)) return(0)

	S.dot_type = "input"
	eps	= 1e-4

	// NOTE: pass mytodo==2 to ensure using 'view's with ado-file
	// evaluators does not get in the way of taking second
	// derivatives.

	pM	= S.arglist[1]
	if (strlen(pM->st_user)) {
		mytodo = todo
	}
	else {
		mytodo = 1
	}
	if (doCns) {
		dimCns	= cols(S.params)
		S.H	= J(dimCns,dimCns,.)
		gp	= J(1,dim,.)
		gm	= J(1,dim,.)
		ui	= J(1,dimCns,0)
		for (i=1; i<=dimCns; i++) {
			h	= (abs(S.params[i]) + eps)*eps
			ui[i]	= h
	
			p_alt	= (S.params + ui)*S.T' + S.a
			(*S.calluser)(S.user,S.arglist,S.minimize,
				mytodo,p_alt,
				v0,gp,H0,gp_v)
			opt__cnt_eval(S,1,v0)
	
			p_alt	= (S.params - ui)*S.T' + S.a
			(*S.calluser)(S.user,S.arglist,S.minimize,
				mytodo,p_alt,
				v0,gm,H0,gm_v)
			opt__cnt_eval(S,1,v0)
			S.H[i,] = ((gp - gm)*S.T)/(2*h)
	
			ui[i]	= 0
		}
		S.H = (S.H + S.H')/2
	}
	else {
		neq	= pM->neq
		S.H	= J(dim,dim,0)
		gp	= J(1,dim,.)
		gm	= J(1,dim,.)
		for (i=1; i<=neq; i++) {
			mopt__lf_h(S.params,i,(*pM),h)
			pM->eqdelta[i] = h
			(*S.calluser)(S.user,S.arglist,S.minimize,
				mytodo,S.params,
				v0,gp,H0,gp_v)
			opt__cnt_eval(S,1,v0)
	
			pM->eqdelta[i] = -h
			(*S.calluser)(S.user,S.arglist,S.minimize,
				mytodo,S.params,
				v0,gm,H0,gm_v)
			opt__cnt_eval(S,1,v0)
			pM->eqdelta[i] = 0
			gp_v = (gp_v - gm_v)/(2*h)
			for (j=i; j<=neq; j++) {
			    S.H[|moptimize_util_eq_indices((*pM),j,i)|] =
				moptimize_util_matsum((*pM),j,i,gp_v[,j],v0)
			}
		}
		if (neq > 1 ) {
			_makesymmetric(S.H)
		}
	}
	return(0)
}

`Errcode' opt__eval_nr_e2debug(`OptStruct' S, real scalar todo)
{
	`Errcode'	ec
	pointer(function)	pf

	// call d0 method, and exit if no derivatives were requested
	pf = S.calluser
	S.calluser = &mopt__calluser_d()
	ec = opt__eval_nr_d0(S, todo)
	S.calluser = pf
	if (ec) return(ec)
	if (todo == 0) return(0)

	real scalar	dim
	real scalar	v
	real rowvector	p, g
	real matrix	g_e
	real matrix	H
	pragma unset v
	pragma unset g_e

	dim	= S.dim
	p	= S.params
	g	= J(1,dim,.)
	H	= J(dim,dim,.)
	// call user to compute some derivatives to compare with d0
	if (S.evaltype_s == "e2debug") {
		(*S.calluser)(S.user,S.arglist,S.minimize,
			todo,p,
			v,g,H,g_e)
		if (S.negH & todo == 2) {
			_negate(H)
		}
		opt__cnt_eval(S,todo,v)
	}
	else {
		(*S.calluser)(S.user,S.arglist,S.minimize,
			todo>0,p,
			v,g,H,g_e)
		opt__cnt_eval(S,todo>0,v)
	}

	opt__eval_nr_debug_report(S,todo,p,v,g,H)
	return(0)
}

`Errcode' opt__eval_nr_e2(`OptStruct' S, real scalar todo)
{
	(*S.calluser)(
		S.user,
		S.arglist,
		S.minimize,
		todo,
		S.params,
		S.value,
		S.gradient,
		S.H,
		S.gradient_v
	)
	if (S.negH & todo == 2) {
		_negate(S.H)
	}
	opt__cnt_eval(S,todo,S.value)
	return(0)
}

function moptimize_ado_cleanup(`MoptStruct' M)
{
	if (M.st_user != `MOPT_st_user_default' & M.st_drop_macros) {
		stata("macro drop ML_*")
	}
	if (M.st_tmp_w != `MOPT_st_tmp_w_default') {
		stata(sprintf("capture drop %s", M.st_tmp_w))
	}
}

function mopt__trace_store(`MoptStruct' M, real vector trace)
{
	opt__trace_store(M.S, trace)
}

function mopt__trace_restore(`MoptStruct' M, real vector trace)
{
	opt__trace_restore(M.S, trace)
}

void mopt__build_xb(`MoptStruct' M, real rowvector params)
{
	_mopt_xbmat(	M.eqlist,
			M.eqcons,
			params,
			M.eqoffset,
			M.eqexposure,
			J(1,M.neq,0),
			M.xb)
}

// Mata equivalent of the internal '_mopt_hold_xbi()' function
void mopt_holdxbi(real matrix xb, real scalar i, real colvector xbi)
{
	xbi = xb[,i]
}

// Mata equivalent of the internal '_mopt_unhold_xbi()' function
void mopt_unholdxbi(real matrix xb, real scalar i, real colvector xbi)
{
	xb[,i] = xbi
}

// Mata equivalent of the internal '_mopt_xbdelta()' function
void mopt_xbdelta(real matrix xb, real scalar i, real scalar delta)
{
	xb[,i] = xb[,i] :+ delta
}

function mopt__lf_setdelta(`MoptStruct' M, real scalar i, real scalar delta)
{
	if (M.st_xb != "") {
		st_view(M.xb, ., M.st_xb, M.st_touse)
	}
	if (nonmissing(delta)) {
		if (missing(M.ixb1)) {
			M.ixb1	= i
			_mopt_holdxbi(M.xb, i, M.hxb1)
		}
		else if (missing(M.ixb2)) {
			M.ixb2	= i
			_mopt_holdxbi(M.xb, i, M.hxb2)
		}
		else {
			errprintf(
"moptimize() is trying to hold too many columns of Xb\n")
			exit(3000)
		}
		_mopt_xbdelta(M.xb, i, delta)
	}
	else {
		if (M.ixb1 == i) {
			_mopt_unholdxbi(M.xb, i, M.hxb1)
			M.ixb1	= .
		}
		else if (M.ixb2 == i) {
			_mopt_unholdxbi(M.xb, i, M.hxb2)
			M.ixb2	= .
		}
	}
}

function mopt__lf2_setdelta(`MoptStruct' M, real scalar i, real scalar delta)
{
	if (nonmissing(delta)) {
		M.eqdelta[i] = delta
	}
	else {
		M.eqdelta[i] = 0
	}
}

void mopt__link(`MoptStruct' M)
{
	real scalar	break_key, lcnt

	// WARNING:  Store a pointer to 'M' in its 'optimize()' object;
	// decrement the link counter to 'M' so that it can be automatically
	// handled by garbage collection when 'M' is not a global object.

	break_key = setbreakintr(0)
	lcnt	= sys_linkcount(M)
	optimize_init_argument(M.S,1,M)
	if (lcnt != sys_linkcount(M)) {
		M.linked	= 1
		sys_decrlinkcount(M)
	}
	(void) setbreakintr(break_key)
}

void mopt__unlink(`MoptStruct' M)
{
	real	scalar	break_key

	// WARNING:  Reset the link counter to 'M' then unlink 'M' and its
	// 'optimize()' object so that 'M' can be automatically handled by
	// garbage collection.

	break_key = setbreakintr(0)
	if (M.linked) {
		M.linked	= 0
		sys_incrlinkcount(M)
	}
	opt__unlink_args(M.S)
	(void) setbreakintr(break_key)
}

void mopt__rescore(`MoptStruct' M)
{
	`Errcode'	ec
	real	scalar	dots

	if (M.st_scores != "") {
		st_view(M.S.gradient_v,
			.,
			M.st_scores,
			M.st_touse)
	}
	if (!M.rescore) {
		return
	}
	mopt__link(M)
	if (M.S.hasCns) {
		opt__cns_on(M.S, 2)
	}
	// recompute the scores
	dots = M.S.trace_dots
	M.S.trace_dots = 0
	ec = opt__eval(M.S,1,M.S.hasCns)
	M.S.trace_dots = dots
	if (M.S.hasCns) {
		opt__cns_off(M.S, 2)
	}
	mopt__unlink(M)
	if (ec) {
		exit(ec)
	}
	M.rescore	= `OPT_onoff_off'
}

end
