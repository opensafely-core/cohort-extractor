{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog predict "dialog xtrc_p"}{...}
{vieweralsosee "[XT] xtrc postestimation" "mansection XT xtrcpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtrc" "help xtrc"}{...}
{viewerjumpto "Postestimation commands" "xtrc postestimation##description"}{...}
{viewerjumpto "predict" "xtrc postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtrc postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtrc postestimation##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[XT] xtrc postestimation} {hline 2}}Postestimation tools for xtrc{p_end}
{p2col:}({mansection XT xtrcpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtrc}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb xtrc_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtrc postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast} is not appropriate with {cmd:mi}
estimation results.{p_end}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}
{opt nooff:set}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt group(group)}}linear prediction based on group {it:group}{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction using the mean
parameter vector.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt group(group)} calculates the linear prediction using the best linear
predictors for group {it:group}.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:xtrc}.  It modifies the calculations made by {cmd:predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than xb + offset.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt group(group)}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions. 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse invest2}{p_end}
{phang2}{cmd:. xtrc invest market stock}{p_end}

{pstd}Linear prediction{p_end}
{phang2}{cmd:. predict xb}

{pstd}Mean of linear prediction{p_end}
{phang2}{cmd:. margins}{p_end}
