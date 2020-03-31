*! version 1.6.0  23aug2019
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'

mata:

`Errcode' opt__bfgs(`OptStruct' S)
{
	real	scalar	doCns

	doCns = opt__doCns(S)
	if (doCns) {
		opt__cns_off(S, 2)
	}

	if (S.iter == 0) {
		S.oldparams	= S.params
		S.oldgrad	= S.gradient
		S.H		= I(cols(S.params))
		if (doCns) {
			opt__cns_on(S, 2)
		}
		return(0)
	}

	real scalar	eps
	real scalar	dbdgp, dgHdgp, gPg, bPb
	real colvector	d
	real matrix	db, dg
	real matrix	V

	V	= S.H
	eps	= 1e-8
	db	= S.params - S.oldparams
	dg	= S.gradient - S.oldgrad
	dbdgp	= db * dg'
	dgHdgp	= dg * V * dg'
	bPb	= db * db'
	gPg	= dg * dg'
	if (abs(dbdgp*dgHdgp) > eps*gPg*bPb) {
		// NOTE: -ml_e0_bfgs- can get slightly different results due
		// to the subtraction
		d = db' / dbdgp - V*dg' / dgHdgp
		V = V - db'*db/dbdgp + dgHdgp*d*d' - (V*dg')*(dg*V')/dgHdgp
		V = (V + V')/2
		if (missing(V)) {
			S.errorcode = `Errcode_unstable'
			S.errortext = `Errtext_unstable'
			opt__errorhandler(S)
			return(S.errorcode)
		}
		swap(S.H, V)
	}
	else {
		if (S.reset < 10) {
			if (S.trace) {
				displayas("txt")
	printf("BFGS stepping has contracted, resetting BFGS Hessian\n")
			}
			S.H	= I(cols(S.params))
			S.reset	= S.reset + 1
		}
		else {
			S.errorcode = `Errcode_flat'
			S.errortext = `Errtext_flat'
			opt__errorhandler(S)
			return(S.errorcode)
		}
	}

	S.oldparams	= S.params
	S.oldgrad	= S.gradient

	if (doCns) {
		opt__cns_on(S, 2)
	}
	return(0)
}

real matrix opt__opg_v(`OptStruct' S)
{
	// NOTE: 'optimize()' assumes it is getting the Hessian matrix back,
	// but we are computing the outer product of the gradients here, which
	// is an approximation of -H.
	real matrix H
	if (S.wtype == `OPT_wtype_none') {
		H	= cross(
			S.gradient_v,
			S.gradient_v)
	}
	else if (S.wtype == `OPT_wtype_f') {
		H	= cross(
			S.gradient_v,
			S.weights,
			S.gradient_v)
	}
	else if (rows(S.by_weights)) {
		H	= cross(
			S.gradient_v,
			S.by_weights :* S.by_weights,
			S.gradient_v)
	}
	else {
		H	= cross(
			S.gradient_v,
			S.weights :* S.weights,
			S.gradient_v)
	}
	return(H)
}

/*STATIC*/ real scalar opt__check_concave(real matrix H, real matrix V)
{
	real vector dH, dV

	dV	= diagonal(V) :== 0
	if (!any(dV)) {
		return(1)
	}
	dH	= diagonal(H) :== 0
	if (!any(dH)) {
		return(0)
	}
	if (dV'(1:-dH) == 0) {
		return(1)
	}
	return(0)
}

/*STATIC*/ real scalar opt__check_doopt(
	`OptStruct'	S,
	real rowvector	params,
	real rowvector	delta,
	real scalar	nonrtol,
	|real scalar	pconvtol
)
{
	real	scalar	conv
	// NOTE:  This is a convergence check performed by Stata's internal
	// 'doopt()', and should only be used with evaluators that were
	// developed to use this new 'optimize()' engine in order to replace
	// the 'doopt()' estimator but retain certain numerical properties.

	pconvtol = max(abs(delta):/(abs(params):+0.001))
	conv = pconvtol <= S.ptol
	if (conv) {
		if (nonrtol | abs(S.gradient*delta') <= S.nrtol) {
			return(1)
		}
	}
	return(0)
}

`Errcode' opt__get_hessian(`OptStruct' S)
{
	`Errcode'			ec
	pointer(function)	scalar	eval
	real			scalar	dots
	pragma unset eval
	pragma unset dots

	swap(dots,	S.trace_dots)
	swap(eval,	S.eval)

	S.trace_dots = 0
	S.eval = findexternal(sprintf("opt__eval_nr_%s()", S.evaltype_f))

	ec = opt__eval(S,2,S.hasCns)

	swap(dots,	S.trace_dots)
	swap(eval,	S.eval)

	if (ec) return(ec)

	return(0)
}

/*STATIC*/ `Errcode' opt__check_nrtol(
	`OptStruct'	S,
	real scalar	invert,
	real scalar	nrtol,
	real matrix	H,
	real matrix	invH,
	string scalar	id,
	real scalar	conv
)
{
	real rowvector	delta

	if (missing(invH)) {
		if (invert) {
			invH = invsym(-H)
		}
		else {
			invH = H
		}
		S.concave = opt__check_concave(H,invH)
	}
	if (S.concave) {
		delta	= S.gradient*invH
		if (missing(delta)) {
			S.errorcode = `Errcode_H_notdefinite'
			if (S.minimize) {
				S.errortext = `Errtext_H_notPSD'
			}
			else {
				S.errortext = `Errtext_H_notNSD'
			}
			opt__errorhandler(S)
			return(S.errorcode)
		}
		S.convtol	= abs(S.gradient*delta')
		conv		= S.convtol < nrtol
		S.convtol_id	= id
	}
	else {
		conv	= 0
	}
	return(0)
}

/*STATIC*/ `Errcode' opt__check_conv(
	`OptStruct'	S,
	real rowvector	p0,
	real scalar	v0,
	real matrix	invH
)
{
	`Errcode'	ec
	real scalar	conv
	real scalar	ptol, vtol, nrtol, gtol
	real scalar	pconvtol, vconvtol
	string scalar	tech
	string scalar	id
	real matrix	H
	real matrix	iH
	pragma unset pconvtol
	pragma unset H
	pragma unset iH
	pragma unused iH

	ptol		= S.ptol
	vtol		= S.vtol
	gtol		= S.gtol

	S.converged	= 0
	S.convtol	= `OPT_convtol_default'
	S.hessian	= `OPT_hessian_default'

	if (S.doopt) {
		(void) opt__check_doopt(S,S.params,S.params-p0,1,pconvtol)
		pconvtol	= max((pconvtol, mreldif(S.params,p0)))
	}
	else {
		pconvtol	= mreldif(S.params, p0)
	}
	vconvtol	=  reldif(S.value,  v0)
	if (S.concave) {
		S.k_notconcave = 0
	}
	else {
		if (vconvtol <= vtol) {
			S.k_notconcave = S.k_notconcave + 1
		}
	}
	conv		= ((pconvtol <= ptol) | (vconvtol <= vtol))
	if (conv & S.concave & nonmissing(gtol)) {
		S.convtol	= max(abs(S.gradient):*(abs(S.params):+1e-7))
		conv		= S.convtol < gtol
		S.convtol_id	= "gtol"
	}
	if (conv & !S.ignorenrtol) {
		tech = opt__util_technique(S)
		if (tech == `OPT_technique_nr') {
			id = "g inv(H) g'"
			nrtol = S.nrtol
		}
		else {
			id = "qtol"
			nrtol = missing(S.qtol) ? S.nrtol : S.qtol
		}
		ec = opt__check_nrtol(	S,
					S.invert,
					nrtol,
					S.H,
					invH,
					id,
					conv)
		if (ec) return(ec)
		if (conv & any(tech :== tokens(`QUASI')) & missing(S.qtol)) {
			H = S.H
			ec = opt__get_hessian(S)
			if (ec) return(ec)
			ec = opt__check_nrtol(	S,
						1,
						S.nrtol,
						S.H,
						iH=.,
						"g inv(H) g'",
						conv)
			if (ec) return(ec)
			if (conv) {
				if (S.hasCns) {
					opt__cns_off(S, 2)
				}
				S.hessian = S.H
				if (S.hasCns) {
					opt__cns_on(S, 2)
				}
			}
			swap(S.H, H)
		}
	}
	if (S.convtol == `OPT_convtol_default') {
		if (pconvtol < max((ptol,vconvtol))) {
			S.convtol = pconvtol
			S.convtol_id = "ptol"
		}
		else {
			S.convtol = vconvtol
			S.convtol_id = "vtol"
		}
	}
	S.converged = conv
	return(0)
}

void opt__check_v(
	real scalar	todo,		// INPUT  : instructions
	real colvector	w,		// INPUT  : weights
	real colvector	by_w,		// INPUT  : weights
	real colvector	v_v,		// INPUT  : values by obs vector
	real matrix	g_v,		// INPUT  : gradient by obs matrix
	real scalar	v,		// OUTPUT : value
	real rowvector	g		// OUTPUT : gradient
)
{
	if (missing(v_v)) {
		v = .
		return
	}
	else if (rows(by_w)) {
		v = quadcross(by_w, v_v)
	}
	else {
		v = quadcross(w, v_v)
	}
	if (todo > 0) {
		if ( (rows(g_v) > 1) & (rows(v_v) != rows(g_v)) ) {
			errprintf(
			"evaluator returned gradient vector with too %s rows",
				rows(v_v) < rows(g_v) ?
					"many" : "few")
			exit(3200)
		}
		if (missing(g_v)) {
			v = .
		}
		else if (rows(by_w)) {
			g = quadcross(by_w, g_v)
		}
		else {
			g = quadcross(w, g_v)
		}
	}
}

void opt__cns_off(`OptStruct' S, real scalar todo)
{
	S.params = S.params*S.T'+S.a
	if (todo > 0) {
		S.gradient = S.gradient*S.T'
		if (todo > 1) {
			S.H = S.T*S.H*S.T'
		}
	}
}

void opt__cns_on(`OptStruct' S, real scalar todo)
{
	S.params = (S.params-S.a)*S.T
	if (todo > 0) {
		if (cols(S.gradient) == 0) {
			return
		}
		S.gradient = S.gradient*S.T
		if (todo > 1) {
			if (cols(S.H) == 0) {
				return
			}
			S.H = S.T'*S.H*S.T
		}
	}
}

`Errcode' opt__dfp(`OptStruct' S)
{
	real	scalar	doCns

	doCns = opt__doCns(S)
	if (doCns) {
		opt__cns_off(S, 2)
	}

	if (S.iter == 0) {
		S.oldparams	= S.params
		S.oldgrad	= S.gradient
		S.H		= I(cols(S.params))
		if (doCns) {
			opt__cns_on(S, 2)
		}
		return(0)
	}

	real scalar	eps
	real scalar	dbdgp, dgHdgp, gPg, bPb
	real matrix	db, dg
	real matrix	V

	V	= S.H
	eps	= 1e-8
	db	= S.params - S.oldparams
	dg	= S.gradient - S.oldgrad
	dbdgp	= db * dg'
	dgHdgp	= dg * V * dg'
	bPb	= db * db'
	gPg	= dg * dg'
	if (abs(dbdgp*dgHdgp) > eps*gPg*bPb) {
		// NOTE: -ml_e0_dfp- can get slightly different results due
		// to the subtraction
		V = V - db'*db/dbdgp - (V*dg')*(dg*V')/dgHdgp
		V = (V + V')/2
		if (missing(V)) {
			S.errorcode = `Errcode_unstable'
			S.errortext = `Errtext_unstable'
			opt__errorhandler(S)
			return(S.errorcode)
		}
		swap(S.H,V)
	}
	else {
		if (S.reset < 10) {
			if (S.trace) {
				displayas("txt")
	printf("DFP stepping has contracted, resetting DFP Hessian\n")
			}
			S.H	= I(cols(S.params))
			S.reset	= S.reset + 1
		}
		else {
			S.errorcode = `Errcode_flat'
			S.errortext = `Errtext_flat'
			opt__errorhandler(S)
			return(S.errorcode)
		}
	}

	S.oldparams	= S.params
	S.oldgrad	= S.gradient

	if (doCns) {
		opt__cns_on(S, 2)
	}
	return(0)
}

void opt__errorhandler(`OptStruct' S)
{
	if (!S.errorcode) return
	if (S.verbose) {
		errprintf("{p}\n")
		errprintf("%s\n", S.errortext)
		errprintf("{p_end}\n")
	}
	if (S.ucall) return
	exit(optimize_result_returncode(S))
}

`Errcode' opt__eval_cycle(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec
	real	scalar	i, k, ki, holdCns

	// index to the current technique
	i		= S.cycle_idx
	S.cycle_eval	= S.cycle_evals[i]

	holdCns	= S.holdCns & S.hasCns
	if (todo & S.cycle_iter == 1 & S.iter) {
		if (S.trace) {
			displayas("text")
			printf("(switching technique to %s)\n",
				S.cycle_names[i])
		}
		if (S.cycle_switcher[i] != NULL) {
			ec = (*S.cycle_switcher[i])(S)
			if (ec) return(ec)
		}
		if (holdCns) {
			if (!S.holdCns) {
				opt__cns_off(S, todo)
			}
		}
	}

	ec = (*S.cycle_eval)(S,todo)
	if (ec) return(ec)

	if (todo) {
		// max number of iterations to spend within this technique
		ki		= S.cycle_counts[i]
		S.cycle_iter	= mod(S.cycle_iter, ki) + 1
		if (S.cycle_iter == 1) {
			// number of techniques in the list
			k		= cols(S.cycle_names)
			// switch to the next technique
			i		= mod(i,k) + 1
			S.cycle_iter	= 1
			S.cycle_idx	= i
		}
		if (S.invert & !missing(S.value)) {
			if (opt__doCns(S)) {
				opt__cns_off(S, 1)
				S.oldparams	= S.params
				S.oldgrad	= S.gradient
				opt__cns_on(S, 1)
			}
			else {
				S.oldparams	= S.params
				S.oldgrad	= S.gradient
			}
		}
		if (!holdCns) {
			if (S.holdCns) {
				opt__cns_on(S, todo)
			}
		}
	}

	return(0)
}

`Errcode' opt__eval_bfgs_d0(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)

	return(opt__bfgs(S))
}

`Errcode' opt__eval_bfgs_d1(
	`OptStruct'	S,
	real   scalar	todo
)
{
	real matrix	H0			// ignored
	real scalar	doCns
	pragma unset H0

	doCns = opt__doCns(S)
	if (doCns) {
		opt__cns_off(S, todo>0)
	}
	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.value,S.gradient,H0)
	opt__cnt_eval(S,todo>0,S.value)
	if (doCns) {
		opt__cns_on(S, todo>0)
	}
	if (todo != 2 | missing(S.value)) return(0)

	return(opt__bfgs(S))
}

`Errcode' opt__eval_bfgs_d2(
	`OptStruct'	S,
	real   scalar	todo
)
{
	return(opt__eval_bfgs_d1(S, todo))
}

`Errcode' opt__eval_bfgs_v0(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)

	return(opt__bfgs(S))
}

`Errcode' opt__eval_bfgs_v1(
	`OptStruct'	S,
	real   scalar	todo
)
{
	real matrix	H0			// ignored
	real scalar	doCns
	pragma unset H0

	doCns = opt__doCns(S)
	if (doCns) {
		opt__cns_off(S, todo>0)
	}
	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.weights,S.by_weights,
		S.value,S.gradient,H0,
		S.value_v,S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (doCns) {
		opt__cns_on(S, todo>0)
	}
	if (todo != 2 | missing(S.value)) return(0)

	return(opt__bfgs(S))
}

`Errcode' opt__eval_bfgs_v2(
	`OptStruct'	S,
	real   scalar	todo
)
{
	return(opt__eval_bfgs_v1(S, todo))
}

`Errcode' opt__eval_bhhh_v0(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)

	S.H = -opt__opg_v(S)
	return(0)
}

`Errcode' opt__eval_bhhh_v1(
	`OptStruct'	S,
	real   scalar	todo
)
{
	real scalar	dim
	real matrix	H0			// ignored
	pragma unset H0

	dim	= S.dim
	H0	= J(dim,dim,.)

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.weights,S.by_weights,
		S.value,S.gradient,H0,
		S.value_v,S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (todo != 2 | missing(S.value)) return(0)

	S.H = -opt__opg_v(S)
	return(0)
}

`Errcode' opt__eval_bhhh_v2(
	`OptStruct'	S,
	real   scalar	todo
)
{
	return(opt__eval_bhhh_v1(S, todo))
}

`Errcode' opt__eval_dfp_d0(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)

	return(opt__dfp(S))
}

`Errcode' opt__eval_dfp_d1(
	`OptStruct'	S,
	real   scalar	todo
)
{
	real matrix	H0			// ignored
	real scalar	doCns
	pragma unset H0

	doCns = opt__doCns(S)
	if (doCns) {
		opt__cns_off(S, todo>0)
	}
	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.value,S.gradient,H0)
	opt__cnt_eval(S,todo>0,S.value)
	if (doCns) {
		opt__cns_on(S, todo>0)
	}
	if (todo != 2 | missing(S.value)) return(0)

	return(opt__dfp(S))
}

`Errcode' opt__eval_dfp_d2(
	`OptStruct'	S,
	real   scalar	todo
)
{
	return(opt__eval_dfp_d1(S, todo))
}

`Errcode' opt__eval_dfp_v0(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)

	return(opt__dfp(S))
}

`Errcode' opt__eval_dfp_v1(
	`OptStruct'	S,
	real   scalar	todo
)
{
	real matrix	H0			// ignored
	real scalar	doCns
	pragma unset H0

	doCns = opt__doCns(S)
	if (doCns) {
		opt__cns_off(S, todo>0)
	}
	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.weights,S.by_weights,
		S.value,S.gradient,H0,
		S.value_v,S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (doCns) {
		opt__cns_on(S, todo>0)
	}
	if (todo != 2 | missing(S.value)) return(0)

	return(opt__dfp(S))
}

`Errcode' opt__eval_dfp_v2(
	`OptStruct'	S,
	real   scalar	todo
)
{
	return(opt__eval_dfp_v1(S, todo))
}

void opt__userprolog(`OptStruct' S)
{
	if (S.userprolog == `OPT_userprolog_default') {
		return
	}
	if (S.hasCns) {
		opt__cns_off(S, 0)
	}
	(*S.callprolog)(S.userprolog,S.arglist,S.params,S.value)
	if (S.hasCns) {
		opt__cns_on(S, 0)
	}
}

void opt__userprolog2(`OptStruct' S, real scalar do_cns)
{
	real	scalar	value

	if (S.userprolog2 == `OPT_userprolog2_default') {
		return
	}
	if (do_cns) {
		opt__cns_off(S, 2)
	}
	value = S.value
	(*S.callprolog)(S.userprolog2,S.arglist,S.params,value)
	if (do_cns) {
		opt__cns_on(S, 2)
	}
}

`Errcode' opt__eval(
	`OptStruct'	S,
	real	scalar	todo,
	real	scalar	do_cns
)
{
	`Errcode'	ec

	if (todo == 2) {
		opt__userprolog2(S, do_cns)
	}

	if (do_cns) {
		if (!S.holdCns) {
			opt__cns_off(S, todo)
		}
	}

	if (S.use_deriv) {
		opt__link(S)
	}
	ec = (*S.eval)(S,todo)
	if (S.use_deriv) {
		opt__unlink(S)
	}
	if (ec) return(ec)

	if (do_cns) {
		if (!S.holdCns) {
			opt__cns_on(S, todo)
		}
	}
	return(0)
}

/*STATIC*/ void opt__eval_nm(
	`OptStruct' S,
	real rowvector	params,
	real scalar	value)
{
	if (S.hasCns) {
		params = params*S.T'+S.a
	}
	if (S.evaltype == `OPT_evaltype_d') {
		(*S.calluser)(
			S.user,
			S.arglist,
			S.minimize,
			0,
			params,
			value,
			S.gradient,
			S.H
		)
	}
	else if (S.evaltype == `OPT_evaltype_v') {
		real colvector	v_v
		real matrix	g_v
		pragma unset v_v
		pragma unset g_v
		(*S.calluser)(
			S.user,
			S.arglist,
			S.minimize,
			0,
			params,
			S.weights,
			S.by_weights,
			value,
			S.gradient,
			S.H,
			v_v,
			g_v
		)
	}
	else if (S.evaltype == `OPT_evaltype_q') {
		value = S.value
		(*S.calluser)(
			S.user,
			S.arglist,
			0,
			params,
			S.value_v,
			S.gradient_v
		)
		opt__q_value(S)
		swap(value, S.value)
	}
	else  {
		real matrix	g_e
		pragma unset g_e
		(*S.calluser)(
			S.user,
			S.arglist,
			S.minimize,
			0,
			params,
			value,
			S.gradient,
			S.H,
			.,
			g_e
		)
	}
	opt__cnt_eval(S,0,value)
	if (S.hasCns) {
		params = (params-S.a)*S.T
	}
}

`Errcode' opt__eval_nm_e2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nm_d0(S,todo))
}

`Errcode' opt__eval_nm_e1(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nm_d0(S,todo))
}

`Errcode' opt__eval_nm_d2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nm_d0(S,todo))
}

`Errcode' opt__eval_nm_d1(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nm_d0(S,todo))
}

`Errcode' opt__eval_nm_d0(`OptStruct' S, real scalar todo)
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
		S.H
	)
	opt__cnt_eval(S,0,0)
	return(0)
}

`Errcode' opt__eval_nm_v2(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nm_v0(S,todo))
}

`Errcode' opt__eval_nm_v1(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nm_v0(S,todo))
}

`Errcode' opt__eval_nm_v0(`OptStruct' S, real scalar todo)
{
	pragma unset todo
	(*S.calluser)(
		S.user,
		S.arglist,
		S.minimize,
		0,
		S.params,
		S.weights,
		S.by_weights,
		S.value,
		S.gradient,
		S.H,
		S.value_v,
		S.gradient_v
	)
	opt__cnt_eval(S,0,0)
	return(0)
}

`Errcode' opt__eval_nm_q1(`OptStruct' S, real scalar todo)
{
	return(opt__eval_nm_q0(S,todo))
}

`Errcode' opt__eval_nm_q0(`OptStruct' S, real scalar todo)
{
	pragma unset todo
	(*S.calluser)(
		S.user,
		S.arglist,
		0,
		S.params,
		S.value_v,
		S.gradient_v
	)
	opt__cnt_eval(S,0,0)
	return(0)
}

`Errcode' opt__eval_nr_d0(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 2)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_Hessian(S.D, S.H)

	return(0)
}

`Errcode' opt__eval_nr_d1debug(
	`OptStruct'	S,
	real   scalar	todo
)
{
	return(opt__eval_nr_d2debug(S, todo))
}

`Errcode' opt__eval_nr_d1(
	`OptStruct'	S,
	real   scalar	todo
)
{
	real scalar	dim, eps, h, i
	real rowvector	p_alt, ui, gp, gm
	real scalar	doCns
	real scalar	dimCns
	real scalar	v0			// ignored
	real matrix	H0			// ignored
	pragma unset v0
	pragma unset H0

	doCns = opt__doCns(S)
	if (doCns) {
		opt__cns_off(S, todo>0)
	}
	dim	= S.dim
	H0	= J(dim,dim,.)

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.value,S.gradient,H0)
	opt__cnt_eval(S,todo>0,S.value)
	if (doCns) {
		opt__cns_on(S, todo>0)
	}
	if (todo != 2 | missing(S.value)) {
		return(0)
	}

	S.dot_type = "input"
	eps	= 1e-4
	if (doCns) {
		dimCns	= cols(S.params)
		S.H	= J(dimCns,dimCns,.)
		gp	= J(1,dim,.)
		gm	= J(1,dim,.)
		eps	= 1e-4
		ui	= J(1,dimCns,0)
		for (i=1; i<=dimCns; i++) {
			h	= (abs(S.params[i]) + eps)*eps
			ui[i]	= h
	
			p_alt	= (S.params + ui)*S.T' + S.a
			(*S.calluser)(S.user,S.arglist,S.minimize,
				1,p_alt,v0,gp,H0)
			opt__cnt_eval(S,1,v0)
	
			p_alt	= (S.params - ui)*S.T' + S.a
			(*S.calluser)(S.user,S.arglist,S.minimize,
				1,p_alt,v0,gm,H0)
			opt__cnt_eval(S,1,v0)
			S.H[i,] = ((gp - gm)*S.T)/(2*h)
	
			ui[i]	= 0
		}
	}
	else {
		S.H	= J(dim,dim,.)
		gp	= J(1,dim,.)
		gm	= J(1,dim,.)
		for (i=1; i<=dim; i++) {
			h = (abs(S.params[i]) + eps)*eps
			p_alt    = S.params
			p_alt[i] = S.params[i] + h
			(*S.calluser)(S.user,S.arglist,S.minimize,
				1,p_alt,v0,gp,H0)
			opt__cnt_eval(S,1,v0)
	
			p_alt[i] = S.params[i] - h
			(*S.calluser)(S.user,S.arglist,S.minimize,
				1,p_alt,v0,gm,H0)
			opt__cnt_eval(S,1,v0)
			S.H[i,] = (gp - gm)/(2*h)
		}
	}
	S.H = (S.H + S.H')/2
	return(0)
}

`Errcode' opt__eval_nr_d2debug(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec

	if (S.hasCns) {
		if (cols(S.params) == S.dim) {
			opt__cns_on(S,0)
		}
	}

	// call d0 method, and exit if no derivatives were requested
	ec = opt__eval_nr_d0(S, todo)
	if (ec) return(ec)

	if (S.hasCns) {
		if (cols(S.params) != S.dim) {
			opt__cns_off(S,todo)
		}
	}

	if (todo == 0) return(0)

	real scalar	dim
	real scalar	v
	real rowvector	p, g
	real matrix	H
	pragma unset v

	dim	= S.dim
	p	= S.params
	g	= J(1,dim,.)
	H	= J(dim,dim,.)
	// call user to compute some derivatives to compare with d0
	if (S.evaltype_f == "d2debug") {
		(*S.calluser)(S.user,S.arglist,S.minimize,todo,p,v,g,H)
		if (S.negH & todo == 2) {
			_negate(H)
		}
	}
	else {
		(*S.calluser)(S.user,S.arglist,S.minimize,todo>0,p,v,g,H)
	}
	opt__cnt_eval(S,todo,v)

	opt__eval_nr_debug_report(S,todo,p,v,g,H)
	return(0)
}

`Errcode' opt__eval_nr_d2(
	`OptStruct'	S,
	real   scalar	todo
)
{
	(*S.calluser)(
		S.user,
		S.arglist,
		S.minimize,
		todo,
		S.params,
		S.value,
		S.gradient,
		S.H
	)
	if (S.negH & todo == 2) {
		_negate(S.H)
	}
	opt__cnt_eval(S,todo,S.value)
	return(0)
}

void opt__eval_nr_debug_report(
	`OptStruct' S,
	real scalar	todo,
	real rowvector	p,
	real scalar	v,
	real matrix	g,
	real matrix	H

)
{
	string scalar	evaltype
	real scalar	dim, trace

	evaltype= S.evaltype_user
	dim	= S.dim
	trace	= S.trace

	displayas("txt")
	if (trace) {
		if (!S.trace_step & !S.trace_params) {
			printf("\n")
		}
		printf("%s:  Begin derivative-comparison report {hline}\n",
			evaltype)
	}

	// check the parameter vector
	if (mreldif(p,S.params) != 0) {
		printf("%s:  Warning:  the parameter vector was damaged\n",
			evaltype)
		printf("\n%s:  Parameter vector was\n", evaltype)
		printf("\n")
		_matrix_list(
			S.params,
			J(0,2,""),
			(cols(S.params)==S.dim
				? *S.stripes[3] : J(0,2,"")),
			"%9.0g")
		printf("\n%s:  After calling your evaluator, " +
		       "it changed to\n", evaltype)
		printf("\n")
		_matrix_list(
			p,
			J(0,2,""),
			(cols(p)==S.dim
				? *S.stripes[3] : J(0,2,"")),
			"%9.0g")
		printf("\n")
	}

	// check the value
	if (v != S.value) {
		printf("%s:  Warning:  " +
			"the evaluator returned different values\n", evaltype)
		printf("%s:  First it returned {res:%10.0g}\n",
			evaltype,
			(S.minimize ? -S.value : S.value))
		printf("%s:  Then it returned  {res:%10.0g}\n",
			evaltype,
			(S.minimize ? -v : v))
	}
	if (missing(S.value) & missing(v)) {
		printf("%s:  evaluator returned missing value\n", evaltype)
		printf("%s:  End derivative-comparison report {hline}\n\n",
			evaltype)
		return
	}

	// check the gradient vector
	if (missing(g) | length(g) == 0) {
		printf("%s:  Warning:  " +
			"evaluator did not compute gradient vector\n",
			evaltype)
	}
	else if (trace) {
		if (cols(S.gradient) == cols(g)
		 &  rows(S.gradient) == rows(g)) {
			printf("%s:  mreldif(gradient vectors) = {res:%9.0g}\n",
				evaltype, mreldif(S.gradient,g))
			if (S.trace_gradient) {
				printf("\n%s:  evaluator calculated " +
					"gradient:\n",
					evaltype)
				_matrix_list(
					(S.minimize ? -g : g),
					J(0,2,""),
					(cols(g)==S.dim
						? *S.stripes[3]
						: J(0,2,"")),
					"%9.0g")

				printf("\n%s:  numerically calculated " +
					"gradient (used for stepping):\n",
					evaltype)
				_matrix_list(
					(S.minimize ? -S.gradient : S.gradient),
					J(0,2,""),
					(cols(S.gradient)==S.dim
						? *S.stripes[3]
						: J(0,2,"")),
					"%9.0g")
				printf("\n%s:  relative differences:\n",
					evaltype)
				_matrix_list(
					reldif(S.gradient,g),
					J(0,2,""),
					(cols(S.gradient)==S.dim
						? *S.stripes[3]
						: J(0,2,"")),
					"%9.0g")
				printf("\n")
			}
		}
		else {
			printf("%s:  Warning:  evaluator computed a " +
				"{res:%1.0f} x {res:%1.0f} gradient matrix\n",
				evaltype, rows(g), cols(g))
			printf("%s:  gradient vector should be " +
				"{res:1} x {res:%1.0f} matrix\n",
				evaltype, dim)
			if (S.trace_gradient) {
				printf("\n%s:  evaluator calculated " +
					"gradient:\n",
					evaltype)
				_matrix_list(
					(S.minimize ? -g : g),
					J(0,2,""),
					(cols(g)==S.dim
						? *S.stripes[3]
						: J(0,2,"")),
					"%9.0g")

				printf("\n%s:  numerically calculated " +
					"gradient (used for stepping):\n",
					evaltype)
				_matrix_list(
					(S.minimize ? -S.gradient : S.gradient),
					J(0,2,""),
					(cols(S.gradient)==S.dim
						? *S.stripes[3]
						: J(0,2,"")),
					"%9.0g")
				printf("\n")
			}
		}
	}
	if (todo != 2 |
	    evaltype == `"d1debug"' |
	    evaltype == `"v1debug"' |
	    evaltype == `"e1debug"') {
		if (trace) {
			printf(
			"%s:  End derivative-comparison report {hline}\n",
				evaltype)
			if (trace > 1) {
				printf("\n")
			}
		}
		return
	}

	// check the Hessian matrix
	if (missing(H) | length(H) == 0) {
		printf("%s:  Warning:  " +
			"evaluator did not compute Hessian matrix\n",
			evaltype)
	}
	else if (trace) {
		if (cols(S.H) == cols(H)
		 &  rows(S.H) == rows(H)) {
			printf("%s:  mreldif(Hessian matrices) = {res:%9.0g}\n",
				evaltype, mreldif(S.H,H))
			if (S.trace_hessian) {
				printf("\n%s:  evaluator calculated " +
					"Hessian:\n",
					evaltype)
				_matrix_list(
					(S.minimize ? -H : H),
					(cols(H)==S.dim
						? *S.stripes[2]
						: J(0,2,"")),
					(cols(H)==S.dim
						? *S.stripes[3]
						: J(0,2,"")),
					"%9.0g")
				printf("\n%s:  numerically calculated " +
					"Hessian (used for stepping):\n",
					evaltype)
				_matrix_list(
					(S.minimize ? -S.H : S.H),
					(cols(S.H)==S.dim
						? *S.stripes[2]
						: J(0,2,"")),
					(cols(S.H)==S.dim
						? *S.stripes[3]
						: J(0,2,"")),
					"%9.0g")
				printf("\n%s:  relative difference:\n",
					evaltype)
				_matrix_list(
					reldif(S.H,H),
					(cols(S.H)==S.dim
						? *S.stripes[2]
						: J(0,2,"")),
					(cols(S.H)==S.dim
						? *S.stripes[3]
						: J(0,2,"")),
					"%9.0g")
				printf("\n")
			}
		}
		else {
			printf("%s:  Warning:  evaluator computed a " +
				"{res:%1.0f} x {res:%1.0f} Hessian matrix\n",
				evaltype, rows(H), cols(H))
			printf("%s:  Hessian should be " +
				"{res:%1.0f} x {res:%1.0f} " +
				"matrix\n", evaltype, dim, dim)
		}
	}
	if (trace) {
		printf("%s:  End derivative-comparison report {hline}\n",
			evaltype)
		if (trace > 1) {
			printf("\n")
		}
	}
}

void opt__eval_gn_debug_report(
	`OptStruct' S,
	real rowvector	p,
	real colvector	v_v,
	real matrix	g_v

)
{
	string scalar	evaltype
	real scalar	dim, trace

	evaltype= S.evaltype_user
	dim	= S.dim
	trace	= S.trace

	displayas("txt")
	if (trace) {
		if (!S.trace_step & !S.trace_params) {
			printf("\n")
		}
		printf("%s:  Begin derivative-comparison report {hline}\n",
			evaltype)
	}

	// check the parameter vector
	if (mreldif(p,S.params) != 0) {
		printf("%s:  Warning:  the parameter vector was damaged\n",
			evaltype)
		printf("\n%s:  Parameter vector was\n", evaltype)
		printf("\n")
		_matrix_list(
			S.params,
			J(0,2,""),
			(cols(S.params)==S.dim
				? *S.stripes[3] : J(0,2,"")),
			"%9.0g")
		printf("\n%s:  After calling your evaluator, " +
		       "it changed to\n", evaltype)
		printf("\n")
		_matrix_list(
			p,
			J(0,2,""),
			(cols(p)==S.dim
				? *S.stripes[3] : J(0,2,"")),
			"%9.0g")
		printf("\n")
	}

	// check the value
	if (any(v_v :!= S.value_v)) {
		printf("%s:  Warning:  " +
			"the evaluator returned different values\n", evaltype)
	}
	if (missing(S.value_v) & missing(v_v)) {
		printf("%s:  evaluator returned missing values\n", evaltype)
		printf("%s:  End derivative-comparison report {hline}\n\n",
			evaltype)
		return
	}

	// check the gradient vector
	if (missing(g_v) | length(g_v) == 0) {
		printf("%s:  Warning:  " +
			"evaluator did not compute gradient vector\n",
			evaltype)
	}
	else if (trace) {
		if (cols(S.gradient_v) == cols(g_v)
		 &  rows(S.gradient_v) == rows(g_v)) {
			printf("%s:  mreldif(gradient vectors) = {res:%9.0g}\n",
				evaltype, mreldif(S.gradient_v,g_v))
		}
		else {
			printf("%s:  Warning:  evaluator computed a " +
				"{res:%1.0f} x {res:%1.0f} gradient matrix\n",
				evaltype, rows(g_v), cols(g_v))
			printf("%s:  gradient vector should be " +
				"{res:%1.0f} x {res:%1.0f} matrix\n",
				evaltype, rows(g_v), dim)
		}
	}

	if (trace) {
		printf("%s:  End derivative-comparison report {hline}\n",
			evaltype)
		if (trace > 1) {
			printf("\n")
		}
	}
}

/*STATIC*/ void opt__q_value(`OptStruct' S)
{
	if (missing(S.value_v)) {
		S.value	= .
		return
	}
	if (S.gn_A == `OPT_gn_A_default') {
		if (S.wtype == `OPT_wtype_none') {
			S.value = -cross(S.value_v, S.value_v)
		}
		else {
			S.value = -cross(S.value_v, S.weights, S.value_v)
		}
		return
	}
	S.value = -cross(S.value_v, cross((*S.gn_A), S.value_v))
}

/*STATIC*/ void opt__q_deriv(`OptStruct' S)
{
	if (missing(S.gradient_v)) {
		S.value = .
		return
	}
	if (S.gn_A == `OPT_gn_A_default') {
		if (S.wtype == `OPT_wtype_none') {
			S.gradient = -cross(S.value_v, S.gradient_v)
			S.H	   = -cross(S.gradient_v, S.gradient_v)
		}
		else {
			S.gradient = -cross(S.value_v,
					    S.weights,
					    S.gradient_v)
			S.H	   = -cross(S.gradient_v,
					    S.weights,
					    S.gradient_v)
		}
		return
	}
	S.gradient = -cross(cross((*S.gn_A), S.value_v), S.gradient_v)
	S.H	   = -cross(S.gradient_v, cross((*S.gn_A), S.gradient_v))
}

`Errcode' opt__eval_gn_q0(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'		ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	_deriv_result_values(S.D, S.value_v)
	opt__q_value(S)
	if (todo == 0 | missing(S.value)) {
		return(0)
	}
	// swap vector values back for computing derivatives
	_deriv_result_values(S.D, S.value_v)

	S.dot_type = "result"
	ec = _deriv(S.D, 1)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	_deriv_result_values(S.D, S.value_v)
	opt__q_value(S)
	if (missing(S.value)) return(0)
	_deriv_result_scores(S.D, S.gradient_v)
	opt__q_deriv(S)
	return(0)
}

`Errcode' opt__eval_gn_q1(
	`OptStruct'	S,
	real   scalar	todo
)
{
	(*S.calluser)(S.user,S.arglist,
		todo>0,S.params,
		S.value_v,S.gradient_v)
	opt__q_value(S)
	opt__cnt_eval(S,todo>0,S.value)
	if (todo == 0 | missing(S.value)) return(0)
	opt__q_deriv(S)
	return(0)
}

`Errcode' opt__eval_gn_q1debug(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'		ec

	// call q0 method, and exit if no derivatives were requested
	ec = opt__eval_gn_q0(S, todo)
	if (ec) return(ec)
	if (todo == 0) return(0)

	real rowvector	p
	real colvector	v_v
	real matrix	g_v
	pragma unset v_v
	pragma unset g_v

	p = S.params
	(*S.calluser)(S.user,S.arglist,todo>0,p,v_v,g_v)
	opt__cnt_eval(S,todo>0,S.value)

	opt__eval_gn_debug_report(S,p,v_v,g_v)
	return(0)
}

`Errcode' opt__eval_nr_v0(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec

	deriv_init_params(S.D, S.params)
	ec = _deriv(S.D, 0)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
	}
	S.value = deriv_result_value(S.D)

	if (todo == 0 | missing(S.value)) return(0)

	S.dot_type = "result"
	ec = _deriv(S.D, 2)
	if (ec) {
		S.errorcode = ec
		S.errortext = deriv_result_errortext(S.D)
		opt__errorhandler(S)
		return(ec)
 	}
	_deriv_result_gradient(S.D, S.gradient)
	_deriv_result_scores(S.D, S.gradient_v)
	_deriv_result_Hessian(S.D, S.H)

	return(0)
}

`Errcode' opt__eval_nr_v1debug(
	`OptStruct'	S,
	real   scalar	todo
)
{
	return(opt__eval_nr_v2debug(S, todo))
}

`Errcode' opt__eval_nr_v1(
	`OptStruct'	S,
	real   scalar	todo
)
{
	real scalar	dim, eps, h, i
	real rowvector	p_alt, ui, gp, gm
	real matrix	gp_v, gm_v
	real scalar	doCns
	real scalar	dimCns
	real scalar	v0			// ignored
	real colvector	v0_v			// ignored
	real matrix	H0			// ignored
	pragma unset gm_v
	pragma unset gp_v
	pragma unset v0
	pragma unset v0_v
	pragma unset H0

	doCns = opt__doCns(S)
	if (doCns) {
		opt__cns_off(S, todo>0)
	}
	dim	= S.dim
	H0	= J(dim,dim,.)

	(*S.calluser)(S.user,S.arglist,S.minimize,
		todo>0,S.params,S.weights,S.by_weights,
		S.value,S.gradient,H0,
		S.value_v,S.gradient_v)
	opt__cnt_eval(S,todo>0,S.value)
	if (doCns) {
		opt__cns_on(S, todo>0)
	}
	if (todo != 2 | missing(S.value)) return(0)

	S.dot_type = "input"
	eps	= 1e-4
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
				1,p_alt,S.weights,S.by_weights,
				v0,gp,H0,v0_v,gp_v)
			opt__cnt_eval(S,1,v0)
	
			p_alt	= (S.params - ui)*S.T' + S.a
			(*S.calluser)(S.user,S.arglist,S.minimize,
				1,p_alt,S.weights,S.by_weights,
				v0,gm,H0,v0_v,gm_v)
			opt__cnt_eval(S,1,v0)
			S.H[i,] = ((gp - gm)*S.T)/(2*h)
	
			ui[i]	= 0
		}
		S.H = (S.H + S.H')/2
	}
	else {
		S.H	= J(dim,dim,.)
		p_alt	= J(1,dim,.)
		gp	= J(1,dim,.)
		gm	= J(1,dim,.)
		for (i=1; i<=dim; i++) {
			h = (abs(S.params[i]) + eps)*eps
			p_alt    = S.params
			p_alt[i] = S.params[i] + h
			(*S.calluser)(S.user,S.arglist,S.minimize,
				1,p_alt,S.weights,S.by_weights,
				v0,gp,H0,v0_v,gp_v)
			opt__cnt_eval(S,1,v0)
	
			p_alt[i] = S.params[i] - h
			(*S.calluser)(S.user,S.arglist,S.minimize,
				1,p_alt,S.weights,S.by_weights,
				v0,gm,H0,v0_v,gm_v)
			opt__cnt_eval(S,1,v0)
			S.H[i,] = (gp - gm)/(2*h)
		}
	}
	S.H = (S.H + S.H')/2
	return(0)
}

`Errcode' opt__eval_nr_v2debug(
	`OptStruct'	S,
	real   scalar	todo
)
{
	`Errcode'	ec

	if (S.hasCns) {
		if (cols(S.params) == S.dim) {
			opt__cns_on(S,0)
		}
	}

	// call d0 method, and exit if no derivatives were requested
	ec = opt__eval_nr_v0(S, todo)
	if (ec) return(ec)

	if (S.hasCns) {
		if (cols(S.params) != S.dim) {
			opt__cns_off(S,todo)
		}
	}

	if (todo == 0) return(0)

	real scalar	dim
	real scalar	v
	real colvector	v_v
	real rowvector	p, g
	real matrix	g_v
	real matrix	H
	pragma unset v
	pragma unset v_v
	pragma unset g_v

	dim	= S.dim
	p	= S.params
	g	= J(1,dim,.)
	H	= J(dim,dim,.)
	// call user to compute some derivatives to compare with d0
	if (S.evaltype_f == "v2debug") {
		(*S.calluser)(S.user,S.arglist,S.minimize,
			todo,p,S.weights,S.by_weights,
			v,g,H,v_v,g_v)
		if (S.negH & todo == 2) {
			_negate(H)
		}
	}
	else {
		(*S.calluser)(S.user,S.arglist,S.minimize,
			todo>0,p,S.weights,S.by_weights,
			v,g,H,v_v,g_v)
	}
	opt__cnt_eval(S,todo,v)

	opt__eval_nr_debug_report(S,todo,p,v,g,H)
	return(0)
}

`Errcode' opt__eval_nr_v2(
	`OptStruct'	S,
	real   scalar	todo
)
{
	(*S.calluser)(
		S.user,
		S.arglist,
		S.minimize,
		todo,
		S.params,
		S.weights,
		S.by_weights,
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

void opt__init(`OptStruct' S)
{
	// items for the optimizer status
	S.valid		= `OPT_valid_default'
	S.debugeval	= `OPT_debugeval_default'
	S.eval		= `OPT_eval_default'
	S.dim		= `OPT_dim_default'
	S.concave	= `OPT_concave_default'
	S.backup	= `OPT_backup_default'
	S.D		= deriv_init()
	S.linked	= 0
	S.use_deriv	= 0
	S.userscale	= `OPT_userscale_default'
	S.constraints	= `OPT_constraints_default'
	S.T		= `OPT_T_default'
	S.a		= `OPT_a_default'
	S.eigen		= `OPT_eigen_default'

	S.reset		= `OPT_reset_default'

	// items with output routines for the user
	S.value		= `OPT_value_default'
	S.value_v	= `OPT_value_v_default'
	S.params	= `OPT_params_default'
	S.gradient	= `OPT_gradient_default'
	S.gradient_v	= `OPT_gradient_v_default'
	S.H		= `OPT_H_default'
	S.iter		= `OPT_iter_default'
	S.converged	= `OPT_converged_default'
	S.convtol	= `OPT_convtol_default'
	S.log		= `OPT_log_default'
	S.evalcount	= `OPT_evalcount_default'
	S.cnt0_evals	= `OPT_cnt_evals_default'
	S.cnt1_evals	= `OPT_cnt_evals_default'
	S.cnt2_evals	= `OPT_cnt_evals_default'
	S.cnt__evals	= `OPT_cnt_evals_default'

	// items for the simplex used by NM
	S.simplex	= `OPT_simplex_default'
	S.simvals	= `OPT_simvals_default'
	S.simorder	= `OPT_simorder_default'
	S.simnodes	= `OPT_simnodes_default'

	S.oerrorcode	= `OPT_oerrorcode_default'

	S.verbose	= `OPT_verbose_default'
	S.ucall		= `OPT_ucall_default'
	S.invert	= `OPT_invert_default'

	S.gn_A		= `OPT_gn_A_default'
	S.R		= robust_init()

	S.doopt		= `OPT_doopt_default'

	// WARNING:  This stores the address of 'S.weights', so it is OK to
	// make changes to 'S.weight'; however, take special note that the
	// 'robust' object will need an unadjusted weight vector for subpop
	// estimation while optimize will need one that sets the weight values
	// to 0 outside the subpop.

	robust_init_weight(S.R, S.weights)
}

real scalar opt__init_cycle(`OptStruct' S, string rowvector techlist)
{
	string	scalar	name
	real	scalar	len
	real	scalar	i, k, ck

	len	= cols(techlist)
	S.cycle_names	= J(1,len,"")
	S.cycle_counts	= J(1,len,`OPT_cycle_counts_default')

	i = 1
	k = 0
	while (i<=len) {
		k++
		name = sprintf("opt__loop_%s()",
			S.cycle_names[k] = techlist[i])
		S.loop = findexternal(name)
		if (S.loop == `OPT_loop_default') {
			S.errorcode = `Errcode_bad_tech'
			S.errortext = sprintf(
				"technique '%s' not found",
				techlist[i])
			opt__errorhandler(S)
			return(S.errorcode)
		}
		// check for an optional iteration counter
		i++
		if (i<=len) {
			ck = strtoreal(techlist[i])
			if (!missing(ck)) {
				if (floor(ck) != ck) {
					errprintf(
					"'%s' found where integer expected",
						techlist[i])
					exit(3498)
				}
				else if (ck < 0) {
					errprintf(
					"negative integers not allowed")
					exit(3498)
				}
				S.cycle_counts[k] = ck
				i++
			}
		}
	}
	S.cycle_names	= S.cycle_names[|1\k|]
	S.cycle_counts	= S.cycle_counts[|1\k|]
	if (k > 1) {
		S.loop = &opt__loop_cycle()
	}
	return(0)
}

/*STATIC*/ void opt__log_value(`OptStruct' S)
{
	real	scalar	i

	i	= mod(S.iter, 20) + 1
	if (missing(S.value)) {
		S.log[i]	= 0
	}
	else	S.log[i]	= S.value
	S.iter = S.iter + 1
}

`Errcode' opt__loop(`OptStruct' S)
{
	if (S.fullRankCns) {
		`Errcode' ec
		ec = opt__eval_fullRankCns(S)
		return(ec)
	}
	return((*S.loop)(S))
}

/*STATIC*/ `Errcode' opt__looputil_prolog(`OptStruct' S)
{
	S.reset		= `OPT_reset_default'
	S.iter		= `OPT_iter_default'
	S.convtol	= `OPT_convtol_default'
	S.converged	= `OPT_converged_default'
	S.hessian	= `OPT_hessian_default'
	S.k_notconcave	= 0

	opt__dots(S)

	if (S.hasCns) {
		S.params = S.params*S.T
		opt__cns_off(S, 0)
		if (S.technique == `OPT_technique_nm') {
			opt__cns_on(S, 0)
		}
		else {
			opt__cns_on(S, 2)
		}
	}

	if (S.trace >= `OPT_tracelvl_step') {
		opt__dots(S)
		displayas("txt")
		printf("{hline}\n")
		printf("%s %f:\n", S.iter_id, 0)

		if (S.trace_params) {
			real rowvector	myp
			myp = S.params
			if (cols(myp) != S.dim) {
				myp = myp*S.T' + S.a
			}

			printf("Parameter vector:\n")
			_matrix_list(
				myp,
				J(0,2,""),
				(*S.stripes[3]),
				"%9.0g")
			printf("\n")
		}
	}

	return(0)
}

/*STATIC*/ `Errcode' opt__looputil_epilog(`OptStruct' S)
{
	opt__userprolog(S)

	if (S.H != `OPT_H_default') {
		real matrix invH
		if (S.invert) {
			invH = invsym(-S.H)
		}
		else {
			invH = S.H
		}
		S.concave = opt__check_concave(S.H,invH)
	}

	opt__dots(S)
	opt__print_log(S)

	if (S.hasCns) {
		if (S.technique == `OPT_technique_nm') {
			opt__cns_off(S, 0)
		}
		else {
			opt__cns_off(S, 2)
		}
	}

	if (S.trace > `OPT_tracelvl_tol') {
		printf("{hline}\n")
	}

	if (!S.converged & S.warn) {
		if (S.maxiter == c("maxiter")) {
			errprintf("convergence not achieved\n")
		}
		else {
			displayas("txt")
			printf("convergence not achieved\n")
		}
	}

	return(0)
}

`Errcode' opt__looputil_iter0_common(`OptStruct' S)
{
	`Errcode'	ec

	ec = opt__eval(S,2,S.hasCns)
	if (ec) return(ec)
	if (missing(S.value)) {
		if (S.hasCns) {
			opt__cns_off(S, 1)
		}
		S.errorcode = `Errcode_notfeasible'
		S.errortext = `Errtext_notfeasible'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	// log value and step iteration count
	opt__log_value(S)

	// turn off weak goals used by d0 and v0 in iteration 0
	deriv_init_weak_goals(S.D, 0)

	// save the value from iteration 0
	S.v0		= S.value
	S.invert	= `OPT_onoff_on'
	return(0)
}

`Errcode' opt__looputil_iter0_bfgs(`OptStruct' S)
{
	return(opt__looputil_iter0_dfp(S))
}

real scalar opt__iter_check(`OptStruct' S, real scalar iter)
{
	if (S.converged) {
		return(0)
	}
	if (iter > S.maxiter) {
		return(0)
	}
	if (S.k_notconcave >= S.notconcave) {
		return(0)
	}
	return(1)
}

`Errcode' opt__loop_bfgs(`OptStruct' S)
{
	return(opt__loop_dfp(S))
}

`Errcode' opt__looputil_prolog_bhhh(`OptStruct' S)
{
	// check for evaltypes not allowed with BHHH
	if (S.evaltype == `OPT_evaltype_d') {
		S.errorcode = `Errcode_bhhh_req'
		S.errortext = sprintf(
			"%s evaluators are not allowed with the bhhh technique",
			S.evaltype_user)
		opt__errorhandler(S)
		return(S.errorcode)
	}
	return(0)
}

`Errcode' opt__looputil_iter0_bhhh(`OptStruct' S)
{
	if (S.hasCns) {
		opt__set_holdCns(S, 0)
	}
	return(opt__looputil_iter0_common(S))
}

`Errcode' opt__loop_bhhh(`OptStruct' S)
{
	`Errcode'	ec
	real scalar	iter

	ec = opt__looputil_prolog(S)
	if (ec) return(ec)

	ec = opt__looputil_iter0_bhhh(S)
	if (ec) return(ec)

	for (iter=1; opt__iter_check(S, iter); ++iter) {
		opt__dots(S)
		ec = opt__looputil_step(S)
		if (ec) return(ec)
	}

	ec = opt__looputil_epilog(S)
	if (ec) return(ec)

	return(0)
}

`Errcode' opt__looputil_prolog_cycle(`OptStruct' S)
{
	`Errcode'		ec
	real	scalar		i, k
	string	scalar		name, oldname
	pointer(function)	pf

	k = cols(S.cycle_names)
	S.cycle_evals	= J(1,k,NULL)
	S.cycle_switcher= J(1,k,NULL)
	oldname = S.cycle_names[k]
	for (i=1; i<=k; i++) {
		name = sprintf("opt__looputil_prolog_%s()", S.cycle_names[i])
		pf = findexternal(name)
		if (pf != NULL) {
			ec = (*pf)(S)
			if (ec) return(ec)
		}

		if (k != 1) {
			name = sprintf("opt__looputil_switch_%s_%s()",
				oldname, S.cycle_names[i])
			S.cycle_switcher[i] = findexternal(name)
			if (S.cycle_switcher[i] != NULL) {
				ec = (*S.cycle_switcher[i])(S)
				if (ec) return(ec)
			}
		}
		oldname = S.cycle_names[i]

		name = sprintf("opt__eval_%s_%s()",
			S.cycle_names[i],
			S.evaltype_f)
		pf = findexternal(name)
		if (pf == `OPT_eval_default') {
			S.errorcode = `Errcode_no_eval'
			S.errortext = sprintf(
"type %s evaluators are not allowed with technique %s",
				optimize_init_evaluatortype(S),
				S.cycle_names[i])
			opt__errorhandler(S)
			return(S.errorcode)
		}
		S.cycle_evals[i] = pf
	}
	return(0)
}

`Errcode' opt__looputil_iter0_cycle(`OptStruct' S)
{
	`Errcode'		ec
	pointer(function)	pf

	pf = findexternal(sprintf("opt__looputil_iter0_%s()", S.cycle_names[1]))
	if (pf != NULL) {
		S.iter = `OPT_iter_default'
		ec = (*pf)(S)
		if (ec) return(ec)

		if (S.cycle_names[1] != "dfp" & S.cycle_names[1] != "bfgs") {
			// for 'bfgs' and 'dfp'
			if (S.hasCns) {
				opt__cns_off(S, 1)
			}
			S.oldparams	= S.params
			S.oldgrad	= S.gradient
			if (S.hasCns) {
				opt__cns_on(S, 1)
			}
		}
	}
	return(0)
}

`Errcode' opt__looputil_epilog_cycle(`OptStruct' S)
{
	`Errcode'		ec
	real	scalar		i, k
	string	scalar		name
	pointer(function)	pf

	k = cols(S.cycle_names)
	for (i=1; i<=k; i++) {
		name = sprintf("opt__looputil_epilog_%s()", S.cycle_names[i])
		pf = findexternal(name)
		if (pf != NULL) {
			ec = (*pf)(S)
			if (ec) return(ec)
		}
	}
	return(0)
}

// NOTE: no need for switcher from a technique to itself

`Errcode' opt__looputil_switch_bfgs_bhhh(`OptStruct' S)
{
	return(opt__looputil_switch_bfgs_nr(S))
}

// NOTE: no need for switcher from 'bfgs' to 'dfp'

`Errcode' opt__looputil_switch_bfgs_gn(`OptStruct' S)
{
	return(opt__looputil_switch_gn_bfgs(S))
}

`Errcode' opt__looputil_switch_bfgs_nm(`OptStruct' S)
{
	return(opt__looputil_switch_nm_bfgs(S))
}

`Errcode' opt__looputil_switch_bfgs_nr(`OptStruct' S)
{
	S.invert	= `OPT_onoff_on'
	if (S.hasCns) {
		opt__set_holdCns(S, 1)
	}
	return(0)
}

`Errcode' opt__looputil_switch_bhhh_bfgs(`OptStruct' S)
{
	return(opt__looputil_switch_nr_dfp(S))
}

`Errcode' opt__looputil_switch_bhhh_dfp(`OptStruct' S)
{
	return(opt__looputil_switch_nr_dfp(S))
}

`Errcode' opt__looputil_switch_bhhh_gn(`OptStruct' S)
{
	return(opt__looputil_switch_gn_bhhh(S))
}

`Errcode' opt__looputil_switch_bhhh_nm(`OptStruct' S)
{
	return(opt__looputil_switch_nm_bhhh(S))
}

// NOTE: no need for switcher from 'bhhh' to 'nr'

`Errcode' opt__looputil_switch_dfp_bhhh(`OptStruct' S)
{
	return(opt__looputil_switch_bfgs_nr(S))
}

// NOTE: no need for switcher from 'dfp' to 'bfgs'

`Errcode' opt__looputil_switch_dfp_gn(`OptStruct' S)
{
	return(opt__looputil_switch_gn_dfp(S))
}

`Errcode' opt__looputil_switch_dfp_nm(`OptStruct' S)
{
	return(opt__looputil_switch_nm_dfp(S))
}

`Errcode' opt__looputil_switch_dfp_nr(`OptStruct' S)
{
	return(opt__looputil_switch_bfgs_nr(S))
}

`Errcode' opt__looputil_switch_gn_bfgs(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques gn and bfgs cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_gn_bhhh(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques gn and bhhh cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_gn_dfp(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques gn and dfp cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_gn_nm(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques gn and nm cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_gn_nr(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques gn and nr cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_nm_bfgs(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques nm and bfgs cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_nm_bhhh(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques nm and bhhh cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_nm_dfp(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques nm and dfp cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_nm_gn(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques nm and gn cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_nm_nr(`OptStruct' S)
{
	S.errorcode = `Errcode_bad_tech_comb'
	S.errortext = "techniques nm and nr cannot be combined"
	opt__errorhandler(S)
	return(S.errorcode)
}

`Errcode' opt__looputil_switch_nr_bfgs(`OptStruct' S)
{
	S.H		= invsym(-S.H)
	S.invert	= `OPT_onoff_off'
	if (S.hasCns) {
		opt__set_holdCns(S, 0)
	}
	return(0)
}

// NOTE: no need for switcher from 'nr' to 'bhhh'

`Errcode' opt__looputil_switch_nr_dfp(`OptStruct' S)
{
	return(opt__looputil_switch_nr_bfgs(S))
}

`Errcode' opt__looputil_switch_nr_gn(`OptStruct' S)
{
	return(opt__looputil_switch_gn_nr(S))
}

`Errcode' opt__looputil_switch_nr_nm(`OptStruct' S)
{
	return(opt__looputil_switch_nm_nr(S))
}

`Errcode' opt__loop_cycle(`OptStruct' S)
{
	`Errcode'		ec
	real	scalar		iter

	ec = opt__looputil_prolog_cycle(S)
	if (ec) return(ec)

	ec = opt__looputil_prolog(S)
	if (ec) return(ec)

	ec = opt__looputil_iter0_cycle(S)
	if (ec) return(ec)

	if (S.trace) {
		displayas("text")
		printf("(setting technique to %s)\n", S.cycle_names[1])
	}

	for (iter=1; opt__iter_check(S, iter); ++iter) {
		opt__dots(S)
		ec = opt__looputil_step(S)
		if (ec) return(ec)
	}

	ec = opt__looputil_epilog_cycle(S)
	if (ec) return(ec)

	ec = opt__looputil_epilog(S)
	if (ec) return(ec)

	return(0)
}

`Errcode' opt__looputil_iter0_dfp(`OptStruct' S)
{
	`Errcode'	ec

	if (S.hasCns) {
		opt__set_holdCns(S, 0)
	}
	ec = opt__looputil_iter0_common(S)
	if (ec) return(ec)
	S.invert	= `OPT_onoff_off'
	return(0)
}

`Errcode' opt__loop_dfp(`OptStruct' S)
{
	`Errcode'	ec
	real scalar	iter

	ec = opt__looputil_prolog(S)
	if (ec) return(ec)

	ec = opt__looputil_iter0_dfp(S)
	if (ec) return(ec)

	for (iter=1; opt__iter_check(S, iter); ++iter) {
		opt__dots(S)
		ec = opt__looputil_step(S)
		if (ec) return(ec)
	}

	ec = opt__looputil_epilog(S)
	if (ec) return(ec)

	return(0)
}

`Errcode' opt__looputil_iter0_nm(`OptStruct' S)
{
	real scalar	newv
	real scalar	simnodes
	real scalar	i

	S.holdCns = 0

	S.concave	= 1
	// S.invert	= 0 // only needed if we use -opt__looputil_epilog()-

	S.simplex	= opt__simplex(S)
	S.simnodes	= rows(S.simplex)
	simnodes	= S.simnodes
	S.simvals	= J(simnodes,1,.)

	pragma unset newv
	for (i=1; i<=simnodes; i++) {
		opt__eval_nm(S, S.simplex[i,], newv)
		S.simvals[i] = newv
	}

	if (missing(S.simvals)) {
		S.errorcode = `Errcode_value_missing'
		S.errortext = `Errtext_value_missing'
		opt__errorhandler(S)
		return(S.errorcode)
		/*NOTREACHED*/
	}

	// starting values are stored in the last row of the simplex
	S.value	= S.simvals[simnodes]

	// log value and step iteration count
	opt__log_value(S)

	if (S.nm_sortstable) {
		S.simorder	= order((S.simvals,(1::S.simnodes)), (1,2))
	}
	else {
		S.simorder	= order(S.simvals, 1)
	}

	// save the value from iteration 0
	S.v0 = S.value

	return(0)
}

`Errcode' opt__loop_nm(`OptStruct' S)
{
	`Errcode'	ec
	real scalar	iter

	ec = opt__looputil_prolog(S)
	if (ec) return(ec)

	ec = opt__looputil_iter0_nm(S)
	if (ec) return(ec)

	for (iter=1; opt__iter_check(S, iter); ++iter) {
		opt__dots(S)
		ec = opt__looputil_nm(S)
		if (ec) return(ec)
	}

	ec = opt__looputil_epilog(S)
	if (ec) return(ec)

	return(0)
}

`Errcode' opt__looputil_iter0_nr(`OptStruct' S)
{
	if (S.hasCns) {
		opt__set_holdCns(S, 1)
	}
	return(opt__looputil_iter0_common(S))
}

`Errcode' opt__looputil_iter0_gn(`OptStruct' S)
{
	`Errcode'	ec

	ec = opt__eval(S,2,S.hasCns)
	if (ec) return(ec)
	if (missing(S.value)) {
		if (S.hasCns) {
			opt__cns_off(S, 1)
		}
		S.errorcode = `Errcode_notfeasible'
		S.errortext = `Errtext_notfeasible'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	// log value and step iteration count
	opt__log_value(S)

	// save the value from iteration 0
	S.v0		= S.value
	S.invert	= `OPT_onoff_on'
	return(0)
}

`Errcode' opt__loop_gn(`OptStruct' S)
{
	`Errcode'	ec
	real scalar	iter

	ec = opt__looputil_prolog(S)
	if (ec) return(ec)

	ec = opt__looputil_iter0_gn(S)
	if (ec) return(ec)

	for (iter=1; opt__iter_check(S, iter); ++iter) {
		opt__dots(S)
		ec = opt__looputil_step(S)
		if (ec) return(ec)
	}

	ec = opt__looputil_epilog(S)
	if (ec) return(ec)

	if (S.holdCns) {
		// Numerical derivatives were taken in the constrained space,
		// so transform the scores back into the unconstrained space.

		S.gradient_v = S.gradient_v*S.T'
	}

	S.hessian	= S.H
	S.invert	= `OPT_onoff_on'
	return(0)
}

`Errcode' opt__loop_nr(`OptStruct' S)
{
	`Errcode'	ec
	real scalar	iter

	ec = opt__looputil_prolog(S)
	if (ec) return(ec)

	ec = opt__looputil_iter0_nr(S)
	if (ec) return(ec)

	for (iter=1; opt__iter_check(S, iter); ++iter) {
		opt__dots(S)
		ec = opt__looputil_step(S)
		if (ec) return(ec)
	}

	ec = opt__looputil_epilog(S)
	if (ec) return(ec)

	S.hessian	= S.H
	S.invert	= `OPT_onoff_on'
	return(0)
}

/*STATIC*/ void opt__print_hessian(
	real	matrix	H,
	string	matrix	rstripe,
	string	matrix	cstripe,
	real	scalar	minimize
)
{
	displayas("txt")
	printf("Hessian matrix:\n")
	_matrix_list(
		(minimize ? -H : H),
		rstripe,
		cstripe,
		"%9.0g")
	displayflush()
}

/*STATIC*/ void opt__print_log(`OptStruct' S)
{
	real	scalar	iter
	string	scalar	msg
	real	scalar	debug
	real rowvector	myp

	if (!S.trace) {
		return
	}

	if (!S.concave) {
		msg = "  (not concave)"
	}
	else if (S.backup >= 6) {
		msg = "  (backed up)"
	}
	else	msg = "  "

	iter	= S.iter - 1
	opt__print_value(
		S.iter_id,
		iter,
		S.value_id,
		S.value,
		S.minimize,
		msg,
		(S.trace > `OPT_tracelvl_tol')
	)

	if (S.trace_tol) {
		opt__print_tol(
			S.iter_id,
			iter,
			S.value_id,
			S.convtol_id,
			S.convtol,
			(S.trace > `OPT_tracelvl_tol')
		)
	}

	if (S.trace < `OPT_tracelvl_step' | S.technique == `OPT_technique_nm') {
		return
	}

	if (!S.debugeval) {
		if (S.trace_step | S.trace_gradient) {
			myp = S.gradient
			if (cols(myp) != S.dim) {
				myp = myp*S.T'
			}

			opt__print_vector(	myp,
						(*S.stripes[3]),
						"Gradient",
						S.trace_gradient |
					(S.trace_step & S.trace_params),
						S.minimize)
		}
		debug = 0
	}
	else {
		if (S.trace_step) {
			if (!S.trace_gradient
			 | (S.trace_gradient & S.trace_hessian)) {
				myp = S.gradient
				if (cols(myp) != S.dim) {
					myp = myp*S.T'
				}

				opt__print_vector(	myp,
							(*S.stripes[3]),
							"Gradient",
							S.trace_gradient,
							S.minimize)
			}
		}
		debug = 1
	}

	if (!S.trace_hessian | debug) {
		return
	}

	if (S.trace_step | S.trace_gradient) {
		printf("\n")
	}
	myp = S.H
	if (cols(myp) != S.dim) {
		myp = S.T*myp*S.T'
	}
	opt__print_hessian(	myp,
				(*S.stripes[2]),
				(*S.stripes[3]),
				S.minimize)
}

/*STATIC*/ void opt__print_tol(
	string	scalar	iter_id,
	real	scalar	iter,
	string	scalar	value_id,
	string	scalar	tol_id,
	real	scalar	tol,
	real	scalar	flushright
)
{
	real scalar col, spaces

	if (missing(tol)) return
	displayas("txt")
	if (flushright == 0) {
		col = strlen(iter_id) + 4 + 3
		if (iter > 999) {
			++col
			if (iter > 9999) {
				++col
			}
		}
		spaces = strlen(value_id) - strlen(tol_id) + 1
		if (spaces < 1) {
			spaces = 1
		}
		printf("{col %f}%s{space %f}= {res:%10.0g}\n",
			col, tol_id, spaces, tol)
	}
	else {
		col = 66 - strlen(tol_id)
		printf("{col %f}%s = {res:%10.8g}\n", col, tol_id, tol)
	}
	displayflush()
}

/*STATIC*/ void opt__print_value(
	string	scalar	iter_id,
	real	scalar	iter,
	string	scalar	value_id,
	real	scalar	value,
	real	scalar	minimize,
	string	scalar	msg,
	real	scalar	flushright
)
{
	displayas("txt")
	if (flushright == 0) {
		real scalar space
		space	= 3
		if (iter > 9) {
			--space
			if (iter > 99) {
				--space
			}
		}
		printf("%s %f:{space %f}%s = {res:%10.8g}%s\n",
			iter_id,
			iter,
			space,
			value_id,
			(minimize ? -value : value),
			msg
		)
	}
	else {
		real	scalar	col
		col = 66 - strlen(value_id)
		printf("{col %f}%s = {res:%10.8g}\n",
			col,
			value_id,
			(minimize ? -value : value)
		)
		if (strtrim(msg) != "") {
			col = 79 - strlen(msg)
			printf("{col %f}%s\n", col, msg)
		}
	}
	displayflush()
}

/*STATIC*/ void opt__print_vector(
	real	rowvector	g,
	string	matrix		stripe,
	string	scalar		name,
	real	scalar		showvector,
	real	scalar		minimize
)
{
	displayas("txt")
	if (!showvector) {
		printf("%s length{col 22} ={res:%9.0g}\n", name, norm(g))
	}
	else {
		printf("%s vector (length ={res:%9.0g}):\n", name, norm(g))
		_matrix_list(
			(minimize ? -g : g),
			J(0,2,""),
			stripe,
			"%9.0g")
	}
	displayflush()
}

void opt__set_int(
	real scalar opt,
	real scalar value, 
	real scalar min,
	real scalar max
)
{
	if (value<min || value>max) {
		errprintf("setting out of range\n")
		exit(3498)
	}
	if (value != trunc(value)) {
		errprintf("setting must be integer\n")
		exit(3498)
	}
	opt = value
}

/*STATIC*/ real matrix opt__simplex(`OptStruct' S)
{
	real scalar	dim, dimp1
	real matrix	simplex

	dim	= cols(S.params)
	dimp1	= dim + 1
	simplex	= J(dimp1,dim,.)
	if (cols(S.simplex_delta) == 1) {
		simplex[|1,1\dim,dim|] = (S.params :+ S.simplex_delta*I(dim))
	}
	else {
		simplex[|1,1\dim,dim|] = (S.params :+ diag(S.simplex_delta))
	}
	simplex[|dimp1,1\dimp1,dim|] = S.params
	return(simplex)
}

/*STATIC*/ `Errcode' opt__looputil_step(`OptStruct' S)
{
	`Errcode'	ec
	real scalar	v0
	real rowvector	p0
	real rowvector	delta
	real matrix	invH
	pragma unset invH

	opt__userprolog(S)

	v0 = S.value
	p0 = S.params

	if (S.invert) {
		invH = invsym(-S.H)
	}
	else {
		invH = S.H
	}
	S.concave = opt__check_concave(S.H,invH)

	if (S.concave) {
		delta = S.gradient*invH
		if (S.doopt) {
			if (opt__check_doopt(S,p0+delta,delta,S.ignorenrtol)) {
				S.converged = 1
				S.params = p0 + delta
				return(0)
			}
		}
	}

	// report the value from the original parameters before we compute
	// the value at the next step
	opt__print_log(S)

	if (S.concave) {
		ec = opt__step(S,p0,v0,delta,60,1/8,2)
		if (ec) return(ec)
	}
	else {
		ec = (*S.singularH_stepper)(S,p0,v0,invH)
		if (ec) return(ec)
	}

	// check for convergence
	ec = opt__check_conv(S, p0, v0, .)
	if (ec) return(ec)

	// log value and step iteration count
	opt__log_value(S)

	if (S.trace_pdiffs) {
		real vector diffs
		real vector select
		diffs = reldif(p0, S.params)
		select = diffs :> S.ptol
		if (any(select)) {
			string matrix stripe
			printf("\nChanged elements of parameter vector:\n")
			printf("\n")
			diffs = select(diffs, select)
			if (rows(*S.stripes[3]) & cols(S.params) == S.dim) {
				stripe = select(*S.stripes[3], select')
			}
			else {
				stripe = J(0,2,"")
			}
			_matrix_list(
				diffs,
				J(0,2,""),
				stripe,
				"%9.0g")
			printf("\n")
		}
		else {
			printf("\nParameter changes within tolerance\n")
		}
	}

	return(0)
}

/*STATIC*/ `Errcode' opt__step(
	`OptStruct'		S,
	real	rowvector	p0,
	real	scalar		v0,
	real	rowvector	delta,
	real	scalar		maxback,
	real	scalar		start,
	real	scalar		inc
)
{
	`Errcode'	ec
	real scalar	todo
	real rowvector	myp

	S.params = p0 + delta

	if (S.trace_step) {
		if (S.trace_params|S.trace_gradient|S.trace_hessian) {
			printf("\n")
		}
		opt__print_vector(
			delta,
			(cols(delta)==S.dim
				? *S.stripes[3] : J(0,2,"")),
			"Step",
			S.trace_params,
			S.minimize
		)
		if (S.trace_params) {
			printf("\n")
		}
		displayas("txt")
		printf("Parameters + step -> new parameters\n")
		if (S.trace_params) {
			_matrix_list(
				S.params,
				J(0,2,""),
				(cols(S.params)==S.dim
					? *S.stripes[3] : J(0,2,"")),
				"%9.0g")
			printf("\n")
		}
	}

	// evaluate function at new parameters
	S.dot_type = "step"
	todo	= S.step_forward ? 0 : 2
	ec = opt__eval(S,todo,S.hasCns)
	if (ec) return(ec)

	if (missing(S.value) | S.value < v0) {
		if (S.trace_step) {
			opt__print_value(
				S.iter_id,
				.,
				S.value_id,
				S.value,
				S.minimize,
				"(initial step bad)",
				1
			)
		}
		ec = opt__steputil_backward(S,v0,p0,maxback)
		if (ec) return(ec)
		todo	= 1
	}
	else {
		if (S.trace_step) {
			opt__print_value(
				S.iter_id,
				.,
				S.value_id,
				S.value,
				S.minimize,
				"(initial step good)",
				1
			)
		}
		todo	= !todo
		if (todo) {
			ec = opt__steputil_forward(S,delta,start,inc)
			if (ec) return(ec)
		}
		S.backup = `OPT_backup_default'
	}

	if (S.trace >= `OPT_tracelvl_step') {
		displayas("txt")
		printf("{hline}\n")
		printf("%s %f:\n", S.iter_id, S.iter)

		if (S.trace_params) {
			myp = S.params
			if (cols(myp) != S.dim) {
				myp = myp*S.T' + S.a
			}

			printf("Parameter vector:\n")
			_matrix_list(
				myp,
				J(0,2,""),
				(*S.stripes[3]),
				"%9.0g")
			printf("\n")
		}
	}

	// evaluate function and derivatives at new parameters
	if (todo & (S.iter != S.maxiter | S.ndami == `OPT_onoff_off')) {
		S.dot_type = "text"
		ec = opt__eval(S,2,S.hasCns)
		if (ec) return(ec)
	}

	if (missing(S.value)) {
		S.errorcode = `Errcode_discon'
		S.errortext = `Errtext_discon'
		opt__errorhandler(S)
		return(S.errorcode)
	}

	return(0)
}

/*STATIC*/ void opt__adjH(real matrix H, real matrix invH, invert)
{
	real scalar	ok, adj, tr0

	// adjust the diagonal elements until H is concave 
	ok	= 0
	adj	= 1.1
	tr0	= trace(invH)
	while (!ok) {
		H = H - adj*diag(abs(diagonal(H)))
		if (invert) {
			invH	= invsym(-H)
		}
		else {
			invH	= H
		}
		ok	= opt__check_concave(H,invH)
		adj	= 2*adj
	}
	adj = tr0/trace(invH)
	if (adj > 0) {
		invH	= adj*invH
	}
}

/*STATIC*/ void opt__singularHutil_size(
	`OptStruct' S,
	real rowvector grad,
	real rowvector delta)
{
	real scalar lower, upper, eps
	real scalar i, v0, v1, c

	upper = 1e-2
	lower = 1e-8

	if (S.iter <= 2) {
		eps = upper
	}
	else {
		i = mod(S.iter-2, 20) + 1
		v0 = S.log[i]
		i = mod(S.iter-1, 20) + 1
		v1 = S.log[i]
		eps = min( (upper, max( (lower,0.1*(v1-v0)/abs(v0)) ) ) )
	}
	c = eps*abs(S.value)/(grad*delta')
	if (missing(c)) {
		c = 2
	}
	delta = c * delta
}

/*STATIC*/ `Errcode' opt__singularH_hybrid(
	`OptStruct'		S,
	real	rowvector	p0,
	real	scalar		v0,
	real	matrix		invH
)
{
	`Errcode'	ec
	real scalar	v1
	real scalar	dim, k
	real rowvector	p1, gx, delta
	real matrix	X, Xk, L
	pragma unset invH
	pragma unset X
	pragma unset L

	v1 = v0
	p1 = p0

	if (S.invert) {
		symeigensystem(-S.H, X, L)
	}
	else {
		symeigensystem(S.H, X, L)
	}
	if (S.trace_step) {
		displayas("txt")
		printf(
"\nDividing space into concave/nonconcave regions based on" +
" eigenvalues\nof negative Hessian")
		if (S.trace_params) {
			printf(":\n")
			_matrix_list(L,J(0,2,""),J(0,2,""),"%9.0g")
			printf("\n")
		}
		else {
			printf("\n\n")
		}
	}
	gx	= S.gradient*X
	dim	= cols(L)
	if (L[1] > 0 & dim >=2) {
		// work with eigenvectors associated with
		// reasonably large eigenvalues
		k = min((sum(L:>=S.eigen*L[1]),dim-1) )
		Xk	= X[|1,1 \ dim,k|]
		delta	= gx[|1,1 \ 1,k|] *
			invsym(diag(L[|1,1 \ 1,k|]))*Xk'
		S.params = p1 + delta
		if (S.trace_step) {
			opt__print_vector(
				delta,
				(cols(delta)==S.dim ?
					*S.stripes[3] : J(0,2,"")),
sprintf("Concave-space (dim = {res:%f}) Newton-Raphson step", k),
				S.trace_params,
				S.minimize
			)
			if (S.trace_params) {
				printf("\n")
			}
			displayas("txt")
			printf("Parameters + step -> new parameters\n")
			if (S.trace_params) {
				_matrix_list(
					S.params,
					J(0,2,""),
					(cols(S.params)==S.dim
						? *S.stripes[3]
						: J(0,2,"")),
					"%9.0g")
				printf("\n")
			}
		}
		S.dot_type = "step"
		ec = opt__eval(S,0,S.hasCns)
		if (ec) return(ec)
		if (missing(S.value) | S.value < v1) {
			if (S.trace_step) {
				opt__print_value(
					S.iter_id,
					.,
					S.value_id,
					S.value,
					S.minimize,
					"(initial step bad)",
					1
				)
			}
			ec = opt__steputil_backward(S,v1,p1,60)
			if (ec) return(ec)
			v1	= S.value
			p1	= S.params
		}
		else {
			if (S.trace_step) {
				opt__print_value(
					S.iter_id,
					.,
					S.value_id,
					S.value,
					S.minimize,
					"(initial step good)",
					1
				)
			}
			ec = opt__steputil_forward(S,delta,1/8,2)
			if (ec) return(ec)
			v1	= S.value
			p1	= S.params
		}
	}
	else	k = 0
	// work with eigenvectors associated with small or
	// negative eigenvalues
	k++
	delta	= gx[|1,k \ 1,dim|]
	Xk	= X[|1,k \ dim,dim|]
	S.value = v0
	opt__singularHutil_size(S, delta, delta)
	S.value = v1
	delta	= delta*Xk'
	// update parameters
	S.params = p1 + delta
	if (S.trace_step) {
		opt__print_vector(
			delta,
			(cols(delta)==S.dim ?
				*S.stripes[3] : J(0,2,"")),
sprintf("\nNonconcave-space (dim = {res:%f}) steepest-ascent step",
				dim-k+1),
			S.trace_params,
			S.minimize
		)
		if (S.trace_params) {
			printf("\n")
		}
		displayas("txt")
		printf("Parameters + step -> new parameters\n")
		if (S.trace_params) {
			_matrix_list(
				S.params,
				J(0,2,""),
				(cols(S.params)==S.dim ?
					*S.stripes[3] : J(0,2,"")),
				"%9.0g")
			printf("\n")
		}
	}

	// evaluate function at new parameters
	S.dot_type = "step"
	ec = opt__eval(S,0,S.hasCns)
	if (ec) return(ec)

	if (missing(S.value) | S.value < v1) {
		if (S.trace_step) {
			opt__print_value(
				S.iter_id,
				.,
				S.value_id,
				S.value,
				S.minimize,
				"(initial step bad)",
				1
			)
		}
		ec = opt__steputil_backward(S,v1,p1,10)
		if (ec) return(ec)
		S.backup = 0
		if (missing(S.value) | S.value < v1) {
			if (S.trace_step) {
				printf(
		"{col 47}(going back to last improvement)\n")
			}
			S.params = p1
		}
	}
	else {
		if (S.trace_step) {
			opt__print_value(
				S.iter_id,
				.,
				S.value_id,
				S.value,
				S.minimize,
				"(initial step good)",
				1
			)
		}
		ec = opt__steputil_forward(S,delta,1,2)
		if (ec) return(ec)
		S.backup = `OPT_backup_default'
	}

	if (S.trace >= `OPT_tracelvl_step') {
		displayas("txt")
		printf("{hline}\n")
		printf("%s %f:\n", S.iter_id, S.iter)

		if (S.trace_params) {
			real rowvector	myp
			myp = S.params
			if (cols(myp) != S.dim) {
				myp = myp*S.T' + S.a
			}

			printf("Parameter vector:\n")
			_matrix_list(
				myp,
				J(0,2,""),
				(*S.stripes[3]),
				"%9.0g")
			printf("\n")
		}
	}

	// evaluate function and derivatives at new parameters
	if (S.iter != S.maxiter | S.ndami == `OPT_onoff_off') {
		S.dot_type = "text"
		ec = opt__eval(S,2,S.hasCns)
		if (ec) return(ec)
	}

	if (missing(S.value)) {
		S.errorcode = `Errcode_discon'
		S.errortext = `Errtext_discon'
		opt__errorhandler(S)
		return(S.errorcode)
	}

	return(0)
}

/*STATIC*/ `Errcode' opt__singularH_m_marquardt(
	`OptStruct'		S,
	real	rowvector	p0,
	real	scalar		v0,
	real	matrix		invH
)
{
	real rowvector	delta

	opt__adjH(S.H, invH, S.invert)
	delta = S.gradient*invH
	if (missing(delta)) {
		S.errorcode = `Errcode_H_notdefinite'
		if (S.minimize) {
			S.errortext = `Errtext_H_notPSD'
		}
		else {
			S.errortext = `Errtext_H_notNSD'
		}
		opt__errorhandler(S)
		return(S.errorcode)
	}
	opt__singularHutil_size(S, S.gradient, delta)

	return(opt__step(S,p0,v0,delta,60,1,2))
}

/*STATIC*/ `Errcode' opt__looputil_nm(`OptStruct' S)
{
	real scalar	i
	real scalar	c1, c2, c3
	real scalar	simnodes
	real rowvector	middle
	real rowvector	newp, altp
	real scalar	newv, altv
	real scalar	mult, better
	real scalar	ptol, vtol

	pragma unset newv
	pragma unset altv

	simnodes	= S.simnodes
	c1		= S.simorder[simnodes]
	c2		= S.simorder[2]
	c3		= S.simorder[1]

	middle	= (colsum(S.simplex) - S.simplex[c3,])/S.dim
	newp	= 2*middle - S.simplex[c3,]

	// report the value from the original parameters before we compute
	// the value at the next step
	opt__print_log(S)

	opt__eval_nm(S, newp, newv)

	if (missing(newv)) {
		S.errorcode = `Errcode_value_missing'
		S.errortext = `Errtext_value_missing'
		opt__errorhandler(S)
		return(S.errorcode)
	}

	// improve the worst node

	if (newv > S.simvals[c3]) {
		S.simplex[c3,]	= newp
		S.simvals[c3]	= newv
	}
	if (newv > S.simvals[c1]) {
		better	= 1
		mult	= 2
		while (better) {
			altp	= mult*newp - middle
			opt__eval_nm(S, altp, altv)
			if (!missing(altv) & altv > newv) {
				S.simplex[c3,]	= altp
				S.simvals[c3]	= altv
				newv			= altv
				mult			= 2*mult
			}
			else	better			= 0
		}
	}
	else if (newv <= S.simvals[c2]) {
		// contract the S.simplex toward the best node
		for (i=1; i<=simnodes; i++) {
			if (i != c1) {
				altp = (S.simplex[i,]+S.simplex[c1,])/2
				opt__eval_nm(S, altp, altv)
				S.simplex[i,]	= altp
				S.simvals[i]	= altv
			}
		}
	}
	if (missing(S.simvals)) {
		S.errorcode = `Errcode_value_missing'
		S.errortext = `Errtext_value_missing'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	if (S.nm_sortstable) {
		S.simorder	= order((S.simvals,(1::S.simnodes)), (1,2))
	}
	else {
		S.simorder	= order(S.simvals, 1)
	}
	c1	= S.simorder[simnodes]
	c3	= S.simorder[1]

	if (S.trace_step) {
		displayas("txt")
		printf("{hline}\n")
		printf("%s %f:\n", S.iter_id, S.iter)

		if (S.trace_params) {
			real rowvector	myp
			myp = S.params
			if (cols(myp) != S.dim) {
				myp = myp*S.T' + S.a
			}

			printf("Parameter vector:\n")
			_matrix_list(
				myp,
				J(0,2,""),
				(*S.stripes[3]),
				"%9.0g")
			printf("\n")
		}
	}

	S.params	= S.simplex[c1,]
	S.value	= S.simvals[c1]
	opt__log_value(S)

	ptol	= mreldif(S.simplex[c1,],S.simplex[c3,])
	vtol	= reldif(S.simvals[c1], S.simvals[c3])
	S.converged =	(ptol < S.ptol) | (vtol < S.vtol)
	if (S.converged) {
		if (ptol < vtol) {
			S.convtol	= ptol
			S.convtol_id	= "ptol"
		}
		else {
			S.convtol	= vtol
			S.convtol_id	= "vtol"
		}
	}
	else	S.convtol = `OPT_convtol_default'
	return(0)
}

/*STATIC*/ `Errcode' opt__steputil_backward(
	`OptStruct'		S,
	real	scalar		v0,		// previous value
	real	rowvector	p0,		// previous parameters
	real	scalar		maxback
)
{
	`Errcode'	ec
	real scalar	iback, size
	size	= norm(S.params-p0)
	iback	= 1
	while (iback <= maxback & (missing(S.value) | S.value < v0)) {
		S.params = (S.params + p0)/2
		size	= size/2
		// evaluate function at new parameters
		S.dot_type = "step"
		ec = opt__eval(S,0,S.hasCns)
		if (ec) return(ec)
		if (S.trace_step) {
			opt__steputil_log(S,
				iback,"Reducing step size",size)
		}
		iback++
	}
	if (iback > maxback) S.params = p0
	S.backup = iback - 1
	return(0)
}

/*STATIC*/ `Errcode' opt__steputil_forward(
	`OptStruct' S,
	real rowvector	delta,		// step direction
	real scalar	start,		// initial stepsize
	real scalar	inc		// stepsize increase for next step
)
{
	`Errcode'	ec
	real scalar	istep
	real scalar	v1
	real rowvector	p1

	istep	= 1
	delta	= start*delta
	do {
		v1	= S.value
		p1	= S.params
		S.params = p1 + delta
		// evaluate function at new parameters
		S.dot_type = "step"
		ec = opt__eval(S,0,S.hasCns)
		if (ec) return(ec)
		if (S.trace_step) {
			opt__steputil_log(
				S,
				istep,
				"Stepping forward",
				norm(delta))
		}
		delta = inc*delta
		istep++
	} while (S.value > v1 & !missing(S.value))
	if (S.trace_step) {
		printf("{col 59}(ignoring last step)\n")
	}
	S.value		= v1
	S.params	= p1
	S.backup	= 0
	return(0)
}

/*STATIC*/ void opt__steputil_log(
	`OptStruct' S,
	real	scalar	istep,			// step counter
	string	scalar	message,		// type of stepping performed
	real	scalar	size			// length of the step
)
{
	if (!S.trace) {
		return
	}

	displayas("txt")
	if (S.trace_params){
		printf("\n")
		printf("(%1.0f) %s (step length ={res:%9.0g})\n",
			istep, message, size)
	}
	else {
		printf("(%1.0f) %s, step length ={res:%9.0g}\n",
			istep, message, size)
	}
	if (S.trace_params){
		printf("New parameter vector:\n")
		_matrix_list(
			S.params,
			J(0,2,""),
			(cols(S.params)==S.dim
				? *S.stripes[3] : J(0,2,"")),
			"%9.0g")
		printf("\n")
	}
	opt__print_value(
		S.iter_id,
		.,
		S.value_id,
		S.value,
		S.minimize,
		"",
		1
	)
}

function opt__tracelevel_num(`OptStruct' S, |real scalar trace)
{
	if (args() == 2) {
		opt__set_int(S.utrace, trace, 0, `OPT_tracelvl_max')
		opt__reset_trace(S)
	}
	else	return(S.utrace)
}

function opt__tracelevel_str(`OptStruct' S, |string scalar trace)
{
	if (args() == 2) {
		real scalar len
		len = strlen(trace)
		if (trace == bsubstr(`OPT_tracelvl0',1,max((1,len)))) {
			S.utrace = 0
		}
		else if (trace == bsubstr(`OPT_tracelvl1',1,max((1,len)))) {
			S.utrace = 1
		}
		else if (trace == bsubstr(`OPT_tracelvl2',1,max((2,len)))) {
			S.utrace = 2
		}
		else if (trace == bsubstr(`OPT_tracelvl3',1,max((1,len)))) {
			S.utrace = 3
		}
		else if (trace == bsubstr(`OPT_tracelvl4',1,max((6,len)))) {
			S.utrace = 4
		}
		else if (trace == bsubstr(`OPT_tracelvl4alt',1,max((5,len)))) {
			S.utrace = 4
		}
		else if (trace == bsubstr(`OPT_tracelvl5',1,max((1,len)))) {
			S.utrace = 5
		}
		else if (trace == bsubstr(`OPT_tracelvl5alt',1,max((1,len)))) {
			S.utrace = 5
		}
		else if (trace == bsubstr(`OPT_tracelvl6',1,max((1,len)))) {
			S.utrace = 6
		}
		else if (trace == bsubstr(`OPT_tracelvl7',1,max((1,len)))) {
			S.utrace = 7
		}
		else {
			errprintf("invalid trace level\n")
			exit(3498)
		}
		opt__reset_trace(S)
	}
	else {
		if (S.utrace == 0) {
			return(`OPT_tracelvl0')
		}
		if (S.utrace == 1) {
			return(`OPT_tracelvl1')
		}
		if (S.utrace == 2) {
			return(`OPT_tracelvl2')
		}
		if (S.utrace == 3) {
			return(`OPT_tracelvl3')
		}
		if (S.utrace == 4) {
			return(`OPT_tracelvl4')
		}
		if (S.utrace == 5) {
			return(`OPT_tracelvl5')
		}
		if (S.utrace == 6) {
			return(`OPT_tracelvl6')
		}
		if (S.utrace == 7) {
			return(`OPT_tracelvl7')
		}
		return(`OPT_tracelvl_default')
	}
}

void	opt__reset_trace(`OptStruct' S)
{
	S.trace		= `OPT_tracelvl_default'
	S.trace_value	= `OPT_trace_value_default'
	S.trace_dots	= `OPT_trace_dots_default'
	S.trace_tol	= `OPT_trace_tol_default'
	S.trace_step	= `OPT_trace_step_default'
	S.trace_params	= `OPT_trace_params_default'
	S.trace_pdiffs	= `OPT_trace_pdiffs_default'
	S.trace_gradient= `OPT_trace_gradient_default'
	S.trace_hessian	= `OPT_trace_hessian_default'
}

`Errcode' opt__set_calluser(`OptStruct' S, real scalar is_mopt)
{
	string	scalar	name

	// find the routine that calls the user's evaluator
	if (S.evaltype == `OPT_evaltype_d') {
		if (is_mopt) {
			S.calluser = &mopt__calluser_d()
		}
		else {
			name	= sprintf("opt__calluser%f_d()",S.nargs)
		}
		deriv_init_evaluator(	 S.D,	&opt__d0_calluser())
		deriv_init_evaluatortype(S.D,	"d")
		deriv_init_weak_goals(	 S.D,	!S.userscale)
	}
	else if (S.evaltype == `OPT_evaltype_v') {
		if (is_mopt) {
			S.calluser = &mopt__calluser_v()
		}
		else {
			name	= sprintf("opt__calluser%f_v()",S.nargs)
		}
		deriv_init_evaluator(	 S.D,	&opt__v0_calluser())
		deriv_init_evaluatortype(S.D,	"v")
		deriv_init_weak_goals(	 S.D,	!S.userscale)
		if (S.wtype != `OPT_wtype_none') {
			deriv_init_weights(S.D, S.weights)
		}
	}
	else if (S.evaltype == `OPT_evaltype_q') {
		if (is_mopt) {
			S.calluser = &mopt__calluser_q()
		}
		else {
			name	= sprintf("opt__calluser%f_q()",S.nargs)
		}
		deriv_init_evaluator(	 S.D,	&opt__q0_calluser())
		deriv_init_evaluatortype(S.D,	"v")
		deriv_init_weak_goals(	 S.D,	1)
		if (S.wtype != `OPT_wtype_none') {
			deriv_init_weights(S.D, S.weights)
		}
		S.minimize = `OPT_which_min'
	}
	else if (S.evaltype == `OPT_evaltype_lf') {
		if (!is_mopt) {
			S.errorcode = `Errcode_invalid_evaltype'
			S.errortext = `Errtext_invalid_evaltype'
			opt__errorhandler(S)
			return(S.errorcode)
		}
		if (S.evaltype_f == "lf") {
			S.calluser = &mopt__calluser_lf()
			deriv_init_evaluator(	 S.D,	&opt__lf_calluser())
			deriv_init_user_setdelta(S.D,	&opt__lf_setdelta())
		}
		else {
			S.calluser = &mopt__calluser_lf2()
			deriv_init_evaluator(	 S.D,	&opt__lf2_calluser())
			deriv_init_user_setdelta(S.D,	&opt__lf2_setdelta())
		}
		deriv_init_evaluatortype(S.D,	"v")
		deriv_init_weak_goals(	 S.D,	0)
		deriv_init_user_h(	 S.D,	&opt__lf_h())
		deriv_init_user_neq(	 S.D,	&opt__lf_neq())
		deriv_init_user_vecsum(	 S.D,	&opt__lf_vecsum())
		deriv_init_user_matsum(	 S.D,	&opt__lf_matsum())
		if (S.wtype != `OPT_wtype_none') {
			deriv_init_weights(S.D, S.weights)
		}
	}
	else if (S.evaltype == `OPT_evaltype_e') {
		if (!is_mopt) {
			S.errorcode = `Errcode_invalid_evaltype'
			S.errortext = `Errtext_invalid_evaltype'
			opt__errorhandler(S)
			return(S.errorcode)
		}
		S.calluser = &mopt__calluser_e()
		deriv_init_evaluator(	 S.D,	&opt__d0_calluser())
		deriv_init_evaluatortype(S.D,	"d")
		deriv_init_weak_goals(	 S.D,	!S.userscale)
	}
	else {
		S.errorcode = `Errcode_invalid_evaltype'
		S.errortext = `Errtext_invalid_evaltype'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	if (strlen(name)) {
		S.calluser = findexternal(name)
		if (S.calluser == `OPT_calluser_default') {
			S.errorcode = `Errcode_no_calluser'
			S.errortext = sprintf("%s not found", name)
			opt__errorhandler(S)
			return(S.errorcode)
		}
	}
	S.debugeval =	strpos(S.evaltype_f, "debug")

	S.use_deriv =	(S.debugeval)		|
			any(S.evaltype_f :== tokens("d0 v0 q0 lf lf0"))

	if (S.trace_dots) {
		deriv_init_user_setup1(S.D, &opt__dot_type_grad())
		deriv_init_user_setup2(S.D, &opt__dot_type_Hess())
	}
	return(0)
}

`Errcode' opt__validate(`OptStruct' S, |real scalar is_mopt)
{
	`Errcode'	ec
	real	scalar	k
	real	scalar	z
	real	scalar	cdim
	string	scalar	name

	if (S.utrace != `OPT_tracelvl_default') {
		// user set the trace level, so translate that to the
		// output settings for the individual trace elements
		S.trace_value	= (S.utrace >= `OPT_tracelvl_value')
		S.trace_tol	= (S.utrace >= `OPT_tracelvl_tol')
		S.trace_step	= (S.utrace >= `OPT_tracelvl_step')
		S.trace_params	= (S.utrace >= `OPT_tracelvl_params')
		S.trace_pdiffs	= (S.utrace >= `OPT_tracelvl_pdiffs')
		S.trace_gradient= (S.utrace >= `OPT_tracelvl_gradient')
		S.trace_hessian	= (S.utrace >= `OPT_tracelvl_hessian')
		S.trace		= S.utrace
	}
	else {
		// set the trace level from the output settings of the
		// individual trace elements
		if (S.trace_hessian) {
			S.trace	= `OPT_tracelvl_hessian'
		}
		else if (S.trace_gradient) {
			S.trace	= `OPT_tracelvl_gradient'
		}
		else if (S.trace_params) {
			S.trace	= `OPT_tracelvl_params'
		}
		else if (S.trace_step | S.trace_pdiffs) {
			S.trace	= `OPT_tracelvl_step'
		}
		else if (S.trace_tol) {
			S.trace	= `OPT_tracelvl_tol'
		}
		else if (S.trace_value) {
			S.trace	= `OPT_tracelvl_value'
		}
		else	S.trace	= `OPT_tracelvl_none'
	}

	if (S.valid) {
		return(0)
	}
	if (args() == 1) {
		is_mopt = 0
	}

	S.valid	= `OPT_onoff_off'

	S.errorcode = 0
	S.errortext = ""

	if (S.wtype != `OPT_wtype_none') {
		k = length(S.weights)
		if (k < 2) {
			if (k == 1) {
				k = (S.weights != `OPT_weights_default')
			}
			if (k == 0) {
				S.errorcode	= `Errcode_weights'
				S.errortext	= sprintf(
						"%s values not specified",
						opt__wtype_str(S))
				opt__errorhandler(S)
				return(S.errorcode)
			}
		}
	}

	// check user's evaluator
	if (S.user == `OPT_user_default') {
		S.errorcode = `Errcode_no_user'
		S.errortext = `Errtext_no_user'
		opt__errorhandler(S)
		return(S.errorcode)
	}

	// check starting values
	if (S.p0 == `OPT_p0_default') {
		S.errorcode = `Errcode_no_p0'
		S.errortext = `Errtext_no_p0'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	if (missing(S.p0)) {
		S.errorcode = `Errcode_p0_missing'
		S.errortext = `Errtext_p0_missing'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	S.params = S.p0

	// check convergence tolerance values
	if (S.vtol < 0) {
		S.errorcode = `Errcode_tol_negative'
		S.errortext = `Errtext_tol_negative'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	if (S.ptol < 0) {
		S.errorcode = `Errcode_tol_negative'
		S.errortext = `Errtext_tol_negative'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	if (S.gtol < 0) {
		S.errorcode = `Errcode_tol_negative'
		S.errortext = `Errtext_tol_negative'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	if (S.nrtol < 0) {
		S.errorcode = `Errcode_tol_negative'
		S.errortext = `Errtext_tol_negative'
		opt__errorhandler(S)
		return(S.errorcode)
	}

	// initialize work items based on dimension of the parameter vector
	S.dim	= cols(S.params)
	if (S.dim < 1) {
		S.errorcode = `Errcode_invalid_p0'
		S.errortext = `Errtext_invalid_p0'
		opt__errorhandler(S)
		return(S.errorcode)
	}
	S.gradient	= J(1,S.dim,.)
	S.H		= J(S.dim,S.dim,.)

	ec = opt__set_calluser(S, is_mopt)
	if (ec)	return(ec)

	// find the routine that calls the user's iteration prolog evaluator
	if (S.userprolog != `OPT_userprolog_default'
	 || S.userprolog2 != `OPT_userprolog2_default') {
		name = sprintf("opt__callprolog%f()", S.nargs)
		S.callprolog	= findexternal(name)
		if (S.callprolog == `OPT_callprolog_default') {
			S.errorcode = `Errcode_no_calluser'
			S.errortext = sprintf("%s not found", name)
			opt__errorhandler(S)
			return(S.errorcode)
		}
	}

	// find the internal looping routine for the technique
	if (S.loop == `OPT_loop_default') {
		optimize_init_technique(S, `OPT_technique_default')
	}

	// find the internal routine that handles calling the user's evaluator
	// and other things like taking numerical derivatives
	if (cols(S.cycle_names) == 1) {
		name	= sprintf("opt__eval_%s_%s()",
				S.cycle_names[1],
				S.evaltype_f)
	}
	else {
		name	= "opt__eval_cycle()"
	}
	S.eval	= findexternal(name)
	// check for invalid use of the *debug evaltypes
	if (S.technique != `OPT_technique_nr') {
		if (S.evaltype_f == "q1debug") {
			if (S.technique != `OPT_technique_gn') {
				S.errorcode = `Errcode_no_eval'
				S.errortext =
				    sprintf("%s requires the gn technique",
				    S.evaltype_user)
				opt__errorhandler(S)
				return(S.errorcode)
			}
		}
		else if (strmatch(S.evaltype_f, "*debug")) {
			S.errorcode = `Errcode_eval_debug'
			S.errortext = sprintf("%s requires the nr technique",
				S.evaltype_user)
			opt__errorhandler(S)
			return(S.errorcode)
		}
	}
	if (S.eval == `OPT_eval_default') {
		S.errorcode = `Errcode_no_eval'
		S.errortext = sprintf(
"type %s evaluators are not allowed with technique %s",
			optimize_init_evaluatortype(S),
			S.cycle_names[1])
		opt__errorhandler(S)
		return(S.errorcode)
	}

	// find the internal routine for handling a singular Hessian
	if (S.singularH != "") {
		name = sprintf("opt__singularH_%s()",
			subinstr(optimize_init_singularHmethod(S), "-", "_"))
		S.singularH_stepper = findexternal(name)
		if (S.singularH_stepper == `OPT_singularH_stepper_default') {
			S.errorcode = `Errcode_no_step'
			S.errortext = sprintf(
				"routine for singular H method '%s' not found",
				optimize_init_singularHmethod(S))
			opt__errorhandler(S)
			return(S.errorcode)
		}
	}
	else {
		S.singularH_stepper = &opt__singularH_m_marquardt()
	}

	// linear constraints
	S.hasCns = 0
	S.holdCns = 0
	S.fullRankCns = 0
	if (S.constraints != `OPT_constraints_default') {
		real scalar p
		p	= cols(S.constraints) - 1
		if (p != cols(S.params)) {
			S.errorcode = `Errcode_badconstr'
			S.errortext = `Errtext_badconstr'
			opt__errorhandler(S)
			return(S.errorcode)
		}
		opt__check_fullRankCns(S)
		if (S.fullRankCns == 0) {
			if (_cns_eigen(S.constraints, S.T, S.a)) {
				S.errorcode = `Errcode_badconstr'
				S.errortext = `Errtext_badconstr'
				opt__errorhandler(S)
				return(S.errorcode)
			}
		}
		S.hasCns = 1
		opt__set_holdCns(S, S.technique == `OPT_technique_nr')
	}

	if (any(strmatch(S.cycle_names, "nm"))) {
		if (S.simplex_delta == `OPT_simplex_delta_default') {
			S.errorcode = `Errcode_simplex_req'
			S.errortext = `Errtext_simplex_req'
			opt__errorhandler(S)
			return(S.errorcode)
		}
		if (min(abs(S.simplex_delta)) < 10*S.ptol) {
			S.errorcode = `Errcode_simplex_small'
			S.errortext = `Errtext_simplex_small'
			opt__errorhandler(S)
			return(S.errorcode)
		}
		k = cols(S.simplex_delta)
		if (k > 1) {
			z = S.simplex_delta[1]
			if (allof(S.simplex_delta, z)) {
				S.simplex_delta = z
				k = 1
			}
		}
		if (k > 1) {
			cdim = S.dim
			if (S.hasCns) {
				cdim = cols(S.T)
			}
			if (k != cdim) {
				S.errorcode = `Errcode_simplex_bad_dim'
				S.errortext = `Errtext_simplex_bad_dim'
				opt__errorhandler(S)
				return(S.errorcode)
			}
		}
	}

	if (*S.stripes[1] != `OPT_stripes_default') {
		if (cols(*S.stripes[1]) != 2) {
			S.errorcode = `Errcode_stripe_invalid'
			S.errortext = `Errtext_stripe_invalid'
			opt__errorhandler(S)
			return(S.errorcode)
		}
		if (rows(*S.stripes[1])) {
			if (rows(*S.stripes[1]) != cols(S.params)) {
				S.errorcode = `Errcode_stripe_invalid'
				S.errortext = `Errtext_stripe_invalid'
				opt__errorhandler(S)
				return(S.errorcode)
			}
			if (any(strmatch(*S.stripes[1], "*:*"))) {
				S.errorcode = `Errcode_stripe_invalid'
				S.errortext = `Errtext_stripe_invalid'
				opt__errorhandler(S)
				return(S.errorcode)
			}
		}
		string	scalar tmpmat
		tmpmat = st_tempname()
		st_matrix(tmpmat, J(1,S.dim,.))
		st_matrixcolstripe(tmpmat, *S.stripes[1])
		S.stripes[2] = &st_matrixcolstripe_abbrev(tmpmat, 12)
		S.stripes[3] = &st_matrixcolstripe_split(tmpmat, 12)
		stata(sprintf("matrix drop %s", tmpmat))
	}

	S.converged	= `OPT_converged_default'
	S.errorcode	= `OPT_errorcode_default'
	S.errortext	= `OPT_errortext_default'
	S.cycle_iter	= `OPT_cycle_iter_default'
	S.cycle_idx	= `OPT_cycle_iter_default'

	S.valid	= `OPT_onoff_on'
	return(0)
}

void opt__set_holdCns(`OptStruct' S, real scalar is_nr)
{
	S.holdCns	= 0
	if (any(strmatch(S.evaltype_f, ("d0", "v0", "q0")))) {
		S.holdCns = 1
	}
	else if (is_nr) {
		if (any(strmatch(S.evaltype_f, ("d1", "v1", "e1")))) {
			if (S.evaltype == `OPT_evaltype_e') {
				S.holdCns = mopt__set_holdCns((*S.arglist[1]))
			}
			else {
				S.holdCns = 1
			}
		}
	}
}

function opt__which_num(`OptStruct' S, |real scalar minimize)
{
	if (args() == 2) {
		opt__set_int(S.minimize,minimize,0,`OPT_which_last')
	}
	else	return(S.minimize)
}

function opt__which_str(`OptStruct' S, |string scalar which)
{
	if (args() == 2) {
		if (which == `OPT_which0') {
			S.minimize	= 0
		}
		else if (which == `OPT_which1') {
			S.minimize	= 1
		}
		else {
			errprintf("invalid argument\n")
			exit(3498)
		}
	}
	else {
		if (S.minimize == 0) {
			return(`OPT_which0')
		}
		if (S.minimize == 1) {
			return(`OPT_which1')
		}
	}
}

function opt__weight(
	`OptStruct' S,
	|real	colvector	weights,
		scalar		wtype
)
{
	if (args() == 1) {
		return(S.weights)
	}
	if (!length(weights)) {
		S.weights	= `OPT_weights_default'
		S.wtype		= `OPT_wtype_default'
		return
	}
	if (missing(weights)) {
		errprintf("missing values not allowed in weights\n")
		exit(3498)
	}
	S.weights = weights
	if (args() == 3) {
		S.wtype = `OPT_wtype_f'
		opt__wtype(S, wtype)
	}
	else if (S.wtype == `OPT_wtype_a') {
		real	colvector	w
		w	= S.weights
		robust_init_weight(S.R, w)
		opt__weights_rescale(S.weights)
	}
}

/*STATIC*/ void opt__weights_rescale(real colvector w)
{
	w = w/mean(w)
}

function opt__wtype(`OptStruct' S, |scalar wtype)
{
	if (args() == 1) {
		return(opt__wtype_str(S))
	}

	real	scalar	wtype0

	wtype0	= S.wtype

	if (isreal(wtype)) {
		opt__wtype_num(S, wtype)
	}
	else if (isstring(wtype)) {
		opt__wtype_str(S, wtype)
	}
	else {
		errprintf("invalid weight type\n")
		exit(3498)
	}
	if (S.wtype == `OPT_wtype_none') {
		S.weights	= `OPT_weights_default'
		S.wtype		= `OPT_wtype_default'
	}
	else if (S.wtype == `OPT_wtype_a' & wtype0 != S.wtype) {
		real	colvector	w
		w	= S.weights
		robust_init_weight(S.R, w)
		opt__weights_rescale(S.weights)
	}
	robust_init_weighttype(S.R, opt__wtype_str(S))
}

function opt__wtype_num(`OptStruct' S, |real scalar wtype)
{
	if (args() == 1) {
		return(S.wtype)
	}
	opt__set_int(S.wtype,wtype,0,`OPT_wtype_max')
}

function opt__wtype_str(`OptStruct' S, |string scalar wtype)
{
	if (args() == 1) {
		if (S.wtype == 0) {
			return(`OPT_wtype0')
		}
		if (S.wtype == 1) {
			return(`OPT_wtype1')
		}
		if (S.wtype == 2) {
			return(`OPT_wtype2')
		}
		if (S.wtype == 3) {
			return(`OPT_wtype3')
		}
		if (S.wtype == 4) {
			return(`OPT_wtype4')
		}
		return(`OPT_wtype0')
	}

	real scalar	len

	len	= strlen(wtype)
	if (len == 0) {
		S.wtype	= 0
	}
	else if (wtype == bsubstr("weight",1,len)) {
		S.wtype	= `OPT_wtype_f'
	}
	else if (wtype == bsubstr(`OPT_wtype1',1,len)) {
		S.wtype	= 1
	}
	else if (wtype == bsubstr(`OPT_wtype2',1,len)) {
		S.wtype	= 2
	}
	else if (wtype == bsubstr(`OPT_wtype3',1,len)) {
		S.wtype	= 3
	}
	else if (wtype == bsubstr(`OPT_wtype4',1,len)) {
		S.wtype	= 4
	}
	else {
		errprintf("invalid weight type\n")
		exit(3498)
	}
}

void opt__cnt_eval(
	`OptStruct'	S,
	real	scalar	todo,
	real	scalar	value
)
{
	if (S.trace & S.trace_dots) {
		opt__dots(S,value)
	}
	if (! S.evalcount) {
		return
	}
	if (todo == 2) {
		(void) ++S.cnt2_evals
	}
	else if (todo == 1) {
		(void) ++S.cnt1_evals
	}
	else if (todo == 0) {
		(void) ++S.cnt0_evals
	}
	else {
		(void) ++S.cnt__evals
	}
}

/*STATIC*/ function opt__dots(
	`OptStruct' S,
	|real scalar value
)
{
	if (!S.trace | !S.trace_dots) {
		return
	}

	if (args() == 1) {
		if (mod(S.ndots,50)) {
			printf("\n")
		}
		S.ndots = 0
	}
	else {
		(void) ++S.ndots
		if (missing(value)) {
			printf("{error:x}")
		}
		else if (S.dot_type == "step") {
			if (! S.trace_step) {
				printf("{text:s}")
			}
		}
		else {
			if (S.dot_type == "") {
				S.dot_type = "text"
			}
			if (S.dot_type == "input") {
				printf("{bf}")
			}
			printf("{%s}.{reset}", S.dot_type)
		}
		if (!mod(S.ndots,50)) {
			printf(" %5.0f\n", S.ndots)
		}
	}
}

function opt__conv_warn_num(`OptStruct' S, |real scalar warn)
{
	if (args() == 2) {
		opt__set_int(S.warn,warn,0,`OPT_conv_warn_max')
	}
	else	return(S.warn)
}

function opt__conv_warn_str(`OptStruct' S, |string scalar warn)
{
	if (args() == 2) {
		if (warn == `OPT_onoff0') {
			S.warn	= 0
		}
		else if (warn == `OPT_onoff1') {
			S.warn	= 1
		}
		else {
			errprintf("invalid argument\n")
			exit(3498)
		}
	}
	else {
		if (S.warn == 0) {
			return(`OPT_onoff0')
		}
		if (S.warn == 1) {
			return(`OPT_onoff1')
		}
	}
}

function opt__trace_store(`OptStruct' S, vector trace)
{
	trace    = J(1,10,0)
	trace[1] = S.trace_value
	trace[2] = S.trace_dots
	trace[3] = S.trace_tol
	trace[4] = S.trace_step
	trace[5] = S.trace_pdiffs
	trace[6] = S.trace_params
	trace[7] = S.trace_gradient
	trace[8] = S.trace_hessian
	trace[9] = S.trace
	trace[10] = S.utrace
}

function opt__trace_none(`OptStruct' S)
{
	S.trace_value	= 0
	S.trace_dots	= 0
	S.trace_tol	= 0
	S.trace_step	= 0
	S.trace_pdiffs	= 0
	S.trace_params	= 0
	S.trace_gradient= 0
	S.trace_hessian	= 0
	S.trace		= 0
	S.utrace	= 0
}

function opt__trace_restore(`OptStruct' S, real vector trace)
{
	S.trace_value	= trace[1]
	S.trace_dots	= trace[2]
	S.trace_tol	= trace[3]
	S.trace_step	= trace[4]
	S.trace_pdiffs	= trace[5]
	S.trace_params	= trace[6]
	S.trace_gradient= trace[7]
	S.trace_hessian	= trace[8]
	S.trace		= trace[9]
	S.utrace	= trace[10]
}

function opt__trace_value_num(
	`OptStruct'	S,
	|real	scalar	 value
)
{
	if (args() == 1) {
		return(S.trace_value)
	}
	opt__set_int(S.trace_value,value,0,1)
}

function opt__trace_dots_num(
	`OptStruct'	S,
	|real	scalar	 dots
)
{
	if (args() == 1) {
		return(S.trace_dots)
	}
	opt__set_int(S.trace_dots,dots,0,1)
}

function opt__trace_tol_num(
	`OptStruct'	S,
	|real	scalar	 tol
)
{
	if (args() == 1) {
		return(S.trace_tol)
	}
	opt__set_int(S.trace_tol,tol,0,1)
}

function opt__trace_step_num(
	`OptStruct'	S,
	|real	scalar	 step
)
{
	if (args() == 1) {
		return(S.trace_step)
	}
	opt__set_int(S.trace_step,step,0,1)
}

function opt__trace_pdiffs_num(
	`OptStruct'	S,
	|real	scalar	 pdiffs
)
{
	if (args() == 1) {
		return(S.trace_pdiffs)
	}
	opt__set_int(S.trace_pdiffs,pdiffs,0,1)
}

function opt__trace_params_num(
	`OptStruct'	S,
	|real	scalar	 params
)
{
	if (args() == 1) {
		return(S.trace_params)
	}
	opt__set_int(S.trace_params,params,0,1)
}

function opt__trace_gradient_num(
	`OptStruct'	S,
	|real	scalar	 gradient
)
{
	if (args() == 1) {
		return(S.trace_gradient)
	}
	opt__set_int(S.trace_gradient,gradient,0,1)
}

function opt__trace_hessian_num(
	`OptStruct'	S,
	|real	scalar	 hessian
)
{
	if (args() == 1) {
		return(S.trace_hessian)
	}
	opt__set_int(S.trace_hessian,hessian,0,1)
}

function opt__trace_value_str(
	`OptStruct'	S,
	|string	scalar	 value
)
{
	if (args() == 1) {
		if (S.trace_value) {
			return("on")
		}
		return("off")
	}
	if (value == "on") {
		S.trace_value = 1
	}
	else if (value == "off") {
		S.trace_value = 0
	}
	else {
		errprintf("invalid trace argument\n")
		exit(3498)
	}
}

function opt__trace_dots_str(
	`OptStruct'	S,
	|string	scalar	 dots
)
{
	if (args() == 1) {
		if (S.trace_dots) {
			return("on")
		}
		return("off")
	}
	if (dots == "on") {
		S.trace_dots = 1
	}
	else if (dots == "off") {
		S.trace_dots = 0
	}
	else {
		errprintf("invalid trace argument\n")
		exit(3498)
	}
}

function opt__trace_tol_str(
	`OptStruct'	S,
	|string	scalar	 tol
)
{
	if (args() == 1) {
		if (S.trace_tol) {
			return("on")
		}
		return("off")
	}
	if (tol == "on") {
		S.trace_tol = 1
	}
	else if (tol == "off") {
		S.trace_tol = 0
	}
	else {
		errprintf("invalid trace argument\n")
		exit(3498)
	}
}

function opt__trace_step_str(
	`OptStruct'	S,
	|string	scalar	 step
)
{
	if (args() == 1) {
		if (S.trace_step) {
			return("on")
		}
		return("off")
	}
	if (step == "on") {
		S.trace_step = 1
	}
	else if (step == "off") {
		S.trace_step = 0
	}
	else {
		errprintf("invalid trace argument\n")
		exit(3498)
	}
}

function opt__trace_pdiffs_str(
	`OptStruct'	S,
	|string	scalar	 pdiffs
)
{
	if (args() == 1) {
		if (S.trace_pdiffs) {
			return("on")
		}
		return("off")
	}
	if (pdiffs == "on") {
		S.trace_pdiffs = 1
	}
	else if (pdiffs == "off") {
		S.trace_pdiffs = 0
	}
	else {
		errprintf("invalid trace argument\n")
		exit(3498)
	}
}

function opt__trace_params_str(
	`OptStruct'	S,
	|string	scalar	 params
)
{
	if (args() == 1) {
		if (S.trace_params) {
			return("on")
		}
		return("off")
	}
	if (params == "on") {
		S.trace_params = 1
	}
	else if (params == "off") {
		S.trace_params = 0
	}
	else {
		errprintf("invalid trace argument\n")
		exit(3498)
	}
}

function opt__trace_gradient_str(
	`OptStruct'	S,
	|string	scalar	 gradient
)
{
	if (args() == 1) {
		if (S.trace_gradient) {
			return("on")
		}
		return("off")
	}
	if (gradient == "on") {
		S.trace_gradient = 1
	}
	else if (gradient == "off") {
		S.trace_gradient = 0
	}
	else {
		errprintf("invalid trace argument\n")
		exit(3498)
	}
}

function opt__trace_hessian_str(
	`OptStruct'	S,
	|string	scalar	 hessian
)
{
	if (args() == 1) {
		if (S.trace_hessian) {
			return("on")
		}
		return("off")
	}
	if (hessian == "on") {
		S.trace_hessian = 1
	}
	else if (hessian == "off") {
		S.trace_hessian = 0
	}
	else {
		errprintf("invalid trace argument\n")
		exit(3498)
	}
}

/*STATIC*/ void opt__dot_type_grad(
	real matrix	p,
	`OptStruct'	S,
	real scalar	i
)
{
	pragma unset p
	pragma unset i
	S.dot_type = "result"
}

/*STATIC*/ void opt__dot_type_Hess(
	real matrix	p,
	`OptStruct'	S,
	real scalar	i,
	real scalar	j
)
{
	pragma unset p
	pragma unset i
	pragma unset j
	S.dot_type = "input"
}

function opt__verbose_str(`OptStruct' S,| string scalar verbose)
{
	if (args() == 1) {
		if (S.verbose) {
			return("on")
		}
		return("off")
	}
	if (verbose == "on") {
		S.verbose = 1
	}
	else if (verbose == "off") {
		S.verbose = 0
	}
	else {
		errprintf("invalid verbose setting")
		exit(198)
	}
}

function opt__verbose_num(`OptStruct' S,| real scalar verbose)
{
	if (args() == 1) {
		return(S.verbose)
	}
	opt__set_int(S.verbose,verbose,0,1)
}

void opt__link(`OptStruct' S)
{
	real	scalar	break_key, lcnt

	// WARNING:  Store a pointer to 'S' in its 'deriv()' object; decrement
	// the link counter to 'S' so that it can be automatically handled by
	// garbage collection when 'S' is not a global object.

	break_key = setbreakintr(0)
	lcnt	= sys_linkcount(S)
	deriv_init_argument(S.D, 1, S)
	if (lcnt != sys_linkcount(S)) {
		S.linked	= 1
		sys_decrlinkcount(S)
	}
	(void) setbreakintr(break_key)
}

void opt__unlink(`OptStruct' S)
{
	real	scalar	break_key

	// WARNING:  Reset the link counter to 'S' then unlink 'S' and its
	// 'deriv()' object so that 'S' can be automatically handled by
	// garbage collection.

	break_key = setbreakintr(0)
	if (S.linked) {
		S.linked	= 0
		sys_incrlinkcount(S)
	}
	deriv_init_arguments_unlink(S.D)
	(void) setbreakintr(break_key)
}

string scalar opt__onoff_numtostr(real scalar onoff)
{
	return(( onoff ? `OPT_onoff1' : `OPT_onoff0' ))
}

real scalar opt__onoff(scalar onoff, string scalar argname)
{
	if (isreal(onoff)) {
		return(opt__onoff_num(onoff, argname))
	}
	return(opt__onoff_str(onoff, argname))
}

/*STATIC*/ real scalar opt__onoff_str(
		scalar	onoff,
	string	scalar	argname
)
{
	if (isstring(onoff)) {
		if (onoff == `OPT_onoff0') {
			return(`OPT_onoff_off')
		}
		if (onoff == `OPT_onoff1') {
			return(`OPT_onoff_on')
		}
	}
	if (strlen(argname)) {
		errprintf("invalid %s argument;\n", argname)
	}
	else {
		errprintf("invalid argument;\n")
	}
	errprintf(`"only "on" or "off" is allowed\n"')
	exit(3498)
}

/*STATIC*/ real scalar opt__onoff_num(
	real	scalar	onoff,
	string	scalar	argname
)
{
	if (onoff == `OPT_onoff_off') {
		return(`OPT_onoff_off')
	}
	if (onoff == `OPT_onoff_on') {
		return(`OPT_onoff_on')
	}
	if (strlen(argname)) {
		errprintf("invalid %s argument;\n", argname)
	}
	else {
		errprintf("invalid argument;\n")
	}
	errprintf(`"only "on" or "off" is allowed\n"')
	exit(3498)
}

function opt__init_evaltype(
	`OptStruct'	S,
	string	scalar	name,
	|real	scalar	is_mopt)
{
	if (args() == 2) {
		is_mopt	= 0
	}
	S.evaltype_user = name

	if (name == "derivative0" | name == "d0") {
		S.evaltype	= `OPT_evaltype_d'
		S.evaltype_s	= "d0"
		S.evaltype_l	= "derivative0"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "derivative1" | name == "d1") {
		S.evaltype	= `OPT_evaltype_d'
		S.evaltype_s	= "d1"
		S.evaltype_l	= "derivative1"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "derivative1debug" | name == "d1debug") {
		S.evaltype	= `OPT_evaltype_d'
		S.evaltype_s	= "d1debug"
		S.evaltype_l	= "derivative1debug"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "derivative2" | name == "d2") {
		S.evaltype	= `OPT_evaltype_d'
		S.evaltype_s	= "d2"
		S.evaltype_l	= "derivative2"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "derivative2debug" | name == "d2debug") {
		S.evaltype	= `OPT_evaltype_d'
		S.evaltype_s	= "d2debug"
		S.evaltype_l	= "derivative2debug"
		S.evaltype_f	= S.evaltype_s
		return
	}

	if (name == "generalform0" | name == "gf0" | name == "v0") {
		S.evaltype	= `OPT_evaltype_v'
		S.evaltype_s	= "gf0"
		S.evaltype_l	= "generalform0"
		S.evaltype_f	= "v0"
		return
	}
	if (name == "generalform1" | name == "gf1" | name == "v1") {
		S.evaltype	= `OPT_evaltype_v'
		S.evaltype_s	= "gf1"
		S.evaltype_l	= "generalform1"
		S.evaltype_f	= "v1"
		return
	}
	if (name == "generalform1debug" |
	    name == "gf1debug" |
	    name == "v1debug") {
		S.evaltype	= `OPT_evaltype_v'
		S.evaltype_s	= "gf1debug"
		S.evaltype_l	= "generalform1debug"
		S.evaltype_f	= "v1debug"
		return
	}
	if (name == "generalform2" | name == "gf2" | name == "v2") {
		S.evaltype	= `OPT_evaltype_v'
		S.evaltype_s	= "gf2"
		S.evaltype_l	= "generalform2"
		S.evaltype_f	= "v2"
		return
	}
	if (name == "generalform2debug" |
	    name == "gf2debug" |
	    name == "v2debug") {
		S.evaltype	= `OPT_evaltype_v'
		S.evaltype_s	= "gf2debug"
		S.evaltype_l	= "generalform2debug"
		S.evaltype_f	= "v2debug"
		return
	}

	if (name == "quadraticform0" | name == "q0") {
		S.evaltype	= `OPT_evaltype_q'
		S.evaltype_s	= "q0"
		S.evaltype_l	= "quadraticform0"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "quadraticform1" | name == "q1") {
		S.evaltype	= `OPT_evaltype_q'
		S.evaltype_s	= "q1"
		S.evaltype_l	= "quadraticform1"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "quadraticform1debug" | name == "q1debug") {
		S.evaltype	= `OPT_evaltype_q'
		S.evaltype_s	= "q1debug"
		S.evaltype_l	= "generalform1debug"
		S.evaltype_f	= S.evaltype_s
		return
	}

	// the remaining evaluator types are for use by 'moptimize()'
	if (! is_mopt) {
		errprintf("invalid evaluator type\n")
		exit(3498)
	}

	if (name == "linearform" | name == "lf") {
		S.evaltype	= `OPT_evaltype_lf'
		S.evaltype_s	= "lf"
		S.evaltype_l	= "linearform"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "linearform0" | name == "lf0") {
		S.evaltype	= `OPT_evaltype_lf'
		S.evaltype_s	= "lf0"
		S.evaltype_l	= "linearform0"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "linearform1" | name == "lf1") {
		S.evaltype	= `OPT_evaltype_lf'
		S.evaltype_s	= "lf1"
		S.evaltype_l	= "linearform1"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "linearform1debug" | name == "lf1debug") {
		S.evaltype	= `OPT_evaltype_lf'
		S.evaltype_s	= "lf1debug"
		S.evaltype_l	= "linearform1debug"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "linearform2" | name == "lf2") {
		S.evaltype	= `OPT_evaltype_lf'
		S.evaltype_s	= "lf2"
		S.evaltype_l	= "linearform2"
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "linearform2debug" | name == "lf2debug") {
		S.evaltype	= `OPT_evaltype_lf'
		S.evaltype_s	= "lf2debug"
		S.evaltype_l	= "linearform2debug"
		S.evaltype_f	= S.evaltype_s
		return
	}

	if (name == "e1") {
		S.evaltype	= `OPT_evaltype_e'
		S.evaltype_s	= name
		S.evaltype_l	= name
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "e1debug") {
		S.evaltype	= `OPT_evaltype_e'
		S.evaltype_s	= name
		S.evaltype_l	= name
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "e2") {
		S.evaltype	= `OPT_evaltype_e'
		S.evaltype_s	= name
		S.evaltype_l	= name
		S.evaltype_f	= S.evaltype_s
		return
	}
	if (name == "e2debug") {
		S.evaltype	= `OPT_evaltype_e'
		S.evaltype_s	= name
		S.evaltype_l	= name
		S.evaltype_f	= S.evaltype_s
		return
	}

	errprintf("invalid evaluator type\n")
	exit(3498)
}

string scalar opt__util_technique(`OptStruct' S)
{
	if (strlen(S.cycle_names[1])) {
		return(S.cycle_names[S.cycle_idx])
	}
	return(S.technique)
}

real scalar opt__util_iter(`OptStruct' S)
{
	return(S.iter)
}

void opt__util_reset_cycle(`OptStruct' S)
{
	S.cycle_iter = `OPT_cycle_iter_default'
	S.cycle_idx = `OPT_cycle_iter_default'
}

function optimize_reset_log(`OptStruct' S)
{
	S.log = `OPT_log_default'

}

real scalar opt__doCns(`OptStruct' S)
{
	if (S.hasCns) {
		return(cols(S.params)==cols(S.T))
	}
	return(0)
}

void opt__check_fullRankCns(`OptStruct' S)
{

	if (missing(S.hasCns)) {
		S.fullRankCns = 0
		return
	}
	
	S.fullRankCns = cols(S.params) == rows(S.constraints)

	// still need to check if this is a valid constraint matrix
	if (S.fullRankCns) {

		real scalar r, c, c1, i, rc
		real vector ix, p, sub
		real matrix Cns
		
		r = rows(S.constraints)
		c = cols(S.constraints)
		c1 = c-1
		
		ix = 1..c1
		p = J(1,c1,0)
		
		// if more than one '1' per column, redundant constraints
		for (i=1; i<c; i++) {
			sub = S.constraints[.,i]
			if (sum(sub :== 1) > 1) {
				errprintf("redundant or inconsistent constraints\n")
				exit(412)
			}
		}
		
		// add an extra parameter to fool _cns_eigen()
		Cns = S.constraints
		Cns = J(r,1,0), Cns

		rc = _cns_eigen(Cns, S.T, S.a)

		if (rc) {
			S.constraints = Cns
			S.fullRankCns = 0
			return
		}
		else {
			// remove extra parameter
			S.constraints = Cns[|1,2 \ r,c+1|]
			S.T = S.T[2..c]
			S.a = S.a[2..c]
			S.gradient = J(1,c1,0)
		}

		// put constraints in the order of the parameters
		
		// create permutation vector
		for (i=1; i<c; i++) {
			sub = S.constraints[|i,1 \ i,c1|]
			p[i] = sum( (sub:==1) :* ix)
		}
		
		// put all 1's in R on the main diagonal
		S.constraints = S.constraints[invorder(p),.]
		
		S.params = S.a
	}
}

`Errcode' opt__eval_fullRankCns(`OptStruct' S)
{
	`Errcode'	ec

	if (S.use_deriv) {
		opt__link(S)
	}	
	ec = (*S.eval)(S,0)
	if (S.use_deriv) {
		opt__unlink(S)
	}
	return(ec)
}

end
