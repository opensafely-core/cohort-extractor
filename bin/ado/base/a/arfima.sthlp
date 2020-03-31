{smcl}
{* *! version 1.0.19  22mar2019}{...}
{viewerdialog arfima "dialog arfima"}{...}
{vieweralsosee "[TS] arfima" "mansection TS arfima"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arfima postestimation" "help arfima postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{vieweralsosee "[TS] sspace" "help sspace"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{viewerjumpto "Syntax" "arfima##syntax"}{...}
{viewerjumpto "Menu" "arfima##menu"}{...}
{viewerjumpto "Description" "arfima##description"}{...}
{viewerjumpto "Links to PDF documentation" "arfima##linkspdf"}{...}
{viewerjumpto "Options" "arfima##options"}{...}
{viewerjumpto "Examples" "arfima##examples"}{...}
{viewerjumpto "Stored results" "arfima##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[TS] arfima} {hline 2}}Autoregressive 
fractionally integrated moving-average models{p_end}
{p2col:}({mansection TS arfima:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:arfima}
{depvar}
[{indepvars}]
{ifin}
[{cmd:,}
{it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{synopt:{opth ar(numlist)}}autoregressive terms{p_end}
{synopt:{opth ma(numlist)}}moving-average terms{p_end}
{synopt:{opt smem:ory}}estimate short-memory model without fractional integration{p_end}
{synopt:{opt ml:e}}maximum likelihood estimates; the default{p_end}
{synopt:{opt mpl}}maximum modified-profile-likelihood estimates{p_end}
{synopt:{cmdab:const:raints(}{it:{help estimation options##constraints():numlist}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {opt oim} or {opt r:obust}
    {p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help arfima##display_options:display_options}}}control
INCLUDE help shortdes-displayoptall

{syntab:Maximization}
{synopt:{it:{help arfima##maximize_options:maximize_options}}}control the
maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {opt tsset} your data before using {opt arfima}; see 
{manhelp tsset TS}.
{p_end}
{p 4 6 2}
{it:indepvars} may contain factor variables; see {help fvvarlist}.
{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see 
{help tsvarlist}.
{p_end}
{p 4 6 2}
{opt by}, {opt fp}, {opt rolling}, and {opt statsby} are allowed;
see {help prefix}.{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp arfima_postestimation TS:arfima postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > ARFIMA models}


{marker description}{...}
{title:Description}

{pstd}
{opt arfima} estimates the parameters of an autoregressive
fractionally integrated moving-average (ARFIMA) models.

{pstd}
Long-memory processes are stationary processes whose autocorrelation functions
decay more slowly than short-memory processes.  The ARFIMA model provides a
parsimonious parameterization of long-memory processes that nests the 
autoregressive moving-average (ARMA) model, which is widely used for 
short-memory processes.  By allowing for fractional degrees of integration,
the ARFIMA model also generalizes the autoregressive
integrated moving-average (ARIMA) model with integer degrees of integration.
See {helpb arima:[TS] arima} for ARMA and ARIMA parameter estimation.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS arfimaQuickstart:Quick start}

        {mansection TS arfimaRemarksandexamples:Remarks and examples}

        {mansection TS arfimaMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{bf:{help estimation options##noconstant:[R] Estimation options}}.

{phang}
{opth ar(numlist)} specifies the autoregressive (AR) terms to be included in
the model.  An AR({it:p}), {it:p} {ul:>} 1, specification would be
{cmd:ar(1/}{it:p}{cmd:)}.  This model includes all lags from 1 to {it:p}, but
not all lags need to be included.  For example, the specification {cmd:ar(1}
{it:p}{cmd:)} would specify an AR({it:p}) with only lags 1 and {it:p}
included, setting all the other AR lag parameters to 0.

{phang}
{opth ma(numlist)} specifies the moving-average terms to be included in the
model.  These are the terms for the lagged innovations (white-noise
disturbances).  {cmd:ma(1/}{it:q}{cmd:)}, {it:q} {ul:>} 1, specifies an 
MA({it:q}) model, but like the {cmd:ar()} option, not all lags need to be
included.

{phang}
{opt smemory} causes {cmd:arfima} to fit a short-memory model with {it:d} = 0.
This option causes {cmd:arfima} to estimate the parameters of an ARMA model
by a method that is asymptotically equivalent to that produced by {helpb arima}.

{phang}
{opt mle} causes {cmd:arfima} to estimate the parameters by maximum
likelihood.  This method is the default.

{phang}
{opt mpl} causes {cmd:arfima} to estimate the parameters by maximum
modified profile likelihood (MPL).  The MPL estimator of the
fractional-difference parameter has less small-sample bias than the maximum
likelihood estimator when there are covariates in the model.  {opt mpl} may
only be specified when there is a constant term or {it:indepvars} in the model,
and it may not be combined with the {opt mle} option.

{phang}
{opth constraints(numlist)}; see 
{bf:{help estimation options:[R] Estimation options}}.

{dlgtab:SE/Robust}

{phang}
{opt vce(vcetype)} specifies the type of standard error reported, which
includes types that are robust to some kinds of misspecification
({cmd:robust}) and that are derived from asymptotic theory ({cmd:oim}); see
{helpb vce_option:[R] {it:vce_option}}.

{pmore}
Options {cmd:vce(robust)} and {cmd:mpl} may not be combined.

{dlgtab:Reporting}

{phang}
{opt level(#)}, {opt nocnsreport}; see
{bf:{help estimation options##level():[R] Estimation options}}.

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
{opt gtol:erance(#)},
{opt nonrtol:erance}, and
{opt from(init_specs)}; see {helpb maximize:[R] Maximize}.

{pmore}
Some special points for {cmd:arfima}'s {it:maximize_options} are listed below.

{phang2} 
{cmd:technique(}{it:algorithm_spec}{cmd:)} sets the optimization algorithm.
The default algorithm is {cmd:BFGS} and {cmd:BHHH} is not allowed.
See {helpb maximize:[R] Maximize} for a description of the available
optimization algorithms.

{pmore2}
You can specify multiple optimization methods.  For example, 
{cmd:technique(bfgs 10 nr)} requests that the optimizer perform 10 BFGS
iterations and then  switch to Newton-Raphson until convergence.

{phang2}
{cmd:iterate(}{it:#}{cmd:)} sets the maximum number of iterations.  When the
maximization is not going well, set the maximum number of iterations to the
point where the optimizer appears to be stuck and inspect the estimation
results at that point.

{phang2}
{cmd:from(}{it:matname}{cmd:)} allows you to specify starting values for the 
model parameters in a row vector.  We recommend that you use the 
{cmd:iterate(0)} option, retrieve the initial estimates {cmd:e(b)}, and modify
these elements.

{pstd}
The following options are available with {opt arfima} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse campito}{p_end}

{pstd}Slowly decreasing autocorrelations indicating a long-memory process{p_end}
{phang2}{cmd:. ac width}{p_end}

{pstd}Fit ARFIMA(0,d,0) model on the tree ring data{p_end}
{phang2}{cmd:. arfima width, technique(nr)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse mloa}{p_end}

{pstd}Fit ARFIMA(1,d,2) model on the log monthly levels of carbon dioxide 
above Mauna Loa, Hawaii.  The twelfth seasonal difference of the log is
used to remove seasonality.{p_end}
{phang2}{cmd:. arfima S12.log, ar(1) ma(2)}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:arfima} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(s2)}}idiosyncratic error variance estimate, if {cmd:e(method)} =
{cmd:mpl}{p_end}
{synopt:{cmd:e(tmin)}}minimum time{p_end}
{synopt:{cmd:e(tmax)}}maximum time{p_end}
{synopt:{cmd:e(ar_max)}}maximum autoregressive lag{p_end}
{synopt:{cmd:e(ma_max)}}maximum moving-average lag{p_end}
{synopt:{cmd:e(constant)}}{cmd:0} if {cmd:noconstant}, {cmd:1} otherwise{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:arfima}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(tvar)}}time variable{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(method)}}{cmd:mle} or {cmd:mpl}{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(ma)}}lags for moving-average terms{p_end}
{synopt:{cmd:e(ar)}}lags for autoregressive terms{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(tech_steps)}}number of iterations performed before switching
                 techniques{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
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
