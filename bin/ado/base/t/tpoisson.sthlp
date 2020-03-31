{smcl}
{* *! version 1.2.9  12dec2018}{...}
{viewerdialog tpoisson "dialog tpoisson"}{...}
{viewerdialog "svy: tpoisson" "dialog tpoisson, message(-svy-) name(svy_tpoisson)"}{...}
{vieweralsosee "[R] tpoisson" "mansection R tpoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] tpoisson postestimation" "help tpoisson postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: tpoisson" "help bayes tpoisson"}{...}
{vieweralsosee "[FMM] fmm: tpoisson" "help fmm tpoisson"}{...}
{vieweralsosee "[R] nbreg" "help nbreg"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] tnbreg" "help tnbreg"}{...}
{vieweralsosee "[XT] xtpoisson" "help xtpoisson"}{...}
{vieweralsosee "[R] zinb" "help zinb"}{...}
{vieweralsosee "[R] zip" "help zip"}{...}
{viewerjumpto "Syntax" "tpoisson##syntax"}{...}
{viewerjumpto "Menu" "tpoisson##menu"}{...}
{viewerjumpto "Description" "tpoisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "tpoisson##linkspdf"}{...}
{viewerjumpto "Options" "tpoisson##options"}{...}
{viewerjumpto "Examples" "tpoisson##examples"}{...}
{viewerjumpto "Stored results" "tpoisson##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] tpoisson} {hline 2}}Truncated Poisson regression{p_end}
{p2col:}({mansection R tpoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:tpoisson} {depvar} [{indepvars}] {ifin} 
[{it:{help tpoisson##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 26 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt:{cmd:ll(}{it:#}|{varname}{cmd:)}}lower limit for truncation;
default is {cmd:ll(0)} when neither {cmd:ll()} nor {cmd:ul()} is specified{p_end}
{synopt:{cmd:ul(}{it:#}|{varname}{cmd:)}}upper limit for truncation{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e})
in model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with coefficient
constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
  or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}
{p_end}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help tpoisson##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help tpoisson##maximize_options:maximize_options}}}control the
maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvar} and {it:indepvars} may contain time-series operators;
see {help tsvarlist}.{p_end}
{p 4 6 2}{opt bayes}, {opt bootstrap}, {opt by}, {opt fmm}, {opt fp},
{opt jackknife}, {opt rolling}, {opt statsby}, and {opt svy} are allowed; see
{help prefix}.
For more details, see {manhelp bayes_tpoisson BAYES:bayes: tpoisson} and
{manhelp fmm_tpoisson FMM:fmm: tpoisson}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp tpoisson_postestimation R:tpoisson postestimation} for
features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Count outcomes > Truncated Poisson regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:tpoisson} fits a truncated Poisson regression model
when the number of occurrences of an event is restricted to be above a
truncation point, below a truncation point, or between two truncation points.
Truncated Poisson models are appropriate when neither the dependent variable
nor the covariates are observed in the truncated part of the distribution.  By
default, {cmd:tpoisson} assumes left-truncation occurs at zero, but truncation
may be specified at other fixed points or at values that vary across
observations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R tpoissonQuickstart:Quick start}

        {mansection R tpoissonRemarksandexamples:Remarks and examples}

        {mansection R tpoissonMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{cmd:ll(}{it:#}|{varname}{cmd:)} and
{cmd:ul(}{it:#}|{varname}{cmd:)}
specifies the lower and upper limits for truncation, respectively.
You may specify nonnegative integer values for one or both.

{pmore}
When neither {cmd:ll()} nor {cmd:ul()} is specified, the default is zero
truncation, {cmd:ll(0)}, equivalent to left-truncation at zero.

{phang}
{opth exposure:(varname:varname_e)}, {opt offset(varname_o)},
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{opt irr} reports estimated coefficients transformed to incidence-rate
ratios, that is, exp(b) rather than b.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results are
displayed, not how they are estimated.  {opt irr} may be specified at
estimation or when replaying previously estimated results.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

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
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt tpoisson} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse runshoes}{p_end}

{pstd}Truncated Poisson regression with default truncation point of 0{p_end}
{phang2}{cmd:. tpoisson shoes distance i.male age}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. replace shoes = . if shoes < 4}{p_end}

{pstd}Truncated Poisson regression with truncation point of 3 and exposure
variable {cmd:age}{p_end}
{phang2}{cmd:. tpoisson shoes distance male, exposure(age) ll(3)}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:tpoisson} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:tpoisson}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(llopt)}}contents of {cmd:ll()}, or {cmd:0} if neither
{cmd:ll()} nor {cmd:ul()} is specified{p_end}
{synopt:{cmd:e(ulopt)}}contents of {cmd:ul()}, if specified{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as
{cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as
{cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
