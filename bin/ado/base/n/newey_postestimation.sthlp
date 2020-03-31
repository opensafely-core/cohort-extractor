{smcl}
{* *! version 1.2.5  30oct2018}{...}
{viewerdialog predict "dialog newey_p"}{...}
{vieweralsosee "[TS] newey postestimation" "mansection TS neweypostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] newey" "help newey"}{...}
{viewerjumpto "Postestimation commands" "newey postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "newey_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "newey postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "newey postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "newey postestimation##example"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[TS] newey postestimation} {hline 2}}Postestimation tools for
newey{p_end}
{p2col:}({mansection TS neweypostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt newey}:

{synoptset 17}{...}
{synopt:Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_linktest
{synopt:{helpb newey_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb newey postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS neweypostestimationRemarksandexamples:Remarks and examples}

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
[{cmd:,} {it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt:{opt xb}}linear prediction; the default{p_end}
{synopt:{opt stdp}}standard error of the linear prediction{p_end}
{synopt:{opt re:siduals}}residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions and residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{opt xb}, the default, calculates the linear prediction.

{phang}{opt stdp} calculates the standard error of the linear prediction.

{phang}{opt residuals} calculates the residuals.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt:{opt xb}}linear prediction; the default{p_end}
{synopt:{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt:{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
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
{phang2}{cmd:. webuse idle2}{p_end}
{phang2}{cmd:. tsset time}{p_end}
{phang2}{cmd:. newey usr idle, lag(3)}{p_end}

{pstd}Linear prediction{p_end}
{phang2}{cmd:. predict usrhat}{p_end}
