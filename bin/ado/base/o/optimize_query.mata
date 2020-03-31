*! version 1.1.2  19mar2009
version 10

findfile optimize_include.mata
quietly include `"`r(fn)'"'

local i1 "{col 5}"
local i2 "{col 10}"
local i3 "{col 15}"
local c2 "{col 46}"

mata:

function optimize_query(`OptStruct' S)
{
	real	scalar	i, n, needeval, needparams
	string	scalar	name

	printf("{text}Settings for optimize() {hline}\n\n")
	printf("Version:`c2'{result:%4.2f}\n",
		optimize_version(S))

	printf("\nEvaluator\n")
	name = nameexternal(S.user)
	needeval = name == ""
	if (needeval) {
		printf("`i1'Function:`c2'{error:unknown}\n")
	}
	else {
		printf("`i1'Function:`c2'{result:%s}\n", name)
	}
	printf("`i1'Type:`c2'{result:%s}\n",
		optimize_init_evaluatortype(S))

	n = optimize_init_narguments(S)
	if (n == 0) {
		printf("\nUser-defined arguments:`c2'<none>\n")
	}
	else if (n == 1) {
		name = nameexternal(S.arglist[1])
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
			name = nameexternal(S.arglist[i])
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

	printf("\nConstraints:`c2'%s\n",
		(S.constraints==`OPT_constraints_default'
			? "{text:<none>}" : "{result:yes}"))

	printf("\nOptimization technique:`c2'{result:%s}\n",
		optimize_init_technique(S))
	printf("Singular H method:`c2'{result:%s}\n",
		optimize_init_singularHmethod(S))

	printf("\nConvergence\n")
	printf("`i1'Maximum iterations:`c2'{result:%f}\n",
		optimize_init_conv_maxiter(S))
	printf("`i1'Tolerance for the function value:`c2'{result:%e}\n",
		optimize_init_conv_vtol(S))
	printf("`i1'Tolerance for the parameters:`c2'{result:%e}\n",
		optimize_init_conv_ptol(S))
	printf("`i1'Tolerance for the scaled gradient:`c2'{result:%e}\n",
		optimize_init_conv_nrtol(S))

	printf("\nIteration log\n")
	printf("`i1'Iteration ID:`c2'{result:%s}\n",
		optimize_init_iterid(S))
	printf("`i1'Value ID:`c2'{result:%s}\n",
		optimize_init_valueid(S))
	if (S.utrace != `OPT_tracelvl_default') {
		printf("`i1'Trace level:`c2'{result:%s}\n",
			optimize_init_tracelevel(S))
	}
	else {
		printf("`i1'Trace value:`c2'{result:%s}\n",
			optimize_init_trace_value(S))
		printf("`i1'Trace dots:`c2'{result:%s}\n",
			optimize_init_trace_dots(S))
		printf("`i1'Trace tol:`c2'{result:%s}\n",
			optimize_init_trace_tol(S))
		printf("`i1'Trace step:`c2'{result:%s}\n",
			optimize_init_trace_step(S))
		printf("`i1'Trace params:`c2'{result:%s}\n",
			optimize_init_trace_params(S))
		printf("`i1'Trace gradient:`c2'{result:%s}\n",
			optimize_init_trace_gradient(S))
		printf("`i1'Trace Hessian:`c2'{result:%s}\n",
			optimize_init_trace_Hessian(S))
	}

	printf("\nStarting values\n")
	n = cols(S.p0)
	needparams = n == 0
	if (n==0) {
		printf("`i1'Parameter values:`c2'{error:unknown}\n")
	}
	else if (n==1) {
		printf("`i1'Parameter value:`c2'{result:%g}\n",
			S.p0[1])
	}
	else {
		printf("`i1'Parameter values\n")
		for (i=1; i<=n; i++) {
			printf("`i1'%5.0f:`c2'{result:%g}\n",
				i, S.p0[i])
		}
	}
	printf("`i1'Function value:`c2'{result:%g}\n", S.v0)

	printf("\nCurrent status\n")
	n = cols(S.params)
	if (n==0) {
		printf("`i1'Parameter values:`c2'{error:unknown}\n")
	}
	else if (n==1) {
		printf("`i1'Parameter value:`c2'{result:%g}\n",
			S.params[1])
	}
	else {
		printf("`i1'Parameters values\n")
		for (i=1; i<=n; i++) {
			printf("`i1'%5.0f:`c2'{result:%g}\n",
				i, S.params[i])
		}
	}
	printf("`i1'Function value:`c2'{result:%g}\n",
		optimize_result_value(S))
	if (optimize_result_converged(S)) {
		printf("`i1'Converged:`c2'{result:yes}\n")
		printf("`i1'Iterations:`c2'{result:%f}\n",
			optimize_result_iterations(S))
	}
	else {
		printf("`i1'Converged:`c2'{result:no}\n")
	}

	if (needeval) {
	    printf("\nNote:  The evaluator function has not been specified.")
	}
	if (needparams) {
	    printf("\nNote:  Starting values have not been specified.")
	}
	printf("\n")
}

real scalar optimize_version(`OptStruct' S)	// setting value not allowed
{
	return(S.opt_version)
}

end
