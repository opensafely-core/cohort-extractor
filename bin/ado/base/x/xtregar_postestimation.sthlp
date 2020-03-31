{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog predict "dialog xtrar_p"}{...}
{vieweralsosee "[XT] xtregar postestimation" "mansection XT xtregarpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtregar" "help xtregar"}{...}
{viewerjumpto "Postestimation commands" "xtregar postestimation##description"}{...}
{viewerjumpto "predict" "xtregar postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtregar postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "xtregar postestimation##example"}{...}
{p2colset 1 32 29 2}{...}
{p2col:{bf:[XT] xtregar postestimation} {hline 2}}Postestimation tools for xtregar{p_end}
{p2col:}({mansection XT xtregarpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtregar}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent :* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
{synopt:{helpb xtregar_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtregar postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt estat ic} is not appropriate after {opt xtregar, re}.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}]


{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}xb, linear prediction; the default{p_end}
{synopt :{opt ue}}u_i + e_it, the combined residual{p_end}
{p2coldent :* {opt u}}u_i, the fixed- or random-error component{p_end}
{p2coldent :* {opt e}}e_it, the overall error component{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
Unstarred statistics are available both in and out of sample; type
{cmd:predict} {it:...} {cmd:if e(sample)} {it:...} if wanted only for the
estimation sample.  Starred statistics are calculated only for the estimation
sample, even when {cmd:if e(sample)} is not specified.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear prediction and predictions.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction, xb.

{phang}
{opt ue} calculates the prediction of u_it + e_it.

{phang}
{opt u} calculates the prediction of u_i, the estimated fixed or random effect.

{phang}
{opt e} calculates the prediction of e_it.
{p_end}


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}xb, linear prediction; the default{p_end}
{synopt :{opt ue}}not allowed with {cmd:margins}{p_end}
{synopt :{opt u}}not allowed with {cmd:margins}{p_end}
{synopt :{opt e}}not allowed with {cmd:margins}{p_end}
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
{phang2}{cmd:. xtregar invest mvalue kstock, fe}

{pstd}Compute linear prediction{p_end}
{phang2}{cmd:. predict xb}{p_end}

{pstd}Estimate fixed effects{p_end}
{phang2}{cmd:. predict u, u}{p_end}
