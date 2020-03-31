{smcl}
{* *! version 1.2.7  10oct2017}{...}
{cmd:help mata optimize()}{right:{help prdocumented:previously documented}}
{hline}
{* index optimization}{...}
{* index maximization}{...}
{* index minimization}{...}
{* index minimization}{...}
{* index optimize_init_*() functions}{...}
{* index optimize()}{...}
{* index _optimize()}{...}
{* index optimize_evaluate()}{...}
{* index _optimize_evaluate()}{...}
{* index optimize_result_*() functions}{...}
{* index optimize_query()}{...}
{* index Newton-Raphson method}{...}
{* index Davidon-Fletcher-Powell method}{...}
{* index Broyden-Fletcher-Goldfarb-Shanno method}{...}
{* index Berndt-Hall-Hall-Hausman method}{...}
{* index Nelder-Mead method}{...}
{* Marquardt algorithm}{...}
{* steepest descent (ascent)}{...}

{p 0 4 2 0}
{manlink M-5 optimize()} {hline 2} Function optimization

{p 12 12 8}
{it}[The names associated with {bf:optimize()}'s evaluator types was changed
in version 11.
This help file documents {cmd:optimize()}'s old syntax and as such is 
probably of no interest to you.  You do not have to translate calls to
{cmd:optimize()} in old do-files to modern syntax because Stata continues
to understand both old and new syntaxes.   This help file is 
provided for those wishing to debug or understand old code.
Click {help mf_optimize:here} for the help file of the modern 
{cmd:optimize()} command.]{rm}


{title:Syntax}

{pstd}
In the syntax diagrams, click on the [] at the left of the functions to find
out more about them.

{p 6 25 2}
{help optimize_11##i_:[]}{...}
{bind:          }
{it:S} 
{cmd:=}
{cmd:optimize_init()}


{p 6 25 1}
{help optimize_11##i_which:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_which(}{it:S} [{cmd:,}
{c -(}{cmd:"max"} | {cmd:"min"}{c )-}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_evaluator:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_evaluator(}{it:S} [{cmd:,}
{cmd:&}{it:function}{cmd:()}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_evaluator:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_evaluatortype(}{it:S} [{cmd:,}
{it:evaluatortype}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_negH:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_negH(}{it:S}{cmd:,} {...}
{c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_params:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_params(}{it:S} [{cmd:,}
{it:real rowvector initialvalues}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_nmdeltas:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_nmsimplexdeltas(}{it:S} [{cmd:,}
{it:real rowvector delta}]{cmd:)}

{p 6 25 1}
{help optimize_11##i_argument:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_argument(}{it:S}{cmd:,}
{it:real scalar k} [{cmd:,}
{it:X}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_argument:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_narguments(}{it:S} [{cmd:,}
{it:real scalar K}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_cluster:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_cluster(}{it:S}{cmd:,} {it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##i_colstripe:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_colstripe(}{it:S} [{cmd:,} {cmd:stripe}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_technique:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_technique(}{it:S} [{cmd:,}
{it:technique}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_gnweightmatrix:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_gnweightmatrix(}{it:S}{cmd:,} {...}
{it:{help mf_moptimize##def_W:W}}{cmd:)}

{p 6 25 2}
{help optimize_11##i_singularH:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_singularHmethod(}{it:S} [{cmd:,}
{it:singularHmethod}]{cmd:)}

{p 6 25 1}
{help optimize_11##i_maxiter:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_conv_maxiter(}{it:S} [{cmd:,}
{it:real scalar max}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_warning:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_conv_warning(}{it:S}{cmd:,} {...}
{c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_ptol:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_conv_ptol(}{it:S} [{cmd:,}
{it:real scalar ptol}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_ptol:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_conv_vtol(}{it:S} [{cmd:,}
{it:real scalar vtol}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_ptol:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_conv_nrtol(}{it:S} [{cmd:,}
{it:real scalar nrtol}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_ignore:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_conv_ignorenrtol(}{it:S}{cmd:,} {...}
{c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_iterid:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_iterid(}{it:S} [{cmd:,}
{it:string scalar id}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_valueid:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_valueid(}{it:S} [{cmd:,}
{it:string scalar id}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_tracelevel:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_tracelevel(}{it:S} [{cmd:,}
{it:tracelevel}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_trace:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_trace_dots(}{it:S}{cmd:,} {...}
{c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_trace:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_trace_value(}{it:S}{cmd:,} {...}
{c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_trace:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_trace_tol(}{it:S}{cmd:,} {...}
{c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_trace:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_trace_params(}{it:S}{cmd:,} {...}
{c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_trace:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_trace_step(}{it:S}{cmd:,} {...}
{c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_trace:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_trace_gradient(}{it:S}{cmd:,} {...}
{c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_trace:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_trace_Hessian(}{it:S}{cmd:,} {...}
{c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_evaluations:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_evaluations(}{it:S}{cmd:,} {...}
{c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}

{p 6 25 2}
{help optimize_11##i_constr:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_constraints(}{it:S} [{cmd:,}
{it:real matrix Cc}]{cmd:)}

{p 6 25 2}
{help optimize_11##i_verbose:[]}{...}
{it:(varies)}{bind:      }
{cmd:optimize_init_verbose(}{it:S} [{cmd:,}
{it:real scalar verbose}]{cmd:)}


{p 6 25 2}
{help optimize_11##optimize:[]}{...}
{it:real rowvector}
{cmd:optimize(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##_optimize:[]}{...}
{it:real scalar}{bind:  }
{cmd:_optimize(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##eval:[]}{...}
{it:void}{bind:          }
{cmd:optimize_evaluate(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##_eval:[]}{...}
{it:real scalar}{bind:  }
{cmd:_optimize_evaluate(}{it:S}{cmd:)}


{p 6 25 2}
{help optimize_11##r_params:[]}{...}
{it:real rowvector}
{cmd:optimize_result_params(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_value:[]}{...}
{it:real scalar}{bind:   }
{cmd:optimize_result_value(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_value:[]}{...}
{it:real scalar}{bind:   }
{cmd:optimize_result_value0(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_gradient:[]}{...}
{it:real rowvector}
{cmd:optimize_result_gradient(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_scores:[]}{...}
{it:real matrix}{bind:   }
{cmd:optimize_result_scores(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_hessian:[]}{...}
{it:real matrix}{bind:   }
{cmd:optimize_result_Hessian(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_v:[]}{...}
{it:real matrix}{bind:   }
{cmd:optimize_result_V(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_v:[]}{...}
{it:string scalar}{bind: }
{cmd:optimize_result_Vtype(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_v_all:[]}{...}
{it:real matrix}{bind:   }
{cmd:optimize_result_V_oim(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_v_all:[]}{...}
{it:real matrix}{bind:   }
{cmd:optimize_result_V_opg(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_v_all:[]}{...}
{it:real matrix}{bind:   }
{cmd:optimize_result_V_robust(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_iterations:[]}{...}
{it:real scalar}{bind:   }
{cmd:optimize_result_iterations(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_converged:[]}{...}
{it:real scalar}{bind:   }
{cmd:optimize_result_converged(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_ilog:[]}{...}
{it:real colvector}
{cmd:optimize_result_iterationlog(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_evaluations:[]}{...}
{it:real rowvector}{...}
{cmd:optimize_result_evaluations(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_error:[]}{...}
{it:real scalar}{bind:   }
{cmd:optimize_result_errorcode(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_error:[]}{...}
{it:string scalar}{bind: }
{cmd:optimize_result_errortext(}{it:S}{cmd:)}

{p 6 25 2}
{help optimize_11##r_error:[]}{...}
{it:real scalar}{bind:   }
{cmd:optimize_result_returncode(}{it:S}{cmd:)}


{p 6 25 2}
{help optimize_11##query:[]}{...}
{it:void}{bind:          }
{cmd:optimize_query(}{it:S}{cmd:)}


{p 4 4 2}
where {it:S}, if it is declared, should be declared

		{cmd:transmorphic} {it:S}


{p 4 4 2}
and where {it:evaluatortype} optionally specified in 
{cmd:optimize_init_evaluatortype()} is

{col 16}{it:evaluatortype}{col 32}Description
{col 16}{hline 60}
{col 16}{cmd:"d0"}{col 32}{it:function}{cmd:()} returns {it:scalar} value
{col 16}{cmd:"d1"}{col 32}same as {cmd:"d0"} and returns gradient {it:rowvector}
{col 16}{cmd:"d2"}{col 32}same as {cmd:"d1"} and returns Hessian {it:matrix}

{col 16}{cmd:"d1debug"}{col 32}same as {cmd:"d1"} but checks gradient
{col 16}{cmd:"d2debug"}{col 32}same as {cmd:"d2"} but checks gradient and Hessian

{col 16}{cmd:"v0"}{col 32}{it:function}{cmd:()} returns {it:colvector} value
{col 16}{cmd:"v1"}{col 32}same as {cmd:"v0"} and returns score {it:matrix}
{col 16}{cmd:"v2"}{col 32}same as {cmd:"v1"} and returns Hessian {it:matrix}

{col 16}{cmd:"v1debug"}{col 32}same as {cmd:"v1"} but checks gradient
{col 16}{cmd:"v2debug"}{col 32}same as {cmd:"v2"} but checks gradient and Hessian
{col 16}{hline 60}
{col 16}The default is {cmd:"d0"} if not set.


{p 4 4 2}
and 
where {it:technique} optionally specified in {cmd:optimize_init_technique()} is

{col 16}{it:technique}{col 32}Description
{col 16}{hline 54}
{col 16}{cmd:"nr"}{col 32}modified Newton-Raphson
{col 16}{cmd:"dfp"}{col 32}Davidon-Fletcher-Powell
{col 16}{cmd:"bfgs"}{col 32}Broyden-Fletcher-Goldfarb-Shanno
{col 16}{cmd:"bhhh"}{col 32}Berndt-Hall-Hall-Hausman
{col 16}{cmd:"nm"}{col 32}Nelder-Mead
{col 16}{cmd:"gn"}{col 32}Gauss-Newton (quadratic optimization)
{col 16}{hline 54}
{col 16}The default is {cmd:"nr"}.


{p 4 4 2}
and 
where {it:singularHmethod} optionally specified in 
{cmd:optimize_init_singularHmethod()} is

{col 16}{it:singularHmethod}{col 32}Description
{col 16}{hline 54}
{col 16}{cmd:"m-marquardt"}{col 32}modified Marquardt algorithm
{col 16}{cmd:"hybrid"}{col 32}mixture of steepest descent and Newton
{col 16}{hline 54}
{col 16}The default is {cmd:"m-marquardt"} if not set;
{col 16}{cmd:"hybrid"} is equivalent to {cmd:ml}'s {cmd:difficult} option; see {bf:{help ml:[R] ml}}. 


{p 4 4 2}
and 
where {it:tracelevel} optionally specified in 
{cmd:optimize_init_tracelevel()} is

{col 16}{it:tracelevel}{col 32}To be displayed each iteration
{col 16}{hline 54}
{col 16}{cmd:"none"}{col 32}nothing
{col 16}{cmd:"value"}{col 32}function value
{col 16}{cmd:"tolerance"}{col 32}previous + convergence values
{col 16}{cmd:"params"}{col 32}previous + parameter values
{col 16}{cmd:"step"}{col 32}previous + stepping information
{col 16}{cmd:"gradient"}{col 32}previous + gradient vector
{col 16}{cmd:"hessian"}{col 32}previous + Hessian matrix
{col 16}{hline 54}
{col 16}The default is {cmd:"value"} if not set.


{title:Description}

{p 4 4 2}
These functions find parameter vector or scalar {it:p} such that function
{it:f}({it:p}) is a maximum or a minimum.

{p 4 4 2}
{cmd:optimize_init()} begins the definition of a problem and returns 
{it:S}, a problem-description handle set to contain default values.

{p 4 4 2}
The 
{cmd:optimize_init_}{it:*}{cmd:(}{it:S}{cmd:,} ...{cmd:)} functions then allow
you to modify those defaults.  You use these functions to describe your 
particular problem:  to set whether you wish maximization or minimization, 
to set the identity of function {it:f}(), 
to set initial values, and the like.

{p 4 4 2}
{cmd:optimize(}{it:S}{cmd:)} then performs the optimization.  
{cmd:optimize()}
returns {it:real rowvector p} containing the values of the parameters 
that produce a maximum or minimum.

{p 4 4 2}
The {cmd:optimize_result_}{it:*}{cmd:(}{it:S}{cmd:)} functions can then be
used to access other values associated with the solution.

{p 4 4 2}
Usually you would stop there.  In other cases, you could restart
optimization by using the resulting parameter vector as new initial values,
change the optimization technique, and restart the optimization:

		{cmd:optimize_init_param(}{it:S}{cmd:,} {cmd:optimize_result_param(}{it:S}{cmd:))}
		{cmd:optimize_init_technique(}{it:S}{cmd:,} {cmd:"dfp")}
		{cmd:optimize(}{it:S}{cmd:)}

{p 4 4 2}
Aside:

{p 4 4 2}
The {cmd:optimize_init_}{it:*}{cmd:(}{it:S}{cmd:,} ...{cmd:)} functions have
two modes of operation.  Each has an optional argument that you specify to set
the value and that you omit to query the value.
For instance, the full syntax of
{cmd:optimize_init_params()} is

		{it:void} {cmd:optimize_init_params(}{it:S}{cmd:,} {it:real rowvector initialvalues}{cmd:)}

		{it:real rowvector} {cmd:optimize_init_params(}{it:S}{cmd:)}

{p 4 4 2}
The first syntax sets the initial values and returns nothing.
The second syntax returns 
the previously set (or default, if not set) initial values.

{p 4 4 2} All the {cmd:optimize_init_}{it:*}{cmd:(}{it:S}{cmd:,}
...{cmd:)} functions work the same way.


{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help optimize_11##example1:First example}
	{help optimize_11##notation:Notation}
	{help optimize_11##typed:Type d evaluators}
	{help optimize_11##example2:Example of d0, d1, and d2}
	{help optimize_11##debug:d1debug and d2debug}
	{help optimize_11##typev:Type v evaluators}
	{help optimize_11##example3:Example of v0, v1, and v2}

	{help optimize_11##functions:Functions}
	    {help optimize_11##i_:optimize_init()}
	    {help optimize_11##i_which:optimize_init_which()}
	    {help optimize_11##i_evaluator:optimize_init_evaluator() and optimize_init_evaluatortype()}
	    {help optimize_11##i_negH:optimize_init_negH()}
	    {help optimize_11##i_params:optimize_init_params()}
	    {help optimize_11##i_nmdeltas:optimize_init_nmsimplexdeltas()}
	    {help optimize_11##i_argument:optimize_init_argument() and optimize_init_narguments()}
	    {help optimize_11##i_cluster:optimize_init_cluster()}
	    {help optimize_11##i_colstripe:optimize_init_colstripe()}
	    {help optimize_11##i_technique:optimize_init_technique()}
	    {help optimize_11##i_gnweightmatrix:optimize_init_gnweightmatrix()}
	    {help optimize_11##i_singularH:optimize_init_singularHmethod()}
	    {help optimize_11##i_maxiter:optimize_init_conv_maxiter()}
	    {help optimize_11##i_warning:optimize_init_conv_warning()}
	    {help optimize_11##i_ptol:optimize_init_conv_ptol(), ..._vtol(), ..._nrtol()}
	    {help optimize_11##i_ignore:optimize_init_conv_ignorenrtol()}
	    {help optimize_11##i_iterid:optimize_init_iterid()}
	    {help optimize_11##i_valueid:optimize_init_valueid()}
	    {help optimize_11##i_tracelevel:optimize_init_tracelevel()}
{p 12 16 2}{help optimize_11##i_trace:optimize_init_trace_dots(), ..._value(), ..._tol(), ..._step(), ..._gradient(), ..._Hessian()}{p_end}
	    {help optimize_11##i_evaluations:optimize_init_evaluations()}
	    {help optimize_11##i_constr:optimize_init_constraints()}
	    {help optimize_11##i_verbose:optimize_init_verbose()}

	    {help optimize_11##optimize:optimize()}
	    {help optimize_11##_optimize:_optimize()}
	    {help optimize_11##eval:optimize_evaluate()}
	    {help optimize_11##_eval:_optimize_evaluate()}

	    {help optimize_11##r_params:optimize_result_params()}
	    {help optimize_11##r_value:optimize_result_value() and optimize_result_value0()}
	    {help optimize_11##r_gradient:optimize_result_gradient()}
	    {help optimize_11##r_scores:optimize_result_scores()}
	    {help optimize_11##r_hessian:optimize_result_Hessian()}
	    {help optimize_11##r_v:optimize_result_V() and optimize_result_Vtype()}
	    {help optimize_11##r_v_all:optimize_result_V_oim(), ..._opg(), ..._robust()}
	    {help optimize_11##r_iterations:optimize_result_iterations()}
	    {help optimize_11##r_converged:optimize_result_converged()}
	    {help optimize_11##r_ilog:optimize_result_iterationlog()}
	    {help optimize_11##r_evaluations:optimize_result_evaluations()}
	    {help optimize_11##r_error:optimize_result_errorcode(), ..._errortext(), and ..._returncode()}

	    {help optimize_11##query:optimize_query()}


{marker example1}{...}
{title:First example}

{p 4 4 2}
The optimization functions may be used interactively.

{p 4 4 2}
Below we use the functions to 
find the value of {it:x} that maximizes
{it:y} = exp(-{it:x}^2+{it:x}-3):

{* junk1.smcl from optimize.do}{...}
	: {cmd:void myeval(todo, x,  y, g, H)}
	> {cmd:{c -(}}
	>         {cmd:y = exp(-x^2 + x - 3)}
	> {cmd:{c )-}}
	note: argument todo unused
	note: argument g unused
	note: argument H unused

	: {cmd:S = optimize_init()}

	: {cmd:optimize_init_evaluator(S, &myeval())}

	: {cmd:optimize_init_params(S, 0)}

	: {cmd:x = optimize(S)}
	Iteration 0:  f(p) = .04978707
	Iteration 1:  f(p) = .04978708
	Iteration 2:  f(p) = .06381186
	Iteration 3:  f(p) = .06392786
	Iteration 4:  f(p) = .06392786

	: {cmd:x}
	  .5


{marker notation}{...}
{title:Notation}

{p 4 4 2}
We wrote the above in the way that mathematicians think, that is, 
optimizing {it:y}={it:f}({it:x}).  Statisticians, on the other hand,
think of optimizing {it:s}={it:f}({it:b}).  To avoid
favoritism, we will write {it:v}={it:f}({it:p}) and write
the general problem with the following notation:

{p 8 8 2}
Maximize or minimize {it:v} = {it:f}({it:p}),

		{it:v}:  a scalar 

		{it:p}:  1 {it:x} {it:np}

{p 8 8 2}
subject to the constraint {it:C}{it:p'} = {it:c}, 

		{it:C}:  {it:nc x np}       ({it:nc}=0 if no constraints)
		{it:c}:  {it:nc x} 1

{p 8 8 2}
where {it:g}, the gradient vector, is 
{it:g} = {it:f'}({it:p}) = d{it:f}/d{it:p}, 

		{it:g}:  1 {it:x} {it:np}

{p 8 8 2}
and {it:H}, the Hessian matrix, is 
{it:H} = {it:f''}({it:p}) = d^2{it:f}/d{it:p}d{it:p}'

		{it:H}:  {it:np} {it:x} {it:np}


{marker typed}{...}
{title:Type d evaluators}

{p 4 4 2}
You must write an evaluator function to calculate {it:f}() before
you can use the optimization functions.  The example we showed above was of 
what is called a type {cmd:d} evaluator.  Let's stay with that.

{p 4 4 2}
The evaluator function we wrote was 

	{cmd:void myeval(todo, x,  y, g, H)}
	{cmd:{c -(}}
	        {cmd:y = exp(-x^2 + x - 3)}
	{cmd:{c )-}}

{p 4 4 2}
All type {cmd:d} evaluators open the same way, 

	{it:void} {it:evaluator}{cmd:(}{it:todo}{cmd:,} {...}
{it:x}{cmd:,}  {it:y}{cmd:,} {it:g}{cmd:,} {it:H}{cmd:)}

{p 4 4 2}
although what you name the arguments is up to you.  We named the arguments the
way that mathematicians think, although we could just as well have named them
the way that statisticians think:

	{it:void} {it:evaluator}{cmd:(}{it:todo}{cmd:,} {...}
{it:b}{cmd:,}  {it:s}{cmd:,} {it:g}{cmd:,} {it:H}{cmd:)}

{p 4 4 2}
To avoid favoritism, we will write them as 

	{it:void} {it:evaluator}{cmd:(}{it:todo}{cmd:,} {...}
{it:p}{cmd:,}  {it:v}{cmd:,} {it:g}{cmd:,} {it:H}{cmd:)}

{p 4 4 2}
that is, we will think in terms of optimizing 
{it:v}={it:f}({it:p}).


{p 4 4 2}
Here is the full definition of a type {cmd:d} evaluator:

	{hline 62}
	{it:void} {it:evaluator}{cmd:(}{it:real scalar todo}{cmd:,} {...}
{it:real rowvector p}{cmd:,}  {it:v}{cmd:,} {it:g}{cmd:,} {it:H}{cmd:)}

	where {it:v}, {it:g}, and {it:H} are values to be returned:

		{it:v}:  {it:real scalar}
		{it:g}:  {it:real rowvector}
		{it:H}:  {it:real matrix}

	{it:evaluator}{cmd:()} is to fill in {it:v} given the values in {it:p}
	and optionally to fill in {it:g} and {it:H}, depending on the value of
	{it:todo}:

		{it:todo}         Required action by {it:evaluator}{cmd:()}
		{hline 52}
		  0          calculate {it:v}={it:f}({it:p}) and store in {it:v}

                  1          calculate {it:v}={it:f}({it:p}) and {...}
{it:g}={it:f'}({it:p}) and 
                             store in {it:v} and {it:g}

                  2          calculate {it:v}={it:f}({it:p}), {...}
{it:g}={it:f'}({it:p}), and {it:H}={it:f''}({it:p})
                             and store in {it:v}, {it:g}, and {it:H}
		{hline 52}

	{it:evaluator}{cmd:()} may return {it:v}={cmd:.} if {it:f}() cannot be evaluated at {it:p}.
	Then {it:g} and {it:H} need not be filled in even if requested.
	{hline 62}

{p 4 4 2}
An evaluator does not have to be able to do all of this.  In the
first example, {cmd:myeval()} could handle only {it:todo}=0.
There are three types of type {cmd:d} evaluators:

		{cmd:d} type       Capabilities expected of {it:evaluator}{cmd:()}
		{hline 58}
		  {cmd:d0}         can calculate {it:v}={it:f}({it:p})

		  {cmd:d1}         can calculate {it:v}={it:f}({it:p}) {...}
and {it:g}={it:f'}({it:p})

		  {cmd:d2}         can calculate {it:v}={it:f}({it:p}) {...}
and {it:g}={it:f'}({it:p}) and {it:H}={it:f''}({it:p})
		{hline 58}

{p 4 4 2}
{cmd:myeval()} is a type {cmd:d0} evaluator.
Type {cmd:d0} evaluators are never asked to calculate {it:g} or {it:H}.  Type
{cmd:d0} is the default type but, if we were worried that it was not, we could
set the evaluator type before invoking {cmd:optimize()} by coding

		{cmd:optimize_init_evaluatortype(S, "d0")}

{p 4 4 2}
Here are code outlines of the three types of evaluators:

	{hline 50}
	{it:void} {it:d0_evaluator}{cmd:(}{cmd:todo,} {cmd:p,}  {...}
{cmd:v,} {cmd:g,} {cmd:H)}
	{cmd:{c -(}}
		{cmd:v =} ...
	{cmd:{c )-}}
	{hline 50}

	{hline 50}
	{it:void} {it:d1_evaluator}{cmd:(}{cmd:todo,} {cmd:p,}  {...}
{cmd:v,} {cmd:g,} {cmd:H)}
	{cmd:{c -(}}
		{cmd:v =} ...
		{cmd:if (todo>=1) {c -(}}
			{cmd:g =} ...
		{cmd:{c )-}}
	{cmd:{c )-}}
	{hline 50}

	{hline 50}
	{it:void} {it:d2_evaluator}{cmd:(}{cmd:todo,} {cmd:p,}  {...}
{cmd:v,} {cmd:g,} {cmd:H)}
	{cmd:{c -(}}
		{cmd:v =} ...
		{cmd:if (todo>=1) {c -(}}
			{cmd:g =} ...
			{cmd:if (todo==2) {c -(}}
				{cmd:H =} ...
			{cmd:{c )-}}
		{cmd:{c )-}}
	{cmd:{c )-}}
	{hline 50}


{marker example2}{...}
{title:Example of d0, d1, and d2}

{p 4 4 2}
We wish to find the {it:p}_1 and {it:p}_2 corresponding to the maximum of 

                          2     2
		{it:v} = exp(-{it:p}  -  {it:p}  -  {it:p p}  +  {it:p}  -  {it:p}  -  3)
                          1     2     1 2     1     2

{p 4 4 2} 
A {cmd:d0} solution to the problem would be

{* junk2.smcl from optimize.do}{...}
	: {cmd:void eval0(todo, p, v, g, H)}
	> {cmd:{c -(}}
	>         {cmd:v = exp(-p[1]^2 - p[2]^2 - p[1]*p[2] + p[1] - p[2] - 3)}
	> {cmd:{c )-}}
	{txt}note: argument todo unused
	note: argument g unused
	note: argument h unused

	: {cmd:S = optimize_init()}

	: {cmd:optimize_init_evaluator(S, &eval0())}

	: {cmd:optimize_init_params(S, (0,0))}

	: {cmd:p = optimize(S)}
	Iteration 0:  f(p) = {txt: .04978707}  (not concave)
	Iteration 1:  f(p) = {txt: .12513024}
	Iteration 2:  f(p) = {txt: .13495886}
	Iteration 3:  f(p) = {txt: .13533527}
	Iteration 4:  f(p) = {txt: .13533528}

	: {cmd:p}
	{txt}       {txt} 1    2
            {c TLC}{hline 11}{c TRC}
          1 {c |}  {txt} 1   -1{txt}  {c |}
            {c BLC}{hline 11}{c BRC}

{p 4 4 2}
A d1 solution to the problem would be

{* junk3.smcl from optimize.do}{...}
	: {cmd:void eval1(todo, p, v, g, H)}
	> {cmd:{c -(}}
	>         {cmd:v = exp(-p[1]^2 - p[2]^2 - p[1]*p[2] + p[1] - p[2] - 3)}
	>         {cmd:if (todo==1) {c -(}}
	>                 {cmd:g[1] = (-2*p[1] - p[2] + 1)*v}
	>                 {cmd:g[2] = (-2*p[2] - p[1] - 1)*v}
	>         {cmd:{c )-}}
	> {cmd:{c )-}}
	{txt}note: argument H unused

	: {cmd:S = optimize_init()}

	: {cmd:optimize_init_evaluator(S, &eval1())}

	: {cmd:optimize_init_evaluatortype(S, "d1")}{right:// <- important        }

	: {cmd:optimize_init_params(S, (0,0))}

	: {cmd:p = optimize(S)}
	{txt}{txt}Iteration 0:  f(p) = {txt: .04978707}  (not concave)
	Iteration 1:  f(p) = {txt: .12513026}
	Iteration 2:  f(p) = {txt: .13496887}
	Iteration 3:  f(p) = {txt: .13533527}
	Iteration 4:  f(p) = {txt: .13533528}

	: {cmd:p}
	{txt}       {txt} 1    2
	    {c TLC}{hline 11}{c TRC}
	  1 {c |}  {res} 1   -1{txt}  {c |}
	    {c BLC}{hline 11}{c BRC}

{p 4 4 2}
The {cmd:d1} solution is better than the {cmd:d0} solution because it runs faster 
and usually is more accurate.  Type d1 evaluators require more code, 
however, and deriving analytic derivatives is not always possible.

{p 4 4 2}
A {cmd:d2} solution to the problem would be

{* junk4.smcl from optimize.do}{...}
	: {cmd:void eval2(todo, p, v, g, H)}
	> {cmd:{c -(}}
	>         {cmd:v = exp(-p[1]^2 - p[2]^2 - p[1]*p[2] + p[1] - p[2] - 3)}
	>         {cmd:if (todo>=1) {c -(}}
	>                 {cmd:g[1] = (-2*p[1] - p[2] + 1)*v}
	>                 {cmd:g[2] = (-2*p[2] - p[1] - 1)*v}
	>                 {cmd:if (todo==2) {c -(}}
	>                         {cmd:H[1,1] = -2*v + (-2*p[1]-p[2]+1)*g[1]}
	>                         {cmd:H[2,1] = -1*v + (-2*p[2]-p[1]-1)*g[1]}
	>                         {cmd:H[2,2] = -2*v + (-2*p[2]-p[1]-1)*g[2]}
	>                         {cmd:_makesymmetric(H)}
	>                 {cmd:{c )-}}
	>         {cmd:{c )-}}
	> {cmd:{c )-}}

	: {cmd:S = optimize_init()}

	: {cmd:optimize_init_evaluator(S, &eval2())}

	: {cmd:optimize_init_evaluatortype(S, "d2")}{right:// <- important        }

	: {cmd:optimize_init_params(S, (0,0))}

	: {cmd:p = optimize(S)}
	{txt}{txt}Iteration 0:  f(p) = {txt: .04978707}  (not concave)
	Iteration 1:  f(p) = {txt: .12513026}
	Iteration 2:  f(p) = {txt: .13496887}
	Iteration 3:  f(p) = {txt: .13533527}
	Iteration 4:  f(p) = {txt: .13533528}

	: {cmd:p}
	{txt}       {txt} 1    2
	    {c TLC}{hline 11}{c TRC}
	  1 {c |}  {res} 1   -1{txt}  {c |}
	    {c BLC}{hline 11}{c BRC}

{p 4 4 2}
A {cmd:d2} solution is best because it runs fastest and usually is the most
accurate.  Type {cmd:d2} evaluators require the most code, and 
deriving analytic derivatives is not always possible.

{p 4 4 2}
In the {cmd:d2} evaluator {cmd:eval2()}, note our use of {cmd:_makesymmetric()}.
Type {cmd:d2} evaluators are required to return {it:H} as a 
symmetric matrix; filling in 
just the lower or upper triangle is not sufficient.  The easiest way 
to do that is to fill in the lower triangle and then use {cmd:_makesymmetric()}
to reflect the lower off-diagonal elements;
see {bf:{help mf_makesymmetric:[M-5] makesymmetric()}}.


{marker debug}{...}
{title:d1debug and d2debug}

{p 4 4 2}
In addition to evaluator types {cmd:"d0"}, {cmd:"d1"}, and {cmd:"d2"} that 
are specified in {cmd:optimize_init_evaluatortype(}{it:S}{cmd:,}
{it:evaluatortype}{cmd:)}, there are two more:  {cmd:"d1debug"} and 
"{cmd:d2debug}".  They assist in coding {cmd:d1} and {cmd:d2} evaluators.

{p 4 4 2}
In {it:{help optimize_11##example2:Example of d0, d1, and d2}} 
above, we admit that we did not correctly code the functions {cmd:eval1()} and
{cmd:eval2()} at the outset, before you saw them.  In both cases, 
that was because we
had taken the derivatives incorrectly.  The problem was not with our code
but with our math.  {cmd:d1debug} and {cmd:d2debug} helped us find the
problem.

{p 4 4 2}
{cmd:d1debug} is an alternative to {cmd:d1}.  When you code
{cmd:optimize_init_evaluatortype(}{it:S}{cmd:,} {cmd:"d1debug")}, the
derivatives you calculate are not taken seriously.  Instead, {cmd:optimize()}
calculates its own numerical derivatives and uses those.  Each time
{cmd:optimize()} does that, however, it compares your derivatives to the ones
it calculated and gives you a report on how they differ.  If you have coded
correctly, they should not differ by much.

{p 4 4 2}
{cmd:d2debug} does the same thing, but for {cmd:d2} evaluators.  When you code
{cmd:optimize_init_evaluatortype(}{it:S}{cmd:,} {cmd:"d2debug")},
{cmd:optimize()} uses numerical derivatives but, each time, 
{cmd:optimize()} gives you a report on how much your
results for the gradient and for the Hessian 
differ from the numerical calculations.

{p 4 4 2}
For each comparison, {cmd:optimize()} reports just one number:  the
{bf:{help mf_reldif:mreldif()}} between your results and the numerical ones.
When you have done things right, gradient vectors will differ by approximately
1e-12 or less and Hessians will differ by 1e-7 or less.

{p 4 4 2}
When differences are large, you will want to see not only the summary 
comparison but also the full vectors and matrices so that you can compare your 
results element by element with those calculated numerically.  Sometimes 
the error is in one element and not the others.
To do this, set the trace level with
{cmd:optimize_init_tracelevel(}{it:S}{cmd:,} {it:tracelevel}{cmd:)}
before issuing {cmd:optimize()}.  Code 
{cmd:optimize_init_tracelevel(}{it:S}{cmd:,} {cmd:"gradient")} 
to get a full report on the gradient comparison, or set 
{cmd:optimize_init_tracelevel(}{it:S}{cmd:,} {cmd:"hessian")} 
to get a full report on the gradient comparison and the Hessian 
comparison.


{marker typev}{...}
{title:Type v evaluators}

{p 4 4 2}
In some statistical applications, you will find {cmd:v0}, {cmd:v1}, and
{cmd:v2} more convenient to code than {cmd:d0}, {cmd:d1}, and {cmd:d2}.  The
v stands for vector.

{p 4 4 2}
In statistical applications, one tends to think of a dataset of values
arranged in matrix {it:X}, the rows of which are observations.  A function
{bind:{it:h}({it:p}, {it:X}{cmd:[}{it:i}{cmd:,.]})}
can be calculated for each row
separately, and it is the sum of those resulting values that forms the
function {it:f(}{it:p}) that is to be maximized or minimized.

{p 4 4 2}
The {cmd:v0}, {cmd:v1}, and {cmd:v2} methods are for such cases.

{p 4 4 2}
In a type {cmd:d0} evaluator, you return scalar {it:v}={it:f}({it:p}).

{p 4 4 2}
In a type {cmd:v0} evaluator, you return a column vector 
{it:v} such that {cmd:colsum(}{it:v}{cmd:)}={it:f}({it:p}).

{p 4 4 2}
In a type {cmd:d1} evaluator, you return {it:v}={it:f}({it:p})
and you return a row vector {bind:{it:g}={it:f'}({it:p})}.

{p 4 4 2}
In a type {cmd:v1} evaluator, you return {it:v} 
such that {cmd:colsum(}{it:v}{cmd:)}={it:f}({it:p}) and 
you return 
matrix {it:g} such that 
{cmd:colsum(}{it:g}{cmd:)}={it:f'}({it:p}).

{p 4 4 2}
In a type {cmd:d2} evaluator, you return {it:v}={it:f}({it:p}), 
{bind:{it:g}={it:f'}({it:p})}, 
and you return 
{bind:{it:H}={it:f''}({it:p})}.

{p 4 4 2}
In a type {cmd:v2} evaluator, you return {it:v} 
such that {cmd:colsum(}{it:v}{cmd:)}={it:f}({it:p}), 
{it:g} such that {cmd:colsum(}{it:g}{cmd:)}={it:f'}({it:p}), 
and you return 
{bind:{it:H}={it:f''}({it:p})}.  This is the same {it:H} returned 
for {cmd:d2}. 

{p 4 4 2}
The code outline for type {cmd:v} evaluators is the same as those for {cmd:d}
evaluators.  For instance, the outline for a {cmd:v2} evaluator is 

	{hline 50}
	{it:void} {it:v2_evaluator}{cmd:(}{cmd:todo,} {cmd:p,}  {...}
{cmd:v,} {cmd:g,} {cmd:H)}
	{cmd:{c -(}}
		{cmd:v =} ...
		{cmd:if (todo>=1) {c -(}}
			{cmd:g =} ...
			{cmd:if (todo==2) {c -(}}
				{cmd:H =} ...
			{cmd:{c )-}}
		{cmd:{c )-}}
	{cmd:{c )-}}
	{hline 50}

{p 4 4 2}
The above is the same as the outline for {cmd:d2} evaluators.  All that 
differs is that {it:v} and {it:g}, which were {it:real scalar} and 
{it:real rowvector} in the {cmd:d2} case, are now {it:real colvector} and 
{it:real matrix} in the {cmd:v2} case.  The same applies to {cmd:v1} and
{cmd:v0}.

{p 4 4 2}
The type v evaluators arise in statistical applications and, in such
applications, there are data; that is, just knowing {it:p} is
not sufficient to calculate {it:v}, {it:g}, and {it:H}.
Actually, that same problem can arise when coding type {cmd:d} evaluators 
as well.

{p 4 4 2}
You can pass extra arguments to evaluators, whether they be {cmd:d0}, {cmd:d1},
or {cmd:d2} or {cmd:v0}, {cmd:v1}, or {cmd:v2}.  The first line of all
evaluators, regardless of style, is 

		{it:void} {it:evaluator}{cmd:(}{it:todo}{cmd:,} {...}
{it:p}{cmd:,}{...}
  {it:v}{cmd:,} {it:g}{cmd:,} {it:H}{cmd:)}

{p 4 4 2}
If you code 

	{cmd:optimize_init_argument(}{it:S}{cmd:,} {cmd:1,} {it:X}{cmd:)} 

{p 4 4 2}
the first line becomes 
	
		{it:void} {it:evaluator}{cmd:(}{it:todo}{cmd:,} {...}
{it:p}{cmd:,}  {it:X}{cmd:,}{...}
  {it:v}{cmd:,} {it:g}{cmd:,} {it:H}{cmd:)}

{p 4 4 2}
If you code 

	{cmd:optimize_init_argument(}{it:S}{cmd:,} {cmd:1,} {it:X}{cmd:)} 
	{cmd:optimize_init_argument(}{it:S}{cmd:,} {cmd:2,} {it:Y}{cmd:)} 

{p 4 4 2}
the first line becomes 

		{it:void} {it:evaluator}{cmd:(}{it:todo}{cmd:,} {...}
{it:p}{cmd:,}  {it:X}{cmd:,} {it:Y}{cmd:,}{...}
  {it:v}{cmd:,} {it:g}{cmd:,} {it:H}{cmd:)}

{p 4 4 2}
and so on, up to nine extra arguments.  
That is, you can specify extra arguments to be passed to 
your function.


{marker example3}{...}
{title:Example of v0, v1, and v2}

{p 4 4 2}
You have the following data:

{* junk5.smcl from optimize.do}{...}
	: {cmd:x}
	{txt}        {txt}  1
	     {c TLC}{hline 7}{c TRC}
	   1 {c |}  {txt}.35{txt}  {c |}
	   2 {c |}  {txt}.29{txt}  {c |}
	   3 {c |}  {txt} .3{txt}  {c |}
	   4 {c |}  {txt} .3{txt}  {c |}
	   5 {c |}  {txt}.65{txt}  {c |}
	   6 {c |}  {txt}.56{txt}  {c |}
	   7 {c |}  {txt}.37{txt}  {c |}
	   8 {c |}  {txt}.16{txt}  {c |}
	   9 {c |}  {txt}.26{txt}  {c |}
	  10 {c |}  {txt}.19{txt}  {c |}
	     {c BLC}{hline 7}{c BRC}

{p 4 4 2}
You believe that the data are the result of a beta distribution process with
fixed parameters alpha and beta and you wish to obtain the maximum likelihood
estimates of alpha and beta ({it:a} and {it:b} in what follows).  The formula
for the density of the beta distribution is

			            Gamma({it:a}+{it:b})      {it:a}-1      {it:b}-1
		density({it:x}) =   -----------------   {it:x}    (1-{it:x})
			       Gamma({it:a}) Gamma({it:b})

{p 4 4 2}
The v0 solution to this problem is

{* junk6.smcl from optimize.do}{...}
	: {cmd:void lnbetaden0(todo, p,  x,  lnf, S, H)}
	> {cmd:{c -(}}
	>         {cmd:a   = p[1]}
	>         {cmd:b   = p[2]}
	>         {cmd:lnf = lngamma(a+b) :- lngamma(a) :- lngamma(b) :+}
	>               {cmd:(a-1)*log(x) :+ (b-1)*log(1:-x)}
	> {cmd:{c )-}}
	{txt}note: argument todo unused
	note: argument S unused
	note: argument H unused

	: {cmd:S = optimize_init()}

	: {cmd:optimize_init_evaluator(S, &lnbetaden0())}

	: {cmd:optimize_init_evaluatortype(S, "v0")}

	: {cmd:optimize_init_params(S, (1,1))}

	: {cmd:optimize_init_argument(S, 1, x)}{right:// <- important        }

	: {cmd:p = optimize(S)}
	{txt}{txt}Iteration 0:  f(p) = {txt:         0}
	Iteration 1:  f(p) = {txt: 5.7294728}
	Iteration 2:  f(p) = {txt: 5.7646641}
	Iteration 3:  f(p) = {txt: 5.7647122}
	Iteration 4:  f(p) = {txt: 5.7647122}

	: {cmd:p}
	{txt}       {txt}          1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  {res}3.714209592   7.014926315{txt}  {c |}
	    {c BLC}{hline 29}{c BRC}

{p 4 4 2}
Note the following:

{p 8 12 2}
1.  Rather than calling the returned value {cmd:v}, we called it 
    {cmd:lnf}.  You can name the arguments as you please.

{p 8 12 2}
2.  We arranged for an extra argument to be passed by coding 
    {cmd:optimize_init_argument(S,} {cmd:1,} {cmd:x)}.  The extra argument
    is the vector {cmd:x}, which we listed previously for you.
    In our function, we received the argument as {cmd:x}, but we 
    could have used a different name, just as we used {cmd:lnf} 
    rather than {cmd:v}.

{p 8 12 2}
3.  We set the evaluator type to {cmd:"v0"}.

{p 4 4 2}
This being a statistical problem, we should be interested not only in the
estimates {cmd:p} but also in their variance.  We can get this from the
inverse of the negative Hessian, which is the observed information matrix:

{* junk7.smcl from optimize.do}{...}
	: {cmd:optimize_result_V_oim(S)}
	{res}{txt}[symmetric]
	                 1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  {res}2.556301184              {txt}  {c |}
	  2 {c |}  {res}4.498194785   9.716647065{txt}  {c |}
	    {c BLC}{hline 29}{c BRC}

{p 4 4 2}
The {cmd:v1} solution to this problem is

{* junk8.smcl from optimize.do}{...}
	: {cmd:void lnbetaden1(todo, p,  x,  lnf, S, H)}
	> {cmd:{c -(}}
	>         {cmd:a   = p[1]}
	>         {cmd:b   = p[2]}
	>         {cmd:lnf = lngamma(a+b) :- lngamma(a) :- lngamma(b) :+}
	>               {cmd:(a-1)*log(x) :+ (b-1)*log(1:-x) }
	>         {cmd:if (todo >= 1) {c -(}}
	>                 {cmd:S       = J(rows(x), 2, .)}
	>                 {cmd:S[.,1]  = log(x) :+ digamma(a+b) :- digamma(a)}
	>                 {cmd:S[.,2]  = log(1:-x) :+ digamma(a+b) :- digamma(b)}
	>         {cmd:{c )-}}
	> {cmd:{c )-}}
	{txt}note: argument H unused

	: {cmd:S = optimize_init()}

	: {cmd:optimize_init_evaluator(S, &lnbetaden1())}

	: {cmd:optimize_init_evaluatortype(S, "v1")}

	: {cmd:optimize_init_params(S, (1,1))}

	: {cmd:optimize_init_argument(S, 1, x)}

	: {cmd:p = optimize(S)}
	{txt}{txt}Iteration 0:  f(p) = {txt:         0}
	Iteration 1:  f(p) = {txt: 5.7297061}
	Iteration 2:  f(p) = {txt: 5.7641349}
	Iteration 3:  f(p) = {txt: 5.7647121}
	Iteration 4:  f(p) = {txt: 5.7647122}

	: {cmd:p}
	{txt}       {txt}          1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  {txt}3.714209343   7.014925751{txt}  {c |}
	    {c BLC}{hline 29}{c BRC}

	: {cmd:optimize_result_V_oim(S)}
	{txt}{txt}[symmetric]
                 1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  {txt}2.556299425              {txt}  {c |}
	  2 {c |}  {txt} 4.49819212   9.716643068{txt}  {c |}
	    {c BLC}{hline 29}{c BRC}

{p 4 4 2}
Note the following:

{p 8 12 2}
1.  We called the next-to-last argument of {cmd:lnbetaden1()} 
    {cmd:S} rather than {cmd:g} in accordance with standard statistical 
    jargon.  What is being returned is in fact the observation-level 
    scores, which sum to the gradient vector.

{p 8 12 2}
2.  We called the next-to-last argument {cmd:S} 
    even though that name conflicted with {cmd:S} outside the program, 
    where {cmd:S} is the problem handle.  Perhaps we should have renamed 
    the outside {cmd:S}, but there is no confusion on Mata's part.

{p 8 12 2}
3.  In our program we allocated {it:S} for ourselves:  
    {cmd:S} = {cmd:J(rows(x),} {cmd:2,} {cmd:.)}.
    It is worth comparing this with 
    the example of {cmd:d1} in 
    {it:{help optimize_11##example2:Example of d0, d1, and d2}}, 
    where we did not need to allocate {cmd:g}.
    In {cmd:d1}, {cmd:optimize()} preallocates {cmd:g} for us.
    In {cmd:v1}, {cmd:optimize()} cannot do this because it has 
    no idea how many "observations" we have.


{p 4 4 2}
The {cmd:v2} solution to this problem is

{* junk9.smcl from optimize.do}{...}
	: {cmd:void lnbetaden2(todo, p,  x,  lnf, S, H)}
	> {cmd:{c -(}}
	>         {cmd:a   = p[1]}
	>         {cmd:b   = p[2]}
	>         {cmd:lnf = lngamma(a+b) :- lngamma(a) :- lngamma(b) :+}
	>               {cmd:(a-1)*log(x) :+ (b-1)*log(1:-x) }
	>         {cmd:if (todo >= 1) {c -(}}
	>                 {cmd:S       = J(rows(x), 2, .)}
	>                 {cmd:S[.,1]  = log(x) :+ digamma(a+b) :- digamma(a)}
	>                 {cmd:S[.,2]  = log(1:-x) :+ digamma(a+b) :- digamma(b)}
	>                 {cmd:if (todo==2) {c -(}}
	>                         {cmd:n = rows(x)}
	>                         {cmd:H[1,1] = n*(trigamma(a+b) - trigamma(a))}
	>                         {cmd:H[2,1] = n*(trigamma(a+b))}
	>                         {cmd:H[2,2] = n*(trigamma(a+b) - trigamma(b))}
	>                         {cmd:_makesymmetric(H)}
	>                 {cmd:{c )-}}
	>         {cmd:{c )-}}
	> {cmd:{c )-}}

	: {cmd:S = optimize_init()}

	: {cmd:optimize_init_evaluator(S, &lnbetaden2())}

	: {cmd:optimize_init_evaluatortype(S, "v2")}

	: {cmd:optimize_init_params(S, (1,1))}

	: {cmd:optimize_init_argument(S, 1, x)}

	: {cmd:p = optimize(S)}
	{txt}{txt}Iteration 0:  f(p) = {txt:         0}
	Iteration 1:  f(p) = {txt: 5.7297061}
	Iteration 2:  f(p) = {txt: 5.7641349}
	Iteration 3:  f(p) = {txt: 5.7647121}
	Iteration 4:  f(p) = {txt: 5.7647122}

	: {cmd:p}
	{res}       {txt}          1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  {txt}3.714209343   7.014925751{txt}  {c |}
	    {c BLC}{hline 29}{c BRC}

	: {cmd:optimize_result_V_oim(S)}}
	{txt}{txt}[symmetric]
	                 1             2
	    {c TLC}{hline 29}{c TRC}
	  1 {c |}  {txt}2.556299574              {txt}  {c |}
	  2 {c |}  {txt}4.498192412   9.716643651{txt}  {c |}
	    {c BLC}{hline 29}{c BRC}


{marker functions}{...}
{title:Functions}

{marker i_}{...}
{title:optimize_init()}

{p 8 12 2}
{it:transmorphic} 
{cmd:optimize_init()}

{p 4 4 2}
{cmd:optimize_init()} is used to begin an optimization problem.  Store the
returned result in a variable name of your choosing; we have used 
{it:S} in this documentation.  You pass {it:S} 
as the first argument to the other {cmd:optimize}{it:*}{cmd:()} functions.

{p 4 4 2}
{cmd:optimize_init()} sets all {cmd:optimize_init_}{it:*}{cmd:()} values to
their defaults.  You may use the query form of the
{cmd:optimize_init_}{it:*}{cmd:()} to determine an individual default, or you
can use {cmd:optimize_query()} to see them all.

{p 4 4 2}
The query form of 
{cmd:optimize_init_}{it:*}{cmd:()} 
can be used before or after optimization performed by {cmd:optimize()}.


{marker i_which}{...}
{title:optimize_init_which()}

{p 8 12 2}
{it:void}{bind:         }
{cmd:optimize_init_which(}{it:S}{cmd:,}
{c -(}{cmd:"max"} | {cmd:"min"}{c )-} {cmd:)}

{p 8 12 2}
{it:string scalar}
{cmd:optimize_init_which(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_init_which(}{it:S}{cmd:,}
{it:which}{cmd:)}
specifies whether {cmd:optimize()} is to perform maximization or 
minimization.  The default is maximization if you do not invoke this function.

{p 4 4 2}
{cmd:optimize_init_which(}{it:S}{cmd:)}
returns {cmd:"max"} or {cmd:"min"} according to which is currently set.


{marker i_evaluator}{...}
{title:optimize_init_evaluator() and optimize_init_evaluatortype()}

{p 8 12 2}
{it:void}
{cmd:optimize_init_evaluator(}{it:S}{cmd:,}
{it:pointer(real function) scalar fptr}{cmd:)}

{p 8 25 2}
{it:void}
{cmd:optimize_init_evaluatortype(}{it:S}{cmd:,}
{it:evaluatortype}{cmd:)}


{p 8 12 2}
{it:pointer(real function) scalar}
{cmd:optimize_init_evaluator(}{it:S}{cmd:)}

{p 8 25 2}
{it:string scalar}{bind:                }
{cmd:optimize_init_evaluatortype(}{it:S}{cmd:)}


{p 4 4 2}
{cmd:optimize_init_evaluator(}{it:S}{cmd:,}
{it:fptr}{cmd:)} specifies the function to be called to evaluate 
{it:f}({it:p}).  Use of this function is required.
If your function is named {cmd:myfcn()}, you code 
{cmd:optimize_init_evaluator(}{it:S}{cmd:,} {cmd:&myfcn())}.

{p 4 4 2}
{cmd:optimize_init_evaluatortype(}{it:S}{cmd:,}
{it:evaluatortype}{cmd:)}
specifies the capabilities of the function that has been set using
{cmd:optimize_init_evaluator()}.
Alternatives for {it:evaluatortype} are 
{cmd:"d0"}, 
{cmd:"d1"}, 
{cmd:"d2"}, 
{cmd:"d1debug"}, 
{cmd:"d2debug"}, 
{cmd:"v0"}, 
{cmd:"v1"}, 
{cmd:"v2"}, 
{cmd:"v1debug"}, 
and
{cmd:"v2debug"}.
The default is {cmd:"d0"} if you do not invoke this function.

{p 4 4 2}
{cmd:optimize_init_evaluator(}{it:S}{cmd:)}
returns a pointer to the function that has been set.

{p 4 4 2}
{cmd:optimize_init_evaluatortype(}{it:S}{cmd:)}
returns the {it:evaluatortype} currently set.


{marker i_negH}{...}
{title:optimize_init_negH()}

{pstd}
{cmd:optimize_init_negH(}{it:S}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    sets whether the evaluator you have
    written returns {it:H} or -{it:H}, the Hessian or the negative
    of the Hessian, if it returns a Hessian at all.
    This is for backward compatibility with prior versions of
    Stata's {bf:{help ml:ml}} command.  Modern evaluators return
    {it:H}.  The default is {cmd:"off"}.


{marker i_params}{...}
{title:optimize_init_params()}

{p 8 8 2}
{it:void}{bind:          }
{cmd:optimize_init_params(}{it:S}{cmd:,}
{it:real rowvector initialvalues}{cmd:)}

{p 8 8 2}
{it:real rowvector}
{cmd:optimize_init_params(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_init_params(}{it:S}{cmd:,}
{it:initialvalues}{cmd:)} sets the values of {it:p} to be used 
at the start of the first iteration.  
Use of this function is required.

{p 4 4 2}
{cmd:optimize_init_params(}{it:S}{cmd:)}
returns the initial values that will be (or were) used.


{marker i_nmdeltas}{...}
{title:optimize_init_nmsimplexdeltas()}

{p 8 8 2}
{it:void}{bind:          }
{cmd:optimize_init_nmsimplexdeltas(}{it:S}{cmd:,}
{it:real rowvector delta}{cmd:)}

{p 8 8 2}
{it:real rowvector}
{cmd:optimize_init_nmsimplexdeltas(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_init_nmsimplexdeltas(}{it:S}{cmd:,}
{it:delta}{cmd:)} sets the values of {it:delta} to be used, along 
with the initial parameters, to build the simplex
required by technique {cmd:"nm"} (Nelder-Mead).
Use of this function is required only in the Nelder-Mead case.
The values in {it:delta} must be at least 10 times larger than {it:ptol},
which is set by {cmd:optimize_init_conv_ptol()}.
The initial simplex will be 
{c -(}{it:p}, {it:p}+({it:d}_1,0,...0), 
{it:p}+(0,{it:d}_2,0,...,0),
..., 
{it:p}+(0,0,...,0,{it:d}_{it:k}){c )-}.

{p 4 4 2}
{cmd:optimize_init_nmsimplexdeltas(}{it:S}{cmd:)}
returns the deltas that will be (or were) used.


{marker i_argument}{...}
{title:optimize_init_argument() and optimize_init_narguments()}

{p 8 8 2}
{it:void}{bind:          }
{cmd:optimize_init_argument(}{it:S}{cmd:,}
{it:real scalar k}{cmd:,}
{it:X}{cmd:)}

{p 8 8 2}
{it:void}{bind:          }
{cmd:optimize_init_narguments(}{it:S}{cmd:,}
{it:real scalar K}{cmd:)}

{p 8 8 2}
{it:pointer scalar}
{cmd:optimize_init_argument(}{it:S}{cmd:,}
{it:real scalar k}{cmd:)}

{p 8 8 2}
{it:real scalar}{bind:   }
{cmd:optimize_init_narguments(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_init_argument(}{it:S}{cmd:,} {it:k}{cmd:,} {it:X}{cmd:)}
sets the {it:k}th extra argument of the evaluator function to be {it:X},
where {it:k} can only be 1, 2, ..., 9.
{it:X} can be anything, including a view matrix or even a pointer to a
function.  No copy of {it:X} is made; it is a pointer to {it:X} that is
stored, so any changes you make to {it:X} between setting it and {it:X} being
used will be reflected in what is passed to the evaluator function.

{p 4 4 2}
{cmd:optimize_init_narguments(}{it:S}{cmd:,} {it:K}{cmd:)} sets the number of
extra arguments to be passed to the evaluator function.  This function is
useless and included only for completeness.  The number of extra arguments is
automatically set as you use {cmd:optimize_init_argument()}.

{p 4 4 2}
{cmd:optimize_init_argument(}{it:S}{cmd:)} returns a pointer to the object
that was previously set.

{p 4 4 2}
{cmd:optimize_init_nargs(}{it:S}{cmd:)} returns the number of extra arguments
that are passed to the evaluator function.


{marker i_cluster}{...}
{title:optimize_init_cluster()}

{pstd}
{cmd:optimize_init_cluster(}{it:S}{cmd:,} {it:c}{cmd:)} specifies a cluster
    variable.  {it:c} may be a string scalar containing a Stata
    variable name, or {it:c} may be real colvector directly containing the
    cluster values.  The default is {cmd:""}, meaning no clustering.  If
    clustering is specified, the default {it:vcetype} becomes {cmd:"robust"}.


{marker i_colstripe}{...}
{title:optimize_init_colstripe()}

{pstd}
{cmd:optimize_init_colstripe(}{it:S} [{cmd:, stripe}]{cmd:)} sets the string
	  matrix to be associated with the parameter vector.  See
          {cmd:matrix colnames} in {manhelp matrix_rownames P:matrix rownames}.


{marker i_technique}{...}
{title:optimize_init_technique()}

{p 8 25 2}
{it:void}{bind:         }
{cmd:optimize_init_technique(}{it:S}{cmd:,}
{it:string scalar technique}{cmd:)}

{p 8 25 2}
{it:string scalar}
{cmd:optimize_init_technique(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_init_technique(}{it:S}{cmd:,} {it:technique}{cmd:)} sets the
optimization technique to be used.  Current choices are

{col 16}{it:technique}{col 32}Description
{col 16}{hline 54}
{col 16}{cmd:"nr"}{col 32}modified Newton-Raphson
{col 16}{cmd:"dfp"}{col 32}Davidon-Fletcher-Powell
{col 16}{cmd:"bfgs"}{col 32}Broyden-Fletcher-Goldfarb-Shanno
{col 16}{cmd:"bhhh"}{col 32}Berndt-Hall-Hall-Hausman
{col 16}{cmd:"nm"}{col 32}Nelder-Mead
{col 16}{cmd:"gn"}{col 32}Gauss-Newton (quadratic optimization)
{col 16}{hline 54}
{col 16}The default is {cmd:"nr"}.

{p 4 4 2}
{cmd:optimize_init_technique(}{it:S}{cmd:)} 
returns the technique currently set.

{p 4 4 2}
{it:Aside:}  All techniques require 
{cmd:optimize_init_params()} be set.
Technique {cmd:"nm"} also requires that
{cmd:optimize_init_nmsimplexdeltas()} 
be set.
Parameters (and delta) can be set before or after the technique is set.

{pstd}
You can switch between
{cmd:"nr"},
{cmd:"dfp"},
{cmd:"bfgs"}, and
{cmd:"bhhh"}
by specifying two or more of them in a space-separated list.
By default, {cmd:optimize()} will use an
algorithm for five iterations before switching to the next algorithm.  To
specify a different number of iterations, include the number after the
technique.  For example, specifying
{cmd:optimize_init_technique(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
{cmd:"bhhh 10 nr 1000")} requests that {cmd:optimize()} perform 10 iterations
using the Berndt-Hall-Hall-Hausman algorithm, followed by 1,000 iterations
using the modified Newton-Raphson algorithm, and then switch back to
Berndt-Hall-Hall-Hausman for 10 iterations, and so on.  The process continues
until {help mf_moptimize##syn_convergence:convergence} or until
{it:{help optimize_11##i_maxiter:maxiter}} is exceeded.


{marker i_gnweightmatrix}{...}
{title:optimize_init_gnweightmatrix()}

{pstd}
{cmd:optimize_init_gnweightmatrix(}{it:S}{cmd:,}{...}
 {it:{help mf_moptimize##def_W:W}}{cmd:)}
    sets real matrix {it:W}: {it:L} {it:x} {it:L}, which is used only by type
    {cmd:q} evaluators.  The objective function is {it:r}'{it:W}{it:r}.
    If {it:W} is not set and if observation weights {it:w} are set using
    {bf:{help mf_moptimize##init_weight:moptimize_init_weight()}},
    then {it:W} = diag({it:w}).  If {it:w} is not set, then {it:W} is the
    identity matrix.


{marker i_singularH}{...}
{title:optimize_init_singularHmethod()}

{p 8 25 2}
{it:void}{bind:         }
{cmd:optimize_init_singularHmethod(}{it:S}{cmd:,}
{it:string scalar method}{cmd:)}

{p 8 25 2}
{it:string scalar}
{cmd:optimize_init_singularHmethod(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_init_singularHmethod(}{it:S}{cmd:,} {it:method}{cmd:)}
specifies what the optimizer should do when, at an iteration step, it finds
that {it:H} is singular.  Current choices are

{col 16}{it:method}{col 32}Description
{col 16}{hline 54}
{col 16}{cmd:"m-marquardt"}{col 32}modified Marquardt algorithm
{col 16}{cmd:"hybrid"}{col 32}mixture of steepest descent and Newton
{col 16}{hline 54}
{col 16}The default is {cmd:"m-marquardt"} if not set;
{col 16}{cmd:"hybrid"} is equivalent to {cmd:ml}'s {cmd:difficult} option; see {bf:{help ml:[R] ml}}. 

{p 4 4 2}
{cmd:optimize_init_technique(}{it:S}{cmd:)} 
returns the {it:method} currently set.


{marker i_maxiter}{...}
{title:optimize_init_conv_maxiter()}

{p 8 25 2}
{it:void}{bind:      }
{cmd:optimize_init_conv_maxiter(}{it:S}{cmd:,} {it:real scalar max}{cmd:)}

{p 8 25 2}
{it:real scalar}
{cmd:optimize_init_conv_maxiter(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_init_conv_maxiter(}{it:S}{cmd:,} {it:max}{cmd:)}
sets the maximum number of iterations to be performed before
{cmd:optimization()} is stopped; results are posted to
{cmd:optimize_result_}{it:*}{cmd:()} just as if convergence were achieved, but
{cmd:optimize_result_converged()} is set to 0.  The default {it:max} if not
set is {cmd:c(maxiter)}, which is probably 16,000; type {cmd:creturn}
{cmd:list} in Stata to determine the current default value.

{p 4 4 2}
{cmd:optimize_init_conv_maxiter(}{it:S}{cmd:)} 
returns the {it:max} currently set.


{marker i_warning}{...}
{title:optimize_init_conv_warning()}

{pstd}
{cmd:optimize_init_conv_warning(}{it:S}{cmd:,}
     {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)} specifies whether
     the warning message "convergence not achieved" is to be displayed
     when this stopping rule is invoked.  The default is {cmd:"on"}.


{marker i_ptol}{...}
{title:optimize_init_conv_ptol(), ..._vtol(), ..._nrtol()}

{p 8 25 2}
{it:void}{bind:       }
{cmd:optimize_init_conv_ptol(}{it:S}{cmd:,}
{it:real scalar ptol}{cmd:)}

{p 8 25 2}
{it:void}{bind:       }
{cmd:optimize_init_conv_vtol(}{it:S}{cmd:,}
{it:real scalar vtol}{cmd:)}

{p 8 25 2}
{it:void}{bind:       }
{cmd:optimize_init_conv_nrtol(}{it:S}{cmd:,}
{it:real scalar nrtol}{cmd:)}


{p 8 25 2}
{it:real scalar}
{cmd:optimize_init_conv_ptol(}{it:S}{cmd:)}

{p 8 25 2}
{it:real scalar}
{cmd:optimize_init_conv_vtol(}{it:S}{cmd:)}

{p 8 25 2}
{it:real scalar}
{cmd:optimize_init_conv_nrtol(}{it:S}{cmd:)}

{p 4 4 2}
The two-argument form of these functions
set the tolerances that control {cmd:optimize()}'s convergence criterion.
{cmd:optimize()} performs iterations until the convergence criterion is met or
until the number of iterations exceeds {cmd:optimize_init_conv_maxiter()}.
When the convergence criterion is met, {cmd:optimize_result_converged()} is
set to 1.  The default values of {it:ptol}, {it:vtol}, and {it:nrtol} are
1e-6, 1e-7, and 1e-5, respectively.

{p 4 4 2}
The single-argument form of these functions
return the current values of {it:ptol}, {it:vtol}, and {it:nrtol}.

{p 4 4 2}
{it:Optimization criterion:}
In all cases except 
{cmd:optimize_init_technique(}{it:S}{cmd:)}=={cmd:"nm"}, that is, 
in all cases except Nelder-Mead, that is, in all cases of 
derivative-based maximization, the optimization criterion is defined 
as follows:

{p 12 12 2}
Define

		    {it:C_ptol}:     {cmd:mreldif(}{it:p}, {it:p_prior}{cmd:)} < {it:ptol}

		    {it:C_vtol}:     {cmd:reldif(}{it:v}, {it:v_prior}{cmd:)} < {it:vtol}
	
		    {it:C_nrtol}:    {it:g}*{cmd:invsym(}-{it:H}{cmd:)}*{it:g}' < {it:nrtol}

        	    {it:C_concave}: -{it:H} is positive semidefinite

{p 12 12 2}
The above definitions apply for maximization.  For
minimization, think of it as maximization of -{it:f}({it:p}).
{cmd:optimize()} declares convergence when

		    ({it:C_ptol} | {it:C_vtol}) & {it:C_concave} & {it:C_nrtol}


{p 4 4 2}
For
{cmd:optimize_init_technique(}{it:S}{cmd:)}=={cmd:"nm"}
(Nelder-Mead), the criterion is defined as follows:

{p 12 12 2}
Let {it:R} be the 
minimum and maximum values on the simplex and define 

		    {it:C_ptol}:  {cmd:mreldif(}vertices of {it:R}{cmd:)} < {it:ptol}

		    {it:C_vtol}:  {cmd:reldif(}{it:R}{cmd:)} < {it:vtol}

{p 12 12 2}
{cmd:optimize()} declares successful convergence when

		{it:C_ptol} | {it:C_vtol}


{marker i_ignore}{...}
{title:optimize_init_conv_ignorenrtol()}

{p 8 25 2}
{cmd:optimize_init_conv_ignorenrtol(}{it:S}{cmd:,}
     {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)} sets whether
     {it:C_nrtol} should simply be treated as true in all cases, which in
     effects removes the {it:nrtol} criterion from the convergence rule.
     The default is {cmd:"off"}.


{marker i_iterid}{...}
{title:optimize_init_iterid()}

{p 8 25 2}
{it:void}{bind:         }
{cmd:optimize_init_iterid(}{it:S}{cmd:,}
{it:string scalar id}{cmd:)}

{p 8 25 2}
{it:string scalar}
{cmd:optimize_init_iterid(}{it:S}{cmd:)}

{p 4 4 2}
By default, {cmd:optimize()} shows an iteration log, a line of which looks
like

		{cmd:Iteration 1:  f(p) = 5.7641349}

{p 4 4 2}
See {it:{help optimize_11##i_trace:optimize_init_tracelevel()}}
below.

{p 4 4 2}
{cmd:optimize_init_iterid(}{it:S}{cmd:,} {it:id}{cmd:)}
sets the string used to label the iteration in the iteration log.
The default is {cmd:"Iteration"}.

{p 4 4 2}
{cmd:optimize_init_iterid(}{it:S}{cmd:)}
returns the {it:id} currently in use.


{marker i_valueid}{...}
{title:optimize_init_valueid()}

{p 8 25 2}
{it:void}{bind:         }
{cmd:optimize_init_valueid(}{it:S}{cmd:,}
{it:string scalar id}{cmd:)}

{p 8 25 2}
{it:string scalar}
{cmd:optimize_init_valueid(}{it:S}{cmd:)}

{p 4 4 2}
By default, {cmd:optimize()} shows an iteration log, a line of which looks
like

		{cmd:Iteration 1:  f(p) = 5.7641349}

{p 4 4 2}
See {it:{help optimize_11##i_tracelevel:optimize_init_tracelevel()}}
below.

{p 4 4 2}
{cmd:optimize_init_valueid(}{it:S}{cmd:,} {it:id}{cmd:)}
sets the string used to identify the value.  The default is 
{cmd:"f(p)"}.

{p 4 4 2}
{cmd:optimize_init_valueid(}{it:S}{cmd:)}
returns the {it:id} currently in use.


{marker i_tracelevel}{...}
{title:optimize_init_tracelevel()}

{p 8 25 2}
{it:void}{bind:         }
{cmd:optimize_init_tracelevel(}{it:S}{cmd:,}
{it:string scalar tracelevel}{cmd:)}

{p 8 25 2}
{it:string scalar}
{cmd:optimize_init_tracelevel(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_init_tracelevel(}{it:S}{cmd:,} {it:tracelevel}{cmd:)}
sets what is displayed in the iteration log.  Allowed values of 
{it:tracelevel} are 

{col 16}{it:tracelevel}{col 32}To be displayed each iteration
{col 16}{hline 54}
{col 16}{cmd:"none"}{col 32}nothing (suppress the log)
{col 16}{cmd:"value"}{col 32}function value
{col 16}{cmd:"tolerance"}{col 32}previous + convergence values
{col 16}{cmd:"params"}{col 32}previous + parameter values
{col 16}{cmd:"step"}{col 32}previous + stepping information
{col 16}{cmd:"gradient"}{col 32}previous + gradient vector
{col 16}{cmd:"hessian"}{col 32}previous + Hessian matrix
{col 16}{hline 54}
{col 16}The default is {cmd:"value"} if not reset.

{p 4 4 2}
{cmd:optimize_init_tracelevel(}{it:S}{cmd:)} 
returns the value of {it:tracelevel} currently set.


{marker i_trace}{...}
{title:optimize_init_trace_dots(), ..._value(), ..._tol(), ..._params(), ..._step(), ..._gradient(), ..._Hessian()}

{pstd}
{cmd:optimize_init_trace_dots(}{it:S}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays a dot each time your evaluator is called.
    The default is {cmd:"off"}.

{pstd}
{cmd:optimize_init_trace_value(}{it:S}{cmd:,}
    {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
    displays the function value at the start of each iteration.
    The default is {cmd:"on"}.

{pstd}
{cmd:optimize_init_trace_tol(}{it:S}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the value of the calculated result that is compared
    to the effective {help mf_moptimize##syn_convergence:convergence}
    criterion at the end of each iteration.  The default is {cmd:"off"}.

{pstd}
{cmd:optimize_init_trace_params(}{it:S}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the parameters at the start of each iteration.
    The default is {cmd:"off"}.

{pstd}
{cmd:optimize_init_trace_step(}{it:S}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the steps within iteration.  Listed are the value of
    objective function along with the word forward or backward.  The default is
    {cmd:"off"}.

{pstd}
{cmd:optimize_init_trace_gradient(}{it:S}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the gradient vector at the start of each iteration.
    The default is {cmd:"off"}.

{pstd}
{cmd:optimize_init_trace_Hessian(}{it:S}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the Hessian matrix at the  start of each iteration.
    The default is {cmd:"off"}.


{marker i_evaluations}{...}
{title:optimize_init_evaluations()}

{pstd}
{cmd:optimize_init_evaluations(}{it:S}{cmd:,}
     {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)} specifies whether the system is
     to count the number of times the
     {help mf_moptimize##syn_alleval:evaluator}
     is called.  The default is {cmd:"off"}.


{marker i_constr}{...}
{title:optimize_init_constraints()}

{p 8 25 2}
{it:void}{bind:       }
{cmd:optimize_init_constraints(}{it:S}{cmd:,}
{it:real matrix Cc}{cmd:)}

{p 8 25 2}
{it:real matrix}
{cmd:optimize_init_constraints(}{it:S}{cmd:)}

{p 4 4 2}
{it:nc} 
linear constraints may be imposed on the {it:np} parameters in {it:p} 
according to 
{it:C}{it:p'}={it:c}, 
{it:C}: {it:nc} {it:x} {it:np} and {it:c:} {it:nc} {it:x} 1.
For instance, if there are four parameters and you wish to 
impose the single constraint {it:p}_1={it:p}_2, then 
{bind:{it:C} = (1,-1,0,0)} and {bind:{it:c} = (0)}.
If you wish to add the constraint {it:p}_4=2, then 
{bind:{it:C} = (1,-1,0,0 \ 0,0,0,1)} and {bind:{it:c} = (0 \ 2)}.

{p 4 4 2}
{cmd:optimize_init_constraints(}{it:S}{cmd:,}
{it:Cc}{cmd:)} allows you to impose such constraints where 
{it:Cc} = ({it:C}, {it:c}).  Use of this function is optional.
If no constraints have been set, then {it:Cc} is 0 {it:x} ({it:np}+1).

{p 4 4 2}
{cmd:optimize_init_constraints(}{it:S}{cmd:)}
returns the current {it:Cc} matrix.


{marker i_verbose}{...}
{title:optimize_init_verbose()}

{p 8 25 2}
{it:void}{bind:        }
{cmd:optimize_init_verbose(}{it:S}{cmd:,}
{it:real scalar verbose}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind: }
{cmd:optimize_init_verbose(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_init_verbose(}{it:S}{cmd:,}
{it:verbose}{cmd:)} sets whether error messages that arise during the
execution of {cmd:optimize()} or {cmd:_optimize()} are to be displayed.
{it:verbose}=1 means that they are; 0 means that they are not.
The default is 1.  Setting {it:verbose} to 0 is of 
interest only to users of {cmd:_optimize()}.
If you wish to suppress all output, code 

		{cmd:optimize_init_verbose(}{it:S}{cmd:, 0)}
		{cmd:optimize_init_tracelevel(}{it:S}{cmd:, "none")}

{p 4 4 2}
{cmd:optimize_init_verbose(}{it:S}{cmd:)}
returns the current value of {it:verbose}.


{marker optimize}{...}
{title:optimize()}

{p 8 12 2}
{it:real rowvector} 
{cmd:optimize(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize(}{it:S}{cmd:)} invokes the optimization process and returns the
resulting parameter vector.  If something goes wrong, 
{cmd:optimize()} aborts with error.

{p 4 4 2}
Before you can invoke {cmd:optimize()}, you must have defined your evaluator
function {it:evaluator}{cmd:()} and you must have set initial values:

{col 17}{it:S} {cmd:= optimize_init()}
{col 17}{cmd:optimize_init_evaluator(}{it:S}{cmd:, &}{it:evaluator}{cmd:())}
{col 17}{cmd:optimize_init_params(}{it:S}{cmd:, (}...{cmd:))}

{p 4 4 2}
The above assumes that your evaluator function is {cmd:d0}.  Often you 
will also have coded

{col 17}{cmd:optimize_init_evaluatortype(}{it:S}{cmd:, "}...{cmd:"))}

{p 4 4 2}
and you may have coded other {cmd:optimize_init_}{it:*}{cmd:()} 
functions as well.

{p 4 4 2}
Once {cmd:optimize()} completes, you may use 
the {cmd:optimize_result_}{it:*}{cmd:()} functions.
You may also continue to use the 
{cmd:optimize_init_}{it:*}{cmd:()} functions 
to access initial settings, and you may use them to change settings 
and restart optimization (that is, invoke {cmd:optimize()} again) if you 
wish.  If you do that, you will usually want to use the resulting 
parameter values from the first round of optimization as initial 
values for the second.  If so, do not forget to code

{col 17}{cmd:optimize_init_params(}{it:S}{cmd:, optimize_result_params(}{it:S}{cmd:))}


{marker _optimize}{...}
{title:_optimize()}

{p 8 12 2}
{it:real scalar} 
{cmd:_optimize(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:_optimize(}{it:S}{cmd:)} performs the same actions as
{cmd:optimize(}{it:S}{cmd:)} except that, rather than returning the resulting
parameter vector, {cmd:_optimize()} returns a real scalar and, rather than
aborting if numerical issues arise, {cmd:_optimize()} returns a nonzero value.
{cmd:_optimize()} returns 0 if all went well.  The returned value is called
an error code.

{p 4 4 2}
{cmd:optimize()} returns the resulting parameter vector {it:p}.  It can 
work that way because optimization must have gone well.  Had it not,
{cmd:optimize()} would have aborted execution.

{p 4 4 2}
{cmd:_optimize()} returns an error code.  If it is 0, optimization 
went well and you can obtain the parameter vector by using 
{bf:{help optimize_11##r_params:optimize_result_param()}}.
If optimization did not go well, you can 
use the error code to diagnose what went wrong and take the appropriate 
action.

{p 4 4 2}
Thus, {cmd:_optimize(}{it:S}{cmd:)} is an alternative to
{cmd:optimize(}{it:S}{cmd:)}.  Both functions do the
same thing.  The difference is what happens when there are numerical
difficulties.

{p 4 4 2}
{cmd:optimize()} and {cmd:_optimize()} work around most numerical
difficulties.  For instance, the evaluator function you write is allowed to
return {it:v} equal to missing if it cannot calculate the {it:f}() at the
current values of {it:p}.  If that happens during optimization,
{cmd:optimize()} and {cmd:_optimize()} will back up to the last value that
worked and choose a different direction.  {cmd:optimize()}, however, cannot
tolerate that happening with the initial values of the parameters because
{cmd:optimize()} has no value to back up to.  {cmd:optimize()} issues an error
message and aborts, meaning that execution is stopped.  There can be
advantages in that.  The calling program need not include complicated code for
such instances, figuring that stopping is good enough because a human will
know to address the problem.

{p 4 4 2}
{cmd:_optimize()}, however, does not stop execution.
Rather than aborting, 
{cmd:_optimize()} 
returns a nonzero value to the caller, identifying what went wrong.

{p 4 4 2}
Programmers implementing advanced systems will want to use {cmd:_optimize()}
instead of {cmd:optimize()}.  Everybody else should use {cmd:optimize()}.

{p 4 4 2}
Programmers using {cmd:_optimize()} will also be interested in the 
functions 
{it:{help optimize_11##i_verbose:optimize_init_verbose()}}, 
{it:{help optimize_11##r_error:optimize_result_errorcode()}}, 
{it:{help optimize_11##r_error:optimize_result_errortext()}},
and
{it:{help optimize_11##r_error:optimize_result_returncode()}}.

{p 4 4 2}
If you perform optimization by using {cmd:_optimize()}, the behavior of 
all {cmd:optimize_result_}{it:*}{cmd:()} functions is altered.
The usual behavior is that, if calculation is required and 
numerical problems arise, 
the functions abort with error.
After {cmd:_optimize()}, however, 
a properly dimensioned missing result is returned and 
{cmd:optimize_result_errorcode()} and 
{cmd:optimize_result_errortext()} are set appropriately.

{p 4 4 2}
The error codes returned by {cmd:_optimize()} are
listed under the heading
{it:{help optimize_11##r_error:optimize_result_errorcode()}}
below.


{marker eval}{...}
{title:optimize_evaluate()}

{p 8 25 2}
{it:void}
{cmd:optimize_evaluate(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_evaluate(}{it:S}{cmd:)}
evaluates {it:f}() at 
{cmd:optimize_init_params()}
and posts results to 
{cmd:optimize_result_}{it:*}{cmd:()}
just as if optimization had been performed, 
meaning that all {cmd:optimize_result_}{it:*}{cmd:()} functions are 
available for use.
{cmd:optimize_result_converged()} is set to 1.

{p 4 4 2}
The setup for running this function is the same as for running 
{cmd:optimize()}: 

{col 17}{it:S} {cmd:= optimize_init()}
{col 17}{cmd:optimize_init_evaluator(}{it:S}{cmd:, &}{it:evaluator}{cmd:())}
{col 17}{cmd:optimize_init_params(}{it:S}{cmd:, (}...{cmd:))}

{p 4 4 2}
Usually, you will have also coded 

{col 17}{cmd:optimize_init_evaluatortype(}{it:S}{cmd:,} ...{cmd:))}

{p 4 4 2}
The other {cmd:optimize_init_}{it:*}{cmd:()} settings do not matter.


{marker _eval}{...}
{title:_optimize_evaluate()}

{p 8 25 2}
{it:real scalar}
{cmd:_optimize_evaluate(}{it:S}{cmd:)}

{p 4 4 2}
The relationship between
{cmd:_optimize_evaluate()} and 
{cmd:optimize_evaluate()} is the same as that between 
{cmd:_optimize()} and 
{cmd:optimize()}; 
see {it:{help optimize_11##_optimize:_optimize()}}.

{p 4 4 2}
{cmd:_optimize_evaluate()} returns an error code.


{marker r_params}{...}
{title:optimize_result_params()}

{p 8 25 2}
{it:real rowvector}
{cmd:optimize_result_params(}{it:S}{cmd:)}


{p 4 4 2}
{cmd:optimize_result_params(}{it:S}{cmd:)}
returns the resulting parameter values.  These are the same values 
that were returned by {cmd:optimize}{cmd:()} itself.  There is 
no computational cost to accessing the results, so rather than 
coding 

		{it:p} {cmd:= optimize(}{it:S}{cmd:)}

{p 4 4 2}
if you find it more convenient to code

		{cmd:(void) optimize(}{it:S}{cmd:)}
		...
		{it:p} {cmd:= optimize_result_params(}{it:S}{cmd:)}

{p 4 4 2}
then do so.


{marker r_value}{...}
{title:optimize_result_value() and optimize_result_value0()}

{p 8 25 2}
{it:real scalar}
{cmd:optimize_result_value(}{it:S}{cmd:)}

{p 8 25 2}
{it:real scalar}
{cmd:optimize_result_value0(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_result_value(}{it:S}{cmd:)} returns the value of {it:f}()
evaluated at {it:p} equal to {cmd:optimize_result_param()}.

{p 4 4 2}
{cmd:optimize_result_value0(}{it:S}{cmd:)} returns the value of {it:f}()
evaluated at {it:p} equal to {cmd:optimize_init_param()}.

{p 4 4 2}
These functions may be called regardless of the evaluator or technique used.


{marker r_gradient}{...}
{title:optimize_result_gradient()}

{p 8 25 2}
{it:real rowvector}
{cmd:optimize_result_gradient(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_result_gradient(}{it:S}{cmd:)}
returns the value of the gradient vector evaluated
at {it:p} equal to {cmd:optimize_result_param()}.
This function may be called regardless of the evaluator or technique used.


{marker r_scores}{...}
{title:optimize_result_scores()}

{p 8 25 2}
{it:real matrix}
{cmd:optimize_result_scores(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_result_scores(}{it:S}{cmd:)}
returns the value of the scores 
evaluated at {it:p} equal to {cmd:optimize_result_param()}.
This function may be called only if a type {cmd:v} evaluator is used, but 
regardless of the technique used.


{marker r_hessian}{...}
{title:optimize_result_Hessian()}

{p 8 25 2}
{it:real matrix}
{cmd:optimize_result_Hessian(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_result_Hessian(}{it:S}{cmd:)}
returns the value of the Hessian matrix evaluated
at {it:p} equal to {cmd:optimize_result_param()}.
This function may be called regardless of the evaluator or technique used.


{marker r_v}{...}
{title:optimize_result_V() and optimize_V_Vtype()}

{p 8 25 2}
{it:real matrix}{bind:  }
{cmd:optimize_result_V(}{it:S}{cmd:)}

{p 8 25 2}
{it:string scalar}
{cmd:optimize_result_Vtype(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_result_V(}{it:S}{cmd:)}
returns  
{cmd:optimize_result_V_oim(}{it:S}{cmd:)}
or 
{cmd:optimize_result_V_opg(}{it:S}{cmd:)}, 
depending on which is the natural conjugate for the optimization technique
used.  If there is no natural conjugate,
{cmd:optimize_result_V_oim(}{it:S}{cmd:)} is returned.

{p 4 4 2}
{cmd:optimize_result_Vtype(}{it:S}{cmd:)}
returns {cmd:"oim"} or {cmd:"opg"}.


{marker r_v_all}{...}
{title:optimize_result_V_oim(), ..._opg(), ..._robust()}

{p 8 25 2}
{it:real matrix}
{cmd:optimize_result_V_oim(}{it:S}{cmd:)}

{p 8 25 2}
{it:real matrix}
{cmd:optimize_result_V_opg(}{it:S}{cmd:)}

{p 8 25 2}
{it:real matrix}
{cmd:optimize_result_V_robust(}{it:S}{cmd:)}

{p 4 4 2}
These functions return the variance matrix of {it:p} evaluated 
at {it:p} equal to {cmd:optimize_result_param()}.
These functions are relevant only for 
maximization of log-likelihood functions but may be called in any
context, including minimization.

{p 4 4 2}
{cmd:optimize_result_V_oim(}{it:S}{cmd:)} returns {cmd:invsym(}-{it:H}{cmd:)},
which is the variance matrix obtained from the observed information matrix.
For minimization, returned is 
{cmd:invsym(}{it:H}{cmd:)}.

{p 4 4 2}
{cmd:optimize_result_V_opg(}{it:S}{cmd:)} returns
{cmd:invsym(}{it:S'S}{cmd:)}, where {it:S} is the {it:N x np} matrix of
scores.  This is known as the variance matrix obtained from the outer product
of the gradients.  {cmd:optimize_result_V_opg()} is available only when the
evaluator function is type {cmd:v}, but regardless of the technique used.

{p 4 4 2}
{cmd:optimize_result_V_robust(}{it:S}{cmd:)} returns
{it:H}*{cmd:invsym(}{it:S'S}{cmd:)}*{it:H}, which is the robust estimate of
variance, also known as the sandwich estimator of variance.
{cmd:optimize_result_V_robust()} is available only when the evaluator function
is type {cmd:v}, but regardless of the technique used.


{marker r_iterations}{...}
{title:optimize_result_iterations()}

{p 8 25 2}
{it:real scalar}
{cmd:optimize_result_iterations(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_result_iterations(}{it:S}{cmd:)}
returns the number of iterations used in obtaining results.


{marker r_converged}{...}
{title:optimize_result_converged()}

{p 8 25 2}
{it:real scalar}
{cmd:optimize_result_converged(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_result_converged(}{it:S}{cmd:)}
returns 1 if results converged
and 0 otherwise.
See 
{it:{help optimize_11##i_ptol:optimize_init_conv_ptol()}}
for the definition of convergence.


{marker r_ilog}{...}
{title:optimize_result_iterationlog()}

{p 8 25 2}
{it:real colvector}
{cmd:optimize_result_iterationlog(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_result_iterationlog(}{it:S}{cmd:)}
returns a column vector of 
the values of {it:f}() at the start of the final 20 
iterations, or, if there were fewer, however many iterations there were.
Returned vector is 
min({cmd:optimize_result_iterations()},20) {it:x} 1.


{marker r_evaluations}{...}
{title:optimize_result_evaluations()}

{pstd}
{cmd:optimize_result_evaluations(}{it:S}{cmd:)}
    returns a 1 {it:x} 3 real rowvector containing the number of times
    the {help mf_moptimize##syn_alleval:evaluator} was called, assuming
    {cmd:optimize_init_evaluations()} was set on.
    Contents are the number of times called for the
    purposes of 1) calculating the objective function, 2) calculating the
    objective function and its first derivative, and 3) calculating the
    objective function and its first and second derivatives.
    If {cmd:optimize_init_evaluations()} was set to {cmd:off}, returned is
    (0,0,0).


{marker r_error}{...}
{title:optimize_result_errorcode(), ..._errortext(), and ..._returncode()}

{p 8 25 2}
{it:real scalar}{bind:  }
{cmd:optimize_result_errorcode(}{it:S}{cmd:)}

{p 8 25 2}
{it:string scalar}
{cmd:optimize_result_errortext(}{it:S}{cmd:)}

{p 8 25 2}
{it:real scalar}{bind:  }
{cmd:optimize_result_returncode(}{it:S}{cmd:)}

{p 4 4 2}
These functions are for use after {cmd:_optimize()}.

{p 4 4 2}
{cmd:optimize_result_errorcode(}{it:S}{cmd:)}
returns the error code of {cmd:_optimize()},
{cmd:_optimize_evaluate()},
or the last 
{cmd:optimize_result_}{it:*}{cmd:()} run after either of the 
first two functions.
The value will be zero if there were no errors.
The error codes are listed directly below.

{p 4 4 2}
{cmd:optimize_result_errortext(}{it:S}{cmd:)}
returns a string containing the error message corresponding to the error code.
If the error code is zero, the string will be {cmd:""}.

{p 4 4 2}
{cmd:optimize_result_returncode(}{it:S}{cmd:)}
returns the Stata return code corresponding to the error code.
The mapping is listed directly below.  

{p 4 4 2}
In advanced code, these functions might be used as

		{cmd:(void) _optimize(S)}
		...
		{cmd:if (ec = optimize_result_code(S)) {c -(}}
			{cmd:errprintf("{c -(}p{c )-}\n")}
			{cmd:errprintf("%s\n", optimize_result_errortext(S))}
			{cmd:errprintf("{c -(}p_end{c )-}\n")}
			{cmd:exit(optimize_result_returncode(S))}
			{cmd:/*NOTREACHED*/}
		{cmd:{c )-}}

{p 4 4 2}
{marker error}{...}
The error codes and their corresponding Stata return codes are

	   Error   Return
	   code     code   Error text
	{hline 70}
	     1      1400   initial values not feasible

             2       412   redundant or inconsistent constraints

             3       430   missing values returned by evaluator

             4       430   Hessian is not positive semidefinite
                           {it:or}
                           Hessian is not negative semidefinite

             5       430   could not calculate numerical derivatives --
			   discontinuous region with missing values
			   encountered

             6       430   could not calculate numerical derivatives -- 
			   flat or discontinuous region encountered

             7       430   could not calculate improvement -- 
			   discontinuous region encountered

             8       430   could not calculate improvement --
			   flat region encountered

            10       111   technique unknown

            11       111   incompatible combination of techniques

            12       111   singular H method unknown

            13       198   matrix stripe invalid for parameter vector

            14       198   negative convergence tolerance values are not
                             allowed

            15       503   invalid starting values

            17       111   simplex delta required

            18       3499  simplex delta not conformable with parameter vector

            19       198   simplex delta value too small
                             (must be greater than 10*ptol)

            20       198   evaluator type requires the nr technique

            23       198   evaluator type not allowed with bhhh technique

            24       111   evaluator functions required

            25       198   starting values for parameters required

            26       198   missing parameter values not allowed
	{hline 70}
	NOTES:
          (1)  Error 1 can occur only when evaluating {it:f}() at initial 
               parameters.

	  (2)  Error 2 can occur only if constraints are specified.

	  (3)  Error 3 can occur only if the technique is {cmd:"nm"}.

	  (4)  Error 9 can occur only if technique is {cmd:"bfgs"} or {cmd:"dfp"}.


{marker query}{...}
{title:optimize_query()}

{p 8 25 2}
{it:void}
{cmd:optimize_query(}{it:S}{cmd:)}

{p 4 4 2}
{cmd:optimize_query(}{it:S}{cmd:)} displays a report on all
{cmd:optimize_init_}{it:*}{cmd:()} and {cmd:optimize_result}{it:*}{cmd:()}
values.  {cmd:optimize_query()} may be used before or after {cmd:optimize()}
and is useful when using {cmd:optimize()} interactively or when debugging
a program that calls {cmd:optimize()} or {cmd:_optimize()}.



{title:Conformability}

{p 4 4 2}
All functions have 1 {it:x} 1 inputs and have 
1 {it:x} 1 or {it:void} outputs except
the following:

    {cmd:optimize_init_params(}{it:S}{cmd:,} {it:initialvalues}{cmd:)}:
		{it:S}:  {it:transmorphic}
    {it:initialvalues}:  1 {it:x np}
	   {it:result}:  {it:void}

    {cmd:optimize_init_params(}{it:S}{cmd:)}:
		{it:S}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}

    {cmd:optimize_init_argument(}{it:S}{cmd:,} {it:k}{cmd:,} {it:X}{cmd:)}:
		{it:S}:  {it:transmorphic}
		{it:k}:  1 {it:x} 1
		{it:X}:  {it:anything}
	   {it:result}:  {it:void}

    {cmd:optimize_init_nmsimplexdeltas(}{it:S}{cmd:,} {it:delta}{cmd:)}:
		{it:S}:  {it:transmorphic}
	    {it:delta}:  1 {it:x np}
	   {it:result}:  {it:void}

    {cmd:optimize_init_nmsimplexdeltas(}{it:S}{cmd:)}:
		{it:S}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}

    {cmd:optimize_init_constraints(}{it:S}{cmd:,} {it:Cc}{cmd:)}:
		{it:S}:  {it:transmorphic}
	       {it:Cc}:  {it:nc x} ({it:np}+1)
	   {it:result}:  {it:void}

    {cmd:optimize_init_constraints(}{it:S}{cmd:)}:
		{it:S}:  {it:transmorphic}
	   {it:result}:  {it:nc x} ({it:np}+1)

    {cmd:optimize(}{it:S}{cmd:)}:
		{it:S}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}

    {cmd:optimize_result_params(}{it:S}{cmd:)}:
		{it:S}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}

    {cmd:optimize_result_gradient(}{it:S}{cmd:)}:
		{it:S}:  {it:transmorphic}
	   {it:result}:  1 {it:x np}

    {cmd:optimize_result_scores(}{it:S}{cmd:)}:
		{it:S}:  {it:transmorphic}
	   {it:result}:  {it:N x np}

    {cmd:optimize_result_Hessian(}{it:S}{cmd:)}:
		{it:S}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

{p 4 4 2}
    {cmd:optimize_result_V(}{it:S}{cmd:)}, 
    {cmd:optimize_result_V_oim(}{it:S}{cmd:)},
    {cmd:optimize_result_V_opg(}{it:S}{cmd:)}, 
    {cmd:optimize_result_V_robust(}{it:S}{cmd:)}:
{p_end}
		{it:S}:  {it:transmorphic}
	   {it:result}:  {it:np x np}

    {cmd:optimize_result_iterationlog(}{it:S}{cmd:)}:
		{it:S}:  {it:transmorphic}
	   {it:result}:  {it:L x} 1, {it:L} <= 20


{title:Diagnostics}

{p 4 4 2}
All functions abort with error when used incorrectly.

{p 4 4 2}
{cmd:optimize()} aborts with error if it runs into numerical difficulties.
{cmd:_optimize()} does not; it instead returns a nonzero error code.

{p 4 4 2}
{cmd:optimize_evaluate()} aborts with error if it runs into numerical
difficulties.  {cmd:_optimize_evaluate()} does not; it instead returns a
nonzero error code.

{p 4 4 2}
The {cmd:optimize_result_}{it:*}{cmd:()} functions abort with error if 
they run into numerical difficulties when called after 
{cmd:optimize()} or {cmd:optimize_evaluate()}.  They do not abort 
when run after {cmd:_optimize()} or {cmd:_optimize_evaluate()}.
They instead return a properly dimensioned missing result and 
set {cmd:optimize_result_errorcode()} and 
{cmd:optimize_result_errortext()}.


{title:Source code}

{p 4 4 2}
{view optimize_include.mata, adopath asis:optimize_include.mata},
{view optimize_init.mata, adopath asis:optimize_init.mata}, 
{view optimize_query.mata, adopath asis:optimize_query.mata}, 
{view optimize.mata, adopath asis:optimize.mata}, 
{view optimize_result.mata, adopath asis:optimize_result.mata}, 
{view optimize_utilities.mata, adopath asis:optimize_utilities.mata}


{title:Also see}

{p 4 13 2}
Manual:  {manlink M-5 optimize()}

{p 4 13 2}
{space 2}Help:   
{bf:{help m4_mathematical:[M-4] mathematical}},
{bf:{help m4_statistical:[M-4] statistical}}
{p_end}
