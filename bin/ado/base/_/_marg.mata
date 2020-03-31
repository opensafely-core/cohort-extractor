*! version 1.5.1  21oct2019
version 11

mata:

void st__marg_reorder(	real	scalar	k_pred,
			string	scalar	st_b,
			string	scalar	st_nobs,
			string	scalar	st_err,
			string	scalar	st_J,
			string	scalar	st_V)
{
	real	scalar	dim
	real	matrix	mat
	string	matrix	stripe
	real	matrix	info
	real	vector	idx
	real	scalar	neq
	real	scalar	i
	real	vector	sub

	if (k_pred < 2) {
		return
	}

	mat	= st_matrix(st_b)
	stripe	= st_matrixcolstripe(st_b)

	dim = cols(mat)
	idx = 1..dim

	info	= panelsetup(stripe,1)
	neq	= rows(info)
	for (i=1; i<=neq; i++) {
		sub = idx[|_2x2(1,info[i,1],1,info[i,2])|]
		dim = cols(sub)/k_pred
		sub = rowshape(rowshape(sub, dim)', 1)
		idx[|_2x2(1,info[i,1],1,info[i,2])|] = sub
	}

	stripe = stripe[idx,]

	// reorder columns of b
	st_matrix(st_b, mat[idx])
	st_matrixcolstripe(st_b, stripe)

	// reorder columns of nobs
	mat = st_matrix(st_nobs)
	st_matrix(st_nobs, mat[idx])
	st_matrixcolstripe(st_nobs, stripe)

	// reorder columns of err
	mat = st_matrix(st_err)
	st_matrix(st_err, mat[idx])
	st_matrixcolstripe(st_err, stripe)

	if (strlen(st_J)) {
		// reorder rows of J
		mat = st_matrix(st_J)
		st_matrix(st_J, mat[idx,])
		st_matrixrowstripe(st_J, stripe)
	}

	if (strlen(st_V)) {
		// reorder rows and columns of V
		mat = st_matrix(st_V)
		st_matrix(st_V, mat[idx,idx])
		st_matrixcolstripe(st_V, stripe)
		st_matrixrowstripe(st_V, stripe)
	}
}

void st__marg_dims_check_at()
{
	real	matrix	atmat
	real	vector	at_skip
	real	vector	at_col
	real	scalar	k
	real	scalar	i

	atmat = st_matrix("e(at)")
	k = cols(atmat)
	if (k == 0) {
		st_local("has_at", "0")
		return
	}
	at_skip = J(1,k,0)
	for (i=1; i<=k; i++) {
		at_col = atmat[.,i]
		at_skip[i] = all(at_col :== at_col[1])
	}
	if (!all(at_skip)) {
		st_matrix(st_local("at_skip"), at_skip)
		st_local("has_at", "1")
	}
	else {
		st_local("has_at", "0")
	}
}

void st__marg_make_group(	string scalar ugmat,
				string scalar ubyvars,
				string scalar uselvar)
{
	real	matrix	gmat
	string	matrix	smat

	gmat = st_data(., ubyvars, uselvar)
	if (missing(gmat)) {
		errprintf("missing values not allowed\n")
		exit(198)
	}
	if (any(gmat:<0)) {
		errprintf("negative values not allowed in by() variables\n")
		exit(198)
	}
	if (any(floor(gmat) :!= gmat)) {
		errprintf("only integer values are allowed in by() variables\n")
		exit(198)
	}
	smat = J(cols(gmat),2,"")
	smat[.,2] = (tokens(ubyvars))'
	st_matrix(ugmat, gmat)
	st_matrixcolstripe(ugmat, smat)
}

void _st_fn_get_basename(string scalar st_mname, string scalar fname)
{
	transmorphic	t
	string	matrix	res
	real	scalar	n

	t	= tokeninit(" ", "\\/.")
	tokenset(t, fname)
	res	= tokengetall(t)
	n	= length(res)
	if (n == 0) {
		st_local(st_mname, "")
	}
	else if (n == 1) {
		st_local(st_mname, res)
	}
	else {
		if (res[n-1] == ".") {
			if (n > 2) {
				st_local(st_mname, res[n-2])
			}
		}
		st_local(st_mname, res[n])
	}
}

// PM -----------------------------------------------------------------------

void st__marg_compute(string scalar predict)
{
	real		matrix	b
	transmorphic	scalar	D
	real		scalar	rc
	real		scalar	nobs
	real		scalar	sumw

	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		b = st_matrix("e(b_series)")
	}
	else {
		b = st_matrix("e(b)")
	}
	D = deriv_init()
	deriv_init_verbose(		D, "on")
	deriv_init_evaluator(		D, &__marg_eval())
	deriv_init_evaluatortype(	D, "t")
	deriv_init_params(		D, b)
	deriv_init_argument(		D, 1, predict)
	deriv_init_argument(		D, 2, "next")

	rc = _deriv(D, 0)
	if (st_numscalar("e(empty_cell)")==1) {
		if (rc) exit(deriv_result_returncode(D))
		nobs = st_numscalar("r(N)")
		sumw = st_numscalar("r(sum_w)")
		st_numscalar("r(b)", J(1, cols(deriv_result_values(D)), 0))
		st_matrix("r(db)", J(1, cols(deriv_result_Jacobian(D)), 0))
		st_numscalar("r(N)", nobs)
		st_numscalar("r(sum_w)", sumw)		
	}
	else {
		if (rc) exit(deriv_result_returncode(D))
		if (st_numscalar("r(not_estimable)") == 1) {
			return
		}
		deriv_init_argument(		D, 2, "")
		nobs = st_numscalar("r(N)")
		sumw = st_numscalar("r(sum_w)")

		rc = _deriv(D, 1)
		if (rc) exit(deriv_result_returncode(D))

		st_rclear()
		st_numscalar("r(b)", deriv_result_values(D))
		st_matrix("r(db)", deriv_result_Jacobian(D))
		st_numscalar("r(N)", nobs)
		st_numscalar("r(sum_w)", sumw)
	}
}

void __marg_eval(
	real	rowvector	b,
	string	scalar		predict,
	string	scalar		next,
	real	vector		pm)
{
	real	scalar	rc
	string	scalar	tb
	string  matrix  stripe

	tb = st_tempname()
	st_matrix(tb, b)

	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		stripe = st_matrixcolstripe("e(b_series)")
		st_matrix("e(b_series)", b)
		st_matrixcolstripe("e(b_series)", stripe)
	}
	else {
		tb = st_tempname()
		st_matrix(tb, b)
		rc = _stata(sprintf("_marg_repost b=%s", tb))
		if (rc) exit(rc)
	}

	rc = _stata(sprintf("_marg_compute %s %s", predict, next))
	if (rc) exit(rc)

	pm = st_numscalar("r(b)")
}

struct __marg_cr {
	string	scalar		predict
	string	scalar		touse
	string	scalar		ifin
	real	rowvector	b
	string	scalar		tname
	string	scalar		next
	string	scalar		opts
}

void st__marg_cr_compute(	string	scalar	predict,
				string	scalar	touse,
				string	scalar	opts,
				string	scalar	st_chainrule)
{
	real		matrix	chainrule
struct	__marg_cr	scalar	P
	string		scalar	wvar
	string		matrix	stripe
	string		scalar	mult
	real		scalar	dim, i
	real		scalar	neq, i1, i2, ip
	real		scalar	eq
	transmorphic	scalar	D
	real		scalar	rc
	real		scalar	nobs
	real		scalar	sumw
	real		vector	w
	string		scalar	score_var, gvar
	real		matrix	score_view, gview
	real		vector	g
	string		vector	cons
	real		scalar	has_touse

	cons	= ("_cons", "o._cons")
	P.predict	= predict
	P.opts		= opts
	chainrule	= st_matrix(st_chainrule)
	P.touse		= touse
	has_touse	= strlen(touse)
	if (has_touse) {
		P.ifin = sprintf("if %s", P.touse)
	}
	else {
		P.ifin = "in 1"
	}
	wvar		= st_local("exp")
	P.tname		= st_tempname()
	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		P.b		= st_matrix("e(b_series)")
		stripe		= st_matrixcolstripe("e(b_series)")[,2]
	}	
	else {
		P.b		= st_matrix("e(b)")
		stripe		= st_matrixcolstripe("e(b)")[,2]
	}
	if (has_touse) {
		if (strlen(wvar)) {
			w = st_data(., wvar, P.touse)
		}
		else {
			w = st_data(., P.touse, P.touse)
		}
		w = w/quadcolsum(w)
	}

	score_var	= st_tempname()
	gvar		= st_tempname()
	score_view	= .
	gview		= .
	if (any(chainrule[,3])) {
		// NOTE: Generate variables before any calls to
		// _deriv(), then get views after first to _deriv(),
		// otherwise each view's variable index will get broken
		// by moving of -e(sample)-.

		rc = _stata(sprintf("qui gen double %s=. in 1", score_var))
		if (rc) exit(rc)
		rc = _stata(sprintf("qui gen double %s=. in 1", gvar))
		if (rc) exit(rc)
	}

	D = deriv_init()
	deriv_init_verbose(		D, "on")
	deriv_init_evaluator(		D, &__marg_cr_eval())
	deriv_init_evaluatortype(	D, "vt")
	deriv_init_user_h(		D, &__marg_cr_h())
	if (has_touse) {
		deriv_init_weights(		D, w)
	}
	deriv_init_params(		D, 0)
	deriv_init_argument(		D, 1, P)
	deriv_init_argument(		D, 2, 1)

	if (st_local("nonext") == "") {
		P.next = "next"
	}
	rc = _deriv(D, 0)
	if (rc) exit(deriv_result_returncode(D))
	P.next = ""
	nobs = st_numscalar("r(N)")
	sumw = st_numscalar("r(sum_w)")

	if (any(chainrule[,3])) {
		if (has_touse) {
			st_view(score_view, ., score_var, P.touse)
			st_view(gview, ., gvar, P.touse)
		}
		else {
			st_view(score_view, 1, score_var)
			st_view(gview, 1, gvar)
		}
	}

	dim	= cols(P.b)
	g	= J(1,dim,0)
	neq	= rows(chainrule)
	for (eq=1; eq<=neq; eq++) {
		i1	= chainrule[eq,1]
		i2	= chainrule[eq,2]
		ip	= chainrule[eq,3]
		if (ip) {
			deriv_reset_params(D, 0)
			deriv_init_argument(D, 2, ip)
			rc = _deriv(D, 1)
			if (rc) exit(deriv_result_returncode(D))
			score_view[,] = deriv_result_scores(D)
			g[ip] = deriv_result_gradient(D)
			for (i=i1; i<=i2; i++) {
				if (i == ip) {
					continue
				}
				if (any(stripe[ip] :== cons)) {
					mult = (any(stripe[i] :== cons)
						? ""
						: sprintf("*(%s)", stripe[i]))
				}
				else {
					if (any(stripe[i] :== cons)) {
						mult = sprintf("/(%s)",
							stripe[ip])
					}
					else {
						mult = sprintf("*(%s)/(%s)",
							stripe[i], stripe[ip])
					}
				}
				rc = _stata(sprintf(
					"qui replace %s = %s%s %s",
					gvar,
					score_var,
					mult,
					P.ifin
				))
				if (rc) exit(rc)
				if (has_touse) {
					g[i] = quadcross(gview, w)
				}
				else {
					g[i] = st_data(1,gvar)
				}
			}
		}
		else {
			for (i=i1; i<=i2; i++) {
				deriv_reset_params(D, 0)
				deriv_init_argument(D, 2, i)
				rc = _deriv(D, 1)
				if (rc) exit(deriv_result_returncode(D))
				g[i] = deriv_result_gradient(D)
			}
		}
	}

	st_rclear()
	st_numscalar("r(b)", deriv_result_value(D))
	st_matrix("r(db)", g)
	st_numscalar("r(N)", nobs)
	st_numscalar("r(sum_w)", sumw)
}

void __marg_cr_h(
	real		rowvector	param,
	real		scalar		ignore,
struct	__marg_cr	scalar		P,
	real		scalar		i,
	real		scalar		h)
{
	pragma unset param
	pragma unset ignore

	h = 1e-4
	h = (abs(P.b[i])+h)*h
}

void __marg_cr_eval(
	real		rowvector	params,
struct	__marg_cr	scalar		P,
	real		scalar		i,
	real		colvector	pm)
{
	real	scalar	rc
	real	scalar	myb

	if (params) {
		myb = P.b[i]
		P.b[i] = P.b[i] + params
	}
	st_matrix(P.tname, P.b)

	rc = _stata(sprintf("_marg_repost b=%s", P.tname))
	if (rc) exit(rc)

	rc = _stata(sprintf(	"_marg_compute %s %s, gen(%s) replace %s %s",
				P.predict,
				P.ifin,
				P.tname,
				P.opts,
				P.next))
	if (rc) exit(rc)

	if (params) {
		P.b[i] = myb
	}

	if (P.touse == "") {
		pm = st_data(1, P.tname)
	}
	else {
		pm = st_data(., P.tname, P.touse)
	}
}

// MFX ----------------------------------------------------------------------

struct __marg_dydx_cr2 {
	string	scalar		predict
	string	scalar		opts
	string	scalar		touse
	string	scalar		ifin
	real	matrix		cr
	real	rowvector	b
	string	scalar		tname
	real	colvector	w
	real	scalar		h
	real	scalar		scale
}

void st__marg_dydx_cr2_compute(	string	scalar	predict,
				string	scalar	touse,
				string	scalar	opts,
				real	scalar	todo)
{
	real		scalar	rc
	transmorphic	scalar	D
struct	__marg_dydx_cr2	scalar	P
	string		scalar	wvar
	real		scalar	neq
	string		matrix	stripe
	real		scalar	eq1
	real		scalar	eq2
	real		scalar	nobs
	string		scalar	var
	string		scalar	tvar
	real		scalar	i1
	real		scalar	i2
	real		matrix	view
	string		vector	cons
	real		scalar	has_touse
	pragma unset view

	cons	= ("_cons", "o._cons")
	P.predict	= predict
	P.opts		= opts
	P.touse		= touse
	has_touse	= strlen(touse)
	if (has_touse) {
		P.ifin = sprintf("if %s", P.touse)
	}
	else {
		P.ifin = "in 1"
	}
	wvar		= st_local("exp")
	P.cr		= st_matrix(st_local("cr"))
	neq		= rows(P.cr)
	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		stripe		= st_matrixcolstripe("e(b_series)")[,2]
		P.b		= st_matrix("e(b_series)")	
	}
	else {
		stripe		= st_matrixcolstripe("e(b)")[,2]
		P.b		= st_matrix("e(b)")
	}
	tvar		= st_local("t")
	P.tname		= st_tempname()
	if (has_touse) {
		if (strlen(wvar)) {
			P.w = st_data(., wvar, P.touse)
		}
		else {
			P.w = st_data(., P.touse, P.touse)
		}
		P.w = P.w/quadcolsum(P.w)
	}

	D = deriv_init()
	deriv_init_verbose(		D, "on")
	deriv_init_evaluator(		D, &__marg_dydx_cr2_eval1())
	deriv_init_evaluatortype(	D, "vt")
	deriv_init_user_h(		D, &__marg_dydx_cr2_h1())
	deriv_init_bounds(D,		(1e-5, 1e-3))	// same as -mfx-
	if (has_touse) {
		deriv_init_weights(		D, P.w)
	}
	deriv_init_argument(		D, 1, P)
	deriv_init_argument(		D, 4, 0)
	deriv_init_argument(		D, 5, 0)

	for (eq1=1; eq1<=neq; eq1++) {
		deriv_init_params(	D, 0)
		deriv_init_argument(	D, 2, eq1)
		deriv_init_argument(	D, 3, eq1)
		deriv_init_argument(	D, 4, 0)
		deriv_init_argument(	D, 5, 0)

		rc = _deriv(D, 0)
		if (rc) exit(deriv_result_returncode(D))

		if (eq1==1) {
			nobs	= st_numscalar("r(N)")
		}

		var = sprintf("%s_%g", tvar, eq1)
		if (has_touse) {
			st_view(view, ., var, P.touse)
		}
		else {
			st_view(view, 1, var)
		}
		view[,] = deriv_result_values(D)
		i1 = P.cr[eq1,3]
		if (all(stripe[i1] :!= cons)) {
			rc = _stata(sprintf(
				"qui replace %s = %s/%s %s",
				var,
				var,
				stripe[i1],
				P.ifin))
			if (rc) exit(rc)
		}

		if (!todo) {
			continue
		}
		deriv_init_argument(	D, 4, P.h)
		deriv_init_argument(	D, 5, P.scale)
		for (eq2=1; eq2<=eq1; eq2++) {
			deriv_reset_params(	D, 0)
			deriv_init_argument(	D, 3, eq2)

			rc = _deriv(D, 1)
			if (rc) exit(deriv_result_returncode(D))

			var = sprintf("%s_%g_%g", tvar, eq1, eq2)
			if (has_touse) {
				st_view(view, ., var, P.touse)
			}
			else {
				st_view(view, 1, var)
			}
			view[,] = deriv_result_scores(D)
			i2 = P.cr[eq2,3]
			if (all(stripe[i1]:!=cons) & all(stripe[i2]:!=cons)) {
				rc = _stata(sprintf(
					"qui replace %s = %s/(%s*%s) %s",
					var,
					var,
					stripe[i1],
					stripe[i2],
					P.ifin))
				if (rc) exit(rc)
			}
			else if (all(stripe[i1] :!= cons)) {
				rc = _stata(sprintf(
					"qui replace %s = %s/%s %s",
					var,
					var,
					stripe[i1],
					P.ifin))
				if (rc) exit(rc)
			}
			else if (all(stripe[i2] :!= cons)) {
				rc = _stata(sprintf(
					"qui replace %s = %s/%s %s",
					var,
					var,
					stripe[i2],
					P.ifin))
				if (rc) exit(rc)
			}
		}
	}

	st_rclear()
	st_numscalar("r(N)", nobs)
}

void __marg_dydx_cr2_eval1(
	real			rowvector	params,
struct	__marg_dydx_cr2	scalar		P,
	real			scalar		eq1,
	real			scalar		eq2,
	real			scalar		h,
	real			scalar		scale,
	real			colvector	pm)
{
	transmorphic	scalar		D
	real		scalar		rc
	real		scalar		i
	real		scalar		myb
	pragma unset eq1

	if (params) {
		i	= P.cr[eq2,3]
		myb	= P.b[i]
		P.b[i] = P.b[i] + params
	}

	D = deriv_init()
	deriv_init_verbose(		D, "on")
	deriv_init_evaluator(		D, &__marg_dydx_cr2_eval2())
	deriv_init_evaluatortype(	D, "vt")
	deriv_init_user_h(		D, &__marg_dydx_cr2_h2())
	deriv_init_bounds(D,		(1e-5, 1e-3))	// same as -mfx-
	if (P.touse != "") {
		deriv_init_weights(		D, P.w)
	}
	deriv_init_argument(		D, 1, P)
	deriv_init_argument(		D, 2, eq1)
	deriv_init_argument(		D, 3, eq2)
	deriv_init_params(		D, 0)
	if (scale & h) {
		deriv_init_h(		D, h)
		deriv_init_scale(	D, scale)
		deriv_init_search(	D, "off")
	}

	rc = _deriv(D, 1)
	if (rc) exit(deriv_result_returncode(D))
	pm	= deriv_result_scores(D)
	P.h	= deriv_result_h(D)
	P.scale	= deriv_result_scale(D)

	if (params) {
		P.b[i] = myb
	}
}

void __marg_dydx_cr2_h1(
	real			rowvector	param,
	real			scalar		ignore,
struct	__marg_dydx_cr2	scalar		P,
	real			scalar		eq1,
	real			scalar		eq2,
	real			scalar		ignore2,
	real			scalar		ignore3,
	real			scalar		h)
{
	real	scalar	i
	pragma unset param
	pragma unset ignore
	pragma unset ignore2
	pragma unset ignore3
	pragma unset eq1

	i = P.cr[eq2,3]
	h = 1e-4
	h = (abs(P.b[i])+h)*h
}

void __marg_dydx_cr2_eval2(
	real		rowvector	params,
struct	__marg_dydx_cr2	scalar		P,
	real		scalar		eq1,
	real		scalar		eq2,
	real		colvector	pm)
{
	real		scalar		rc
	real		scalar		i
	real		scalar		myb
	pragma unset eq2

	if (params) {
		i	= P.cr[eq1,3]
		myb	= P.b[i]
		P.b[i] = P.b[i] + params
	}

	st_matrix(P.tname, P.b)

	rc = _stata(sprintf("_marg_repost b=%s", P.tname))
	if (rc) exit(rc)

	rc = _stata(sprintf(	"_marg_compute %s %s, gen(%s) %s replace",
				P.predict,
				P.ifin,
				P.tname,
				P.opts))
	if (rc) exit(rc)

	if (params) {
		P.b[i] = myb
	}
	if (P.touse == "") {
		pm = st_data(1, P.tname)
	}
	else {
		pm = st_data(., P.tname, P.touse)
	}
}

void __marg_dydx_cr2_h2(
	real			rowvector	param,
	real			scalar		ignore,
struct	__marg_dydx_cr2	scalar		P,
	real			scalar		eq1,
	real			scalar		eq2,
	real			scalar		h)
{
	real	scalar	i
	pragma unset param
	pragma unset ignore
	pragma unset eq2

	i = P.cr[eq1,3]
	h = 1e-4
	h = (abs(P.b[i])+h)*h
}

struct __marg_dydx_cr {
	string	scalar	predict
	string	scalar	opts
	string	scalar	touse
	string	scalar	ifin
	string	scalar	tname
}

void st__marg_dydx_cr_compute(	string	scalar	predict,
				string	scalar	touse,
				string	scalar	opts,
				real	scalar	todo)
{
struct	__marg_dydx_cr	scalar		P
	string		scalar		wvar
	real		matrix		cr
	string		vector		stripe
	real		vector		freeparm
	real		matrix		b
	real		matrix		balt
	real		scalar		neq
	real		scalar		eq1, i1
	real		scalar		eq2, i2
	transmorphic	scalar		D
	real		scalar		rc
	real		vector		w
	real		scalar		n
	real		scalar		nobs
	real		matrix		view
	real		vector		h
	string		scalar		tvar
	string		scalar		var
	real		colvector	p0
	real		colvector	pp
	real		colvector	mm
	real		matrix		pph
	real		matrix		mmh
	string		vector		cons
	real		scalar		has_touse
	pragma unset view
	pragma unset pp
	pragma unset mm

	cons	= ("_cons", "o._cons")
	P.predict	= predict
	P.opts		= opts
	tvar		= tokens(st_local("t"))
	P.touse		= touse
	has_touse	= strlen(touse)
	if (has_touse) {
		P.ifin = sprintf("if %s", touse)
	}
	else {
		P.ifin = "in 1"
	}
	wvar		= st_local("exp")
	cr		= st_matrix(st_local("cr"))
	neq		= rows(cr)
	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		stripe		= st_matrixcolstripe("e(b_series)")[,2]
		freeparm	= st_matrixcolfreeparm("e(b_series)")
	}
	else {
		stripe		= st_matrixcolstripe("e(b)")[,2]
		freeparm	= st_matrixcolfreeparm("e(b)")
	}
	for (i1=1; i1<=rows(stripe); i1++) {
		if (freeparm[i1]) {
			stripe[i1] = "_cons"
		}
	}
	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		b		= st_matrix("e(b_series)")		
	}
	else {
		b		= st_matrix("e(b)")
	}
	P.tname		= st_tempname()
	if (has_touse) {
		if (strlen(wvar)) {
			w = st_data(., wvar, P.touse)
		}
		else {
			w = st_data(., P.touse, P.touse)
		}
		n = rows(w)
		w = w/quadcolsum(w)
	}
	else {
		n = 1
	}

	D = deriv_init()
	deriv_init_verbose(		D, "on")
	deriv_init_evaluator(		D, &__marg_dydx_cr_eval())
	deriv_init_evaluatortype(	D, "vt")
	deriv_init_user_h(		D, &__marg_dydx_cr_h())
	deriv_init_bounds(D,		(1e-5, 1e-3))	// same as -mfx-
	if (has_touse) {
		deriv_init_weights(		D, w)
	}
	deriv_init_params(		D, 0)
	deriv_init_argument(		D, 1, P)
	deriv_init_argument(		D, 2, b)
	deriv_init_argument(		D, 3, 1)

	rc = _deriv(D, 0)
	if (rc) exit(deriv_result_returncode(D))
	nobs	= st_numscalar("r(N)")
	p0	= deriv_result_values(D)

	if (neq > 1) {
		pph	= J(n,neq,0)
		mmh	= J(n,neq,0)
	}
	h	= J(1,neq,0)
	for (eq1=1; eq1<=neq; eq1++) {
		i1	= cr[eq1,3]
		deriv_reset_params(D, 0)
		deriv_init_h(		D, .)
		deriv_init_scale(	D, .)
		deriv_init_argument(	D, 3, i1)
		rc = _deriv(D, 1)
		if (rc) exit(deriv_result_returncode(D))
		var = sprintf("%s_%g", tvar, eq1)
		if (has_touse) {
			st_view(view, ., var, P.touse)
		}
		else {
			st_view(view, 1, var)
		}
		view[,] = deriv_result_scores(D)
		if (all(stripe[i1] :!= cons)) {
			rc = _stata(sprintf(
				"qui replace %s = %s/%s %s",
				var,
				var,
				stripe[i1],
				P.ifin))
			if (rc) exit(rc)
		}
		if (!todo) {
			continue
		}
		h[eq1]	= deriv_result_delta(D)
		var	= sprintf("%s_%g_%g", tvar, eq1, eq1)
		if (has_touse) {
			st_view(view, ., var, P.touse)
		}
		else {
			st_view(view, 1, var)
		}
		if (h[eq1]) {
			__marg_dydx_cr_eval(	h[eq1],
						P,
						b,
						i1,
						pp)
			if (neq > 1) {
				pph[,eq1] = pp
			}
			__marg_dydx_cr_eval(	-h[eq1],
						P,
						b,
						i1,
						mm)
			if (neq > 1) {
				mmh[,eq1] = mm
			}
			view[,] = (pp + mm - 2*p0)/(h[eq1]^2)
			if (all(stripe[i1] :!= cons)) {
				rc = _stata(sprintf(
					"qui replace %s = %s/(%s)^2 %s",
					var,
					var,
					stripe[i1],
					P.ifin))
				if (rc) exit(rc)
			}
		}
		else {
			view[,] = J(n,1,0)
		}
		for (eq2=1; eq2<eq1; eq2++) {
			var	= sprintf("%s_%g_%g", tvar, eq1, eq2)
			if (has_touse) {
				st_view(view, ., var, P.touse)
			}
			else {
				st_view(view, 1, var)
			}
			if (!h[eq2] | !h[eq1]) {
				view[,] = J(n,1,0)
				continue
			}
			i2	= cr[eq2,3]
			balt	= b
			balt[i1] = b[i1] + h[eq1]
			balt[i2] = b[i2] + h[eq2]
			__marg_dydx_cr_eval(	0,
						P,
						balt,
						1,
						pp)
			balt[i1] = b[i1] - h[eq1]
			balt[i2] = b[i2] - h[eq2]
			__marg_dydx_cr_eval(	0,
						P,
						balt,
						1,
						mm)

			view[,] = (pp + mm + 2*p0 - pph[,eq1] - mmh[,eq1] -
				pph[,eq2] - mmh[,eq2]) / (2*h[eq1]*h[eq2])
			if (all(stripe[i1] :!= cons) | all(stripe[i2] :!= cons)) {
				rc = _stata(sprintf(
					"qui replace %s = %s/(%s*%s) %s",
					var,
					var,
					stripe[i1],
					stripe[i2],
					P.ifin))
				if (rc) exit(rc)
			}
		}
	}

	st_rclear()
	st_numscalar("r(N)", nobs)
}

void __marg_dydx_cr_h(
	real	rowvector	param,
	real	scalar		ignore,
struct	__marg_dydx_cr	scalar	P,
	real	rowvector	b,
	real	scalar		i,
	real	scalar		h)
{
	pragma unset param
	pragma unset ignore
	pragma unset P

	h = 1e-4
	h = (abs(b[i])+h)*h
}

void __marg_dydx_cr_eval(
	real	rowvector	params,
struct	__marg_dydx_cr	scalar	P,
	real	rowvector	b,
	real	scalar		i,
	real	colvector	pm)
{
	real	scalar	rc
	real	scalar	myb

	if (params) {
		myb = b[i]
		b[i] = b[i] + params
	}
	st_matrix(P.tname, b)

	rc = _stata(sprintf("_marg_repost b=%s", P.tname))
	if (rc) exit(rc)

	rc = _stata(sprintf(	"_marg_compute %s %s, gen(%s) %s replace",
				P.predict,
				P.ifin,
				P.tname,
				P.opts))
	if (rc) exit(rc)

	if (params) {
		b[i] = myb
	}

	if (P.touse == "") {
		pm = st_data(1, P.tname)
	}
	else {
		pm = st_data(., P.tname, P.touse)
	}
}

struct __marg_dydx {
	string	scalar	opts
	string	scalar	o
	string	scalar	touse
	string	scalar	ifin
	string	scalar	xvar
	string	scalar	wgt
	real	matrix	xbar
	string	scalar	altcond
}

void st__marg_dydx_ccompute(string scalar predict)
{
	real		matrix	b
	transmorphic	scalar	D
	real		scalar	rc
	real		scalar	nobs
	real		scalar	sumw

	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		b = st_matrix("e(b_series)")
	}
	else {
		b = st_matrix("e(b)")
	}
	
	D = deriv_init()
	deriv_init_verbose(D, "on")
	deriv_init_evaluator(D, &__marg_dydx_ceval())
	deriv_init_evaluatortype(D, "t")
	deriv_init_bounds(D, (1e-5, 1e-3))	// same as -mfx-
	deriv_init_params(D, b)
	deriv_init_argument(D, 1, predict)
	rc = _deriv(D, 0)
	if (rc) exit(deriv_result_returncode(D))
	if (st_numscalar("r(not_estimable)") == 1) {
		return
	}
	nobs = st_numscalar("r(N)")
	sumw = st_numscalar("r(sum_w)")
	rc = _deriv(D, 1)
	if (rc) exit(deriv_result_returncode(D))
	st_rclear()
	st_numscalar("r(b)", deriv_result_values(D))
	st_matrix("r(db)", deriv_result_Jacobian(D))
	st_numscalar("r(N)", nobs)
	st_numscalar("r(sum_w)", sumw)
}

void __marg_dydx_ceval(
	real	rowvector	b,
	string	scalar		predict,
	real	vector		ape)
{
	real	scalar	rc
	string	scalar	tb
	string matrix stripe

	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		stripe = st_matrixcolstripe("e(b_series)")
		st_matrix("e(b_series)", b)
		st_matrixcolstripe("e(b_series)", stripe)
	}
	else {
		tb = st_tempname()
		st_matrix(tb, b)
		rc = _stata(sprintf("_marg_repost b=%s", tb))	
		if (rc) exit(rc)
	}

	rc = _stata(sprintf("_marg_dydx_ccompute %s", predict))
	if (rc) exit(rc)

	ape = st_numscalar("r(b)")
}

void st__marg_dydx_compute(real scalar h, real scalar scale)
{
	real		scalar	rc
struct	__marg_dydx	scalar	P
	transmorphic	scalar	D
	real		scalar	nobs
	real		scalar	sumw
	real		matrix	x
	real		matrix	w
	string		scalar	wvar
	real		scalar	has_touse
	pragma unset x

	P.opts	= st_local("options")
	P.o	= st_local("o")
	P.touse	= st_local("if")
	has_touse = strlen(P.touse)
	if (has_touse) {
		P.ifin = sprintf("if %s", P.touse)
	}
	else {
		P.ifin = "in 1"
	}
	P.altcond = st_local("alternative")
	P.xvar	= st_local("xvar")
	if (has_touse) {
		wvar	= st_local("exp")
	}
	else {
		wvar	= ""
	}
	if (P.altcond == "") {
		if (has_touse) {
			st_view(x, ., P.xvar, P.touse)
		}
		else {
			st_view(x, 1, P.xvar)
		}
		w = 1
		if (strlen(wvar)) {
			P.wgt = sprintf("[iweight=%s]", wvar)
			st_view(w, ., wvar, P.touse)
		}
		P.xbar = mean(x, w)
	}
	else if (strlen(wvar)) {
		rc = _stata(sprintf("sum %s [iweight=%s] if %s, mean",
			P.xvar, wvar, P.altcond))
		if (rc) exit(rc)
		P.xbar = st_numscalar("r(mean)")
		P.wgt = sprintf("[iweight=%s]", wvar)
	}
	else {
		rc = _stata(sprintf("sum %s if %s, mean",
			P.xvar, P.altcond))
		if (rc) exit(rc)
		P.xbar = st_numscalar("r(mean)")
	}

	D = deriv_init()
	deriv_init_verbose(		D, "on")
	deriv_init_evaluator(		D, &__marg_dydx_eval())
	deriv_init_evaluatortype(	D, "t")
	deriv_init_user_h(		D, &__marg_dydx_h())
	deriv_init_bounds(D,		(1e-8, 1e-4))
	deriv_init_params(		D, 0)
	deriv_init_argument(		D, 1, P)
	if (h > 0 & scale > 0) {
		deriv_init_h(		D, h)
		deriv_init_scale(	D, scale)
		deriv_init_search(	D, "off")
	}
	rc = _deriv(D, 0)
	if (rc) exit(deriv_result_returncode(D))
	if (st_numscalar("r(not_estimable)") == 1) {
		return
	}
	nobs = st_numscalar("r(N)")
	sumw = st_numscalar("r(sum_w)")
	rc = _deriv(D, 1)
	if (rc) exit(deriv_result_returncode(D))
	st_rclear()
	st_numscalar("r(b)", deriv_result_Jacobian(D))
	st_numscalar("r(N)", nobs)
	st_numscalar("r(sum_w)", sumw)
	st_numscalar("r(h)", deriv_result_h(D))
	st_numscalar("r(scale)", deriv_result_scale(D))
}

void __marg_dydx_eval(
	real	rowvector		b,
	struct	__marg_dydx	scalar	P,
	real	vector			pm)
{
	real	scalar	rc

	if (b[1]) {
	    if (P.altcond != "") {
		rc = _stata(sprintf("qui replace %s = %s + (%21x) if %s",
				P.xvar, P.xvar, b[1], P.altcond))
	    }
	    else {
		rc = _stata(sprintf("qui replace %s = %s + (%21x)",
				P.xvar, P.xvar, b[1]))
	    }
		if (rc) exit(rc)
	}
	rc = _stata(sprintf(	"_marg_compute %s %s %s, %s",
				P.o,
				P.wgt,
				P.ifin,
				P.opts))
	if (rc) exit(rc)
	if (b[1]) {
	    if (P.altcond != "") {
		rc = _stata(sprintf("qui replace %s = %s - (%21x) if %s",
				P.xvar, P.xvar, b[1], P.altcond))
	    }
	    else {
		rc = _stata(sprintf("qui replace %s = %s - (%21x)",
				P.xvar, P.xvar, b[1]))
	    }
		if (rc) exit(rc)
	}

	pm = st_numscalar("r(b)")
}

void __marg_dydx_h(
	real	rowvector		b,
	real	scalar			i,
	struct	__marg_dydx	scalar	P,
	real	scalar			h)
{
	pragma unset b
	pragma unset i

	h = 1e-4
	h = (abs(P.xbar)+h)*h
}

void st__marg_dydx_dcompute(string scalar predict)
{
	real		matrix	b
	transmorphic	scalar	D
	real		scalar	rc
	real		scalar	nobs
	real		scalar	sumw

	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		b = st_matrix("e(b_series)")
	}
	else {
		b = st_matrix("e(b)")
	}
	D = deriv_init()
	deriv_init_verbose(D, "on")
	deriv_init_evaluator(D, &__marg_dydx_deval())
	deriv_init_evaluatortype(D, "t")
	deriv_init_bounds(D, (1e-5, 1e-3))	// same as -mfx-
	deriv_init_params(D, b)
	deriv_init_argument(D, 1, predict)
	deriv_init_argument(D, 2, "next")
	rc = _deriv(D, 0)
	if (rc) exit(deriv_result_returncode(D))
	if (st_numscalar("r(not_estimable)") == 1) {
		return
	}
	deriv_init_argument(D, 2, "")
	nobs = st_numscalar("r(N)")
	sumw = st_numscalar("r(sum_w)")
	rc = _deriv(D, 1)
	if (rc) exit(deriv_result_returncode(D))
	st_rclear()
	st_numscalar("r(b)", deriv_result_values(D))
	st_matrix("r(db)", deriv_result_Jacobian(D))
	st_numscalar("r(N)", nobs)
	st_numscalar("r(sum_w)", sumw)
}

void __marg_dydx_deval(
	real	rowvector	b,
	string	scalar		predict,
	string	scalar		next,
	real	vector		dydx)
{
	real	scalar	rc
	string	scalar	tb
	string matrix stripe

	if (st_global("e(cmd_loco)")=="_npreg_series_two") {
		stripe = st_matrixcolstripe("e(b_series)")
		st_matrix("e(b_series)", b)
		st_matrixcolstripe("e(b_series)", stripe)
	}
	else {
		tb = st_tempname()
		st_matrix(tb, b)
		rc = _stata(sprintf("_marg_repost b=%s", tb))	
		if (rc) exit(rc)
	}

	rc = _stata(sprintf("_marg_dydx_dcompute %s %s", predict, next))
	if (rc) exit(rc)

	dydx = st_numscalar("r(b)")
}

void st_marg4cm_search_alt()
{
	string	scalar	var
	string	scalar	vl
	real	matrix	val
	real	scalar	nval
	string	vector	alt
	real	scalar	nalt
	real	vector	altsel
	string	vector	out
	real	scalar	nout
	real	vector	outsel
	real	scalar	i
	real	scalar	v

	var	= st_local("altvar")
	vl	= st_varvaluelabel(var)

	val	= st_matrix(st_local("altvals"))
	nval	= cols(val)

	alt	= tokens(st_local("alternatives"))
	nalt	= cols(alt)

	if (nalt == 0 | st_local("allalternatives") != "0") {
		altsel	= J(1,nval,1)
	}
	else {
		altsel	= J(1,nval,0)
	}

	for (i=1; i<=nalt; i++) {
		v = strtoreal(alt[i])
		if (missing(v)) {
			if (vl != "") {
				v = st_vlsearch(vl, alt[i])
			}
		}
		if (anyof(val, v)) {
			altsel[selectindex(val:==v)] = 1
		}
		else {
			v = .
		}
		if (missing(v)) {
			errprintf("alternative '{bf:%s}' not recognized\n",
				alt[i])
			exit(198)
		}
	}

	out	= tokens(st_local("outcomes"))
	nout	= cols(out)

	if (nout == 0 | st_local("alloutcomes") != "0") {
		outsel	= J(1,nval,1)
	}
	else {
		outsel	= J(1,nval,0)
	}

	for (i=1; i<=nout; i++) {
		v = strtoreal(out[i])
		if (missing(v)) {
			if (vl != "") {
				v = st_vlsearch(vl, out[i])
			}
		}
		if (anyof(val, v)) {
			outsel[selectindex(val:==v)] = 1
		}
		else {
			v = .
		}
		if (missing(v)) {
			errprintf("outcome '{bf:%s}' not recognized\n",
				out[i])
			exit(198)
		}
	}

	st_local("k", strofreal(nval))
	for (i=1; i<=nval; i++) {
		st_local(sprintf("altval%f",i), strofreal(val[i]))
		st_local(sprintf("altsel%f",i), strofreal(altsel[i]))
		st_local(sprintf("outsel%f",i), strofreal(outsel[i]))
	}
}

void _st_marg_save_double(string scalar ldbl)
{
	string	scalar	dbl
	real	matrix	T

	dbl = st_local(ldbl)
	if (dbl == "double") {
		return
	}

	T = st_matrix("r(table)")
	if (max(T) > c("maxfloat")) {
		st_local(ldbl, "double")
	}
}

void _st_marg_exp_token(
	string	scalar	ltok,
	string	scalar	lexp)
{
	string	vector	bad
	string	scalar	exp
	transmorphic	T
	transmorphic	B
	string	scalar	beq
	string	scalar	bname
	string	scalar	eq
	string	scalar	name
	string	scalar	peek
	string	scalar	tok
	real	scalar	pos

	bad = tokens("_se _B _SE _Z _P _LB _UB")
	exp = st_local(lexp)
	T = tokeninitstata()
	B = tokeninit(" ", "", "[]")

	beq = ""
	bname = ""
	eq = ""
	name = ""
	tokenset(T, exp)
	peek = tokenpeek(T)
	if (peek == "[") {
		tokenset(B, exp)
		beq = tokenget(B)
		exp = tokenrest(B)
		tokenset(T, exp)
	}
	tok = tokenget(T)
	if (anyof(bad, tok)) {
		errprintf("{p 0 0 2}\n")
		errprintf("system variable {bf:%s}", tok)
		errprintf(" not allowing in {bf:expression()}\n")
		errprintf("{p_end}\n")
		exit(198)
	}
	peek = tokenpeek(T)
	if (tok != "_b" | peek != "[") {
		tok = beq + tok
		exp = tokenrest(T)
		st_local(ltok, tok)
		st_local(lexp, exp)
		return
	}

	exp = tokenrest(T)
	tokenset(B, exp)
	bname = tokenget(B)
	exp = tokenrest(B)
	_path__rmbracket(name=bname)
	if (beq != "") {
		_path__rmbracket(eq=beq)
	}
	pos = st_matrixcolnumb("e(b)", (eq, name))
	if (pos != .) {
		tok = sprintf("e(b)[1,%f]",pos)
	}
	else {
		tok = sprintf("%s%s%s", beq, tok, bname)
	}

	st_local(ltok, tok)
	st_local(lexp, exp)
}

end
