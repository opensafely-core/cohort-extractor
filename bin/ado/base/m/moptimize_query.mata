*! version 1.1.0  01dec2010
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'
findfile moptimize_include.mata
quietly include `"`r(fn)'"'

local i1 "{col 5}"
local i2 "{col 10}"
local i3 "{col 15}"
local c2 "{col 46}"

mata:

function moptimize_query(`MoptStruct' M)
{
	real	scalar	i, n
	real	scalar	j, m
	real	scalar	needeval
	real	vector	b0
	string	scalar	name
	string	vector	names

	printf("{text}\nSettings for moptimize() {hline}\n\n")
	printf("Version:`c2'{result:%4.2f}\n",
		moptimize_version(M))

	printf("\nEvaluator\n")
	printf("`i1'Type:`c2'{result:%s}\n", moptimize_init_evaluatortype(M))
	if (M.st_user != "") {
		name = M.st_user
	}
	else {
		name = nameexternal(M.S.user)
	}
	needeval = name == ""
	if (needeval) {
		printf("`i1'Function:`c2'{error:unknown}\n")
	}
	else {
		printf("`i1'Function:`c2'{result:%s}\n", name)
	}

	printf("\n")
	n = M.ndepvars
	if (n==0) {
		printf("Dependent variables:`c2'<none>\n")
	}
	else if (n==1) {
		name = moptimize_name_depvar(M, 1)
		if (name == "") {
			printf("Dependent variable:`c2'<tmp>\n")
		}
		else {
			printf("Dependent variable:`c2'{result:%s}\n",
				name)
		}
	}
	else {
		printf("Dependent variables\n")
		for (i=1; i<=n; i++) {
			name = moptimize_name_depvar(M, i)
			if (name == "") {
				printf("%5.0f:`c2'<tmp>\n")
			}
			else {
				printf("%5.0f:`c2'{result:%s}\n",
					i, name)
			}
		}
	}

	printf("\n")

	n = moptimize_init_eq_n(M)
	if (n==0) {
		printf("Equations:`c2'none\n")
	}
	for (i=1; i<=n; i++) {
		printf("Equation %f:\n", i)
		if (M.st_eqlist[i] != "") {
			names = tokens(M.st_eqlist[i])
			m = length(names)
			for (j=1; j<=m; j++) {
				printf("`i1'predictor %5.0f:`c2'{result:%s}\n",
					j, names[j])
			}
		}
		else if (M.eqlist[i] != NULL) {
			name = nameexternal(M.eqlist[i])
			printf("`i1'predictors:`c2'{result:%s}\n", name)
		}
		else {
			printf("`i1'predictors:`c2'<none>\n")
		}
		if (M.eqcons[i]) {
			printf("`c2'{res:_cons}\n")
		}
	}

	n = moptimize_init_nuserinfo(M)
	if (n == 0) {
		printf("\nUser-defined information:`c2'<none>\n")
	}
	else if (n == 1) {
		name = nameexternal(M.S.arglist[1])
		if (name == "") {
			printf("\nUser-defined information:`c2'<tmp>\n")
		}
		else {
			printf("\nUser-defined information:`c2'{result:%s}\n",
				name)
		}
	}
	else {
		printf("\nUser-defined information\n")
		for(i=1; i<=n; i++) {
			name = nameexternal(M.S.arglist[i])
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

	if (M.wtype != `OPT_wtype_none') {
		name = opt__wtype(M.S)
		printf("\nWeight type:`c2'{result:%s}s\n", name)
		name = moptimize_name_weight(M)
		if (strlen(name)) {
			printf("Weights:`c2'{result:%s}\n", name)
		}
	}
	else {
		printf("\nWeights:`c2'<none>\n")
	}

	printf("\nOptimization technique:`c2'{result:%s}\n",
		moptimize_init_technique(M))
	printf("Singular H method:`c2'{result:%s}\n",
		moptimize_init_singularHmethod(M))

	printf("\nConvergence\n")
	printf("`i1'Maximum iterations:`c2'{result:%f}\n",
		moptimize_init_conv_maxiter(M))
	printf("`i1'Tolerance for the function value:`c2'{result:%e}\n",
		moptimize_init_conv_vtol(M))
	printf("`i1'Tolerance for the parameters:`c2'{result:%e}\n",
		moptimize_init_conv_ptol(M))
	printf("`i1'Tolerance for the scaled gradient:`c2'{result:%e}\n",
		moptimize_init_conv_nrtol(M))
	printf("`i1'Tolerance for the quasi-scaled gradient:`c2'{result:%e}\n",
		moptimize_init_conv_qtol(M))
	printf("`i1'Warning:`c2'{result:%s}\n",
		moptimize_init_conv_warning(M))

	printf("\nIteration log\n")
	printf("`i1'Value ID:`c2'{result:%s}\n",
		moptimize_init_valueid(M))
	if (M.S.utrace != `OPT_tracelvl_default') {
		printf("`i1'Trace level:`c2'{result:%s}\n",
			moptimize_init_tracelevel(M))
	}
	else {
		printf("`i1'Trace dots:`c2'{result:%s}\n",
			moptimize_init_trace_dots(M))
		printf("`i1'Trace value:`c2'{result:%s}\n",
			moptimize_init_trace_value(M))
		printf("`i1'Trace tol:`c2'{result:%s}\n",
			moptimize_init_trace_tol(M))
		printf("`i1'Trace step:`c2'{result:%s}\n",
			moptimize_init_trace_step(M))
		printf("`i1'Trace coefficients:`c2'{result:%s}\n",
			moptimize_init_trace_coefs(M))
		printf("`i1'Trace gradient:`c2'{result:%s}\n",
			moptimize_init_trace_gradient(M))
		printf("`i1'Trace Hessian:`c2'{result:%s}\n",
			moptimize_init_trace_Hessian(M))
	}

	printf("\nConstraints:`c2'%s\n",
		(M.S.constraints==`OPT_constraints_default'
			? "{text:<none>}" : "{result:yes}"))

	printf("\nSearch for starting values:`c2'{result:%s}\n",
		moptimize_init_search(M))
	if (M.search != `OPT_onoff_off') {
		printf(
		"`i1'Max attempts at feasible values:`c2'{result:%g}\n",
			moptimize_init_search_feasible(M))
		printf(
		"`i1'Random improvement attempts:`c2'{result:%g}\n",
			moptimize_init_search_repeat(M))
		printf(
		"`i1'Rescale values:`c2'{result:%s}\n",
			moptimize_init_search_rescale(M))
		printf(
		"`i1'Use random values:`c2'{result:%s}\n",
			moptimize_init_search_random(M))
	}

	printf("\nStarting values\n")
	b0	= mopt__build_b0(M)
	n	= cols(b0)
	if (n==0) {
		printf("`i1'Coefficient values:`c2'{error:unknown}\n")
	}
	else if (n==1) {
		printf("`i1'Coefficient value:`c2'{result:%g}\n", b0[1])
	}
	else {
		printf("`i1'Coefficient values\n")
		for (i=1; i<=n; i++) {
			printf("`i1'%5.0f:`c2'{result:%g}\n", i, b0[i])
		}
	}
	printf("`i1'Function value:`c2'{result:%g}\n", M.S.v0)

	printf("\nCurrent status\n")
	n = cols(M.S.params)
	if (n==0) {
		printf("`i1'Coefficient values:`c2'{error:unknown}\n")
	}
	else if (n==1) {
		printf("`i1'Coefficient value:`c2'{result:%g}\n", M.S.params[1])
	}
	else {
		printf("`i1'Coefficient values\n")
		for (i=1; i<=n; i++) {
			printf("`i1'%5.0f:`c2'{result:%g}\n",
				i, M.S.params[i])
		}
	}
	printf("`i1'Function value:`c2'{result:%g}\n", M.S.value)
	if (moptimize_result_converged(M)) {
		printf("`i1'Converged:`c2'{result:yes}\n")
		printf("`i1'Iterations:`c2'{result:%f}\n",
			moptimize_result_iterations(M))
	}
	else {
		printf("`i1'Converged:`c2'{result:no}\n")
	}

	if (needeval) {
	    printf("\nNote:  The evaluator function has not been specified.")
	}
	printf("\n")
}

real scalar moptimize_version(`MoptStruct' M)	// setting value not allowed
{
	return(M.mopt_version)
}

end
