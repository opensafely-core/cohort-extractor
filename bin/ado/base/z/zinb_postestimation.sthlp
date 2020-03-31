{smcl}
{* *! version 1.2.7  21may2018}{...}
{viewerdialog predict "dialog zip_p"}{...}
{vieweralsosee "[R] zinb postestimation" "mansection R zinbpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] zinb" "help zinb"}{...}
{viewerjumpto "Postestimation commands" "zinb postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "zinb_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "zinb postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "zinb postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "zinb postestimation##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[R] zinb postestimation} {hline 2}}Postestimation tools
for zinb
{p_end}
{p2col:}({mansection R zinbpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:zinb}:

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
{synopt:{helpb zinb_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb zinb postestimation##predict:predict}}predictions, residuals,
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
{cmd:svy} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R zinbpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 18 2}
{cmd:predict} {dtype} {newvar} {ifin}
[{cmd:,} {it:statistic} {opt nooff:set}]

{p 8 18 2}
{cmd:predict} {dtype} {{it:{help newvarlist##stub*:stub}}{cmd:*} | {it:{help newvar:newvar_reg}}
    {it:{help newvar:newvar_inflate}} {it:{help newvar:newvar_lnalpha}}}
    {ifin}{cmd:,} {opt sc:ores}

{marker statistic}{...}
{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt n}}number of events; the default{p_end}
{synopt :{opt ir}}incidence rate{p_end}
{synopt :{opt pr}}probability of a degenerate zero{p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
numbers of events, incidence rates, probabilities, linear predictions,
and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt n}, the default, calculates the predicted number of events, which is
(1-F_j)exp(x_j b) if neither {opt offset()} nor {opt exposure()} was specified
when the model was fit, where F_j is the predicted probability of a zero
outcome; (1-F_j)exp(x_j b + offset^b_j) if {opt offset()} was specified; or
{bind:(1-F_j){exp(x_j b) * exposure_j}} if {opt exposure()} was specified.

{phang}
{opt ir} calculates the incidence rate, which is the predicted number of
events when exposure is 1.  This is equivalent to specifying both the {opt n}
and the {opt nooffset} options.

{phang}
{opt pr} calculates the probability of a degenerate zero, predicted from the
fitted degenerate distribution F_j=F(z_j g).  If {opt offset()} was specified
within the {opt inflate()} option, then F_j=F(z_j g + offset^g_j) is
calculated.

{phang}
{opt pr(n)} calculates the probability Pr(y = n), where n is a
nonnegative integer that may be specified as a number or a variable.
Note that {opt pr} is not equivalent to {cmd:pr(0)}.

INCLUDE help pr_uncond_opt

{phang}
{opt xb} calculates the linear prediction, which is xb if neither
{opt offset()} nor {opt exposure()} was specified; {bind:x_j b + offset^b_j}
if {opt offset()} was specified; or {bind:x_j b + ln(exposure^b_j)} if
{opt exposure()} was specified; see {opt nooffset} below.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the calculations made
by {opt predict} so that they ignore the offset or exposure variable; the
linear prediction is treated as x_j b rather than as
{bind:x_j b + offset^b_j} or {bind:x_j b + ln(exposure_j)}.  Specifying
{bind:{cmd:predict ..., nooffset}} is equivalent to specifying
{bind:{cmd:predict ..., ir}}.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the inflation equation.

{pmore}
The third new variable will contain the derivative of the log likelihood with
respect to the dispersion equation ({hi:lnalpha}).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt n}}number of events; the default{p_end}
{synopt :{opt ir}}incidence rate{p_end}
{synopt :{opt pr}}probability of a degenerate zero{p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
numbers of events, incidence rates, probabilities, and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fish}{p_end}
{phang2}{cmd:. zinb count persons i.livebait, inflate(child camper)}{p_end}

{pstd}Number of events{p_end}
{phang2}{cmd:. predict n}

{pstd}Linear prediction{p_end}
{phang2}{cmd:. predict lp, xb}

{pstd}Predictive margins for {cmd:livebait}{p_end}
{phang2}{cmd:. margins livebait}

{pstd}Estimate proportion of zeros added to the negative binomial
population{p_end}
{phang2}{cmd:. predict p, pr}

{pstd}Calculate the overall probability of a zero outcome{p_end}
{phang2}{cmd:. predict p, pr(0)}

{pstd}Calculate the overall probability of 5 or fewer outcomes{p_end}
{phang2}{cmd:. predict p, pr(0,5)}{p_end}
