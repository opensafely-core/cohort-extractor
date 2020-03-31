{smcl}
{* *! version 1.1.7  15jan2019}{...}
{viewerdialog predict "dialog hetpr_p"}{...}
{vieweralsosee "[R] hetprobit postestimation" "mansection R hetprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] hetprobit" "help hetprobit"}{...}
{viewerjumpto "Postestimation commands" "hetprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "hetprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "hetprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "hetprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "hetprobit postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[R] hetprobit postestimation} {hline 2}}Postestimation tools
for hetprobit{p_end}
{p2col:}({mansection R hetprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:hetprobit}:

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
{synopt:{helpb hetprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb hetprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R hetprobitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} 
{opt nooff:set}]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_reg}}
{it:{help newvar:newvar_lnsigma}}{c )-} {ifin} {cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}probability of a positive outcome; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt sigma}}standard deviation of the error term{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, and standard deviations.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pr}, the default, calculates the probability of a positive outcome.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt sigma} calculates the standard deviation of the error term.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:hetprobit}.  It modifies the calculations made by {cmd:predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than as xb + offset.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the scale equation ({hi:lnsigma}).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pr}}probability of a positive outcome; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt sigma}}standard deviation of the error term{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
probabilities, linear predictions, and standard deviations.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hetprobxmpl}{p_end}

{pstd}Fit heteroskedastic probit model{p_end}
{phang2}{cmd:. hetprobit y x, het(xhet) vce(robust)}{p_end}

{pstd}Calculate fitted probabilities{p_end}
{phang2}{cmd:. predict phat}{p_end}

{pstd}Calculate predicted standard deviation, a function of {cmd:xhet}{p_end}
{phang2}{cmd:. predict sigmahat, sigma}{p_end}
