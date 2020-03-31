{smcl}
{* *! version 1.2.1  12dec2018}{...}
{viewerdialog zip "dialog zip"}{...}
{viewerdialog "svy: zip" "dialog zip, message(-svy-) name(svy_zip)"}{...}
{vieweralsosee "[R] zip" "mansection R zip"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] zip postestimation" "help zip postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: zip" "help bayes zip"}{...}
{vieweralsosee "[R] nbreg" "help nbreg"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[R] tnbreg" "help tnbreg"}{...}
{vieweralsosee "[R] tpoisson" "help tpoisson"}{...}
{vieweralsosee "[XT] xtpoisson" "help xtpoisson"}{...}
{vieweralsosee "[R] zinb" "help zinb"}{...}
{viewerjumpto "Syntax" "zip##syntax"}{...}
{viewerjumpto "Menu" "zip##menu"}{...}
{viewerjumpto "Description" "zip##description"}{...}
{viewerjumpto "Links to PDF documentation" "zip##linkspdf"}{...}
{viewerjumpto "Options" "zip##options"}{...}
{viewerjumpto "Examples" "zip##examples"}{...}
{viewerjumpto "Stored results" "zip##results"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[R] zip} {hline 2}}Zero-inflated Poisson regression{p_end}
{p2col:}({mansection R zip:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:zip} {depvar} [{indepvars}] {ifin}
[{it:{help zip##weight:weight}}]{cmd:,}{break} 
   {opt inf:late}{cmd:(}{varlist}[{cmd:,} {opth off:set(varname)}]|{cmd:_cons)}
   [{it:options}]

{synoptset 28 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Model}
{p2coldent :* {opt inf:late()}}equation that determines whether the count is
zero{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth exp:osure(varname:varname_e)}}include {opt ln(varname_e)} in model with
coefficient constrained to 1{p_end}
{synopt :{opth off:set(varname:varname_o)}}include {it:varname_o} in model with
coefficient constrained to 1{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{opt probit}}use probit model to characterize excess zeros;
default is logit{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar}, {opt opg}, {opt boot:strap},
  or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt irr}}report incidence-rate ratios{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help zip##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help zip##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt inf:late}{cmd:(}{it:varlist}[{cmd:,} {opt off:set(varname)}]|{cmd:_cons)}
is required.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}{cmd:bayes}, {cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife},
{cmd:rolling}, {cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_zip BAYES:bayes: zip}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy}
prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp zip_postestimation R:zip postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Count outcomes > Zero-inflated Poisson regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:zip} fits a zero-inflated Poisson (ZIP) model to count data with excess
zero counts. The ZIP model assumes that the excess zero counts come from a
logit or probit model and the remaining counts come from a Poisson model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R zipQuickstart:Quick start}

        {mansection R zipRemarksandexamples:Remarks and examples}

        {mansection R zipMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:inflate(}{varlist}[{cmd:,} {cmd:offset(}{varname}{cmd:)}]|{cmd:_cons)}
specifies the equation that determines whether the observed count is zero.
Conceptually, omitting {opt inflate()} would be equivalent to fitting the
model with {helpb poisson}.

{pmore}
{cmd:inflate(}{it:varlist}[{cmd:, offset(}{it:varname}{cmd:)}]{cmd:)}
specifies the variables in the equation.  You may optionally include an offset
for this {it:varlist}.

{pmore}
{cmd:inflate(_cons)} specifies that the equation determining whether
the count is zero contains only an intercept.  To run a zero-inflated model of
{depvar} with only an intercept in both equations, type
{bind:{cmd:zip} {it:depvar}{cmd:,} {cmd:inflate(_cons)}}.

{phang}
{opt noconstant}, {opth exposure:(varname:varname_e)}, {opt offset(varname_o)}, 
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{phang}
{opt probit} requests that a probit, instead of logit, model be used to
characterize the excess zeros in the data.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}. 

{phang}
{opt irr} reports estimated coefficients transformed to incidence-rate
ratios.  Standard errors and confidence intervals are similarly transformed.
This option affects how results are displayed, not how they are estimated or
stored.  {opt irr} may be specified at estimation or when replaying
previously estimated results.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab:Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)}, 
{opt iter:ate(#)}, [{cmd:no}]{cmd:log}, {opt tr:ace}, 
{opt grad:ient}, {opt showstep}, {opt hess:ian}, {opt showtol:erance},
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and {opt from(init_specs)}; see
{helpb maximize:[R] Maximize}.  These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt zip} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fish}{p_end}

{pstd}Fit zero-inflated Poisson model{p_end}
{phang2}{cmd:. zip count persons livebait, inflate(child camper)}{p_end}

{pstd}Replay results, displaying incidence-rate ratios{p_end}
{phang2}{cmd:. zip, irr}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:zip} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_zero)}}number of zero observations{p_end}
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
{synopt:{cmd:e(cmd)}}{cmd:zip}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(inflate)}}{cmd:logit} or {cmd:probit}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset{p_end}
{synopt:{cmd:e(offset2)}}offset for {cmd:inflate()}{p_end}
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
