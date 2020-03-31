{smcl}
{* *! version 1.2.5  21may2018}{...}
{viewerdialog predict "dialog clog_p"}{...}
{vieweralsosee "[R] cloglog postestimation" "mansection R cloglogpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] cloglog" "help cloglog"}{...}
{viewerjumpto "Postestimation commands" "cloglog postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "cloglog_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "cloglog postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "cloglog postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "cloglog postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] cloglog postestimation} {hline 2}}Postestimation tools for cloglog{p_end}
{p2col:}({mansection R cloglogpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:cloglog}:

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
{synopt:{helpb cloglog_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb cloglog postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results.  {cmd:forecast} is also not appropriate with
{cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R cloglogpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang2}{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic} {cmdab:nooff:set}]

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}probability of a positive outcome; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect to xb{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, standard errors, and equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pr}, the default, calculates the probability of a positive outcome.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt score} calculates the equation-level score, the derivative of the log
likelihood with respect to the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:cloglog}.  It modifies the calculations made by {opt predict} so that they
ignore the offset variable; the linear prediction is treated as xb rather than
xb + offset.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pr}}probability of a positive outcome; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for 
probabilities and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. cloglog foreign weight mpg}{p_end}
{phang2}{cmd:. estimates store cloglog}{p_end}
{phang2}{cmd:. logit foreign weight mpg}{p_end}
{phang2}{cmd:. estimates store logit}{p_end}

{pstd}Perform seemingly unrelated estimation so that we can compare the
estimates from the two fitted models{p_end}
{phang2}{cmd:. suest cloglog logit}

{pstd}Display the coefficient matrix to learn how the equations are
named{p_end}
{phang2}{cmd:. matrix list e(b)}

{pstd}Test that the estimates from the two fitted models are the same{p_end}
{phang2}{cmd:. test [cloglog_foreign = logit_foreign]}{p_end}
