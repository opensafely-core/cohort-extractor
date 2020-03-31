{smcl}
{* *! version 1.2.4  19oct2017}{...}
{viewerdialog predict "dialog cnsreg_p"}{...}
{vieweralsosee "[R] cnsreg postestimation" "mansection R cnsregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] cnsreg" "help cnsreg"}{...}
{viewerjumpto "Postestimation commands" "cnsreg postestimation##description"}{...}
{viewerjumpto "predict" "cnsreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "cnsreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "cnsreg postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] cnsreg postestimation} {hline 2}}Postestimation tools for cnsreg{p_end}
{p2col:}({mansection R cnsregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:cnsreg}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_linktest
INCLUDE help post_lrtest_star
{synopt:{helpb cnsreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb cnsreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results. {cmd:forecast} is also not appropriate with
{cmd:mi} estimation results.{p_end}


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
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
INCLUDE help regstats
{synopt :{opt sc:ore}}equivalent to {opt residuals}{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample
{p 4 6 2}
{opt stdf} is not allowed with {cmd:svy} estimation results.

INCLUDE help whereab


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, residuals, standard errors, probabilities, and expected
values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt residuals} calculates the residuals, that is, y - xb.

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
thought of as the standard error of the predicted expected value or mean for
the observation's covariate pattern.  The standard error of the prediction is
also referred to as the standard error of the fitted value.

{phang}
{opt stdf} calculates the standard error of the forecast, which is the
standard error of the point prediction for 1 observation.  It is
commonly referred to as the standard error of the future or forecast value.
By construction, the standard errors produced by {opt stdf} are always larger
than those produced by {opt stdp}; see
{mansection R regressMethodsandformulas:{it:Methods and formulas}} in
{bf:[R] regress}.

INCLUDE help pr_opt

{phang}
{opt e(a,b)} calculates {bind:{it:E}(xb + u | {it:a} < xb + u < {it:b})},
the expected value of y|x conditional
on y|x being in the interval ({it:a},{it:b}), meaning that y|x
is truncated.  {it:a} and {it:b} are specified as they are for {opt pr()}.

{phang}
{opt ystar(a,b)} calculates {it:E}(y*), where {bind:y* = {it:a}}
if {bind:xb + u {ul:<} {it:a}}, {bind:y* = {it:b}} if
{bind:xb + u {ul:>} {it:b}}, and {bind:y* = xb + u} otherwise,
meaning that y* is censored.  {it:a} and {it:b} are specified as
they are for {opt pr()}.

{phang}
{opt score} is equivalent to {opt residuals} for linear regression models.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
INCLUDE help regstats_margins
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions, probabilities, and expected values.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. constraint 1 price = weight}{p_end}
{phang2}{cmd:. cnsreg mpg price weight, constraints(1)}{p_end}

{pstd}Obtain linear prediction{p_end}
{phang2}{cmd:. predict mpghat, xb}

{pstd}Get adjusted means by {cmd:foreign}{p_end}
{phang2}{cmd:. margins, atmeans by(foreign)}

{pstd}Display information criteria for comparison with a subsequent
unconstrained model{p_end}
{phang2}{cmd:. estat ic} 

{pstd}An unconstrained model{p_end}
{phang2}{cmd:. regress mpg price weight foreign}

{pstd}Display information criteria to compare with previous constrained
model{p_end}
{phang2}{cmd:. estat ic}{p_end}
