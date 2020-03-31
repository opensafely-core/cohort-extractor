{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog predict "dialog xtgls_p"}{...}
{vieweralsosee "[XT] xtgls postestimation" "mansection XT xtglspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtgls" "help xtgls"}{...}
{viewerjumpto "Postestimation commands" "xtgls postestimation##description"}{...}
{viewerjumpto "predict" "xtgls postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtgls postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtgls postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[XT] xtgls postestimation} {hline 2}}Postestimation tools for xtgls{p_end}
{p2col:}({mansection XT xtglspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtgls}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent:* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
{p2coldent:* {bf:{help lrtest}}}likelihood-ratio test{p_end}
{synopt:{helpb xtgls_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb xtgls postestimation##predict:predict}}predictions, residuals,
 influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 8 2}* {cmd:estat ic} and {cmd:lrtest} are available only if {cmd:igls} and {cmd:corr(independent)} were specified at estimation.{p_end}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {opt xb} {opt stdp}]

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


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse invest2}{p_end}
{phang2}{cmd:. xtset company time}{p_end}
{phang2}{cmd:. xtgls invest market stock, panels(correlated) corr(ar1)}{p_end}

{pstd}Test that coefficients on {cmd:market} and {cmd:stock} are jointly zero
{p_end}
{phang2}{cmd:. test market stock}

{pstd}Linear prediction{p_end}
{phang2}{cmd:. predict ihat}{p_end}

{pstd}Standard error of linear prediction{p_end}
{phang2}{cmd:. predict serr, stdp}{p_end}
