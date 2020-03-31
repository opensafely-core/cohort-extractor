*! version 1.4.5  10oct2017
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'
findfile moptimize_include.mata
quietly include `"`r(fn)'"'

mata:

struct mopt__struct {
	real			scalar		mopt_version
	real			scalar		caller_version
	struct opt__struct	scalar		S
	real			scalar		linked
	// dependent variables
	pointer(real matrix)	rowvector	depvars
	real			scalar		ndepvars
	real			scalar		obs
	// user defined equations
	real			scalar		neq
	pointer(real matrix)	rowvector	eqlist
	real			rowvector	eqcons
	pointer(real matrix)	rowvector	eqoffset
	real			rowvector	eqexposure
	real			rowvector	eqfreeparm
	string			rowvector	eqnames
	pointer(string vector)	rowvector	eqcolnames
	pointer(real vector)	rowvector	eqcoefs
	real			matrix		eqbounds
	real			scalar		kaux
	real			rowvector	eqdelta
	// user defined information
	real			scalar		nuinfo
	pointer			rowvector	uinfolist
	pointer(colvector)	scalar		by
	// weights
	string			scalar		wname
	real			scalar		wtype
	pointer(real colvector)	scalar		weights
	pointer(real colvector)	scalar		by_weights
	real			scalar		uvcetype
	real			scalar		vce
	real			scalar		svy
	// searching for initial values
	real			scalar		search
	real			scalar		search_quietly
	real			scalar		search_min
	real			scalar		search_max
	real			scalar		search_feasible
	real			scalar		search_repeat
	real			scalar		search_rescale
	real			scalar		search_random
	// internal data management for equations
	real			matrix		eqdims
	// internal item for 'lf' derivatives
	real			matrix		xb
	real			colvector	hxb1
	real			scalar		ixb1
	real			colvector	hxb2
	real			scalar		ixb2
	real			rowvector	scale
	real			rowvector	h
	real			scalar		hold_xb
	// items that refer to Stata objects
	real			scalar		view
	real			scalar		need_views
	string			scalar		st_user
	string			scalar		st_userprolog
	string			scalar		st_trace
	string			scalar		st_touse
	string			scalar		st_sample
	string			vector		st_depvars
	string			vector		st_eqlist
	string			vector		st_eqoffset
	string			vector		st_eqoffset_revar
	string			scalar		st_wvar
	string			scalar		st_genwvar
	real			scalar		k_autoCns
	real			scalar		st_drop_macros
	real			scalar		st_regetviews
	real			scalar		st_tsops
	real			scalar		check
	real			scalar		st_rc	// Stata return code
	real			scalar		norc
	// strings that point to temporary Stata objects
	string			scalar		st_p
	string			scalar		st_v
	string			vector		st_delta
	string			scalar		st_g
	string			scalar		st_H
	string			scalar		st_by
	string			vector		st_scores
	string			vector		st_xb
	string			scalar		st_cmd_args
	string			scalar		st_cmd_prolog
	string			scalar		st_tmp_w
	// miscellaneous
	string			colvector	diparm
	string			scalar		title
	real			scalar		valid
	real			scalar		rescore
	real			scalar		p_updated
	real			scalar		interactive
	// ML class used in recallable evaluators
	string			scalar		usrname
	string			scalar		dropmetoo	
	string			matrix		vmacros	// temp variables
	string			matrix		mmacros	// temp matrices
	string			matrix		smacros	// temp scalars
	// coefficient adjustment function
	pointer(function)	scalar		adj_func
	real			rowvector	adj_args
}

void moptimize(`MoptStruct' M)
{
	// validate the settings
	M.S.ucall = 0

	if (M.search == `OPT_onoff_off') {
		(void) mopt__validate(M)
	}
	else {
		moptimize_search(M)
	}
	mopt__link(M)
	(void) opt__loop(M.S)
	mopt__unlink(M)
}

`Errcode' _moptimize(`MoptStruct' M)
{
	// validate the settings
	M.S.ucall = 1
	if (M.search == `OPT_onoff_off') {
		M.S.oerrorcode = mopt__validate(M)
	}
	else {
		M.S.oerrorcode = _moptimize_search(M)
	}
	if (! M.S.oerrorcode) {
		mopt__link(M)
		M.S.oerrorcode = opt__loop(M.S)
		mopt__unlink(M)
	}
	return(M.S.oerrorcode)
}

void moptimize_search(`MoptStruct' M)
{
	`Errcode' ec

	mopt__link(M)
	ec = _moptimize_search(M)
	mopt__unlink(M)
	if (ec) {
		M.S.ucall = 0
		exit(optimize_result_returncode(M.S))
	}
}

`Errcode' _moptimize_search(`MoptStruct' M)
{
	`Errcode'	ec
	real scalar	dots

	// search for feasible/better starting values
	M.S.ucall = 1
	dots = M.S.trace_dots
	M.S.trace_dots = 0
	ec = _moptimize_evaluate(M)
	if (! ec) {
		mopt__link(M)
		ec = mopt__search(M)
		mopt__unlink(M)
	}
	M.S.trace_dots = dots
	M.S.oerrorcode = ec
	return(ec)
}

`Errcode' _mopt__search(`MoptStruct' M)
{
	`Errcode'	ec
	real scalar	dots

	// search for feasible/better starting values
	M.S.ucall = 1
	ec = mopt__validate(M)
	if (ec) {
		M.S.oerrorcode = ec
		return(ec)
	}
	dots = M.S.trace_dots
	M.S.trace_dots = 0
	mopt__link(M)
	ec = mopt__search(M)
	mopt__unlink(M)
	M.S.trace_dots = dots
	M.S.oerrorcode = ec
	return(ec)
}

void moptimize_evaluate(`MoptStruct' M,| real scalar todo)
{
	if (args() == 1) {
		todo = 0
	}
	M.S.ucall = 0
	if (mopt__validate(M)) {
		exit(optimize_result_returncode(M.S))
	}
	if (opt__looputil_prolog_cycle(M.S)) {
		exit(optimize_result_returncode(M.S))
	}
	mopt__link(M)
	(void) optimize_evaluate(M.S, todo)
	mopt__unlink(M)
}

void Mopt_evaluate(`MoptStruct' M,| real scalar todo)
{
	`Errcode'	ec
	if (args() == 1) {
		todo = 0
	}
	mopt__link(M)
	ec = _optimize_evaluate(M.S, todo)
	mopt__unlink(M)
	if (ec) {
		exit(optimize_result_returncode(M.S))
	}
}

`Errcode' _moptimize_evaluate(`MoptStruct' M,| real scalar todo)
{
	`Errcode'	ec
	if (args() == 1) {
		todo = 0
	}
	M.S.ucall = 1
	ec = mopt__validate(M)
	if (! ec) {
		ec = opt__looputil_prolog_cycle(M.S)
	}
	if (ec) {
		M.S.oerrorcode = ec
		return(ec)
	}
	return(_mopt__evaluate(M, todo))
}

`Errcode' _mopt__evaluate(`MoptStruct' M,| real scalar todo)
{
	`Errcode'	ec
	if (args() == 1) {
		todo = 0
	}
	mopt__link(M)
	ec = mopt__st_validate(M)
	if (! ec) {
		ec = _optimize_evaluate(M.S, todo)
	}
	mopt__unlink(M)
	return(ec)
}

`Errcode' _moptimize_validate(`MoptStruct' M)
{
	M.S.ucall = 1
	M.S.oerrorcode = mopt__validate(M)
	return(M.S.oerrorcode)
}

end
