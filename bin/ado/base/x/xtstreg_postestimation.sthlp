{smcl}
{* *! version 1.0.10  19oct2017}{...}
{viewerdialog predict "dialog xtstreg_p"}{...}
{viewerdialog stcurve "dialog stcurve"}{...}
{vieweralsosee "[XT] xtstreg postestimation" "mansection XT xtstregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtstreg" "help xtstreg"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcurve" "help stcurve"}{...}
{viewerjumpto "Postestimation commands" "xtstreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtstreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtstreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtstreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtstreg postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[XT] xtstreg postestimation} {hline 2}}Postestimation tools for xtstreg{p_end}
{p2col:}({mansection XT xtstregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:xtstreg}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb stcurve}}plot the survivor, hazard, and cumulative hazard functions{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb xtstreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb xtstreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtstregpostestimationRemarksandexamples:Remarks and examples}

        {mansection XT xtstregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic} {opt nooff:set}]

{synoptset 15 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt mean}}marginal mean survival time{p_end}
{synopt :{opt mean0}}mean survival time assuming that the random effects are
zero{p_end}
{synopt :{opt median0}}median survival time assuming that the random effects
are zero{p_end}
{synopt :{opt hazard}}marginal hazard{p_end}
{synopt :{opt hazard0}}hazard assuming that the random effects are zero{p_end}
{synopt :{opt surv}}marginal predicted survivor function{p_end}
{synopt :{opt surv0}}predicted survivor function assuming that the random
effects are zero{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2} 
{p_end}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, mean and median survival times, hazard functions,
and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt mean} calculates the mean survival time
that is marginal with respect to the random effect,
which means that the statistic is calculated by integrating the prediction
function with respect to the random effect over its entire support.

{phang}
{opt mean0} calculates the mean survival time assuming that all
random effects are zero.

{phang}
{opt median0} calculates the median survival time assuming that all
random effects are zero.

{phang}
{opt hazard} calculates the hazard function at {cmd:_t0}
that is marginal with respect to the random effect,
which means that the statistic is calculated by integrating the prediction
function with respect to the random effect over its entire support.

{phang}
{opt hazard0} calculates the hazard function at {opt _t0}, assuming that all
random effects are zero.

{phang}
{opt surv} calculates the predicted survivor function at {opt _t0}
that is marginal with respect to the random effect,
which means that the statistic is calculated by integrating the prediction
function with respect to the random effect over its entire support.

{phang}
{opt surv0} calculates the predicted survivor function at {opt _t0}, assuming
that all random effects are zero.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{cmd:nooffset} is relevant only if you specified {opth offset:(varname)} with
{cmd:xtstreg}.  This option modifies the calculations made by {cmd:predict} so that they
ignore the offset variable; the linear prediction is treated as
xb rather than as xb + offset.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt mean}}marginal mean survival time; the default{p_end}
{synopt :{opt mean0}}mean survival time conditional on zero random effects{p_end}
{synopt :{opt median0}}median survival time conditional on zero random effects{p_end}
{synopt :{opt hazard}}marginal hazard{p_end}
{synopt :{opt surv}}marginal predicted survivor function{p_end}
{synopt :{cmd:xb}}linear predictor for the fixed portion of the model
only{p_end}
{synopt :{opt hazard0}}not allowed with {cmd:margins}{p_end}
{synopt :{opt surv}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions and mean and median survival times.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse catheter}{p_end}
{phang2}{cmd:. xtset patient}{p_end}
{phang2}{cmd:. xtstreg age female, d(weibull)}{p_end}

{pstd}Compute predicted marginal mean and the mean and median survival time assuming random effect is zero{p_end}
{phang2}{cmd:. predict mean, mean}{p_end}
{phang2}{cmd:. predict mean0, mean0}{p_end}
{phang2}{cmd:. predict median0, median0}
{p_end}
