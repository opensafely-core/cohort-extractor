{smcl}
{* *! version 1.2.5  19oct2017}{...}
{viewerdialog predict "dialog prais_p"}{...}
{vieweralsosee "[TS] prais postestimation" "mansection TS praispostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] prais" "help prais"}{...}
{viewerjumpto "Postestimation commands" "prais postestimation##description"}{...}
{viewerjumpto "predict" "prais postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "prais postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "prais postestimation##example"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[TS] prais postestimation} {hline 2}}Postestimation tools for prais{p_end}
{p2col:}({mansection TS praispostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are available after {opt prais}:

{synoptset 17}{...}
{synopt:Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest
{synopt:{helpb prais_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb prais postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}


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
linear predictions and residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the fitted values -- the prediction of 
   xb for the specified equation.  This is the linear
   predictor from the fitted regression model; it does not apply the estimate
   of rho to prior residuals.

{phang}
{opt stdp} calculates the standard error of the prediction for the specified
   equation, that is, the standard error of the predicted expected
   value or mean for the observation's covariate pattern.  The standard error
   of the prediction is also referred to as the standard error of the fitted
   value.

{pmore}
   As computed for {opt prais}, this is strictly the standard error from the
   variance in the estimates of the parameters of the linear model and assumes
   that rho is estimated without error.

{phang}
{opt residuals} calculates the residuals from the linear prediction.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt:{cmd:xb}}linear prediction; the default{p_end}
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
{phang2}{cmd:. webuse idle}{p_end}
{phang2}{cmd:. tsset t}{p_end}
{phang2}{cmd:. prais usr idle}{p_end}

{pstd}Linear prediction{p_end}
{phang2}{cmd:. predict usrhat}{p_end}
