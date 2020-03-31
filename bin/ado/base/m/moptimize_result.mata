*! version 1.3.3  13jul2018
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'
findfile moptimize_include.mata
quietly include `"`r(fn)'"'

local VTYPE v0 v1 v1debug v2 v2debug

mata:

void moptimize_result_post(`MoptStruct' M, |scalar vcetype)
{
	`Errcode'	rc
	string	scalar	st_b, st_V, st_C, wgt, name
	real	scalar	rank, i, dim, is_svy, is_lf, vce
	real	matrix	t

	if (args() == 1) {
		vce	= (M.uvcetype != `MOPT_vcetype_none'
				? M.uvcetype : M.vce)
	}
	else if (isstring(vcetype)) {
		vce	= mopt__vcetype_str(M, vcetype)
	}
	else if (isreal(vcetype)) {
		vce	= mopt__vcetype_num(M, vcetype)
	}
	else {
		errprintf("invalid vcetype argument\n")
		exit(3498)
	}
	is_svy	= (vce == `MOPT_vcetype_svy')
	is_lf	= any(strmatch(M.S.evaltype_f, ("lf", "lf0")))

	st_b	= st_tempname()
	st_matrix(st_b,			moptimize_result_eq_coefs(M))
	st_matrixcolstripe(st_b,	moptimize_result_colstripe(M))

	if (moptimize_init_technique(M) != "nm" | M.S.hasCns) {
		t	= mopt__result_V(M, ., vce)
		_editmissing(t, 0)
		rank	= cols(t) - diag0cnt(invsym(t))
		st_V	= st_tempname()
		st_matrix(st_V,			t)
		st_matrixcolstripe(st_V,	moptimize_result_colstripe(M))
		st_matrixrowstripe(st_V,	moptimize_result_colstripe(M))
	}
	else {
 		rank	= 0
	}

	if (M.S.hasCns) {
		st_C	= st_tempname()
		st_matrix(st_C,	moptimize_init_constraints(M))
	}
	else	st_C	= ""

	if (M.wtype != `OPT_wtype_none') {
		name = moptimize_name_weight(M)
		if (strlen(name)) {
			st_global("e(wexp)", "= " + name)
			wgt = moptimize_init_weighttype(M) + "= " + name
		}
	}
	rc = _stata(
		sprintf(`"mopt_post "%s" "%s" "%s" "[%s]" "%s" "%s""',
			st_b, st_V, st_C, wgt, M.st_touse,
			(M.ndepvars == 1 ? moptimize_name_depvar(M, 1) : "")
		))
	if (rc) {
		exit(rc)
	}

	// Scalars
	if (! is_svy) {
		st_numscalar("e(rank)", rank)
	}
	st_numscalar("e(N)",	moptimize_result_obs(M))
	st_numscalar("e(ic)",	moptimize_result_iterations(M)-1)
	st_numscalar("e(k)",	cols(moptimize_result_eq_coefs(M, .)))
	st_numscalar("e(k_eq)",	moptimize_init_eq_n(M))
	if (M.kaux) {
		st_numscalar("e(k_aux)", M.kaux)
	}
	st_numscalar("e(noconstant)",
		moptimize_init_eq_cons(M,1)=="off","hidden")
	st_numscalar("e(consonly)", 
		cols(moptimize_init_eq_indepvars(M,1))==0, "hidden")
	st_numscalar("e(k_dv)",	dim = moptimize_init_ndepvars(M))
	if (dim) {
		st_global("e(depvar)",
			invtokens(moptimize_name_depvars(M)))
	}
	if (M.S.fullRankCns) {
		st_numscalar("e(converged)",	1)
		st_numscalar("e(rc)",		0)
	}
	else if (moptimize_init_conv_maxiter(M)	|
	    moptimize_init_conv_warning(M) == "on") {
		i = moptimize_result_converged(M)
		st_numscalar("e(converged)",	i)
		if (i | M.norc == `OPT_onoff_on') {
			st_numscalar("e(rc)",	0)
		}
		else {
			// force a not converged error on replay
			st_numscalar("e(rc)",	430)
		}
	}
	else {
		st_numscalar("e(converged)",	1)
		st_numscalar("e(rc)",		0)
	}
	if (moptimize_init_evaluations(M) == "on") {
		t = moptimize_result_evaluations(M)
		if (is_lf) {
			st_numscalar("e(cnt0)",	0)
			st_numscalar("e(cnt_)",	t[1])
		}
		else {
			st_numscalar("e(cnt0)",	t[1])
			st_numscalar("e(cnt_)",	0)
		}
		st_numscalar("e(cnt1)",	t[2])
		st_numscalar("e(cnt2)",	t[3])
	}

	// Macros
	st_global("e(which)",		moptimize_init_which(M))
	st_global("e(technique)",	moptimize_init_technique(M))
	st_global("e(singularHmethod)",	moptimize_init_singularHmethod(M),
					"hidden")
	st_global("e(ml_method)",	moptimize_init_evaluatortype(M))
	st_global("e(crittype)",	moptimize_init_valueid(M),
					"hidden")
	st_numscalar("e(k_autoCns)",	mopt__init_k_autoCns(M), "hidden")
	dim = moptimize_init_eq_n(M)
	for (i=1; i<=dim; i++) {
		if (M.eqoffset[i] != NULL) {
			if (M.eqexposure[i]) {
				name = moptimize_name_eq_exposure(M,i)
				if (strlen(name)) {
					name = sprintf("ln(%s)", name)
				}
			}
			else {
				name = moptimize_name_eq_offset(M,i)
			}
			st_global(sprintf("e(offset%f)",i), name)
		}
	}
	st_global("e(user)",	moptimize_name_evaluator(M))
	dim = length(M.diparm)
	for (i=1; i<=dim; i++) {
		st_global(sprintf("e(diparm%f)",i), M.diparm[i], "hidden")
	}
	if (strlen(M.title)) {
		st_global("e(title)", M.title)
	}

	// VCE results
	if (is_svy) {
		st_global("e(prefix)",	"svy")
		st_global("e(vce)",	"linearized")
		st_global("e(vcetype)",	"Linearized")
		robust_result_post2e(M.S.R)
		t = moptimize_result_svy_postsize(M)
		if (! cols(t)) {
			st_matrix("e(V_srs)",
				moptimize_result_V_svy_srs(M))
			st_matrixcolstripe("e(V_srs)",
				moptimize_result_colstripe(M))
			st_matrixrowstripe("e(V_srs)",
				moptimize_result_colstripe(M))
			st_matrix("e(V_srswr)",
				moptimize_result_V_svy_srswr(M))
			st_matrixcolstripe("e(V_srswr)",
				moptimize_result_colstripe(M))
			st_matrixrowstripe("e(V_srswr)",
				moptimize_result_colstripe(M))
			st_matrix("e(V_srssub)",
				moptimize_result_V_svy_srssub(M))
			st_matrixcolstripe("e(V_srssub)",
				moptimize_result_colstripe(M))
			st_matrixrowstripe("e(V_srssub)",
				moptimize_result_colstripe(M))
			st_matrix("e(V_srssubwr)",
				moptimize_result_V_svy_srswrsub(M))
			st_matrixcolstripe("e(V_srssubwr)",
				moptimize_result_colstripe(M))
			st_matrixrowstripe("e(V_srssubwr)",
				moptimize_result_colstripe(M))
		}
	}
	else {
		st_global("e(vce)",	mopt__vcetype_numtostr(vce))
		if (vce == `MOPT_vcetype_cluster') {
			st_global("e(clustvar)",
				moptimize_name_svy_stage_units(M, 1))
			st_global("e(vcetype)",	"Robust")
			st_numscalar("e(N_clust)",
				moptimize_result_svy_N_clust(M))
		}
		if (vce == `MOPT_vcetype_robust') {
			st_global("e(vcetype)",	"Robust")
		}
		if (vce == `MOPT_vcetype_opg') {
			st_global("e(vcetype)",	"OPG")
		}
	}
	if (`MOPT_vcetype_robust' <= vce & vce <= `MOPT_vcetype_svy') {
		st_matrix("e(V_modelbased)",
			moptimize_result_V_oim(M))
		st_matrixcolstripe("e(V_modelbased)", 
			moptimize_result_colstripe(M))
		st_matrixrowstripe("e(V_modelbased)", 
			moptimize_result_colstripe(M))
 	}
 
	// Matrices
	t	= moptimize_result_deriv_scale(M)
	if (! missing(t)) {
		st_matrix("e(ml_scale)",  t, "hidden")
	}
	if (is_lf) {
		st_matrix("e(ml_h)", moptimize_result_deriv_h(M), "hidden")
	}
	st_matrix("e(gradient)",moptimize_result_gradient(M))
	st_matrixcolstripe("e(gradient)", moptimize_result_colstripe(M))
	st_matrix("e(ilog)",	moptimize_result_iterationlog(M)')

	// Macros
	st_global("e(predict)",	"ml_p")
	st_global("e(opt)",	"moptimize")
	st_global("e(cmd)",	"mopt")
}

void moptimize_result_display(|transmorphic M, string scalar vcetype)
{
	`Errcode'	ec
	real	scalar	bkey
	string	scalar	hold

	if (args()) {
		bkey	= setbreakintr(0)
		hold	= st_tempname()
		ec = _stata(sprintf("_estimates hold %s, nullok", hold))
		if (! ec) {
			if (args() == 1) {
				moptimize_result_post(M)
			}
			else {
				moptimize_result_post(M, vcetype)
			}
			mopt__display(1)
			stata(sprintf("capture _estimates unhold %s", hold))
		}
		(void) setbreakintr(bkey)
		if (ec) exit(ec)
	}
	else {
		mopt__display(0)
	}
}

/*STATIC*/ void mopt__display(real scalar ismopt)
{
	`Errcode' ec
	if (ismopt) {
		ec = _stata("mopt display")
		if (ec) exit(ec)
	}
	else {
		ec = _stata("estimates replay")
		if (ec) exit(ec)
	}
}

real scalar moptimize_result_obs(`MoptStruct' M)
{
	return(M.obs)
}

function moptimize_result_converged(`MoptStruct' M)
{
	return(optimize_result_converged(M.S))
}

function moptimize_result_errorcode(`MoptStruct' M)
{
	return(optimize_result_errorcode(M.S))
}

function moptimize_result_errortext(`MoptStruct' M)
{
	return(optimize_result_errortext(M.S))
}

function moptimize_result_returncode(`MoptStruct' M)
{
	if (M.S.errorcode == `Errcode_stata_rc') {
		return(M.st_rc)
	}
	return(optimize_result_returncode(M.S))
}

function moptimize_result_gradient(`MoptStruct' M)
{
	real	rowvector g

	mopt__link(M)
	g = optimize_result_gradient(M.S)
	mopt__unlink(M)
	return(g)
}

function moptimize_result_Hessian(`MoptStruct' M)
{
	real	matrix	H

	mopt__link(M)
	H = optimize_result_Hessian(M.S)
	mopt__unlink(M)
	return(H)
}

real colvector moptimize_result_iterationlog(`MoptStruct' M)
{
	return(optimize_result_iterationlog(M.S))
}

real rowvector moptimize_result_evaluations(`MoptStruct' M)
{
	return(optimize_result_evaluations(M.S))
}

real scalar moptimize_result_iterations(`MoptStruct' M)
{
	return(optimize_result_iterations(M.S))
}

function moptimize_result_eq_coefs(`MoptStruct' M, |real scalar eq)
{
	if (args() == 1 | missing(eq)) {
		return(optimize_result_params(M.S))
	}

	real	scalar	i0, i1

	i0 = M.eqdims[1,eq]
	i1 = M.eqdims[2,eq]
	mopt__check_eqnum(eq, M.neq)
	return(optimize_result_params(M.S)[|i0\i1|])
}

function moptimize_result_coefs(`MoptStruct' M)
{
	return(optimize_result_params(M.S))
}

function moptimize_result_scores(`MoptStruct' M)
{
	real	matrix	S

	mopt__rescore(M)
	S = mopt__scores(M, 1)
	return(S)
}

real scalar moptimize_result_value0(`MoptStruct' M)
{
	return(optimize_result_value0(M.S))
}

real scalar moptimize_result_value(`MoptStruct' M)
{
	return(optimize_result_value(M.S))
}

real matrix moptimize_result_V(`MoptStruct' M, |real scalar eq)
{
	return(mopt__result_V(M, eq,
		(M.uvcetype != `MOPT_vcetype_none'
			? M.uvcetype : M.vce)))
}

/*STATIC*/ real matrix mopt__result_V(
	`MoptStruct'	M,
	real	scalar	eq,
	real	scalar	vce
)
{
	if (vce == `MOPT_vcetype_svy' | M.svy == `OPT_onoff_on') {
		return(moptimize_result_V_robust(M, eq))
	}
	if (vce == `MOPT_vcetype_cluster') {
		return(moptimize_result_V_robust(M, eq))
	}
	if (vce == `MOPT_vcetype_robust') {
		return(moptimize_result_V_robust(M, eq))
	}
	if (vce == `MOPT_vcetype_opg') {
		return(moptimize_result_V_opg(M, eq))
	}
	return(moptimize_result_V_oim(M, eq))
}

string scalar moptimize_result_Vtype(`MoptStruct' M)
{
	return(mopt__result_Vtype(M,
		(M.uvcetype != `MOPT_vcetype_none'
			? M.uvcetype : M.vce)))
}

/*STATIC*/ string scalar mopt__result_Vtype(`MoptStruct' M, real scalar vce)
{
	if (vce == `MOPT_vcetype_svy' | M.svy == `OPT_onoff_on') {
		return("svy")
	}
	if (vce == `MOPT_vcetype_cluster') {
		return("cluster")
	}
	if (vce == `MOPT_vcetype_robust') {
		return("robust")
	}
	if (vce == `MOPT_vcetype_opg') {
		return("opg")
	}
	return("oim")
}


real matrix moptimize_result_V_oim(`MoptStruct' M, |real scalar eq)
{
	real	matrix	V
	real	matrix	block

	if (nonmissing(eq)) {
		block	= moptimize_util_eq_indices(M,eq,eq)
	}
	mopt__link(M)
	V = optimize_result_V_oim(M.S)
	mopt__unlink(M)
	if (nonmissing(eq)) {
		return(V[|block|])
	}
	return(V)
}

real scalar mopt__use_opt_for_V(`MoptStruct' M)
{
	real	scalar	nobs

	if (M.S.evaltype != `OPT_evaltype_v') {
		if (M.S.evaltype == `OPT_evaltype_d') {
			return(1)
		}
		if (M.S.evaltype == `OPT_evaltype_q') {
			return(1)
		}
		return(0)
	}
	if (isview(M.S.gradient_v)) {
		return(1)
	}
	if (!strlen(M.st_touse)) {
		nobs	= st_nobs()
	}
	else {
		stata(sprintf("quietly count if %s", M.st_touse))
		nobs	= st_numscalar("r(N)")
	}
	if (nobs == rows(M.S.gradient_v)) {
		return(1)
	}
	return(0)
}

function mopt__scores(`MoptStruct' M,|real scalar values)
{
	real	scalar	expand
	real	scalar	nobs
	real	matrix	scores
	real	vector	sel
	real	matrix	info
	real	scalar	k
	real	scalar	i
	real	scalar	r

	if (args() == 1) {
		values = 0
	}

	expand = any(M.S.evaltype_f :== tokens("`VTYPE'"))
	if (!expand) {
		if (isview(M.S.gradient_v) & values == 0) {
			return(invtokens(M.st_scores))
		}
		else {
			if (M.st_touse != M.st_sample) {
				sel = st_data(., M.st_touse, M.st_sample)
				scores = J(rows(sel), cols(M.S.gradient_v), 0)
				scores[selectindex(sel),] = M.S.gradient_v
				return(scores)
			}
			return(M.S.gradient_v)
		}
	}
	rob__set_eqsize(M.S.R, cols(M.S.params))

	if (isview(M.S.gradient_v) & values == 0) {
		return(invtokens(M.st_scores))
	}

	if (!strlen(M.st_touse)) {
		nobs	= st_nobs()
	}
	else {
		stata(sprintf("quietly count if %s", M.st_touse))
		nobs	= st_numscalar("r(N)")
	}
	expand = nobs != rows(M.S.gradient_v)
	if (!expand) {
		return(M.S.gradient_v)
	}
	if (M.by == NULL) {
		errprintf(
"scores returned by evaluator not conformable with the dataset\n")
		exit(503)
	}
	scores	= J(nobs, cols(M.S.params), 0)
	info = panelsetup((*M.by), 1)
	k	= rows(info)
	if (k != rows(M.S.gradient_v)) {
		errprintf(
"scores returned by evaluator not conformable with the groups\n")
		exit(503)
	}
	if (cols(scores) != cols(M.S.gradient_v)) {
		if (cols(M.S.gradient_v) == cols(M.S.T)) {
			M.S.gradient_v = M.S.gradient_v*M.S.T'
		}
	}
	r	= 0
	for (i=1; i<=k; i++) {
		r = r + info[i,2] - info[i,1] + 1
		scores[r,.] = M.S.gradient_v[i,.]
	}

	return(scores)
}

function moptimize_result_V_opg(`MoptStruct' M, |real scalar eq)
{
	real	matrix	V
	real	matrix	block

	if (nonmissing(eq)) {
		block	= moptimize_util_eq_indices(M,eq,eq)
	}
	if (mopt__use_opt_for_V(M)) {
		mopt__link(M)
		V = optimize_result_V_opg(M.S)
		mopt__unlink(M)
		if (nonmissing(eq)) {
			return(V[|block|])
		}
		return(V)
	}

	robust_init_covmat(M.S.R, J(0,0,.))
	mopt__rescore(M)
	robust_init_scores(M.S.R, mopt__scores(M))
	robust_init_minus(M.S.R, 0)
	V = robust(M.S.R)
	if (M.S.hasCns) {
		V = M.S.T'*V*M.S.T
		_invsym(V)
		V = M.S.T*V*M.S.T'
		if (nonmissing(eq)) {
			return(V[|block|])
		}
		return(V)
	}
	_invsym(V)
	if (nonmissing(eq)) {
		return(V[|block|])
	}
	return(V)
}

real matrix moptimize_result_V_robust(`MoptStruct' M, |real scalar eq)
{
	real	scalar	rc
	real	matrix	V
	real	matrix	S
	real	matrix	block
	real	vector	sel
	real	matrix	info
	string	scalar	touse
	string	scalar	hold

	if (nonmissing(eq)) {
		block	= moptimize_util_eq_indices(M,eq,eq)
	}
	if (mopt__use_opt_for_V(M)) {
		mopt__link(M)
		V = optimize_result_V_robust(M.S)
		mopt__unlink(M)
		if (nonmissing(eq)) {
			return(V[|block|])
		}
		return(V)
	}

	hold = ""
	mopt__link(M)
	robust_init_covmat(M.S.R, optimize_result_V_oim(M.S))
	mopt__unlink(M)
	mopt__rescore(M)
	if (M.by != NULL & any(M.S.evaltype_f :== tokens("`VTYPE'"))) {
	    S = mopt__scores(M, 1)
	    info = panelsetup((*M.by), 1)
	    sel = rowsum(S :!= 0) :!= 0
	    if (sum(sel) == rows(info)) {
		if (M.st_touse == "") {
		    robust_init_touse(M.S.R, sel)
		}
		else {
		    hold = robust_name_touse(M.S.R)
		    touse = st_tempname()
		    rc = _stata(sprintf("quietly gen byte %s = 0", touse))
		    if (rc) exit(rc)
		    st_view(V=., ., touse, M.st_touse)
		    V[,] = sel
		    robust_init_touse(M.S.R, touse)
		    S = select(S, sel)
		}
		if (M.wtype) {
		    V = robust_init_weight(M.S.R)
		    if (M.svy == 0) {
			robust_init_weight(M.S.R, select(V, sel))
		    }
		    if (M.st_by == robust_name_stage_units(M.S.R,1)) {
			robust_init_stage_units(M.S.R, 1, "")
		    }
		}
	    }
	    robust_init_scores(M.S.R, S)
	}
	else {
	    robust_init_scores(M.S.R, mopt__scores(M))
	}
	robust_init_minus(M.S.R, 1)
	V	= robust(M.S.R)
	if (hold != "") {
		robust_init_touse(M.S.R, hold)
	}
	if (nonmissing(eq)) {
		return(V[|block|])
	}
	return(V)
}

string matrix moptimize_result_colstripe(`MoptStruct' M, |real scalar eq)
{
	if (args() == 1) {
		return(*M.S.stripes[1])
	}
	return((*M.S.stripes[1])[|moptimize_util_eq_indices(M,eq,.)|])
}

real rowvector moptimize_result_deriv_h(`MoptStruct' M)
{
	return(optimize_result_deriv_h(M.S))
}

real rowvector moptimize_result_deriv_scale(`MoptStruct' M)
{
	return(optimize_result_deriv_scale(M.S))
}

real matrix moptimize_result_V_svy(`MoptStruct' M, |real scalar eq)
{
	return(moptimize_result_V_robust(M, eq))
}

real matrix moptimize_result_V_svy_srs(`MoptStruct' M)
{
	return(optimize_result_V_srs(M.S))
}

real matrix moptimize_result_V_svy_srssub(`MoptStruct' M)
{
	return(optimize_result_V_srssub(M.S))
}

real matrix moptimize_result_V_svy_srswr(`MoptStruct' M)
{
	return(optimize_result_V_srswr(M.S))
}

real matrix moptimize_result_V_svy_srswrsub(`MoptStruct' M)
{
	return(optimize_result_V_srswrsub(M.S))
}

real scalar moptimize_result_svy_census(`MoptStruct' M)
{
	return(optimize_result_svy_census(M.S))
}

real scalar moptimize_result_svy_N_clust(`MoptStruct' M)
{
	return(optimize_result_svy_N_clust(M.S))
}

real scalar moptimize_result_svy_N_strata(`MoptStruct' M)
{
	return(optimize_result_svy_N_strata(M.S))
}

real scalar moptimize_result_svy_N_omit(`MoptStruct' M)
{
	return(optimize_result_svy_N_omit(M.S))
}

real scalar moptimize_result_svy_N(`MoptStruct' M)
{
	return(optimize_result_svy_N(M.S))
}

real scalar moptimize_result_svy_N_sub(`MoptStruct' M)
{
	return(optimize_result_svy_N_sub(M.S))
}

real scalar moptimize_result_svy_singleton(`MoptStruct' M)
{
	return(optimize_result_svy_singleton(M.S))
}

real scalar moptimize_result_svy_sum_w(`MoptStruct' M)
{
	return(optimize_result_svy_sum_w(M.S))
}

real scalar moptimize_result_svy_sum_wsub(`MoptStruct' M)
{
	return(optimize_result_svy_sum_wsub(M.S))
}

real rowvector moptimize_result_svy_postsize(`MoptStruct' M)
{
	return(optimize_result_svy_postsize(M.S))
}

real rowvector moptimize_result_svy_postsum(`MoptStruct' M)
{
	return(optimize_result_svy_postsum(M.S))
}

real rowvector moptimize_result_svy_certain(`MoptStruct' M)
{
	return(optimize_result_svy_certain(M.S))
}

real rowvector moptimize_result_svy_single(`MoptStruct' M)
{
	return(optimize_result_svy_single(M.S))
}

real rowvector moptimize_result_svy_strata(`MoptStruct' M)
{
	return(optimize_result_svy_strata(M.S))
}

end
