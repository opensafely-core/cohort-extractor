*! version 1.1.4  01jun2013
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'
findfile moptimize_include.mata
quietly include `"`r(fn)'"'

local lfstar `""lf0 lf1 lf1debug lf2 lf2debug""'
local vstar `""v0 v1 v1debug v2 v2debug""'
local eval2 `""d2 d2debug v2 v2debug lf2 lf2debug e2 e2debug""'
local eval1 `""d1 d1debug v1 v1debug q1 q1debug lf1 lf1debug e1 e1debug""'

mata:

void moptimize_check(`MoptStruct' M)
{
	`Errcode'	ec

	M.S.ucall = 1
	ec = _moptimize_check(M)
	M.S.ucall = 0
	if (ec) {
		exit(moptimize_result_returncode(M))
	}
}

`Errcode' _moptimize_check(`MoptStruct' M)
{
	`Errcode'		ec
	real	rowvector	params
	real	scalar		value
	real	rowvector	gradient
	real	matrix		H

	M.check	= `OPT_onoff_on'

	M.st_trace = "mopt_quietly"
	ec = mopt__validate(M)
	if (!ec) {
		ec = mopt__check_test1(M)
	}
	if (!ec) {
		ec = mopt__check_test2(M)
	}
	if (!ec & missing(M.S.value)) {
		mopt__check_feasible1(M)
		ec = mopt__check_test1(M)
		if (!ec) {
			ec = mopt__check_test2(M)
		}
	}
	if (!ec) {
		ec = mopt__check_test3(M)
	}
	if (!ec) {
		ec = mopt__check_test4(M)
	}
	if (!ec) {
		ec = mopt__check_test5(M)
	}
	if (!ec) {
		ec = mopt__check_test6(M)
	}
	if (!ec) {
		params		= M.S.params
		value		= M.S.value
		gradient	= M.S.gradient
		H		= M.S.H
		ec = mopt__check_feasible2(M)
	}
	if (!ec) {
		ec = mopt__check_test7(M, params, value, gradient, H)
	}
	if (!ec) {
		ec = mopt__check_test8(M, params, value, gradient, H)
	}
	if (!ec) {
		ec = mopt__check_test9(M, params, value, gradient, H)
	}
	if (!ec) {
		displayas("res")
		printf("\n{hline 78}\n")
		printf("{col 26}%s HAS PASSED ALL TESTS\n{hline 78}\n",
			moptimize_name_evaluator(M))
	}
	M.st_trace = ""
	if (!ec & M.st_user != `MOPT_st_user_default') {
		ec = mopt__check_test10(M)
	}
	if (!ec) {
		if (!mopt__check_evaltype(M)) return(ec)
		ec = mopt__check_derivatives(M)
	}

	M.check	= `MOPT_check_default'

	return(ec)
}

void moptimize_report(`MoptStruct' M)
{
	real	scalar		ec
	real	scalar		todo, minimize
	string	scalar		name, user
	real	rowvector	g
	real	matrix		H

	displayas("txt")

	user = moptimize_name_evaluator(M)

	ec =_moptimize_validate(M)
	if (ec) {
		exit(moptimize_result_returncode(M))
	}

	printf("\nCurrent coefficient vector:\n")
	_matrix_list(
		M.S.params,
		J(0,2,""),
		(cols(M.S.params)==M.S.dim ?
			(*M.S.stripes[3]) : J(0,2,"")),
		"%9.0g")

	name = M.S.evaltype_f
	if (strmatch(name, "lf")) {
		todo = 2
	}
	else if (any(strmatch(name, tokens(`eval2')))) {
		todo = 2
	}
	else if (any(strmatch(name, tokens(`eval1')))) {
		todo = 1
	}
	else {
		todo = 0
	}

	ec = _mopt__evaluate(M, todo)
	if (ec) {
		exit(moptimize_result_returncode(M))
	}
	if (missing(moptimize_result_value(M))) {
		printf("\n(function cannot be evaluated at this point)\n")
		return
	}
	printf("\nValue of %s function = {res:%10.0g}\n",
		moptimize_init_valueid(M),
		moptimize_result_value(M))

	g = moptimize_result_gradient(M)
	if (missing(g)) {
		printf("\n(%s does not provide derivatives)\n", user)
		return
	}

	minimize = moptimize_init_which(M) == "min"

	printf("\n")
	printf("Gradient vector (length ={res:%9.0g}):\n", norm(g))
	_matrix_list(
		(minimize ? -g : g),
		J(0,2,""),
		(cols(g)==M.S.dim ?
			(*M.S.stripes[3]) : J(0,2,"")),
		"%9.0g")
	printf("\n")

	if (todo < 2) {
		return
	}

	H = M.S.H
	if (missing(H)) {
		printf("Steepest-ascent direction:\n")
		(minimize ? -g : g)/norm(g)
		printf("\n")
		printf("\n(%s does not provide a Hessian)\n", user)
		return
	}

	printf("Hessian matrix ")
	if (rank(H) == cols(H)) {
		printf("(concave; matrix is full rank):\n")
	}
	else {
		printf("(nonconcave; ranke = %f < %f):\n",
			rank(H), cols(H))
	}
	_matrix_list(
		H,
		(cols(H)==M.S.dim ?
			(*M.S.stripes[2]) : J(0,2,"")),
		(cols(H)==M.S.dim ?
			(*M.S.stripes[3]) : J(0,2,"")),
		"%9.0g")

	printf("\n")
	printf("Steepest-ascent direction:\n")
	_matrix_list(
		(minimize ? -g : g)/norm(g),
		J(0,2,""),
		(cols(g)==M.S.dim ?
			(*M.S.stripes[3]) : J(0,2,"")),
		"%9.0g")
	printf("\n")

	if (M.S.invert) {
		g = g*invsym(-H)
	}
	else {
		g = g*H
	}
	printf(
"Newton-Raphson direction (length before normalization ={res:%9.0g}):\n",
		norm(g))
	_matrix_list(
		g/norm(g),
		J(0,2,""),
		(cols(g)==M.S.dim ?
			(*M.S.stripes[3]) : J(0,2,"")),
		"%9.0g")
}

// test routines ------------------------------------------------------------

/*STATIC*/ `Errcode' mopt__check_test1(`MoptStruct' M)
{
	`Errcode'		ec
	real	rowvector	params
	real	scalar		checkxb
	real	matrix		xb

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf(
	"Test 1:  Calling {res:%s} to check if it computes %s and{break}",
		moptimize_name_evaluator(M),
		M.S.value_id)
	printf("does not alter coefficient vector...")
	printf("{p_end}\n")

	if (M.S.params == `OPT_params_default') {
		M.S.params = M.S.p0
	}

	checkxb = (M.S.evaltype_f == "lf") &
		  (M.st_user != `MOPT_st_user_default')
	if (checkxb) {
		mopt__build_xb(M, M.S.params)
		xb = st_data(., M.st_xb, M.st_touse)
	}
	params = M.S.params
	ec = _mopt__evaluate(M)
	if (ec) return(ec)
	if (M.st_rc) {
		return(mopt__check_set_errorcode(M))
	}

	if (checkxb) {
		if (mreldif(xb, M.xb)) {
			mopt__check_failed(M)
			displayas("txt")
			printf("{p 9 9 0 78}")
			printf("{res:%s} changed an input variable ",
				moptimize_name_evaluator(M))
			printf("(argument 2, 3, ...).{break}")
			printf("It must not do that.")
			printf("{p_end}\n")
			exit(9)
		}
	}
	else {
		mopt__check_value(M)
		mopt__check_equal_params(M, params)
	}
	mopt__check_passed()

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_test2(`MoptStruct' M)
{
	`Errcode'	ec
	real	scalar	value

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf("Test 2:  Calling {res:%s} again to check if the same %s value ",
		moptimize_name_evaluator(M),
		M.S.value_id)
	printf("is returned...")
	printf("{p_end}\n")

	value = M.S.value
	ec = _mopt__evaluate(M)
	if (ec) return(ec)
	if (M.st_rc) {
		mopt__check_failed(M, M.st_rc)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf(
"Perhaps {res:%s} attempted to redefine something defined previously.{break}",
			moptimize_name_evaluator(M)
		)
		printf(
"Did you forget to drop some working variable?"
		)
		printf("{p_end}\n")
		mopt__check_trace(M, 0)
		M.S.errorcode = `Errcode_stata_rc'
		M.S.errortext = `Errtext_stata_rc'
		return(M.S.errorcode)
	}

	mopt__check_equal_value(M, value)
	mopt__check_passed()

	return(0)
}

/*STATIC*/ void mopt__check_feasible1(`MoptStruct' M)
{
	`Errcode'	ec
	real	scalar 	trace
	real	scalar	repeat
	real	scalar	random
	pragma unset trace

	displayas("txt")
	printf("\n{hline 78}\n")
	printf("{p 0 0 0 78}")
	printf("The initial values are not feasible.  ")
	printf("This may be because the initial values ")
	printf("have been chosen poorly or because there is an error in ")
	printf("{res:%s} and it ", moptimize_name_evaluator(M))
	printf("always returns missing no matter what the parameter values.\n")
	printf("{p_end}\n")
	printf("\n{p 0 0 0 78}")
	printf("Stata is going to search for a feasible set of initial values.")
	printf("{break}")
	printf("If {res:%s} is broken, ", moptimize_name_evaluator(M))
	printf("this will not work and you will have to press {res:Break} ")
	printf("to stop the search.")
	printf("{p_end}\n")
	printf("\n{p 0 0 0 78}")
	printf("Searching...")
	printf("{p_end}\n")
	opt__trace_store((M.S), trace)
	repeat			= M.search_repeat
	random			= M.search_random
	M.S.utrace		= `OPT_tracelvl_step'
	M.valid			= `OPT_onoff_off'
	M.search_repeat		= 10
	M.search_random		= `OPT_onoff_on'
	moptimize_reset_p0(M)
	ec = _mopt__search(M)
	M.search_repeat		= repeat
	M.search_random		= random
	opt__trace_restore((M.S), trace)
	M.S.ucall		= 0
	if (ec) {
		exit(optimize_result_returncode(M.S))
	}
	printf("\nrestarting tests...\n{hline 78}\n")
}

/*STATIC*/ `Errcode' mopt__check_test3(`MoptStruct' M)
{
	`Errcode'		ec
	real	rowvector	params
	real	scalar		value

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf("Test 3:  Calling {res:%s} to check if 1st derivatives ",
		moptimize_name_evaluator(M))
	printf("are computed...")
	printf("{p_end}\n")
	if (any(strmatch(M.S.evaltype_f, ("d0",
					  "v0",
					  "q0",
					  "lf",
					  "lf0")))) {
		mopt__check_notrel(M)
		return(0)
	}
	params		= M.S.params
	value		= M.S.value
	ec = _mopt__evaluate(M, 1)
	if (ec) return(ec)
	if (M.st_rc) {
		return(mopt__check_set_errorcode(M, 1))
	}

	mopt__check_equal_params(M, params)
	mopt__check_gradient(M)
	mopt__check_equal_value(M, value)
	mopt__check_passed()

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_test4(`MoptStruct' M)
{
	`Errcode'		ec
	real	rowvector	params
	real	scalar		value
	real	rowvector	gradient

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf("Test 4:  Calling {res:%s} again to check if the same ",
		moptimize_name_evaluator(M))
	printf("1st derivatives are returned...")
	printf("{p_end}\n")
	if (any(strmatch(M.S.evaltype_f, ("d0",
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
		mopt__check_notrel(M)
		return(0)
	}
	params		= M.S.params
	value		= M.S.value
	gradient	= M.S.gradient
	ec = _mopt__evaluate(M, 1)
	if (ec) return(ec)
	if (M.st_rc) {
		return(mopt__check_set_errorcode(M, 1))
	}

	mopt__check_equal_params(M, params)
	mopt__check_equal_value(M, value)
	mopt__check_equal_gradient(M, gradient)
	mopt__check_passed()

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_test5(`MoptStruct' M)
{
	`Errcode'		ec
	real	rowvector	params
	real	scalar		value
	real	rowvector	gradient

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf("Test 5:  Calling {res:%s} to check if 2nd derivatives ",
		moptimize_name_evaluator(M))
	printf("are computed...")
	printf("{p_end}\n")
	if (any(strmatch(M.S.evaltype_f, ("d0",
					  "d1",
					  "d1debug",
					  "d2debug",
					  "v0",
					  "v1",
					  "v1debug",
					  "v2debug",
					  "q0",
					  "q1",
					  "q1debug",
					  "lf",
					  "lf0",
					  "lf1",
					  "lf1debug",
					  "lf2debug",
					  "e1",
					  "e1debug",
					  "e2debug")))) {
		mopt__check_notrel(M)
		return(0)
	}
	params		= M.S.params
	value		= M.S.value
	gradient	= M.S.gradient
	ec = _mopt__evaluate(M, 2)
	if (ec) return(ec)
	if (M.st_rc) {
		return(mopt__check_set_errorcode(M, 2))
	}

	mopt__check_equal_params(M, params)
	mopt__check_H(M)
	mopt__check_equal_value(M, value)
	mopt__check_equal_gradient(M, gradient)
	mopt__check_passed()

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_test6(`MoptStruct' M)
{
	`Errcode'		ec
	real	rowvector	params
	real	scalar		value
	real	rowvector	gradient
	real	matrix		H

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf("Test 6:  Calling {res:%s} again to check if the same ",
		moptimize_name_evaluator(M))
	printf("2nd derivatives are returned...")
	printf("{p_end}\n")
	if (any(strmatch(M.S.evaltype_f, ("d0",
					  "d1",
					  "d1debug",
					  "d2debug",
					  "v0",
					  "v1",
					  "v1debug",
					  "v2debug",
					  "q0",
					  "q1",
					  "q1debug",
					  "lf",
					  "lf0",
					  "lf1",
					  "lf1debug",
					  "lf2debug",
					  "e1",
					  "e1debug",
					  "e2debug")))) {
		mopt__check_notrel(M)
		return(0)
	}
	params		= M.S.params
	value		= M.S.value
	gradient	= M.S.gradient
	H		= M.S.H
	ec = _mopt__evaluate(M, 2)
	if (ec) return(ec)
	if (M.st_rc) {
		return(mopt__check_set_errorcode(M, 2))
	}

	mopt__check_equal_params(M, params)
	mopt__check_equal_value(M, value)
	mopt__check_equal_gradient(M, gradient)
	mopt__check_equal_H(M, H)
	mopt__check_passed()

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_feasible2(`MoptStruct' M)
{
	`Errcode'	ec
	real	scalar 	trace
	real	scalar	rescale
	real	scalar	random
	real	scalar	repeat
	pragma unset trace

	displayas("txt")
	printf("\n{hline 78}\n")
	printf("{p 0 0 0 78}")
	printf("Searching for alternate values for the coefficient ")
	printf("vector to verify that {res:%s} ", moptimize_name_evaluator(M))
	printf("returns different results when fed a different ")
	printf("coefficient vector:")
	printf("{p_end}\n")
	printf("\n{p 0 0 0 78}")
	printf("Searching...")
	printf("{p_end}\n")
	rescale			= M.search_rescale
	random			= M.search_random
	repeat			= M.search_repeat
	opt__trace_store((M.S), trace)
	M.search_rescale	= `OPT_onoff_off'
	M.search_random		= `OPT_onoff_on'
	M.search_repeat		= 10
	M.S.utrace		= `OPT_tracelvl_step'
	M.S.value		= `OPT_value_default'
	M.valid			= `OPT_onoff_off'
	ec = _mopt__search(M)
	M.search_rescale	= rescale
	M.search_random		= random
	M.search_repeat		= repeat
	opt__trace_restore((M.S), trace)
	M.S.ucall		= 0
	if (ec) {
		opt__errorhandler(M.S)
	}
	printf("\ncontinuing with tests...\n{hline 78}\n")
	return(0)
}

/*STATIC*/ `Errcode' mopt__check_test7(
	`MoptStruct'		M,
	real	rowvector	params,
	real	scalar		value,
	real	rowvector	gradient,
	real	matrix		H
)
{
	`Errcode'		ec
	pragma unset gradient
	pragma unset H

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf("Test 7:  Calling {res:%s} to check %s at the new values...",
		moptimize_name_evaluator(M),
		M.S.value_id)
	printf("{p_end}\n")
	ec = _mopt__evaluate(M)
	if (ec) return(ec)
	if (M.st_rc) {
		return(mopt__check_set_errorcode(M))
	}

	mopt__check_notequal_value(M, params, value)
	mopt__check_passed()

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_test8(
	`MoptStruct'		M,
	real	rowvector	params,
	real	scalar		value,
	real	rowvector	gradient,
	real	matrix		H
)
{
	`Errcode'		ec
	pragma unset value
	pragma unset H

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf("Test 8:  Calling {res:%s} requesting 1st derivatives ",
		moptimize_name_evaluator(M))
	printf("at the new values...")
	printf("{p_end}\n")
	if (any(strmatch(M.S.evaltype_f, ("d0",
					  "v0",
					  "q0",
					  "lf",
					  "lf0")))) {
		mopt__check_notrel(M)
		return(0)
	}

	ec = _mopt__evaluate(M, 1)
	if (ec) return(ec)
	if (M.st_rc) {
		return(mopt__check_set_errorcode(M, 1))
	}

	mopt__check_notequal_gradient(M, params, gradient)
	mopt__check_passed()

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_test9(
	`MoptStruct'		M,
	real	rowvector	params,
	real	scalar		value,
	real	rowvector	gradient,
	real	matrix		H
)
{
	`Errcode'		ec
	pragma unset value
	pragma unset gradient

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf("Test 9:  Calling {res:%s} requesting 2nd derivatives ",
		moptimize_name_evaluator(M))
	printf("at the new values...")
	printf("{p_end}\n")
	if (any(strmatch(M.S.evaltype_f, ("d0",
					  "d1",
					  "d1debug",
					  "v0",
					  "v1",
					  "v1debug",
					  "q0",
					  "q1",
					  "q1debug",
					  "lf",
					  "lf0",
					  "lf1",
					  "lf1debug",
					  "e1",
					  "e1debug")))) {
		mopt__check_notrel(M)
		return(0)
	}

	ec = _mopt__evaluate(M, 2)
	if (ec) return(ec)
	if (M.st_rc) {
		return(mopt__check_set_errorcode(M, 2))
	}

	mopt__check_notequal_H(M, params, H)
	mopt__check_passed()

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_test10(`MoptStruct' M)
{
	`Errcode'	ec
	string	scalar	name
	real	scalar	todo

	displayas("txt")

	printf("\n{p 0 9 0 78}")
	printf("Test 10: Does {res:%s} produce unanticipated output?{break}",
		moptimize_name_evaluator(M))
	printf("This is a minor issue.  Stata has been running {res:%s} ",
		moptimize_name_evaluator(M))
	printf("with all output suppressed.  ")
	printf("This time Stata will not suppress the output.  ")
	printf("If you see any unanticipated output, ")
	printf("you need to place {res:quietly} in front of some of the ")
	printf("commands in {res:%s}.",
		moptimize_name_evaluator(M))
	printf("{p_end}\n")

	name = moptimize_init_evaluatortype(M)
	if (any(strmatch(name, tokens(`eval2')))) {
		todo = 2
	}
	else if (any(strmatch(name, tokens(`eval1')))) {
		todo = 1
	}
	else {
		todo = 0
	}
	printf("\n{hline 62} begin execution\n")
	ec = _mopt__evaluate(M, todo)
	if (ec) return(ec)
	printf("{txt}{hline 64} end execution\n")

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_derivatives(`MoptStruct' M)
{
	string	scalar	name

	displayas("txt")
	printf("\nYou should check that the derivatives are right.\n")
	name = optimize_init_evaluatortype(M.S)
	if (!strmatch(name, "*debug")) {
		printf("\n{p 0 0 0 78}")
		printf("Stata recommends that you change the evaluator type ")
		printf("to {res:%s}{res:debug}.  ", name)
		printf("Then use the optimizer to obtain estimates.")
		printf("{p_end}\n")
	}
	else {
		printf("\nUse the optimizer to obtain estimates.\n")
	}

	printf("\n{p 0 0 0 78}")
	printf(
"The output will include a report comparing analytic to numeric derivatives.  "
	)
	printf(
"Do not be concerned if your analytic derivatives differ from the numeric ones "
	)
	printf(
"in early iterations."
	)
	printf("{p_end}\n")
	printf("\n{p 0 0 0 78}")
	printf(
"The analytic gradient will differ from the numeric one in early iterations, "
	)
	printf(
"then the mreldif() difference should become less than 1e-6 in the middle "
	)
	printf(
"iterations, and the difference will increase again in the final iterations "
	)
	printf(
"as the gradient goes to zero."
	)
	printf("{p_end}\n")

	if (any(strmatch(name, tokens(`eval1')))) {
		return(0)
	}

	printf("\n{p 0 0 0 78}")
	printf(
"The analytic negative Hessian will differ from the numeric one in early "
	)
	printf(
"iterations, but the mreldif() difference should decrease with each iteration "
	)
	printf(
"and become less than 1e-6 in the final iterations."
	)
	printf("{p_end}\n")

	return(0)
}

// utilities ----------------------------------------------------------------

/*STATIC*/ void mopt__check_params(`MoptStruct' M)
{
	if (M.st_user != `MOPT_st_user_default') {
		real	matrix	params
		params = st_matrix(M.st_p)
		if (!length(params)) {
			mopt__check_failed(M)
			displayas("txt")
			printf("{p 9 9 0 78}")
			printf(
			"{res:%s} did not issue an error, but it dropped ",
				moptimize_name_evaluator(M))
			printf("the input coefficient vector.")
			printf("{p_end}\n")
			exit(111)
		}
	}
}

/*STATIC*/ void mopt__check_equal_params(
	`MoptStruct'	M,
	real matrix	params
)
{
	mopt__check_params(M)
	if (mreldif(params, M.S.params)) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf("{res:%s} changed the coefficient vector.{break}",
			moptimize_name_evaluator(M))
		printf("Your program must not change this input value.")
		printf("{p_end}\n")
		exit(9)
	}
}

/*STATIC*/ void mopt__check_value(`MoptStruct' M)
{
	if (M.st_user == `MOPT_st_user_default') {
		return
	}
	if (any(strmatch(M.S.evaltype_f, tokens(`lfstar')))) {
		return
	}
	if (any(strmatch(M.S.evaltype_f, tokens(`vstar')))) {
		return
	}
	if (! length(st_numscalar(M.st_v))) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf(
"{res:%s} did not issue an error, but it also did not set the %s scalar.",
			moptimize_name_evaluator(M),
			M.S.value_id)
		printf("{p_end}\n")
		exit(111)
	}
}

/*STATIC*/ void mopt__check_equal_value(
	`MoptStruct'	M,
	real scalar	value
)
{
	if (value != M.S.value) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf(
"{res:%s} returned{break}{space 5}%s = {res:%10.0g} this time,{break}",
			moptimize_name_evaluator(M),
			M.S.value_id,
			M.S.value)
		printf(
"{space 5}%s = {res:%10.0g} last time,{break}",
			M.S.value_id,
			value)
		printf(
"{space %f}difference = %10.0g{break}",
			5+max((0,strlen(M.S.value_id)-10)),
			M.S.value-value)
		printf("The coefficient vectors were the same.")
		printf("{p_end}\n")
		exit(9)
	}
}

/*STATIC*/ void mopt__check_notequal_value(
	`MoptStruct'	M,
	real rowvector	params,
	real scalar	value
)
{
	if (value == M.S.value) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf("Two different coefficient vectors resulted in equal ")
		printf("%s values of {res:%10.0g}.",
			M.S.value_id,
			M.S.value)
		printf("{p_end}\n")
		mopt__check_notproof()
		mopt__check_show_params(M, params)
		exit(9)
	}
}

/*STATIC*/ void mopt__check_gradient(`MoptStruct' M)
{
	if (!length(M.S.gradient)) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf(
		"{res:%s} did not issue an error, but it also ",
			moptimize_name_evaluator(M))
		printf("did not set the gradient vector.")
		printf("{p_end}\n")
		exit(111)
	}
	if (rows(M.S.gradient) != 1
	 |  cols(M.S.gradient) != M.S.dim) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf("{res:%s} returned a gradient vector that was ",
			moptimize_name_evaluator(M))
		printf("{res:%f} x {res:%f}, not {res:1} x {res:%f}.",
			rows(M.S.gradient),
			cols(M.S.gradient),
			M.S.dim)
		printf("{p_end}\n")
		exit(503)
	}
}

/*STATIC*/ void mopt__check_equal_gradient(
	`MoptStruct'	M,
	real rowvector	gradient
)
{
	if (mreldif(gradient, M.S.gradient)) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf(
"{res:%s} returned a different gradient vector this time;{break}",
			moptimize_name_evaluator(M))
		printf(
"mreldif(this time, last time) = {res:%10.0g}{break}",
			mreldif(gradient, M.S.gradient))
		printf("The coefficient vectors were the same.")
		printf("{p_end}\n")
		exit(9)
	}
}

/*STATIC*/ void mopt__check_notequal_gradient(
	`MoptStruct'	M,
	real rowvector	params,
	real rowvector	gradient
)
{
	if (! mreldif(gradient, M.S.gradient)) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf("Two different coefficient vectors resulted in equal ")
		printf("gradient vectors.")
		printf("{p_end}\n")
		mopt__check_notproof()
		mopt__check_show_params(M, params)
		printf("\nGradient vector:\n")
		_matrix_list(
			gradient,
			J(0,2,""),
			(cols(gradient)==M.S.dim ?
				(*M.S.stripes[3]) : J(0,2,"")),
			"%9.0g")
		exit(9)
	}
}

/*STATIC*/ void mopt__check_H(`MoptStruct' M)
{
	if (!length(M.S.H)) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf(
		"{res:%s} did not issue an error, but it also ",
			moptimize_name_evaluator(M))
		printf("did not set the Hessian matrix.")
		printf("{p_end}\n")
		exit(111)
	}
	if (rows(M.S.H) != M.S.dim
	 |  cols(M.S.H) != M.S.dim) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf("{res:%s} returned a Hessian matrix that was ",
			moptimize_name_evaluator(M))
		printf("{res:%f} x {res:%f}, not {res:%f} x {res:%f}.",
			rows(M.S.H),
			cols(M.S.H),
			M.S.dim,
			M.S.dim)
		printf("{p_end}\n")
		exit(503)
	}
	if (! issymmetric(M.S.H)) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf(
		"{res:%s} returned a Hessian matrix that was not symmetric.",
			moptimize_name_evaluator(M))
		printf("{p_end}\n")
		exit(505)
	}
}

/*STATIC*/ void mopt__check_equal_H(
	`MoptStruct'	M,
	real matrix	H
)
{
	if (mreldif(H, M.S.H)) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf(
"{res:%s} returned a different Hessian matrix this time;{break}",
			moptimize_name_evaluator(M))
		printf(
"mreldif(this time, last time) = {res:%10.0g}{break}",
			mreldif(H, M.S.H))
		printf("The coefficient vectors were the same.")
		printf("{p_end}\n")
		exit(9)
	}
}

/*STATIC*/ void mopt__check_notequal_H(
	`MoptStruct'	M,
	real rowvector	params,
	real matrix	H
)
{
	if (! mreldif(H, M.S.H)) {
		mopt__check_failed(M)
		displayas("txt")
		printf("{p 9 9 0 78}")
		printf("Two different coefficient vectors resulted in equal ")
		printf("Hessian matrices.")
		printf("{p_end}\n")
		mopt__check_notproof()
		mopt__check_show_params(M, params)
		printf("\nHessian matrix:\n")
		_matrix_list(
			H,
			(cols(H)==M.S.dim ?
				(*M.S.stripes[2]) : J(0,2,"")),
			(cols(H)==M.S.dim ?
				(*M.S.stripes[3]) : J(0,2,"")),
			"%9.0g")
		exit(9)
	}
}

/*STATIC*/ void mopt__check_failed(`MoptStruct' M,| real scalar rc)
{
	if (args() == 1) {
		errprintf("{col 10}FAILED.\n")
	}
	else {
		displayas("txt")
		printf("{col 10}{err:FAILED;} {res:%s} returned error %f.\n",
			moptimize_name_evaluator(M), rc)
	}
}

/*STATIC*/ void mopt__check_passed()
{
	displayas("txt")
	printf("{col 10}Passed.\n")
}

/*STATIC*/ void mopt__check_notproof()
{
	displayas("txt")
	printf("{col 10}")
	printf("This does not prove there is a problem, but it suggests it.\n")
}

/*STATIC*/ void mopt__check_show_params(
	`MoptStruct'	M,
	real rowvector	params
)
{
	real	matrix	pp
	displayas("txt")
	printf("\ntwo coefficient vectors:\n")
	pp = M.S.params \ params
	_matrix_list(
		pp,
		J(0,2,""),
		(cols(pp)==M.S.dim ?
			(*M.S.stripes[3]) : J(0,2,"")),
		"%9.0g")
}

/*STATIC*/ void mopt__check_notrel(`MoptStruct' M)
{
	displayas("txt")
	printf("{col 10}")
	printf("test not relevant for type {res:%s} evaluators.\n",
		optimize_init_evaluatortype(M.S))
}

/*STATIC*/ real scalar mopt__check_evaltype(`MoptStruct' M)
{
	if (any(strmatch(M.S.evaltype_f, tokens(`eval2')))) {
		return(2)
	}

	if (any(strmatch(M.S.evaltype_f, tokens(`eval1')))) {
		return(1)
	}

	return(0)
}

/*STATIC*/ `Errcode' mopt__check_set_errorcode(
	`MoptStruct'	M,
	| real	scalar	todo
)
{
	if (args() == 1) {
		todo = 0
	}
	mopt__check_failed(M, M.st_rc)
	mopt__check_trace(M, todo)
	M.S.errorcode = `Errcode_stata_rc'
	M.S.errortext = `Errtext_stata_rc'
	return(M.S.errorcode)
}

/*STATIC*/ void mopt__check_trace(`MoptStruct' M, real scalar todo)
{
	`Errcode'	ec, rc0, rc1

	if (M.st_user == `MOPT_st_user_default') {
		return
	}

	displayas("txt")
	printf("\nHere is a trace of its execution:\n{hline 78}\n")

	rc0 = M.st_rc
	moptimize_init_trace_ado(M, "on")
	M.st_trace = "mopt_quietly " + M.st_trace
	ec = _mopt__evaluate(M, todo)
	moptimize_init_trace_ado(M, "off")
	if (ec) return(ec)
	rc1 = M.st_rc

	displayas("txt")
	printf("{hline 78}\n")

	displayas("txt")
	if (rc1 == 0) {
		printf("{res:%s} worked this time!\n",
			moptimize_name_evaluator(M))
		printf("Probably something is uninitialized.\n")
	}
	else if (rc0 != rc1) {
		printf("{res:%s} returned error {res:%f} this time!\n",
			moptimize_name_evaluator(M),
			rc1)
		printf("(It returned error {res:%f} last time.)\n", rc0)
	}
	printf("Fix {res:%s}.\n", moptimize_name_evaluator(M))
}

end
