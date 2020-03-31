{smcl}
{* *! version 1.0.12  01mar2018}{...}
{viewerdialog predict "dialog mlexp_p"}{...}
{vieweralsosee "[R] mlexp postestimation" "mansection R mlexppostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] mlexp" "help mlexp"}{...}
{viewerjumpto "Postestimation commands" "mlexp postestimation##description"}{...}
{viewerjumpto "predict" "mlexp postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mlexp postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "mlexp postestimation##example"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[R] mlexp postestimation} {hline 2}}Postestimation tools for mlexp{p_end}
{p2col:}({mansection R mlexppostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:mlexp}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb mlexp_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb mlexp postestimation##syntax_predict:predict}}linear predictions and scores{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
INCLUDE help post_lrtest_star_msg


{marker syntax_predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {opt xb} {cmdab:eq:uation(#}{it:eqno}{c |}{it:eqname}{cmd:)}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_1}} ... {it:{help newvar:newvar_q}}{c )-}
{ifin}
[{cmd:,}
{opt sc:ores}]

{phang}
Scores are only available for observations within the estimation 
sample.  q represents the number of equations in the model.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as linear
predictions and equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{phang}
{cmd:xb} calculates the linear prediction. 

{phang}{cmd:equation(#}{it:eqno}{c |}{it:eqname}{cmd:)} specifies the equation
for which the linear prediction is desired.  Specifying {cmd:equation(#1)}
indicates that the calculation be made for the first equation.  Specifying
{cmd:equation(demand)} indicates that the calculation be made for the equation
named {cmd:demand}, assuming there is an equation named {cmd:demand} in the
model.

{pmore}
If you specify one new variable name and omit {cmd:equation()}, 
results are the same as if you had specified {cmd:equation(#1)}.

{pmore}
For more information on using {cmd:predict} after multiple-equation
estimation commands, see {manhelp predict R}.

{phang}
{opt scores} calculates the equation-level score variables.  The
{it:j}th new variable will contain the scores for the {it:j}th equation of
the model.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt xb} defaults to the first equation.
{p_end}


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Classical linear regression{p_end}
{phang2}{cmd:. mlexp (ln(normalden(mpg, {b0}+{b1}*gear, {sigma})))}{p_end}

{pstd}Calculate scores{p_end}
{phang2}{cmd:. predict s*, scores}{p_end}

{pstd}
Probit regression with a linear combination of regressors{p_end}
{phang2}{cmd:. mlexp (ln(cond(foreign==1, normal({xb:gear_ratio turn _cons}),}
{cmd:normal(-1*({xb:}))))), vce(robust)}{p_end}

{pstd}Estimate marginal probability of success with unconditional standard
errors{p_end}
{phang2}{cmd:. margins, expression(normal(xb())) vce(unconditional)}{p_end}
