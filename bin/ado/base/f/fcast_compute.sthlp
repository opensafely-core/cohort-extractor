{smcl}
{* *! version 1.1.15  19oct2017}{...}
{viewerdialog "fcast compute" "dialog fcast_compute"}{...}
{vieweralsosee "[TS] fcast compute" "mansection TS fcastcompute"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] fcast graph" "help fcast_graph"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] vec intro" "help vec_intro"}{...}
{viewerjumpto "Syntax" "fcast compute##syntax"}{...}
{viewerjumpto "Menu" "fcast compute##menu"}{...}
{viewerjumpto "Description" "fcast compute##description"}{...}
{viewerjumpto "Links to PDF documentation" "fcast_compute##linkspdf"}{...}
{viewerjumpto "Options" "fcast compute##options"}{...}
{viewerjumpto "Examples" "fcast compute##examples"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[TS] fcast compute} {hline 2}}Compute dynamic forecasts
after var, svar, or vec{p_end}
{p2col:}({mansection TS fcastcompute:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
After {opt var} and {opt svar}

{p 8 17 2}
{cmd:fcast}
{opt c:ompute}
{it:prefix}
[{cmd:,}
{it:{help fcast_compute##options1:options1}}]


{pstd}
After {opt vec}

{p 8 17 2}
{cmd:fcast}
{opt c:ompute}
{it:prefix}
[{cmd:,}
{it:{help fcast_compute##options2:options2}}]


{pstd}
{it:prefix} is the prefix appended to the names of the dependent variables
to create the names of the variables holding the dynamic forecasts.

{synoptset 29 tabbed}{...}
{marker options1}{...}
{synopthdr:options1}
{synoptline}
{syntab:Main}
{synopt:{opt st:ep(#)}}set {it:#} periods to forecast; default is {cmd:step(1)}{p_end}
{synopt:{opt d:ynamic(time_constant)}}begin dynamic forecasts at {it:time_constant}{p_end}
{synopt:{opt est:imate(estname)}}use previously stored results {it:estname}; default is to use active results{p_end}
{synopt:{opt replace}}replace existing forecast variables that have the same prefix{p_end}

{syntab:Std. Errors}
{synopt:{opt nose}}suppress asymptotic standard errors{p_end}
{synopt:{opt bs}}obtain standard errors from bootstrapped residuals{p_end}
{synopt:{opt bsp}}obtain standard errors from parametric bootstrap{p_end}
{synopt:{opt bsc:entile}}estimate bounds by using centiles of bootstrapped dataset{p_end}
{synopt:{opt r:eps(#)}}perform {it:#} bootstrap replications; default is {cmd:reps(200)}
{p_end}
{synopt:{opt nodo:ts}}suppress the usual dot after each bootstrap replication{p_end}
{synopt:{cmdab:sa:ving(}{it:{help filename}}[{cmd:, replace}]{cmd:)}}save
bootstrap results as {it:filename}; use {opt replace} to overwrite existing
{it:filename}{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}

{marker options2}{...}
{synopthdr:options2}
{synoptline}
{syntab:Main}
{synopt:{opt st:ep(#)}}set {it:#} periods to forecast; default is {cmd:step(1)}{p_end}
{synopt:{opt d:ynamic(time_constant)}}begin dynamic forecasts at {it:time_constant}{p_end}
{synopt:{opt est:imate(estname)}}use previously stored results {it:estname}; default is to use active results{p_end}
{synopt:{opt replace}}replace existing forecast variables that have the same prefix{p_end}
{synopt:{opt di:fferences}}save dynamic predictions of the first-differenced variables{p_end}

{syntab:Std. errors}
{synopt:{opt nose}}suppress asymptotic standard errors{p_end}

{syntab:Reporting}
{synopt:{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synoptline}
{p2colreset}{...}

{p 4 6 2}
Default is to use asymptotic standard errors if no options are specified.
{p_end}
{p 4 6 2}
{opt fcast compute} can be used only after {opt var}, {opt svar}, and
{opt vec}; see {helpb var:[TS] var}, {helpb svar:[TS] var svar},
and {helpb vec:[TS] vec}.
{p_end}
{p 4 6 2}
You must {opt tsset} your data before using {opt fcast compute}; see
{manhelp tsset TS}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > VEC/VAR forecasts > Compute forecasts (required for graph)}


{marker description}{...}
{title:Description}

{pstd}
{opt fcast compute} produces dynamic forecasts of the dependent
variables in a model previously fit by {opt var}, {opt svar}, or {opt vec}.
{opt fcast compute} creates new variables and, if necessary, extends
the time frame of the dataset to contain the prediction horizon.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS fcastcomputeQuickstart:Quick start}

        {mansection TS fcastcomputeRemarksandexamples:Remarks and examples}

        {mansection TS fcastcomputeMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt step(#)} specifies the number of periods to be forecast.
   The default is {cmd:step(1)}.

{phang}
{opt dynamic(time_constant)} specifies the period to begin the
   dynamic forecasts.  The default is the period after the last observation in
   the estimation sample.  The {opt dynamic()} option accepts either a Stata
   date function that returns an integer or an integer that corresponds to a
   date using the current {opt tsset} format.  {opt dynamic()} must specify a
   date in the range of two or more periods into the estimation sample to one
   period after the estimation sample.

{phang}
{opt estimates(estname)} specifies that {opt fcast compute}
   use the estimation results stored as {it:estname}.  By default,
   {cmd:fcast compute} uses the active estimation results.  See 
   {manhelp estimates R} for more information on manipulating estimation
   results.

{phang}
{opt replace} causes {opt fcast compute} to replace the variables in memory
   with the specified predictions.

{phang}
{opt differences} specifies that {opt fcast compute} also save dynamic
   predictions of the first-differenced variables.  {opt differences} can 
   be specified only with {opt vec} estimation results.

{dlgtab:Std. errors}

{phang}
{opt nose} specifies that the asymptotic standard errors of the forecasted
   levels, and thus the asymptotic confidence intervals for the levels, not be
   calculated.  By default, the asymptotic standard errors and the asymptotic
   confidence intervals of the forecasted levels are calculated.

{phang}
{opt bs} specifies that {opt fcast compute} use confidence bounds estimated by
   a simulation method based on bootstrapping the residuals.

{phang}
{opt bsp} specifies that {opt fcast compute} use confidence bounds estimated
   via simulation in which the innovations are drawn from a multivariate
   normal distribution.

{phang}
{opt bscentile} specifies that {opt fcast compute} use centiles of the
   bootstrapped dataset to estimate the bounds of the confidence intervals.
   By default, {opt fcast compute} uses the estimated standard errors and the
   quantiles of the standard normal distribution determined by {opt level()}.

{phang}
{opt reps(#)} gives the number of repetitions used in the simulations.  The
   default is {cmd:reps(200)}.

{phang}
{opt nodots} specifies that no dots be displayed while obtaining the
   simulation-based standard errors.  By default, for each replication, a dot
   is displayed.

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)} specifies the name of
the file to hold the dataset that contains the bootstrap replications.  The
{opt replace} option overwrites any file with this name.

{pmore}
   {opt replace} specifies that {it:filename} be overwritten if it exists.
   This option is not shown in the dialog box.

{dlgtab:Reporting}

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
   confidence intervals.  The default is {cmd:level(95)} or as set by
   {helpb set level}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}

{pstd}Fit VAR model restricted to specified period{p_end}
{phang2}{cmd:. var dln_inc dln_consump dln_inv if qtr<tq(1979q1)}

{pstd}Compute 8-step dynamic predictions{p_end}
{phang2}{cmd:. fcast compute m2_, step(8)}{p_end}

{pstd}Compute 8-step dynamic predictions starting in the first quarter of 1978
{p_end}
{phang2}{cmd:. fcast compute m3_, step(8) dynamic(tq(1978q1))}{p_end}
