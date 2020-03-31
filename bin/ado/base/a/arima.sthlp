{smcl}
{* *! version 1.3.13  12dec2018}{...}
{viewerdialog arima "dialog arima"}{...}
{vieweralsosee "[TS] arima" "mansection TS arima"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arima postestimation" "help arima postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arch" "help arch"}{...}
{vieweralsosee "[TS] dfactor" "help dfactor"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] mgarch" "help mgarch"}{...}
{vieweralsosee "[TS] mswitch" "help mswitch"}{...}
{vieweralsosee "[TS] prais" "help prais"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{vieweralsosee "[TS] sspace" "help sspace"}{...}
{vieweralsosee "[TS] threshold" "help threshold"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] ucm" "help ucm"}{...}
{viewerjumpto "Syntax" "arima##syntax"}{...}
{viewerjumpto "Menu" "arima##menu"}{...}
{viewerjumpto "Description" "arima##description"}{...}
{viewerjumpto "Links to PDF documentation" "arima##linkspdf"}{...}
{viewerjumpto "Options" "arima##options"}{...}
{viewerjumpto "Examples" "arima##examples"}{...}
{viewerjumpto "Video example" "arima##video"}{...}
{viewerjumpto "Stored results" "arima##results"}{...}
{viewerjumpto "References" "arima##references"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[TS] arima} {hline 2}}ARIMA, ARMAX, and other dynamic
regression models {p_end}
{p2col:}({mansection TS arima:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Basic syntax for a regression model with ARMA disturbances

{p 8 14 2}
{cmd:arima}
{depvar}
[{indepvars}]{cmd:,}
{opth ar(numlist)}
{opth ma(numlist)}


{pstd}
Basic syntax for an ARIMA({it:p},{it:d},{it:q}) model

{p 8 14 2}
{cmd:arima}
{depvar}{cmd:,}
{opt arima(#p,#d,#q)}


{pstd}
Basic syntax for a multiplicative seasonal 
         ARIMA({it:p},{it:d},{it:q})*({it:P},{it:D},{it:Q})s model

{p 8 14 2}
{cmd:arima}
{depvar}{cmd:,}
{opt arima(#p,#d,#q)}
{opt sarima(#P,#D,#Q,#s)}


{pstd}
Full syntax

{p 8 14 2}
{cmd:arima}
{depvar}
[{indepvars}]
{ifin}
[{it:{help arima##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 28 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{synopt:{opt arima(#p,#d,#q)}}specify ARIMA({it:p,d,q}) model for dependent variable{p_end}
{synopt:{opth ar(numlist)}}autoregressive terms of the structural model
disturbance{p_end}
{synopt:{opth ma(numlist)}}moving-average terms of the structural model
disturbance{p_end}
{synopt:{cmdab:c:onstraints(}{it:{help arima##constraints:constraints}}{cmd:)}}apply specified linear constraints{p_end}

{syntab:Model 2}
{synopt:{opt sarima(#P,#D,#Q,#s)}}specify period-{it:#s} multiplicative seasonal ARIMA term{p_end}
{synopt:{cmd:mar(}{it:{help numlist}}{cmd:,} {it:#s}{cmd:)}}multiplicative seasonal autoregressive terms; may be repeated{p_end}
{synopt:{cmd:mma(}{it:{help numlist}}{cmd:,} {it:#s}{cmd:)}}multiplicative seasonal moving-average terms; may be repeated{p_end}

{syntab:Model 3}
{synopt:{opt cond:ition}}use conditional MLE instead of full MLE{p_end}
{synopt:{opt save:space}}conserve memory during estimation{p_end}
{synopt:{opt di:ffuse}}use diffuse prior for starting Kalman filter recursions{p_end}
{synopt:{cmd:p0(}{it:#}|{it:matname}{cmd:)}}use alternate prior for
starting Kalman recursions; seldom used{p_end}
{synopt:{cmd:state0(}{it:#}|{it:matname}{cmd:)}}use alternate state
vector for starting Kalman filter recursions{p_end}

{syntab:SE/Robust}
{synopt:{opth vce(vcetype)}}{it:vcetype} may be {opt opg}, {opt r:obust}, or
    {opt oim}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt det:ail}}report list of gaps in time series{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help arima##display_options:display_options}}}control columns
       and column formats, row spacing, and line width{p_end}

{syntab:Maximization}
{synopt:{it:{help arima##maximize_options:maximize_options}}}control the
maximization process; seldom used{p_end}

{synopt:{opt col:linear}}keep collinear variables{p_end}
INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {opt tsset} your data before using {opt arima}; see {manhelp tsset TS}.
{p_end}
{p 4 6 2}
{it:depvar} and {it:indepvars} may contain time-series operators; see 
{help tsvarlist}.
{p_end}
{p 4 6 2}
{opt by}, {opt fp}, {opt rolling}, {opt statsby}, and {cmd:xi} are allowed;
see {help prefix}.{p_end}
{marker weight}{...}
{p 4 6 2}
{opt iweight}s are allowed; see {help weights}.
{p_end}
{p 4 6 2}
{opt collinear} and {opt coeflegend} do not appear in the dialog box.{p_end}
{p 4 6 2}
See {manhelp arima_postestimation TS:arima postestimation} for features
available after estimation.  {p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Time series > ARIMA and ARMAX models}


{marker description}{...}
{title:Description}

{pstd}
{opt arima} fits univariate models for a time series, where the disturbances
are allowed to follow a linear autoregressive moving-average (ARMA)
specification.  When independent variables are included in the specification,
such models are often called ARMAX models; and when independent variables are
not specified, they reduce to Box-Jenkins autoregressive integrated
moving-average (ARIMA) models in the dependent variable.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS arimaQuickstart:Quick start}

        {mansection TS arimaRemarksandexamples:Remarks and examples}

        {mansection TS arimaMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{bf:{help estimation options##noconstant:[R] Estimation options}}.

{phang}
{opt arima(#p,#d,#q)} is an alternative,
shorthand notation for specifying models with ARMA disturbances.  The 
dependent variable and any independent variables are differenced 
{it:#d} times, 1 through {it:#p} lags of autocorrelations
and 1 through {it:#q} lags of moving averages are included in the model.
For example, the specification

{pin2}
{cmd:. arima D.y, ar(1/2) ma(1/3)}

{pmore}
is equivalent to

{pin2}
{cmd:. arima y, arima(2,1,3)}

{pmore}
The latter is easier to write for simple ARMAX and ARIMA models, but if gaps
in the AR or MA lags are to be modeled, or if different operators are to be
applied to independent variables, the first syntax is required.

{phang}
{opth ar(numlist)} specifies the autoregressive terms of the structural model
   disturbance to be included in the model.  For example, {cmd:ar(1/3)}
   specifies that lags of 1, 2, and 3 of the structural disturbance be
   included in the model; {cmd:ar(1 4)} specifies that lags 1 and 4 be
   included, perhaps to account for additive quarterly effects.

{pmore}
   If the model does not contain regressors, these terms can also be
   considered autoregressive terms for the dependent variable.

{phang}
{opth ma(numlist)} specifies the moving-average terms to be included in the
   model.  These are the terms for the lagged innovations (white-noise
   disturbances).

{marker constraints}{...}
{phang}
{opt constraints(constraints)}; see 
{bf:{help estimation options:[R] Estimation options}}.

{pmore}
   If constraints are placed between structural model parameters and ARMA
   terms, the first few iterations may attempt steps into nonstationary areas.
   This process can be ignored if the final solution is well within the bounds
   of stationary solutions.

{dlgtab:Model 2}

{phang}
{opt sarima(#P,#D,#Q,#s)} is an alternative, shorthand notation for specifying
   the multiplicative seasonal components of models with ARMA disturbances.
   The dependent variable and any independent variables are lag-{it:#s}
   seasonally differenced {it:#D} times, and 1 through {it:#P} seasonal lags
   of autoregressive terms and 1 through {it:#Q} seasonal lags of
   moving-average terms are included in the model.  For example, the
   specification

{pin2}
{cmd:. arima DS12.y, ar(1/2) ma(1/3) mar(1/2,12) mma(1/2,12)}

{pmore}
   is equivalent to

{pin2}
{cmd:. arima y, arima(2,1,3) sarima(2,1,2,12)}

{phang}
{cmd:mar(}{it:{help numlist}}{cmd:,} {it:#s}{cmd:)}
   specifies the lag-{it:#s} multiplicative seasonal autoregressive terms.
   For example, {cmd:mar(1/2,12)} requests that the first two lag-12
   multiplicative seasonal autoregressive terms be included in the model.

{phang}
{cmd:mma(}{it:{help numlist}}{cmd:,} {it:#s}{cmd:)} specifies the lag-{it:#s} 
   multiplicative seasonal moving-average terms.  For example,
   {cmd:mma(1 3,12)} requests that the first and third (but not the second)
   lag-12 multiplicative seasonal moving-average terms be included in the
   model.

{dlgtab:Model 3}

{phang}
{opt condition} specifies that conditional, rather than full, maximum
likelihood estimates be produced.  The presample values for epsilon_t and mu_t
are taken to be their expected value of zero, and the estimate of the variance
of epsilon_t is taken to be constant over the entire sample; see
{help arima##H1994:Hamilton (1994, 132)}.  This estimation method is not
appropriate for nonstationary series but may be preferable for long series or
for models that have one or more long AR or MA lags.  {cmd:diffuse},
{cmd:p0()}, and {cmd:state0()} have no meaning for models fit from the
conditional likelihood and may not be specified with {cmd:condition}.

{pmore}
    If the series is long and stationary and the underlying data-generating
    process does not have a long memory, estimates will be similar, whether
    estimated by unconditional maximum likelihood (the default), conditional
    maximum likelihood ({cmd:condition}), or maximum likelihood from a diffuse
    prior ({cmd:diffuse}).

{pmore} 
    In small samples, however, results of conditional and unconditional
    maximum likelihood may differ substantially; see
    {help arima##AN1980:Annsley and Newbold (1980)}.
    Whereas the default unconditional maximum likelihood estimates make the
    most use of sample information when all the assumptions of the model are
    met, {help arima##H1989:Harvey (1989)} and
    {help arima##AK1985:Ansley and Kohn (1985)} argue for diffuse priors
    often, particularly in ARIMA models corresponding to an underlying
    structural model.

{pmore}
    The {cmd:condition} or {cmd:diffuse} options may also be preferred when
    the model contains one or more long AR or MA lags; this
    avoids inverting potentially large matrices (see {cmd:diffuse} below).

{pmore}
    When {cmd:condition} is specified, estimation is performed by the
    {cmd:arch} command (see {manhelp arch TS}), and more control of the
    estimation process can be obtained using {cmd:arch} directly.

{pmore}
    {cmd:condition} cannot be specified if the model contains any
    multiplicative seasonal terms.

{phang}
{opt savespace} specifies that memory use be conserved by retaining only
   those variables required for estimation.  The original dataset is restored
   after estimation.  This option is rarely used and should be used only if
   there is not enough space to fit a model without the option. 
   However, {opt arima} requires considerably more temporary storage
   during estimation than most estimation commands in Stata.

{phang}
{opt diffuse} specifies that a diffuse prior (see Harvey
   {help arima##H1989:1989} or {help arima##H1993:1993}) be used as a starting
   point for the Kalman filter recursions.  Using {opt diffuse}, nonstationary
   models may be fit with {opt arima} (see the
   {helpb arima##p0():p0()} option below;
   {opt diffuse} is equivalent to specifying {cmd:p0(1e9)}).  See
   {mansection TS arimaOptionsdiffuse:{bf:[TS] arima}} for details.

{marker p0()}{...}
{phang}
{cmd:p0(}{it:#}|{it:matname}{cmd:)} is a rarely specified option that
   can be used for nonstationary series or when an alternate prior for
   starting the Kalman recursions is desired; see
   {mansection TS arimaOptionsp0:{bf:[TS] arima}} for details.

{phang}
{cmd:state0(}{it:#}|{it:matname}{cmd:)} is a rarely used option that
specifies an alternate initial state vector for starting the Kalman filter
recursions.  If {it:#} is specified, all elements of the vector are taken to
be {it:#}.  The default initial state vector is {cmd:state0(0)}.

{dlgtab:SE/Robust}

INCLUDE help vce_roo

{pmore}
For state-space models in general and ARMAX and ARIMA models in particular,
the robust or quasi-maximum likelihood estimates (QMLEs) of variance are robust
to symmetric nonnormality in the disturbances, including, as a special case,
heteroskedasticity.  The robust variance estimates are not generally robust to
functional misspecification of the structural or ARMA components of the model;
see {help arima##H1994:Hamilton (1994, 389)} for a brief discussion.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{bf:{help estimation options##level():[R] Estimation options}}.

{phang}
{opt detail} specifies that a detailed list of any gaps in the series
be reported, including gaps due to missing observations or missing data
for the dependent variable or independent variables.

{phang}
{opt nocnsreport}; see
     {helpb estimation options##nocnsreport:[R] Estimation options}.

{marker display_options}{...}
{phang}
{it:display_options}:
{opt noci},
{opt nopv:alues},
{opt vsquish},
{opth cformat(%fmt)},
{opt pformat(%fmt)},
{opt sformat(%fmt)}, and
{opt nolstretch};
    see {helpb estimation options##display_options:[R] Estimation options}.

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
{opt gtol:erance(#)},
{opt nonrtol:erance(#)}, and
{opt from(init_specs)};
see {helpb maximize:[R] Maximize} for all options except {cmd:gtolerance()},
and see below for information on {helpb arima##gtolerance():gtolerance()}.

{pmore}
These options are sometimes more important for ARIMA models than most maximum
likelihood models because of potential convergence problems with ARIMA models,
particularly if the specified model and the sample data imply a nonstationary
model.

{pmore}
Several alternate optimization methods, such as Berndt-Hall-Hall-Hausman
(BHHH) and Broyden-Fletcher-Goldfarb-Shanno (BFGS), are provided for
ARIMA models.  Although ARIMA models are not as difficult to
optimize as ARCH models, their likelihoods are nevertheless generally not
quadratic and often pose optimization difficulties; this is particularly true
if a model is nonstationary or nearly nonstationary.  Because each method
approaches optimization differently, some problems can be successfully
optimized by an alternate method when one method fails.

{pmore}
Setting {cmd:technique()} to something other than the default or BHHH changes
the {it:vcetype} to {cmd:vce(oim)}.

{pmore}
   The following options are all related to maximization and are either
   particularly important in fitting ARIMA models or not available for most
   other estimators.

{phang2}
{opt technique(algorithm_spec)} specifies the optimization technique to 
   use to maximize the likelihood function.

{phang3}
{cmd:technique(bhhh)} specifies the Berndt-Hall-Hall-Hausman (BHHH) 
   algorithm.

{phang3}
{cmd:technique(dfp)} specifies the Davidon-Fletcher-Powell (DFP) algorithm.

{phang3}
{cmd:technique(bfgs)} specifies the Broyden-Fletcher-Goldfarb-Shanno 
   (BFGS) algorithm.

{phang3}
{cmd:technique(nr)} specifies Stata's modified Newton-Raphson (NR)
   algorithm.

{pmore2} 
   You can specify multiple optimization methods.  For example, 

{pin3}
{cmd:technique(bhhh 10 nr 20)} 

{pmore2}
   requests that the optimizer perform 10 BHHH iterations, switch to
   Newton-Raphson for 20 iterations, switch back to BHHH for 10 more
   iterations, and so on.

{pmore2}
The default for {opt arima} is {cmd:technique(bhhh 5 bfgs 10)}.

{marker gtolerance()}{...}
{phang2}
{opt gtolerance(#)}
specifies the tolerance for the gradient relative to the
coefficients.  When |g_i*b_i| {ul:<} {opt gtolerance()} for all parameters b_i
and the corresponding elements of the gradient g_i, the gradient tolerance
criterion is met.
The default gradient tolerance for {opt arima} is {cmd:gtolerance(.05)}.

{pmore2}
{cmd:gtolerance(999)} may be specified to disable the gradient criterion.  If
the optimizer becomes stuck with repeated "(backed up)" messages, 
the gradient probably still contains substantial values, but an uphill direction
cannot be found for the likelihood.  With this option, results can often be
obtained, but whether the global maximum likelihood has been found is unclear.

{pmore2}
When the maximization is not going well, it is also possible to set the maximum
number of iterations (see {helpb maximize:[R] Maximize}) to the point where the optimizer
appears to be stuck and to inspect the estimation results at that point.

{phang2}
{opt from(init_specs)} allows you to set the starting values of the model
   coefficients; see {helpb maximize:[R] Maximize} for a general discussion and
   syntax options.  
  
{pmore2}
   The standard syntax for {cmd:from()} accepts a matrix, a list of values, or
   coefficient name value pairs; see {helpb maximize:[R] Maximize}.  {opt arima} also
   accepts {cmd:from(armab0)}, which sets the starting value for all ARMA
   parameters in the model to zero prior to optimization.

{pmore2}
   ARIMA models may be sensitive to initial conditions and may have coefficient
   values that correspond to local maximums.  The default starting values for
   {opt arima} are generally good, particularly in large samples for
   stationary series.

{pstd}
The following options are available with {opt arima} but are not shown in the
dialog box:

{phang}
{opt collinear}, {opt coeflegend}; see
     {helpb estimation options:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse wpi1}{p_end}

{pstd}Simple ARIMA model with differencing and autoregressive and
moving-average components{p_end}
{phang2}{cmd:. arima wpi, arima(1,1,1)}{p_end}

{pstd}Same as above{p_end}
{phang2}{cmd:. arima D.wpi, ar(1) ma(1)}

{pstd}ARIMA model with additive seasonal effects{p_end}
{phang2}{cmd:. arima D.wpi, ar(1) ma(1 4)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse air2}{p_end}
{phang2}{cmd:. generate lnair = ln(air)}{p_end}

{pstd}Multiplicative SARIMA model{p_end}
{phang2}{cmd:. arima lnair, arima(0,1,1) sarima(0,1,1,12) noconstant}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse friedman2, clear}{p_end}

{pstd}ARMAX model{p_end}
{phang2}{cmd:. arima consump m2 if tin(, 1981q4), ar(1) ma(1)}

{pstd}ARMAX model with robust standard errors{p_end}
{phang2}{cmd:. arima consump m2 if tin(, 1981q4), ar(1) ma(1) vce(robust)}
{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang2}{browse "http://www.youtube.com/watch?v=8xt4q7KHfBs":Introduction to ARMA/ARIMA models}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:arima} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_gaps)}}number of gaps{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_eq_model)}}number of equations in overall model test{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(k1)}}number of variables in first equation{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(sigma)}}sigma{p_end}
{synopt:{cmd:e(chi2)}}chi-squared{p_end}
{synopt:{cmd:e(p)}}p-value for model test{p_end}
{synopt:{cmd:e(tmin)}}minimum time{p_end}
{synopt:{cmd:e(tmax)}}maximum time{p_end}
{synopt:{cmd:e(ar_max)}}maximum AR lag{p_end}
{synopt:{cmd:e(ma_max)}}maximum MA lag{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}
{synopt:{cmd:e(ic)}}number of iterations{p_end}
{synopt:{cmd:e(rc)}}return code{p_end}
{synopt:{cmd:e(converged)}}{cmd:1} if converged, {cmd:0} otherwise{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:arima}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(covariates)}}list of covariates{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(wtype)}}weight type{p_end}
{synopt:{cmd:e(wexp)}}weight expression{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(tmins)}}formatted minimum time{p_end}
{synopt:{cmd:e(tmaxs)}}formatted maximum time{p_end}
{synopt:{cmd:e(chi2type)}}{cmd:Wald}; type of model chi-squared test{p_end}
{synopt:{cmd:e(vce)}}{it:vcetype} specified in {cmd:vce()}{p_end}
{synopt:{cmd:e(vcetype)}}title used to label Std. Err.{p_end}
{synopt:{cmd:e(ma)}}lags for moving-average terms{p_end}
{synopt:{cmd:e(ar)}}lags for autoregressive terms{p_end}
{synopt:{cmd:e(mar}{it:i}{cmd:)}}multiplicative AR terms and lag {it:i}=1...
      ({it:#} seasonal AR terms){p_end}
{synopt:{cmd:e(mma}{it:i}{cmd:)}}multiplicative MA terms and lag {it:i}=1...
      ({it:#} seasonal MA terms){p_end}
{synopt:{cmd:e(seasons)}}seasonal lags in model{p_end}
{synopt:{cmd:e(opt)}}type of optimization{p_end}
{synopt:{cmd:e(ml_method)}}type of ml method{p_end}
{synopt:{cmd:e(user)}}name of likelihood-evaluator program{p_end}
{synopt:{cmd:e(technique)}}maximization technique{p_end}
{synopt:{cmd:e(tech_steps)}}number of iterations performed before switching
                 techniques{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(estat_cmd)}}program used to implement {cmd:estat}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {cmd:margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {cmd:margins}{p_end}

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


{marker references}{...}
{title:References}

{marker AK1985}{...}
{phang}
Ansley, C. F., and R. J. Kohn. 1985. Estimation, filtering, and smoothing in
state space models with incompletely specified initial conditions.
{it:Annals of Statistics} 13: 1286-1316.

{marker AN1980}{...}
{phang}
Ansley, C. F., and P. Newbold. 1980. Finite sample properties of estimators for
autoregressive moving average models.
{it:Journal of Econometrics} 13: 159-183.

{marker H1994}{...}
{phang}
Hamilton, J. D. 1994. {it:Time Series Analysis}.
Princeton: Princeton University Press.

{marker H1989}{...}
{phang}
Harvey, A. C. 1989. {it:Forecasting, Structural Time Series Models and the}
{it:Kalman Filter}. Cambridge: Cambridge University Press.

{marker H1993}{...}
{phang}
------. 1993. {it:Time Series Models}. 2nd ed. Cambridge, MA: MIT Press.
{p_end}
