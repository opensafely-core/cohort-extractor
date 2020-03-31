{smcl}
{* *! version 1.0.17  07jan2019}{...}
{viewerdialog hetprobit "dialog hetprobit"}{...}
{viewerdialog "svy: hetprobit" "dialog hetprobit, message(-svy-) name(svy_hetprobit)"}{...}
{vieweralsosee "[R] hetprobit" "mansection R hetprobit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] hetprobit postestimation" "help hetprobit postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: hetprobit" "help bayes hetprobit"}{...}
{vieweralsosee "[R] hetoprobit" "help hetoprobit"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{vieweralsosee "[XT] xtprobit" "help xtprobit"}{...}
{viewerjumpto "Syntax" "hetprobit##syntax"}{...}
{viewerjumpto "Menu" "hetprobit##menu"}{...}
{viewerjumpto "Description" "hetprobit##description"}{...}
{viewerjumpto "Links to PDF documentation" "hetprobit##linkspdf"}{...}
{viewerjumpto "Options" "hetprobit##options"}{...}
{viewerjumpto "Examples" "hetprobit##examples"}{...}
{viewerjumpto "Stored results" "hetprobit##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[R] hetprobit} {hline 2}}Heteroskedastic probit model{p_end}
{p2col:}({mansection R hetprobit:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:hetprobit} {depvar} [{indepvars}] {ifin}
[{it:{help hetprobit##weight:weight}}]{cmd:,} 
{cmd:het(}{varlist} [{cmd:,} {opth off:set(varname:varname_o)}]{cmd:)}
[{it:options}]

{synoptset 27 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{p2coldent :* {cmd:het(}{varlist}[...]{cmd:)}}independent variables to model
the variance and optional offset variable{p_end}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opth off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt :{opt asis}}retain perfect predictor variables{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab :SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar}, {cmd:opg}, {opt boot:strap},
or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt lrmodel}}perform the likelihood-ratio model test instead of the
default Wald test{p_end}
{synopt :{opt waldhet}}perform Wald test on variance instead of LR test{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help hetprobit##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help hetprobit##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt het()} is required. The full specification is{break}
     {cmd:het(}{it:varlist} [{cmd:,} {opt off:set(varname_o)}]{cmd:)}.
{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}{it:depvar}, {it:indepvars}, and {it:varlist} may contain time-series
operators; see {help tsvarlist}.{p_end}
{p 4 6 2}{cmd:bayes}, {cmd:bootstrap}, {cmd:by}, {cmd:fp}, {cmd:jackknife},
{cmd:rolling}, {cmd:statsby}, and {cmd:svy} are allowed; see {help prefix}.
For more details, see {manhelp bayes_hetprobit BAYES:bayes: hetprobit}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()}, {opt lrmodel}, and weights are not allowed with the {helpb svy}
prefix.{p_end}
{marker weight}{...}
{p 4 6 2}{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp hetprobit_postestimation R:hetprobit postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Binary outcomes > Heteroskedastic probit regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:hetprobit} fits a maximum-likelihood heteroskedastic probit model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R hetprobitQuickstart:Quick start}

        {mansection R hetprobitRemarksandexamples:Remarks and examples}

        {mansection R hetprobitMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:het(}{varlist} [{cmd:,} {opth offset:(varname:varname_o)}]{cmd:)}
specifies the independent variables and, optionally, the offset variable
in the variance function.  {opt het()} is required.

{pmore}
{opt offset(varname_o)} specifies that selection offset {it:varname_o} be
included in the model with the coefficient constrained to be 1.

{phang}
{opt noconstant}, {opth offset(varname)}; see 
{helpb estimation options:[R] Estimation options}.

{phang}
{opt asis} forces the retention of perfect predictor variables and their
associated perfectly predicted observations and may produce instabilities in
maximization; see {manhelp probit R}.

{phang}
{opt constraints(constraints)}; see
{helpb estimation options:[R] Estimation options}.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt lrmodel}; see 
{helpb estimation options:[R] Estimation options}.

{phang}
{opt waldhet} specifies that a Wald test of whether {cmd:lnsigma} = 0 be
performed instead of the LR test.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{marker maximize_options}{...}
{dlgtab :Maximization}

{phang}
{it:maximize_options}: {opt dif:ficult},
{opth tech:nique(maximize##algorithm_spec:algorithm_spec)},
{opt iter:ate(#)}, [{cmd:no}]{opt log}, {opt tr:ace},
{opt grad:ient}, {opt showstep},
{opt hess:ian}, {opt showtol:erance},
{opt tol:erance(#)}, {opt ltol:erance(#)},
{opt nrtol:erance(#)}, {opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt hetprobit} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hetprobxmpl}{p_end}

{pstd}Fit heteroskedastic probit model and use {cmd:xhet} to model the variance
{p_end}
{phang2}{cmd:. hetprobit y x, het(xhet)}{p_end}

{pstd}Fit heteroskedastic probit model and request robust standard errors{p_end}
{phang2}{cmd:. hetprobit y x, het(xhet) vce(robust)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:hetprobit} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_f)}}number of zero outcomes{p_end}
{synopt:{cmd:e(N_s)}}number of nonzero outcomes{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood, comparison model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(chi2_c)}}chi-squared for heteroskedasticity test{p_end}
{synopt:{cmd:e(p_c)}}p-value for heteroskedasticity test{p_end}
{synopt:{cmd:e(df_m_c)}}degrees of freedom for heteroskedasticity test{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(rank0)}}rank of {cmd:e(V)} for constant-only model{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:hetprobit}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset1)}}offset for probit equation{p_end}
{synopt:{cmd:e(offset2)}}offset for variance equation{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test{p_end}
{synopt:{cmd:e(chi2_ct)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared
	test corresponding to {cmd:e(chi2_c)}{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                         maximization or minimization{p_end}
{synopt:{cmd:e(method)}}{cmd:ml}{p_end}
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
