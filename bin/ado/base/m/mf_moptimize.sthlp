{smcl}
{* *! version 1.3.8  04feb2020}{...}
{vieweralsosee "[M-5] moptimize()" "mansection M-5 moptimize()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] optimize()" "help mf_optimize"}{...}
{vieweralsosee "[M-5] Quadrature()" "help mf_quadrature"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Mathematical" "help m4_mathematical"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] set iter" "help set_iter"}{...}
{viewerjumpto "Syntax" "mf_moptimize##syntax"}{...}
{viewerjumpto "Description" "mf_moptimize##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_moptimize##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_moptimize##remarks"}{...}
{viewerjumpto "Conformability" "mf_moptimize##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_moptimize##diagnostics"}{...}
{viewerjumpto "Source code" "mf_moptimize##source"}{...}
{viewerjumpto "Reference" "mf_moptimize##reference"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] moptimize()} {hline 2}}Model optimization
{p_end}
{p2col:}({mansection M-5 moptimize():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
{it}If you are reading this entry for the first time, skip down to 
{bf:{help mf_moptimize##description:Description}}
and to 
{bf:{help mf_moptimize##remarks:Remarks}}, and more especially, to
{help mf_moptimize##rem_math:Mathematical statement of the moptimize() problem}
under {bf:Remarks}.{rm}

{p 4 4 2}
Syntax is presented under the following headings:

	{help mf_moptimize##syn_step1:Step 1:  Initialization}
	{help mf_moptimize##syn_step2:Step 2:  Definition of maximization or minimization problem}
	{help mf_moptimize##syn_step3:Step 3:  Perform optimization or perform a single function evaluation}
	{help mf_moptimize##syn_step4:Step 4:  Post, display, or obtain results}

	{help mf_moptimize##syn_stepall:Utility functions for use in all steps}

	{help mf_moptimize##syn_M:Definition of M}
	{help mf_moptimize##syn_sample:Setting the sample}
	{help mf_moptimize##syn_dependent:Specifying dependent variables}
	{help mf_moptimize##syn_independent:Specifying independent variables}
	{help mf_moptimize##syn_constraints:Specifying constraints}
	{help mf_moptimize##syn_weights:Specifying weights or survey data}
	{help mf_moptimize##syn_clusters:Specifying clusters and panels}
	{help mf_moptimize##syn_technique:Specifying optimization technique}
	{help mf_moptimize##syn_initial:Specifying initial values}
	{help mf_moptimize##syn_one:Performing one evaluation of the objective function}
	{help mf_moptimize##syn_opt:Performing optimization of the objective function}
	{help mf_moptimize##syn_trace:Tracing optimization}
	{help mf_moptimize##syn_convergence:Specifying convergence criteria}
	{help mf_moptimize##syn_results:Accessing results}
	{help mf_moptimize##syn_ado_cleanup:Stata evaluators}
	{help mf_moptimize##syn_advanced:Advanced functions}

	{help mf_moptimize##syn_alleval:Syntax of evaluators}
	{help mf_moptimize##syn_lf:Syntax of type lf evaluators}
	{help mf_moptimize##syn_dstar:Syntax of type d evaluators}
	{help mf_moptimize##syn_lfstar:Syntax of type lf* evaluators}
	{help mf_moptimize##syn_gfstar:Syntax of type gf evaluators}
	{help mf_moptimize##syn_qstar:Syntax of type q evaluators}
	{help mf_moptimize##syn_extra:Passing extra information to evaluators}

	{help mf_moptimize##syn_util:Utility functions}


{marker syn_step1}{...}
    {title:Step 1:  Initialization}

{col 19}{...}
{it:{help mf_moptimize##def_M:M}} {...}
{cmd:=} {...}
{cmd:moptimize_init()}


{marker syn_step2}{...}
    {title:Step 2:  Definition of maximization or minimization problem}

{p 13 13 8}
{it}In each of the functions, the last argument is optional.
If specified, the function sets the value and returns {it:void}.
If not specified, no change is made, and instead what is currently
set is returned.{rm}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_which:{bf:moptimize_init_which(}{it:M}{bf:,} {c -(}{bf:"max"}|{bf:"min"}{c )-}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_evaluator:{bf:moptimize_init_evaluator(}{it:M}{bf:,} {bf:&}{it:functionname}{bf:()}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_evaluator:{bf:moptimize_init_evaluator(}{it:M}{bf:,} {bf:"}{it:programname}{bf:")}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_evaluatortype:{bf:moptimize_init_evaluatortype(}{it:M}{bf:,} {it:evaluatortype}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_negH:{bf:moptimize_init_negH(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_touse:{bf:moptimize_init_touse(}{it:M}{bf:,} {bf:"}{it:tousevarname}{bf:")}}


{col 9}{...}
{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_ndepvars:{bf:moptimize_init_ndepvars(}{it:M}{bf:,} {it:D}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_depvar:{bf:moptimize_init_depvar(}{it:M}{bf:,} {it:j}{bf:,} {it:y}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_eq_n:{bf:moptimize_init_eq_n(}{it:M}{bf:,} {it:m}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_independent:{bf:moptimize_init_eq_indepvars(}{it:M}{bf:,} {it:i}{bf:,} {it:X}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_independent:{bf:moptimize_init_eq_cons(}{it:M}{bf:,} {it:i}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_independent:{bf:moptimize_init_eq_offset(}{it:M}{bf:,} {it:i}{bf:,} {it:o}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_independent:{bf:moptimize_init_eq_exposure(}{it:M}{bf:,} {it:i}{bf:,} {it:t}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_independent:{bf:moptimize_init_eq_name(}{it:M}{bf:,} {it:i}{bf:,} {it:name}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_independent:{bf:moptimize_init_eq_colnames(}{it:M}{bf:,} {it:i}{bf:,} {it:names}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_independent:{bf:moptimize_init_eq_freeparm(}{it:M}{bf:,} {it:i}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_initial:{bf:moptimize_init_eq_coefs(}{it:M}{bf:,} {it:i}{bf:,} {it:b0}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_constraints:{bf:moptimize_init_constraints(}{it:M}{bf:,} {it:Cc}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_search:{bf:moptimize_init_search(}{it:M}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_search:{bf:moptimize_init_search_random(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_search:{bf:moptimize_init_search_repeat(}{it:M}{bf:,} {it:nr}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_search:{bf:moptimize_init_search_bounds(}{it:M}{bf:,} {it:i}{bf:,} {it:minmax}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_search:{bf:moptimize_init_search_rescale(}{it:M}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_weight:{bf:moptimize_init_weight(}{it:M}{bf:,} {it:w}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_weight:{bf:moptimize_init_weighttype(}{it:M}{bf:,} {it:weighttype}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_cluster:{bf:moptimize_init_cluster(}{it:M}{bf:,} {it:c}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_svy:{bf:moptimize_init_svy(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_by:{bf:moptimize_init_by(}{it:M}{bf:,} {it:by}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_userinfo:{bf:moptimize_init_nuserinfo(}{it:M}{bf:,} {it:n_user}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_userinfo:{bf:moptimize_init_userinfo(}{it:M}{bf:,} {it:l}{bf:,} {it:Z}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_technique:{bf:moptimize_init_technique(}{it:M}{bf:,} {it:technique}{bf:)}}
 
{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_vcetype:{bf:moptimize_init_vcetype(}{it:M}{bf:,} {it:vcetype}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_nmsimplexdeltas:{bf:moptimize_init_nmsimplexdeltas(}{it:M}{bf:,} {it:delta}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_gnweightmatrix:{bf:moptimize_init_gnweightmatrix(}{it:M}{bf:,} {it:W}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##def_singularHmethod:{bf:moptimize_init_singularHmethod(}{it:M}{bf:,} {it:singularHmethod}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_convergence:{bf:moptimize_init_conv_maxiter(}{it:M}{bf:,} {it:maxiter}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{col 6}{help mf_moptimize##syn_convergence:{bf:moptimize_init_conv_warning(}{it:M}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_convergence:{bf:moptimize_init_conv_ptol(}{it:M}{bf:,} {it:ptol}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_convergence:{bf:moptimize_init_conv_vtol(}{it:M}{bf:,} {it:vtol}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_convergence:{bf:moptimize_init_conv_nrtol(}{it:M}{bf:,} {it:nrtol}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_convergence:{bf:moptimize_init_conv_ignorenrtol(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}



{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_iterid:{bf:moptimize_init_iterid(}{it:M}{bf:,} {it:id}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_valueid:{bf:moptimize_init_valueid(}{it:M}{bf:,} {it:id}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_tracelevel(}{it:M}{bf:,} {it:tracelevel}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_trace_ado(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_trace_dots(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_trace_value(}{it:M}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_trace_tol(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_trace_step(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_trace_coefdiffs(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_trace_coefs(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_trace_gradient(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}

{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##syn_trace:{bf:moptimize_init_trace_Hessian(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{col 6}{help mf_moptimize##init_evaluations:{bf:moptimize_init_evaluations(}{it:M}{bf:,} {c -(}{bf:"off"}|{bf:"on"}{c )-}{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##init_verbose:{bf:moptimize_init_verbose(}{it:M}{bf:,} {c -(}{bf:"on"}|{bf:"off"}{c )-}{bf:)}}


{marker syn_step3}{...}
    {title:Step 3:  Perform optimization or perform a single function evaluation}

{col 9}{...}
{it:void}{...}
{col 24}{...}
{help mf_moptimize##syn_opt:{bf:moptimize(}{it:M}{bf:)}}

{col 9}{...}
{it:real scalar}{...}
{col 23}{...}
{help mf_moptimize##syn_opt:{bf:_moptimize(}{it:M}{bf:)}}

{col 9}{...}
{it:void}{...}
{col 24}{...}
{help mf_moptimize##syn_one:{bf:moptimize_evaluate(}{it:M}{bf:)}}

{col 9}{...}
{it:real scalar}{...}
{col 23}{...}
{help mf_moptimize##syn_one:{bf:_moptimize_evaluate(}{it:M}{bf:)}}


{marker syn_step4}{...}
    {title:Step 4:  Post, display, or obtain results}

{col 9}{...}
{it:void}{...}
{col 24}{...}
{help mf_moptimize##result_post:{bf:moptimize_result_post(}{it:M} [{bf:,} {it:vcetype}]{bf:)}}


{col 9}{...}
{it:void}{...}
{col 24}{...}
{help mf_moptimize##result_display:{bf:moptimize_result_display(}[{it:M} [{bf:,} {it:vcetype}]]{bf:)}}


{col 9}{...}
{it:real scalar}{...}
{col 24}{...}
{help mf_moptimize##result_value:{bf:moptimize_result_value(}{it:M}{bf:)}}

{col 9}{...}
{it:real scalar}{...}
{col 24}{...}
{help mf_moptimize##result_value0:{bf:moptimize_result_value0(}{it:M}{bf:)}}


{col 9}{...}
{it:real rowvector}{...}
{col 24}{...}
{help mf_moptimize##result_eq_coefs:{bf:moptimize_result_eq_coefs(}{it:M} [{bf:,} {it:i}]{bf:)}}

{col 9}{...}
{it:real rowvector}{...}
{col 24}{...}
{help mf_moptimize##result_coefs:{bf:moptimize_result_coefs(}{it:M}{bf:)}}

{col 9}{...}
{it:string matrix}{...}
{col 24}{...}
{help mf_moptimize##result_colstripe:{bf:moptimize_result_colstripe(}{it:M} [{bf:,} {it:i}]{bf:)}}


{col 9}{...}
{it:real matrix}{...}
{col 24}{...}
{help mf_moptimize##result_scores:{bf:moptimize_result_scores(}{it:M}{bf:)}}

{col 9}{...}
{it:real rowvector}{...}
{col 24}{...}
{help mf_moptimize##result_gradient:{bf:moptimize_result_gradient(}{it:M} [{bf:,} {it:i}]{bf:)}}


{col 9}{...}
{it:real matrix}{...}
{col 24}{...}
{help mf_moptimize##result_Hessian:{bf:moptimize_result_Hessian(}{it:M} [{bf:,} {it:i}]{bf:)}}

{col 9}{...}
{it:real matrix}{...}
{col 24}{...}
{help mf_moptimize##result_V:{bf:moptimize_result_V(}{it:M} [{bf:,} {it:i}]{bf:)}}

{col 9}{...}
{it:string scalar}{...}
{col 24}{...}
{help mf_moptimize##result_Vtype:{bf:moptimize_result_Vtype(}{it:M}{bf:)}}

{col 9}{...}
{it:real matrix}{...}
{col 24}{...}
{help mf_moptimize##result_V_oim:{bf:moptimize_result_V_oim(}{it:M} [{bf:,} {it:i}]{bf:)}}

{col 9}{...}
{it:real matrix}{...}
{col 24}{...}
{help mf_moptimize##result_V_opg:{bf:moptimize_result_V_opg(}{it:M} [{bf:,} {it:i}]{bf:)}}

{col 9}{...}
{it:real matrix}{...}
{col 24}{...}
{help mf_moptimize##result_V_robust:{bf:moptimize_result_V_robust(}{it:M} [{bf:,} {it:i}]{bf:)}}



{col 9}{...}
{it:real scalar}{...}
{col 24}{...}
{help mf_moptimize##result_iterations:{bf:moptimize_result_iterations(}{it:M}{bf:)}}

{col 9}{...}
{it:real scalar}{...}
{col 24}{...}
{help mf_moptimize##result_converged:{bf:moptimize_result_converged(}{it:M}{bf:)}}

{col 9}{...}
{it:real colvector}{...}
{col 24}{...}
{help mf_moptimize##result_iterationlog:{bf:moptimize_result_iterationlog(}{it:M}{bf:)}}

{col 9}{...}
{it:real rowvector}{...}
{col 24}{...}
{help mf_moptimize##result_evaluations:{bf:moptimize_result_evaluations(}{it:M}{bf:)}}

{col 9}{...}
{it:real scalar}{...}
{col 24}{...}
{help mf_moptimize##result_errorcode:{bf:moptimize_result_errorcode(}{it:M}{bf:)}}

{col 9}{...}
{it:string scalar}{...}
{col 24}{...}
{help mf_moptimize##result_errortext:{bf:moptimize_result_errortext(}{it:M}{bf:)}}

{col 9}{...}
{it:real scalar}{...}
{col 24}{...}
{help mf_moptimize##result_returncode:{bf:moptimize_result_returncode(}{it:M}{bf:)}}

{col 9}{...}
{it:void}{...}
{col 24}{...}
{help mf_moptimize##syn_ado_cleanup:{bf:moptimize_ado_cleanup(}{it:M}{bf:)}}


{marker syn_stepall}{...}
    {title:Utility functions for use in all steps}

{col 9}{...}
{it:void}{...}
{col 24}{...}
{help mf_moptimize##_query:{bf:moptimize_query(}{it:M}{bf:)}}


{col 9}{...}
{it:real matrix}{...}
{col 24}{...}
{help mf_moptimize##_eq_indices:{bf:moptimize_util_eq_indices(}{it:M}{bf:,} {it:i} [{bf:,} {it:i2}]{bf:)}}


{col 9}{...}
{it:(varies)}{...}
{col 24}{...}
{help mf_moptimize##util_depvar:{bf:moptimize_util_depvar(}{it:M}{cmd:,} {it:j}{cmd:)}}
{col 12}\ 
{p 12 22 10}
{it:returns} {it:{help mf_moptimize##def_y:y}} {it:set by}
{cmd:moptimize_init_depvar(}{it:M}{cmd:,} {it:j}{cmd:,} {it:y}{cmd:)}{it:,}
{it:which is usually a} {it:real} {it:colvector}


{col 9}{...}
{it:real colvector}{...}
{col 24}{...}
{help mf_moptimize##util_xb:{bf:moptimize_util_xb(}{it:M}{bf:,} {it:b}{bf:,} {it:i}{bf:)}}


{col 9}{...}
{it:real scalar}{...}
{col 24}{...}
{help mf_moptimize##util_sum:{bf:moptimize_util_sum(}{it:M}{bf:,} {it:real colvector v}{bf:)}}


{p 8 38 5}
{it:real rowvector}{...}
{help mf_moptimize##util_vecsum:{bf:moptimize_util_vecsum(}{it:M}{bf:,} {it:i}{bf:,} {it:real colvector s}{bf:,} {it:real scalar value}{bf:)}}



{p 8 38 5}
{it:real matrix}{space 3}{...}
{help mf_moptimize##util_matsum:{bf:moptimize_util_matsum(}{it:M}{bf:,} {it:i}{bf:,} {it:i2}{bf:,} {it:real colvector s}{bf:,} {it:real scalar value}{bf:)}}


{p 8 38 5}
{it:real matrix}{space 3}{...}
{help mf_moptimize##util_matbysum:{bf:moptimize_util_matbysum(}{it:M}{bf:,} {it:i}{bf:,} {it:real colvector a}{bf:,} {it:real colvector b}{bf:,} {it:real scalar value}{bf:)}}

{p 8 38 5}
{it:real matrix}{space 3}{...}
{help mf_moptimize##util_matbysum:{bf:moptimize_util_matbysum(}{it:M}{bf:,} {it:i}{bf:,} {it:i2}{bf:,} {it:real colvector a}{bf:,} {it:real colvector b}{bf:,} {it:real colvector c}{bf:,} {it:real scalar value}{bf:)}}


{col 9}{...}
{it:pointer scalar}{...}
{col 24}{...}
{help mf_moptimize##util_by:{bf:moptimize_util_by(}{it:M}{bf:)}}



{marker syn_M}{...}
{marker def_M}{...}
    {title:Definition of M}

{p 4 4 2}
{it:M}, if it is declared, should be declared transmorphic.
{it:M} is obtained from {cmd:moptimize_init()} and then passed as an
argument to the other {cmd:moptimize()} functions.  

{p 8 12 2}
{cmd:moptimize_init()} returns {it:M}, called an {cmd:moptimize()} 
problem handle.  The function takes no arguments.
{it:M} holds the 
information about the optimization problem.



{marker init_touse}{...}
{marker syn_sample}{...}
    {title:Setting the sample}

{p 4 4 2}
Various {cmd:moptimize_init_}{it:*}{cmd:()} functions set values for dependent
variables, independent variables, etc.  When you set those values, you do that
either by specifying Stata variable names or by specifying Mata matrices
containing the data themselves.  Function {cmd:moptimize_init_touse()}
specifies the sample to be used when you specify Stata variable names.

{p 8 12 2}
{cmd:moptimize_init_touse(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
     {cmd:"}{it:tousevarname}{cmd:")} specifies the name of the variable 
     in the Stata dataset that marks the observations to be included.
     Observations for which the Stata variable is nonzero are included.
     The default is {cmd:""}, meaning all observations are to be used.

{p 12 12 2}
     You need to specify {it:tousevarname} only if you specify 
     Stata variable names in the other {cmd:moptimize_init_}{it:*}{cmd:()} 
     functions, and even then it is not required.  
     Setting {cmd:tousevar} when you specify the data themselves
     via Mata matrices, whether views or not, has no effect.


{marker def_j}{...}
{marker def_D}{...}
{marker def_y}{...}
{marker init_ndepvars}{...}
{marker init_depvar}{...}
{marker syn_dependent}{...}
    {title:Specifying dependent variables}

{p 4 4 2}
{it:D} and {it:j} index dependent variables:

{col 16}{it:index}{col 32}Description
{col 16}{hline 60}
{col 16}{it:D}{col 32}number of dependent variables, {it:D} >= 0
{col 16}{it:j}{col 32}dependent variable index, 1 <= {it:j} <= {it:D}
{col 16}{hline 60}
{col 16}{it:D} and {it:j} are real scalars.

{p 4 4 2}
You set the dependent variables one at a time.
In a particular optimization problem, you may have no 
dependent variables or have more dependent variables than 
{help mf_moptimize##syn_independent:equations}.

{p 8 12 2}
{cmd:moptimize_init_depvar(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:j}{cmd:,} {it:y}{cmd:)} sets the {it:j}th dependent variable to be
    {it:y}.  {it:y} may be a string scalar containing a Stata
    variable name that in turn contains the values of the {it:j}th dependent
    variable, or {it:y} may be a real colvector directly containing the values.

{p 8 12 2}
{cmd:moptimize_init_ndepvars(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
{it:D}{cmd:)} sets the total number of dependent variables.
You can set {it:D} before defining dependent variables, 
and that speeds execution slightly, but it is not necessary 
because {it:D} is automatically set to the maximum {it:j}.


{marker def_i}{...}
{marker def_i2}{...}
{marker def_m}{...}
{marker def_X}{...}
{marker def_name}{...}
{marker def_o}{...}
{marker def_t}{...}
{marker def_names}{...}
{marker syn_independent}{...}
    {title:Specifying independent variables}

{p 4 4 2}
Independent variables are defined within parameters 
or, equivalently, equations.  The words parameter and equation mean the same
thing.  {it:m}, {it:i}, and {it:i2} index parameters:

{col 16}{it:index}{col 32}Description
{col 16}{hline 60}
{col 16}{it:m}{col 32}number of parameters (equations), {it:m} >= 1
{col 16}{it:i}{col 32}equation index, 1 <= {it:i}  <= {it:m}
{col 16}{it:i2}{col 32}equation index, 1 <= {it:i2} <= {it:m}
{col 16}{hline 60}
{col 16}{it:m}, {it:i}, and {it:i2} are real scalars.

{marker def_parameter}{...}
{p 4 4 2}
The function to be optimized is 
{it:f}({it:p}1, {it:p}2, ..., {it:p}{it:m}).
The {it:i}th parameter (equation) is defined as 

{p 12 12 2}
{it:pi} = 
{it:Xi}*{it:bi}' + 
{it:oi} + 
ln({it:ti}) {cmd::+} 
{it:b0i}

{p 8 8 2}
where 

		{it:pi:} {it:Ni x} 1        ({it:i}th parameter)

		{it:Xi:} {it:Ni x ki}       ({it:Ni} observations on {it:ki} independent variables)

		{it:bi:}  1 {it:x ki}       (coefficients to be fit)

		{it:oi:} {it:Ni x} 1        (exposure/offset in offset form, optional)

		{it:ti:} {it:Ni x} 1        (exposure/offset in exposure form, optional)

	       {it:b0i:}  1 {it:x} 1        (constant or intercept, optional) 

{p 4 4 2}
Any of the terms may be omitted.  The most common forms for a parameter
are 
{it:pi} = {it:Xi}*{it:bi}{bf:'} + {it:b0i} (standard model), 
{it:pi} = {it:Xi}*{it:bi}{bf:'} (no-constant model), 
and 
{it:pi} = {it:b0i} (constant-only model).

{marker def_b}{...}
{marker def_K}{...}
{p 4 4 2}
In addition, define {it:b:} 1 {it:x} {it:K} as the entire coefficient vector, 
which is to say,

{col 14}{...}
{it:b} = ({it:b1}, [{it:b01},]   {it:b2}, [{it:b02},]    ...)

{p 4 4 2}
That is, because 
{it:bi} is 1 {it:x} {it:ki} for {it:i}=1, 2, ..., {it:m}, 
then {it:b} is {it:1} {it:x} {it:K}, where 
{it:K} = sum_{it:i} {it:ki}+{it:ci}, where {it:ci} is 1 if equation {it:i}
contains an intercept and is 0 otherwise.  Note that {it:bi} does not contain
the constant or intercept, if there is one, but {it:b} contains all the
coefficients, including the intercepts.  {it:b} is called
{it:the full set of coefficients}.

{p 4 4 2}
Parameters are defined one at a time by using the following functions:

{marker init_eq_n}{...}
{p 8 12 2}
{cmd:moptimize_init_eq_n(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_m:m}}{cmd:)} sets the number of parameters.
   Use of this function 
    is optional; {it:m} will be automatically determined from 
    the other {cmd:moptimize_init_eq_}{it:*}{cmd:()} functions you issue.

{p 8 12 2}
{cmd:moptimize_init_eq_indepvars(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:{help mf_moptimize##def_i:i}}{cmd:,} {it:X}{cmd:)} sets {it:X} to be
    the data (independent variables) for the {it:i}th parameter.  {it:X} may
    be a 1 {it:x} {it:ki} string rowvector containing Stata variable
    names, or {it:X} may be a string scalar containing the same names in
    space-separated format, or {it:X} may be an {it:Ni} {it:x} {it:ki}
    real matrix containing the data for the independent
    variables.  Specify {it:X} as {cmd:""} to omit term {it:Xi}*{it:bi}',
    for instance, as when fitting a constant-only model.
    The default is {cmd:""}.

{p 8 12 2}
{cmd:moptimize_init_eq_cons(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}{cmd:,} 
    {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)} specifies whether the equation for
    the {it:i}th parameter includes {it:b0i}, a constant or intercept.
    Specify {cmd:"on"} to include {it:b0i}, {cmd:"off"} to exclude it.
    The default is {cmd:"on"}.

{p 8 12 2}
{cmd:moptimize_init_eq_offset(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}{cmd:,} {it:o}{cmd:)}
    specifies {it:oi} in the equation for the {it:i}th parameter.  {it:o} may
    be a string scalar containing a Stata variable name,
    or {it:o} may be an {it:Ni} {it:x} 1 real colvector
    containing the offsets.  The default is {cmd:""}, meaning term {it:oi} is
    omitted.  Parameters may not have both {it:oi} and ln({it:ti})
    terms.

{p 8 12 2}
{cmd:moptimize_init_eq_exposure(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
{it:{help mf_moptimize##def_i:i}}{cmd:,} {it:t}{cmd:)}
    specifies {it:ti} in term ln({it:ti}) of the equation for the {it:i}th
    parameter.  {it:t} may be a string scalar containing a Stata
    variable name, or {it:t} may be an {it:Ni} {it:x} 1 real colvector
    containing the exposure values.  The default is {cmd:""}, meaning term
    ln({it:ti}) is omitted.

{p 8 12 2}
{cmd:moptimize_init_eq_name(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}{cmd:,} {it:name}{cmd:)} specifies a
    string scalar, {it:name}, to be used in the output to label the
    {it:i}th parameter.  The default is to use an automatically generated 
    name.

{p 8 12 2}
{cmd:moptimize_init_eq_colnames(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
{it:{help mf_moptimize##def_i:i}}{cmd:,} {it:names}{cmd:)}
    specifies a 1 {it:x} {it:ki} string rowvector, {it:names},
    to be used in the output to label the coefficients for the {it:i}th
    parameter.  The default is to use automatically generated names.

{p 8 12 2}
{cmd:moptimize_init_eq_freeparm(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}{cmd:,} 
    {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
    specifies whether the equation for the {it:i}th parameter is to be
    treated as a free parameter.
    This setting is ignored if there are independent variables or an offset
    attached to the {it:i}th parameter.
    Free parameters have a shortcut notation that distinguishes them from
    constant linear equations.
    The free parameter notation for an equation labeled {it:name} is
    {cmd:/}{it:name}.
    The corresponding notation for a constant linear equation
    is {it:name}{cmd::_cons}.


{marker def_Cc}{...}
{marker syn_constraints}{...}
    {title:Specifying constraints}

{p 4 4 2}
Linear constraints may be placed on the coefficients, {it:b}, which may be
either within equation or between equations.

{p 8 12 2}
{cmd:moptimize_init_constraints(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:Cc}{cmd:)} specifies an {it:R} {it:x} {it:K}+1 real matrix, {it:Cc},
    that places {it:R} linear restrictions on the 1 {it:x} {it:K} 
    {help mf_moptimize##def_K:full set of coefficients, {it:b}}.  Think of
    {it:Cc} as being ({it:C},{it:c}), {it:C:} {it:R} {it:x} {it:K} and
    {it:c:} {it:R} {it:x} 1.  Optimization will be performed subject to
    the constraint {it:C}*{it:b}' = {it:c}.  The default is no constraints.


{marker def_w}{...}
{marker syn_weights}{...}
{marker init_weight}{...}
{marker init_svy}{...}
    {title:Specifying weights or survey data}

{p 4 4 2}
You may specify weights, and once you do, everything is automatic, assuming you
implement your {help mf_moptimize##syn_alleval:evaluator} by using the provided
{help mf_moptimize##syn_util:utility functions}.

{p 8 12 2}
{cmd:moptimize_init_weight(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:w}{cmd:)} specifies the weighting variable or data.
    {it:w} may be a string scalar containing a Stata
    variable name, 
    or {it:w} may be a real colvector directly containing the weight values.
    The default is {cmd:""}, meaning no weights.

{p 8 12 2}
{cmd:moptimize_init_weighttype(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
     {it:weighttype}{cmd:)} specifies how {it:w} is to be treated. 
     {it:weighttype} may be 
     {cmd:"fweight"}, 
     {cmd:"aweight"}, 
     {cmd:"pweight"}, or
     {cmd:"iweight"}.  You may set {it:w} first and then {it:weighttype}, 
     or the reverse.  If you set {it:w} without setting {it:weighttype}, 
     then {cmd:"fweight"} is assumed.  If you set {it:weighttype} without 
     setting {it:w}, then {it:weighttype} is ignored.  The default
     {it:weighttype} is {cmd:"fweight"}.

{p 4 4 2}
Alternatively, you may inherit the full set of 
{help svyset:survey settings} from Stata by using 
{cmd:moptimize_init_svy()}.  If you do this, do not use 
{cmd:moptimize_init_weight()},  
{cmd:moptimize_init_weighttype()}, or 
{bf:{help mf_moptimize##init_cluster:moptimize_init_cluster()}}.
When you use the survey settings, 
everything is nearly automatic, assuming you
use the provided {help mf_moptimize##syn_util:utility functions} to implement
your {help mf_moptimize##syn_alleval:evaluator}.  The proviso is 
that your evaluator must be of
{it:{help mf_moptimize##def_evaluatortype:evaluatortype}}
{cmd:lf}, {cmd:lf*}, {cmd:gf}, or {cmd:q}.

{p 8 12 2}
{cmd:moptimize_init_svy(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    specifies whether Stata's survey settings 
    should be used.  
    The default is {cmd:"off"}.
    Using the survey settings changes the default 
    {it:{help mf_moptimize##def_vcetype:vcetype}} to {cmd:"svy"}, which is 
    equivalent to {cmd:"robust"}.
    

{marker def_c}{...}
{marker def_by}{...}
{marker syn_clusters}{...}
{marker init_cluster}{...}
{marker init_by}{...}
    {title:Specifying clusters and panels}

{p 4 4 2}
Clustering refers to possible nonindependence of the observations within 
groups called clusters.  A cluster variable takes on the same value within a
cluster and different values across clusters.  After setting the cluster
variable, there is nothing special you have to do, but be aware that
clustering is allowed only if you use a type {cmd:lf}, {cmd:lf*}, {cmd:gf}, or
{cmd:q} {help mf_moptimize##def_evaluatortype:evaluator}.
{cmd:moptimize_init_cluster()} allows you to set a cluster variable.

{p 4 4 2}
Panels refer to likelihood functions or other objective functions that can 
only be calculated at the panel level, for which there is no
observation-by-observation decomposition.  
Unlike clusters, these panel likelihood functions are difficult to 
calculate and require the use of type {cmd:d} or {cmd:gf} 
{help mf_moptimize##def_evaluatortype:evaluator}.
A panel variable takes on the same
value within a panel and different values across panels.
{cmd:moptimize_init_by()} allows you to set a panel variable.

{p 4 4 2}
You may set both a cluster variable and a panel variable, but be careful
because, for most likelihood functions, panels are mathematically 
required to be nested within cluster.

{p 8 12 2}
{cmd:moptimize_init_cluster(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:c}{cmd:)} specifies a cluster variable.
    {it:c} may be a string scalar containing a Stata
    variable name, 
    or {it:c} may be a real colvector directly containing the cluster values.
    The default is {cmd:""}, meaning no clustering. 
    If clustering is specified, the default 
    {it:{help mf_moptimize##def_vcetype:vcetype}} becomes {cmd:"robust"}.

{p 8 12 2}
{cmd:moptimize_init_by(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:by}{cmd:)} specifies a panel variable and specifies that only
    panel-level calculations are meaningful.  {it:by} may be a string scalar
    containing a Stata variable name, or {it:by} may be a real colvector
    directly containing the panel ID values.  The default is {cmd:""}, meaning
    no panels.  If panels are specified, the default 
    {it:{help mf_moptimize##def_vcetype:vcetype}} remains unchanged, but if
    the {cmd:opg} variance estimator is used, the {cmd:opg} calculation
    is modified so that it is clustered at the panel level.


{marker def_technique}{...}
{marker syn_technique}{...}
    {title:Specifying optimization technique}

{p 4 4 2}
Technique refers to the numerical methods used to solve the 
optimization problem.  The default is Newton-Raphson maximization.

{marker init_which}{...}
{p 8 12 2}
{cmd:moptimize_init_which(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
{c -(}{cmd:"max"}|{cmd:"min"}{c )-}{cmd:)}
    sets whether the maximum or minimum of the objective function is 
    to be found.  The default is {cmd:"max"}.  

{p 8 12 2}
{cmd:moptimize_init_technique(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:technique}{cmd:)} specifies the technique to be used to find 
    the coefficient vector 
    {it:{help mf_moptimize##def_K:b}} that maximizes or minimizes 
    the objective function.  Allowed values
    are

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

{p 12 12 2}
You can switch between
{cmd:"nr"},
{cmd:"dfp"},
{cmd:"bfgs"}, and
{cmd:"bhhh"}
by specifying two or more of them in a space-separated list.
By default, {cmd:moptimize()} will use an
algorithm for five iterations before switching to the next algorithm.  To
specify a different number of iterations, include the number after the
technique.  For example, specifying
{cmd:moptimize_init_technique(}{it:M}{cmd:,}
{cmd:"bhhh 10 nr 1000")} requests that {cmd:moptimize()} perform 10 iterations
using the Berndt-Hall-Hall-Hausman algorithm, followed by 1,000 iterations
using the modified Newton-Raphson algorithm, and then switch back to
Berndt-Hall-Hall-Hausman for 10 iterations, and so on.  The process continues
until {help mf_moptimize##syn_convergence:convergence} or until
{it:{help mf_moptimize##def_maxiter:maxiter}} is exceeded.

{marker def_singularHmethod}{...}
{p 8 12 2}
{cmd:moptimize_init_singularHmethod(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:singularHmethod}{cmd:)}
    specifies the action to be taken during optimization if the Hessian is
    found to be singular and the {it:technique} requires the Hessian be of
    full rank.  Allowed values are

{col 16}{it:singularHmethod}{col 34}Description
{col 16}{hline 56}
{col 16}{cmd:"m-marquardt"}{col 34}modified Marquardt algorithm
{col 16}{cmd:"hybrid"}{col 34}mixture of steepest descent and Newton
{col 16}{hline 56}
{col 16}The default is {cmd:"m-marquardt"}.
{col 16}{cmd:"hybrid"} is equivalent to {cmd:ml}'s {cmd:difficult} option; see {bf:{help ml:[R] ml}}. 

{marker init_nmsimplexdeltas}{...}
{marker def_delta}{...}
{p 8 12 2}
{cmd:moptimize_init_nmsimplexdeltas(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
{it:delta}{cmd:)} is for use with Nelder-Mead, also known as technique {cmd:nm}.
This function sets the values of {it:delta} to be used, along with the initial
parameters, to build the simplex required by Nelder-Mead.  Use of this
function is required only in the Nelder-Mead case.  The values in {it:delta}
must be at least 10 times larger than {it:{help mf_moptimize##def_ptol:ptol}}.
The initial simplex will be 
{c -(}{it:p}, {it:p}+({it:d}_1,0,...0), 
{it:p}+(0,{it:d}_2,0,...,0),
..., 
{it:p}+(0,0,...,0,{it:d}_{it:K}){c )-}.


{marker def_minmax}{...}
{marker def_nr}{...}
{marker def_b0}{...}
{marker syn_initial}{...}
    {title:Specifying initial values}

{p 4 4 2}
Initial values are values you optionally specify that via a search procedure
result in starting values that are then used for the first iteration of the
optimization technique.  That is, 
    
                                                 {it:(optimization}
                       {it:(searching)                   technique)}
	initial values {hline 10}> starting values {hline 11}> final results

{p 4 4 2}
Initial values are specified {help mf_moptimize##def_parameter:parameter}
 by parameter.

{p 8 12 2}
{cmd:moptimize_init_eq_coefs(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}{cmd:,} {it:b0}{cmd:)} sets the initial
    values of the coefficients for the {it:i}th parameter to be {it:b0:} 1
    {it:x} ({it:ki}+{it:ci}).  The default is (0, 0, ..., 0).

{marker init_search}{...}
{p 4 4 2}
The following functions control whether searching is used to improve on the
initial values to produce better starting values.  In addition to searching a
predetermined set of hardcoded starting values, there are two other methods
that can be used to improve on the initial values: random and rescaling.  By
default, random is off and rescaling is on.  You can use one, the other, or
both.

{p 8 12 2}
{cmd:moptimize_init_search(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
    determines whether any attempts are to be made to improve on the initial
    values via a search technique.  The default is {cmd:"on"}.  If you specify
    {cmd:"off"}, the initial values become the starting values.

{p 8 12 2}
{cmd:moptimize_init_search_random(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)} 
    determines whether the random method of improving initial values 
    is to be attempted.  The default is {cmd:"off"}.  Use of the 
    random method is recommended when the initial values are or might 
    be infeasible.  Infeasible means that the function cannot be evaluated,
    which mechanically corresponds to the user-written evaluator
    returning a missing value.  The random method is seldom able to improve on 
    feasible initial values.  It works well when the initial 
    values are or might be infeasible.
    
{p 8 12 2}
{cmd:moptimize_init_search_repeat(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
     {it:nr}{cmd:)} controls how many times random values are tried 
     if the random method is turned on.  The default is 10.

{p 8 12 2}
{cmd:moptimize_init_search_bounds(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:{help mf_moptimize##def_i:i}}{cmd:,} {it:minmax}{cmd:)} 
    specifies the bounds for the random search.
    {it:minmax} is a 1 {it:x} 2 real rowvector containing the
    minimum and maximum values for the {it:i}th parameter (equation). 
    The default is (.,.), meaning no lower and no upper bounds.

{p 8 12 2}
{cmd:moptimize_init_search_rescale(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)} determines whether 
    rescaling is attempted.  The default is {cmd:"on"}.  Rescaling is a
    deterministic (not random) method.  It also usually improves initial
    values, and usually reduces the number of subsequent iterations required
    by the optimization technique.


{marker syn_one}{...}
    {title:Performing one evaluation of the objective function}

{p 4 4 2}
{cmd:moptimize_evaluate(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
and 
{cmd:_moptimize_evaluate(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
perform one evaluation of the function evaluated at the 
{help mf_moptimize##syn_initial:initial values}.
Results can be accessed by using
{bf:{help mf_moptimize##syn_results:moptimize_result_{it:*}()}}, including 
first- and second-derivative-based results.

{p 4 4 2}
{cmd:moptimize_evaluate()}
and 
{cmd:_moptimize_evaluate()}
do the same thing, differing only in that 
{cmd:moptimize_evaluate()} aborts with a nonzero return code if 
things go badly, whereas 
{cmd:_moptimize_evaluate()} returns the 
real scalar 
{help mf_moptimize##def_errorcode:error code}.
An infeasible initial value is an error.

{p 4 4 2}
The evaluation is performed at the 
{help mf_moptimize##syn_initial:initial values}, 
not the 
{help mf_moptimize##syn_initial:starting values}, and this is 
true even if search is turned on.
If you want to perform an evaluation at the starting values, 
then perform {help mf_moptimize##syn_opt:optimization} with 
{it:{help mf_moptimize##syn_convergence:maxiter}} set to 0.


{marker syn_opt}{...}
    {title:Performing optimization of the objective function}

{p 4 4 2}
{cmd:moptimize(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
and 
{cmd:_moptimize(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
perform 
optimization.  Both routines do the same thing; they differ only in 
their behavior when things go badly.
{cmd:moptimize()} returns nothing and aborts with error. 
{cmd:_moptimize()} returns a real scalar 
{help mf_moptimize##def_errorcode:error code}.
{cmd:moptimize()} is best for interactive use and often adequate for use in
programs that do not want to consider the possibility that optimization 
might fail.

{p 4 4 2}
The optimization process is as follows:

{p 8 12 2}
1.  
The {help mf_moptimize##syn_initial:initial values} are 
used to create {help mf_moptimize##syn_initial:starting values}.
The value of the function at the starting values is calculated.
If that results in a missing value, the starting values are 
declared infeasible.
{cmd:moptimize()} aborts with return code 430;
{cmd:_moptimize()} returns a nonzero error code, which maps to 430
via {bf:{help mf_moptimize##err_to_ret:moptimize_result_returncode()}}.
This step is called iteration 0. 

{p 8 12 2}
2.
    The starting values are passed to the 
    {help mf_moptimize##syn_technique:technique} to produce better values.
    Usually this involves the technique calculating first and second
    derivatives, numerically or analytically, and then stepping multiple times
    in the appropriate direction, but techniques can vary on this.  In general,
    the technique performs what it calls one iteration, the result of which is
    to produce better values.  Those new values then become the starting
    values and the process repeats.

{p 12 12 2}
    An iteration is said to fail if the new coefficient vector is infeasible
    (results in a missing value).  Then attempts are made to recover
    and, if those attempts are successful, optimization continues.  If they
    fail, {cmd:moptimize()} aborts with error and {cmd:_moptimize()} returns a
    nonzero error code.

{p 12 12 2}
    Other problems may arise, such as singular Hessians or the inability to find
    better values.  Various fix-ups are made and optimization continues.
    These are not failures.

{p 12 12 2}
    This step is called iterations 1, 2, and so on.

{p 8 12 2}
3.
    Step 2 continues either until the process 
    {help mf_moptimize##syn_convergence:converges} or until the 
    {help mf_moptimize##syn_convergence:maximum number of iterations}
    ({it:maxiter}) is exceeded.  Stopping due to {it:maxiter} is not
    considered an error.  Upon completion, programmers should check
    {bf:{help mf_moptimize##result_converged:moptimize_result_converged()}}.

{p 4 4 2}
If optimization succeeds, which is to say, if {cmd:moptimize()} does not abort
or {cmd:_moptimize()} returns 0, you can use the 
{bf:{help mf_moptimize##syn_results:moptimize_result_{it:*}()}} functions to
access results.


{marker def_id}{...}
{marker syn_trace}{...}
{marker def_tracelevel}{...}
{marker init_iterid}{...}
{marker init_valueid}{...}
    {title:Tracing optimization}

{p 4 4 2}
{cmd:moptimize()} and {cmd:_moptimize()} will produce output like 

            Iteration 0:   f(p) = .........
            Iteration 1:   f(p) = .........

{p 4 4 2}
You can change the f(p) to be "log likelihood" or whatever else 
you want.  You can also change "Iteration".

{p 8 12 2}
{cmd:moptimize_init_iterid(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
{it:id}{cmd:)}
     sets the string to be used to label the iterations
     in the iteration log.  {it:id} is a string scalar.
     The default is {cmd:"Iteration"}.

{p 8 12 2}
{cmd:moptimize_init_valueid(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
{it:id}{cmd:)}
     sets the string to be used to label the objective function 
     value in the iteration log.  {it:id} is a string scalar.
     The default is {cmd:"f(p)"}.

{p 4 4 2}
Additional results can be displayed during optimization, which can be 
useful when you are debugging your 
{help mf_moptimize##syn_alleval:evaluator}.  This is called 
tracing the execution.

{p 8 12 2}
{cmd:moptimize_init_tracelevel(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:tracelevel}{cmd:)} specifies the output to be displayed during the
    optimization process.  Allowed values are

{col 16}{it:tracelevel}{col 32}To be displayed each iteration
{col 16}{hline 57}
{col 16}{cmd:"none"}{col 32}nothing
{col 16}{cmd:"value"}{col 32}function value
{col 16}{cmd:"tolerance"}{col 32}previous + convergence values
{col 16}{cmd:"step"}{col 32}previous + stepping information
{col 16}{cmd:"coefdiffs"}{col 32}previous + parameter relative differences
{col 16}{cmd:"paramdiffs"}{col 32}same as {cmd:"coefdiffs"}
{col 16}{cmd:"coefs"}{col 32}previous + parameter values
{col 16}{cmd:"params"}{col 32}same as {cmd:"coefs"}
{col 16}{cmd:"gradient"}{col 32}previous + gradient vector
{col 16}{cmd:"hessian"}{col 32}previous + Hessian matrix
{col 16}{hline 57}
INCLUDE help traceleveldefault

{p 4 4 2}
Setting {it:tracelevel} is a shortcut.  The other trace functions
allow you to turn on and off individual features.  In what follows, 
the documented defaults are the defaults when {it:tracelevel} is
{cmd:"value"}.

{p 8 12 2}
{cmd:moptimize_init_trace_ado(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    traces the execution of evaluators written as ado-files.
    This topic is not discussed in this manual entry.
    The default is {cmd:"off"}.

{p 8 12 2}
{cmd:moptimize_init_trace_dots(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays a dot each time your evaluator is called.
    The default is {cmd:"off"}.

{p 8 12 2}
{cmd:moptimize_init_trace_value(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)}
    displays the function value at the start of each iteration.
    The default is {cmd:"on"}.

{p 8 12 2}
{cmd:moptimize_init_trace_tol(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the value of the calculated result that is compared 
    with the effective {help mf_moptimize##syn_convergence:convergence} 
    criterion at the end of each iteration.  The default is {cmd:"off"}.

{p 8 12 2}
{cmd:moptimize_init_trace_step(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the steps within iteration.  Listed are the value of
    objective function along with the word forward or backward.  The default is
    {cmd:"off"}.

{p 8 12 2}
{cmd:moptimize_init_trace_coefdiffs(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the coefficient relative differences from the previous iteration
    that are greater than the coefficient tolerance {it:ptol}.
    The default is {cmd:"off"}.

{p 8 12 2}
{cmd:moptimize_init_trace_coefs(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the coefficients at the start of each iteration.
    The default is {cmd:"off"}.

{p 8 12 2}
{cmd:moptimize_init_trace_gradient(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the gradient vector at the start of each iteration.
    The default is {cmd:"off"}.

{p 8 12 2}
{cmd:moptimize_init_trace_Hessian(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    displays the Hessian matrix at the  start of each iteration.
    The default is {cmd:"off"}.


{marker def_maxiter}{...}
{marker def_ptol}{...}
{marker def_vtol}{...}
{marker def_nrtol}{...}
{marker syn_convergence}{...}
    {title:Specifying convergence criteria}

{p 4 4 2}
Convergence is based on several rules controlled by four parameters:
{it:maxiter}, {it:ptol}, {it:vtol}, and {it:nrtol}.
The first rule is not a convergence rule, but a stopping rule, and 
it is controlled by {it:maxiter}.

{p 8 12 2}
{cmd:moptimize_init_conv_maxiter(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
{it:maxiter}{cmd:)} specifies the maximum number of iterations.  If this
number is exceeded, optimization stops and results are posted where they are
accessible by using the {cmd:moptimize_result_*()} functions, just as if
convergence had been achieved.  {cmd:moptimize_result_converged()}, however,
is set to 0 rather than 1.  The default {it:maxiter} is Stata's
{bf:{help creturn:c(maxiter)}}, which is
INCLUDE help maxiter
by default.

{p 8 12 2}
{cmd:moptimize_init_conv_warning(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
     {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)} specifies whether 
     the warning message "convergence not achieved" is to be displayed
     when this stopping rule is invoked.  The default is {cmd:"on"}.

{p 4 4 2}
Usually, convergence occurs before the stopping rule comes into effect.
The convergence criterion is a function of three real scalar values:
{it:ptol}, {it:vtol}, and {it:nrtol}.  Let 

{col 16}      {it:b} = {help mf_moptimize##def_K:full set of coefficients} 
{col 16}{it:b_prior} = value of {it:b} from prior iteration
{col 16}      {it:v} = value of objective function
{col 16}{it:v_prior} = value of {it:v} from prior iteration
{col 16}      {it:g} = gradient vector from this iteration
{col 16}      {it:H} = Hessian matrix from this iteration

{p 4 4 2}
Define, for maximization,

{col 17}{it:C_ptol:}  {...}
{cmd:mreldif(}{it:b}, {it:b_prior}{cmd:)} <= {it:ptol}
{col 17}{it:C_vtol:}  {...}
 {cmd:reldif(}{it:v}, {it:v_prior}{cmd:)} <= {it:vtol}
{col 16}{it:C_nrtol:}  {...}
    g*{cmd:invsym(}-{it:H}{cmd:)}*g' <  {it:nrtol}
{col 14}{it:C_concave:}  {...}
-{it:H} is positive semidefinite

{p 4 4 2}
For minimization, think in terms of maximization of 
-{it:f}({it:p}).  Convergence is declared when 

{col 16}{...}
({it:C_ptol} | {it:C_vtol}) & {it:C_nrtol} & {it:C_concave}

{p 4 4 2}
The above applies in cases of derivative-based optimization, which 
currently is all {help mf_moptimize##def_technique:techniques} except 
{cmd:"nm"} (Nelder-Mead).  In the Nelder-Mead case, the 
criterion is 

{col 17}{it:C_ptol:}  {...}
{cmd:mreldif(}vertices of {it:R}{cmd:)} <= {it:ptol}
{col 17}{it:C_vtol:}  {...}
             {cmd:reldif(}{it:R}{cmd:)} <= {it:vtol}

{p 4 4 2}
where {it:R} is the minimum and maximum values on the simplex.  
Convergence is declared when {it:C_ptol} | {it:C_vtol}.

{p 4 4 2}
The values of {it:ptol}, {it:vtol}, and {it:nrtol} are set by the following
functions:

{p 8 12 2}
{cmd:moptimize_init_conv_ptol(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
     {it:ptol}{cmd:)}
     sets {it:ptol}.
     The default is 1e-6.

{p 8 12 2}
{cmd:moptimize_init_conv_vtol(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
     {it:vtol}{cmd:)}
     sets {it:vtol}. 
     The default is 1e-7.

{p 8 12 2}
{cmd:moptimize_init_conv_nrtol(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
     {it:nrtol}{cmd:)}
     sets {it:nrtol}. 
     The default is 1e-5.

{p 8 12 2}
{cmd:moptimize_init_conv_ignorenrtol(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
     {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)} sets whether 
     {it:C_nrtol} should always be treated as true, which in
     effect removes the {it:nrtol} criterion from the convergence rule.
     The default is {cmd:"off"}.


{marker syn_results}{...}
    {title:Accessing results}

{p 4 4 2}
Once you have successfully performed {help mf_moptimize##syn_opt:optimization},
or you have successfully performed a 
{help mf_moptimize##syn_one:single function evaluation}, you
may display results, post results to Stata, or access individual results.

{marker result_display}{...}
{p 4 4 2}
To display results, use {cmd:moptimize_result_display()}.

{p 8 12 2}
{cmd:moptimize_result_display(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    displays estimation results.  
    Standard errors are shown using the default 
    {it:{help mf_moptimize##def_vcetype:vcetype}}.

{p 8 12 2}
{cmd:moptimize_result_display(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
{it:{help mf_moptimize##def_vcetype:vcetype}}{cmd:)}
    displays estimation results.
    Standard errors are shown using the specified 
    {it:vcetype}.

{p 4 4 2}
Also there is a third syntax for use after results have been 
posted to Stata, which we will discuss below.

{p 8 12 2}
{cmd:moptimize_result_display()} without arguments (not
even {it:M}) 
displays the estimation results currently posted in Stata.

{marker def_vcetype}{...}
{marker init_vcetype}{...}
{p 4 4 2}
{it:vcetype} specifies how the variance-covariance matrix of the estimators
(VCE) is to be calculated.  Allowed values are

{col 16}{it:vcetype}{col 32}Description
{col 16}{hline 54}
{col 16}{cmd:""}{col 32}use default for {help mf_moptimize##def_technique:technique}
{col 16}{cmd:"oim"}{col 32}observed information matrix
{col 16}{cmd:"opg"}{col 32}outer product of gradients
{col 16}{cmd:"robust"}{col 32}Huber/White/sandwich estimator
{col 16}{cmd:"svy"}{col 32}survey estimator; equivalent to {cmd:robust}
{col 16}{hline 54}
{col 16}The default {it:vcetype} is {cmd:oim} except for technique {cmd:bhhh}, 
{col 16}where it is {cmd:opg}.  If survey, {cmd:pweight}s, or clusters
{col 16}are used, the default becomes {cmd:robust} or {cmd:svy}.

{p 4 4 2}
As an aside, if you set {cmd:moptimize_init_vcetype()} during initialization,
that changes the default.

{p 8 12 2} 
{cmd:moptimize_init_vcetype(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_vcetype:vcetype}}{cmd:)}, {it:vcetype} being a
    string scalar, resets the default {it:vcetype}.

{p 4 4 2}
To post results to Stata, use {cmd:moptimize_result_post()}.

{marker result_post}{...}
{p 8 12 2}
{cmd:moptimize_result_post(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
posts estimation results to Stata where they can be displayed with 
Mata function 
{cmd:moptimize_result_post()} (without arguments) 
or with Stata command 
{bf:{help ereturn:ereturn display}}.
The posted VCE will be of the default 
{it:{help mf_moptimize##def_vcetype:vcetype}}.

{p 8 12 2}
{cmd:moptimize_result_post(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
{it:{help mf_moptimize##def_vcetype:vcetype}}{cmd:)}
does the same thing, except the VCE will be of the specified
{it:vcetype}.

{p 4 4 2}
The remaining {cmd:moptimize_result_*()} functions
simply return the requested result.  It does not matter whether 
results have been posted or previously displayed.

{marker result_value}{...}
{p 8 12 2}
{cmd:moptimize_result_value(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns the real scalar value of the objective function.

{marker result_value0}{...}
{p 8 12 2}
{cmd:moptimize_result_value0(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns the real scalar value of the objective function 
    at the {help mf_moptimize##syn_initial:starting values}.

{marker result_eq_coefs}{...}
{p 8 12 2}
{cmd:moptimize_result_eq_coefs(}{it:{help mf_moptimize##def_M:M}} [{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}]{cmd:)}
    returns the 1 {it:x} ({it:ki}+{it:ci})
    coefficient rowvector for the {it:i}th equation.  
    If {it:i}>={cmd:.} or argument {it:i} is omitted, 
    the 
    1 {it:x} {it:K} {help mf_moptimize##def_K:full set of coefficients} is
    returned.

{marker result_coefs}{...}
{p 8 12 2}
{cmd:moptimize_result_coefs(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns the 
    1 {it:x} {it:K} {help mf_moptimize##def_K:full set of coefficients}.

{marker result_colstripe}{...}
{p 8 12 2}
{cmd:moptimize_result_colstripe(}{it:{help mf_moptimize##def_M:M}} [{cmd:,}
    {it:{help mf_moptimize##def_i:i}}]{cmd:)}
    returns a ({it:ki}+{it:ci}) {it:x} 2 string matrix containing, for the
    {it:i}th equation, the equation names in the first column and the
    coefficient names in the second.
    If {it:i}>={cmd:.} or argument {it:i} is omitted, 
    the result is {it:{help mf_moptimize##def_K:K}} {it:x} 2.

{marker result_scores}{...}
{p 8 12 2}
{cmd:moptimize_result_scores(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns an {it:N} {it:x} {it:{help mf_moptimize##def_m:m}} 
    ({help mf_moptimize##def_evaluatortype:evaluator types} {cmd:lf} and 
    {cmd:lf*}), or an 
    {it:N} {it:x} {it:{help mf_moptimize##def_K:K}} (evaluator type 
    {cmd:gf}), 
    or an {it:L} {it:x} {it:K} (evaluator type 
    {cmd:q}) real matrix containing the observation-by-observation
    scores.
    For all other evaluator types, {cmd:J(}0{cmd:,}0{cmd:,.)}
    is returned.
    For evaluator types {cmd:lf} and {cmd:lf*}, scores are defined as 
    the derivative of the objective function with respect to the 
    {help mf_moptimize##def_parameter:parameters}.  
    For evaluator type {cmd:gf}, scores are 
    defined as the derivative of the objective function 
    with respect to the {help mf_moptimize##def_K:coefficients}.
    For evaluator type {cmd:q}, scores are defined as the 
    derivatives of the {it:L} {help mf_moptimize##def_L:independent elements}
    with respect to the coefficients.
   
{marker result_gradient}{...}
{p 8 12 2}
{cmd:moptimize_result_gradient(}{it:{help mf_moptimize##def_M:M}} [{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}]{cmd:)}
    returns the 1 {it:x} ({it:ki}+{it:ci})
     gradient rowvector for the {it:i}th equation.
    If {it:i}>={cmd:.} or argument {it:i} is omitted, 
    the 1 {it:x} {it:K} gradient corresponding to 
    the {help mf_moptimize##def_K:full set of coefficients} is returned.
    Gradient is defined as the derivative of the objective function 
    with respect to the {help mf_moptimize##def_K:coefficients}.

{marker result_Hessian}{...}
{p 8 12 2}
{cmd:moptimize_result_Hessian(}{it:{help mf_moptimize##def_M:M}} [{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}]{cmd:)}
    returns the ({it:ki}+{it:ci}) {it:x} ({it:ki}+{it:ci})
    Hessian matrix for the {it:i}th equation. 
    If {it:i}>={cmd:.} or argument {it:i} is omitted, the {it:K} {it:x} {it:K}
    Hessian corresponding to the 
    {help mf_moptimize##def_K:full set of coefficients} is returned.  
    The Hessian 
    is defined as the second derivative of the objective function with
    respect to the {help mf_moptimize##def_K:coefficients}.

{marker result_V}{...}
{p 8 12 2}
{cmd:moptimize_result_V(}{it:{help mf_moptimize##def_M:M}} [{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}]{cmd:)}
    returns the appropriate ({it:ki}+{it:ci}) {it:x} ({it:ki}+{it:ci})
    submatrix of the full variance matrix calculated according to the 
    default {it:{help mf_moptimize##def_vcetype:vcetype}}.
    If {it:i}>={cmd:.} or argument {it:i} is omitted, the full
    {it:K} {it:x} {it:K} variance matrix corresponding to the 
    {help mf_moptimize##def_K:full set of coefficients} is returned.  

{marker result_Vtype}{...}
{p 8 12 2}
{cmd:moptimize_result_Vtype(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns a string scalar containing the default
    {it:{help mf_moptimize##def_vcetype:vcetype}}.

{marker result_V_oim}{...}
{p 8 12 2}
{cmd:moptimize_result_V_oim(}{it:{help mf_moptimize##def_M:M}} [{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}]{cmd:)}
    returns the appropriate ({it:ki}+{it:ci}) {it:x} ({it:ki}+{it:ci})
    submatrix of the full variance matrix calculated as the inverse of the
    negative Hessian matrix (the observed information matrix).  If
    {it:i}>={cmd:.} or argument {it:i} is omitted, the full {it:K} {it:x}
    {it:K} variance matrix corresponding to the 
    {help mf_moptimize##def_K:full set of coefficients} is returned.

{marker result_V_opg}{...}
{p 8 12 2}
{cmd:moptimize_result_V_opg(}{it:{help mf_moptimize##def_M:M}} [{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}]{cmd:)}
    returns the appropriate ({it:ki}+{it:ci}) {it:x} ({it:ki}+{it:ci}) submatrix
    of the full variance matrix calculated as the inverse of the outer product
    of the gradients.  If {it:i}>={cmd:.} or argument {it:i} is omitted, the
    full {it:K} {it:x} {it:K} variance matrix corresponding to the
    {help mf_moptimize##def_K:full set of coefficients} is returned.  If
    {cmd:moptimize_result_V_opg()} is used with 
    {help mf_moptimize##syn_alleval:evaluator types} other than {cmd:lf},
    {cmd:lf*}, {cmd:gf}, or {cmd:q}, an appropriately dimensioned matrix of
    zeros is returned.

{marker result_V_robust}{...}
{p 8 12 2}
{cmd:moptimize_result_V_robust(}{it:{help mf_moptimize##def_M:M}} [{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}]{cmd:)}
    returns the appropriate ({it:ki}+{it:ci}) {it:x} ({it:ki}+{it:ci}) submatrix
    of the full variance matrix calculated via the sandwich estimator.  If
    {it:i}>={cmd:.} or argument {it:i} is omitted, the full {it:K} {it:x}
    {it:K} variance matrix corresponding to the 
    {help mf_moptimize##def_K:full set of coefficients} is returned.  If
    {cmd:moptimize_result_V_robust()} is used with
    {help mf_moptimize##syn_alleval:evaluator types} other than {cmd:lf},
    {cmd:lf*}, {cmd:gf}, or {cmd:q}, an appropriately dimensioned matrix of
    zeros is returned.

{marker result_iterations}{...}
{p 8 12 2}
{cmd:moptimize_result_iterations(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns a real scalar containing the number of iterations performed.

{marker result_converged}{...}
{p 8 12 2}
{cmd:moptimize_result_converged(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns a real scalar containing 
    1 if {help mf_moptimize##syn_convergence:convergence} was achieved 
    and 0 otherwise.

{marker result_iterationlog}{...}
{p 8 12 2}
{cmd:moptimize_result_iterationlog(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns a real colvector 
    containing the values of the objective function at the end of each 
    iteration.   Up to the last 20 iterations are returned, one to a row.

{marker def_errorcode}{...}
{marker result_errorcode}{...}
{p 8 12 2}
{cmd:moptimize_result_errorcode(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns the real scalar containing the error code from the most 
    recently run optimization or function evaluation.  The error code is 
    0 if there are no errors. 
    This function is useful only after 
    {cmd:_moptimize()} or 
    {cmd:_moptimize_evaluate()} because the nonunderscore versions
    aborted with error if there were problems.

{marker result_errortext}{...}
{p 8 12 2}
{cmd:moptimize_result_errortext(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns a string scalar containing the error text corresponding to
    {cmd:moptimize_result_errorcode()}.

{marker err_to_ret}{...}
{marker result_returncode}{...}
{p 8 12 2}
{cmd:moptimize_result_returncode(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns a real scalar containing the Stata return code corresponding to
    {cmd:moptimize_result_errorcode()}.

{pstd}
The following error codes and their corresponding Stata return codes are 
for {cmd:moptimize()} only.  To see other error codes and their corresponding
Stata return codes, see {help mf_optimize##error:{bf:[M-5] optimize}}.

           Error   Return
           code    code    Error text
        {hline 70}
           400      1400   could not find feasible values
           401      491    Stata program evaluator returned an error
           402      198    views are required when the evaluator is a 
                             Stata program
           403      198    Stata program evaluators require a touse variable
        {hline 70}


{marker syn_ado_cleanup}{...}
    {title:Stata evaluators}

{p 4 4 2}
The following function is useful only when your evaluator is a Stata program
instead of a Mata function.

{marker init_verbose}{...}
{p 8 12 2}
{cmd:moptimize_ado_cleanup(}{it:{help mf_moptimize##def_M:M}}{cmd:)} removes all
the global macros with the {cmd:ML_} prefix. A temporary weight variable is
also dropped if weights were specified.


{marker syn_advanced}{...}
    {title:Advanced functions}

{p 4 4 2}
These functions are not really advanced, they are just seldomly used.

{marker init_verbose}{...}
{p 8 12 2}
{cmd:moptimize_init_verbose(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {c -(}{cmd:"on"}|{cmd:"off"}{c )-}{cmd:)} specifies 
    whether error messages are to be displayed.  The default is {cmd:"on"}.
    
{marker init_evaluations}{...}
{p 8 12 2}
{cmd:moptimize_init_evaluations(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
     {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)} specifies whether the system is
     to count the number of times the 
     {help mf_moptimize##syn_alleval:evaluator}
     is called.  The default is {cmd:"off"}.

{marker result_evaluations}{...}
{p 8 12 2}
{cmd:moptimize_result_evaluations(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    returns a 1 {it:x} 3 real rowvector containing the number of times 
    the 
    {help mf_moptimize##syn_alleval:evaluator} was called, assuming 
    {cmd:moptimize_init_evaluations()} was set on.
    Contents are the number of times called for the 
    purposes of 1) calculating the objective function, 2) calculating the
    objective function and its first derivative, and 3) calculating the
    objective function and its first and second derivatives.
    If {cmd:moptimize_init_evaluations()} was set off, returned is 
    (0,0,0).


{marker def_evaluatortype}{...}
{marker syn_alleval}{...}
    {title:Syntax of evaluators}

{p 8 8 2}
An {it:evaluator} is a program you write that calculates the value of the
function being optimized and optionally calculates the function's first and
second derivatives.  The evaluator you write is called by the
{cmd:moptimize()} functions.

{p 8 8 2}
There are five styles in which the evaluator can be written, known as types
{cmd:lf}, {cmd:lf*}, {cmd:d}, {cmd:gf}, and {cmd:q}.
{it:evaluatortype}, optionally specified in 
{cmd:moptimize_init_evaluatortype()}, specifies the style in which 
the evaluator is written.
Allowed values are

{col 16}{it:evaluatortype}{col 32}Description
{col 16}{hline 60}
{col 16}{cmd:"lf"}{col 32}{it:function}{cmd:()} returns {it:N} {it:x} 1 colvector value

{col 16}{cmd:"d0"}{col 32}{it:function}{cmd:()} returns scalar value
{col 16}{cmd:"d1"}{col 32}same as {cmd:"d0"} and returns gradient rowvector
{col 16}{cmd:"d2"}{col 32}same as {cmd:"d1"} and returns Hessian matrix
{col 16}{cmd:"d1debug"}{col 32}same as {cmd:"d1"} but checks gradient
{col 16}{cmd:"d2debug"}{col 32}same as {cmd:"d2"} but checks gradient and Hessian

{col 16}{cmd:"lf0"}{col 32}{it:function}{cmd:()} returns {it:N} {it:x} 1 colvector value
{col 16}{cmd:"lf1"}{col 32}same as {cmd:"lf0"} and returns equation-level
{col 34}score matrix
{col 16}{cmd:"lf2"}{col 32}same as {cmd:"lf1"} and returns Hessian matrix
{col 16}{cmd:"lf1debug"}{col 32}same as {cmd:"lf1"} but checks gradient
{col 16}{cmd:"lf2debug"}{col 32}same as {cmd:"lf2"} but checks gradient and Hessian

{col 16}{cmd:"gf0"}{col 32}{it:function}{cmd:()} returns {it:N} {it:x} 1 colvector value
{col 16}{cmd:"gf1"}{col 32}same as {cmd:"gf0"} and returns score matrix
{col 16}{cmd:"gf2"}{col 32}same as {cmd:"gf1"} and returns Hessian matrix
{col 16}{cmd:"gf1debug"}{col 32}same as {cmd:"gf1"} but checks gradient
{col 16}{cmd:"gf2debug"}{col 32}same as {cmd:"gf2"} but checks gradient and Hessian

{col 16}{cmd:"q0"}{col 32}{it:function}{cmd:()} returns colvector value
{col 16}{cmd:"q1"}{col 32}same as {cmd:"q0"} and returns score matrix
{col 16}{cmd:"q1debug"}{col 32}same as {cmd:"q1"} but checks gradient
{col 16}{hline 60}
{col 16}The default is {cmd:"lf"} if not set.
{col 16}{cmd:"q"} evaluators are used with technique {cmd:"gn"}.
{col 16}Returned gradients are {...}
1 {it:x} {...}
{it:{help mf_moptimize##def_K:K}} {...}
rowvectors.
{col 16}Returned Hessians are {...}
{it:{help mf_moptimize##def_K:K}} {...}
{it:x} {...}
{it:{help mf_moptimize##def_K:K}} {...}
matrices.

{p 8 8 2}
Examples of each of the evaluator types are outlined below.

{p 8 8 2}
You must tell {cmd:moptimize()} the identity and type of your evaluator, 
which you do by using the {cmd:moptimize_init_evaluator()} and 
{cmd:moptimize_init_evaluatortype()} functions.

{marker init_evaluator}{...}
{marker init_evaluatortype}{...}
{p 12 16 2}
{cmd:moptimize_init_evaluator(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {cmd:&}{it:functionname}{cmd:()}{cmd:)}
    sets the identity of the evaluator function that you write in Mata.

{p 12 16 2}
{cmd:moptimize_init_evaluator(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {cmd:"}{it:programname}{cmd:")}
    sets the identity of the evaluator program that you write in Stata.

{p 12 16 2} 
{cmd:moptimize_init_evaluatortype(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:evaluatortype}{cmd:)} informs
    {cmd:moptimize()} of the style of evaluator you have written.
    {it:evaluatortype} is a string scalar from the table above.  The default is
    {cmd:"lf"}.

{marker init_negH}{...}
{p 12 16 2}
{cmd:moptimize_init_negH(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {c -(}{cmd:"off"}|{cmd:"on"}{c )-}{cmd:)}
    sets whether the evaluator you have 
    written returns {it:H} or -{it:H}, the Hessian or the negative 
    of the Hessian, if it returns a Hessian at all.
    This is for backward compatibility with prior versions of 
    Stata's {bf:{help ml:ml}} command.  Modern evaluators return 
    {it:H}.  The default is {cmd:"off"}.


{marker syn_lf}{...}
    {title:Syntax of type lf evaluators}

        {cmd:lfeval}{cmd:(}{it:M}{cmd:,} {it:b}{cmd:,} {it:fv}{cmd:)}:

		{it:inputs}:
			{it:M}:   problem definition
			{it:b}:   coefficient vector
		{it:outputs}:
		       {it:fv}:   {it:N x} 1, {it:N} = # of observations

{p 8 8 2}
Notes:

{p 12 16 2}
1.  The objective function is {it:f}() = {cmd:colsum(}{it:fv}{cmd:)}.

{p 12 16 2}
2.
In the case where {it:f}() is a log-likelihood function, the values of the
log likelihood must be summable over the observations.

{p 12 16 2}
3.
For use with any {help mf_moptimize##def_technique:technique} except {cmd:gn}.

{p 12 16 2}
4.
May be used with robust, clustering, and survey.

{p 12 16 2}
5.
Returns {it:fv} containing missing ({it:fv}={cmd:.}) if evaluation is not 
possible.



{marker syn_dstar}{...}
    {title:Syntax of type d evaluators}

	{cmd:deval}{cmd:(}{...}
{it:M}{cmd:,} {...}
{it:todo}{cmd:,} {...}
{it:b}{cmd:,} {...}
{it:fv}{cmd:,} {it:g}{cmd:,} {it:H}{cmd:)}:

		{it:inputs}:
			{it:M}:   problem definition
		     {it:todo}:   real scalar containing 0, 1, or 2
			{it:b}:   coefficient vector
		{it:outputs}:
		       {it:fv}:   real scalar
			{it:g}:   1 {it:x K}, gradients, {it:K} = # of coefficients
			{it:H}:   {it:K x K}, Hessian

{p 8 8 2}
Notes:

{p 12 16 2}
1.  
The objective function is {it:f}() = {it:fv}.

{p 12 16 2}
2.  For use with any log-likelihood function, or any function.

{p 12 16 2}
3.
For use with any {help mf_moptimize##def_technique:technique} except {cmd:gn}
and {cmd:bhhh}.

{p 12 16 2}
4.
Cannot be used with robust, clustering, or survey.

{p 12 16 2}
5.  
{it:deval}{cmd:()} must always
fill in {it:fv}, and fill in {it:g} if {it:todo}>=1, and fill in 
{it:H} if {it:todo}==2.
For type {cmd:d0}, {it:todo} will always be 0.
For type {cmd:d1} and {cmd:d1debug}, {it:todo} will be 0 or 1.
For type {cmd:d2} and {cmd:d2debug}, {it:todo} will be 0, 1, or 2.

{p 12 16 2}
6.
Returns {it:fv}={cmd:.} if evaluation is not possible.


{marker syn_lfstar}{...}
    {title:Syntax of type lf* evaluators}

	{cmd:lfeval}{cmd:(}{...}
{it:M}{cmd:,} {...}
{it:todo}{cmd:,} {...}
{it:b}{cmd:,} {...}
{it:fv}{cmd:,} {it:S}{cmd:,} {it:H}{cmd:)}:

		{it:inputs}:
			{it:M}:   problem definition
		     {it:todo}:   real scalar containing 0, 1, or 2
			{it:b}:   coefficient vector
		{it:outputs}:
		       {it:fv}:   {it:N x} 1, {it:N} = # of observations
			{it:S}:   {it:N x m}, scores,  {it:m} = # of equations (parameters)
			{it:H}:   {it:K x K}, Hessian, {it:K} = # of coefficients


{p 8 8 2}
Notes:

{p 12 16 2}
1.  
The objective function is {it:f}() = {cmd:colsum(}{it:fv}{cmd:)}.

{p 12 16 2}
2.
Type {cmd:lf*} is a variation of type {cmd:lf} that allows the user to supply
analytic derivatives.
Although {cmd:lf*} could be used with an arbitrary
function, it is intended for use when {it:f}() is a log-likelihood
function and the log-likelihood values are summable over the observations.

{p 12 16 2}
3.
For use with any {help mf_moptimize##def_technique:technique} except {cmd:gn}.

{p 12 16 2}
4.
May be used with robust, clustering, and survey.

{p 12 16 2}
5.  
Always returns {it:fv}, returns {it:S} if {it:todo}>=1, and returns
{it:H} if {it:todo}==2.
For type {cmd:lf0}, {it:todo} will always be 0.
For type {cmd:lf1} and {cmd:lf1debug}, {it:todo} will be 0 or 1.
For type {cmd:lf2} and {cmd:lf2debug}, {it:todo} will be 0, 1, or 2.

{p 12 16 2}
6.
Returns {it:fv} containing missing ({it:fv}={cmd:.}) if evaluation is not 
possible.


{marker syn_gfstar}{...}
    {title:Syntax of type gf evaluators}

	{cmd:gfeval}{cmd:(}{...}
{it:M}{cmd:,} {...}
{it:todo}{cmd:,} {...}
{it:b}{cmd:,} {...}
{it:fv}{cmd:,} {it:S}{cmd:,} {it:H}{cmd:)}:

		{it:inputs}:
			{it:M}:   problem definition
		     {it:todo}:   real scalar containing 0, 1, or 2
			{it:b}:   coefficient vector
		{it:outputs}:
		       {it:fv}:   {it:L x 1}, values, {it:L} = # of independent elements
			{it:S}:   {it:L x K}, scores, {it:K} = # of coefficients
			{it:H}:   {it:K x K}, Hessian

{p 8 8 2}
Notes:

{p 12 16 2}
1.  The objective function is {it:f}() = {cmd:colsum(}{it:fv}{cmd:)}.

{p 12 16 2}
2.  Type {cmd:gf} is a variation on type {cmd:lf*} that relaxes the requirement
    that the log-likelihood function be summable over the observations.
    {cmd:gf} is especially useful for fitting panel-data models with 
    {help mf_moptimize##def_technique:technique} {cmd:bhhh}.
    Then {it:L} is the number of panels.

{p 12 16 2}
3.
For use with any {help mf_moptimize##def_technique:technique} except {cmd:gn}.

{p 12 16 2}
4.
May be used with robust, clustering, and survey.

{p 12 16 2}
5.  
Always returns {it:fv}, returns {it:S} if {it:todo}>=1, and returns
{it:H} if {it:todo}==2.
For type {cmd:gf0}, {it:todo} will always be 0.
For type {cmd:gf1} and {cmd:gf1debug}, {it:todo} will be 0 or 1.
For type {cmd:gf2} and {cmd:gf2debug}, {it:todo} will be 0, 1, or 2.

{p 12 16 2}
6.
Returns {it:fv}={cmd:.} if evaluation is not possible.


{marker syn_qstar}{...}
{marker def_W}{...}
{marker def_L}{...}
    {title:Syntax of type q evaluators}

	{cmd:qeval}{cmd:(}{...}
{it:M}{cmd:,} {...}
{it:todo}{cmd:,} {...}
{it:b}{cmd:,} {...}
{it:r}{cmd:,} {it:S}{cmd:)}:

		{it:inputs}:
			{it:M}:   problem definition
		     {it:todo}:   real scalar containing 0 or 1
			{it:b}:   coefficient vector
		{it:outputs}:
			{it:r}:   {it:L x 1} of independent elements
			{it:S}:   {it:L x K}, scores, {it:K} = # of coefficients

{p 8 8 2}
Notes:

{p 12 16 2}
1.
Type {cmd:q} is for quadratic optimization.
The objective function is {it:f}() = {it:r'Wr}, where 
{it:r} is returned by {it:qeval}{cmd:()} and 
{it:W}
has been previously set by using 
{cmd:moptimize_init_gnweightmatrix()}, described below.

{p 12 16 2}
2.
For use only with {help mf_moptimize##def_technique:techniques} {cmd:gn}
and {cmd:nm}.

{p 12 16 2}
3.  
Always returns {it:r} and returns {it:S} if {it:todo}==1.
For type {cmd:q0}, {it:todo} will always be 0.
For type {cmd:q1} and {cmd:q1debug}, {it:todo} will be 0 or 1.
There is no type {cmd:q2}.

{p 12 16 2}
4.
Returns {it:r} containing missing, or {it:r}={cmd:.}
if evaluation is not possible.

{marker init_gnweightmatrix}{...}
{p 8 8 2}
Use {cmd:moptimize_init_gnweightmatrix()} during initialization to set matrix
{it:W}.

{p 12 16 2}
{cmd:moptimize_init_gnweightmatrix(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:{help mf_moptimize##def_W:W}}{cmd:)}
    sets real matrix {it:W}: {it:L} {it:x} {it:L}, which is used only by type
    {cmd:q} evaluators.  The objective function
    is {it:r}'{it:W}{it:r}.
    If {it:W} is not set and if
    observation weights {it:w} are set by using 
    {bf:{help mf_moptimize##init_weight:moptimize_init_weight()}},
    then {it:W} = diag({it:w}).  If {it:w} is not set, then {it:W} is the
    identity matrix.

{p 16 16 2}
{cmd:moptimize()} does not produce a robust VCE when you set {it:W} with
{cmd:moptimize_init_gnweight()}.


{marker def_l}{...}
{marker def_Z}{...}
{marker def_n_user}{...}
{marker syn_extra}{...}
{marker init_userinfo}{...}
    {title:Passing extra information to evaluators}

{p 4 4 2}
In addition to the arguments the evaluator receives, you may arrange that
extra information be sent to the evaluator.  Specify the extra information
to be sent by using {cmd:moptimize_init_userinfo()}.

{p 8 12 2}
{cmd:moptimize_init_userinfo(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:l}{cmd:,} {it:Z}{cmd:)} specifies that the {it:l}th piece of 
    extra information is {it:Z}.  {it:l} is a real scalar.  The first 
    piece of extra information should be 1; the second piece, 2; and 
    so on.  {it:Z} can be anything.  No copy of {it:Z} is made.  

{p 8 12 2}
{cmd:moptimize_init_nuserinfo(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:n_user}{cmd:)} specifies the total number of extra pieces of 
    information to be sent.  Setting {it:n_user} is optional;
    it will be automatically determined from the 
    {cmd:moptimize_init_userinfo()} calls you issue.

{p 4 4 2}
Inside your evaluator, you access the information by using
{cmd:moptimize_util_userinfo()}.

{p 8 12 2}
{cmd:moptimize_util_userinfo(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:l}{cmd:)} returns the {it:Z} set by {cmd:moptimize_init_userinfo()}.


{marker syn_util}{...}
    {title:Utility functions}

{p 4 4 2}
There are various utility functions that are helpful in writing 
{help mf_moptimize##syn_alleval:evaluators} and in processing results returned
by the {bf:{help mf_moptimize##syn_results:moptimize_result_*()}} functions.

{marker util_depvar}{...}
{marker util_xb}{...}
{p 4 4 2}
The first set of utility functions are useful in writing evaluators, and the
first set return results that all evaluators need.

{p 8 12 2}
{cmd:moptimize_util_depvar(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:{help mf_moptimize##def_j:j}}{cmd:)}
    returns an {it:Nj} {it:x} 1 colvector containing the 
    values of the {it:j}th dependent variable, the values 
    set by {cmd:moptimize_init_depvar(}{it:M}{cmd:,}
    {it:j}{cmd:,} ...{cmd:)}.

{p 8 12 2}
{cmd:moptimize_util_xb(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_b:b}}{cmd:,}
    {it:{help mf_moptimize##def_i:i}}{cmd:)} returns 
    the {it:Ni} {it:x} 1 colvector containing 
    the value of the {it:i}th {help mf_moptimize##def_i:parameter}, 
    which is usually 
    {it:Xi*bi}' {cmd::+} {it:b0i}, but might be as complicated as
    {it:Xi*bi}' + {it:oi} + ln({it:ti}) {cmd::+} {it:b0i}.

{p 4 4 2}
Once the inputs of an evaluator have been processed, the following 
functions assist in making the calculations required of evaluators.

{marker util_sum}{...}
{p 8 12 2}
{cmd:moptimize_util_sum(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:v}{cmd:)}
    returns the "sum" of colvector {it:v}.
    This function 
    is for use in evaluators that require you to return an overall 
    objective function value rather than observation-by-observation
    results.  Usually,
    {cmd:moptimize_util_sum()} returns {cmd:sum(}{it:v}{cmd:)}, 
    but in cases where you have specified a weight by using 
    {bf:{help mf_moptimize##init_weight:moptimize_init_weight()}}
    or there is an implied 
    weight due to use of 
    {bf:{help mf_moptimize##init_svy:moptimize_init_svy()}}, 
    the appropriately weighted sum is returned.
    Use {cmd:moptimize_util_sum()} to sum log-likelihood values.

{marker util_vecsum}{...}
{p 8 12 2}
{cmd:moptimize_util_vecsum(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}{cmd:,}
    {it:s}{cmd:,} {it:value}{cmd:)}
    is like {cmd:moptimize_util_sum()}, but for use with gradients.
    The gradient is defined as the vector of partial derivatives of {it:f}() 
    with respect to the coefficients {it:bi}.  Some evaluator types require 
    that your evaluator be able to return this vector.
    Nonetheless, 
    it is usually easier to write your evaluator in terms of parameters 
    rather than coefficients, and this function handles 
    the mapping of parameter gradients to the required coefficient gradients.

{p 12 12 2}
    Input {it:s} is an 
    {it:Ni} {it:x} 1 colvector containing d{it:f}/d{it:pi} for each 
    observation. d{it:f}/d{it:pi} is the partial derivative 
    of the objective function, but with respect to the {it:i}th parameter 
    rather than the {it:i}th set of coefficients.
    {cmd:moptimize_util_vecsum()} takes {it:s} and returns the 
    1 {it:x} ({it:ki}+{it:ci}) summed gradient.
    Also weights, if any, are factored into the 
    calculation.

{p 12 12 2}
    If you have more than one equation, you will need to call 
    {cmd:moptimize_util_vecsum()} {it:m} times, once for each 
    equation, and then concatenate the individual results into
    one vector.

{p 12 12 2}
    {it:value} plays no role in {cmd:moptimize_util_vecsum()}'s
    calculations.  
    {it:value}, however, should be specified as the result obtained from 
    {cmd:moptimize_util_sum()}.  If that is inconvenient, make 
    {it:value} any nonmissing value.  If the calculation from 
    parameter space to vector space cannot be performed, or if your
    original parameter space derivatives have any missing values, 
    {it:value} will be changed to missing.  Remember, when a calculation 
    cannot be made, the evaluator is to return 
    a missing value for the objective function.  Thus
    storing the value of the objective function in {it:value} 
    ensures that your evaluator will return missing if it is supposed to.

{marker util_matsum}{...}
{p 8 12 2}
{cmd:moptimize_util_matsum(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
{it:{help mf_moptimize##def_i:i}}{cmd:,} 
{it:{help mf_moptimize##def_i2:i2}}{cmd:,} 
{it:s}{cmd:,}
{it:value}{cmd:)}
    is similar to {cmd:moptimize_util_vecsum()}, but for 
    Hessians (matrix of second derivatives).

{p 12 12 2}
    Input {it:s} is an {it:Ni} {it:x} 1 colvector containing 
    d^2{it:f}/d{it:pi}d{it:pi2} for each observation.  
    {cmd:moptimize_util_matsum()} returns the 
    ({it:ki}+{it:ci}) {it:x} ({it:ki2}+{it:ci2}) summed Hessian.  Also 
    weights, if any, are factored into the calculation.

{p 12 12 2}
    If you have {it:m}>1 equations, you will need to call 
    {cmd:moptimize_util_matsum()} {it:m}*({it:m}+1)/2 times and 
    then join the results into one symmetric matrix.

{p 12 12 2}
    {it:value} plays no role in the calculation and works the same way 
    it does in {cmd:moptimize_util_vecsum()}.

{marker util_matbysum}{...}
{p 8 12 2}
{cmd:moptimize_util_matbysum()} is an added helper for making
    {cmd:moptimize_util_matsum()} calculations in cases where you have panel
    data and the log-likelihood function's values exists only at the panel
    level.
    {cmd:moptimize_util_matbysum(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}{cmd:,} 
    {it:a}{cmd:,}
    {it:b}{cmd:,}
    {it:value}{cmd:)}
    is for making diagonal calculations and 
    {cmd:moptimize_util_matbysum(}{it:{help mf_moptimize##def_M:M}}{cmd:,} 
    {it:{help mf_moptimize##def_i:i}}{cmd:,} 
    {it:{help mf_moptimize##def_i:i2}}{cmd:,}
    {it:a}{cmd:,}
    {it:b}{cmd:,}
    {it:c}{cmd:,}
    {it:value}{cmd:)}
    is for making off-diagonal calculations.

{p 12 12 2}
    This is an advanced topic;
    see {help mf_moptimize##GPP2010:Gould, Pitblado, and Poi (2010, 136-138)}
    for a full description 
    of it.  In applying the chain rule to translate results from 
    parameter space to coefficient space, {cmd:moptimize_util_matsum()} 
    can be used to make some of the calculations, and 
    {cmd:moptimize_util_matbysum()} can be used to make the rest.
    {it:value} plays no role and works just as it did in the other helper
    functions.
    {cmd:moptimize_util_matbysum()} is for use sometimes when 
    {it:by} has been set, which is done via 
    {cmd:moptimize_init_by(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:{help mf_moptimize##def_by:by}}{cmd:)}.  
    {cmd:moptimize_util_matbysum()} is never required unless {it:by} 
    has been set.
{* put the formulas from pg 118 of ML book 3d here in manual entry *}

{marker util_by}{...}
{p 8 12 2}
{cmd:moptimize_util_by()} returns a pointer to the vector of group identifiers
that were set using {cmd:moptimize_init_by()}.  This vector can be used with
{helpb mf_panelsetup:panelsetup()} to perform panel level calculations.

{marker _eq_indices}{...}
{p 4 4 2}
The other utility functions are useful inside or outside of evaluators.
One of the more useful is {cmd:moptimize_util_eq_indices()}, which allows
two or three arguments.

{p 8 12 2}
{cmd:moptimize_util_eq_indices(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:{help mf_moptimize##def_i:i}}{cmd:)}
    returns a 1 {it:x} 2 vector that can be used with 
    {help m2_subscripts:range subscripts}
    to extract the portion relevant for the {it:i}th equation 
    from any 1 {it:x} {it:{help mf_moptimize##def_K:K}} vector, that is,
    from any vector conformable with the 
    {help mf_moptimize##def_K:full coefficient vector}.

{p 8 12 2}
{cmd:moptimize_util_eq_indices(}{it:{help mf_moptimize##def_M:M}}{cmd:,}
    {it:{help mf_moptimize##def_i:i}}{cmd:,} 
    {it:{help mf_moptimize##def_i2:i2}}{cmd:)}
    returns a 2 {it:x} 2 matrix that can be used with 
    {help m2_subscripts:range subscripts}
    to exact the portion relevant for the {it:i}th and {it:i2}th equations 
    from any 
    {it:{help mf_moptimize##def_K:K}} 
    {it:x}
    {it:{help mf_moptimize##def_K:K}} 
    matrix, that is,
    from any matrix with rows and columns conformable with the
    full variance matrix.

{p 4 4 2}
For instance, let 
{cmd:b} be the 1 {it:x} {it:K} full coefficient vector, perhaps obtained 
by being passed into an evaluator, or perhaps obtained from 
{cmd:b} = {cmd:moptimize_result_coefs(}{it:M}{cmd:)}.
Then
{cmd:b[|moptimize_util_eq_indices(}{it:M}{cmd:,} {it:i}{cmd:)|]}
is the 1 {it:x} ({it:ki}+{it:ci}) vector of coefficients 
for the {it:i}th equation.

{p 4 4 2}
Let {cmd:V} be the {it:K} {it:x} {it:K} full variance matrix obtained by 
{cmd:V} = {cmd:moptimize_result_V(}{it:M}{cmd:)}.
Then 
{cmd:V[|moptimize_util_eq_indices(}{it:M}{cmd:,} {it:i}{cmd:,} {it:i}{cmd:)|]}
is the ({it:ki}+{it:ci}) {it:x} ({it:ki}+{it:ci}) variance matrix for the 
{it:i}th equation.
{cmd:V[|moptimize_util_eq_indices(}{it:M}{cmd:,} {it:i}{cmd:,} {it:j}{cmd:)|]}
is the ({it:ki}+{it:ci}) {it:x} ({it:kj}+{it:cj}) covariance matrix between the
{it:i}th and {it:j}th equations.

{marker _query}{...}
{p 4 4 2}
Finally, there is one more utility function that may help when you become 
confused:  {cmd:moptimize_query()}.

{p 8 12 2}
{cmd:moptimize_query(}{it:{help mf_moptimize##def_M:M}}{cmd:)}
    displays in readable form everything you have set via the 
    {bf:{help mf_moptimize##syn_step2:moptimize_init_}{it:*}{cmd:()}} functions,
    along with the status of the system.


{marker description}{...}
{title:Description}

{p 4 4 2}
The {cmd:moptimize()} functions find coefficients
({bf:b}1, {bf:b}2, ..., {bf:b}{it:m}) that maximize or minimize 
{it:f}({bf:p}1, {bf:p}2, ..., {bf:p}{it:m}), where 
{bf:p}{it:i} = {bf:X}{it:i}*{bf:b}{it:i}', a linear combination of 
{bf:b}{it:i} and the data.
The user of {cmd:moptimize()} writes a Mata function or Stata program 
to evaluate 
{it:f}({bf:p}1, {bf:p}2, ..., {bf:p}{it:m}).
The data can be in Mata matrices or in the Stata dataset currently 
residing in memory.

{p 4 4 2}
{cmd:moptimize()} is especially useful for obtaining solutions for 
maximum likelihood models, minimum chi-squared models, minimum squared-residual
models, and the like.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 moptimize()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_moptimize##rem_relation:Relationship of moptimize() to Stata's ml and to Mata's optimize()}
	{help mf_moptimize##rem_math:Mathematical statement of the moptimize() problem}
	{help mf_moptimize##rem_fill:Filling in moptimize() from the mathematical statement}
	{help mf_moptimize##rem_lf:The type lf evaluator}
	{help mf_moptimize##rem_dlfgfq:The type d, lf*, gf, and q evaluators}
	{help mf_moptimize##rem_d:Example using type d}
	{help mf_moptimize##rem_e:Example using type lf*}



{marker rem_relation}{...}
{title:Relationship of moptimize() to Stata's ml and to Mata's optimize()}

{p 4 4 2}
{cmd:moptimize()} is Mata's and Stata's premier optimization routine.  
This is the routine used by most of the official optimization-based estimators
implemented in Stata.

{p 4 4 2}
That said, Stata's {cmd:ml} command -- see {bf:{help ml:[R] ml}} --
provides most of the capabilities of Mata's {cmd:moptimize()}, and {cmd:ml} is
easier to use.  In fact, {cmd:ml} uses {cmd:moptimize()} to perform the
optimization, and {cmd:ml} amounts to little more than a shell providing a
friendlier interface.  If you have a maximum-likelihood model you wish to fit,
we recommend you use {cmd:ml} instead of {cmd:moptimize()}.  Use
{cmd:moptimize()} when you need or want to work in the Mata environment, or
when you wish to implement a specialized system for fitting a class of models.

{p 4 4 2}
Also make note of Mata's {cmd:optimize()} function; see 
{bf:{help mf_optimize:[M-5] optimize()}}.  {cmd:moptimize()} finds coefficients
({bf:b}1, {bf:b}2, ..., {bf:b}{it:m}) that maximize or minimize
{it:f}({bf:p}1, {bf:p}2, ..., {bf:p}{it:m}), where {bf:p}{it:i} = 
{bf:X}{it:i}*{bf:b}{it:i}.
{cmd:optimize()} handles a
simplified form of the problem, namely, finding constant 
({it:p}1, {it:p}2, ..., {it:p}{it:m}) that maximizes or minimizes
{it:f}().  {cmd:moptimize()}
is the appropriate routine for fitting a Weibull model, but if all 
you need 
to estimate are the fixed parameters of the Weibull distribution for some
population, {cmd:moptimize()} is overkill and {cmd:optimize()} will prove
easier to use.

{p 4 4 2}
These three routines are all related.  Stata's {cmd:ml} uses {cmd:moptimize()}
to do the numerical work.  {cmd:moptimize()}, in turn, uses {cmd:optimize()} to
perform certain calculations, including the search for parameters.  There is
nothing inferior about {cmd:optimize()} except that it cannot efficiently deal
with models in which parameters are given by linear combinations of
coefficients and data.


{marker rem_math}{...}
{title:Mathematical statement of the moptimize() problem}

{p 4 4 2}
We mathematically describe the problem {cmd:moptimize()} solves
not merely to fix notation and ease communication, but also because there is a
one-to-one correspondence between the mathematical notation and the
{cmd:moptimize}{it:*}{cmd:()} functions.  Simply writing your problem in the
following notation makes obvious the {cmd:moptimize}{it:*}{cmd:()} functions
you need and what their arguments should be.

{p 4 4 2}
In what follows, we are going to simplify the mathematics a little.
For instance, we are about to claim 
{bf:p}{it:i} = {bf:X}{it:i}*{bf:b}{it:i} {cmd::+} {it:c}{it:i},
when in the syntax section, you will see that 
{bf:p}{it:i} = {bf:X}{it:i}*{bf:b}{it:i} + {bf:o}{it:i} + ln({bf:t}{it:i})
{cmd::+} {it:c}{it:i}.  Here we omit {bf:o}{it:i} and ln({bf:t}{it:i}) because
they are seldom used.  We will omit some other details, too.  The statement of
the problem under
{it:{help mf_moptimize##syntax:Syntax}}, above, is the full and accurate
statement.  We will also use typefaces a little differently.  In the syntax
section, we use italics following programming convention.  In what follows, we
will use boldface for matrices and vectors, and italics for scalars so that you
can follow the math more easily.  So in this section, we will write
{bf:b}{it:i}, whereas under syntax we would write {it:bi}; regardless of
typeface, they mean the same thing.

{p 4 4 2}
Function {cmd:moptimize()} finds coefficients 

        	{bf:b} = (({bf:b}1,{it:c}1), ({bf:b}2,{it:c}2) ..., ({bf:b}{it:m},{it:cm})) 

{p 4 4 2}
where

		     {bf:b}1: 1 {it:x} {it:k}1,  {...}
{bf:b}2: 1 {it:x} {it:k}2,  {...}
...,   {...}
{bf:b}{it:m}: 1 {it:x} {it:km}
		     {it:c}1: 1 {it:x} 1,   {...}
{it:c}2: 1 {it:x} 1,   {...}
...,   {...}
{it:c}{it:m}: 1 {it:x} 1

{p 4 4 2}
that maximize or minimize function 

		{it:f}({bf:p}1, {bf:p}2, ..., {bf:p}{it:m}; {bf:y}1, {bf:y}2, ..., {bf:y}{it:D})

{p 4 4 2}
where

		     {bf:p}1 = {bf:X}1*{bf:b}1' {cmd::+} {it:c}1,{...}
{col 55}{bf:X}1: {it:N}1 {it:x} {it:k}1
		     {bf:p}2 = {bf:X}2*{bf:b}2' {cmd::+} {it:c}2,{...}
{col 55}{bf:X}2: {it:N}2 {it:x} {it:k}2
		     .
		     .
		     {bf:p}{it:m} = {bf:X}{it:m}*{bf:b}{it:m}' {cmd::+} {it:cm},{...}
{col 55}{bf:X}{it:m}: {it:N}{it:m} {it:x} {it:k}{it:m}

{p 4 4 2}
and where {bf:y}1, {bf:y}2, ..., {bf:y}{it:D} are of arbitrary dimension.

{p 4 4 2}
Usually, {it:N}1 = {it:N}2 = ... = {it:N}{it:m}, and the model is said to be
fit on data of {it:N} observations.  Similarly, column vectors {bf:y}1,
{bf:y}2, ..., {bf:y}{it:D} are usually called dependent variables, and each is
also of {it:N} observations.

{p 4 4 2}
As an example, let's write the maximum-likelihood estimator for linear
regression in the above notation.  We begin by stating the problem in the
usual way, but in Mata-ish notation:

{p 12 12 2}
Given data {bf:y}: {it:N} {it:x} 1 and {bf:X}: {it:N x k}, 
obtain 
(({bf:b},{it:c}), {it:s}^2) to fit 

			{bf:y} = {bf:X}*{bf:b}' {cmd::+} {it:c} + {bf:u}

{p 12 12 2}
where the elements of {bf:u} are distributed {it:N}(0, {it:s}^2).
The log-likelihood function is

		lnL = Sum_j {cmd:ln(normalden(}{bf:y}_{it:j}-({bf:X}_{it:j}*{bf:b}'{cmd::+}{it:c}){cmd:,} 0{cmd:,} {cmd:sqrt(}{it:s}^2{cmd:)))}

{p 12 12 2}
where {cmd:normalden(}{it:x}{cmd:,} {it:mean}{cmd:,} {it:sd}{cmd:)} 
returns the density 
at {it:x} of the Gaussian normal with the specified mean and standard
deviation; see {bf:{help mf_normal:[M-5] normal()}}.

{p 4 4 2}
The above is a two-parameter or, equivalently, two-equation model in
{cmd:moptimize()} jargon.  There may be many coefficients, but the 
likelihood function can be written in terms of 
two parameters, namely {bf:p}1 = {bf:X}*{bf:b}' {cmd::+} {it:c} and
{bf:p}2 = {it:s}^2.  Here is the problem stated in the {cmd:moptimize()}
notation:

{p 12 12 2}
Find coefficients

        	{bf:b} = (({bf:b}1,{it:c}1), ({it:c}2))

{p 12 12 2}
where

		     {bf:b}1: 1 {it:x} {it:k}
		     {it:c}1: 1 {it:x} 1,   {...}
{it:c}2: 1 {it:x} 1

{p 12 12 2}
that maximize

		{it:f}({bf:p}1, {bf:p}2; {bf:y}) = {...}
Sum {cmd:ln(normalden(}{bf:y}-{bf:p}1{cmd:,} 0{cmd:,} {cmd:sqrt(}{bf:p}2{cmd:))}

{p 12 12 2}
where

		     {bf:p}1 = {bf:X}*{bf:b}1' {cmd::+} {it:c}1,{...}
{col 55}{bf:X}: {it:N} {it:x} {it:k}
		     {bf:p}2 = {it:c}2

{p 12 12 2}
and where {it:y} is {it:N} {it:x} 1.

{p 4 4 2}
Notice that, in this notation, the regression coefficients ({bf:b}1, {it:c}1)
play a secondary role, namely, to determine {bf:p}1.  That is, the function,
{it:f}(), to be optimized -- a log-likelihood function here -- is
written in terms of {bf:p}1 and {bf:p}2.  The program you will write to
evaluate {it:f}() will be written in terms of {bf:p}1 and {bf:p}2, thus
abstracting from the particular regression model being fit.  Whether the
regression is mpg on weight or log income on age, education, and experience,
your program to calculate {it:f}() will remain unchanged.  All that will
change are the definitions of {bf:y} and {bf:X}, which you will communicate to
{cmd:moptimize()} separately.

{p 4 4 2}
There is another advantage to this arrangement.  We can trivially generalize
linear regression without writing new code.  Note that the variance {it:s}^2
is given by {bf:p}2, and currently, we have {bf:p}2 = {it:c}2, that is,
a constant.  {cmd:moptimize()} allows parameters to be constant, but it
equally allows them to be given by a linear combination.  Thus rather than
defining {bf:p}2 = {it:c}2, we could define {bf:p}2 = {bf:X}2*{bf:b}2' {cmd::+}
{it:c}2.  If we did that, we would have a second linear equation that allowed
the variance to vary observation by observation.  As far as {cmd:moptimize()}
is concerned, that problem is the same as the original problem.


{marker rem_fill}{...}
{title:Filling in moptimize() from the mathematical statement}

{p 4 4 2}
The mathematical statement of our sample problem is the following:

{p 12 12 2}
Find coefficients

        	{bf:b} = (({bf:b}1,{it:c}1), ({it:c}2))

{p 12 12 2}
where
		     {bf:b}1: 1 {it:x} {it:k}
		     {it:c}1: 1 {it:x} 1,   {...}
{it:c}2: 1 {it:x} 1

{p 12 12 2}
that maximize

		{it:f}({bf:p}1, {bf:p}2; {bf:y}) = {...}
Sum {cmd:ln(normalden(}{bf:y}-{bf:p}1{cmd:,} 0{cmd:,} {cmd:sqrt(}{bf:p}2{cmd:))}

{p 12 12 2}
where

		     {bf:p}1 = {bf:X}*{bf:b}1' {cmd::+} {it:c}1,{...}
{col 55}{bf:X}: {it:N} {it:x} {it:k}
		     {bf:p}2 = {it:c}2

{p 12 12 2}
and where {it:y} is {it:N} {it:x} 1.

{p 4 4 2}
The corresponding code to perform the optimization is 

	    {cmd}. sysuse auto, clear 

	    . mata:

	    : function linregeval(transmorphic M,
	                          real rowvector b,
	                          real colvector lnf)
	      {
       	              real colvector  p1, p2
       	              real colvector  y1
	     
       	              p1 = moptimize_util_xb(M, b, 1)
       	              p2 = moptimize_util_xb(M, b, 2)
       	              y1 = moptimize_util_depvar(M, 1)
	      
	              lnf = ln(normalden(y1:-p1, 0, sqrt(p2)))
	      }

	    : M = moptimize_init()
	    : moptimize_init_evaluator(M, &linregeval())
	    : moptimize_init_depvar(M, 1, "mpg")
	    : moptimize_init_eq_indepvars(M, 1, "weight foreign")
	    : moptimize_init_eq_indepvars(M, 2, "")
	    : moptimize(M)
	    : moptimize_result_display(M){txt}

{p 4 4 2}
Here is the result of running the above code:

{* junk1.smcl from example1.do, but remove evaluatortype()}{...}
  {c TLC}{hline 75}{c TRC}
  {txt:{c |}} {com}{sf}{ul off}{txt}{com}. sysuse auto, clear{col 79}{c |}
  {txt:{c |}}  {txt}(1978 Automobile Data){col 79}{c |}
  {txt:{c |}}{col 79}{c |}
  {txt:{c |}} {com}. mata:{col 79}{c |}
  {txt:{c |}} {txt}{hline 38} mata (type {cmd:end} to exit) {hline 3}{col 79}{c |}
  {txt:{c |}} {com}: function linregeval(transmorphic M, {col 79}{c |}
  {txt:{c |}} >                 real rowvector b,{col 79}{c |}
  {txt:{c |}} >                 real colvector lnf){col 79}{c |}
  {txt:{c |}} >                 {col 79}{c |}
  {txt:{c |}} > {c -(}{col 79}{c |}
  {txt:{c |}} >         real colvector  p1, p2{col 79}{c |}
  {txt:{c |}} >         real colvector  y1{col 79}{c |}
  {txt:{c |}} > {col 79}{c |}
  {txt:{c |}} >         p1 = moptimize_util_xb(M, b, 1){col 79}{c |}
  {txt:{c |}} >         p2 = moptimize_util_xb(M, b, 2){col 79}{c |}
  {txt:{c |}} >         y1 = moptimize_util_depvar(M, 1){col 79}{c |}
  {txt:{c |}} > {col 79}{c |}
  {txt:{c |}} >         lnf = ln(normalden(y1:-p1, 0, sqrt(p2))){col 79}{c |}
  {txt:{c |}} > {c )-}{col 79}{c |}
  {txt:{c |}} : {col 79}{c |}
  {txt:{c |}} : M = moptimize_init() {col 79}{c |}
  {txt:{c |}} {res}{txt}{col 79}{c |}
  {txt:{c |}} {com}: moptimize_init_evaluator(M, &linregeval()){txt:{col 79}{c |}}
  {txt:{c |}} {res}{txt:{col 79}{c |}}
  {txt:{c |}} {com}: moptimize_init_depvar(M, 1, "mpg"){txt:{col 79}{c |}}
  {txt:{c |}} {res}{txt:{col 79}{c |}}
  {txt:{c |}} {com}: moptimize_init_eq_indepvars(M, 1, "weight foreign"){txt:{col 79}{c |}}
  {txt:{c |}} {res}{txt:{col 79}{c |}}
  {txt:{c |}} {com}: moptimize_init_eq_indepvars(M, 2, ""){txt:{col 79}{c |}}
  {txt:{c |}} {res}{txt:{col 79}{c |}}
  {txt:{c |}} {com}: moptimize(M){txt:{col 79}{c |}}
  {txt:{c |}} {res}{txt}initial:{col 20}f(p) = {res:    -<inf>}  (could not be evaluated){txt:{col 79}{c |}}
  {txt:{c |}} feasible:{col 20}f(p) = {res:-12949.708}{txt:{col 79}{c |}}
  {txt:{c |}} rescale:{col 20}f(p) = {res:-243.04355}{txt:{col 79}{c |}}
  {txt:{c |}} rescale eq:{col 20}f(p) = {res:-236.58999}{txt:{col 79}{c |}}
  {txt:{c |}} Iteration 0:{col 20}f(p) = {res:-236.58999}  (not concave){txt:{col 79}{c |}}
  {txt:{c |}} Iteration 1:{col 20}f(p) = {res:-227.46735}  {txt:{col 79}{c |}}
  {txt:{c |}} Iteration 2:{col 20}f(p) = {res:-205.73496}  (backed up){txt:{col 79}{c |}}
  {txt:{c |}} Iteration 3:{col 20}f(p) = {res:-195.72762}  {txt:{col 79}{c |}}
  {txt:{c |}} Iteration 4:{col 20}f(p) = {res:-194.20885}  {txt:{col 79}{c |}}
  {txt:{c |}} Iteration 5:{col 20}f(p) = {res:-194.18313}  {txt:{col 79}{c |}}
  {txt:{c |}} Iteration 6:{col 20}f(p) = {res:-194.18306}  {txt:{col 79}{c |}}
  {txt:{c |}} Iteration 7:{col 20}f(p) = {res:-194.18306}  {txt:{col 79}{c |}}
  {txt:{c |}}{txt:{col 79}{c |}}
  {txt:{c |}} {com}: moptimize_result_display(M){txt:{col 79}{c |}}
  {txt:{c |}} {res}{txt:{col 79}{c |}}
  {txt:{c |}}{txt}{col 51}Number of obs{col 67}= {res}        74{txt:{col 79}{c |}}
  {txt:{c |}}{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{text}{hline 9}{c TT}{hline 11}{hline 11}{hline 9}{hline 9}{hline 12}{hline 12}{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{text}     mpg{col 14}{c |}      Coef.{col 26}   Std. Err.{col 37}      z{col 46}   P>|z|{col 55}    [95% Conf. Interval]{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{text}{hline 9}{c +}{hline 11}{hline 11}{hline 9}{hline 9}{hline 12}{hline 12}{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{result}eq1     {col 14}{text}{c |}{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{text}  weight{col 14}{c |}{result}{space 2}-.0065879{col 26}{space 2} .0006241{col 37}{space 1}  -10.56{col 46}{space 3}0.000{col 55}{space 3} -.007811{col 67}{space 3}-.0053647{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{text} foreign{col 14}{c |}{result}{space 2}-1.650029{col 26}{space 2} 1.053958{col 37}{space 1}   -1.57{col 46}{space 3}0.117{col 55}{space 3}-3.715749{col 67}{space 3} .4156903{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{text}   _cons{col 14}{c |}{result}{space 2}  41.6797{col 26}{space 2} 2.121197{col 37}{space 1}   19.65{col 46}{space 3}0.000{col 55}{space 3} 37.52223{col 67}{space 3} 45.83717{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{text}{hline 9}{c +}{hline 11}{hline 11}{hline 9}{hline 9}{hline 12}{hline 12}{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{result}eq2     {col 14}{text}{c |}{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{text}   _cons{col 14}{c |}{result}{space 2} 11.13746{col 26}{space 2} 1.830987{col 37}{space 1}    6.08{col 46}{space 3}0.000{col 55}{space 3}  7.54879{col 67}{space 3} 14.72613{txt:{col 79}{c |}}
  {txt:{c |}}{col 5}{text}{hline 9}{c BT}{hline 11}{hline 11}{hline 9}{hline 9}{hline 12}{hline 12}{txt:{col 79}{c |}}
  {txt:{c |}}{txt:{col 79}{c |}}
  {c BLC}{hline 75}{c BRC}


{marker rem_lf}{...}
{title:The type lf evaluator}

{p 4 4 2}
Let's now interpret the code we wrote, which was

	    {cmd}: function linregeval(transmorphic M,
	                          real rowvector b,
	                          real colvector lnf)
	      {
       	              real colvector  p1, p2
       	              real colvector  y1
	     
       	              p1 = moptimize_util_xb(M, b, 1)
       	              p2 = moptimize_util_xb(M, b, 2)
       	              y1 = moptimize_util_depvar(M, 1)
	      
	              lnf = ln(normalden(y1:-p1, 0, sqrt(p2)))
	      }

	    : M = moptimize_init()
	    : moptimize_init_evaluator(M, &linregeval())
	    : moptimize_init_depvar(M, 1, "mpg")
	    : moptimize_init_eq_indepvars(M, 1, "weight foreign")
	    : moptimize_init_eq_indepvars(M, 2, "")
	    : moptimize(M)
	    : moptimize_result_display(M){txt}

{p 4 4 2}
We first defined the function to evaluate our likelihood function -- we named
the function {cmd:linregeval()}.  The name was of our choosing.  After that,
we began an optimization problem by typing {cmd:M} {cmd:=}
{cmd:moptimize_init()}, described the problem with
{cmd:moptimize_init_}{it:*}{cmd:()} functions, performed the optimization by
typing {cmd:moptimize()}, and displayed results by using
{cmd:moptimize_result_display()}.

{p 4 4 2}
Function {cmd:linregeval()} is an example of a type {cmd:lf} evaluator.
There are several different evaluator types, including {cmd:d0}, 
{cmd:d1}, {cmd:d2}, through {cmd:q1}.  Of all of them, type {cmd:lf}
is the easiest to use and is the one {cmd:moptimize()} uses unless we tell it
differently.  What makes {cmd:lf} easy is that we need only
calculate the likelihood function; we are not required to calculate its
derivatives.  A description of {cmd:lf} appears under the heading
{it:{help mf_moptimize##syn_lf:Syntax of type lf evaluators}} under 
{it:Syntax} above.

{p 4 4 2}
In the syntax diagrams, you will see that type {cmd:lf} evaluators receive
three arguments, {it:M}, {it:b}, and {it:fv}, although in {cmd:linregeval()},
we decided to call them {cmd:M}, {cmd:b}, and {cmd:lnf}.  The first two
arguments are inputs, and your evaluator is expected to fill in
the third argument with observation-by-observation values of the log-likelihood
function.

{p 4 4 2}
The input arguments are {cmd:M} and {cmd:b}.  {cmd:M} is the problem handle,
which we have not explained yet.  Basically, all evaluators receive {cmd:M} as
the first argument and are expected to pass {cmd:M} to any
{cmd:moptimize}{it:*}{cmd:()} subroutines that they call.  {cmd:M} in fact
contains all the details of the optimization problem.  The second argument,
{cmd:b}, is the entire coefficient vector, which in the {cmd:linregeval()} case
will be all the coefficients of our regression, the constant (intercept), and
the variance of the residual.  Those details are unimportant.  Instead, your
evaluator will pass {it:M} and {it:b} to {cmd:moptimize()} utility programs
that will give you back what you need.

{p 4 4 2}
Using one of those utilities is the first action our {cmd:linregeval()}
evaluator performs:

       	              {cmd:p1 = moptimize_util_xb(M, b, 1)}

{p 4 4 2} 
That returns observation-by-observation values of the first
parameter, namely, {it:X}{cmd:*}{it:b}1{cmd::+}{it:c}1.
{cmd:moptimize_util_xb(x, b, 1)} returns the first parameter because the
last argument specified is 1.  We obtained the second parameter similarly:

       	              {cmd:p2 = moptimize_util_xb(M, b, 2)}

{p 4 4 2}
To evaluate the likelihood function, we also need the dependent variable.
Another {cmd:moptimize}{it:*}{cmd:()} utility returns that to us:

       	              {cmd:y1 = moptimize_util_depvar(M, 1)}

{p 4 4 2}
Having {cmd:p1}, {cmd:p2}, and {cmd:y1}, we are ready to fill in the 
log-likelihood values:

	              {cmd:lnf = ln(normalden(y1:-p1, 0, sqrt(p2)))}

{p 4 4 2}
For a type {cmd:lf} evaluator, you are to return
observation-by-observation values of the log-likelihood function;
{cmd:moptimize()} itself will sum them to obtain the overall log likelihood.
That is exactly what the line
{cmd:lnf = ln(normalden(y1:-p1, 0, sqrt(p2)))}
did.  Note that {cmd:y1} is {it:N} {it:x} 1, {cmd:p1} is {it:N} {it:x} 1, and
{cmd:p2} is {it:N} {it:x} 1, so the {cmd:lnf} result we calculate is also
{it:N} {it:x} 1.  Some of the other evaluator types are expected to return
a scalar equal to the overall value of the function.

{p 4 4 2}
With the evaluator defined, we can estimate a linear regression by typing

	    {cmd}: M = moptimize_init()
	    : moptimize_init_evaluator(M, &linregeval())
	    : moptimize_init_depvar(M, 1, "mpg")
	    : moptimize_init_eq_indepvars(M, 1, "weight foreign")
	    : moptimize_init_eq_indepvars(M, 2, "")
	    : moptimize(M)
	    : moptimize_result_display(M){txt}

{p 4 4 2}
All estimation problems begin with 

	      {cmd:M = moptimize_init()}

{p 4 4 2}
The returned value {cmd:M} is called a problem handle, and from that 
point on, you will pass {cmd:M} to every other {cmd:moptimize()} function 
you call.  {cmd:M} contains the details of your problem.
If you were to list {it:M}, you would see something like 

            : {cmd:M}
	      0x15369a

{p 4 4 2}
0x15369a is in fact  the address where all those details are stored.  Exactly
how {cmd:M} works does not matter, but it is important that you understand
what {cmd:M} is.  {cmd:M} is your problem.  In a more complicated problem, you
might need to perform nested optimizations.  You might have one optimization
problem, and right in the middle of it, even right in the middle of evaluating
its log-likelihood function, you might need to set up and solve another
optimization problem.  You can do that.  The first problem you would set up as
{cmd:M1} {cmd:=} {cmd:moptimize_init()}. 
The second
problem you would set up as {cmd:M2} {cmd:=} {cmd:moptimize_init()}.
{cmd:moptimize()} would not confuse the two problems because it
would know to which problem you were referring by whether you used {cmd:M1} or
{cmd:M2} as the argument of the {cmd:moptimize()} functions.  As
another example, you might have one optimization problem, {cmd:M} {cmd:=}
{cmd:moptimize_init()}, and halfway through it, decide you want to try
something wild.  You could code {cmd:M2} {cmd:=} {cmd:M}, thus making a copy
of the problem, use the {cmd:moptimize}{it:*}{cmd:()} functions with {cmd:M2},
and all the while your original problem would remain undisturbed.

{p 4 4 2}
Having obtained a problem handle, that is, having coded
{cmd:M = moptimize_init()}, you now need to fill in the 
details of your problem.  You do that with the
{cmd:moptimize_init_}{it:*}{cmd:()} functions.  The order in which you do this
does not matter.  We first informed {cmd:moptimize()} of the identity of the
evaluator function:

            : {cmd:moptimize_init_evaluator(M, &linregeval())}

{p 4 4 2}
We must also inform {cmd:moptimize()} as to the type of 
evaluator function {cmd:linregeval()} is, which we could do by coding 

	    :  {cmd:moptimize_init_evaluatortype(M, "lf")}

{p 4 4 2}
We did not bother, however, because type {cmd:lf} is the default.

{p 4 4 2}
After that, we need to inform {cmd:moptimize()} as to the identity of the 
dependent variables:

	    :  {cmd:moptimize_init_depvar(M, 1, "mpg")}

{p 4 4 2}
Dependent variables play no special role in {cmd:moptimize()}; they are 
merely something that are remembered so that they can be passed to the
evaluator function that we write.  One problem might have no dependent
variables and another might have lots of them.
{cmd:moptimize_init_depvar(}{it:M}{cmd:,} {it:i}{cmd:,} {it:y}{cmd:)}'s second
argument specifies which dependent variable is being set.  There is no
requirement that the number of dependent variables match the number of
equations.  In the linear regression case, we have one dependent variable and
two equations.

{p 4 4 2}
Next we set the independent variables, or equivalently, the mapping 
of coefficients, into parameters.  When we code

	    :  {cmd:moptimize_init_eq_indepvars(M, 1, "weight foreign")}

{p 4 4 2}
we are stating that there is a parameter, {bf:p}1 = {bf:X}1*{bf:b}1 {cmd::+}
{it:c}1, and that {bf:X}1 = ({cmd:weight},{cmd:foreign}).  Thus {bf:b}1
contains two coefficients, that is, {bf:p}1 =
({cmd:weight},{cmd:foreign})*({it:b}11,{it:b}12)' {cmd::+} {it:c}1.  Actually,
we have not yet specified whether there is a constant, {it:c}1, on the end, but
if we do not specify otherwise, the constant will be included.  If we want to
suppress the constant, after coding 
{cmd:moptimize_init_eq_indepvars(M, 1, "weight foreign")}, we would code
{cmd:moptimize_init_eq_cons(M, 1, "off")}.
The {cmd:1} says first equation, and 
the {cmd:"off"} says to turn the constant off.

{p 4 4 2}
As an aside, 
we coded {cmd:moptimize_init_eq_indepvars(M, 1, "weight foreign")} and so 
specified that the independent variables were the Stata variables 
{cmd:weight} and {cmd:foreign}, but the independent variables do not have 
to be in Stata.  If we had a 74 {it:x} 2 matrix named {cmd:data} in 
Mata that we wanted to use, we would have coded 
{cmd:moptimize_init_eq_indepvars(M, 1, data)}.

{p 4 4 2}
To define the second parameter, we code

	    :  {cmd:moptimize_init_eq_indepvars(M, 2, "")}

{p 4 4 2}
Thus we are stating that there is a parameter, {bf:p}2 = {bf:X}2*{bf:b}2
{cmd::+} {it:c}2, and that {bf:X}2 does not exist, leaving {bf:p}2 = {it:c}2,
meaning that the second parameter is a constant.

{p 4 4 2}
Our problem defined, we code 

	    :  {cmd:moptimize(M)}

{p 4 4 2}
to obtain the solution, and we code 

	    :  {cmd:moptimize_result_display(M)}

{p 4 4 2}
to see the results.  There are many {cmd:moptimize_result_}{it:*}{cmd:()}
functions for use after the solution is obtained.


{marker rem_dlfgfq}{...}
{title:The type d, lf*, gf, and q evaluators}

{p 4 4 2}
Above we wrote our evaluator function in the style of type {cmd:lf}.
{cmd:moptimize()} provides four other evaluator types -- called types 
{cmd:d}, {cmd:gf}, and {cmd:q} -- and each have their
uses.

{p 4 4 2}
Using type {cmd:lf} above, we were required to calculate the
observation-by-observation log likelihoods and that was all.  Using another
type of evaluator, say, type {cmd:d}, we are required to calculate the overall
log likelihood, and optionally, its first derivatives, and optionally, its
second derivatives.  The corresponding evaluator types are called {cmd:d0},
{cmd:d1}, and {cmd:d2}.  Type {cmd:d} is better than type {cmd:lf} because if
we do calculate the derivatives, then {cmd:moptimize()} can execute more
quickly and it can produce a slightly more accurate result (more accurate
because numerical derivatives are not involved).  These speed and accuracy
gains justify type {cmd:d1} and {cmd:d2}, but what about type {cmd:d0}?  For
many optimization problems, type {cmd:d0} is redundant and amounts to nothing
more than a slight variation on type {cmd:lf}.  In these cases, type {cmd:d0}'s
justification is that if we want to write a type {cmd:d1} or type {cmd:d2}
evaluator, then it is usually easiest to start by writing a type {cmd:d0}
evaluator.  Make that work, and then add to the code to convert our type
{cmd:d0} evaluator into a type {cmd:d1} evaluator; make that work, and then, if
we are going all the way to type {cmd:d2}, add the code to convert our type
{cmd:d1} evaluator into a type {cmd:d2} evaluator.

{p 4 4 2}
For other optimization problems, however, there is a substantive reason for
type {cmd:d0}'s existence.  Type {cmd:lf} requires observation-by-observation
values of the log-likelihood function, and for some likelihood functions,
those simply do not exist.  Think of a panel-data model.  There may be
observations within each of the panels, but there is no corresponding
log-likelihood value for each of them.  The log-likelihood function is defined
only across the entire panel.  Type {cmd:lf} cannot handle problems like that.
Type {cmd:d0} can.

{p 4 4 2}
That makes type {cmd:d0} seem to be a strict improvement on type {cmd:lf}.
Type {cmd:d0} can handle any problem that type {cmd:lf} can handle, and it can
handle other problems to boot.  Where both can handle the problem, the only
extra work to use type {cmd:d0} is that we must sum the individual values we
produce, and that is not difficult.  Type {cmd:lf}, however, has other
advantages.  If you write a type {cmd:lf} evaluator, then without writing
another line of code, you can obtain the robust estimates of variance, adjust
for clustering, account for survey design effects, and more.
{cmd:moptimize()} can do all that because it has the results of an
observation-by-observation calculation.  {cmd:moptimize()} can break into the
assembly of those observation-by-observation results and modify how that is
done.  {cmd:moptimize()} cannot do that for {cmd:d0}.

{p 4 4 2}
So there are advantages both ways.

{p 4 4 2}
Another provided evaluator type is type {cmd:lf*}.  Type {cmd:lf*} is a
variation 
on type {cmd:lf}.  It also comes in the subflavors {cmd:lf0}, {cmd:lf1}, and 
{cmd:lf2}.
Type {cmd:lf*} allows you to make observation-level derivative 
calculations, which means that results can be obtained more quickly and 
more accurately.
Type {cmd:lf*} is designed to always work where 
{cmd:lf} is appropriate, which means panel-data estimators are excluded.
In return, it provides all the ancillary features provided by type 
{cmd:lf}, meaning that robust standard errors, clustering, and survey-data 
adjustments are available.  You write the evaluator function in a 
slightly different style when you use type {cmd:lf*} rather than type {cmd:lf}.

{p 4 4 2}
Type {cmd:gf} is a variation on type {cmd:lf*} that relaxes the requirement 
that the log-likelihood function be summable over the observations.
Thus type {cmd:gf} can work with panel-data models and resurrect the 
features of robust standard errors, clustering, and survey-data adjustments.
Type {cmd:gf} evaluators, however, are more difficult to write than type 
{cmd:lf*} evaluators.

{p 4 4 2}
Type {cmd:q} is for the special case of quadratic optimization.
You either need it, and then only type {cmd:q} will do, or you do not.


{marker rem_d}{...}
{title:Example using type d}

{p 4 4 2}
Let's return to our linear regression maximum-likelihood estimator.
To remind you, this is a two-parameter model, and the log-likelihood function
is

	    {it:f}({bf:p}1, {bf:p}2; {bf:y}) = {...}
Sum {cmd:ln(normalden(}{bf:y}-{bf:p}1{cmd:,} 0{cmd:,} {cmd:sqrt(}{bf:p}2{cmd:))}

{p 4 4 2}
This time, however, we are going to parameterize the variance parameter 
{bf:p}2 as the log of the standard deviation, so we will write 

	    {it:f}({bf:p}1, {bf:p}2; {bf:y}) = {...}
Sum {cmd:ln(normalden(}{bf:y}-{bf:p}1{cmd:,} 0{cmd:,} {cmd:exp(}{bf:p}2{cmd:))}

{p 4 4 2}
It does not make any conceptual difference which parameterization we use, but
the log parameterization converges a little more quickly, and the derivatives
are easier, too.  We are going to implement a type {cmd:d2} evaluator for this
function.  To save you from pulling out pencil and paper, let's tell you the
derivatives:

	           d{it:f}/d{bf:p}1 = {bf:z}:/{bf:s}

	           d{it:f}/d{bf:p}2 = {bf:z}:^2 :- 1


	       d^2{it:f}/d{bf:p}1^2 = -1:/{bf:s}:^2

	       d^2{it:f}/d{bf:p}2^2 = -2*{bf:z}:^2

	       d^2{it:f}/d{bf:p}d{bf:p}2 = -2*{bf:z}:/{bf:s} 

{p 4 4 2}
where
{p_end}
                        {bf:z} = ({bf:y}:-{bf:p}1):/{bf:s}

                        {bf:s} = exp({bf:p}2)

{p 4 4 2}
The {cmd:d2} evaluator function for this problem is

	{cmd}function linregevald2(transmorphic M, real scalar todo, 
			      real rowvector b, fv, g, H)
	{c -(}
		y1  = moptimize_util_depvar(M, 1)
		p1  = moptimize_util_xb(M, b, 1)
		p2  = moptimize_util_xb(M, b, 2)

		s   = exp(p2)
		z   = (y1:-p1):/s

		fv  = moptimize_util_sum(M, ln(normalden(y1:-p1, 0, s)))

		if (todo>=1) {c -(}
			s1  = z:/s          
			s2  = z:^2 :- 1
			g1  = moptimize_util_vecsum(M, 1, s1, fv)
			g2  = moptimize_util_vecsum(M, 2, s2, fv)
			g   = (g1, g2)
			if (todo==2) {c -(}
				h11 = -1:/s:^2
				h22 = -2*z:^2
				h12 = -2*z:/s
				H11 = moptimize_util_matsum(M, 1,1, h11, fv)
				H22 = moptimize_util_matsum(M, 2,2, h22, fv)
				H12 = moptimize_util_matsum(M, 1,2, h12, fv)
				H   = (H11, H12 \ H12', H22)
			{c )-}{txt}
		{c )-}{txt}
	{c )-}{txt}

{p 4 4 2}
The code to fit a model of mpg on weight and foreign reads 

	{cmd}: M = moptimize_init()
	: moptimize_init_evaluator(M, &linregevald2())
	: moptimize_init_evaluatortype(M, "d2")
	: moptimize_init_depvar(M, 1, "mpg")
	: moptimize_init_eq_indepvars(M, 1, "weight foreign")
	: moptimize_init_eq_indepvars(M, 2, "")
	: moptimize(M)
	: moptimize_result_display(M){txt}

{p 4 4 2}
By the way, function {cmd:linregevald2()} will work not only with 
type {cmd:d2}, but also with types {cmd:d1} and {cmd:d0}.
Our function has the code to calculate first and second derivatives, 
but if we use type {cmd:d1}, {cmd:todo} will never be 2 and the 
second derivative part of our code will be ignored.  If we use type 
{cmd:d0}, {cmd:todo} will never be 1 or 2 and so the first and second 
derivative parts of our code will be ignored.  You could delete the 
unnecessary blocks if you wanted.

{p 4 4 2}
It is also worth trying the above code with types {cmd:d1debug} and 
{cmd:d2debug}.  Type {cmd:d1debug} is like {cmd:d1}; the second 
derivative code will not be used.  Also type {cmd:d1debug} 
will almost ignore the first derivative code.  Our program will 
be asked to make the calculation, but {cmd:moptimize()} will not use 
the results except to report a comparison of the derivatives we calculate 
with numerically calculated derivatives.  That way, we can check that our 
program is right.  Once we have done that, we move to type {cmd:d2debug}, 
which will check our second-derivative calculation.


{marker rem_e}{...}
{title:Example using type lf*}

{p 4 4 2}
The {cmd:lf2} evaluator function for the linear-regression problem is 
almost identical to the type {cmd:d2} evaluator.  It differs in that 
rather than return the summed log likelihood, we return the observation-level
log likelihoods.  And rather than return the gradient vector, we return the
equation-level scores that when used with the chain-rule can be summed
to produce the gradient.
The conversion from {cmd:d2} to {cmd:lf2} was possible because of the
observation-by-observation nature of the linear-regression problem; 
if the evaluator was not going to be implemented as {cmd:lf}, it always 
should have been implemented as {cmd:lf1} or {cmd:lf2} instead of {cmd:d1} or
{cmd:d2}.  In the {cmd:d2} 
evaluator above, we went to extra work -- summing the scores -- the result
of which was to eliminate {cmd:moptimize()} features such as being able 
to automatically adjust for clusters and survey data.
In a more appropriate type {cmd:d} problem -- a problem for which 
a type {cmd:lf*} evaluator could not have been implemented -- those scores 
never would have been available in the first place.

{p 4 4 2}
The {cmd:lf2} evaluator is

	{cmd}function linregevallf2(transmorphic M, real scalar todo, 
			      real rowvector b, fv, S, H)
	{c -(}
		y1  = moptimize_util_depvar(M, 1)
		p1  = moptimize_util_xb(M, b, 1)
		p2  = moptimize_util_xb(M, b, 2)

		s   = exp(p2)
		z   = (y1:-p1):/s

		fv  = ln(normalden(y1:-p1, 0, s))

		if (todo>=1) {c -(}
			s1  = z:/s          
			s2  = z:^2 :- 1
			S   = (s1, s2)
			if (todo==2) {c -(}
				h11 = -1:/s:^2
				h22 = -2*z:^2
				h12 = -2*z:/s
				mis = 0
				H11 = moptimize_util_matsum(M, 1,1, h11, mis)
				H22 = moptimize_util_matsum(M, 2,2, h22, mis)
				H12 = moptimize_util_matsum(M, 1,2, h12, mis)
				H   = (H11, H12 \ H12', H22)
			{c )-}{txt}
		{c )-}{txt}
	{c )-}{txt}

{p 4 4 2}
The code to fit a model of {cmd:mpg} on {cmd:weight} and {cmd:foreign} reads
nearly identically to the code we used in the type {cmd:d2} case.  We must
specify the name of our type {cmd:lf2} evaluator and specify that it is type
{cmd:lf2}:

	{cmd}: M = moptimize_init()
	: moptimize_init_evaluator(M, &linregevallf2())
	: moptimize_init_evaluatortype(M, "lf2")
	: moptimize_init_depvar(M, 1, "mpg")
	: moptimize_init_eq_indepvars(M, 1, "weight foreign")
	: moptimize_init_eq_indepvars(M, 2, "")
	: moptimize(M)
	: moptimize_result_display(M){txt}


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
See {it:{help mf_moptimize##syntax:Syntax}} above.


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
All functions abort with error when used incorrectly.

{pstd}
{cmd:moptimize()} aborts with error if it runs into numerical difficulties.
{cmd:_moptimize()} does not; it instead returns a nonzero error code.

{pstd}
The {cmd:moptimize_result}{it:*}{cmd:()} functions abort with error if they run
into numerical difficulties when called after {cmd:moptimize()} or
{cmd:moptimize_evaluate()}.  They do not abort when run after 
{cmd:_moptimize()} or {cmd:_moptimize_evaluate()}.  They instead return a
properly dimensioned missing result and set {cmd:moptimize_result_errorcode()}
and {cmd:moptimize_result_errortext()}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view moptimize_include.mata, adopath asis:moptimize_include.mata},
{view moptimize_init.mata, adopath asis:moptimize_init.mata}, 
{view moptimize_query.mata, adopath asis:moptimize_query.mata}, 
{view moptimize_check.mata, adopath asis:moptimize_check.mata}, 
{view moptimize.mata, adopath asis:moptimize.mata}, 
{view moptimize_result.mata, adopath asis:moptimize_result.mata}, 
{view moptimize_calluser.mata, adopath asis:moptimize_calluser.mata},
{view moptimize_evaltools.mata, adopath asis:moptimize_evaltools.mata},
{view moptimize_name.mata, adopath asis:moptimize_name.mata},
{view moptimize_stata.mata, adopath asis:moptimize_stata.mata},
{view moptimize_utilities.mata, adopath asis:moptimize_utilities.mata}
{p_end}


{marker reference}{...}
{title:Reference}

{marker GPP2010}{...}
{p 4 8 2}
Gould, W. W., J. Pitblado, and B. P. Poi. 2010. 
{browse "http://www.stata-press.com/books/ml4.html":{it:Maximum Likelihood Estimation with Stata}. 4th ed.}
College Station, TX: Stata Press.
{p_end}
