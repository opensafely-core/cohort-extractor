{smcl}
{* *! version 1.2.7  12nov2018}{...}
{viewerdialog predict "dialog mprobit_p"}{...}
{vieweralsosee "[R] mprobit postestimation" "mansection R mprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mprobit" "help mprobit"}{...}
{viewerjumpto "Postestimation commands" "mprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "mprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "mprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "mprobit postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] mprobit postestimation} {hline 2}}Postestimation tools for mprobit{p_end}
{p2col:}({mansection R mprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt mprobit}:

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
{synopt:{helpb mprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb mprobit postestimation##predict:predict}}predicted
probabilities, linear predictions, and standard errors{p_end}
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

        {mansection R mprobitpostestimationRemarksandexamples:Remarks and examples}

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
{synopt :{cmdab:pr}}predicted probabilities; the default{p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{cmd:stdp}}standard error of the linear prediction{p_end}
{synopt:{opt sc:ores}}equation-level scores{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help fn_pr_out
{p 4 6 2}
You specify one new variable with {cmd:xb} and {cmd:stdp}.
If you do not specify {cmd:outcome()}, then {cmd:outcome(#1)} is assumed.
{p_end}
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
{opt xb} calculates the linear prediction, x_{it:i} a_{it:j}, for 
alternative {it:j} and individual {it:i}.  The index, {it:j}, corresponds 
to the outcome specified in {opt outcome()}.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

INCLUDE help outcome_opt
{opt outcome()} is not allowed with {opt scores}.

{phang}
{opt scores} calculates equation-level score variables.  The {it:j}th new
variable will contain the scores for the {it:j}th fitted equation.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}probabilities for each outcome{p_end}
{synopt :{opt pr}}probability for a specified outcome{p_end}
{synopt :{cmd:xb}}linear prediction for a specified outcome{p_end}
{synopt :{cmd:stdp}}not allowed with {cmd:margins}{p_end}
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

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sysdsn1}{p_end}
{phang2}{cmd:. mprobit insure age male nonwhite i.site}{p_end}

{pstd}Test that the coefficients on {cmd:2.site} and {cmd:3.site} are 0 in all
equations{p_end}
{phang2}{cmd:. test 2.site 3.site}{p_end}

{pstd}Test that all coefficients in equation {cmd:Uninsure} are 0{p_end}
{phang2}{cmd:. test [Uninsure]}{p_end}

{pstd}Test that {cmd:2.site} and {cmd:3.site} are jointly 0 in the {cmd:Prepaid}
equation{p_end}
{phang2}{cmd:. test [Prepaid]: 2.site 3.site}{p_end}

{pstd}Test that coefficients in equations {cmd:Prepaid} and {cmd:Uninsure} are
equal{p_end}
{phang2}{cmd:. test [Prepaid=Uninsure]}{p_end}

{pstd}Predict probability that a person belongs to the {cmd:Prepaid} insurance
category{p_end}
{phang2}{cmd:. predict p1 if e(sample), outcome(2)}{p_end}
