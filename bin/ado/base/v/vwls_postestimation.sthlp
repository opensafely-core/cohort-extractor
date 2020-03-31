{smcl}
{* *! version 1.2.5  19oct2017}{...}
{viewerdialog predict "dialog vwls_p"}{...}
{vieweralsosee "[R] vwls postestimation" "mansection R vwlspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] vwls" "help vwls"}{...}
{viewerjumpto "Postestimation commands" "vwls postestimation##description"}{...}
{viewerjumpto "predict" "vwls postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "vwls postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "vwls postestimation##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[R] vwls postestimation} {hline 2}}Postestimation tools for vwls
{p_end}
{p2col:}({mansection R vwlspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:vwls}:

{synoptset 20}{...}
{p2col:Command}Description{p_end}
{p2line}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_linktest
{synopt:{helpb vwls_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb vwls postestimation##predict:predict}}predictions, residuals,
influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{p2line}
{p2colreset}{...}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 17 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {cmd:xb} {cmd:stdp}]

{phang}
These statistics are available both in and out of sample; type
{cmd:predict} {it:...} {cmd:if e(sample)} {it:...} if wanted only for the
estimation sample.


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


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bp}{p_end}
{phang2}{cmd:. vwls bp gender race}{p_end}

{pstd}Linear prediction{p_end}
{phang2}{cmd:. predict p}

{pstd}Summary of linear prediction{p_end}
{phang2}{cmd:. margins}{p_end}
