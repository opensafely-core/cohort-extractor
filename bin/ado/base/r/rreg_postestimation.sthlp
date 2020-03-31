{smcl}
{* *! version 1.2.5  19oct2017}{...}
{viewerdialog predict "dialog rreg_p"}{...}
{vieweralsosee "[R] rreg postestimation" "mansection R rregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] rreg" "help rreg"}{...}
{viewerjumpto "Postestimation commands" "rreg postestimation##description"}{...}
{viewerjumpto "predict" "rreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "rreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "rreg postestimation##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[R] rreg postestimation} {hline 2}}Postestimation tools for rreg{p_end}
{p2col:}({mansection R rregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:rreg}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_lincom
{synopt:{helpb rreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb rreg postestimation##predict:predict}}predictions, residuals,
influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast} is not appropriate with {cmd:mi} estimation results.{p_end}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 17 8}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt hat}}diagonal elements of the hat matrix{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, residuals, and diagonal elements of the
hat matrix.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt residuals} calculates the residuals.

{phang}
{opt hat} calculates the diagonal elements of the hat matrix.  You
must have run the {opt rreg} command with the {opt genwt()} option.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt hat}}not allowed with {cmd:margins}{p_end}
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
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. rreg mpg foreign foreign#c.weight}{p_end}

{pstd}Test that coefficient on weight for domestic cars equals coefficient
on weight for foreign cars{p_end}
{phang2}{cmd:. test 0.foreign#c.weight = 1.foreign#c.weight}

{pstd}Obtain predicted values{p_end}
{phang2}{cmd:. predict predmpg}

{pstd}Obtain residuals{p_end}
{phang2}{cmd:. predict r, resid}{p_end}
