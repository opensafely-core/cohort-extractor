*! version 1.5.0  11apr2018
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'
findfile moptimize_include.mata
quietly include `"`r(fn)'"'

mata:

void mopt__st_post_extra(`MoptStruct' M)
{
	real	scalar		stata_user
	real	scalar		stata_prolog
	real	matrix		b0

	stata_user	= (M.st_user != `MOPT_st_user_default')
	stata_prolog	= (M.st_userprolog != `MOPT_st_userprolog_default')
	if (!stata_user & !stata_prolog) {
		return
	}

	if (M.S.constraints != `OPT_constraints_default') {
		b0 = M.S.params
		opt__cns_on(M.S, 0)
		st_global("ML_kCns",	strofreal(cols(M.S.params)))
		M.S.params = b0
	}
}

`Errcode' mopt__st_validate(`MoptStruct' M)
{
	real	scalar		i
	real	scalar		dim
	real	scalar		stata_user
	real	scalar		stata_prolog

	stata_user	= (M.st_user != `MOPT_st_user_default')
	stata_prolog	= (M.st_userprolog != `MOPT_st_userprolog_default')

	if (M.interactive) {
		robust_init_skip_setup(M.S.R, "off")
	}

	if (robust_init_skip_setup(M.S.R) == "off") {
		moptimize_init_svy_setup(M)
	}
	else {
		mopt__rebuild_data(M, 0)
	}

	if (stata_user | stata_prolog) {
		// the user supplied evaluator is a Stata program
		M.st_p	= st_tempname()
		M.st_v	= st_tempname()
		if (M.S.evaltype_f != "lf") {
			M.st_g	= st_tempname()
			M.st_H	= st_tempname()
		}
		if (any(M.S.evaltype_f :== tokens("e1 lf0 lf1 lf1debug lf2debug"))) {
			M.st_delta	= st_tempname(M.neq)
		}
	}

	mopt__build_eqdims(M)

	if (!stata_user & !stata_prolog) {
		return(0)
	}

	if (M.st_touse == `MOPT_st_touse_default') {
		M.st_touse = st_varname(mopt__st_tempvar(1, "byte", 1))
	}

	if (stata_prolog) {
		M.st_cmd_prolog = sprintf("%s %s",
			M.st_userprolog,
			M.st_p)
	}

	M.st_cmd_args	= ""
	if (stata_user & (`OPT_evaltype_v' <= M.S.evaltype) &
	    (M.S.evaltype <= `OPT_evaltype_e')) {
		if (M.S.evaltype <= `OPT_evaltype_q') {
			dim = M.eqdims[2,M.neq]
		}
		else {
			dim = M.neq
		}
		if (M.S.evaltype_f == "lf") {
			M.st_xb = st_varname(mopt__st_tempvar(dim, "double"))
			M.st_cmd_args = sprintf("%s %s %s",
				M.st_user,
				M.st_v,
				invtokens(M.st_xb))
			st_view(M.xb, ., M.st_xb, M.st_touse)
		}
		else if (all(M.S.evaltype_f :!= tokens("v0 q0 lf0"))) {
			M.st_scores = st_varname(
				mopt__st_tempvar(dim, "double"))
			M.st_cmd_args = invtokens(M.st_scores)
			if (any(M.S.evaltype_f :== tokens("e1 e2 lf1 lf2"))) {
				if (M.view == `OPT_onoff_on') {
					st_view(M.S.gradient_v,
						.,
						M.st_scores,
						M.st_touse)
				}
			}
		}
	}

	if (stata_user & M.S.evaltype_f != "lf") {
		if (any(M.S.evaltype_f :== tokens("lf0 lf1 lf1debug lf2 lf2debug"))) {
			M.st_cmd_args = sprintf("%s %s %s %s",
				M.st_p,
				M.st_v,
				M.st_cmd_args,
				M.st_H)
		}
		else {
			M.st_cmd_args = sprintf("%s %s %s %s %s",
				M.st_p,
				M.st_v,
				M.st_g,
				M.st_H,
				M.st_cmd_args)
		}
	}

	// generate the global macros consumed by ado-file likelihood
	// evaluators:
	//	ML_samp		-- identifies estimation sample
	//	ML_n		-- number of equations
	//	ML_f		-- scalar/variable holding function value
	//	ML_b		-- vector of parameters
	//	ML_k		-- number of parameters
	//	ML_kCns		-- number of unconstrained parameters
	//	ML_ic		-- current value of iteration counter
	//	ML_N		-- number of observations
	//	ML_y		-- dependent variables
	//	ML_y#		-- dependent variable ##
	//	ML_k#		-- number of parameters    for equation ##
	//	ML_fp#		-- first parameter index   for equation ##
	//	ML_lp#		-- last  parameter index   for equation ##
	//	ML_ip#		-- constant only indicator for equation ##
	//	ML_x#		-- predictor variables     for equation ##
	//	ML_xc#		-- "" or "nocons"          for equation ##
	//	ML_xe#		-- exposure variable       for equation ##
	//	ML_xo#		-- offset variable         for equation ##
	//	ML_wtyp		-- weight type
	//	ML_w		-- weight variable
	//	ML_ec		-- comment command, "*"

	st_global("ML_samp",	M.st_touse)
	st_global("ML_n",	strofreal(M.neq))
	st_global("ML_b",	M.st_p)
	st_global("ML_f",	M.st_v)
	st_global("ML_k",	strofreal(M.eqdims[2,M.neq]))
	st_global("ML_kCns",	strofreal(M.eqdims[2,M.neq]))
	st_global("ML_ic",	strofreal(M.S.iter))
	st_global("ML_N",	strofreal(M.obs))

	st_global("ML_y", invtokens(M.st_depvars))
	for (i=1; i<=M.ndepvars; i++) {
		st_global(sprintf("ML_y%f",i), M.st_depvars[i])
	}
	for (i=1; i<=M.neq; i++) {
		st_global(sprintf("ML_fp%f",i), strofreal(M.eqdims[1,i]))
		st_global(sprintf("ML_lp%f",i), strofreal(M.eqdims[2,i]))
		st_global(sprintf("ML_k%f", i),
			strofreal(1+M.eqdims[2,i]-M.eqdims[1,i]))
		if (M.eqdims[1,i] == M.eqdims[2,i] & M.eqcons[i]) {
			st_global(sprintf("ML_ip%f",i), "1")
		}
		else {
			st_global(sprintf("ML_ip%f",i), "0")
		}
		if (M.eqlist[i] != NULL) {
			st_global(sprintf("ML_x%f",i), M.st_eqlist[i])
		}
		if (!M.eqcons[i]) {
			st_global(sprintf("ML_xc%f",i), "nocons")
		}
		if (M.eqoffset[i] != NULL) {
			st_global(sprintf("ML_x%s%f",
					(M.eqexposure[i] ? "e" : "o"), i),
				M.st_eqoffset_revar[i])
		}
	}
	if (M.st_wvar != `MOPT_st_wvar_default') {
		st_global("ML_wtyp",	opt__wtype(M.S))
		if (M.wtype == `OPT_wtype_a') {
			M.st_tmp_w = M.st_genwvar
			if (M.st_tmp_w == `MOPT_st_tmp_w_default') {
				M.st_tmp_w = st_varname(
					mopt__st_tempvar(1, "double"))
			}
			if (missing(_st_varindex(M.st_tmp_w))) {
				i = _stata(sprintf("qui gen double %s = .",
					M.st_tmp_w))
				if (i) exit(i)
			}
			real matrix W
			pragma unset W
			st_view(W, ., M.st_tmp_w, M.st_touse)
			W[,] = M.S.weights
			st_global("ML_w",	M.st_tmp_w)
		}
		else {
			st_global("ML_w",	M.st_wvar)
		}
	}
	else if (nonmissing(_st_varindex(M.st_genwvar))) {
		st_global("ML_w", M.st_genwvar)
	}
	else	st_global("ML_w", M.st_touse)
	if (any(M.S.evaltype_f :== tokens("e1 e2"))) {
		st_global("ML_ec", "*")
	}
	else {
		st_global("ML_ec", "")
	}
	return(0)
}

real rowvector mopt__st_tempvar(
	|real	scalar	n,
	string	scalar	type,
	real	scalar	value
)
{
	`Errcode'		ec
	string	rowvector	names
	real	scalar		i

	if (args() < 1) {
		n	= 1
	}
	if (args() < 2) {
		type	= ""
	}
	if (args() < 3) {
		value	= .
	}

	names	= st_tempname(n)
	for (i=1; i<=n; i++) {
		ec = _stata(sprintf("qui gen %s %s = %g",
			type, names[i], value))
		if (ec) exit(ec)
	}
	return(st_varindex(names))
}

void mopt__st_user_setup(`MoptStruct' M, real rowvector params)
{
	`Errcode'	ec
	real scalar	i

	st_matrix(M.st_p, params)
	st_matrixcolstripe(M.st_p, (*M.S.stripes[1]))
	st_global("ML_ic", strofreal(M.S.iter))

	if (M.S.evaltype == `OPT_evaltype_v' |
	    M.S.evaltype == `OPT_evaltype_q' |
	    M.S.evaltype == `OPT_evaltype_lf') {
		stata(sprintf("capture drop %s", M.st_v))
		ec = _stata(sprintf("qui gen double %s = . in 1", M.st_v))
		if (ec) exit(ec)
	}
	else {
		ec = _stata(sprintf("capture scalar drop %s", M.st_v))
		if (ec) exit(ec)
	}
	if (any(M.S.evaltype_f :== tokens("e1 e1debug lf0 lf1 lf1debug lf2debug"))) {
		for (i=1; i<=M.neq; i++) {
			if (M.eqdelta[i]) {
				st_global(sprintf("ML_delta%f",i),
					M.st_delta[i])
				st_numscalar(M.st_delta[i], M.eqdelta[i])
			}
			else {
				st_global(sprintf("ML_delta%f",i),"")
			}
		}
	}
}

void mopt__st_prolog(
	real	rowvector	params,
	`MoptStruct'		M,
	real	scalar		v
)
{
	`Errcode'	ec
	real	scalar	uv

	mopt__st_user_setup(M, params)

	ec = _stata(M.st_cmd_prolog)
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}
	uv = st_numscalar(M.st_v)
	if (length(uv) != 0 & !missing(uv)) {
		v = uv
	}
}

void mopt__st_user_d2debug(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}
 
	params = st_matrix(M.st_p)
	v = st_numscalar(M.st_v)
	if (length(v) == 0) {
		v = .
	}
	if (todo) {
		g = st_matrix(M.st_g)
	}
	if (todo == 2) {
		H = st_matrix(M.st_H)
	}
}

void mopt__st_user_d2(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	real	scalar	dim

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}
 
	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}
	v = st_numscalar(M.st_v)
	if (length(v) == 0) {
		v = .
	}
	if (todo) {
		g = st_matrix(M.st_g)
		if (length(g) == 0) {
			v = .
		}
	}
	if (todo == 2) {
		H = st_matrix(M.st_H)
		if (length(H) == 0) {
			v = .
			if (!M.check) {
				dim = cols(M.S.params)
				H = J(dim, dim, .)
			}
		}
	}
}

void mopt__st_user_d1debug(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	params = st_matrix(M.st_p)
	v = st_numscalar(M.st_v)
	if (length(v) == 0) {
		v = .
	}
	if (todo) {
		g = st_matrix(M.st_g)
	}
}

void mopt__st_user_d1(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}
	v = st_numscalar(M.st_v)
	if (length(v) == 0) {
		v = .
	}
	if (todo) {
		g = st_matrix(M.st_g)
		if (length(g) == 0) {
			v = .
		}
	}
}

void mopt__st_user_d0(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset g
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}
	v = st_numscalar(M.st_v)
	if (length(v) == 0) {
		v = .
	}
}

void mopt__st_user_v2debug(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	params = st_matrix(M.st_p)

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
	if (todo) {
		g = st_data(., M.st_scores, M.st_touse)
	}
	if (todo == 2) {
		H = st_matrix(M.st_H)
	}
}

void mopt__st_user_v2(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
	if (todo) {
		g = st_data(., M.st_scores, M.st_touse)
		if (length(g) == 0) {
			v = .
		}
	}
	if (todo == 2) {
		H = st_matrix(M.st_H)
		if (length(H) == 0) {
			v = .
		}
	}
}

void mopt__st_user_v1debug(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	params = st_matrix(M.st_p)

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
	if (todo) {
		g = st_data(., M.st_scores, M.st_touse)
	}
}

void mopt__st_user_v1(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
	if (todo) {
		g = st_data(., M.st_scores, M.st_touse)
		if (length(g) == 0) {
			v = .
		}
	}
}

void mopt__st_user_v0(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset g
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
}

void mopt__st_user_lf(
	`MoptStruct'		M,
	real	rowvector	params,
	real	matrix		v
)
{
	`Errcode'	ec

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s",
			M.caller_version,
			M.st_trace,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
}

void mopt__st_user_lf0(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset g
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
}

void mopt__st_user_lf1debug(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	params = st_matrix(M.st_p)

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
	if (todo) {
		g = st_data(., M.st_scores, M.st_touse)
	}
}

void mopt__st_user_lf1(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo>0,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
	if (todo) {
		// NOTE: todo == 2 means that we are taking derivatives of the
		// scores in order to compute 2nd degree scores for the
		// Hessian.  We cannot use a view in this case.

		if (M.view == `OPT_onoff_off' | todo == 2) {
			g = mopt__st_getdata(M, invtokens(M.st_scores))
		}
		else {
			st_view(g, ., M.st_scores, M.st_touse)
		}
	}
}

void mopt__st_user_lf2debug(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	params = st_matrix(M.st_p)

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)
	if (todo) {
		g = st_data(., M.st_scores, M.st_touse)
	}
	if (todo == 2) {
		H = st_matrix(M.st_H)
	}
}

void mopt__st_user_lf2(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}

	// NOTE: 'v' cannot be a view because this routine is being called
	// with perturbed parameter values in order to compute numerical
	// derivatives.

	v = st_data(., M.st_v, M.st_touse)

	// NOTE: 'g' should be the same as 'M.S.gradient_v', which is already
	// a view when 'M.view is on, so we shouldn't have to pull it from the
	// dataset unless the Stata evaluator dropped variables.

	if (M.view == `OPT_onoff_on') {
		if (st_viewvars(M.S.gradient_v) != st_varindex(M.st_scores)) {
			st_view(M.S.gradient_v,
				.,
				M.st_scores,
				M.st_touse)
		}
	}
	else if (todo) {
		g = mopt__st_getdata(M, invtokens(M.st_scores))
	}

	if (todo == 2) {
		H = st_matrix(M.st_H)
		if (length(H) == 0) {
			v = .
		}
	}
}

void mopt__st_user_e2debug(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	params = st_matrix(M.st_p)
	v = st_numscalar(M.st_v)
	if (length(v) == 0) {
		v = .
	}
	if (todo) {
		g = mopt__st_getdata(M, invtokens(M.st_scores))
	}
	if (todo == 2) {
		H = st_matrix(M.st_H)
	}
}

void mopt__st_user_e2(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	real	scalar	dim
	pragma unset g

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}
	v = st_numscalar(M.st_v)
	if (length(v) == 0) {
		v = .
	}

	// NOTE: 'g' should be the same as 'M.S.gradient_v', which is already
	// a view when 'M.view is on, so we shouldn't have to pull it from the
	// dataset unless the Stata evaluator dropped variables.

	if (M.view == `OPT_onoff_on') {
		if (st_viewvars(M.S.gradient_v) != st_varindex(M.st_scores)) {
			st_view(M.S.gradient_v,
				.,
				M.st_scores,
				M.st_touse)
		}
	}
	else if (todo) {
		g = mopt__st_getdata(M, invtokens(M.st_scores))
	}

	if (todo == 2) {
		H = st_matrix(M.st_H)
		if (length(H) == 0) {
			v = .
			if (!M.check) {
				dim = cols(M.S.params)
				H = J(dim, dim, .)
			}
		}
	}
}

void mopt__st_user_e1debug(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	params = st_matrix(M.st_p)
	v = st_numscalar(M.st_v)
	if (length(v) == 0) {
		v = .
	}
	if (todo) {
		g = mopt__st_getdata(M, invtokens(M.st_scores))
	}
}

void mopt__st_user_e1(
	`MoptStruct'		M,
	real	scalar		todo,
	real	rowvector	params,
	real	matrix		v,
	real	matrix		g,
	real	matrix		H
)
{
	`Errcode'	ec
	pragma unset g
	pragma unset H

	mopt__st_user_setup(M, params)

	ec = _stata(sprintf("version %g: %s %s %f %s",
			M.caller_version,
			M.st_trace,
			M.st_user,
			todo>0,
			M.st_cmd_args))
	if (ec) {
		if (M.check) {
			M.st_rc = ec
			return
		}
		exit(ec)
	}

	if (M.check | M.p_updated) {
		params = st_matrix(M.st_p)
	}
	v = st_numscalar(M.st_v)
	if (length(v) == 0) {
		v = .
	}

	if (todo) {
		// NOTE: todo == 2 means that we are taking derivatives of the
		// scores in order to compute 2nd degree scores for the
		// Hessian.  We cannot use a view in this case.

		if (M.view == `OPT_onoff_off' | todo == 2) {
			g = mopt__st_getdata(M, invtokens(M.st_scores))
		}
		else {
			st_view(g, ., M.st_scores, M.st_touse)
		}
	}
}

// functions exclusively intended for the -mopt- command --------------------

function mopt__init_k_autoCns(`MoptStruct' M, | real scalar k)
{
	if (args() == 1) {
		return(M.k_autoCns)
	}
	else {
		M.k_autoCns = missing(k) ? `MOPT_k_autoCns_default' : k
	}
}

function mopt__init_macros_drop(`MoptStruct' M, |real scalar drop)
{
	if (args() == 1) {
		return(M.st_drop_macros)
	}
	else {
		M.st_drop_macros = drop
	}
}

function mopt__init_regetviews(`MoptStruct' M, |real scalar regetviews)
{
	if (args() == 1) {
		return(M.st_regetviews)
	}
	M.st_regetviews = (regetviews != 0)
}

void mopt__init_interactive(`MoptStruct' M, |real scalar onoff)
{
	if (args() == 1) {
		return(M.interactive)
	}
	M.interactive	= (onoff != 0)
}

void mopt__st_check_program(string scalar user)
{
	if (_stata(sprintf("mopt_check_program %s", user))) {
		exit(199)
	}
}

void Mopt_error(string scalar msg, real scalar rc)
{
	errprintf("%s\n", msg)
	exit(rc)
}

pointer(transmorphic) scalar Mopt_new_external(|string scalar name)
{
	pointer(transmorphic) scalar pM
	real	scalar	i

	if (name != J(1, 1, "")) {
		pM = findexternal(name)
		if (pM != NULL) {
			st_global("ML_M",name)
			return(pM)
		}
	}
	else {
		i = 0
		do {
			++i
			pM = findexternal( name = sprintf("_MLM%f",i) )
		} while (pM != NULL)
	}
	st_global("ML_M",name)
	pM = crexternal(name)
	return(pM)
}

pointer(transmorphic) scalar Mopt_get_external()
{
	pointer(transmorphic) scalar pM
	string	scalar	name

	name = st_global("ML_M")
	if (name == "") {
		Mopt_error("model not defined", 111)
	}
	pM = findexternal(name)
	if (pM == NULL) {
		Mopt_error("model not defined", 111)
	}
	return(pM)
}

void Mopt_drop_external()
{
	string scalar name

	name = st_global("ML_M")
	if (name == "") return
	rmexternal(name)
}

void Mopt_model()
{
	// Stata macros:
	//	version		-- caller's version
	// 	ML_sample	-- estimation subpop sample indicator (global)
	// 	ML_samp		-- estimation sample indicator (global)
	// 	lhs		-- left hand side variables
	// 	eq_n		-- number of equations
	// 	eq_rhs#		-- right hand side variables for equation #
	// 	eq_nocons#	-- indicator for constant in equation #
	//	eq_offset#	-- offset variable
	//	eq_exposure#	-- indicator to treat offset as exposure
	//	eq_freeparm#	-- indicator to as free parameter
	//	eq_names	-- equation names for the parameter vector

	pointer(`MoptStruct')		scalar	pM
	pointer(function)	scalar	pf
	pointer			scalar	ptr

	real		scalar		ec
	string		scalar		eval_name
	string		scalar		prolog_name
	string		scalar		offset
	string		scalar		usrname
	string		vector		names
	real		scalar		exposure
	real		scalar		freeparm
	real		scalar		neq
	string		scalar		rhs
	real		scalar		cons
	real		scalar		i, n
	real		matrix		C

	usrname = st_local("moptobj")
	pM = Mopt_new_external(usrname)

	(*pM) = moptimize_init()
	mopt__init_macros_drop((*pM), 0)

	moptimize_init_caller_version((*pM), strtoreal(st_local("version")))

	// user specified objective/evaluator function
	if (st_local("evaltype") != "") {
		moptimize_init_evaluatortype((*pM), st_local("evaltype"))
	}
	eval_name = st_local("evaluator")
	if (strmatch(eval_name, "*()")) {
		pf = findexternal(eval_name)
		if (pf == NULL) {
			errprintf("evaluator %s not found\n",
				eval_name)
			exit(111)
		}
		moptimize_init_evaluator((*pM), pf)
	}
	else {
		moptimize_init_evaluator((*pM), eval_name)
	}

	// user specified iteration prolog function
	prolog_name = st_local("iterprolog")
	if (prolog_name != "") {
		if (strmatch(prolog_name, "*()")) {
			pf = findexternal(prolog_name)
			if (pf == NULL) {
				errprintf("%s not found\n", prolog_name)
				exit(111)
			}
			moptimize_init_iterprolog((*pM), pf)
		}
		else {
			ec = _stata(sprintf("quietly which %s", prolog_name))
			if (ec) {
				exit(ec)
			}
			moptimize_init_iterprolog((*pM), prolog_name)
		}
	}

	// user specified derivative prolog function
	prolog_name = st_local("derivprolog")
	if (prolog_name != "") {
		if (!strmatch(prolog_name, "*()")) {
			errprintf("invalid derivprolog() option;\n")
			errprintf("only Mata functions are allowed\n")
			exit(198)
		}
		pf = findexternal(prolog_name)
		if (pf == NULL) {
			errprintf("%s not found\n", prolog_name)
			exit(111)
		}
		moptimize_init_derivprolog((*pM), pf)
	}

	if (st_local("useviews") != "") {
		moptimize_init_useviews((*pM), 1)
	}

	// estimation sample indicator variable
	moptimize_init_touse((*pM), st_global("ML_samp"))
	moptimize_init_touse_full((*pM), st_global("ML_sample"))

	// left hand side variables
	ec	= _st_varlist(st_local("lhs"), 0, 1)
	if (ec) exit(ec)
	names	= tokens(st_local("lhs"))
	n	= length(names)
	if (n) {
		moptimize_init_ndepvars((*pM), n)
		for (i=1; i<=n; i++) {
			moptimize_init_depvar((*pM), i, names[i])
		}
	}

	// equations:	right hand side variables
	// 		intercept (_cons)
	// 		offset/exposure
	// 		freeparm
	neq	= strtoreal(st_local("eq_n"))
	moptimize_init_eq_n((*pM), neq)
	moptimize_init_eq_names((*pM), st_local("eq_names"))
	for (i=1; i<=neq; i++) {
		rhs	= st_local(sprintf("eq_rhs%f",i))
		cons	= strtoreal(st_local(sprintf("eq_nocons%f",i))) == 0
		offset	= st_local(sprintf("eq_offset%f",i))
		exposure= strtoreal(st_local(sprintf("eq_exposure%f",i)))
		freeparm= strtoreal(st_local(sprintf("eq_freeparm%f",i)))
		if (strlen(rhs)) {
			moptimize_init_eq_indepvars((*pM), i, rhs, cons, 1)
		}
		if (offset != "") {
			if (exposure) {
				moptimize_init_eq_exposure((*pM), i, offset)
			}
			else {
				moptimize_init_eq_offset((*pM), i, offset)
			}
		}
		if (freeparm) {
			moptimize_init_eq_freeparm((*pM), i, freeparm)
		}
	}

	// check if additional global macros are needed by recallable evaluator
	moptimize_init_macros((*pM))

	// weights
	if (strlen(st_local("svy"))) {
		moptimize_init_svy((*pM), "on")
		moptimize_init_svy_V_srs((*pM), 1)
		moptimize_init_svy_subpop((*pM), st_local("subpop"))
		moptimize_init_svy_subuse((*pM), st_global("ML_subv"))
		moptimize_init_genwvar((*pM),    st_global("ML_w"))
	}
	else if (st_global("ML_w") != "") {
		moptimize_init_weight((*pM),
			st_global("ML_w"),
			st_local("wtype"))
		moptimize_init_genwvar((*pM),    st_global("ML_w"))
	}
	// vce(cluster ...)
	names = st_local("cluster")
	if (names != "") {
		moptimize_init_svy_nstages((*pM), 1)
		moptimize_init_svy_stage_units((*pM), 1, names)
		moptimize_init_svy_subuse((*pM), st_global("ML_subv"))
	}

	moptimize_init_obs((*pM), strtoreal(st_local("obs")))

	// group(...)
	names = st_global("ML_grp")
	if (names == "") {
		names = st_global("ML_group")
	}
	if (names != "") {
		moptimize_init_by((*pM), names)
	}

	// options consumed by the moptimize_init_*() routines
	if (st_local("technique") != "") {
		moptimize_init_technique((*pM), st_local("technique"))
	}
	if (st_local("iterid") != "") {
		moptimize_init_iterid((*pM), st_local("iterid"))
	}
	if (st_local("crittype") != "") {
		moptimize_init_valueid((*pM), st_local("crittype"))
	}
	if (st_local("b0") != "") {
		Mopt_set_b0()
	}
	if (st_local("C") != "") {
		C = st_matrix(st_local("C"))
		moptimize_init_constraints((*pM), C)
		mopt__init_k_autoCns((*pM),strtoreal(st_local("k_autoCns")))
	}
	moptimize_init_vcetype((*pM), st_local("vce"))
	if (st_local("negh") != "") {
		moptimize_init_negH((*pM),1)
	}

	if (st_local("bracket") != "") {
		moptimize_init_deriv_search((*pM), "bracket")
	}
	else {
		moptimize_init_deriv_search((*pM), "interpolate")
	}

	if (st_local("derivscale") != "") {
		moptimize_init_deriv_scale((*pM),
			st_matrix(st_local("derivscale")))
	}
	if (st_local("derivh") != "") {
		moptimize_init_deriv_h((*pM),
			st_matrix(st_local("derivh")))
	}

	if (st_local("gnwmatrix") != "") {
		moptimize_init_gnweightmatrix((*pM),
			st_matrix(st_local("gnwmatrix")))
	}

	names = st_local("kauxiliary")
	if (strlen(names)) {
		moptimize_init_kaux((*pM), strtoreal(names))
	}

	n = strtoreal(st_local("ndiparm"))
	if (n) {
		names	= J(n,1,"")
		for (i=1; i<=n; i++) {
			names[i] = st_local(sprintf("diparm%f",i))
		}
		moptimize_init_diparm((*pM), names)
	}

	names = tokens(st_local("userinfo"))
	n = cols(names)
	for (i=1; i<=n; i++) {
		ptr	= findexternal(names[i])
		if (ptr == NULL) {
			errprintf("Mata object '%s' not found\n", names[i])
			exit(111)
		}
		moptimize_init_userinfo((*pM), i, (*ptr))
	}

	moptimize_init_title((*pM), st_local("title"))

	if (strlen(st_local("pupdated"))) {
		mopt__init_pupdated((*pM), `OPT_onoff_on')
	}

	if (st_local("interactive") == "1") {
		mopt__init_regetviews((*pM), 1)
	}
	ec = mopt__st_validate((*pM))
	if (ec) exit(ec)
}

void Mopt_get_b0()
{
	pointer(transmorphic) scalar pM
	string	scalar		b0
	real	colvector	p0

	pM = Mopt_get_external()
	if (_moptimize_validate((*pM))) {
		exit(moptimize_result_returncode((*pM)))
	}
	b0 = st_local("b0")
	p0 = moptimize_init_coefs((*pM))
	if (cols(p0) == 0) {
		st_matrix(b0, J(1,cols(moptimize_result_colstripe((*pM))),0))
	}
	else {
		st_matrix(b0, p0)
	}
	st_matrixcolstripe(b0, moptimize_result_colstripe((*pM)))
}

void Mopt_set_b0()
{
	pointer(transmorphic) scalar pM
	real matrix b0

	pM = Mopt_get_external()
	b0 = st_matrix(st_local("b0"))
	moptimize_init_coefs((*pM), b0)
	moptimize_reset_params((*pM), b0)
	moptimize_reset_p0((*pM))
}

void Mopt_search()
{
	pointer(transmorphic) scalar pM
	real	scalar	neq, i
	real	scalar	rc
	real	vector	bounds
	string	scalar	name
	real	vector	trace
	pragma unset trace

	pM = Mopt_get_external()

	bounds	= J(1,2,.)

	// bounds
	name = st_local("lb_1")
	if (name != "") {
		bounds[1] = strtoreal(name)
		bounds[2] = strtoreal(st_local("ub_1"))
		moptimize_init_search_bounds((*pM),1,bounds)
	}
	neq = moptimize_init_eq_n((*pM))
	for (i=1; i<=neq; i++) {
		name = st_local(sprintf("lb_%s",
			moptimize_init_eq_name((*pM),i)))
		if (name != "") {
			bounds[1] = strtoreal(name)
			bounds[2] = strtoreal(st_local(sprintf("ub_%s",
				moptimize_init_eq_name((*pM),i))))
			moptimize_init_search_bounds((*pM),i,bounds)
		}
	}

	// temporarily store changed settings
	mopt__trace_store((*pM), trace)

	// search options
	Mopt_tracelevel(pM)
	if (st_local("repeat") != "") {
		moptimize_init_search_repeat((*pM),
			strtoreal(st_local("repeat")))
	}
	if (st_local("rescale") != "") {
		moptimize_init_search_rescale((*pM), "off")
	}
	else {
		moptimize_init_search_rescale((*pM), "on")
	}
	if (st_local("restart") != "") {
		moptimize_init_search_random((*pM), "on")
	}
	else {
		moptimize_init_search_random((*pM), "off")
	}
	if (st_local("maxmin") == "minimize") {
		moptimize_init_which((*pM), "min")
	}
	else {
		moptimize_init_which((*pM), "max")
	}

	if (moptimize_result_iterations((*pM))) {
		moptimize_reset_p0((*pM))
	}

	rc = _moptimize_search((*pM))

	// restore temporarily changed settings
	mopt__trace_restore((*pM), trace)
	if (rc) {
		exit(moptimize_result_returncode((*pM)))
	}
}

void Mopt_init_regetviews()
{
	pointer(transmorphic) scalar pM

	pM = Mopt_get_external()
	mopt__init_regetviews((*pM), 1)
}

void Mopt_init_interactive(real scalar onoff)
{
	pointer(transmorphic) scalar pM

	pM = Mopt_get_external()
	mopt__init_interactive((*pM), onoff)
}

void Mopt_maxmin()
{
	pointer(transmorphic) scalar pM
	real	scalar	ec

	pM = Mopt_get_external()

	if (st_local("maxmin") == "minimize") {
		moptimize_init_which((*pM), "min")
	}
	else {
		moptimize_init_which((*pM), "max")
	}
	if (st_local("negh") != "") {
		moptimize_init_negH((*pM),1)
	}
	if (st_local("tolerance") != "") {
		moptimize_init_conv_ptol((*pM),
			strtoreal(st_local("tolerance")))
	}
	if (st_local("ltolerance") != "") {
		moptimize_init_conv_vtol((*pM),
			strtoreal(st_local("ltolerance")))
	}
	if (st_local("gtolerance") != "") {
		moptimize_init_conv_gtol((*pM),
			strtoreal(st_local("gtolerance")))
	}
	if (st_local("nrtolerance") != "") {
		moptimize_init_conv_nrtol((*pM),
			strtoreal(st_local("nrtolerance")))
	}
	if (st_local("qtolerance") != "") {
		moptimize_init_conv_qtol((*pM),
			strtoreal(st_local("qtolerance")))
	}
	if (st_local("nonrtolerance") != "") {
		moptimize_init_conv_ignorenrtol((*pM), "on")
	}
	if (st_local("notconcave") != "") {
		moptimize_init_conv_notconcave((*pM),
			strtoreal(st_local("notconcave")))
	}
	if (st_local("iterate") != "") {
		moptimize_init_conv_maxiter((*pM),
			strtoreal(st_local("iterate")))
	}
	if (st_local("ndami") != "") {
		moptimize_init_conv_ndami((*pM), "on")
	}
	else {
		moptimize_init_conv_ndami((*pM), "off")
	}
	if (st_local("difficult") != "") {
		moptimize_init_singularHmethod((*pM), "hybrid")
	}
	if (st_local("halfsteponly") != "") {
		moptimize_init_step_forward((*pM), "off")
	}
	if (st_local("doopt") != "") {
		mopt__init_doopt((*pM), "on")
	}
	if (st_local("warning") != "") {
		moptimize_init_conv_warning((*pM), "off")
	}

	Mopt_tracelevel(pM)
	moptimize_init_search((*pM), "off")

	if (moptimize_result_iterations((*pM))) {
		moptimize_reset_p0((*pM))
	}

	ec = _moptimize((*pM))
	if (ec) {
		moptimize_ado_cleanup((*pM))
		exit(moptimize_result_returncode((*pM)))
	}

	moptimize_result_post((*pM))
	if (moptimize_init_svy((*pM)) != "on") {
		st_numscalar("e(ll)",	moptimize_result_value((*pM)))
	}
	else {
		st_global("e(adjust)",	st_global("ML_noadj"))
		st_global("e(svyml)",	"svyml")
	}
	moptimize_ado_cleanup((*pM))
}

void Mopt_score(real scalar iter0)
{
	pointer(transmorphic) scalar pM
	real	matrix	scores
	string	scalar	name
	real	scalar	ec
	real	scalar maxiter
		scalar	warn
	pragma unset scores

	pM = Mopt_get_external()

	if (iter0) {
		if ((name = st_local("scale")) != "") {
			moptimize_init_deriv_scale((*pM), st_matrix(name))
			name = st_local("h")
			moptimize_init_deriv_h((*pM), st_matrix(name))
		}
		moptimize_init_which((*pM), st_local("which"))
		warn = moptimize_init_conv_warning((*pM))
		moptimize_init_conv_warning((*pM), "off")
		maxiter = moptimize_init_conv_maxiter((*pM))
		moptimize_init_conv_maxiter((*pM), 0)
		ec = _moptimize_validate((*pM))
		if (!ec) {
			ec = _moptimize_evaluate((*pM), 1)
		}
		moptimize_init_conv_warning((*pM), warn)
		moptimize_init_conv_maxiter((*pM), maxiter)
		if (ec) {
			exit(moptimize_result_returncode((*pM)))
		}
	}
	if (rows(moptimize_result_scores((*pM))) == 0) {
		return
	}
	st_view(scores, ., tokens(st_local("scores")), st_global("ML_samp"))
	scores[,] = moptimize_result_scores((*pM))
}

void Mopt_set_trace()
{
	pointer(transmorphic) scalar pM

	pM = Mopt_get_external()
	if (moptimize_init_evaluator(((*pM))) == "") {
		Mopt_error("trace not allowed with Mata evaluators", 198)
	}
	else {
		moptimize_init_trace_ado((*pM),st_local("onoff"))
	}
}

void Mopt_get_counts()
{
	pointer(`MoptStruct') scalar pM
	real	matrix	t
	real	scalar	is_lf

	pM = Mopt_get_external()
	if (moptimize_init_evaluations((*pM)) == "on") {
		is_lf	= any(pM->S.evaltype_f :== tokens("lf lf0"))
		t	= moptimize_result_evaluations((*pM))
		if (is_lf) {
			st_local("nt0",	0)
			st_local("nt_",	t[1])
		}
		else {
			st_local("nt0",	t[1])
			st_local("nt_",	0)
		}
		st_local("nt1",	t[2])
		st_local("nt2",	t[3])
		st_local("user", moptimize_name_evaluator((*pM)))
	}
}

void Mopt_set_count(string scalar set)
{
	pointer(transmorphic) scalar pM

	pM = Mopt_get_external()
	if (set == "on") {
		if (moptimize_init_evaluations((*pM)) == "on") {
			displayas("txt")
			printf("(count already on)")
			return
		}
		moptimize_init_evaluations((*pM), "on")
		return
	}
	if (set == "off") {
		if (moptimize_init_evaluations((*pM)) == "on") {
			moptimize_init_evaluations((*pM), "off")
			return
		}
		displayas("txt")
		printf("(count was on)")
		return
	}
	if (set == "") {
		displayas("txt")
		printf("count %s", moptimize_init_evaluations((*pM)))
		return
	}
	exit(error(198))
}

void Mopt_query()
{
	pointer(transmorphic) scalar pM

	pM = Mopt_get_external()
	moptimize_query((*pM))
}

void Mopt_report()
{
	pointer(transmorphic) scalar pM

	pM = Mopt_get_external()
	moptimize_report((*pM))
}

void Mopt_plot_gen()
{
	pointer(transmorphic) scalar pM
	string	scalar		eqnam, colnam, name
	string	matrix		colfulna
	real	scalar		x0, x1, n, N
	real	scalar		idx
	real	rowvector	p0, params
	real	scalar		v0
	real	scalar		i, j, k
	real	matrix		Vx, Vy
	real	vector		order	
	real	scalar		max
	pragma unset Vx
	pragma unset Vy

	pM = Mopt_get_external()

	max = moptimize_init_which((*pM)) == "max"
	p0  = moptimize_result_eq_coefs((*pM))
	if (length(p0) == 0) {
		p0  = moptimize_init_coefs((*pM))
	}
	v0  = moptimize_result_value((*pM))

	mopt__reset_valid((*pM))
	if (_moptimize_validate((*pM))) {
		exit(moptimize_result_returncode((*pM)))
	}

	st_view(Vx, ., st_varindex(st_local("x")))
	st_view(Vy, ., st_varindex(st_local("y")))

	// find the index of the parameter that 'parm' identifies
	colfulna = moptimize_result_colstripe((*pM))
	eqnam	= st_local("eqnam")
	if (eqnam == "") {
		eqnam = colfulna[1,1]
	}
	colnam	= st_local("colnam")
	k = rows(colfulna)
	idx = 0
	for (i=1; i<=k; i++) {
		if (eqnam == colfulna[i,1] & colnam == colfulna[i,2]) {
			idx = i
			break
		}
	}
	if (idx == 0) {
		Mopt_error(sprintf("parameter not found"), 199)
	}

	if (st_local("x0") == "") {
		x0 = p0[idx] - 1
		x1 = p0[idx] + 1
	}
	else if (st_local("x1") == "") {
		x0 = strtoreal(st_local("x0"))
		x1 = p0[idx] + abs(x0)
		x0 = p0[idx] - abs(x0)
	}
	else {
		x0 = strtoreal(st_local("x0"))
		x1 = strtoreal(st_local("x1"))
		if (x0 > x1) {
			swap(x0,x1)
		}
	}
	n = strtoreal(st_local("n"))
	N = strtoreal(st_local("N"))

	if (missing(v0)) {
		if (_moptimize_evaluate((*pM))) {
			exit(moptimize_result_returncode((*pM)))
		}
		v0 = moptimize_result_value((*pM))
	}

	if (x0 <= p0[idx] & p0[idx] <= x1) {
		st_local("xval", strofreal(p0[idx]))
		st_local("yval", strofreal(moptimize_result_value((*pM))))
	}
	st_local("ytitle", moptimize_init_valueid((*pM)))

	params = p0
	for (i=1; i<=N; i++) {
		params[idx] = x0 + (x1-x0)*(i-1)/n
		moptimize_reset_params((*pM), params)
		if (_mopt__evaluate((*pM))) {
			exit(moptimize_result_errorcode((*pM)))
		}
		Vx[i] = params[idx]
		Vy[i] = moptimize_result_value((*pM))
	}
	if (rows(Vy) > missing(Vy)) {
		order = order(Vy, 1)
		j = (max ? order[rows(Vy)-missing(Vy)] : order[1])
		displayas("txt")
		printf("\n")
		if (reldif(Vx[j],p0[idx]) > 1e-15 & !missing(Vy[j])
		 &  ((max ? Vy[j] > v0 : Vy[j] < v0) | missing(v0))) {
			name = sprintf("reset %s", st_local("parm"))
			printf(
			"{space %f}%s = {res:%10.0g}  (was {res:%10.0g})\n",
				max((0, 27-strlen(name))),
				name,
				Vx[j],
				p0[idx]
			)
			name = st_local("ytitle")
			printf(
			"{space %f}%s = {res:%10.0g}  (was {res:%10.0g})\n",
				max((0, 27-strlen(name))),
				name,
				Vy[j],
				v0
			)
			p0[idx] = Vx[j]
			moptimize_reset_params((*pM), p0)
                        moptimize_init_coefs((*pM), p0)
			(void) _mopt__evaluate((*pM))
			v0 = moptimize_result_value((*pM))
		}
		else {
			name = sprintf("keeping %s", st_local("parm"))
			printf("{space %f}%s = {res:%10.0g}\n",
				max((0, 27-strlen(name))),
				name,
				p0[idx]
			)
			name = st_local("ytitle")
			printf("{space %f}%s = {res:%10.0g}\n",
				max((0, 27-strlen(name))),
				name,
				v0
			)
			moptimize_reset_params((*pM), p0)
                        moptimize_init_coefs((*pM), p0)
			(void) _mopt__evaluate((*pM))
		}
	}
	st_global("ML_b", "ML_b")
        moptimize_reset_p0(*pM)
	st_matrix("ML_b", p0)
	st_matrixcolstripe("ML_b", moptimize_result_colstripe((*pM)))
	st_global("ML_f", "ML_f")
	st_numscalar("ML_f", v0)
}

void mopt_check_technique(`MoptStruct' M)
{
	real	vector	sel
	string	vector	tech

	sel = strmatch(M.S.cycle_names, "nr") :== 0
	if (any(sel)) {
		tech = select(M.S.cycle_names, sel) 
		if (strlen(tech)) {
errprintf("technique(%s) is not allowed with ml check\n", tech[1])
			exit(198)
		}
	}
}

void Mopt_check()
{
	pointer(transmorphic) scalar pM

	pM = Mopt_get_external()
	mopt_check_technique((*pM))
	moptimize_init_search_feasible((*pM), strtoreal(st_local("maxfeas")))
	if (_moptimize_check((*pM))) {
		exit(moptimize_result_returncode((*pM)))
	}
}

void Mopt_graph_gen()
{
	pointer(transmorphic) scalar pM
	real	matrix	y, x
	real	scalar	ic, n, i
	real	vector	ilog
	pragma unset x
	pragma unset y

	if (st_global("ML_M") != "") {
		pM = Mopt_get_external()
		st_local("crittype", moptimize_init_valueid((*pM)))
		ic = moptimize_result_iterations((*pM))
		ilog = moptimize_result_iterationlog((*pM))
	}
	else {
		if (st_global("e(opt)") != "moptimize") {
			exit(error(301))
		}
		st_local("crittype", st_global("e(crittype)"))
		ic = st_numscalar("e(ic)")
		ilog = st_matrix("e(ilog)")
	}
	n = (ic > 20 ? 20 : ic+1)
	st_view(y, ., st_local("y"))
	st_view(x, ., st_local("x"))
	for (i=1; i<=n; i++) {
		x[i] = ic-n+i
		y[i] = ilog[i]
	}
}

void Mopt_tracelevel(pointer(transmorphic) scalar pM)
{
	string scalar name

	name = ""
	if (st_local("dots") != "") {
		moptimize_init_trace_dots((*pM), "on")
		name = "on"
	}
	if (st_local("showtolerance") != "") {
		moptimize_init_trace_tol((*pM), "on")
		name = "on"
	}
	if (st_local("showstep") != "") {
		moptimize_init_trace_step((*pM), "on")
		name = "on"
	}
	if (st_local("coefdiffs") != "") {
		moptimize_init_trace_coefdiffs((*pM), "on")
		name = "on"
	}
	if (st_local("trace") != "") {
		moptimize_init_trace_coefs((*pM), "on")
		name = "on"
	}
	if (st_local("gradient") != "") {
		moptimize_init_trace_gradient((*pM), "on")
		name = "on"
	}
	if (st_local("hessian") != "") {
		moptimize_init_trace_Hessian((*pM), "on")
		name = "on"
	}
	if (name == "") {
		if (st_local("log") != "") {
			moptimize_init_tracelevel((*pM), "none")
		}
		else {
			moptimize_init_tracelevel((*pM), "value")
		}
	}
}

void Mopt_reset_params(`MoptStruct' M, real rowvector b,| real scalar nocheck)
{
	real scalar r, c

	pragma unused nocheck

	if (args() == 2) {
		r = rows(M.S.params)
		c = cols(M.S.params)
		if ( r != rows(b) | c != cols(b) ) {
			errprintf("new vector must be %g x %g\n",r,c)
			exit(198)
		}
	}
	if (M.adj_func) {
		b = (*M.adj_func)(b, M.adj_args)
	}
	M.S.params = b
}

void Mopt_list_params(`MoptStruct' M)
{
	M.S.params
}

void Mopt_prolog(`MoptStruct' M) {

	real scalar i
	string scalar sortby

//	for (i=1; i<=rows(M.macros); i++) {
//		st_global(M.macros[i,1],M.macros[i,2])
//	}

	for (i=1; i<=rows(M.vmacros); i++) {
		st_global(M.vmacros[i,1],M.vmacros[i,2])
	}

	for (i=1; i<=rows(M.mmacros); i++) {
		st_global(M.mmacros[i,1],M.mmacros[i,2])
	}

	for (i=1; i<=rows(M.smacros); i++) {
		st_global(M.smacros[i,1],M.smacros[i,2])
	}
	
	// check if dataset needs to be sorted
	stata(sprintf(`"local check : all globals "*_by""'))
	sortby = st_local("check")
	if (sortby!="") {
		sortby = st_global(sortby)
		stata(sprintf("qui sort %s",sortby))
	}
	
	// moved from moptimize_evaluate(), you call it once only
	(void) mopt__validate(M)
	M.S.ucall = 0
	if (opt__looputil_prolog_cycle(M.S)) {
		exit(optimize_result_returncode(M.S))
	}
}

real scalar Mopt_ll_fasteval(`MoptStruct' M)
{
	// calculate the ll
	Mopt_evaluate(M)
	return(moptimize_result_value(M))
}

void Mopt_update_offset_view(`MoptStruct' M, real scalar eq, string scalar offset)
{
	real scalar i, dim
	real matrix data	
	pragma unset data

	if (eq == 0 & offset != "") {
		if (eq < 1 || eq > length(M.st_eqoffset))
			return
		st_view(data, ., offset, M.st_touse)
		M.eqoffset[eq] = &data
	}
	else {
		dim = M.neq
		for (i=1; i<=dim; i++) {
			if (strlen(M.st_eqoffset[i])) {
				M.eqoffset[i] = &mopt__st_getdata(M,
					M.st_eqoffset_revar[i])
			}
		}
	}
}

real colvector Mopt_ll_vector(`MoptStruct' M)
{
	// calculate the ll
	Mopt_evaluate(M)
	if (M.S.evaltype == `OPT_evaltype_v') {
		if (M.wtype == 1 & M.weights != NULL) {
			if (length(M.S.value_v) != length(*M.weights)) {
				errprintf("failed to apply frequency weights\n")
				exit(503)
			}
			return(M.S.value_v :* (*M.weights))
		}
		else {
			return(M.S.value_v)
		}
	}
	else {
		return(moptimize_result_value(M))
	}
}

real scalar Mopt_ll_eval(`MoptStruct' M)
{
	real scalar i
	string scalar sortby

//	for (i=1; i<=rows(M.macros); i++) {
//		st_global(M.macros[i,1],M.macros[i,2])
//	}

	for (i=1; i<=rows(M.vmacros); i++) {
		st_global(M.vmacros[i,1],M.vmacros[i,2])
	}

	for (i=1; i<=rows(M.mmacros); i++) {
		st_global(M.mmacros[i,1],M.mmacros[i,2])
	}

	for (i=1; i<=rows(M.smacros); i++) {
		st_global(M.smacros[i,1],M.smacros[i,2])
	}
	
	// check if dataset needs to be sorted
	stata(sprintf(`"local check : all globals "*_by""'))
	sortby = st_local("check")
	if (sortby!="") {
		sortby = st_global(sortby)
		stata(sprintf("qui sort %s",sortby))
	}

	// calculate the ll
	Mopt_evaluate(M)

	return(moptimize_result_value(M))
}

void Mopt_moptobj_cleanup(`MoptStruct' M) {
	real scalar i, j
	string vector name, adonames, glnames
	pointer scalar p_ptr
	
	// remove variables created by mopt.ado
	adonames = "ML_sample" \ "ML_samp" \ "ML_grp" \ "ML_w" \ "ML_subv"
	for (i=1; i<=rows(adonames); i++) {
		stata(sprintf("capture drop %s",st_global(adonames[i])))
	}
	
	// remove any other extra temporary variables
	name = tokens(M.dropmetoo)'
	for (j=1; j<=rows(name); j++) {
		stata(sprintf("capture drop %s",name[j]))
	}

	// remove global macros and corresponding variables
	for (i=1; i<=rows(M.vmacros); i++) {
		name = tokens(M.vmacros[i,2])'
		for (j=1; j<=rows(name); j++) {
			stata(sprintf("capture drop %s",name[j]))
		}
		st_global(M.vmacros[i,1],"")
	}
	for (i=1; i<=rows(M.mmacros); i++) {
		name = tokens(M.mmacros[i,2])'
		for (j=1; j<=rows(name); j++) {
			stata(sprintf("capture matrix drop %s",name[j]))
		}
		st_global(M.mmacros[i,1],"")
	}	
	
	// remove gsem structure (passed in userinfo)
	if (M.nuinfo) {
		for (i=1; i<=M.nuinfo; i++) {
			name = nameexternal(M.uinfolist[i])
			if (name != "") {
				stata(sprintf("capture drop %s*",name))
				rmexternal(name)
			}
		}
	}
	
	// remove moptimize structure
	p_ptr = &M
	name = nameexternal(p_ptr)
	rmexternal(name)
	
	// remove all ML_* globals
	stata(sprintf(`"local check : all globals "ML_*""'))
	glnames = tokens(st_local("check"))'
	for (i=1; i<=rows(glnames); i++) {
		st_global(glnames[i],"")
	}
	st_local("check","")
}

end
exit

