{smcl}
{* *! version 1.3.7  12dec2018}{...}
{viewerdialog xtfrontier "dialog xtfrontier"}{...}
{vieweralsosee "[XT] xtfrontier" "mansection XT xtfrontier"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtfrontier postestimation" "help xtfrontier postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] frontier" "help frontier"}{...}
{vieweralsosee "[XT] xtset" "help xtset"}{...}
{viewerjumpto "Syntax" "xtfrontier##syntax"}{...}
{viewerjumpto "Menu" "xtfrontier##menu"}{...}
{viewerjumpto "Description" "xtfrontier##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtfrontier##linkspdf"}{...}
{viewerjumpto "Options for time-invariant model" "xtfrontier##options_ti"}{...}
{viewerjumpto "Options for time-varying decay model" "xtfrontier##options_tv"}{...}
{viewerjumpto "Examples" "xtfrontier##examples"}{...}
{viewerjumpto "Stored results" "xtfrontier##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[XT] xtfrontier} {hline 2}}Stochastic frontier models for panel data{p_end}
{p2col:}({mansection XT xtfrontier:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Time-invariant model

{p 8 19 2}{cmd:xtfrontier}
{depvar}
[{indepvars}] {ifin}
[{it:{help xtfrontier##weight:weight}}]
{cmd:,} {cmd:ti}
[{it:{help xtfrontier##tioptions:ti_options}}]


{phang}
Time-varying decay model

{p 8 19 2}{cmd:xtfrontier}
{depvar}
[{indepvars}] {ifin}
[{it:{help xtfrontier##weight:weight}}]
{cmd:,} {cmd:tvd}
[{it:{help xtfrontier##tvdoptions:tvd_options}}]


{marker tioptions}{...}
{synoptset 28 tabbed}{...}
{synopthdr :ti_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt ti}}use time-invariant model{p_end}
{synopt :{opt cost}}fit cost frontier model{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim}, {opt boot:strap},
    or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help xtfrontier##ti_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help xtfrontier##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker tvdoptions}{...}
{synoptset 28 tabbed}{...}
{synopthdr :tvd_options}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt tvd}}use time-varying decay model{p_end}
{synopt :{opt cost}}fit cost frontier model{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
       {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help xtfrontier##tvd_display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help xtfrontier##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{p 4 6 2}
A panel variable must be specified. For {cmd:xtfrontier, tvd}, a time variable
must also be specified. Use {helpb xtset}.{p_end}
INCLUDE help fvvarlist
{p 4 6 2}
{it:depvars} and {it:indepvars} may contain time-series operators; see
{help tsvarlist}.{p_end}
{p 4 6 2}
{opt by}, {opt fp}, and {opt statsby} are allowed; see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s and {opt iweight}s are allowed; see {help weight}.
Weights must be constant within panel.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp xtfrontier_postestimation XT:xtfrontier postestimation} for
features available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Frontier models}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtfrontier} fits stochastic production or cost frontier models for panel
data where the disturbance term is a mixture of an inefficiency term and the
idiosyncratic error.  {cmd:xtfrontier} can fit a time-invariant model, in
which the inefficiency term is assumed to have a truncated-normal
distribution, or a time-varying decay model, in which the inefficiency term is
modeled as a truncated-normal random variable multiplied by a function of
time. 

{pstd}
{cmd:xtfrontier} expects that the dependent variable and independent
variables are on the natural logarithm scale; this transformation must be
performed before estimation takes place.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtfrontierQuickstart:Quick start}

        {mansection XT xtfrontierRemarksandexamples:Remarks and examples}

        {mansection XT xtfrontierMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options_ti}{...}
{title:Options for time-invariant model}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt ti} specifies that the parameters of the time-invariant technical
inefficiency model be estimated.

{phang}
{opt cost} specifies the frontier model be fit in terms of a cost function
instead of a production function.  By default, {cmd:xtfrontier} fits a
production frontier model.

{phang}
{opt constraints(constraints)};
see {helpb estimation options##constraints():[R] Estimation options}.

{dlgtab:SE}

INCLUDE help xt_vce_asymptbj

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker ti_display_options}{...}
INCLUDE help displayopts_list

{dlgtab:Maximization}

{phang}
{marker maximize_options}
{it:maximize_options}: {opt dif:ficult},
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
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pstd}
The following options are available with {opt xtfrontier} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker options_tv}{...}
{title:Options for time-varying decay model}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt tvd} specifies that the parameters of the time-varying decay model be
estimated.

{phang}
{opt cost} specifies the frontier model be fit in terms of a cost function
instead of a production function.  By default, {cmd:xtfrontier} fits a
production frontier model.

{phang}
{opt constraints(constraints)};
see {helpb estimation options##constraints():[R] Estimation options}.

{dlgtab:SE}

INCLUDE help xt_vce_asymptbj

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker tvd_display_options}{...}
INCLUDE help displayopts_list

{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
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
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pstd}
The following options are available with {opt xtfrontier} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse xtfrontier1}{p_end}

{pstd}Time-invariant model{p_end}
{phang2}{cmd:. xtfrontier lnwidgets lnmachines lnworkers, ti}

{pstd}Time-varying decay model{p_end}
{phang2}{cmd:. xtfrontier lnwidgets lnmachines lnworkers, tvd}

{pstd}Time-varying decay model with a constraint{p_end}
{phang2}{cmd:. constraint 1 [eta]_cons = 0}{p_end}
{phang2}{cmd:. xtfrontier lnwidgets lnmachines lnworkers, tvd constraints(1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtfrontier} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_g)}}number of groups{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(g_min)}}minimum number of observations per group{p_end}
{synopt:{cmd:e(g_avg)}}average number of observations per group{p_end}
{synopt:{cmd:e(g_max)}}maximum number of observations per group{p_end}
{synopt:{cmd:e(sigma2)}}sigma2{p_end}
{synopt:{cmd:e(gamma)}}gamma{p_end}
{synopt:{cmd:e(Tcon)}}{cmd:1} if panels balanced, {cmd:0} otherwise{p_end}
{synopt:{cmd:e(sigma_u)}}standard deviation of technical inefficiency{p_end}
{synopt:{cmd:e(sigma_v)}}standard deviation of random error{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:xtfrontier}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(ivar)}}variable denoting groups{p_end}
{synopt:{cmd:e(tvar)}}variable denoting time within groups{p_end}
{synopt:{cmd:e(function)}}{cmd:production} or {cmd:cost}{p_end}
{synopt:{cmd:e(model)}}{cmd:ti}, after time-invariant model; {cmd:tvd}, after
	time-varying decay model{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
