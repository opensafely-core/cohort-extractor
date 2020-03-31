{smcl}
{* *! version 1.0.10  07jan2019}{...}
{viewerdialog fracreg "dialog fracreg"}{...}
{viewerdialog "svy: fracreg" "dialog fracreg, message(-svy-) name(svy_fracreg)"}{...}
{vieweralsosee "[R] fracreg" "mansection R fracreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] fracreg postestimation" "help fracreg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: fracreg" "help bayes fracreg"}{...}
{vieweralsosee "[R] betareg" "help betareg"}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "[MI] Estimation" "help mi estimation"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{viewerjumpto "Syntax" "fracreg##syntax"}{...}
{viewerjumpto "Menu" "fracreg##menu"}{...}
{viewerjumpto "Description" "fracreg##description"}{...}
{viewerjumpto "Links to PDF documentation" "fracreg##linkspdf"}{...}
{viewerjumpto "Options" "fracreg##options"}{...}
{viewerjumpto "Examples" "fracreg##examples"}{...}
{viewerjumpto "Stored results" "fracreg##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] fracreg} {hline 2}}Fractional response regression{p_end}
{p2col:}({mansection R fracreg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Syntax for fractional probit regression

{p 8 16 2}
{cmd:fracreg}
{opt pr:obit}
{depvar} 
[{indepvars}]
{ifin}
[{it:{help fracreg##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Syntax for fractional logistic regression

{p 8 16 2}
{cmd:fracreg}
{opt log:it}
{depvar}
[{indepvars}]
{ifin}
[{it:{help fracreg##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
Syntax for fractional heteroskedastic probit regression

{p 8 16 2}
{cmd:fracreg}
{opt pr:obit}
{depvar} 
[{indepvars}]
{ifin}
[{it:{help fracreg##weight:weight}}]{cmd:,}
{cmd:het(}{varlist}[{cmd:,}
{cmdab:off:set(}{it:{help varname:varname}_o}{cmd:)}]{cmd:)}
[{it:options}]


{synoptset 35 tabbed}{...}
{marker options_table}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{opt off:set(varname)}}include {it:varname} in model with coefficient constrained to 1{p_end}
{synopt:{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{p2coldent:* {cmd:het(}{varlist}[{cmd:,} {cmdab:off:set(}{it:{help varname:varname}_o}]{cmd:)}}independent variables to
model the variance and optional offset variable with {cmd:fracreg probit}{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt r:obust},
{opt cl:uster} {it:clustvar}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt or}}report odds ratio; only valid with {cmd:fracreg logit}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help fracreg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help fracreg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt :{opt nocoef}}do not display the coefficient table; seldom used{p_end}
{synopt :{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}* {cmd:het()} may be used only with {cmd:fracreg probit} to compute
fractional heteroskedastic probit regression.{p_end}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain
time-series operators; see {help tsvarlist}.{p_end}
{p 4 6 2}
{cmd:bayes}, {cmd:bootstrap}, {cmd:by}, {opt fp}, {cmd:jackknife},
{cmd:mi estimate}, {cmd:rolling}, {cmd:statsby}, and {cmd:svy} are allowed;
see {help prefix}.
For more details, see {manhelp bayes_fracreg BAYES:bayes: fracreg}.{p_end}
INCLUDE help vce_mi
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()},
{opt nocoef},
and weights are not allowed with the {helpb svy} prefix.
{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are
allowed; see {help weight}.{p_end}
{p 4 6 2}
{opt nocoef}, {opt collinear}, and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp fracreg_postestimation R:fracreg postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Fractional outcomes > Fractional regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:fracreg} fits a fractional response model for a dependent
variable that is greater than or equal to 0 and less than or equal to 1.
It uses a probit, logit, or heteroskedastic probit model for the
conditional mean. These models are often used for outcomes such as
rates, proportions, and fractional data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R fracregQuickstart:Quick start}

        {mansection R fracregRemarksandexamples:Remarks and examples}

        {mansection R fracregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:noconstant}, {opth offset(varname)}, {opt constraints(constraints)};
see {helpb estimation options:[R] Estimation options}.

{phang}
{cmd:het(}{varlist}[{cmd:,}
{cmd:offset(}{it:{help varname}_o}{cmd:)}]{cmd:)} specifies the independent
variables and, optionally, the offset variable in the variance function.
{cmd:het()} may only be used with {cmd:fracreg probit} to compute fractional
heteroskedastic probit regression.

{pmore}
{opt offset(varname_o)} specifies that selection offset {it:varname_o}
be included in the model with the coefficient constrained to be 1.

{dlgtab:SE/Robust}

INCLUDE help vce_rcbj

{dlgtab:Reporting}

{phang}
{opt level(#)}; see {helpb estimation options##level():[R] Estimation options}.

{phang}
{cmd:or} reports the estimated coefficients transformed to odds ratios,
that is, e^b rather than b.  Standard errors and confidence
intervals are similarly transformed.  This option affects how results
are displayed, not how they are estimated.  {cmd:or} may be specified at
estimation or when replaying previously estimated results. This option
may only be used with {cmd:fracreg logit}.

{phang}
{cmd:nocnsreport}; see {helpb estimation options##nocnsreport:[R] Estimation options}.

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

{pstd}
The following options are available with {cmd:fracreg} but are not shown
in the dialog box:

{phang}
{cmd:nocoef} specifies that the coefficient table not be displayed.
This option is sometimes used by programmers but is of no use
interactively.

{phang}
{opt collinear}, {opt coeflegend};
see {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse 401k}

{pstd}
Use fractional probit regression to obtain consistent estimates of the
parameters of the conditional mean{p_end}
{phang2}{cmd:. fracreg probit prate mrate c.ltotemp##c.ltotemp c.age##c.age i.sole}

{pstd}
Use fractional logistic regression to obtain consistent estimates of the
parameters of the conditional mean{p_end}
{phang2}{cmd:. fracreg logit prate mrate c.ltotemp##c.ltotemp c.age##c.age i.sole}

{pstd}Obtain the odds ratios by specifying the option {cmd:or}{p_end}
{phang2}{cmd:. fracreg logit prate mrate c.ltotemp##c.ltotemp c.age##c.age i.sole, or}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:fracreg} stores the following in {cmd:e()}:

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

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:fracreg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(estimator)}}model for conditional mean; {cmd:logit}, {cmd:probit}, or {cmd:hetprobit}{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(offset)}}offset{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                           maximization or minimization{p_end}
{synopt:{cmd:e(ml_method)}}type of {cmd:ml} method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(mns)}}vector of means of the independent variables{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
