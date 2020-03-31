{smcl}
{* *! version 1.3.1  12dec2018}{...}
{viewerdialog frontier "dialog frontier"}{...}
{vieweralsosee "[R] frontier" "mansection R frontier"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] frontier postestimation" "help frontier postestimation"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[XT] xtfrontier" "help xtfrontier"}{...}
{viewerjumpto "Syntax" "frontier##syntax"}{...}
{viewerjumpto "Menu" "frontier##menu"}{...}
{viewerjumpto "Description" "frontier##description"}{...}
{viewerjumpto "Links to PDF documentation" "frontier##linkspdf"}{...}
{viewerjumpto "Options" "frontier##options"}{...}
{viewerjumpto "Examples" "frontier##examples"}{...}
{viewerjumpto "Stored results" "frontier##results"}{...}
{viewerjumpto "Reference" "frontier##reference"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] frontier} {hline 2}}Stochastic frontier models{p_end}
{p2col:}({mansection R frontier:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:frontier}
{depvar}
[{indepvars}]
{ifin}
[{it:{help frontier##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 31 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Model}
{synopt :{opt nocons:tant}}suppress constant term{p_end}
{synopt :{cmdab:d:istribution(}{opt h:normal)}}half-normal distribution for the
inefficiency term{p_end}
{synopt :{cmdab:d:istribution(}{opt e:xponential)}}exponential distribution for the inefficiency term{p_end}
{synopt :{cmdab:d:istribution(}{opt t:normal)}}truncated-normal distribution for the inefficiency term{p_end}
{synopt :{opt uf:rom(matrix)}}specify untransformed log likelihood; only with
{cmd:d(tnormal)}{p_end}
{synopt :{cmd:cm(}{it:{help varlist}}[{cmd:,} {opt nocons:tant}]{cmd:)}}fit
conditional mean model; only with {cmd:d(tnormal)}; use {opt noconstant} to
suppress constant term{p_end}

{syntab :Model 2}
{synopt :{cmdab:const:raints(}{it:{help estimation options##constraints():constraints}}{cmd:)}}apply specified linear constraints{p_end}
{synopt :{cmdab:u:het(}{it:{help varlist}}[{cmd:,} {opt nocons:tant}]{cmd:)}}explanatory
variables for technical inefficiency variance function; use {opt noconstant}
to suppress constant term{p_end}
{synopt :{cmdab:v:het(}{it:{help varlist}}[{cmd:,} {opt nocons:tant}]{cmd:)}}explanatory
variables for idiosyncratic error variance function; use {opt noconstant}
to suppress constant term{p_end}
{synopt :{opt cost}}fit cost frontier model; default is production frontier
model{p_end}

{syntab :SE/Robust}
{p2coldent:* {opth vce(vcetype)}}{it:vcetype} may be {opt oim},
{opt r:obust}, {opt cl:uster} {it:clustvar},
{opt opg}, {opt boot:strap}, or {opt jack:knife}{p_end}

{syntab :Reporting}
{synopt :{opt l:evel(#)}}set confidence level; default is
{cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help frontier##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab :Maximization}
{synopt :{it:{help frontier##maximize_options:maximize_options}}}control the maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:vce(robust)} and {cmd:vce(cluster} {it:clustvar}{cmd:)} may not be
    specified with {cmd:distribution(tnormal)}.{p_end}
INCLUDE help fvvarlist2
{p 4 6 2}
{opt bootstrap}, {opt by}, {opt fp}, {opt jackknife}, {opt rolling}, and
{opt statsby} are allowed; see {help prefix}.{p_end}
{p 4 6 2}Weights are not allowed with the {helpb bootstrap} prefix.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt fweight}s, {opt iweight}s, and {opt pweight}s are allowed;
see {help weight}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp frontier_postestimation R:frontier postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Linear models and related > Frontier models}


{marker description}{...}
{title:Description}

{pstd}
{opt frontier} fits stochastic production or cost frontier models; the default
is a production frontier model.  It provides estimators for the parameters of
a linear model with a disturbance that is assumed to be 
a mixture of two components, which have a strictly 
nonnegative and symmetric distribution, respectively.
{opt frontier} can fit models in which the nonnegative distribution component
(a measurement of inefficiency) is assumed
to be from a half-normal, exponential, or truncated-normal distribution.
See {help frontier##KL2000:Kumbhakar and Lovell (2000)} for a detailed
introduction to frontier analysis.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R frontierQuickstart:Quick start}

        {mansection R frontierRemarksandexamples:Remarks and examples}

        {mansection R frontierMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{helpb estimation options##noconstant:[R] Estimation options}.

{phang}
{opt distribution(distname)} specifies the
distribution for the inefficiency term
as half-normal ({opt hnormal}), {opt exponential}, or truncated-normal
({opt tnormal}). The default is {opt hnormal}.

{phang}
{opt ufrom(matrix)} specifies a 1 x K matrix of
untransformed starting values when the distribution is
truncated-normal ({opt tnormal}).  {opt frontier} can
estimate the parameters of the model by maximizing either the log likelihood
or a transformed log likelihood
(see {mansection R frontierMethodsandformulas:{it:Methods and formulas}}).
{opt frontier} automatically transforms the starting values before passing
them on to the transformed log likelihood.  The matrix must have the
same number of columns as there are parameters to estimate.

{phang}
{cmd:cm(}{varlist} [{cmd:,} {opt noconstant}]{cmd:)}
may be used only with {cmd:distribution(tnormal)}.
Here {opt frontier} will fit a conditional
mean model in which the mean of the truncated-normal distribution is modeled
as a linear function of the set of covariates specified in {it:varlist}.
Specifying {opt noconstant} suppresses the constant in the mean function.

{dlgtab:Model 2}

{phang}
{opt constraints(constraints)}; see 
{helpb estimation options:[R] Estimation options}.

{pmore}
By default, when fitting the truncated-normal model or the conditional mean
model, {opt frontier} maximizes a transformed log likelihood.  When
constraints are applied, {opt frontier} will maximize the untransformed
log likelihood with constraints defined in the untransformed metric.

{phang}
{cmd:uhet(}{varlist} [{cmd:, noconstant}]{cmd:)}
specifies that the technical inefficiency component is heteroskedastic,
with the variance function depending on a linear combination of
{it:varlist_u}.  Specifying {opt noconstant} suppresses the
constant term from the variance function.  This option may not be specified
with {cmd:distribution(tnormal)}.

{phang}
{cmd:vhet(}{varlist} [{cmd:, noconstant}]{cmd:)}
specifies that the idiosyncratic error component is heteroskedastic,
with the variance function depending on a linear combination of 
{it:varlist_v}.  Specifying {opt noconstant} suppresses the
constant term from the variance function.  This option may not be specified
with {cmd:distribution(tnormal)}.

{phang}
{opt cost} specifies that {opt frontier} fit a cost frontier model.

{dlgtab:SE/Robust}

INCLUDE help vce_asymptall

{pmore}
{cmd:vce(robust)} and {cmd:vce(cluster} {it:clustvar}{cmd:)} may not be
    specified with {cmd:distribution(tnormal)}.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
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
{opt from(init_specs)};
see {helpb maximize:[R] Maximize}.
These options are seldom used.

{pmore}
Setting the optimization type to {cmd:technique(bhhh)} resets the default
{it:vcetype} to {cmd:vce(opg)}.

{pstd}
The following options are available with {opt frontier} but are not shown in
the dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse greene9}{p_end}

{pstd}Cobb-Douglas production function with half-normal distribution for
inefficiency term{p_end}
{phang2}{cmd:. frontier lnv lnk lnl}{p_end}

{pstd}Cobb-Douglas production function with exponential distribution for
inefficiency term{p_end}
{phang2}{cmd:. frontier lnv lnk lnl, dist(exponential)}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse frontier1}{p_end}

{pstd}Cobb-Douglas production function with {cmd:size} as explanatory variable
in variance function for idiosyncratic error{p_end}
{phang2}{cmd:. frontier lnoutput lnlabor lncapital, vhet(size)}{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse frontier2}{p_end}

{pstd}Cost frontier model with truncated-normal distribution for inefficiency
term{p_end}
{phang2}{cmd:. frontier lncost lnp_k lnp_l lnout, dist(tnormal) cost}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:frontier} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_c)}}log likelihood for H_0: sigma_u=0{p_end}
{synopt:{cmd:e(z)}}test for negative skewness of OLS residuals{p_end}
{synopt:{cmd:e(sigma_u)}}standard deviation of technical inefficiency{p_end}
{synopt:{cmd:e(sigma_v)}}standard deviation of V_i{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(chi2_c)}}LR test statistic{p_end}
{synopt:{cmd:e(p_z)}}p-value for z{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:frontier}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(function)}}{cmd:production} or {cmd:cost}{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(dist)}}distribution assumption for U_i{p_end}
{synopt:{cmd:e(het)}}heteroskedastic components{p_end}
{synopt:{cmd:e(u_hetvar)}}{it:varlist} in {cmd:uhet()}{p_end}
{synopt:{cmd:e(v_hetvar)}}{it:varlist} in {cmd:vhet()}{p_end}
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


{marker reference}{...}
{title:Reference}

{marker KL2000}{...}
{phang}
Kumbhakar, S. C., and C. A. K. Lovell. 2000. {it:Stochastic Frontier Analysis}.
Cambridge: Cambridge University Press.
{p_end}
