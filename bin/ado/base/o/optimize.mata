*! version 1.4.2  10oct2017
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'

mata:

struct opt__struct {
	real			scalar		opt_version
	// settings allowed to be changed by the user
	real			rowvector	p0
	real			scalar		minimize
	pointer(function)	scalar		user
	pointer(function)	scalar		userprolog
	pointer(function)	scalar		userprolog2
	real			scalar		evaltype
	string			scalar		evaltype_s	// short name
	string			scalar		evaltype_l	// long name
	string			scalar		evaltype_user
	string			scalar		evaltype_f	// func name
	string			scalar		technique
	pointer(function)	scalar		loop
	string			scalar		singularH
	pointer(function)	scalar		singularH_stepper
	real			scalar		step_forward
	real			scalar		maxiter
	real			scalar		ptol
	real			scalar		vtol
	real			scalar		gtol
	real			scalar		qtol // quasi-nrtol
	real			scalar		nrtol
	real			scalar		ignorenrtol
	real			scalar		notconcave
	real			scalar		k_notconcave
	real			scalar		utrace
	real			scalar		trace
	real			scalar		trace_value
	real			scalar		trace_dots
	real			scalar		trace_tol
	real			scalar		trace_pdiffs
	real			scalar		trace_step
	real			scalar		trace_params
	real			scalar		trace_gradient
	real			scalar		trace_hessian
	string			scalar		value_id
	string			scalar		iter_id
	real			matrix		constraints
	real			scalar		wtype
	real			colvector	weights
	real			colvector	by_weights
	real			scalar		simplex_delta
					// no derivatives after maxiter
	real			scalar		ndami
	// user defined arguments
	real			scalar		nargs
	pointer			rowvector	arglist
	// evaluator returns -H instead of H
	real			scalar		negH
	// optimization-time items
	real			rowvector	params
	real			scalar		v0
	real			scalar		value
	real			colvector	value_v
	real			rowvector	gradient
	real			matrix		gradient_v
	real			matrix		hessian
	real			scalar		iter
	real			scalar		converged
	real			scalar		convtol
	string			scalar		convtol_id
	real			colvector	log
	real			scalar		evalcount
	real			scalar		cnt0_evals
	real			scalar		cnt1_evals
	real			scalar		cnt2_evals
	real			scalar		cnt__evals
	real			scalar		ndots
	string			scalar		dot_type
	real			scalar		warn
	// internals
	real			scalar		valid
	real			scalar		debugeval
	pointer(function)	scalar		calluser
	pointer(function)	scalar		deriv_calluser
	pointer(function)	scalar		callprolog
	pointer(function)	scalar		eval
	real			scalar		dim
	real			matrix		H
	real			scalar		concave
	real			scalar		backup
	transmorphic 		scalar		D		// deriv()
	real			scalar		use_deriv
	real			scalar		linked
	real			scalar		userscale
	real			scalar		holdCns
	real			scalar		hasCns
	real			scalar		fullRankCns
	real			matrix		T
	real			colvector	a
	real			rowvector	oldparams
	real			rowvector	oldgrad
	real			scalar		reset
	real			scalar		eigen
	real			matrix		simplex
	real			colvector	simvals
	real			colvector	simorder
	real			scalar		simnodes
	real			scalar		oerrorcode
	real			scalar		errorcode
	string			scalar		errortext
	real			scalar		verbose
	real			scalar		ucall
	real			scalar		invert
	string			vector		cycle_names
	real			vector		cycle_counts
	pointer(function)	vector		cycle_evals
	pointer(function)	vector		cycle_eval
	pointer(function)	vector		cycle_switcher
	pointer(string matrix)	vector		stripes
	real			scalar		cycle_iter
	real			scalar		cycle_idx
	pointer(real matrix)	scalar		gn_A
	transmorphic 		scalar		R		// robust()
	real			scalar		doopt
	real			scalar		nm_sortstable
}

real rowvector optimize(`OptStruct' S)
{
	// validate the settings
	S.ucall = 0
	(void) opt__validate(S)
	(void) opt__loop(S)
	return(S.params)
}

`Errcode' _optimize(`OptStruct' S)
{
	// validate the settings
	S.ucall = 1
	S.oerrorcode = opt__validate(S)
	if (! S.oerrorcode) {
		S.oerrorcode = opt__loop(S)
	}
	return(S.oerrorcode)
}

real rowvector optimize_evaluate(`OptStruct' S,| real scalar todo)
{
	`Errcode'	ec

	if (args() == 1) {
		todo = 0
	}

	ec = _optimize_evaluate(S, todo)
	S.ucall = 0
	if (ec) {
		exit(optimize_result_returncode(S))
	}

	return(S.params)
}

`Errcode' _optimize_evaluate(
	`OptStruct'	S,
	|real	scalar	todo,
	real	scalar	do_cns)
{
	`Errcode'	ec
	real	scalar	warn
	real	vector	trace
	pragma unset trace

	if (args() == 1) {
		todo = 0
	}
	if (args() == 2) {
		do_cns = 0
	}

	S.ucall = 1

	// copy the setting we'll be overriding
	opt__trace_store(S, trace)
	warn		= S.warn

	// run 1 silent evaluation
	opt__trace_none(S)
	S.warn		= `OPT_onoff_off'

	ec = opt__validate(S)
	if (!ec) {
		if (S.hasCns == 0) {
			do_cns = 0
		}
		if (do_cns) {
			opt__cns_on(S, todo)
		}
		ec = opt__eval(S,todo,do_cns)
	}
	if (!ec) {
		if (do_cns) {
			opt__cns_off(S, todo)
		}
		if (todo == 2 & S.technique == `OPT_technique_nr') {
			S.hessian = S.H
		}
	}

	// restore the original settings
	opt__trace_restore(S, trace)
	S.warn		= warn
	S.oerrorcode	= ec
	return(ec)
}

`Errcode' _optimize_validate(`OptStruct' S)
{
	S.ucall = 1
	S.oerrorcode = opt__validate(S)
	return(S.oerrorcode)
}

end
