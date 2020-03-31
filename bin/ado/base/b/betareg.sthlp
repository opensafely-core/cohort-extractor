{smcl}
{* *! version 1.1.9  12dec2018}{...}
{viewerdialog betareg "dialog betareg"}{...}
{viewerdialog "svy: betareg" "dialog betareg, message(-svy-) name(svy_betareg)"}{...}
{vieweralsosee "[R] betareg" "mansection R betareg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] betareg postestimation" "help betareg postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[BAYES] bayes: betareg" "help bayes betareg"}{...}
{vieweralsosee "[FMM] fmm: betareg" "help fmm betareg"}{...}
{vieweralsosee "[R] fracreg" "help fracreg"}{...}
{vieweralsosee "[R] glm" "help glm"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy_estimation"}{...}
{viewerjumpto "Syntax" "betareg##syntax"}{...}
{viewerjumpto "Menu" "betareg##menu"}{...}
{viewerjumpto "Description" "betareg##description"}{...}
{viewerjumpto "Links to PDF documentation" "betareg##linkspdf"}{...}
{viewerjumpto "Options" "betareg##options"}{...}
{viewerjumpto "Examples" "betareg##examples"}{...}
{viewerjumpto "Stored results" "betareg##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] betareg} {hline 2}}Beta regression{p_end}
{p2col:}({mansection R betareg:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:betareg}
{depvar}
{indepvars}
{ifin}
[{it:{help betareg##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 29 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:sca:le(}{varlist} [{cmd:,} {cmdab:nocons:tant}{cmd:)}}specify
independent variables for scale{p_end}
{synopt :{opt li:nk(linkname)}}specify link function for the conditional mean;
default is {cmd:link(logit)}{p_end}
{synopt :{opt sli:nk(slinkname)}}specify link function for the conditional
scale; default is {cmd:slink(log)} {p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {opt oim},
  {opt r:obust}, {opt cl:uster} {it:clustvar},
  {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
        {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help betareg##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help betareg##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}

{marker linkname}{...}
{synoptset 29}{...}
{synopthdr :linkname}
{synoptline}
{synopt :{opt logit}}logit{p_end}
{synopt :{opt prob:it}}probit{p_end}
{synopt :{opt clog:log}}complementary log-log{p_end}
{synopt :{opt logl:og}}log-log{p_end}
{synoptline}
{p2colreset}{...}

{marker slinkname}{...}
{synoptset 29}{...}
{synopthdr :slinkname}
{synoptline}
{synopt :{opt log}}log{p_end}
{synopt :{opt root}}square root{p_end}
{synopt :{opt iden:tity}}identity{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
{it:indepvars} and {it:varlist} specified in {cmd:scale()} may contain
factor variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:bayes},
{cmd:bootstrap},
{cmd:by},
{cmd:fmm},
{cmd:fp},
{cmd:jackknife},
{cmd:nestreg}, 
{cmd:rolling},
{cmd:statsby},
{cmd:stepwise}, and
{cmd:svy}
are allowed; see {help prefix}.
For more details, see {manhelp bayes_betareg BAYES:bayes: betareg} and
{manhelp fmm_betareg FMM:fmm: betareg}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{cmd:vce()} and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed; see
{help weight}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp betareg_postestimation R:betareg postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Fractional outcomes > Beta regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:betareg} estimates the parameters of a beta regression model.  This model
accommodates dependent variables that are greater than 0 and less than 1,
such as rates, proportions, and fractional data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R betaregQuickstart:Quick start}

        {mansection R betaregRemarksandexamples:Remarks and examples}

        {mansection R betaregMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{cmd:scale(}{varlist} [{cmd:, noconstant}]{cmd:)} specifies the independent
variables used to model the scale.  

{phang2}
{opt noconstant} suppresses the constant term in the scale model.
A constant term is included by default. 

{phang}
{opt link(linkname)} specifies the link function used for
the conditional mean. {it:linkname} may be {cmd:logit}, {cmd:probit},
{cmd:cloglog}, or {cmd:loglog}. The default is {cmd:link(logit)}.

{phang}
{opt slink(slinkname)} specifies the link function used for
the conditional scale. {it:slinkname} may be {cmd:log}, {cmd:root}, or
{cmd:identity}. The default is {cmd:slink(log)}.

{phang}
{opt constraints(constraints)}; see
{helpb estimation options##constraints():[R] Estimation options}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported,
which includes types that are derived from asymptotic theory ({cmd:oim}),
that are robust to some kinds of misspecification ({cmd:robust}), that allow
for intragroup correlation ({cmd:cluster} {it:clustvar}), and that
use bootstrap or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see
{helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {cmd:nocnsreport}; see
{helpb estimation options:[R] Estimation options}.

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
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pstd}
The following option is available with {cmd:betareg} but is not shown in
the dialog box:

{phang}
{opt coeflegend}; see
{helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sprogram}{p_end}

{pstd}Beta regression with default logit link for the conditional mean and log
link for the conditional scale{p_end}
{phang2}{cmd:. betareg prate i.summer freemeals pdonations}{p_end}

{pstd}Same as above, but with the scale parameter as a function of
{cmd:freemeals}{p_end}
{phang2}{cmd:. betareg prate i.summer freemeals pdonations, scale(freemeals)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:betareg} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
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

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:betareg}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(linkt)}}link title in the conditional mean equation{p_end}
{synopt:{cmd:e(linkf)}}link function in the conditional mean equation{p_end}
{synopt:{cmd:e(slinkt)}}link title in the conditional scale equation{p_end}
{synopt:{cmd:e(slinkf)}}link function in the conditional scale equation{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
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

{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log (up to 20 iterations){p_end}
{synopt:{cmd:e(gradient)}}gradient vector{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
