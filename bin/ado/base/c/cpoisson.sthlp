{smcl}
{* *! version 1.0.8  12dec2018}{...}
{viewerdialog cpoisson "dialog cpoisson"}{...}
{viewerdialog "svy: cpoisson" "dialog cpoisson, message(-svy-) name(svy_cpoisson)"}{...}
{vieweralsosee "[R] cpoisson" "mansection R cpoisson"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] cpoisson postestimation" "help cpoisson postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nbreg" "help nbreg"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[R] tnbreg" "help tnbreg"}{...}
{vieweralsosee "[R] tpoisson" "help tpoisson"}{...}
{vieweralsosee "[XT] xtpoisson" "help xtpoisson"}{...}
{vieweralsosee "[R] zinb" "help zinb"}{...}
{vieweralsosee "[R] zip" "help zip"}{...}
{viewerjumpto "Syntax" "cpoisson##syntax"}{...}
{viewerjumpto "Menu" "cpoisson##menu"}{...}
{viewerjumpto "Description" "cpoisson##description"}{...}
{viewerjumpto "Links to PDF documentation" "cpoisson##linkspdf"}{...}
{viewerjumpto "Options" "cpoisson##options"}{...}
{viewerjumpto "Example" "cpoisson##example"}{...}
{viewerjumpto "Stored results" "cpoisson##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] cpoisson} {hline 2}}Censored Poisson regression{p_end}
{p2col:}({mansection R cpoisson:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:cpoisson} {depvar} [{indepvars}] {ifin}
[{it:{help cpoisson##weight:weight}}]
[{cmd:,}
{it:options}] 

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt ll}[{cmd:(}{varname}|{it:#}{cmd:)}]}left-censoring variable or limit{p_end}
{synopt :{opt ul}[{cmd:(}{varname}|{it:#}{cmd:)}]}right-censoring variable or limit{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include ln({it:varname_e}) in
model with coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar},
{opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt ir:r}}report incidence-rate ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help cpoisson##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help cpoisson##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
INCLUDE help fvvarlist
{p 4 6 2}{it:depvar} and {it:indepvars} may
contain time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{opt bootstrap}, {opt by}, {opt fp}, {opt jackknife},
{opt rolling}, {opt statsby}, and {opt svy} are allowed; see {help prefix}.
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp cpoisson_postestimation R:cpoisson postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Count outcomes > Censored Poisson regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:cpoisson} fits a Poisson model of a count dependent variable with some
censored values.  The command can be used when the dependent variable is
left-censored (has a lower limit), is right-censored (has an upper limit), or 
is interval-censored (has a lower and an upper limit).


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R cpoissonQuickstart:Quick start}

        {mansection R cpoissonRemarksandexamples:Remarks and examples}

        {mansection R cpoissonMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see {helpb estimation options:[R] Estimation options}.

{phang}
{opt ll}[{cmd:(}{varname}|{it:#}{cmd:)}] and
{opt ul}[{cmd:(}{varname}|{it:#}{cmd:)}]
   indicate the lower and upper limits for censoring, respectively.
   Observations with {depvar} {ul:<} {opt ll()} are left-censored; observations
   with {it:depvar} {ul:>} {opt ul()} are right-censored; and remaining
   observations are not censored.  You do not have to specify the censoring
   value.  If you specify {opt ll}, the lower limit is the minimum of
   {it:depvar}.  If you specify {opt ul}, the upper limit is the maximum of
   {it:depvar}.

{phang}
{opth "exposure(varname:varname_e)"},
{opt offset(varname_o)}, 
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

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

{pstd}
The following options are available with {opt cpoisson} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse trips}{p_end}

{pstd}Fit a censored Poisson regression{p_end}
{phang2}{cmd:. cpoisson trips income children, ul(3)}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:cpoisson} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_unc)}}number of uncensored observations{p_end}
{synopt:{cmd:e(N_lc)}}number of left-censored observations{p_end}
{synopt:{cmd:e(N_rc)}}number of right-censored observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
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
{synopt:{cmd:e(cmd)}}{cmd:cpoisson}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(llopt)}}contents of {cmd:ll()}, if specified{p_end}
{synopt:{cmd:e(ulopt)}}contents of {cmd:ul()}, if specified{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}linear offset variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared test{p_end}
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
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

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
