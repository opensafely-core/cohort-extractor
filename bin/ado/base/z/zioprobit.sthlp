{smcl}
{* *! version 1.0.11  12dec2018}{...}
{viewerdialog zioprobit "dialog zioprobit"}{...}
{viewerdialog "svy: zioprobit" "dialog zioprobit, message(-svy-) name(svy_zioprobit)"}{...}
{vieweralsosee "[R] zioprobit" "mansection R zioprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] zioprobit postestimation" "help zioprobit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: zioprobit" "help bayes zioprobit"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "zioprobit##syntax"}{...}
{viewerjumpto "Menu" "zioprobit##menu"}{...}
{viewerjumpto "Description" "zioprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "zioprobit##linkspdf"}{...}
{viewerjumpto "Options" "zioprobit##options"}{...}
{viewerjumpto "Example" "zioprobit##example"}{...}
{viewerjumpto "Stored results" "zioprobit##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] zioprobit} {hline 2}}Zero-inflated ordered probit regression{p_end}
{p2col:}({mansection R zioprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:zioprobit}
{depvar}
[{indepvars}]
{ifin}
[{it:{help zioprobit##weight:weight}}]{cmd:,}{break}
{opt inf:late}{cmd:(}{varlist}[{cmd:,} {opt nocons:tant} {opth off:set(varname)}]|{cmd:_cons)}
 [{it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{p2coldent :* {opt inf:late()}}equation that determines excess zero values{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
   {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap}, or
   {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help zioprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help zioprobit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt inf:late}{cmd:(}{it:varlist}[{cmd:,} {opt nocons:tant} {opt off:set(varname)}]|{cmd:_cons)}
is required.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{opt bayes}, {opt bootstrap}, {opt by}, {opt fp}, {opt jackknife},
{opt rolling}, {opt statsby}, and {opt svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_zioprobit BAYES:bayes: zioprobit}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy}
prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed;
see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp zioprobit_postestimation R:zioprobit postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Ordinal outcomes > Zero-inflated ordered probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd: zioprobit} fits a model for a discrete ordered outcome with a high
fraction of zeros, called zero inflation. This model is known as a
zero-inflated ordered probit (ZIOP) model.  In the context of ZIOP models,
zero is an actual 0 value or the lowest outcome category. The ZIOP model
accounts for the zero inflation by assuming that the zero-valued outcomes come
from both a probit model and an ordered probit model, allowing potentially
different sets of covariates for each model.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R zioprobitQuickstart:Quick start}

        {mansection R zioprobitRemarksandexamples:Remarks and examples}

        {mansection R zioprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt inflate}{cmd:(}{varlist}[{cmd:,} {opt noconstant} {opth offset(varname)}]|{cmd:_cons)}
specifies the equation that determines the excess zero values; this option is
required.  Conceptually, omitting {opt inflate()} would be equivalent to
fitting the model with {opt oprobit}; see {manhelp oprobit R}.

{pmore}
{opt inflate}{cmd:(}{it:varlist}[{cmd:,} {opt noconstant} {opt offset(varname)}]{cmd:)}
specifies the variables in the equation that determines the excess zeros.  To
suppress the constant in this equation, specify the {opt noconstant}
suboption.  You may optionally include an offset for this {it:varlist}.

{pmore}
{cmd:inflate(_cons)} specifies that the equation determining the
excess zero values contains only an intercept.  To run a zero-inflated model of
{depvar} with only an intercept in both equations, type {opt zioprobit}
{it:depvar}{cmd:,} {cmd:inflate(_cons)}.

{phang}
{opth offset(varname)},
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{helpb estimation options##level():[R] Estimation options}.

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
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep},
{opt hess:ian},
{opt showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)}, 
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt zioprobit} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse tobacco}{p_end}

{pstd}Zero-inflated ordered probit regression{p_end}
{phang2}{cmd:. zioprobit tobacco education income i.female age, inflate(education income i.parent age i.female i.religion)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:zioprobit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_zero)}}number of zeros or lowest-category observations{p_end}
{synopt:{cmd:e(k_cat)}}number of categories{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_aux)}}number of auxiliary parameters{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:zioprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset{p_end}
{synopt:{cmd:e(offset2)}}offset for {cmd:inflate()}{p_end}
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
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(cat)}}category values{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
