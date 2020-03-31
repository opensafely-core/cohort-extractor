{smcl}
{* *! version 1.0.0  07jan2019}{...}
{viewerdialog predict "dialog hetoprobit_p"}{...}
{vieweralsosee "[R] hetoprobit postestimation" "mansection R hetoprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] hetoprobit" "help hetoprobit"}{...}
{viewerjumpto "Postestimation commands" "hetoprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "hetoprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "hetoprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "hetoprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "hetoprobit postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[R] hetoprobit postestimation} {hline 2}}Postestimation tools
for hetoprobit{p_end}
{p2col:}({mansection R hetoprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:hetoprobit}:

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
{synopt:{helpb hetoprobit_postestimation##margins:margins}}marginal
        means, predictive margins, marginal effects, and average marginal
	        effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb hetoprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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

        {mansection R hetoprobitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |}
{it:{help newvar}} {c |}
{it:{help newvarlist}}{c )-} {ifin} [{cmd:,} {it:statistic}
{opt o:utcome(outcome)} {opt nooff:set}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}predicted probabilities; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sigma}}standard deviation of the error term{p_end}
{synopt :{opt sc:ores}}equation-level scores{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help fn_pr_out
{p 4 6 2}
You specify one new variable with {cmd:xb}, {cmd:stdp}, or {cmd:sigma}.{p_end}
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

INCLUDE help pr_stub

{phang}
{opt xb} calculates the linear prediction.  The linear prediction is defined
by ignoring the contribution of the estimated cutpoints.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt sigma} calculates the standard deviation of the error term.

INCLUDE help outcome_opt
{opt outcome()} is available only with the default {opt pr} option.

{phang}
{opt nooffset} is relevant only if you specified {opt offset(varname)}
for {opt hetoprobit} or within the {opt het()} option.  {opt nooffset}
modifies the calculations made by {opt predict} so that they ignore the offset
variable: the linear prediction is treated as xb rather than as xb + offset,
and the prediction of ln(sigma) is treated as zg rather than as zg + offset.
{opt nooffset} is not allowed with {cmd:scores}.

{phang}
{opt scores} calculates equation-level score variables.    The number of score
variables created will equal the number of outcomes in the model.  If the
number of outcomes in the model was k, then

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The next new variable will contain the derivative of the log likelihood with
respect to the scale equation.

{pmore}
The other new variables will contain the derivative of the log likelihood with
respect to the cutpoints.


INCLUDE help syntax_margins

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :default}probabilities for each outcome{p_end}
{synopt :{opt pr}}probability for a specified outcome{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
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
{phang2}{cmd:. webuse eathealth15}{p_end}
{phang2}{cmd:. hetoprobit health age bmi i.exercise, het(age i.exercise)}{p_end}

{pstd}Predicted probabilities of excellent health status{p_end}
{phang2}{cmd:. predict pexc if e(sample), outcome(5)}{p_end}

{pstd}Predicted standard deviation of the error term{p_end}
{phang2}{cmd:. predict psig, sigma}{p_end}

{pstd}Average marginal effects on the probability of poor health status
{p_end}
{phang2}{cmd:. margins, dydx(*) predict(outcome(1))}{p_end}
