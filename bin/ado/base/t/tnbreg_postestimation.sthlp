{smcl}
{* *! version 1.2.6  04apr2019}{...}
{viewerdialog predict "dialog tnbreg_p"}{...}
{vieweralsosee "[R] tnbreg postestimation" "mansection R tnbregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] tnbreg" "help tnbreg"}{...}
{viewerjumpto "Postestimation commands" "tnbreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "tnbreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "tnbreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "tnbreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "tnbreg postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] tnbreg postestimation} {hline 2}}Postestimation tools
for tnbreg{p_end}
{p2col:}({mansection R tnbregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:tnbreg}:

{synoptset 17 tabbed}{...}
{p2col :Command}Description{p_end}
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
{synopt:{helpb tnbreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb tnbreg postestimation##predict:predict}}predictions,
residuals, influence statistics, and other diagnostic measures{p_end}
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

        {mansection R tnbregpostestimationMethodsandformulas:Methods and formulas}

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
 {it:{help newvar:newvar_disp}}{c )-}
 {ifin}{cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt n}}number of events; the default{p_end}
{synopt:{opt ir}}incidence rate{p_end}
{synopt :{opt cm}}conditional mean, E(y | y > ll){p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt cpr(n)}}conditional probability Pr(y = n | y > ll){p_end}
{synopt :{opt cpr(a,b)}}conditional probability Pr(a {ul:<} y {ul:<} b | y > ll){p_end}
{synopt:{opt xb}}linear prediction{p_end}
{synopt:{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
numbers of events, incidence rates, conditional means, probabilities, 
conditional probabilities, linear predictions, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt n}, the default, calculates the predicted number of events, which
is exp(xb) if neither {opt offset()} nor {opt exposure()} was specified
when the model was fit; {bind:exp(xb + offset)} if {opt offset()} was
specified; or {bind:exp(xb)*exposure} if {opt exposure()} was specified.

{phang}
{opt ir} calculates the incidence rate exp(xb), which is the predicted
number of events when exposure is 1.  This is equivalent to specifying both
the {opt n} and the {opt nooffset} options.

{phang}
{opt cm} calculates the conditional mean, E(y|y > ll),
where ll is the truncation point found in {cmd:e(llopt)}.

{phang}
{opt pr(n)} calculates the probability Pr(y = n),
where n is a nonnegative integer that may be specified as a number
or a variable.

INCLUDE help pr_uncond_opt

{phang}
{opt cpr(n)} calculates the conditional probability Pr(y = n|y > ll),
where ll is the truncation point found in {cmd:e(llopt)}.  n is an
integer greater than the truncation point that may be
specified as a number or a variable.

INCLUDE help cpr_lb_ub_option

{phang}
{opt xb} calculates the linear prediction, which is xb if neither
{opt offset()} nor {opt exposure()} was specified when the model was fit;
{bind:xb + offset} if {opt offset()} was specified; or
{bind:xb + ln(exposure)} if {opt exposure()} was specified; see
{opt nooffset} below.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the calculations made
by {cmd:predict} so that they ignore the offset or exposure variable; the
linear prediction is treated as xb rather than as {bind:xb + offset}
or {bind:xb + ln(exposure)}.  Specifying {cmd:predict} ...{cmd:, nooffset} is
equivalent to specifying {cmd:predict} ...{cmd:, ir}.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the dispersion equation.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt:{opt n}}number of events; the default{p_end}
{synopt:{opt ir}}incidence rate{p_end}
{synopt :{opt cm}}conditional mean, E(y | y > ll){p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt cpr(n)}}conditional probability Pr(y = n | y > ll){p_end}
{synopt :{opt cpr(a,b)}}conditional probability Pr(a {ul:<} y {ul:<} b | y > ll){p_end}
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
numbers of events, incidence rates, conditional means, probabilities, 
conditional probabilities, and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rod93}{p_end}

{pstd}Fit truncated negative binomial regression model{p_end}
{phang2}{cmd:. tnbreg deaths i.cohort, dispersion(constant) exposure(exposure) ll(9)}{p_end}

{pstd}Predict incidence rate of death{p_end}
{phang2}{cmd:. predict incidence, ir}{p_end}

{pstd}Predict the number of events{p_end}
{phang2}{cmd:. predict nevents, n}{p_end}

{pstd}Predict the number of events, conditional on the number being positive
{p_end}
{phang2}{cmd:. predict condmean, cm}{p_end}

{pstd}Predict probability of 20 or fewer deaths conditional on the number of
deaths being greater than 9{p_end}
{phang2}{cmd:. predict p1, cpr(10,20)}{p_end}

{pstd}Predict probability of 15 or more deaths conditional on the number
of deaths being greater than 9{p_end}
{phang2}{cmd:. predict p2, cpr(15,.)}{p_end}
