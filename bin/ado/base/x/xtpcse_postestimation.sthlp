{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog predict "dialog xtpcse_p"}{...}
{vieweralsosee "[XT] xtpcse postestimation" "mansection XT xtpcsepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtpcse" "help xtpcse"}{...}
{viewerjumpto "Postestimation commands" "xtpcse postestimation##description"}{...}
{viewerjumpto "predict" "xtpcse postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtpcse postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "xtpcse postestimation##example"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[XT] xtpcse postestimation} {hline 2}}Postestimation tools for xtpcse{p_end}
{p2col:}({mansection XT xtpcsepostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtpcse}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
{synopt:{helpb xtpcse_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtpcse postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin}  [{cmd:,} {opt xb} {opt stdp}]

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
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse grunfeld}{p_end}
{phang2}{cmd:. xtset company year, yearly}{p_end}
{phang2}{cmd:. xtpcse invest mvalue kstock, correlation(psar1) rhotype(tscorr)}
{p_end}

{pstd}Obtain linear prediction{p_end}
{phang2}{cmd:. predict ihat, xb}{p_end}
