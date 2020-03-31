{smcl}
{* *! version 1.0.4  15may2018}{...}
{viewerdialog predict "dialog threshold_p"}{...}
{vieweralsosee "[TS] threshold postestimation" "mansection TS thresholdpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] threshold" "help threshold"}{...}
{viewerjumpto "Postestimation commands" "threshold postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "threshold_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "threshold postestimation##syntax_predict"}{...}
{viewerjumpto "Examples" "threshold postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[TS] threshold postestimation} {hline 2}}Postestimation tools
for threshold{p_end}
{p2col:}({mansection TS thresholdpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after
{opt threshold}:

{synoptset 17}{...}
{synopt:Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_nlcom
{p2col :{helpb threshold postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS thresholdpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic} {opth dyn:amic(threshold_postestimation##timecon:time_constant)}]

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{cmd:xb}}linear prediction; the default{p_end}
{synopt:{cmd:stdp}}standard error of the linear prediction{p_end}
{synopt:{cmdab:r:esiduals}}residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, and residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt residuals} calculates the residuals in the equations for observable
variables.

{dlgtab:Options}

{marker timecon}{...}
{phang}
{opt dynamic(time_constant)} specifies that {opt predict} begin producing
dynamic forecasts at {it:time_constant}, which must be in the sample for which
observations on the dependent variable exist and given in the scale of the
time variable specified in {helpb tsset}.  For example,
{cmd:dynamic(tq(2014q4))} causes dynamic predictions to begin in the fourth
quarter of 2014, assuming that the time variable is quarterly; see
{manhelp Datetime D}.  If the model contains exogenous variables, they must be
present for the whole predicted sample.  {cmd:dynamic()} may not be specified
with {cmd:stdp} or {cmd:residuals}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse usmacro}{p_end}
{phang2}{cmd:. threshold fedfunds, regionvars(l.fedfunds inflation ogap)}
        {cmd:threshvar(l2.ogap)}{p_end}

{pstd}Predict values of {cmd:fedfunds}{p_end}
{phang2}{cmd:. predict fedf}{p_end}

{pstd}Same as above, but with dynamic predictions beginning in the first
quarter of 2003{p_end}
{phang2}{cmd:. predict fedfdyn, dynamic(tq(2003q1))}{p_end}
