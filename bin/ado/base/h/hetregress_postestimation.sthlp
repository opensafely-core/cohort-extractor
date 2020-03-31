{smcl}
{* *! version 1.0.6  04jun2018}{...}
{viewerdialog predict "dialog hetregress_p"}{...}
{vieweralsosee "[R] hetregress postestimation" "mansection R hetregresspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] hetregress" "help hetregress"}{...}
{viewerjumpto "Postestimation commands" "hetregress postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "hetregress_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "hetregress postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "hetregress postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "hetregress postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[R] hetregress postestimation} {hline 2}}Postestimation tools
for hetregress{p_end}
{p2col:}({mansection R hetregresspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:hetregress}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent:* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
{p2coldent:* {help estat svy:{bf:estat} (svy)}}postestimation statistics for survey data{p_end}
INCLUDE help post_estimates
INCLUDE help post_forecast_star2
INCLUDE help post_hausman_star2
INCLUDE help post_lincom
INCLUDE help post_linktest
{p2col 4 24 26 2:*+ {bf:{help lrtest}}}likelihood-ratio test; not available with
two-step estimator{p_end}
{synopt:{helpb hetregress_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb hetregress postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
{p2coldent:* {helpb suest}}seemingly unrelated estimation{p_end}
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estat ic}, {cmd:estat} (svy), {cmd:lrtest}, and {cmd:suest} are not appropriate after
{cmd:hetregress, twostep}.{p_end}
{p 4 6 2}
+ {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R hetregresspostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
After ML or two-step

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}]


{phang}
After ML

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_reg}}
{it:{help newvar:newvar_lnsigma2}}{c )-} {ifin}{cmd:,} {opt sc:ores}


{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sigma}}standard deviation of the error term{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, and standard deviations.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt stdp} calculates the standard errors of the linear prediction.

{phang}
{opt sigma} calculates the standard deviations of the error term.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the scale equation ({hi:lnsigma2}).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}not allowed with {opt margins}{p_end}
{synopt :{opt sigma}}standard deviation of the error term{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions and
of standard deviations.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse salary}{p_end}

{pstd}Fit heteroskedastic regression model{p_end}
{phang2}{cmd:. hetregress salary i.termdeg priorexp, het(i.female)}{p_end}

{pstd}Calculate the linear prediction of the mean model{p_end}
{phang2}{cmd:. predict xb, xb}{p_end}

{pstd}Calculate predicted values of the standard deviations, a function of
{cmd:i.female}{p_end}
{phang2}{cmd:. predict sigma, sigma}{p_end}

{pstd}Calculate predictive margins for each level of {cmd:termdeg}{p_end}
{phang2}{cmd:. margins termdeg}{p_end}
