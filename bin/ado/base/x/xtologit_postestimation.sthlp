{smcl}
{* *! version 1.1.6  04jun2018}{...}
{viewerdialog "predict" "dialog xtologit"}{...}
{vieweralsosee "[XT] xtologit postestimation" "mansection XT xtologitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtologit" "help xtologit"}{...}
{viewerjumpto "Postestimation commands" "xtologit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtologit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtologit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtologit postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "xtologit postestimation##example"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[XT] xtologit postestimation} {hline 2}}Postestimation tools for xtologit{p_end}
{p2col:}({mansection XT xtologitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtologit}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb xtologit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtologit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtologitpostestimationRemarksandexamples:Remarks and examples}

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
[{cmd:,} {it:statistic}
{opt o:utcome(outcome)} {opt nooff:set}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt pr}}marginal probability of the specified outcome ({cmd:outcome()}){p_end}
{synopt :{opt pu0}}probability of the specified outcome ({cmd:outcome()}) assuming that the random effect is zero{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
If you do not specify {cmd:outcome()}, {cmd:pr} and {cmd:pu0} (with one new
variable specified) assume {cmd:outcome(#1)}.{p_end}
{p 4 6 2}
You specify one or k new variables with {cmd:pr} and {cmd:pu0}, where {it:k}
is the number of outcomes.{p_end}
{p 4 6 2}
You specify one new variable with {cmd:xb} and {cmd:stdp}.{p_end}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, probabilities, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt pr} calculates predicted probabilities that are marginal with respect to
the random effect, which means that the probabilities are calculated by
integrating the prediction function with respect to the random effect over its
entire support.  Unless otherwise specified, {opt pr} defaults to the first
outcome.

{phang}
{opt pu0} calculates predicted probabilities, assuming that the random effect
for that observation's panel is zero.  Unless otherwise specified, {opt pu0}
defaults to the first outcome.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt outcome(outcome)} specifies the outcome for which the predicted
probabilities are to be calculated.  {opt outcome()} should contain either one
value of the dependent variable or one of {opt #1}, {opt #2}, {it:...}, with
{opt #1} meaning the first category of the dependent variable, {opt #2}
meaning the second category, etc.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:xtologit}.  This option modifies the calculations made by {cmd:predict} so
that they ignore the offset variable; the linear prediction is treated as xb
rather than xb + offset.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}marginal probabilities for each outcome{p_end}
{synopt :{opt pr}}marginal probability of the specified outcome ({cmd:outcome()}){p_end}
{synopt :{opt pu0}}probability of the specified outcome ({cmd:outcome()}) assuming that the random effect is zero{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt pr} and {opt pu0} default to the first outcome.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions and
probabilities.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse tvsfpors}{p_end}
{phang2}{cmd:. xtset school}{p_end}
{phang2}{cmd:. xtologit thk prethk cc##tv}{p_end}

{pstd}Compute predicted probabilities, assuming random effect is zero{p_end}
{phang2}{cmd:. predict prob*, pu0}{p_end}
