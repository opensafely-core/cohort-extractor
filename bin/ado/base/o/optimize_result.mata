*! version 1.4.1  10oct2017
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'

mata:

real scalar optimize_result_converged(`OptStruct' S)
{
	return(S.converged)
}

`Errcode' optimize_result_errorcode(`OptStruct' S)
{
	return(S.errorcode)
}

string scalar optimize_result_errortext(`OptStruct' S)
{
	return(S.errortext)
}

`Errcode' optimize_result_returncode(`OptStruct' S)
{
	if (S.oerrorcode & !S.errorcode) {
		S.errorcode = S.oerrorcode
	}
	if (S.errorcode) {
		if (S.errorcode == `Errcode_notfeasible') {
			return(1400)
		}
		if (S.errorcode == `Errcode_badconstr') {
			return(412)
		}
		if (S.errorcode == `Errcode_bad_tech') {
			return(111)
		}
		if (S.errorcode == `Errcode_bad_tech_comb') {
			return(111)
		}
		if (S.errorcode == `Errcode_no_step') {
			return(111)
		}
		if (S.errorcode == `Errcode_weights') {
			return(459)
		}
		if (S.errorcode == `Errcode_search_feasible') {
			return(491)
		}
		if (S.errorcode == `Errcode_tol_negative') {
			return(198)
		}
		if (S.errorcode == `Errcode_invalid_p0') {
			return(503)
		}
		if (S.errorcode == `Errcode_no_calluser') {
			return(111)
		}
		if (S.errorcode == `Errcode_simplex_req') {
			return(111)
		}
		if (S.errorcode == `Errcode_simplex_bad_dim') {
			return(3499)
		}
		if (S.errorcode == `Errcode_simplex_small') {
			return(198)
		}
		if (S.errorcode == `Errcode_eval_debug') {
			return(198)
		}
		if (S.errorcode == `Errcode_no_eval') {
			return(111)
		}
		if (S.errorcode == `Errcode_no_loop') {
			return(111)
		}
		if (S.errorcode == `Errcode_bhhh_req') {
			return(198)
		}
		if (S.errorcode == `Errcode_no_user') {
			return(111)
		}
		if (S.errorcode == `Errcode_no_p0') {
			return(198)
		}
		if (S.errorcode == `Errcode_p0_missing') {
			return(198)
		}
		if (S.errorcode == `Errcode_invalid_evaltype') {
			return(198)
		}
		if (S.errorcode == `Errcode_no_views') {
			return(198)
		}
		if (S.errorcode == `Errcode_by_weights') {
			return(459)
		}
		if (S.errorcode == `Errcode_freeparm') {
			return(198)
		}
		return(430)
	}
	return(0)
}

real rowvector optimize_result_gradient(`OptStruct' S)
{
	if (S.minimize) {
		return(-S.gradient)
	}
	else	return(S.gradient)
}

real matrix optimize_result_Hessian(`OptStruct' S)
{
	`Errcode'	ec
	real scalar	notnm

	notnm = !any(strmatch(tokens(S.technique), "*nm*"))
	if (notnm & S.oerrorcode == 0) {
		if ((S.valid) & (S.hessian == `OPT_hessian_default')) {
			if (S.hasCns) {
				opt__cns_on(S, 2)
			}
			ec = opt__get_hessian(S)
			if (S.hasCns) {
				opt__cns_off(S, 2)
			}
			if (ec) return(J(S.dim,S.dim,.))
			S.hessian = S.H
		}
		if (S.minimize) {
			return(-S.hessian)
		}
		else	return(S.hessian)
	}
	return(J(S.dim,S.dim,.))
}

real colvector optimize_result_iterationlog(`OptStruct' S)
{
	real colvector log
	if (S.iter < 20) {
		log = S.log
	}
	else {
		real scalar i, j
		log = `OPT_log_default'
		j = mod(S.iter,20)
		for (i=1; i<=20; i++) {
			if (j == 20) {
				j = 1
			}
			else	j++
			log[i] = S.log[j]
		}
	}
	return(log)
}

real rowvector optimize_result_evaluations(`OptStruct' S)
{
	if (S.evaltype == `OPT_evaltype_lf') {
		return((S.cnt__evals, 0, 0))
	}
	else {
		return((S.cnt0_evals, S.cnt1_evals, S.cnt2_evals))
	}
}

real scalar optimize_result_iterations(`OptStruct' S)
{
	return(S.iter)
}

real rowvector optimize_result_params(`OptStruct' S)
{
	return(S.params)
}

real matrix optimize_result_scores(`OptStruct' S)
{
	if (S.evaltype < `OPT_evaltype_v' | S.evaltype > `OPT_evaltype_max') {
	 	return(J(0,0,.))
	}
	return(S.gradient_v)
}

real scalar optimize_result_value0(`OptStruct' S)
{
	if (S.minimize) {
		return(-S.v0)
	}
	else	return(S.v0)
}

real scalar optimize_result_value(`OptStruct' S)
{
	if (S.minimize) {
		return(-S.value)
	}
	else	return(S.value)
}

real matrix optimize_result_V(`OptStruct' S)
{
	if (S.technique == "bhhh") {
		return(optimize_result_V_opg(S))
	}
	return(optimize_result_V_oim(S))
}

string scalar optimize_result_Vtype(`OptStruct' S)
{
	if (S.technique == "bhhh") {
		return("opg")
	}
	return("oim")
}

void opt__q_vceparts(
	`OptStruct'	S,
	real matrix	XpX,
	real colvector	e,
	real scalar	nobs,
	real scalar	minus
)
{
	real matrix	Xpy

	nobs = rows(S.gradient_v)
	if (S.wtype == `OPT_wtype_none') {
		XpX = quadcross(S.gradient_v, S.gradient_v)
		Xpy = quadcross(S.gradient_v, S.value_v)
	}
	else {
		XpX = quadcross(S.gradient_v, S.weights, S.gradient_v)
		Xpy = quadcross(S.gradient_v, S.weights, S.value_v)
		if (S.wtype == `OPT_wtype_f' | S.wtype == `OPT_wtype_i') {
			nobs = colsum(S.weights)
		}
	}

	if (! S.hasCns) {
		minus = cols(S.gradient_v)
		XpX = invsym(XpX)
		e   = S.value_v - S.gradient_v*XpX*Xpy
	}
	else {
		minus = cols(S.T)
		Xpy = Xpy - XpX*S.a'
		XpX = S.T'*XpX*S.T
		XpX = S.T*invsym(XpX)*S.T'
		e   = S.value_v - S.gradient_v*(XpX*Xpy + S.a')
	}
}

/*STATIC*/ real matrix opt__result_V_q(`OptStruct' S)
{
	if (S.gn_A != `OPT_gn_A_default') {
 		return(J(S.dim,S.dim,0))
	}

	real matrix	V
	real colvector	e
	real scalar	nobs
	real scalar	f
	pragma unset V
	pragma unset e
	pragma unset f
	pragma unset nobs

	opt__q_vceparts(S, V, e, nobs, f)
	if (S.wtype == `OPT_wtype_none') {
		f = quadcross(e,e)/(nobs-f)
	}
	else {
		f = quadcross(e,S.weights,e)/(nobs-f)
	}
	V = f*V
	_makesymmetric(V)
	return(V)
}

/*STATIC*/ real matrix opt__result_V_q_opg(`OptStruct' S)
{
	if (S.gn_A != `OPT_gn_A_default') {
 		return(J(S.dim,S.dim,0))
	}

	real scalar	minus
	real colvector	e
	     scalar	R
	pragma unset e
	pragma unset minus

	opt__q_vceparts(S, ., e, ., minus)

	R = robust_init()
	if (rows(S.weights) > 1) {
		robust_init_weight(R, S.weights)
		robust_init_weighttype(R, opt__wtype_str(S))
	}
	robust_init_eq_indepvars(R, 1, S.gradient_v, 0)
	robust_init_scores(R, e)
	robust_init_minus(R, minus)
	return(robust(R))
}

/*STATIC*/ real matrix opt__result_V_q_robust(`OptStruct' S)
{
	if (S.gn_A != `OPT_gn_A_default') {
 		return(J(S.dim,S.dim,0))
	}

	real matrix	V
	real colvector	e
	real scalar	minus
	pragma unset V
	pragma unset e
	pragma unset minus

	opt__q_vceparts(S, V, e, ., minus)

	robust_init_scores(S.R, e)
	robust_init_covmat(S.R, V)
	robust_reset_eq_n(S.R, 1)
	robust_init_eq_indepvars(S.R, 1, S.gradient_v, 0)
	robust_init_minus(S.R, minus)
	return(robust(S.R))
}

real matrix optimize_result_V_oim(`OptStruct' S)
{
	if (S.fullRankCns) {
		return(J(S.dim,S.dim,0))
	}
	if (S.evaltype == `OPT_evaltype_q') {
		return(opt__result_V_q(S))
	}
	if (S.hasCns) {
		real matrix H
		H = S.T'*optimize_result_Hessian(S)*S.T
		if (S.minimize) {
			H = S.T*invsym(H)*S.T'
		}
		else {
			H = S.T*invsym(-H)*S.T'
		}
		return(H)
	}
	else {
		if (S.minimize) {
			return(invsym(optimize_result_Hessian(S)))
		}
		else	return(invsym(-optimize_result_Hessian(S)))
	}
}

real matrix optimize_result_V_opg(`OptStruct' S)
{
	if (S.fullRankCns) {
		return(J(S.dim,S.dim,0))
	}
	if (S.evaltype == `OPT_evaltype_d') {
	 	return(J(S.dim,S.dim,0))
	}

	if (S.evaltype == `OPT_evaltype_q') {
		return(opt__result_V_q_opg(S))
	}

	real matrix H
	H = opt__opg_v(S)
	if (S.hasCns) {
		if (rows(S.T) == rows(H)) {
			H = S.T'*H*S.T
		}
		_invsym(H)
		H = S.T*H*S.T'
		return(H)
	}
	return(invsym(H))
}

real matrix optimize_result_V_robust(`OptStruct' S)
{
	real	matrix	scores

	if (S.fullRankCns) {
		return(J(S.dim,S.dim,0))
	}
	if (S.evaltype == `OPT_evaltype_d') {
	 	return(J(S.dim,S.dim,.))
	}

	if (S.evaltype == `OPT_evaltype_q') {
		return(opt__result_V_q_robust(S))
	}

	robust_init_covmat(S.R, optimize_result_V_oim(S))
	robust_init_scores(S.R, S.gradient_v)
	if (S.evaltype == `OPT_evaltype_v') {
		if (S.hasCns) {
			if (cols(S.gradient_v) < cols(S.params)) {
				scores = S.gradient_v*S.T'
				robust_init_scores(S.R, scores)
			}
		}
	}
	robust_reset_eq_n(S.R, S.dim)
	return(robust(S.R))
}

real rowvector optimize_result_deriv_h(`OptStruct' S)
{
	if (any(S.evaltype_f :== tokens("lf lf0"))) {
		return(deriv_result_h(S.D))
	}
	return(J(1,S.dim,.))
}

real rowvector optimize_result_deriv_scale(`OptStruct' S)
{
	if (any(strmatch(S.evaltype_f,	("d0",
					 "d1debug",
					 "d2debug",
					 "v0",
					 "v1debug",
					 "v2debug",
					 "q0",
					 "q1debug",
					 "lf",
					 "lf0",
					 "lf1debug",
					 "lf2debug",
					 "e1debug",
					 "e2debug")))) {
		return(deriv_result_scale(S.D))
	}
	return(J(1,S.dim,.))
}

real matrix optimize_result_V_svy(`OptStruct' S)
{
	return(optimize_result_V_robust(S))
}

real matrix optimize_result_V_srs(`OptStruct' S)
{
	return(robust_result_V_srs(S.R))
}

real matrix optimize_result_V_srssub(`OptStruct' S)
{
	return(robust_result_V_srssub(S.R))
}

real matrix optimize_result_V_srswr(`OptStruct' S)
{
	return(robust_result_V_srswr(S.R))
}

real matrix optimize_result_V_srswrsub(`OptStruct' S)
{
	return(robust_result_V_srswrsub(S.R))
}

real scalar optimize_result_svy_census(`OptStruct' S)
{
	return(robust_result_census(S.R))
}

real scalar optimize_result_svy_N_clust(`OptStruct' S)
{
	return(robust_result_N_clust(S.R))
}

real scalar optimize_result_svy_N_strata(`OptStruct' S)
{
	return(robust_result_N_strata(S.R))
}

real scalar optimize_result_svy_N_omit(`OptStruct' S)
{
	return(robust_result_N_strata_omit(S.R))
}

real scalar optimize_result_svy_N(`OptStruct' S)
{
	return(robust_result_N(S.R))
}

real scalar optimize_result_svy_N_sub(`OptStruct' S)
{
	return(robust_result_N_sub(S.R))
}

real scalar optimize_result_svy_singleton(`OptStruct' S)
{
	return(robust_result_singleton(S.R))
}

real scalar optimize_result_svy_sum_w(`OptStruct' S)
{
	return(robust_result_sum_w(S.R))
}

real scalar optimize_result_svy_sum_wsub(`OptStruct' S)
{
	return(robust_result_sum_wsub(S.R))
}

real rowvector optimize_result_svy_postsize(`OptStruct' S)
{
	return(robust_result_postsize(S.R))
}

real rowvector optimize_result_svy_postsum(`OptStruct' S)
{
	return(robust_result_postsum(S.R))
}

real rowvector optimize_result_svy_certain(`OptStruct' S)
{
	return(robust_result_stage_certain(S.R))
}

real rowvector optimize_result_svy_single(`OptStruct' S)
{
	return(robust_result_stage_single(S.R))
}

real rowvector optimize_result_svy_strata(`OptStruct' S)
{
	return(robust_result_stage_strata(S.R))
}

end
