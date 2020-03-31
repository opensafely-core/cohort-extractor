{smcl}
{* *! version 1.3.2  19oct2017}{...}
{viewerdialog predict "dialog tpoisson_p"}{...}
{vieweralsosee "[R] tpoisson postestimation" "mansection R tpoissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] tpoisson" "help tpoisson"}{...}
{viewerjumpto "Postestimation commands" "tpoisson postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "tpoisson_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "tpoisson postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "tpoisson postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "tpoisson postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[R] tpoisson postestimation} {hline 2}}Postestimation tools
for tpoisson{p_end}
{p2col:}({mansection R tpoissonpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:tpoisson}:

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
{synopt:{helpb tpoisson_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb tpoisson postestimation##predict:predict}}predictions,
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

        {mansection R tpoissonpostestimationRemarksandexamples:Remarks and examples}

        {mansection R tpoissonpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,}
   {it:statistic} {opt nooff:set}]

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt n}}number of events; the default{p_end}
{synopt :{opt ir}}incidence rate{p_end}
{synopt :{opt cm}}conditional mean, E(y | ll < y < ul){p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt cpr(n)}}conditional probability Pr(y = n | ll < y < ul){p_end}
{synopt :{opt cpr(a,b)}}conditional probability Pr(a {ul:<} y {ul:<} b | ll < y < ul){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with
respect to xb{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
numbers of events, incidence rates, conditional means, probabilities,
conditional probabilities, linear predictions, standard errors, and
equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt n}, the default, calculates the predicted number of events, which
is exp(xb) if neither {opt offset()} nor {opt exposure()} was specified
when the model was fit; {bind:exp(xb + offset)} if {opt offset()} was
specified; or {bind:exp(xb) x exposure} if {opt exposure()} was specified.

{phang}
{opt ir} calculates the incidence rate exp(xb), which is the predicted
number of events when exposure is 1.  This is equivalent to specifying both
the {opt n} and the {opt nooffset} options.

{phang}
{opt cm} calculates the conditional mean, E(y|ll < y < ul),
where ll is the left-truncation point specified at estimation and
ul is the right-truncation point specified at estimation.

{phang}
{opt pr(n)} calculates the probability Pr(y = n), where n is a
nonnegative integer that may be specified as a number or a variable.

INCLUDE help pr_uncond_opt

{phang}
{opt cpr(n)} calculates the conditional probability Pr(y = n|ll < y < ul),
where n is a nonnegative integer that may be specified
as a number or a variable.  ll and ul are as defined in {opt cm}.

{phang}
{opt cpr(a,b)} calculates the conditional probability
Pr(a {ul:<} y {ul:<} b | ll < y < ul), where a and b are as defined in {opt
pr(a,b)} with the additional restrictions that a > ll and b < ul.  ll and ul 
are as defined in {opt cm}.

{phang}
{opt xb} calculates the linear prediction, which is xb if neither
{opt offset()} nor {opt exposure()} was specified when the model was fit;
{bind:xb + offset} if {opt offset()} was specified; or
{bind:xb + ln(exposure)} if {opt exposure()} was specified; see
{opt nooffset} below.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt score} calculates the equation-level score, the derivative of the log
likelihood with respect to the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the calculations made
by {cmd:predict} so that they ignore the offset or exposure variable; the
linear prediction is treated as xb rather than as {bind:xb + offset}
or {bind:xb + ln(exposure)}.  Specifying {cmd:predict} ...{cmd:, nooffset} is
equivalent to specifying {cmd:predict} ...{cmd:, ir}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt n}}number of events; the default{p_end}
{synopt :{opt ir}}incidence rate{p_end}
{synopt :{opt cm}}conditional mean, E(y | ll < y < ul){p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt cpr(n)}}conditional probability Pr(y = n | ll < y < ul){p_end}
{synopt :{opt cpr(a,b)}}conditional probability Pr(a {ul:<} y {ul:<} b | ll < y < ul){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {cmd:margins}{p_end}
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
{phang2}{cmd:. webuse runshoes}{p_end}
{phang2}{cmd:. replace shoes = . if shoes<4}{p_end}

{pstd}Fit truncated Poisson regression{p_end}
{phang2}{cmd:. tpoisson shoes distance male age, ll(3)}{p_end}

{pstd}Predict the number of pairs of shoes purchased{p_end}
{phang2}{cmd:. predict shoehat, n}{p_end}

{pstd}Predict the number of shoes purchased, conditional on each person having
bought more than 3 pairs of shoes{p_end}
{phang2}{cmd:. predict shoecondhat, cm}{p_end}

{pstd}Predict the probability each person has 1-3 pairs of shoes{p_end}
{phang2}{cmd:. predict p, pr(1,3)}{p_end}

{pstd}Predict the probability each person has 6 or more pairs of shoes given
that they have more than 3 pairs of shoes{p_end}
{phang2}{cmd:. predict p2, cpr(6,.)}{p_end}
