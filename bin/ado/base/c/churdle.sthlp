{smcl}
{* *! version 1.0.10  01may2019}{...}
{viewerdialog churdle "dialog churdle"}{...}
{viewerdialog "svy: churdle" "dialog churdle, message(-svy-) name(svy_churdle)"}{...}
{vieweralsosee "[R] churdle" "mansection R churdle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] churdle postestimation" "help churdle postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] intreg" "help intreg"}{...}
{vieweralsosee "[SVY] svy estimation" "help svy estimation"}{...}
{vieweralsosee "[R] tobit" "help tobit"}{...}
{viewerjumpto "Syntax" "churdle##syntax"}{...}
{viewerjumpto "Menu" "churdle##menu"}{...}
{viewerjumpto "Description" "churdle##description"}{...}
{viewerjumpto "Links to PDF documentation" "churdle##linkspdf"}{...}
{viewerjumpto "Options" "churdle##options"}{...}
{viewerjumpto "Examples" "churdle##examples"}{...}
{viewerjumpto "Stored results" "churdle##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[R] churdle} {hline 2}}Cragg hurdle regression{p_end}
{p2col:}({mansection R churdle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Basic syntax

{p 8 16 2}{cmd:churdle}
{cmdab:lin:ear}
{depvar}{cmd:,}
  {cmdab:sel:ect(}{it:{help varlist:varlist_s}}{cmd:)}
  {c -(}{cmd:ll(}...{cmd:)} | {cmd:ul(}...{cmd:)}{c )-}

{p 8 16 2}{cmd:churdle}
{cmdab:exp:onential}
{depvar}{cmd:,}
{cmdab:sel:ect(}{it:{help varlist:varlist_s}}{cmd:)}
{cmd:ll(}...{cmd:)}


{phang}
Full syntax for churdle linear

{p 8 16 2}{cmd:churdle}
{cmdab:lin:ear}
{depvar} [{indepvars}] {ifin}
[{it:{help churdle##weight:weight}}]{cmd:,}
  {cmdab:sel:ect(}{it:{help varlist:varlist_s}}[{cmd:,}
  {cmdab:nocons:tant}
  {cmd:het(}{it:{help varlist:varlist_o}}{cmd:)}]{cmd:)}
  {c -(}{cmd:ll(}{it:#}|{varname}{cmd:)} | {cmd:ul(}{it:#}|{varname}{cmd:)}{c )-}
   [{it:options}]


{phang}
Full syntax for churdle exponential

{p 8 16 2}{cmd:churdle}
{cmdab:exp:onential}
{depvar} [{indepvars}] {ifin}
[{it:{help churdle##weight:weight}}]{cmd:,} 
{cmdab:sel:ect(}{it:{help varlist:varlist_s}}[{cmd:,}
{cmdab:nocons:tant}
{opth het:(varlist:varlist_o)}]{cmd:)} {cmd:ll(}{it:#}|{varname}{cmd:)}
[{it:options}]


{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{p2coldent:* {cmdab:sel:ect()}}specify independent variables and options for selection model  {p_end}
{p2coldent:+ {cmd:ll(}{it:#}|{varname}{cmd:)}}lower truncation limit{p_end}
{p2coldent:+ {cmd:ul}({it:#}|{varname}{cmd:)}}upper truncation limit{p_end}
{synopt :{cmdab:nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{opth het(varlist)}}specify variables to model the variance{p_end}

{syntab:SE/Robust}
{synopt :{opth vce(vcetype)}}{it:vcetype} may be {cmd:oim}, {cmdab:r:obust}, {cmdab:cl:uster} {it:clustvar}, {opt boot:strap}, or {cmdab:jack:knife}{p_end}

{syntab:Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{cmdab:nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help churdle##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt :{it:{help churdle##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p 4 6 2}* {cmd:select()} is required.
The full specification is{p_end}
{p 10 10 2}
{cmdab:sel:ect(}{it:varlist_s}[{cmd:,} {cmdab:nocons:tant} {opt het(varlist_o)}]{cmd:)}{p_end}
{p 6 6 2}{cmd:noconstant} specifies that the constant be excluded from the selection
model.  {opt het(varlist_o)} specifies the variables in the error-variance
function
of the selection model.{p_end}
{p 4 6 2}+ You must specify at least one of
{cmd:ul(}{it:#}|{it:varname}{cmd:)} or {cmd:ll(}{it:#}|{it:varname}{cmd:)} for the linear model and must specify {cmd:ll(}{it:#}|{it:varname}{cmd:)} for 
the exponential model.{p_end}
{p 4 6 2}
{it:indepvars}, {it:varlist_s}, and {it:varlist_o} may contain factor
variables; see {help fvvarlist}.{p_end}
{p 4 6 2}
{cmd:bootstrap},
{cmd:by},
{cmd:fp},
{cmd:jackknife},
{cmd:rolling},
{cmd:statsby}, and
{cmd:svy}
are allowed; see {help prefix}.
{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{p 4 6 2}
{opt vce()} and weights are not allowed with the {helpb svy} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s  are allowed; see {help weight}.{p_end}
{p 4 6 2}
{cmd:coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp churdle_postestimation R:churdle postestimation} for
features available after estimation.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Hurdle regression}


{marker description}{...}
{title:Description}

{pstd}
{cmd:churdle} fits a linear or exponential hurdle model for a bounded
dependent variable.  The hurdle model combines a selection model that
determines the boundary points of the dependent variable with an outcome
model that determines its nonbounded values.  Separate independent
covariates are permitted for each model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R churdleQuickstart:Quick start}

        {mansection R churdleRemarksandexamples:Remarks and examples}

        {mansection R churdleMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{cmd:select(}{it:{help varlist:varlist_s}}[{cmd:, noconstant} 
{opth het:(varlist:varlist_o)}]{cmd:)} specifies the variables and options for
the selection model.  {cmd:select()} is required.

{phang}
{cmd:ll(}{it:#}|{varname}{cmd:)} and
{cmd:ul(}{it:#}|{varname}{cmd:)} indicate the lower and upper limits,
respectively, for the dependent variable.  You must specify one or both
for the linear model and must specify a lower limit for the exponential
model.  Observations with {depvar} <= {cmd:ll()} have a lower bound;
observations with {it:depvar} >= {cmd:ul()} have an upper bound; and the
remaining observations are in the continuous region.

{phang}
{cmd:noconstant}, {opt constraints(constraints)}; see 
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opth het(varlist)} specifies the variables in the error-variance
function of the outcome model.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are derived from asymptotic theory ({cmd:oim}), that are
robust to some kinds of misspecification ({cmd:robust}), that allow for
intragroup correlation ({cmd:cluster}, {it:clustvar}), and that use bootstrap
or jackknife methods ({cmd:bootstrap}, {cmd:jackknife}); see 
{helpb vce_option:[R] {it:vce_option}}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {cmd:nocnsreport};
see {helpb estimation options##nocnsreport:[R] Estimation options}.

INCLUDE help displayopts_list

{dlgtab:Maximization}

{marker maximize_options}{...}
{phang}
{it:maximize_options}:
{cmdab:dif:ficult},
{opt tech:nique(algorithm_spec)},
{opt iter:ate(#)},
[{cmd:no}]{cmd:log},
{cmdab:tr:ace},
{cmdab:grad:ient},
{cmd:showstep},
{cmdab:hess:ian},
{cmdab:showtol:erance},
{opt tol:erance(#)},
{opt ltol:erance(#)},
{opt nrtol:erance(#)},
{cmdab:nonrtol:erance}, and
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.  These options are seldom used.

{pstd}
The following option is available with {cmd:churdle} but is not shown in
the dialog box:

{phang}
{cmd:coeflegend}; see 
{helpb estimation options##level():[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fitness}{p_end}

{pstd}Cragg hurdle linear regression{p_end}
{phang2}{cmd:. churdle linear hours age i.smoke distance i.single, select(commute whours age) ll(0)}{p_end}

{pstd}Average marginal effect of {cmd:age}{p_end}
{phang2}{cmd:. margins, dydx(age)}{p_end}

{pstd}Cragg hurdle linear regression with a model for the variance{p_end}
{phang2}{cmd:. churdle linear hours age i.smoke distance i.single, select(commute whours age, het(age single)) ll(0)}{p_end}

{pstd}Cragg hurdle exponential regression{p_end}
{phang2}{cmd:. churdle exponential hours age i.smoke distance i.single, select(commute whours age) ll(0) nolog}{p_end}

{pstd}Average marginal effect of {cmd:age}{p_end}
{phang2}{cmd:. margins, dydx(age)}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:churdle} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(r2_p)}}pseudo-R-squared{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_0)}}log likelihood, constant-only model{p_end}
{synopt:{cmd:e(N_clust)}}number of clusters{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(v)}{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:churdle}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(estimator)}}{cmd:linear} or {cmd:exponential}{p_end}
{synopt:{cmd:e(model)}}{cmd:Linear} or {cmd:Exponential}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(clustvar)}}name of cluster variable{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald} or {cmd:LR}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(which)}}{cmd:max} or {cmd:min}; whether optimizer is to perform
                           maximization or minimization{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}
{synopt:{cmd:e(asbalanced)}}factor variables {cmd:fvset} as {cmd:asbalanced}{p_end}
{synopt:{cmd:e(asobserved)}}factor variables {cmd:fvset} as {cmd:asobserved}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(ilog)}}iteration log{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(V_modelbased)}}model-based variance{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
