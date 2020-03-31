{smcl}
{* *! version 1.2.7  12nov2018}{...}
{viewerdialog predict "dialog oprobi_p"}{...}
{vieweralsosee "[R] oprobit postestimation" "mansection R oprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] oprobit" "help oprobit"}{...}
{viewerjumpto "Postestimation commands" "oprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "oprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "oprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "oprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "oprobit postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] oprobit postestimation} {hline 2}}Postestimation tools for oprobit{p_end}
{p2col:}({mansection R oprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt oprobit}:

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
{synopt:{helpb oprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb oprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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

        {mansection R oprobitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {newvar} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,}
{it:statistic}
{opt o:utcome(outcome)}
{opt nooff:set}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}predicted probabilities; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt:{opt sc:ores}}equation-level scores{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help fn_pr_out
{p 4 6 2}
You specify one new variable with {cmd:xb} and {cmd:stdp}.{p_end}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

INCLUDE help pr_stub

{phang}
{opt xb} calculates the linear prediction.  You specify one new
variable, for example, {cmd:predict linear, xb}.  The linear prediction is
defined, ignoring the contribution of the estimated cutpoints.

{phang}
{opt stdp} calculates the standard error of the linear prediction.  You
specify one new variable, for example, {cmd:predict se, stdp}.

INCLUDE help outcome_opt
{opt outcome()} is available only with the default {opt pr} option.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{opt oprobit}.  It modifies the calculations made by {opt predict} so that they
ignore the offset variable; the linear prediction is treated as xb rather than
as xb + offset.  {opt nooffset} is not allowed with {cmd:scores}.

{phang}
{opt scores} calculates equation-level score variables.  The number of score
variables created will equal the number of outcomes in the model.  If the
number of outcomes in the model was k, then

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The other new variables will contain the derivative of the log likelihood with
respect to the cutpoints.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}probabilities for each outcome{p_end}
{synopt :{opt pr}}probability for a specified outcome{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{cmd:stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt pr} defaults to the first outcome.
{p_end}

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
{phang2}{cmd:. webuse fullauto}{p_end}
{phang2}{cmd:. oprobit rep77 i.foreign length mpg}{p_end}

{pstd}Predicted probabilities of an excellent repair record{p_end}
{phang2}{cmd:. predict exc if e(sample), outcome(5)}{p_end}

{pstd}Histogram of predicted probabilities{p_end}
{phang2}{cmd:. histogram exc}

{pstd}Linear prediction{p_end}
{phang2}{cmd:. predict pscore, xb}{p_end}

{pstd}Average marginal effects on the probability of the worst repair record
{p_end}
{phang2}{cmd:. margins, dydx(*) predict(outcome(1))}{p_end}
