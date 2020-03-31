{smcl}
{* *! version 1.1.9  17feb2020}{...}
{viewerdialog mestreg "dialog mestreg"}{...}
{viewerdialog "svy: mestreg" "dialog mestreg, message(-svy-) name(svy_mestreg)"}{...}
{vieweralsosee "[ME] mestreg" "mansection ME mestreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mestreg postestimation" "help mestreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: mestreg" "help bayes mestreg"}{...}
{vieweralsosee "[ME] me" "help me"}{...}
{vieweralsosee "[ST] Glossary" "help st glossary"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[XT] xtstreg" "help xtstreg"}{...}
{viewerjumpto "Syntax" "mestreg##syntax"}{...}
{viewerjumpto "Menu" "mestreg##menu"}{...}
{viewerjumpto "Description" "mestreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "mestreg##linkspdf"}{...}
{viewerjumpto "Options" "mestreg##options"}{...}
{viewerjumpto "Examples" "mestreg##examples"}{...}
{viewerjumpto "Stored results" "mestreg##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[ME] mestreg} {hline 2}}Multilevel mixed-effects parametric survival models{p_end}
{p2col:}({mansection ME mestreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:mestreg} {it:fe_equation} [{cmd:||} {it:re_equation}]
	[{cmd:||} {it:re_equation} ...]{cmd:,}
	{opth dist:ribution(mestreg##distname:distname)}
	[{it:{help mestreg##options_table:options}}]

{p 4 4 2}
    where the syntax of {it:fe_equation} is

{p 12 24 2}
	[{indepvars}] {ifin} [{it:{help mestreg##weight:weight}}]
	[{cmd:,} {it:{help mestreg##fe_options:fe_options}}]

{p 4 4 2}
    and the syntax of {it:re_equation} is one of the following:

{p 8 18 2}
	for random coefficients and intercepts

{p 12 24 2}
	{it:levelvar}{cmd::} [{varlist}]
		[{cmd:,} {it:{help melogit##re_options:re_options}}]

{p 8 18 2}
	for random effects among the values of a factor variable in a
	crossed-effects model

{p 12 24 2}
	{it:levelvar}{cmd::} {cmd:R.}{varname}

{p 4 4 2}
    {it:levelvar} is a variable identifying the group structure for the random
    effects at that level or is {cmd:_all} representing one group comprising all
    observations.{p_end}

{synoptset 25 tabbed}{...}
{marker fe_options}{...}
{synopthdr :fe_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term from the fixed-effects
equation{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient
constrained to 1{p_end}
{synoptline}

{marker re_options}{...}
{synopthdr :re_options}
{synoptline}
{syntab:Model}
{synopt :{opth cov:ariance(melogit##vartype:vartype)}}variance-covariance structure of the random effects{p_end}
{synopt :{opt nocons:tant}}suppress constant term from the random-effects equation{p_end}
{synopt :{opth fw:eight(varname)}}frequency weights at higher levels{p_end}
{synopt :{opth iw:eight(varname)}}importance weights at higher levels{p_end}
{synopt :{opth pw:eight(varname)}}sampling weights at higher levels{p_end}
{synoptline}

{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent :* {cmdab:dist:ribution(}{it:{help mestreg##distname:distname}}{cmd:)}}specify survival distribution{p_end}
{synopt :{opt time}}use accelerated failure-time metric{p_end}
{synopt :{cmdab:const:raints:(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, or {opt cl:uster} {it:clustvar}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nohr}}do not report hazard ratios{p_end}
{synopt :{opt tr:atio}}report time ratios{p_end}
{synopt :{opt nos:how}}do not show st setting information{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{opt notab:le}}suppress coefficient table{p_end}
{synopt :{opt nohead:er}}suppress output header{p_end}
{synopt :{opt nogr:oup}}suppress table summarizing groups{p_end}
{synopt :{it:{help mestreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Integration}
{synopt :{opth intm:ethod(mestreg##intmethod:intmethod)}}integration method{p_end}
{synopt :{opt intp:oints(#)}}set the number of integration
(quadrature) points for all levels; default is {cmd:intpoints(7)}{p_end}

{syntab :Maximization}
{synopt :{it:{help mestreg##maximize_options:maximize_options}}}control
the maximization process; seldom used{p_end}

INCLUDE help startval_table
{synopt :{opt dnumerical}}use numerical derivative techniques{p_end}
{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}
* {opt distribution(distname)} is required.{p_end}

INCLUDE help me_vartype_table

{marker distname}{...}
{synoptset 25}{...}
{synopthdr:distname}
{synoptline}
{synopt:{cmdab:e:xponential}}exponential survival distribution{p_end}
{synopt:{cmdab:logl:ogistic}}loglogistic survival distribution{p_end}
{synopt:{cmdab:ll:ogistic}}synonym for {cmd:loglogistic}{p_end}
{synopt:{cmdab:w:eibull}}Weibull survival distribution{p_end}
{synopt:{cmdab:logn:ormal}}lognormal survival distribution{p_end}
{synopt:{cmdab:ln:ormal}}synonym for {cmd:lognormal}{p_end}
{synopt:{cmdab:gam:ma}}gamma survival distribution{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help me_intmethod_table

{p 4 6 2}
You must {cmd:stset} your data before using {cmd:mestreg}; see
{manhelp stset ST}.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{cmd:bayes}, {cmd:by}, and {cmd:svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_mestreg BAYES:bayes: mestreg}.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed;
see {help weight}.  Only one type of weight may be specified.
Weights are not supported under the Laplacian
approximation or for crossed models.{p_end}
{p 4 6 2}
{opt startvalues()}, {opt startgrid}, {opt noestimate}, {opt dnumerical},
{opt collinear}, and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp mestreg_postestimation ME:mestreg postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multilevel mixed-effects models >}
    {bf:Parametric survival regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mestreg} fits a mixed-effects parametric survival-time model.  The
conditional distribution of the response given the random effects is assumed
to be an exponential, Weibull, lognormal, loglogistic, or gamma distribution.
{cmd:mestreg} can be used with single- or multiple-record st data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME mestregQuickstart:Quick start}

        {mansection ME mestregRemarksandexamples:Remarks and examples}

        {mansection ME mestregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant} suppresses the constant (intercept) term and may
be specified for the fixed-effects equation and for any of or all the
random-effects equations.

{phang}
{opth offset(varname)} specifies that {it:varname} be included
in the fixed-effects portion of the model with the coefficient
constrained to be 1.

INCLUDE help me_vartype_opt

INCLUDE help me_weight_opt

{phang}
{opt distribution(distname)} specifies the survival model to be fit.
{it:distname} is one of the following: {opt exponential}, {opt loglogistic},
{opt llogistic}, {opt weibull}, {opt lognormal}, {opt lnormal}, or {opt gamma}.
This option is required.

{phang}
{cmd:time} specifies that the model be fit in the accelerated failure-time
metric rather than in the log relative-hazard metric.  This option is
valid only for the exponential and Weibull models because these are
the only models that have both a proportional-hazards and an
accelerated failure-time parameterization.  Regardless of metric, the
likelihood function is the same, and models are equally appropriate
in either metric; it is just a matter of changing interpretation.

{pmore}
{cmd:time} must be specified at estimation.

{phang}
{opt constraints(constraints)};
see {helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), and
that allow for intragroup correlation ({cmd:cluster} {it:clustvar}); see
{helpb vce_option:[R] {it:vce_option}}.  If {cmd:vce(robust)} is specified,
robust variances are clustered at the highest level in the multilevel model.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options:[R] Estimation options}.

{phang}
{opt nohr},
which may be specified at estimation or upon redisplaying results,
specifies that coefficients rather than exponentiated coefficients be
displayed, that is, that coefficients rather than hazard ratios be
displayed.  This option affects only how coefficients are displayed,
not how they are estimated.

{pmore}
This option is valid only for the exponential and Weibull models because they
have a natural proportional-hazards parameterization.
These two models, by default, report hazards ratios
(exponentiated coefficients).

{phang}
{opt tratio}
specifies that exponentiated coefficients, which are interpreted
as time ratios, be displayed.  {opt tratio} is appropriate only for the
loglogistic, lognormal, and gamma models or for the exponential and
Weibull models when fit in the accelerated failure-time metric.

{pmore}
{cmd:tratio} may be specified at estimation or upon replay.

{phang}
{opt noshow}
prevents {opt mestreg} from showing the key st variables.  This option
is rarely used because most users type {opt stset}, {opt show}
or {opt stset, noshow} to set once and for all whether they want to see
these variables mentioned at the top of the output of every st command;
see {manhelp stset ST}.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{phang}
{opt notable} suppresses the estimation table, either at estimation or
upon replay.

{phang}
{opt noheader} suppresses the output header, either at estimation or 
upon replay.

{phang}
{opt nogroup} suppresses the display of group summary information (number of 
groups, average group size, minimum, and maximum) from the output header.

INCLUDE help displayopts_list

{dlgtab:Integration}

INCLUDE help me_integration_opt

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}:
{opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{opt log},
{opt tr:ace},
{opt grad:ient},
{opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.
Those that require special mention for {cmd:mestreg} are listed below.

{pmore}
{opt from()} accepts a properly labeled vector of initial values or a list of
coefficient names with values.  A list of values is not allowed.

{pstd}
The following options are available with {opt mestreg} but are not shown in
the dialog box:

{phang}
{opt startvalues(svmethod)}, {cmd:startgrid}[{cmd:(}{it:gridspec}{cmd:)}],
{opt noestimate}, and {opt dnumerical}; see {helpb meglm##startval:[ME] meglm}.

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse catheter}

{pstd}Two-level random-intercept Weibull survival model, analogous to {cmd:xtstreg}{p_end}
{phang2}{cmd:. mestreg age female || patient:, distribution(weibull)}

{pstd}Two-level random-intercept Weibull survival model in the accelerated failure-time metric{p_end}
{phang2}{cmd:. mestreg age female || patient:, distribution(weibull) time}

{pstd}Two-level random-intercept gamma survival model{p_end}
{phang2}{cmd:. mestreg age female || patient:, distribution(gamma)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse jobhistory}{p_end}
{phang2}{cmd:. stset tend, origin(tstart) fail(failure)}

{pstd}Three-level random-intercept lognormal survival model{p_end}
{phang2}{cmd:. mestreg education njobs prestige i.female || birthyear: || id:, distribution(lognormal)}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:mestreg} stores the following in {cmd:e()}:

{synoptset 24 tabbed}{...}
{p2col 5 24 26 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k_f)}}number of fixed-effects parameters{p_end}
{synopt:{cmd:e(k_r)}}number of random-effects parameters{p_end}
{synopt:{cmd:e(k_rs)}}number of variances{p_end}
{synopt:{cmd:e(k_rc)}}number of covariances{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared, comparison test{p_end}
{synopt:{cmd:e(df_c)}}degrees of freedom, comparison test{p_end}
{synopt:{cmd:e(p_c)}}p-value for comparison test{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 24 26 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:gsem}{p_end}
{synopt:{cmd:e(cmd2)}}{cmd:mestreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression (first-level weights){p_end}
{synopt:{cmd:e(fweight}{it:k}{cmd:)}}{cmd:fweight} variable for {it:k}th highest
level, if specified{p_end}
{synopt:{cmd:e(iweight}{it:k}{cmd:)}}{cmd:iweight} variable for {it:k}th highest
level, if specified{p_end}
{synopt:{cmd:e(pweight}{it:k}{cmd:)}}{cmd:pweight} variable for {it:k}th highest
level, if specified{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(ivars)}}grouping variables{p_end}
{synopt:{cmd:e(model)}}model name{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(distribution)}}distribution{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}offset{p_end}
{synopt:{cmd:e(intmethod)}}integration method{p_end}
{synopt:{cmd:e(n_quad)}}number of integration points{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(frm2)}}{cmd:hazard} or {cmd:time}{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(datasignature)}}the checksum{p_end}
{synopt:{cmd:e(datasignaturevars)}}variables used in calculation of
checksum{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginswtype)}}weight type for {cmd:margins}{p_end}
{synopt:{cmd:e(marginswexp)}}weight expression for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 24 26 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(N_g)}}group counts{p_end}
{synopt:{cmd:e(g_min)}}group-size minimums{p_end}
{synopt:{cmd:e(g_avg)}}group-size averages{p_end}
{synopt:{cmd:e(g_max)}}group-size maximums{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 24 tabbed}{...}
{p2col 5 24 26 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
