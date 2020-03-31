{smcl}
{* *! version 1.2.7  12nov2018}{...}
{viewerdialog predict "dialog mlogit_p"}{...}
{vieweralsosee "[R] mlogit postestimation" "mansection R mlogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mlogit" "help mlogit"}{...}
{viewerjumpto "Postestimation commands" "mlogit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "mlogit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "mlogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mlogit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "mlogit postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] mlogit postestimation} {hline 2}}Postestimation tools for mlogit{p_end}
{p2col:}({mansection R mlogitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt mlogit}:

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
INCLUDE help post_lrtest_star
{synopt:{helpb mlogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb mlogit postestimation##predict:predict}}predictions, residuals,
influence statistics, and other diagnostic measures{p_end}
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

        {mansection R mlogitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvar}} | {it:{help newvarlist}}{c )-}
{ifin}
[{cmd:,} {it:statistic} {opt o:utcome(outcome)}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt pr}}predicted probabilities; the default{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{cmd:stdp}}standard error of the linear prediction{p_end}
{synopt :{cmd:stddp}}standard error of the difference in two linear
predictions{p_end}
{synopt :{opt sc:ores}}equation-level scores{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help fn_pr_out
{p 4 6 2}
You specify one new variable with {cmd:xb}, {cmd:stdp}, and {cmd:stddp}.
If you do not specify {cmd:outcome()}, then {cmd:outcome(#1)} is assumed.
You must specify {cmd:outcome()} with the {cmd:stddp} option.{p_end}
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
{opt xb} calculates the linear prediction.  You must also specify the
{opt outcome(outcome)} option.

{phang}
{opt stdp} calculates the standard error of the linear prediction.
You must also specify the {opt outcome(outcome)} option.

{phang}
{opt stddp} calculates the standard error of the difference in two
linear predictions.  You must specify the {opt outcome(outcome)} option,
and here you specify the two particular outcomes of interest inside
the parentheses, for example, {cmd:predict sed, stdp outcome(1,3)}.

INCLUDE help outcome_opt
{opt outcome()} is not allowed with {opt scores}.

{phang}
{opt scores} calculates equation-level score variables.  The number of
score variables created will be one less than the number of outcomes in the
model.  If the number of outcomes in the model were k, then

{pmore}
the first new variable will contain the first derivative of the log
likelihood with respect to the first equation;

{pmore}
the second new variable will contain the first derivative of the log
likelihood with respect to the second equation;

{pmore}
...

{pmore}
the (k-1)th new variable will contain the first derivative of the log
likelihood with respect to the (k-1)st equation.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}probabilities for each outcome{p_end}
{synopt :{opt pr}}probability for a specified outcome{p_end}
{synopt :{cmd:xb}}linear prediction for a specified outcome{p_end}
{synopt :{cmd:stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{cmd:stddp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt pr} and {opt xb} default to the first outcome.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for probabilities and linear
predictions.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}{p_end}
{phang2}{cmd:. mlogit insure age male nonwhite i.site}{p_end}

{pstd}Test joint significance of {cmd:2.site} and {cmd:3.site} in all equations
{p_end}
{phang2}{cmd:. test 2.site 3.site}{p_end}

{pstd}Test joint significance of coefficients in {cmd:Prepaid} equation{p_end}
{phang2}{cmd:. test [Prepaid]}{p_end}

{pstd}Test joint significance of {cmd:2.site} and {cmd:3.site} in {cmd:Uninsure}
equation{p_end}
{phang2}{cmd:. test [Uninsure]: 2.site 3.site}{p_end}

{pstd}Test if coefficients in {cmd:Prepaid} and {cmd:Uninsure} equations are
equal{p_end}
{phang2}{cmd:. test [Prepaid=Uninsure]}{p_end}

{pstd}Predict probabilities of outcome 1 for estimation sample{p_end}
{phang2}{cmd:. predict p1 if e(sample), outcome(1)}{p_end}

{pstd}Display summary statistics of {cmd:p1}{p_end}
{phang2}{cmd:. summarize p1}{p_end}

{pstd}Compute linear prediction for {cmd:Indemnity} equation{p_end}
{phang2}{cmd:. predict idx1, outcome(Indemnity) xb}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. mlogit rep78 mpg displ}{p_end}

{pstd}Compute the predicted probability at the regressors' means for each
outcome{p_end}
{phang2}{cmd:. margins, atmeans}{p_end}

{pstd}Compute the average marginal effect of each regressor on the probability
of each of the outcomes 1-3{p_end}
{phang2}{cmd:. margins, dydx(*) predict(outcome(1)) predict(outcome(2)) predict(outcome(3))}{p_end}
    {hline}
