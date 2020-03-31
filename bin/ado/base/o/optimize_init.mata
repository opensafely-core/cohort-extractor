*! version 1.5.0  11apr2018
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'

mata:

transmorphic scalar optimize_init()
{
	`OptStruct' S

	// items for the optimizer settings
	S.opt_version	= `OPT_version_default'

	S.p0		= `OPT_p0_default'
	S.simplex_delta	= `OPT_simplex_delta_default'

	S.minimize	= `OPT_which_default'

	S.user		= `OPT_user_default'
	S.userprolog	= `OPT_userprolog_default'
	S.userprolog2	= `OPT_userprolog2_default'
	opt__init_evaltype(S, `OPT_evaltype_default')

	S.technique	= `OPT_technique_default'
	S.loop		= `OPT_loop_default'

	S.singularH	= `OPT_singularH_default'
	S.singularH_stepper	= `OPT_singularH_stepper_default'

	S.step_forward	= `OPT_step_forward_default'

	S.maxiter	= `OPT_maxiter_default'

	S.ptol		= `OPT_ptol_default'
	S.vtol		= `OPT_vtol_default'
	S.gtol		= `OPT_gtol_default'
	S.nrtol		= `OPT_nrtol_default'
	if (c("version") < 12) {
		S.qtol = S.nrtol
	}
	else {
		S.qtol = .
	}
	S.ignorenrtol	= `OPT_ignorenrtol_default'
	S.notconcave	= `OPT_notconcave_default'
	S.k_notconcave	= 0

	S.utrace	= `OPT_tracelvl_default'
	opt__reset_trace(S)
	if (c("iterlog")=="off") {
		//S.utrace	= `OPT_tracelvl_none'
		optimize_init_trace_value(S, "off")
	}
	S.ndots		= 0

	S.value_id	= `OPT_value_id_default'
	S.iter_id	= `OPT_iter_id_default'

	// items for user defined arguments
	S.nargs		= `OPT_nargs_default'
	S.arglist	= `OPT_arglist_default'

	S.negH		= `OPT_negH_default'
	S.warn		= `OPT_conv_warn_default'

	S.wtype		= `OPT_wtype_default'
	S.weights	= `OPT_weights_default'

	S.cycle_names	= `OPT_cycle_names_default'
	S.cycle_counts	= `OPT_cycle_counts_default'
	S.cycle_eval	= `OPT_eval_default'
	S.cycle_iter	= `OPT_cycle_iter_default'
	S.cycle_idx	= `OPT_cycle_iter_default'

	S.stripes	= J(1,3,NULL)
	S.stripes[1]	= &`OPT_stripes_default'
	S.stripes[2]	= &`OPT_stripes_default'
	S.stripes[3]	= &`OPT_stripes_default'
	S.ndami		= `OPT_conv_ndami_default'

	// items for the optimizer status
	opt__init(S)

	return(S)
}

function optimize_init_argument(`OptStruct' S, real scalar i, |arg)
{
	if (i<1 | i>`OPT_nargs_max' | i!=trunc(i)) {
		errprintf("invalid argument index\n")
		exit(3498)
	}
	if (args() == 2) {
		if (S.arglist[i] == NULL) {
			return(NULL)
		}
		return(S.arglist[i])
	}
	if (ispointer(arg) & arg == NULL) {
		S.arglist[i] = NULL
		return
	}
	S.arglist[i] = &arg
	if (S.nargs<i) optimize_init_narguments(S, i)
}

function optimize_init_negH(`OptStruct' S, |real scalar negH)
{
	if (args() == 1) {
		return(S.negH)
	}
	else {
		S.negH = negH
	}
}

function optimize_init_constraints(`OptStruct' S, |real matrix constraints)
{
	if (args() == 1) {
		if (S.constraints == `OPT_constraints_default') {
			if (S.p0 != `OPT_p0_default') {
				return(J(0,cols(S.p0)+1,.))
			}
		}
		return(S.constraints)
	}
	else {
		if (rows(constraints) == 0 | cols(constraints) == 0) {
			S.constraints = `OPT_constraints_default'
		}
		else {
			S.constraints = constraints
		}
	}
	S.valid	= `OPT_onoff_off'
}

function optimize_init_conv_maxiter(`OptStruct' S, |real scalar maxiter)
{
	if (args()==1) {
		return(S.maxiter)
	}
	else {
		if (missing(maxiter)) {
			S.maxiter = `OPT_maxiter_default'
		}
		else	opt__set_int(S.maxiter, maxiter, 0, .)
	}
}

function optimize_init_conv_ndami(`OptStruct' S, |scalar ndami)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(S.ndami))
	}
	S.ndami = opt__onoff(ndami, "ndami")
}

function optimize_init_conv_gtol(`OptStruct' S, |real scalar tol)
{
	if (args()==1) {
		return(S.gtol)
	}
	else {
		if (missing(tol)) {
			S.gtol = `OPT_gtol_default'
		}
		else {
			S.gtol = tol
		}
	}
}

function optimize_init_conv_nrtol(`OptStruct' S, |real scalar tol)
{
	if (args()==1) {
		return(S.nrtol)
	}
	else {
		if (missing(tol)) {
			S.nrtol = `OPT_nrtol_default'
		}
		else {
			S.nrtol = tol
		}
		if (c("version") < 12) {
			S.qtol = S.nrtol
		}
	}
}

function optimize_init_conv_qtol(`OptStruct' S, |real scalar tol)
{
	if (args()==1) {
		return(S.qtol)
	}
	else {
		if (missing(tol)) {
			if (c("version") < 12) {
				S.qtol = `OPT_nrtol_default'
			}
			else {
				S.qtol = .
			}
		}
		else {
			S.qtol = tol
		}
	}
}

function optimize_init_conv_ignorenrtol(`OptStruct' S, |scalar onoff)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(missing(S.nrtol)))
	}
	S.ignorenrtol = opt__onoff(onoff, "ignore nrtol")
}

function optimize_init_conv_ptol(`OptStruct' S, |real scalar tol)
{
	if (args()==1) {
		return(S.ptol)
	}
	else {
		if (missing(tol)) {
			S.ptol = `OPT_ptol_default'
		}
		else {
			S.ptol = tol
		}
	}
}

function optimize_init_conv_vtol(`OptStruct' S, |real scalar tol)
{
	if (args()==1) {
		return(S.vtol)
	}
	else {
		if (missing(tol)) {
			S.vtol = `OPT_vtol_default'
		}
		else {
			S.vtol = tol
		}
	}
}

function optimize_init_conv_notconcave(
	`OptStruct'	S,
	|real	scalar	notconcave)
{
	if (args()==1) {
		return(S.notconcave)
	}
	if (missing(notconcave)) {
		S.notconcave = `OPT_notconcave_default'
	}
	else	opt__set_int(S.notconcave, notconcave, 2, .)
}

function optimize_init_conv_warning(`OptStruct' S, |scalar warn)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(S.warn))
	}
	S.warn = opt__onoff(warn, "convergence warning")
}

function optimize_init_evaluations(`OptStruct' S, |scalar evalcount)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(S.evalcount))
	}
	S.evalcount = opt__onoff(evalcount, "evaluations")
}

function optimize_init_evaluator(`OptStruct' S, |pointer(function) scalar f)
{
	if (args() == 1) {
		return(S.user)
	}
	if (f == NULL | !ispointer(f)) {
		errprintf("invalid function pointer\n")
		exit(3498)
	}
	S.user = f
	S.valid	= `OPT_onoff_off'
}

function optimize_init_evaluatortype(`OptStruct' S, |scalar type)
{
	if (args() == 1) {
		return(S.evaltype_user)
	}
	else if (isstring(type)) {
		opt__init_evaltype(S,type)
	}
	else {
		errprintf("invalid evaluator type\n")
		exit(3498)
	}
	S.valid	= `OPT_onoff_off'
}

function optimize_init_deriv_h(`OptStruct' S,| real rowvector h)
{
	if (args() == 1) {
		return(deriv_init_h(S.D))
	}
	deriv_init_h(S.D, h)
}

function optimize_init_deriv_scale(`OptStruct' S,| real rowvector scale)
{
	if (args() == 1) {
		return(deriv_init_scale(S.D))
	}
	deriv_init_scale(S.D, scale)
	S.userscale = 1
}

function optimize_init_iterprolog(`OptStruct' S, |pointer(function) scalar f)
{
	if (args() == 1) {
		return(S.userprolog)
	}
	if (!ispointer(f)) {
		errprintf("invalid function pointer\n")
		exit(3498)
	}
	S.userprolog = f
	S.valid	= `OPT_onoff_off'
}

function optimize_init_derivprolog(`OptStruct' S, |pointer(function) scalar f)
{
	if (args() == 1) {
		return(S.userprolog2)
	}
	if (!ispointer(f)) {
		errprintf("invalid function pointer\n")
		exit(3498)
	}
	S.userprolog2 = f
	S.valid	= `OPT_onoff_off'
}

function optimize_init_narguments(`OptStruct' S, |real scalar n)
{
	if (args()==1) {
		return(S.nargs)
	}
	opt__set_int(S.nargs, n, `OPT_nargs_default', `OPT_nargs_max')
}

function optimize_init_params(`OptStruct' S,| real rowvector params)
{
	if (args() == 1) {
		return(S.p0)
	}
	S.p0 = params
	S.v0 = `OPT_v0_default'
}

function optimize_init_colstripe(`OptStruct' S, |string matrix stripe)
{
	if (args() == 1) {
		return(*S.stripes[1])
	}
	else {
		string	matrix	copy
		copy	= stripe
		S.stripes[1] = &copy
	}
	S.valid	= `OPT_onoff_off'
}

function optimize_reset_p0(`OptStruct' S)
{
	if (S.params != `OPT_params_default') {
		S.p0 = S.params
		S.v0 = S.value
	}
}

function optimize_reset_params(`OptStruct' S, real rowvector params)
{
	S.params = params
	S.value  = `OPT_v0_default'
}

function optimize_init_gnweightmatrix(`OptStruct' S,| real matrix A)
{
	if (args()==1) {
		return(S.gn_A)
	}
	if (missing(A)) {
		errprintf("missing values not allowed in weight matrix\n")
		exit(3498)
	}
	S.gn_A = &A
	S.valid	= `OPT_onoff_off'
}

function optimize_init_nmsimplexdeltas(`OptStruct' S,| real rowvector delta)
{
	if (args()==1) {
		return(S.simplex_delta)
	}
	else {
		if (missing(delta)) {
			errprintf("missing values not allowed in delta\n")
			exit(3498)
		}
		S.simplex_delta = delta
	}
	S.valid	= `OPT_onoff_off'
}

function optimize_init_singularHmethod(`OptStruct' S, |string scalar method)
{
	if (args() == 1) {
		if (S.singularH == "") {
			return(`OPT_singularH_default')
		}
		return(S.singularH)
	}
	else {
		S.singularH	= method
	}
	S.valid	= `OPT_onoff_off'
}

function optimize_init_step_forward(`OptStruct' S, |scalar onoff)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(S.step_forward))
	}
	S.step_forward = opt__onoff(onoff, "step forward")
	S.valid	= `OPT_onoff_off'
}

function optimize_init_technique(`OptStruct' S, |scalar technique)
{
	if (args() == 1) {
		return(S.technique)
	}
	else {
		S.ucall = 0
		(void) opt__init_cycle(S, tokens(technique))
		S.technique	= technique
	}
	S.valid	= `OPT_onoff_off'
}

function optimize_init_deriv_search(`OptStruct' S, |scalar search)
{
	if (args() == 1) {
		return(deriv_init_search(S.D))
	}
	deriv_init_search(S.D, search)
}

function optimize_init_tracelevel(`OptStruct' S, |scalar tracelevel)
{
	if (args() == 1) {
		return(opt__tracelevel_str(S))
	}
	else if (isreal(tracelevel)) {
		opt__tracelevel_num(S,tracelevel)
	}
	else if (isstring(tracelevel)) {
		opt__tracelevel_str(S,tracelevel)
	}
	else {
		errprintf("invalid trace level\n")
		exit(3498)
	}
}

function optimize_init_trace_value(`OptStruct' S, |scalar value)
{
	if (args() == 1) {
		return(opt__trace_value_str(S))
	}
	if (isreal(value)) {
		opt__trace_value_num(S, value)
	}
	else if (isstring(value)) {
		opt__trace_value_str(S, value)
	}
	else {
		errprintf("invalid argument\n")
		exit(3498)
	}
}

function optimize_init_trace_tol(`OptStruct' S, |scalar tol)
{
	if (args() == 1) {
		return(opt__trace_tol_str(S))
	}
	if (isreal(tol)) {
		opt__trace_tol_num(S, tol)
	}
	else if (isstring(tol)) {
		opt__trace_tol_str(S, tol)
	}
	else {
		errprintf("invalid argument\n")
		exit(3498)
	}
}

function optimize_init_trace_step(`OptStruct' S, |scalar step)
{
	if (args() == 1) {
		return(opt__trace_step_str(S))
	}
	if (isreal(step)) {
		opt__trace_step_num(S, step)
	}
	else if (isstring(step)) {
		opt__trace_step_str(S, step)
	}
	else {
		errprintf("invalid argument\n")
		exit(3498)
	}
}

function optimize_init_trace_paramdiffs(`OptStruct' S, |scalar params)
{
	if (args() == 1) {
		return(opt__trace_pdiffs_str(S))
	}
	if (isreal(params)) {
		opt__trace_pdiffs_num(S, params)
	}
	else if (isstring(params)) {
		opt__trace_pdiffs_str(S, params)
	}
	else {
		errprintf("invalid argument\n")
		exit(3498)
	}
}

function optimize_init_trace_params(`OptStruct' S, |scalar params)
{
	if (args() == 1) {
		return(opt__trace_params_str(S))
	}
	if (isreal(params)) {
		opt__trace_params_num(S, params)
	}
	else if (isstring(params)) {
		opt__trace_params_str(S, params)
	}
	else {
		errprintf("invalid argument\n")
		exit(3498)
	}
}

function optimize_init_trace_gradient(`OptStruct' S, |scalar gradient)
{
	if (args() == 1) {
		return(opt__trace_gradient_str(S))
	}
	if (isreal(gradient)) {
		opt__trace_gradient_num(S, gradient)
	}
	else if (isstring(gradient)) {
		opt__trace_gradient_str(S, gradient)
	}
	else {
		errprintf("invalid argument\n")
		exit(3498)
	}
}

function optimize_init_trace_Hessian(`OptStruct' S, |scalar hessian)
{
	if (args() == 1) {
		return(opt__trace_hessian_str(S))
	}
	if (isreal(hessian)) {
		opt__trace_hessian_num(S, hessian)
	}
	else if (isstring(hessian)) {
		opt__trace_hessian_str(S, hessian)
	}
	else {
		errprintf("invalid argument\n")
		exit(3498)
	}
}

function optimize_init_trace_dots(`OptStruct' S, |scalar dots)
{
	if (args() == 1) {
		return(opt__trace_dots_str(S))
	}
	else if (isreal(dots)) {
		opt__trace_dots_num(S,dots)
	}
	else if (isstring(dots)) {
		opt__trace_dots_str(S,dots)
	}
	else {
		errprintf("invalid argument\n")
		exit(3498)
	}
}

function optimize_init_valueid(`OptStruct' S, |string scalar value_id)
{
	if (args() == 1) {
		return(S.value_id)
	}
	else {
		if (strlen(strtrim(value_id))) {
			S.value_id = value_id
		}
		else {
			S.value_id = `OPT_value_id_default'
		}
	}
}

function optimize_init_iterid(`OptStruct' S, |string scalar iter_id)
{
	if (args() == 1) {
		return(S.iter_id)
	}
	else {
		if (strlen(strtrim(iter_id))) {
			S.iter_id = iter_id
		}
		else {
			S.iter_id = `OPT_iter_id_default'
		}
	}
}

function optimize_init_verbose(`OptStruct' S,| scalar verbose)
{
	if (args() == 1) {
		return(S.verbose)
	}
	if (isstring(verbose)) {
		opt__verbose_str(S, verbose)
	}
	else if (isreal(verbose)) {
		opt__verbose_num(S, verbose)
	}
	else {
		errprintf("invalid verbose setting")
		exit(198)
	}
}

function optimize_init_weight(
	`OptStruct'		S,
	|real	colvector	weights,
		scalar		wtype
)
{
	if (args() == 1) {
		return(opt__weight(S))
	}
	if (args() == 2) {
		opt__weight(S, weights)
	}
	else	opt__weight(S, weights, wtype)
}

function optimize_init_weighttype(
	`OptStruct'	S,
	|scalar		wtype
)
{
	if (args() == 1) {
		return(opt__wtype(S))
	}
	opt__wtype(S, wtype)
}

function optimize_init_which(`OptStruct' S, |scalar which)
{
	if (args() == 1) {
		return(opt__which_str(S))
	}
	else if (isreal(which)) {
		opt__which_num(S, which)
	}
	else if (isstring(which)) {
		opt__which_str(S, which)
	}
	else {
		errprintf("invalid argument\n")
		exit(3498)
	}
}

function optimize_init_svy(`OptStruct' S, |scalar svy)
{
	if (args() == 1) {
		return(robust_init_svyset(S.R))
	}
	robust_init_svyset(S.R, svy)
}

function optimize_init_svy_nstages(`OptStruct' S,|real scalar K)
{
	if (args() == 1) {
		return(robust_init_nstages(S.R))
	}
	robust_init_nstages(S.R, K)
}

function optimize_init_svy_stage_units(`OptStruct' S, real scalar k, |units)
{
	if (args() == 2) {
		return(robust_init_stage_units(S.R, k))
	}
	robust_init_stage_units(S.R, k, units)
}

function optimize_init_svy_stage_strata(`OptStruct' S, real scalar k, |strata)
{
	if (args() == 2) {
		return(robust_init_stage_strata(S.R, k))
	}
	robust_init_stage_strata(S.R, k, strata)
}

function optimize_init_svy_stage_fpc(`OptStruct' S, real scalar k, |fpc)
{
	if (args() == 2) {
		return(robust_init_stage_fpc(S.R, k))
	}
	robust_init_stage_fpc(S.R, k, fpc)
}

function optimize_init_svy_weights(`OptStruct' S, |weights, scalar wtype)
{
	if (args() == 1) {
		return(robust_init_weight(S.R))
	}
	if (args() == 2) {
		robust_init_weight(S.R, weights)
	}
	else {
		robust_init_weight(S.R, weights, wtype)
	}
}

function optimize_init_svy_poststrata(`OptStruct' S, |P)
{
	if (args() == 1) {
		return(robust_init_poststrata(S.R))
	}
	robust_init_poststrata(S.R, P)
}

function optimize_init_svy_touse(`OptStruct' S, |touse)
{
	if (args() == 1) {
		return(robust_init_touse(S.R))
	}
	robust_init_touse(S.R, touse)
}

function optimize_init_svy_subpop(`OptStruct' S, |subpop)
{
	if (args() == 1) {
		return(robust_init_subpop(S.R))
	}
	robust_init_subpop(S.R, subpop)
}

function optimize_init_cluster(`OptStruct' S, |cluster)
{
	if (args() == 1) {
		return(optimize_init_svy_stage_units(S, 1))
	}
	optimize_init_svy_stage_units(S, 1, cluster)
}

function optimize_init_svy_singleunit(
	`OptStruct'	S,
	|string	scalar	singleunit
)
{
	if (args() == 1) {
		return(robust_init_singleunit(S.R))
	}
	robust_init_singleunit(S.R, singleunit)
}

function optimize_init_svy_V_srs( `OptStruct' S, |srs)
{
	if (args() == 1) {
		return(robust_init_V_srs(S.R))
	}
	robust_init_V_srs(S.R, srs)
}

void opt__robust_skip_setup(`OptStruct' S, |scalar onoff)
{
	if (args() == 1) {
		return(robust_init_skip_setup(S.R))
	}
	robust_init_skip_setup(S.R, onoff)
}

void opt__unlink_args(`OptStruct' S)
{
	S.arglist	= `OPT_arglist_default'
	S.nargs		= `OPT_nargs_default'
	if (S.use_deriv) {
		opt__unlink(S)
	}
}

function opt__init_doopt(`OptStruct' S, |onoff)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(S.doopt))
	}
	S.doopt = opt__onoff(onoff, "doopt")
}

function optimize_init_nm_sortstable(`OptStruct' S, | onoff)
{
	if (args() == 1) {
		return(opt__onoff_numtostr(S.nm_sortstable))
	}
	S.nm_sortstable = opt__onoff(onoff, "nm_sortstable")
}

end
