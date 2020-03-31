*! version 1.0.7  12jul2017
version 10

findfile deriv_include.mata
quietly include `"`r(fn)'"'

local i1 "{col 5}"
local i2 "{col 10}"
local i3 "{col 15}"
local c2 "{col 46}"

mata:

struct deriv__struct {
	// user specified items
	pointer(function)	scalar		user
	pointer(function)	scalar		user_h
	pointer(function)	scalar		user_neq
	pointer(function)	scalar		user_vecsum
	pointer(function)	scalar		user_matsum
	pointer(function)	scalar		user_setdelta
	pointer(function)	scalar		user_setup1
	pointer(function)	scalar		user_setup2
	real			scalar		evaltype
	pointer(real rowvector)	scalar		params
	real			scalar		search
	real			scalar		verbose
	real			scalar		weak_goals
	real			rowvector	goals
	pointer(real colvector)	scalar		weights
	// user defined arguments
	real			scalar		nargs
	pointer			rowvector	arglist
	// results
	real			scalar		value
	real			colvector	value_v
	real			rowvector	value_t
	real			rowvector	gradient
	real			matrix		gradient_v
	real			matrix		Jacobian
	real			rowvector	Hessian
	// internal items
	pointer(function)	scalar		calluser
	pointer(function)	scalar		calluser_h
	pointer(function)	scalar		calluser_neq
	pointer(function)	scalar		calluser_vecsum
	pointer(function)	scalar		calluser_matsum
	pointer(function)	scalar		calluser_setdelta
	pointer(function)	scalar		calluser_setup1
	pointer(function)	scalar		calluser_setup2
	real			scalar		valid
	real			scalar		pdim
	real			scalar		vdim
	real			rowvector	h0
	real			matrix		scale0
	real			rowvector	h
	real			matrix		scale
	real			scalar		flat
	real			scalar		h_hold
	real			scalar		ucall
	real			scalar		errorcode
	string			scalar		errortext
}

// initialization -----------------------------------------------------------

transmorphic scalar deriv_init()
{
	`DerivStruct'	D

	D.user		= NULL
	D.user_h	= NULL
	D.user_neq	= NULL
	D.user_setdelta	= NULL
	D.evaltype	= `DERIV_evaltype_d'
	D.params	= NULL
	D.h_hold	= `FALSE'
	D.search	= `DERIV_search_interpol'
	D.verbose	= `TRUE'
	D.weak_goals	= `FALSE'
	D.goals		= `DERIV_goals_default'
	D.weights	= NULL

	D.nargs		= `DERIV_nargs_default'
	D.arglist	= J(1,`DERIV_nargs_max',NULL)

	D.value		= .
	D.value_v	= J(0,1,.)
	D.value_t	= J(1,0,.)
	D.gradient	= J(1,0,.)
	D.gradient_v	= J(0,0,.)
	D.Jacobian	= J(0,0,.)
	D.Hessian	= J(0,0,.)

	D.calluser	= NULL
	D.valid		= `FALSE'
	D.pdim		= 0
	D.vdim		= 1
	D.h0		= `DERIV_h_default'
	D.scale0	= `DERIV_scale_default'
	D.h		= `DERIV_h_default'
	D.scale		= `DERIV_scale_default'
	D.ucall		= `FALSE'
	D.errorcode	= 0
	D.errortext	= ""

	return(D)
}

function deriv_init_evaluator(`DerivStruct' D,| pointer(function) scalar f)
{
	if (args() == 1) {
		return(D.user)
	}
	D.valid = `FALSE'
	D.user = f
}

function deriv_init_evaluatortype(`DerivStruct' D,| scalar evaltype)
{
	if (args() == 1) {
		return(deriv__evaltype_str(D))
	}
	D.valid	= `FALSE'
	D.flat	= `FALSE'
	if (isreal(evaltype)) {
		deriv__evaltype_num(D, evaltype)
	}
	else if (isstring(evaltype)) {
		deriv__evaltype_str(D, evaltype)
	}
	else {
		errprintf("invalid evaluator type\n")
		exit(3498)
	}
}

function deriv_init_params(`DerivStruct' D,| real rowvector p)
{
	if (args() == 1) {
		if (D.params == NULL) {
			return(J(1,0,.))
		}
		return(*D.params)
	}
	D.params = &p
	D.value = .
	D.value_t = .
}

function deriv_reset_params(`DerivStruct' D,| real rowvector p)
{
	D.params = &p
}

// user arguments -----------------------------------------------------------

function deriv_init_arguments_unlink(`DerivStruct' D)
{
	D.nargs		= 0
	D.arglist	= J(1,`DERIV_nargs_max',NULL)
	D.valid		= `FALSE'
}

function deriv_init_argument(`DerivStruct' D, real scalar i,| arg)
{
	deriv__check_nargs(i)
	if (args() == 2) {
		if (D.arglist[i] == NULL) {
			return(NULL)
		}
		return(D.arglist[i])
	}
	if (ispointer(arg) & arg == NULL) {
		D.arglist[i] = NULL
		return
	}
	D.valid = `FALSE'
	D.arglist[i] = &arg
	if (D.nargs<i) deriv_init_narguments(D, i)
}

function deriv_init_narguments(
	`DerivStruct'	D,
	|real	scalar	nargs
)
{
	if (args() == 1) {
		return(D.nargs)
	}
	if (nargs) {
		deriv__check_nargs(nargs)
	}
	D.valid = `FALSE'
	D.nargs	= nargs
}

function deriv_init_weights(`DerivStruct' D,| real colvector weights)
{
	if (args() == 1) {
		return(D.weights)
	}
	D.valid = `FALSE'
	if (length(weights)) {
		D.weights = &weights
	}
	else	D.weights = NULL
}

// advanced initialization routines -----------------------------------------

function deriv_init_h(`DerivStruct' D,| real rowvector h)
{
	if (args() == 1) {
		return(D.h0)
	}
	D.valid	= `FALSE'
	D.h	= `DERIV_h_default'
	if (missing(h)) {
		D.h0 = `DERIV_h_default'
	}
	else	D.h0 = h
	D.h_hold = `TRUE'
}

function deriv_init_scale(`DerivStruct' D,| real matrix scale)
{
	if (args() == 1) {
		return(D.scale0)
	}
	D.valid = `FALSE'
	D.scale = `DERIV_scale_default'
	if (missing(scale)) {
		D.scale0 = `DERIV_scale_default'
	}
	else	D.scale0 = scale
}

function deriv_init_bounds(`DerivStruct' D,| real rowvector goals)
{
	if (args() == 1) {
		return(D.goals)
	}

	real	scalar	c
	c = cols(goals)
	if (c != 2) {
		errprintf("invalid goals argument;\n")
		if (c < 2) {
			errprintf("too few columns\n")
		}
		else {
			errprintf("too many columns\n")
		}
		exit(3498)
	}
	if (min(goals) < 0) {
		errprintf("invalid goals argument;\n")
		errprintf("negative values not allowed\n")
		exit(3498)
	}
	if (missing(goals)) {
		D.goals	= `DERIV_goals_default'
	}
	else {
		D.goals[1]	= min(goals)
		D.goals[2]	= max(goals)
	}
}

function deriv_init_search(`DerivStruct' D,| scalar method)
{
	if (args() == 1) {
		return(deriv__search_str(D))
	}
	D.valid = `FALSE'
	if (isreal(method)) {
		deriv__search_num(D, method)
	}
	else if (isstring(method)) {
		deriv__search_str(D, method)
	}
	else {
		errprintf("invalid search method\n")
		exit(3498)
	}
}

function deriv_init_verbose(`DerivStruct' D,| scalar verbose)
{
	if (args() == 1) {
		return(deriv__verbose_str(D))
	}
	D.valid = `FALSE'
	if (isreal(verbose)) {
		deriv__verbose_num(D, verbose)
	}
	else if (isstring(verbose)) {
		deriv__verbose_str(D, verbose)
	}
	else {
		errprintf("invalid verbose setting\n")
		exit(3498)
	}
}

function deriv_init_weak_goals(`DerivStruct' D,| scalar weak_goals)
{
	if (args() == 1) {
		return(deriv__weak_goals_str(D))
	}
	if (isreal(weak_goals)) {
		deriv__weak_goals_num(D, weak_goals)
	}
	else if (isstring(weak_goals)) {
		deriv__weak_goals_str(D, weak_goals)
	}
	else {
		errprintf("invalid setting for weak goals\n")
		exit(3498)
	}
}

// user function calls ------------------------------------------------------

function deriv_init_user_h(`DerivStruct' D,| pointer(function) scalar f)
{
	if (args() == 1) {
		return(D.user_h)
	}
	D.valid = `FALSE'
	D.user_h = f
}

function deriv_init_user_neq(`DerivStruct' D,| pointer(function) scalar f)
{
	if (args() == 1) {
		return(D.user_neq)
	}
	D.valid = `FALSE'
	D.user_neq = f
}

function deriv_init_user_vecsum(`DerivStruct' D,| pointer(function) scalar f)
{
	if (args() == 1) {
		return(D.user_vecsum)
	}
	D.valid = `FALSE'
	D.user_vecsum = f
}

function deriv_init_user_matsum(`DerivStruct' D,| pointer(function) scalar f)
{
	if (args() == 1) {
		return(D.user_matsum)
	}
	D.valid = `FALSE'
	D.user_matsum = f
}

function deriv_init_user_setdelta(`DerivStruct' D,| pointer(function) scalar f)
{
	if (args() == 1) {
		return(D.user_setdelta)
	}
	D.valid = `FALSE'
	D.user_setdelta = f
}

function deriv_init_user_setup1(`DerivStruct' D,| pointer(function) scalar f)
{
	if (args() == 1) {
		return(D.user_setup1)
	}
	D.valid = `FALSE'
	D.user_setup1 = f
}

function deriv_init_user_setup2(`DerivStruct' D,| pointer(function) scalar f)
{
	if (args() == 1) {
		return(D.user_setup2)
	}
	D.valid = `FALSE'
	D.user_setup2 = f
}

// query --------------------------------------------------------------------

function deriv_query(`DerivStruct' D)
{
	real	scalar	i, n
	real	scalar	needeval, needparams
	string	scalar	name

	printf("{text}Settings for deriv() {hline}\n\n")

	printf("\nEvaluator\n")
	name = nameexternal(D.user)
	needeval = name == ""
	if (needeval) {
		printf("`i1'Function:`c2'{error:unknown}\n")
	}
	else {
		printf("`i1'Function:`c2'{result:%s}\n", name)
	}
	printf("`i1'Type:`c2'{result:%s}\n", deriv_init_evaluatortype(D))

	n = deriv_init_narguments(D)
	if (n == 0) {
		printf("\nUser-defined arguments:`c2'<none>\n")
	}
	else if (n == 1) {
		name = nameexternal(D.arglist[1])
		if (name == "") {
			printf("\nUser-defined argument:`c2'<tmp>\n")
		}
		else {
			printf("\nUser-defined argument:`c2'{result:%s}\n",
				name)
		}
	}
	else {
		printf("\nUser-defined arguments\n")
		for(i=1; i<=n; i++) {
			name = nameexternal(D.arglist[i])
			if (name != "") {
				printf("`i1'%5.0f:`c2'{result:%s}\n",
					i, name)
			}
			else {
				printf("`i1'%5.0f:`c2'<tmp>\n",
					i)
			}
		}
	}

	if (D.evaltype == `DERIV_evaltype_v') {
		if (D.weights == NULL) {
			printf("\nWeights:`c2'<none>\n")
		}
		else {
			name = nameexternal(D.weights)
			if (name == "") {
				printf("\nWeights:`c2'<tmp>\n")
			}
			else {
				printf("\nWeights:`c2'{result:%s}\n", name)
			}
		}
	}

	printf("\nSearch method:`c2'{result:%s}\n",
		deriv_init_search(D))

	printf("\nInitial status\n")
	if (D.params != NULL) {
		n = cols(*D.params)
	}
	else	n = 0
	needparams = n == 0
	if (n==0) {
		printf("`i1'Parameter values:`c2'{error:<unknown>}\n")
	}
	else if (n==1) {
		printf("`i1'Parameter value:`c2'{result:%g}\n",
			(*D.params)[1])
	}
	else {
		printf("`i1'Parameter values\n")
		for (i=1; i<=n; i++) {
			printf("`i1'%5.0f:`c2'{result:%g}\n",
				i, (*D.params)[i])
		}
	}
	if (!D.h_hold) {
		deriv__query_mat(J(0,0,.), "{it:h}", "<default>")
	}
	else {
		deriv__query_mat(D.h0, "{it:h}", "<default>")
	}
	if (D.scale0 == `DERIV_scale0_default') {
		deriv__query_mat(J(0,0,.), "scale", "<default>")
	}
	else {
		deriv__query_mat(D.scale0, "scale", "<default>")
	}

	printf("\nCurrent status\n")
	if (D.evaltype == `DERIV_evaltype_t') {
		deriv__query_mat(D.value_t, "Function", "{result:.}")
	}
	else {
		printf("`i1'Function value:`c2'{result:%g}\n",
			deriv_result_value(D))
	}
	deriv__query_mat(D.h, "{it:h}", "{result:.}")
	deriv__query_mat(D.scale, "scale", "{result:.}")

	if (needeval) {
	    printf("\nNote:  The evaluator function has not been specified.")
	}
	if (needparams) {
	    printf("\nNote:  Parameter values have not been specified.")
	}
	if (needeval | needparams) {
		printf("\n")
	}
	displayflush()
}

void deriv__query_mat(
	real	matrix	X,
	string	scalar	name,
	string	scalar	dflt
)
{
	real	scalar	n, m, i, j

	n	= cols(X)
	if (n == 0 | missing(X)) {
		printf("`i1'%s values:`c2'%s\n", name, dflt)
		return
	}
	m	= rows(X)
	if (n==1 & m==1) {
		printf("`i1'%s value:`c2'{result:%g}\n", name, X)
		return
	}
	printf("`i1'%s values\n", name)
	if (m==1) {
		for (i=1; i<=n; i++) {
			printf("`i1'%5.0f:`c2'{result:%g}\n",
				i, X[i])
		}
		return
	}
	for (i=1; i<=m; i++) {
		for (j=1; j<=n; j++) {
			printf("`i1'%5.0f,%5.0f:`c2'{result:%g}\n",
				i, j, X[i,j])
		}
	}
}

// computation --------------------------------------------------------------

real matrix deriv(`DerivStruct' D, real scalar todo)
{
	D.ucall = 0

	if (todo < 0 | todo > 2 | todo != trunc(todo)) {
		D.errorcode = `Errcode_invalid_todo'
		D.errortext = `Errtext_invalid_todo'
		deriv__errorhandler(D)
		return(D.errorcode)
	}
	if (!D.valid) {
		(void) _deriv__validate(D)
	}
	else {
		(void) _deriv__init(D)
	}
	if (todo == 0) {
		if (D.evaltype == `DERIV_evaltype_t') {
			(void) _deriv__compute_Jacobian(D)
			return(D.value_t)
		}
		(void) _deriv__compute_value(D)
		return(D.value)
	}
	if (todo == 1) {
		if (D.evaltype == `DERIV_evaltype_t') {
			(void) _deriv__compute_Jacobian(D)
			return(D.Jacobian)
		}
		(void) _deriv__compute_gradient(D)
		return(D.gradient)
	}
	(void) _deriv__compute_Hessian(D)
	return(D.Hessian)
}

real scalar _deriv(`DerivStruct' D, real scalar todo)
{
	`Errcode'	ec

	D.ucall = 1
	if (todo < 0 | todo > 2 | todo != trunc(todo)) {
		D.errorcode = `Errcode_invalid_todo'
		D.errortext = `Errtext_invalid_todo'
		deriv__errorhandler(D)
		return(D.errorcode)
	}
	if (!D.valid) {
		ec = _deriv__validate(D)
		if (ec) return(ec)
	}
	else {
		ec = _deriv__init(D)
		if (ec) return(ec)
	}
	if (todo == 0) {
		return(_deriv__compute_value(D))
	}
	if (todo == 1) {
		if (D.evaltype == `DERIV_evaltype_t') {
			return(_deriv__compute_Jacobian(D))
		}
		return(_deriv__compute_gradient(D))
	}
	if (D.evaltype == `DERIV_evaltype_t') {
		D.errorcode = `Errcode_Hessian_t'
		D.errortext = `Errtext_Hessian_t'
		deriv__errorhandler(D)
		return(D.errorcode)
	}
	return(_deriv__compute_Hessian(D))
}

// results ------------------------------------------------------------------

real scalar deriv_result_value(`DerivStruct' D)
{
	return(D.value)
}

real matrix deriv_result_values(`DerivStruct' D)
{
	if (D.evaltype == `DERIV_evaltype_t') {
		return(D.value_t)
	}
	return(D.value_v)
}

void _deriv_result_values(`DerivStruct' D, real colvector values)
{
	if (D.evaltype == `DERIV_evaltype_t') {
		swap(D.value_t, values)
	}
	else {
		swap(D.value_v, values)
	}
}

real matrix deriv_result_gradient(`DerivStruct' D)
{
	if (missing(D.value) | D.evaltype == `DERIV_evaltype_t') {
		return(J(1,D.pdim,.))
	}
	return(D.gradient)
}

void _deriv_result_gradient(`DerivStruct' D, g)
{
	if (missing(D.value) | D.evaltype == `DERIV_evaltype_t') {
		g = J(1,D.pdim,.)
	}
	else	swap(D.gradient, g)
}

real matrix deriv_result_scores(`DerivStruct' D)
{
	if (D.evaltype != `DERIV_evaltype_v') {
		return(J(0,0,.))
	}
	return(D.gradient_v)
}

void _deriv_result_scores(`DerivStruct' D, S)
{
	if (D.evaltype != `DERIV_evaltype_v') {
		S =J(0,0,.)
	}
	else	swap(D.gradient_v, S)
}

real matrix deriv_result_Jacobian(`DerivStruct' D)
{
	if (missing(D.value_t) | D.evaltype != `DERIV_evaltype_t') {
		return(J(D.vdim,D.pdim,.))
	}
	return(D.Jacobian)
}

void _deriv_result_Jacobian(`DerivStruct' D, J)
{
	if (missing(D.value_t) | D.evaltype != `DERIV_evaltype_t') {
		J = J(D.vdim,D.pdim,.)
	}
	else	swap(D.Jacobian, J)
}

real matrix deriv_result_Hessian(`DerivStruct' D)
{
	if (missing(D.value) | D.evaltype == `DERIV_evaltype_t') {
		return(J(D.pdim,D.pdim,.))
	}
	return(D.Hessian)
}

void _deriv_result_Hessian(`DerivStruct' D, H)
{
	if (missing(D.value) | D.evaltype == `DERIV_evaltype_t') {
		H = J(D.pdim,D.pdim,.)
	}
	else	swap(D.Hessian, H)
}

real rowvector deriv_result_h(`DerivStruct' D)
{
	return(D.h)
}

real matrix deriv_result_scale(`DerivStruct' D)
{
	return(D.scale)
}

real matrix deriv_result_delta(`DerivStruct' D)
{
	return(floatround(D.h:*D.scale))
}

`Errcode' deriv_result_errorcode(`DerivStruct' D)
{
	return(D.errorcode)
}

string scalar deriv_result_errortext(`DerivStruct' D)
{
	return(D.errortext)
}

real scalar deriv_result_returncode(`DerivStruct' D)
{
	if (D.errorcode) {
		if (D.errorcode == `Errcode_invalid_todo') {
			return(198)
		}
		if (D.errorcode == `Errcode_no_user') {
			return(111)
		}
		if (D.errorcode == `Errcode_no_calluser') {
			return(111)
		}
		return(459)
	}
	return(0)
}

// utilities ----------------------------------------------------------------

/*STATIC*/ void deriv__check_nargs(real scalar i)
{
	if (i<1 | i>`DERIV_nargs_max' | i != trunc(i)) {
		errprintf("invalid argument index\n")
		exit(3498)
	}
}

/*STATIC*/ `Errcode' _deriv__compute_value(`DerivStruct' D)
{
	if (D.evaltype == `DERIV_evaltype_t') {
		(*D.calluser)(D,*D.params,0,0,0,D.value,D.value_t)
		if (D.vdim != cols(D.value_t)) {
			D.vdim	= cols(D.value_t)
			if (rows(D.scale0) != D.vdim) {
				D.scale = D.scale0 = `DERIV_scale0_default'
			}
		}
		if (D.ucall == 0 & missing(D.value_t)) {
			D.errorcode = `Errcode_missing'
			D.errortext = `Errtext_missing'
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}
	else {
		(*D.calluser)(D,*D.params,0,0,0,D.value,D.value_v)

		if (D.ucall == 0 & missing(D.value)) {
			D.errorcode = `Errcode_missing'
			D.errortext = `Errtext_missing'
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}

	return(0)
}

/*STATIC*/ `Errcode' _deriv__compute_gradient(`DerivStruct' D)
{
	`Errcode'	ec
	real scalar	neq, pdim, i
	real scalar	fp
	real scalar	fm
	real scalar	hi
	real colvector	fpv, fmv, score
	pragma unset fp
	pragma unset fm
	pragma unset hi
	pragma unset fpv
	pragma unset fmv

	if (D.evaltype == `DERIV_evaltype_t') {
		if (missing(D.value_t)) {
			ec = _deriv__compute_value(D)
			if (ec) return(ec)
		}
	}
	else {
		if (missing(D.value)) {
			ec = _deriv__compute_value(D)
			if (ec) return(ec)
		}
	}
	pdim	= D.pdim

	if (D.evaltype == `DERIV_evaltype_d') {		// 'd' type
		D.gradient = `DERIV_h_default'
		for (i=1; i<=pdim; i++) {
			ec = _deriv__h(D,1,i,hi,fp,fm,.,.)
			if (ec) return(ec)
			if (hi) {
				D.gradient[i] = (fp - fm)/(2*hi)
			}
			else {
				D.gradient[i] = 0
			}
		}
	}
	else if (D.user_vecsum == NULL) {		// 'v' type
		D.gradient = `DERIV_h_default'
		neq	= deriv__neq(D)
		D.gradient_v = J(rows(D.value_v), neq,.)
		for (i=1; i<=neq; i++) {
			ec = _deriv__h(D,1,i,hi,.,.,fpv,fmv)
			if (ec) return(ec)
			if (hi) {
				D.gradient_v[,i] = (fpv - fmv)/(2*hi)
			}
			else {
				D.gradient_v[,i] = J(rows(D.value_v), 1, 0)
			}
		}
		if (D.weights == NULL) {
			D.gradient = quadcolsum(D.gradient_v)
		}
		else {
			D.gradient = quadcross(*D.weights, D.gradient_v)
		}
	}
	else {						// 'lf' type
		neq	= deriv__neq(D)
		D.gradient_v = J(rows(D.value_v), neq,.)
		for (i=1; i<=neq; i++) {
			ec = _deriv__h(D,1,i,hi,.,.,fpv,fmv)
			if (ec) return(ec)
			if (hi) {
				score = (fpv - fmv)/(2*hi)
				deriv__vecsum(D,i,score,D.gradient)
			}
			else {
				score = J(rows(D.value_v), 1, 0)
				D.gradient[i] = 0
			}
			D.gradient_v[,i] = score
		}
	}
	return(0)
}

/*STATIC*/ `Errcode' _deriv__compute_Jacobian(`DerivStruct' D)
{
	`Errcode'	ec
	real scalar	pdim, i
	real scalar	vdim, k
	real scalar	fp
	real scalar	fm
	real scalar	hi
	pragma unset fp
	pragma unset fm
	pragma unset hi

	if (missing(D.value_t)) {
		ec = _deriv__compute_value(D)
		if (ec) return(ec)
	}
	pdim	= D.pdim
	vdim	= D.vdim

	D.Jacobian = J(vdim,pdim,0)
	for (k=1; k<=vdim; k++) {
		for (i=1; i<=pdim; i++) {
			ec = _deriv__h(D,k,i,hi,fp,fm,.,.)
			if (ec) return(ec)
			if (hi) {
				D.Jacobian[k,i] = (fp - fm)/(2*hi)
			}
		}
	}
	return(0)
}

/*STATIC*/ `Errcode' _deriv__compute_Hessian(`DerivStruct' D)
{
	`Errcode'	ec
	real scalar	neq, pdim, i, j
	real scalar	fp, fpp
	real scalar	fm, fmm
	real scalar	hi
	real rowvector	p_alt, h, fph, fmh	
	real scalar	v0
	real colvector	score
	real colvector	fpv, fppv
	real colvector	fmv, fmmv
	real rowvector	grad
	real matrix	grad_v, fphv, fmhv
	real matrix	Hess
	pragma unset fp
	pragma unset fm
	pragma unset fpp
	pragma unset fppv
	pragma unset fmm
	pragma unset fmmv
	pragma unset hi
	pragma unset fpv
	pragma unset fmv

	if (missing(D.value)) {
		ec = _deriv__compute_value(D)
		if (ec) return(ec)
	}

	pdim	= D.pdim
	h	= `DERIV_h_default'
	fph	= `DERIV_h_default'
	fmh	= `DERIV_h_default'
	v0	= D.value
	grad	= `DERIV_h_default'
	Hess	= J(pdim,pdim,.)

	if (! D.evaltype) {			// 'd' type
		for (i=1; i<=pdim; i++) {
			if (D.user_setup1 != NULL) {
				(*D.calluser_setup1)(D,i)
			}

			ec = _deriv__h(D,1,i,hi,fp,fm,.,.)
			if (ec) return(ec)
			h[i]	= hi
			grad[i]	= (fp - fm)/(2*hi)
			fph[i]	= fp
			fmh[i]	= fm

			// diagonal element of the Hessian matrix
			Hess[i,i] = (fp - 2*v0 + fm)/(hi^2)

			// off diagonal elements of the Hessian matrix
			for (j=1; j<i; j++) {
				if (D.user_setup2 != NULL) {
					(*D.calluser_setup2)(D,i,j)
				}

				p_alt    = *D.params
				deriv__setdelta(D,i,hi,p_alt)
				deriv__setdelta(D,j,h[j],p_alt)
				(*D.calluser)(D,p_alt,0,0,0,fpp,.)
				deriv__setdelta(D,i,.,p_alt)
				deriv__setdelta(D,j,.,p_alt)

				deriv__setdelta(D,i,-hi,p_alt)
				deriv__setdelta(D,j,-h[j],p_alt)
				(*D.calluser)(D,p_alt,0,0,0,fmm,.)
				deriv__setdelta(D,i,.,p_alt)
				deriv__setdelta(D,j,.,p_alt)

				Hess[i,j] = (fpp + fmm + 2*v0 - fp
					- fm - fph[j] - fmh[j]) / (2*hi*h[j])
				Hess[j,i] = Hess[i,j]
			}
		}
	}
	else if (D.user_vecsum == NULL) {	// 'v' type
		grad_v = J(rows(D.value_v), pdim, .)
		for (i=1; i<=pdim; i++) {
			if (D.user_setup1 != NULL) {
				(*D.calluser_setup1)(D,i)
			}

			ec = _deriv__h(D,1,i,hi,fm,fp,fpv,fmv)
			if (ec) return(ec)
			h[i]	= hi
			score	= (fpv - fmv)/(2*hi)
			deriv__vecsum(D,i,score,grad)
			grad_v[,i] = score
			fmh[i]	= fm
			fph[i]	= fp

			// diagonal element of the Hessian matrix
			Hess[i,i] = (fp - 2*v0 + fm)/(hi^2)

			// off diagonal elements of the Hessian matrix
			for (j=1; j<i; j++) {
				if (D.user_setup2 != NULL) {
					(*D.calluser_setup2)(D,i,j)
				}

				p_alt	= *D.params
				deriv__setdelta(D,i,hi,p_alt)
				deriv__setdelta(D,j,h[j],p_alt)
				(*D.calluser)(D,p_alt,0,0,0,fpp,.)
				deriv__setdelta(D,i,.,p_alt)
				deriv__setdelta(D,j,.,p_alt)

				deriv__setdelta(D,i,-hi,p_alt)
				deriv__setdelta(D,j,-h[j],p_alt)
				(*D.calluser)(D,p_alt,0,0,0,fmm,.)
				deriv__setdelta(D,i,.,p_alt)
				deriv__setdelta(D,j,.,p_alt)

				Hess[i,j] = (fpp + fmm + 2*v0 - fp
					- fm - fph[j] - fmh[j]) / (2*hi*h[j])
				Hess[j,i] = Hess[i,j]
			}
		}
		swap(D.gradient_v, grad_v)
	}
	else {					// 'lf' type
		if (D.user_matsum == NULL) {
			D.errorcode = `Errcode_no_user'
			D.errortext = ///
"Hessian calculation requires a matsum evaluator when a vecsum evaluator is specified"
			deriv__errorhandler(D)
			return(D.errorcode)
		}
		neq	= deriv__neq(D)
		grad_v	= J(rows(D.value_v), neq, .)
		fmhv	= J(rows(D.value_v), neq, .)
		fphv	= J(rows(D.value_v), neq, .)
		for (i=1; i<=neq; i++) {
			if (D.user_setup1 != NULL) {
				(*D.calluser_setup1)(D,i)
			}

			ec = _deriv__h(D,1,i,hi,fm,fp,fpv,fmv)
			if (ec) return(ec)
			h[i]	= hi
			score	= (fpv - fmv)/(2*hi)
			deriv__vecsum(D,i,score,grad)
			grad_v[,i] = score
			fmhv[,i]   = fmv
			fphv[,i]   = fpv

			// diagonal element of the Hessian matrix
			score = (fpv - 2*D.value_v + fmv)/(hi^2)
			deriv__matsum(D,i,i,score,Hess)

			// off diagonal elements of the Hessian matrix
			for (j=1; j<i; j++) {
				if (D.user_setup2 != NULL) {
					(*D.calluser_setup2)(D,i,j)
				}

				p_alt	= *D.params

				deriv__setdelta(D,i,hi,p_alt)
				deriv__setdelta(D,j,h[j],p_alt)
				(*D.calluser)(D,p_alt,0,0,0,.,fppv)
				deriv__setdelta(D,i,.,p_alt)
				deriv__setdelta(D,j,.,p_alt)

				deriv__setdelta(D,i,-hi,p_alt)
				deriv__setdelta(D,j,-h[j],p_alt)
				(*D.calluser)(D,p_alt,0,0,0,.,fmmv)
				deriv__setdelta(D,i,.,p_alt)
				deriv__setdelta(D,j,.,p_alt)

				score = (fppv + fmmv + 2*D.value_v - fpv
					- fmv - fphv[,j] - fmhv[,j]) /
					  (2*hi*h[j])
				deriv__matsum(D,i,j,score,Hess)
			}
		}
		swap(D.gradient_v, grad_v)
	}
	swap(D.gradient, grad)
	swap(D.Hessian, Hess)
	return(0)
}

/*STATIC*/ void deriv__errorhandler(`DerivStruct' D)
{
	if (!D.errorcode) return
	if (D.verbose) {
		errprintf("{p}\n")
		errprintf("%s\n", D.errortext)
		errprintf("{p_end}\n")
	}
	if (D.ucall) return
	exit(deriv_result_returncode(D))
}

/*STATIC*/ function deriv__evaltype_str(`DerivStruct' D,| string scalar evaltype)
{
	if (args() == 1) {
		if (D.evaltype == `DERIV_evaltype_d') {
			return("d")
		}
		return("v")
	}
	if (evaltype == "d") {
		D.evaltype = `DERIV_evaltype_d'
	}
	else if (evaltype == "dt") {
		D.evaltype = `DERIV_evaltype_d'
		D.flat	= `TRUE'
	}
	else if (evaltype == "v") {
		D.evaltype = `DERIV_evaltype_v'
	}
	else if (evaltype == "t") {
		D.evaltype = `DERIV_evaltype_t'
		D.flat	= `TRUE'
	}
	else if (evaltype == "vt") {
		D.evaltype = `DERIV_evaltype_v'
		D.flat	= `TRUE'
	}
	else {
		errprintf("invalid evaluator type\n")
		exit(3498)
	}
}

/*STATIC*/ function deriv__evaltype_num(`DerivStruct' D,| real scalar evaltype)
{
	if (args() == 1) {
		return(D.evaltype)
	}
	if (evaltype == `DERIV_evaltype_d') {
		D.evaltype = evaltype
	}
	else if (evaltype == `DERIV_evaltype_v') {
		D.evaltype = evaltype
	}
	else {
		errprintf("invalid evaluator type\n")
		exit(3498)
	}
}

/*STATIC*/ function deriv__search_str(
	`DerivStruct'	D,
	| string scalar	search
)
{
	if (args() == 1) {
		if (D.search == `DERIV_search_off') {
			return("off")
		}
		if (D.search == `DERIV_search_interpol') {
			return("interpolate")
		}
		return("bracket")
	}
	if (search == "off") {
		D.search = `DERIV_search_off'
	}
	else if (search == "interpolate") {
		D.search = `DERIV_search_interpol'
	}
	else if (search == "bracket") {
		D.search = `DERIV_search_bracket'
	}
	else {
		errprintf("invalid search method\n")
		exit(3498)
	}
}

/*STATIC*/ function deriv__search_num(
	`DerivStruct'	D,
	| real scalar	search
)
{
	if (args() == 1) {
		return(D.search)
	}
	if (search == `DERIV_search_off') {
		D.search = search
	}
	else if (search == `DERIV_search_interpol') {
		D.search = search
	}
	else if (search == `DERIV_search_bracket') {
		D.search = search
	}
	else {
		errprintf("invalid search method\n")
		exit(3498)
	}
}

/*STATIC*/ void deriv__sum(`DerivStruct' D, real matrix v_v, real matrix v)
{
	if (missing(v_v)) {
		v = .
	}
	else if (D.weights == NULL) {
		v = quadcolsum(v_v)
	}
	else {
		v = quadcross(*D.weights,v_v)
	}
}

/*STATIC*/ real scalar deriv__neq(`DerivStruct' D)
{
	if (D.calluser_neq == NULL) {
		return(D.pdim)
	}
	return((*D.calluser_neq)(D))
}

/*STATIC*/ void deriv__setdelta(
	`DerivStruct'	D,
	real	scalar	i,
	real	scalar	h,
	real	matrix	p
)
{
	if (D.calluser_setdelta == NULL) {
		if (i) {
			if (missing(h)) {
				p[i] = (*D.params)[i]
			}
			else {
				p[i] = (*D.params)[i] + floatround(h)
			}
		}
	}
	else {
		if (i) {
			(*D.calluser_setdelta)(D,i,floatround(h))
		}
	}
}

/*STATIC*/ void deriv__vecsum(
	`DerivStruct'	D,
	real scalar	i,
	real matrix	score,
	real rowvector	g
)
{
	if (D.calluser_vecsum == NULL) {
		if (D.weights == NULL) {
			g[i] = quadcolsum(score)
		}
		else {
			g[i] = quadcross(*D.weights,score)
		}
	}
	else {
		(*D.calluser_vecsum)(D,i,score,g)
	}
}

/*STATIC*/ void deriv__matsum(
	`DerivStruct'	D,
	real scalar	i,
	real scalar	j,
	real colvector	score,
	real matrix	H
)
{
	if (D.calluser_matsum == NULL) {
		H[j,i] = H[i,j] = score
	}
	else {
		(*D.calluser_matsum)(D,i,j,score,H)
	}
}

/*STATIC*/ `Errcode' _deriv__init(`DerivStruct' D)
{
	if (D.params == NULL) {
		D.errorcode = `Errcode_no_params'
		D.errortext = `Errtext_no_params'
		deriv__errorhandler(D)
		return(D.errorcode)
	}
	D.pdim = cols(*D.params)
	if (D.pdim == 0) {
		D.errorcode = `Errcode_no_params'
		D.errortext = `Errtext_no_params'
		deriv__errorhandler(D)
		return(D.errorcode)
	}

	D.gradient = `DERIV_h_default'

	if (cols(D.scale0) != D.pdim | missing(D.scale0)) {
		D.scale = D.scale0 = `DERIV_scale0_default'
	}

	if (cols(D.h0) != D.pdim | missing(D.h0)) {
		D.h = D.h0 = `DERIV_h0_default'
		D.h_hold = `FALSE'
	}

	return(0)
}

/*STATIC*/ `Errcode' _deriv__validate(`DerivStruct' D)
{
	`Errcode'	ec
	string scalar	name

	D.valid = `FALSE'

	ec = _deriv__init(D)
	if (ec) return(ec)

	if (cols(D.scale) != D.pdim) {
		D.scale = D.scale0
	}
	if (cols(D.h) != D.pdim) {
		D.h = D.h0
	}

	if (D.user == NULL) {
		D.errorcode = `Errcode_no_user'
		D.errortext = `Errtext_no_user'
		deriv__errorhandler(D)
		return(D.errorcode)
	}

	if (D.evaltype == `DERIV_evaltype_d') {
		name = sprintf("deriv__call%fuser_d()", D.nargs)
		D.calluser = findexternal(name)
	}
	else if (D.evaltype == `DERIV_evaltype_v') {
		name = sprintf("deriv__call%fuser_v()", D.nargs)
		D.calluser = findexternal(name)
	}
	else {
		name = sprintf("deriv__call%fuser_t()", D.nargs)
		D.calluser = findexternal(name)
	}
	if (D.calluser == NULL) {
		D.errorcode = `Errcode_no_calluser'
		D.errortext = sprintf("%s not found", name)
		deriv__errorhandler(D)
		return(D.errorcode)
	}

	if (D.user_h != NULL) {
		name = sprintf("deriv__call%fuser_h()", D.nargs)
		D.calluser_h = findexternal(name)
		if (D.calluser_h == NULL) {
			D.errorcode = `Errcode_no_calluser'
			D.errortext = sprintf("%s not found", name)
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}

	if (D.user_neq != NULL) {
		name = sprintf("deriv__call%fuser_neq()", D.nargs)
		D.calluser_neq = findexternal(name)
		if (D.calluser_neq == NULL) {
			D.errorcode = `Errcode_no_calluser'
			D.errortext = sprintf("%s not found", name)
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}

	if (D.user_vecsum != NULL) {
		name = sprintf("deriv__call%fuser_vecsum()", D.nargs)
		D.calluser_vecsum = findexternal(name)
		if (D.calluser_vecsum == NULL) {
			D.errorcode = `Errcode_no_calluser'
			D.errortext = sprintf("%s not found", name)
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}

	if (D.user_matsum != NULL) {
		name = sprintf("deriv__call%fuser_matsum()", D.nargs)
		D.calluser_matsum = findexternal(name)
		if (D.calluser_matsum == NULL) {
			D.errorcode = `Errcode_no_calluser'
			D.errortext = sprintf("%s not found", name)
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}

	if (D.user_setdelta != NULL) {
		name = sprintf("deriv__call%fuser_setdelta()", D.nargs)
		D.calluser_setdelta = findexternal(name)
		if (D.calluser_setdelta == NULL) {
			D.errorcode = `Errcode_no_calluser'
			D.errortext = sprintf("%s not found", name)
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}

	if (D.user_setup1 != NULL) {
		name = sprintf("deriv__call%fuser_setup1()", D.nargs)
		D.calluser_setup1 = findexternal(name)
		if (D.calluser_setup1 == NULL) {
			D.errorcode = `Errcode_no_calluser'
			D.errortext = sprintf("%s not found", name)
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}

	if (D.user_setup2 != NULL) {
		name = sprintf("deriv__call%fuser_setup2()", D.nargs)
		D.calluser_setup2 = findexternal(name)
		if (D.calluser_setup2 == NULL) {
			D.errorcode = `Errcode_no_calluser'
			D.errortext = sprintf("%s not found", name)
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}

	D.valid = `TRUE'

	return(0)
}

/*STATIC*/ function deriv__verbose_str(`DerivStruct' D,| string scalar verbose)
{
	if (args() == 1) {
		if (D.verbose) {
			return("on")
		}
		return("off")
	}
	if (verbose == "on") {
		D.verbose = `TRUE'
	}
	else if (verbose == "off") {
		D.verbose = `FALSE'
	}
	else {
		errprintf("invalid verbose setting\n")
		exit(3498)
	}
}

/*STATIC*/ function deriv__verbose_num(`DerivStruct' D,| real scalar verbose)
{
	if (args() == 1) {
		return(D.verbose)
	}
	if (verbose < 0 | verbose > 1 | verbose != trunc(verbose)) {
		errprintf("invalid verbose setting\n")
		exit(3498)
	}
	D.verbose = verbose
}

/*STATIC*/ function deriv__weak_goals_str(
	`DerivStruct'	D,
	| string scalar	weak_goals
)
{
	if (args() == 1) {
		if (D.weak_goals) {
			return("on")
		}
		return("off")
	}
	if (weak_goals == "on") {
		D.weak_goals = `TRUE'
	}
	else if (weak_goals == "off") {
		D.weak_goals = `FALSE'
	}
	else {
		errprintf("invalid setting for weak goals\n")
		exit(3498)
	}
}

/*STATIC*/ function deriv__weak_goals_num(`DerivStruct' D,| real scalar weak_goals)
{
	if (args() == 1) {
		return(D.weak_goals)
	}
	if (weak_goals < 0 | weak_goals > 1 | weak_goals != trunc(weak_goals)) {
		errprintf("invalid setting for holding the scale\n")
		exit(3498)
	}
	D.weak_goals = weak_goals
}

// subroutines for finding the scale for taking numerical derivatives -------

/*STATIC*/ `Errcode' _deriv__h_2(
	`DerivStruct'	D,
	real scalar	k,
	real scalar	i,
	real scalar	h,
	real scalar	scale,
	real scalar	fph,			// f(x+h)
	real scalar	fmh,			// f(x-h)
	real vector	fph_v,			// f(x+h) vectorized
	real vector	fmh_v			// f(x-h) vectorized
)
{
	real scalar	goal0, goal1, mgoal, mingoal, iter, itmax
	real scalar	newscale, scale1, scale2, bestscale
	real scalar	dv, dv1, dv2, bestdv
	real rowvector	p_alt

	goal0	= D.goals[1]
	goal1	= D.goals[2]
	mingoal	= min((goal0*1e-4, 1e-12))
	itmax	= 40

	goal0	= (abs(D.value)+goal0)*goal0
	goal1	= (abs(D.value)+goal1)*goal1
	mgoal	= (goal0+goal1)/2
	mingoal	= (abs(D.value)+mingoal)*mingoal

	// always start off with the original parameter values
	p_alt	= *D.params

	dv	= (abs(D.value - fph) + abs(D.value - fmh))/2
	bestdv	= dv
	bestscale	= scale
	scale1	= 0
	dv1	= 0
	// use interpolation to get the scaled delta to within our goals
	for (iter=1; iter<=itmax & (dv<goal0 | dv>goal1); iter++) {
		if (dv < mingoal) {
			newscale = 2*scale
		}
		else if (iter==1) {
			// linear interpolation
			deriv__ipolate_linear(
				newscale,	mgoal,
				scale,		dv,
				scale1,		dv1)
		}
		else {
			// quadratic interpolation
			pragma unset scale2
			pragma unset dv2
			deriv__ipolate_quadratic(
				newscale,	mgoal,
				scale,		dv,
				scale1,		dv1,
				scale2,		dv2)
		}

		if (missing(newscale)
		 | newscale <= 0
		 | (dv > goal1 & newscale > scale)
		 | (dv < goal0 & newscale < scale)) {
			if (dv < goal0) {
				newscale	= 2*scale
			}
			else	newscale	= scale/2
		}

		scale2	= scale1
		dv2	= dv1
		scale1	= scale
		dv1	= dv

		scale	= newscale

		(*D.calluser)(D,p_alt,k,i,-h*scale,fmh,fmh_v)
		if (!missing(fmh)) {
			(*D.calluser)(D,p_alt,k,i,h*scale,fph,fph_v)
		}
		if (missing(fmh) | missing(fph)) {
			if (bestdv >= mingoal) {
				scale	= bestscale
				(*D.calluser)(D,p_alt,k,i,-h*scale,fmh,fmh_v)
				(*D.calluser)(D,p_alt,k,i,h*scale,fph,fph_v)

				if (D.verbose) {
					displayas("txt")
					printf(
	"numerical derivatives are approximate\nnearby values are missing\n"
					)
				}
				return(0)
			}
			D.errorcode = `Errcode_discon_miss'
			D.errortext = `Errtext_discon_miss'
			deriv__errorhandler(D)
			return(D.errorcode)
		}

		dv = (abs(D.value - fph) + abs(D.value - fmh))/2

		if (dv > 1.1*bestdv
		 | (dv >= 0.9*bestdv & scale < bestscale)) {
			bestdv		= dv
			bestscale	= scale
		}
	}

	if (dv < goal0 | dv > goal1) {	// we did not meet the goal
		if (bestdv >= mingoal) {
			// go with the best value
			scale	= bestscale
			(*D.calluser)(D,p_alt,k,i,-h*scale,fmh,fmh_v)
			(*D.calluser)(D,p_alt,k,i,h*scale,fph,fph_v)

			if (D.verbose) {
				displayas("txt")
				printf(
	"numerical derivatives are approximate\n" +
	"flat or discontinuous region encountered\n"
				)
			}
		}
		else {
			if (D.evaltype == `DERIV_evaltype_d') {
				D.errorcode = `Errcode_discon_miss'
				D.errortext = `Errtext_discon_miss'
			}
			else {
				D.errorcode = `Errcode_discon_flat'
				D.errortext = `Errtext_discon_flat'
			}
			deriv__errorhandler(D)
			return(D.errorcode)
		}
	}
	return(0)
}

/*STATIC*/ `Errcode' _deriv__h(
	`DerivStruct'	D,
	real scalar	k,
	real scalar	i,
	real scalar	h,
	real scalar	fph,			// f(x+h)
	real scalar	fmh,			// f(x-h)
	real vector	fph_v,			// f(x+h) vectorized
	real vector	fmh_v			// f(x-h) vectorized
)
{
	`Errcode'	ec
	real scalar	scale
	real rowvector	p_alt

	if (D.h_hold) {
		h = D.h[i]
	}
	else if (D.user_h != NULL) {
		(void) (*D.calluser_h)(D,i,h)
		D.h[i] = h
	}
	else {
		h = 1e-3
		h = (abs((*D.params)[i])+h)*h
		D.h[i] = h
	}

	// get the numerical derivative scale for the ith parameter/equation
	scale = D.scale[k,i]
	if (!scale) {
		scale	= `DERIV_S_default'
	}

	if (D.search == `DERIV_search_off') {
		p_alt = *D.params
		(*D.calluser)(D,p_alt,k,i,-h*scale,fmh,fmh_v)
		(*D.calluser)(D,p_alt,k,i,h*scale,fph,fph_v)
	}
	else {
		if (D.search == `DERIV_search_interpol') {
			ec = _deriv__search_interpol(
				D,k,i,h,scale,fph,fmh,fph_v,fmh_v)
		}
		else {
			ec = _deriv__search_bracket(
				D,k,i,h,scale,fph,fmh,fph_v,fmh_v)
		}
		if (ec) return(ec)

		// save the new numerical derivative scale for the ith
		// parameter/equation
		D.scale[k,i] = scale
	}

	// return the value of the perturbation for taking a numerical
	// derivative with respect to the ith parameter/equation
	h = floatround(h*scale)
	return(0)
}

/*STATIC*/ `Errcode' _deriv__h_missing(
	`DerivStruct'	D,
	real scalar	k,
	real scalar	i,
	real scalar	h,
	real scalar	scale,
	real scalar	fph,			// f(x+h)
	real scalar	fmh,			// f(x-h)
	real vector	fph_v,			// f(x+h) vectorized
	real vector	fmh_v			// f(x-h) vectorized
)
{
	real scalar	fm, fp
	real colvector	fm_v, fp_v
	real scalar	iter, itmax
	real rowvector	p_alt
	pragma unset fm_v
	pragma unset fp_v

	itmax	= 50

	// always start off with the original parameter values
	p_alt	= *D.params
	fp	= fph
	fm	= fmh
	for (iter=1; iter<=itmax & (missing(fm) | missing(fp)); iter++) {
		scale = scale/2
		(*D.calluser)(D,p_alt,k,i,-h*scale,fm,fm_v)
		if (!missing(fm)) {
			(*D.calluser)(D,p_alt,k,i,h*scale,fp,fp_v)
		}
	}
	if (missing(fm) | missing(fp)) {
		D.errorcode = `Errcode_discon_miss'
		D.errortext = `Errtext_discon_miss'
		deriv__errorhandler(D)
		return(D.errorcode)
	}
	fmh = fm
	fmh_v = fm_v
	fph = fp
	fph_v = fp_v
	return(_deriv__h_2(D,k,i,h,scale,fph,fmh,fph_v,fmh_v))
}

/*STATIC*/ `Errcode' _deriv__search_interpol(
	`DerivStruct'	D,
	real scalar	k,
	real scalar	i,
	real scalar	h,
	real scalar	scale,
	real scalar	fph,			// f(x+h)
	real scalar	fmh,			// f(x-h)
	real vector	fph_v,			// f(x+h) vectorized
	real vector	fmh_v			// f(x-h) vectorized
)
{
	real scalar	goal0, goal1, mgoal, mingoal, iter, itmax
	real scalar	value
	real colvector	fm0, fm0_v
	real scalar	scale0, newscale, scale1, scale2
	real scalar	dv, dv1, dv2
	real rowvector	p_alt
	real scalar	nflat

	if (D.weak_goals) {
		goal0	= 1e-4
		goal1	= 1e-3
	}
	else {
		goal0	= D.goals[1]
		goal1	= D.goals[2]
	}
	mingoal	= min((goal0*1e-2, 1e-10))
	itmax	= 20

	if (D.evaltype == `DERIV_evaltype_t') {
		value	= D.value_t[k]
	}
	else {
		value	= D.value
	}

	goal0	= (abs(value)+goal0)*goal0
	goal1	= (abs(value)+goal1)*goal1
	mgoal	= (goal0+goal1)/2
	mingoal	= (abs(value)+mingoal)*mingoal

	// always start off with the original parameter values
	p_alt	= *D.params

	(*D.calluser)(D,p_alt,k,i,-h*scale,fmh,fmh_v)
	if (missing(fmh)) {
		return(_deriv__h_missing(D,k,i,h,scale,fph,fmh,fph_v,fmh_v))
	}

	// Save initial values, we may have to restore them later
	scale0	= scale
	fm0	= fmh
	fm0_v	= fmh_v

	dv	= abs(value-fmh)
	scale1	= 0
	dv1	= 0
	nflat	= 0
	// use interpolation to get the scaled delta to within our goals
	for (iter=1; iter<=itmax & (dv<goal0 | dv>goal1); iter++) {
		if (dv < mingoal) {
			newscale = 2*scale
		}
		else if (iter==1) {
			// linear interpolation
			deriv__ipolate_linear(
				newscale,	mgoal,
				scale,		dv,
				scale1,		dv1)
		}
		else {
			// quadratic interpolation
			pragma unset scale2
			pragma unset dv2
			deriv__ipolate_quadratic(
				newscale,	mgoal,
				scale,		dv,
				scale1,		dv1,
				scale2,		dv2)
		}

		if (missing(newscale)
		 | newscale <= 0
		 | (dv > goal1 & newscale > scale)
		 | (dv < goal0 & newscale < scale)) {
			if (dv < goal0) {
				newscale	= 2*scale
			}
			else	newscale	= scale/2
		}

		scale2	= scale1
		dv2	= dv1
		scale1	= scale
		dv1	= dv

		scale	= newscale

		(*D.calluser)(D,p_alt,k,i,-h*scale,fmh,fmh_v)
		if (missing(fmh)) {
			return(_deriv__h_missing(D,k,i,h,
					scale,fph,fmh,fph_v,fmh_v))
		}

		dv	= abs(value-fmh)
		if (D.flat) {
			if (dv) {
				nflat = -itmax
			}
			else {
				nflat++
			}
			if (nflat > `DERIV_flat_maxiter') {
				scale	= 0
				return(0)
			}
		}
	}

	if (dv < goal0 | dv > goal1) {	// we did not meet the goal
		scale	= scale0	// go back to the initial values
		fmh	= fm0		// guaranteed to be nonmissing
		fmh_v	= fm0_v
	}

	(*D.calluser)(D,p_alt,k,i,h*scale,fph,fph_v)
	if (missing(fph)) {
		return(_deriv__h_missing(D,k,i,h,scale,fph,fmh,fph_v,fmh_v))
	}

	if (dv < goal0 | dv > goal1) {	// we did not meet the goal
		// redo the stepsize adjustment looking at both sides
		// starting values are guaranteed not to be missing
		return(_deriv__h_2(D,k,i,h,scale,fph,fmh,fph_v,fmh_v))
	}
	return(0)
}

/*STATIC*/ `Errcode' _deriv__search_bracket(
	`DerivStruct'	D,
	real scalar	k,
	real scalar	i,
	real scalar	h,
	real scalar	scale,
	real scalar	fph,			// f(x+h)
	real scalar	fmh,			// f(x-h)
	real vector	fph_v,			// f(x+h) vectorized
	real vector	fmh_v			// f(x-h) vectorized
)
{
	real scalar	goal0, goal1, mgoal, mingoal, iter, itmax
	real scalar	value
	real colvector	fm0, fm0_v
	real scalar	scale0, scale1, scale2, scale3
	real scalar	dv, dv1, dv2, dv3
	real scalar	swapi
	real scalar	magstep, ctrstep
	real rowvector	p_alt
	real scalar	nflat

	goal0	= D.goals[1]
	goal1	= D.goals[2]
	mingoal	= min((goal0/100, 1e-10))
	magstep	= 3
	ctrstep	= 1/magstep
	itmax	= 20

	if (D.evaltype==`DERIV_evaltype_t') {
		value	= D.value_t[k]
	}
	else {
		value	= D.value
	}

	goal0	= (abs(value)+goal0)*goal0
	goal1	= (abs(value)+goal1)*goal1
	mingoal	= (abs(value)+mingoal)*mingoal

	// always start off with the original parameter values
	p_alt	= *D.params

	(*D.calluser)(D,p_alt,k,i,-h*scale,fmh,fmh_v)
	if (missing(fmh)) {
		return(_deriv__h_missing(D,k,i,h,scale,fph,fmh,fph_v,fmh_v))
	}

	dv	= abs(value-fmh)

	if (dv >= goal0 & dv <= goal1) {
		(*D.calluser)(D,p_alt,k,i,h*scale,fph,fph_v)
		return(0)
	}

	// Save initial values, we may have to restore them later
	scale0	= scale
	fm0	= fmh
	fm0_v	= fmh_v

	// bracket the mid-point of the target range.
	// if we hit the range, we are done.

	scale3	= 0			// (0,0) is a fine point on the
	dv3	= 0			// delta/delta fn

	scale2	= scale			// so in the current point
	dv2	= dv

	if (dv < goal0) {
		scale = magstep*scale
	}
	else {
		scale = scale/magstep
	}

	(*D.calluser)(D,p_alt,k,i,-h*scale,fmh,fmh_v)
	if (missing(fmh)) {
		return(_deriv__h_missing(D,k,i,h,scale,fph,fmh,fph_v,fmh_v))
	}
	dv	= abs(value-fmh)

	scale1	= scale
	dv1	= dv

	mgoal	= (goal0+goal1)/2
	swapi	= 3
	nflat	= 0
	for (iter=1; iter<=itmax & (dv<goal0 | dv>goal1); iter++) {
		deriv__solve(
			scale,	mgoal,
			scale1,	dv1,
			scale2,	dv2,
			scale3,	dv3,
			ctrstep)

		(*D.calluser)(D,p_alt,k,i,-h*scale,fmh,fmh_v)
		if (missing(fmh)) {
			return(_deriv__h_missing(D,k,i,h,scale,
					fph,fmh,fph_v,fmh_v))
		}

		dv	= abs(value-fmh)
		if (D.flat) {
			if (dv) {
				nflat = -itmax
			}
			else {
				nflat++
			}
			if (nflat > `DERIV_flat_maxiter') {
				scale	= 0
				return(0)
			}
		}

		if (swapi == 1) {
			dv1	= dv		
			scale1	= scale
			swapi	= 2
		}
		else if (swapi == 2) {
			dv2	= dv		
			scale2	= scale
			swapi	= 3
		}
		else {
			dv3	= dv		
			scale3	= scale
			swapi	= 1
		}
	}

	if (dv < goal0 | dv > goal1) {	// we did not meet the goal
		scale	= scale0	// go back to the initial values
		fmh	= fm0		// guaranteed to be nonmissing
		fmh_v	= fm0_v
	}

	(*D.calluser)(D,p_alt,k,i,h*scale,fph,fph_v)
	if (missing(fph)) {
		return(_deriv__h_missing(D,k,i,h,scale,fph,fmh,fph_v,fmh_v))
	}

	if (dv < goal0 | dv > goal1) {	// we did not meet the goal
		// redo the stepsize adjustment looking at both sides
		// starting values are guaranteed not to be missing
		return(_deriv__h_2(D,k,i,h,scale,fph,fmh,fph_v,fmh_v))
	}
	return(0)
}

/*STATIC*/ void deriv__ipolate_linear(
	real scalar	y,
	real scalar	x,
	real scalar	y0,
	real scalar	x0,
	real scalar	y1,
	real scalar	x1
)
{
	y = y0 + (y1 - y0)*(x - x0)/(x1 - x0)
}

/*STATIC*/ void deriv__ipolate_quadratic(
	real scalar	y,
	real scalar	x,
	real scalar	y0,
	real scalar	x0,
	real scalar	y1,
	real scalar	x1,
	real scalar	y2,
	real scalar	x2
)
{
	y =	y0*(x - x1)*(x - x2)/((x0 - x1)*(x0 - x2)) +
		y1*(x - x0)*(x - x2)/((x1 - x0)*(x1 - x2)) +
		y2*(x - x0)*(x - x1)/((x2 - x0)*(x2 - x1))
}

/*STATIC*/ void deriv__solve(
	real scalar	x,
	real scalar	y,
	real scalar	x1,
	real scalar	y1,
	real scalar	x2,
	real scalar	y2,
	real scalar	x3,
	real scalar	y3,
	real scalar	cont_rt
)
{
	deriv__solve_quadratic(x,y,x1,y1,x2,y2,x3,y3)
	if (missing(x)) {
		// no quadratic solution, try linear
		x = ((x3-x1) / (y3-y1)) * (y-y1) + x1
	}
	if (x<=0 | missing(x)){
		// negative result not allowed, contract
		real scalar minx, maxx
		minx = cont_rt * min((x1,x2,x3))
		if (minx > 1e-12) {
			x = minx * cont_rt
		}
		else {
			maxx = cont_rt * max((x1,x2,x3))
			x = maxx*cont_rt + (1-cont_rt)*minx
		}
		x = x + 1e-6*(x1 + x2 + x3)
	}
}

/*STATIC*/ void deriv__solve_quadratic(
	real scalar	x,
	real scalar	y,
	real scalar	x1,
	real scalar	y1,
	real scalar	x2,
	real scalar	y2,
	real scalar	x3,
	real scalar	y3
)
{
	real matrix	X
	real colvector	t
	real colvector	b
	real scalar	c

	X = (1, x1, x1^2 \
	     1, x2, x2^2 \
	     1, x3, x3^2 )
	t = (y1 \ y2 \ y3)
	b = pinv(X) * t
	c = b[1] - y
	x = (-b[2] + sqrt(b[2]^2 - 4*b[3]*c)) / (2*b[3])
}

end
