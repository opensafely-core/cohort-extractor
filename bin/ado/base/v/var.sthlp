{smcl}
{* *! version 1.3.8  12dec2018}{...}
{viewerdialog var "dialog var"}{...}
{vieweralsosee "[TS] var" "mansection TS var"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] var postestimation" "help var postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] dfactor" "help dfactor"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] mgarch" "help mgarch"}{...}
{vieweralsosee "[TS] sspace" "help sspace"}{...}
{vieweralsosee "[TS] tsset" "help tsset"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] var svar" "help svar"}{...}
{vieweralsosee "[TS] varbasic" "help varbasic"}{...}
{vieweralsosee "[TS] vec" "help vec"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[DSGE]" "mansection DSGE dsge"}{...}
{viewerjumpto "Syntax" "var##syntax"}{...}
{viewerjumpto "Menu" "var##menu"}{...}
{viewerjumpto "Description" "var##description"}{...}
{viewerjumpto "Links to PDF documentation" "var##linkspdf"}{...}
{viewerjumpto "Options" "var##options"}{...}
{viewerjumpto "Examples" "var##examples"}{...}
{viewerjumpto "Stored results" "var##results"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[TS] var} {hline 2}}Vector autoregressive models{p_end}
{p2col:}({mansection TS var:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:var}
{depvarlist}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Model}
{synopt:{opt nocons:tant}}suppress constant term{p_end}
{synopt:{opth la:gs(numlist)}}use lags {it:numlist} in the VAR{p_end}
{synopt:{opth ex:og(varlist)}}use exogenous variables {it:varlist}{p_end}

{syntab:Model 2}
{synopt:{cmdab:const:raints(}{it:{help estimation options##constraints():numlist}}{cmd:)}}apply specified linear constraints{p_end}
{synopt:[{cmd:no}]{cmd:log}}display or suppress SURE iteration log; default is
to display{p_end}
{synopt:{opt it:erate(#)}}set maximum number of iterations for SURE; default is {cmd:iterate(1600)}{p_end}
{synopt:{opt tol:erance(#)}}set convergence tolerance of SURE{p_end}
{synopt:{opt nois:ure}}use one-step SURE{p_end}
{synopt:{opt dfk}}make small-sample degrees-of-freedom adjustment{p_end}
{synopt:{opt sm:all}}report small-sample t and F statistics{p_end}
{synopt:{opt nobig:f}}do not compute parameter vector for coefficients implicitly set to zero
{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt lut:stats}}report L{c u:}tkepohl lag-order selection statistics{p_end}
{synopt :{opt nocnsr:eport}}do not display constraints{p_end}
{synopt :{it:{help var##display_options:display_options}}}control columns
       and column formats, row spacing, and line width{p_end}

INCLUDE help shortdes-coeflegend
{synoptline}
{p2colreset}{...}
{p 4 6 2}
You must {cmd:tsset} your data before using {opt var}; see 
{helpb tsset:[TS] tsset}.{p_end}
{p 4 6 2}{it:depvarlist} and {it:varlist} may contain time-series
operators; see {help tsvarlist}.
{p_end}
{p 4 6 2}
{opt by}, {opt fp}, {opt rolling}, {opt statsby}, and {cmd:xi} are allowed; see
{help prefix}.{p_end}
{p 4 6 2}
{opt coeflegend} does not appear in the dialog box.{p_end}
{p 4 6 2}See {manhelp var_postestimation TS:var postestimation} for features
available after estimation.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > Vector autoregression (VAR)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:var} fits a multivariate time-series regression of each dependent
variable on lags of itself and on lags of all the other dependent
variables.  {cmd:var} also fits a variant of vector autoregressive (VAR)
models known as the VARX model, which also includes exogenous variables. 
See {manhelp var_intro TS:var intro} for a list of commands that are used 
in conjunction with {cmd:var}. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS varQuickstart:Quick start}

        {mansection TS varRemarksandexamples:Remarks and examples}

        {mansection TS varMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Model}

{phang}
{opt noconstant}; see
{bf:{help estimation options##noconstant:[R] Estimation options}}.

{phang}
{opt lags(numlist)} specifies the lags to be included in the model.
The default is {cmd:lags(1 2)}.  This option takes a {it:numlist} and
not simply an integer for the maximum lag.  For example, {cmd:lags(2)} would
include only the second lag in the model, whereas {cmd:lags(1/2)} would
include both the first and second lags in the model.  See {it:{help numlist}}
and {help tsvarlist} for more discussion of numlists
and lags.

{phang}
{opth exog(varlist)} specifies a list of exogenous variables to be
included in the VAR.

{dlgtab:Model 2}

{phang}
{opth constraints(numlist)}; see
{bf:{help estimation options##constraints():[R] Estimation options}}.

{phang}
{opt log} and {opt nolog} specify whether to display the log from the iterated
seemingly unrelated regression algorithm.  By default, the iteration log is
displayed when the coefficients are estimated through iterated seemingly
unrelated regression.  When the {opt constraints()} option is not specified,
the estimates are obtained via OLS, and {opt nolog} has no effect.  For this
reason, {opt log} and {opt nolog} can be specified only when
{opt constraints()} is specified.  Similarly, {opt nolog} cannot be combined
with {opt noisure}.  You can also control the iteration log using
{cmd:set iterlog}; see {manhelpi set_iter R:set iter}.

{phang}
{opt iterate(#)} specifies an integer that sets the maximum number of
iterations when the estimates are obtained through iterated seemingly
unrelated regression.  By default, the limit is 1,600.  When
{opt constraints()} is not specified, the estimates are obtained using OLS,
and {opt iterate()} has no effect.  For this reason, {opt iterate()} can 
be specified only when {opt constraints()} is specified.  Similarly,
{opt iterate()} cannot be combined with {opt noisure}.

{phang}
{opt tolerance(#)} specifies a number greater than zero and less
than 1 for the convergence tolerance of the iterated seemingly unrelated
regression algorithm.  By default, the tolerance is {cmd:1e-6}.  When the
{opt constraints()} option is not specified, the estimates are obtained using
OLS, and {opt tolerance()} has no effect.  For this reason, {opt tolerance()}
can be specified only when {opt constraints()} is specified.  Similarly,
{opt tolerance()} cannot be combined with {opt noisure}.

{phang}
{opt noisure} specifies that the estimates in the presence of constraints
be obtained through one-step seemingly unrelated regression.  By default,
{opt var} obtains estimates in the presence of constraints through iterated
seemingly unrelated regression.  When {opt constraints()} is not specified,
the estimates are obtained using OLS, and {opt noisure} has no effect.  For
this reason, {opt noisure} can be specified only when {opt constraints()} is
specified.

{phang}
{opt dfk} specifies that a small-sample degrees-of-freedom adjustment 
be used when estimating the error variance-covariance matrix.
Specifically, 1/(T-mparms) is used instead of the large-sample divisor
1/T, where mparms is the average number of parameters in the functional form
for y_t over the K equations.

{phang}
{opt small} causes {opt var} to report small-sample {it:t} and {it:F}
statistics instead of the large-sample normal and chi-squared statistics.

{phang}
{opt nobigf} requests that {opt var} not save the estimated parameter
vector that incorporates coefficients that have been implicitly constrained to
be zero, such as when some lags have been omitted from a model.  {cmd:e(bf)}
is used for computing asymptotic standard errors in the postestimation
commands {helpb irf create} and {helpb fcast compute}.  Therefore, specifying
{opt nobigf} implies that the asymptotic standard errors will not be available
from {opt irf create} and {opt fcast compute}.  See
{mansection TS varRemarksandexamplesFittingmodelswithsomelagsexcluded:{it:Fitting models with some lags excluded}} in {hi:[TS] var}.

{dlgtab:Reporting}

{phang}
{opt level(#)}; see
{bf:{help estimation options##level():[R] Estimation options}}.

{phang}
{opt lutstats} specifies that the L{c u:}tkepohl versions of the lag-order
selection statistics be reported.  See 
{mansection TS varsocMethodsandformulas:{it:Methods and formulas}} in 
{bf:[TS] varsoc} for a discussion of these statistics.

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

{pstd}
The following option is available with {opt var} but is not shown in the
dialog box:

{phang}
{opt coeflegend}; see
     {helpb estimation options##coeflegend:[R] Estimation options}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}
{phang2}{cmd:. tsset}

{pstd}Fit vector autoregressive model with 2 lags (the default){p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump}{p_end}

{pstd}Fit vector autoregressive model restricted to specified period{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4)}{p_end}

{pstd}Same as above, but include first, second, and third lags in model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4), lags(1/3)}
{p_end}

{pstd}Same as above, but report the L{c u:}tkepohl versions of the lag-order
selection statistics{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr<=tq(1978q4), lags(1/3)}
            {cmd:lutstats}{p_end}

{pstd}Replay results with 99% confidence interval{p_end}
{phang2}{cmd:. var, level(99)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:var} stores the following in {cmd:e()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(N_gaps)}}number of gaps in sample{p_end}
{synopt:{cmd:e(k)}}number of parameters{p_end}
{synopt:{cmd:e(k_eq)}}number of equations in {cmd:e(b)}{p_end}
{synopt:{cmd:e(k_dv)}}number of dependent variables{p_end}
{synopt:{cmd:e(df_eq)}}average number of parameters in an equation{p_end}
{synopt:{cmd:e(df_m)}}model degrees of freedom{p_end}
{synopt:{cmd:e(df_r)}}residual degrees of freedom ({cmd:small} only){p_end}
{synopt:{cmd:e(ll)}}log likelihood{p_end}
{synopt:{cmd:e(ll_dfk)}}{cmd:dfk} adjusted log likelihood ({cmd:dfk}
	only){p_end}
{synopt:{cmd:e(obs_}{it:#}{cmd:)}}number of observations on equation
	{it:#}{p_end}
{synopt:{cmd:e(k_}{it:#}{cmd:)}}number of parameters in equation {it:#}{p_end}
{synopt:{cmd:e(df_m}{it:#}{cmd:)}}model degrees of freedom for equation
	{it:#}{p_end}
{synopt:{cmd:e(df_r}{it:#}{cmd:)}}residual degrees of freedom for equation
	{it:#} ({cmd:small} only){p_end}
{synopt:{cmd:e(r2_}{it:#}{cmd:)}}R-squared for equation {it:#}{p_end}
{synopt:{cmd:e(ll_}{it:#}{cmd:)}}log likelihood for equation {it:#}{p_end}
{synopt:{cmd:e(chi2_}{it:#}{cmd:)}}chi-squared for equation {it:#}{p_end}
{synopt:{cmd:e(F_}{it:#}{cmd:)}}F statistic for equation {it:#} ({cmd:small}
	only){p_end}
{synopt:{cmd:e(rmse_}{it:#}{cmd:)}}root mean squared error for equation
	{it:#}{p_end}
{synopt:{cmd:e(aic)}}Akaike information criterion{p_end}
{synopt:{cmd:e(hqic)}}Hannan-Quinn information criterion{p_end}
{synopt:{cmd:e(sbic)}}Schwarz-Bayesian information criterion{p_end}
{synopt:{cmd:e(fpe)}}final prediction error{p_end}
{synopt:{cmd:e(mlag)}}highest lag in VAR{p_end}
{synopt:{cmd:e(tmin)}}first time period in sample{p_end}
{synopt:{cmd:e(tmax)}}maximum time{p_end}
{synopt:{cmd:e(detsig)}}determinant of {cmd:e(Sigma)}{p_end}
{synopt:{cmd:e(detsig_ml)}}determinant of Sigma_ml hat{p_end}
{synopt:{cmd:e(rank)}}rank of {cmd:e(V)}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:var}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(depvar)}}names of dependent variables{p_end}
{synopt:{cmd:e(endog)}}names of endogenous variables, if specified{p_end}
{synopt:{cmd:e(exog)}}names of exogenous variables, and their lags, if specified{p_end}
{synopt:{cmd:e(exogvars)}}names of exogenous variables, if specified{p_end}
{synopt:{cmd:e(eqnames)}}names of equations{p_end}
{synopt:{cmd:e(lags)}}lags in model{p_end}
{synopt:{cmd:e(exlags)}}lags of exogenous variables in model, if specified{p_end}
{synopt:{cmd:e(title)}}title in estimation output{p_end}
{synopt:{cmd:e(nocons)}}{cmd:nocons}, if {cmd:noconstant} is specified{p_end}
{synopt:{cmd:e(constraints)}}{cmd:constraints}, if {cmd:constraints()} is specified{p_end}
{synopt:{cmd:e(cnslist_var)}}list of specified constraints{p_end}
{synopt:{cmd:e(small)}}{cmd:small}, if specified{p_end}
{synopt:{cmd:e(lutstats)}}{cmd:lutstats}, if specified{p_end}
{synopt:{cmd:e(timevar)}}time variable specified in {cmd:tsset}{p_end}
{synopt:{cmd:e(tsfmt)}}format for the current time variable{p_end}
{synopt:{cmd:e(dfk)}}{cmd:dfk}, if specified{p_end}
{synopt:{cmd:e(properties)}}{cmd:b V}{p_end}
{synopt:{cmd:e(predict)}}program used to implement {cmd:predict}{p_end}
{synopt:{cmd:e(marginsok)}}predictions allowed by {opt margins}{p_end}
{synopt:{cmd:e(marginsnotok)}}predictions disallowed by {opt margins}{p_end}
{synopt:{cmd:e(marginsdefault)}}default {opt predict()} specification for {cmd:margins}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}coefficient vector{p_end}
{synopt:{cmd:e(Cns)}}constraints matrix{p_end}
{synopt:{cmd:e(Sigma)}}Sigma hat matrix{p_end}
{synopt:{cmd:e(V)}}variance-covariance matrix of the estimators{p_end}
{synopt:{cmd:e(bf)}}constrained coefficient vector{p_end}
{synopt:{cmd:e(exlagsm)}}matrix mapping lags to exogenous variables{p_end}
{synopt:{cmd:e(G)}}Gamma matrix; see 
      {mansection TS varMethodsandformulas:{it:Methods and formulas}} in
      {hi:[TS] var}{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}
