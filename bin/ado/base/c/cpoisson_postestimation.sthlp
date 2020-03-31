{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog predict "dialog cpoisson_p"}{...}
{vieweralsosee "[R] cpoisson postestimation" "mansection R cpoissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] cpoisson" "help cpoisson"}{...}
{viewerjumpto "Postestimation commands" "cpoisson postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "cpoisson_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "cpoisson postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "cpoisson postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "cpoisson postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[R] cpoisson postestimation} {hline 2}}Postestimation tools for
cpoisson{p_end}
{p2col:}({mansection R cpoissonpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation commands are also available:

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
{synopt:{helpb cpoisson_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb cpoisson postestimation##predict:predict}}predictions,
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

        {mansection R cpoissonpostestimationRemarksandexamples:Remarks and examples}

        {mansection R cpoissonpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin}
[{cmd:,} {it:statistic} {opt nooff:set}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt n}}number of events; the default{p_end}
{synopt :{opt ir}}incidence rate{p_end}
{synopt :{opt cm}}conditional mean, E(y | y > L), E(y | y < U), or
    E(y | L < y < U){p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt cpr(n)}}conditional probability Pr(y = n | y > L),
    Pr(y = n | y < U), Pr(y = n | L < y < U){p_end}
{synopt :{opt cpr(a,b)}}conditional probability Pr(a {ul:<} y {ul:<} b | y > L),
    Pr(a {ul:<} y {ul:<} b | y < U), or Pr(a {ul:<} y {ul:<} b | L < y < U){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect to
xb{p_end}
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
{opt n}, the default, calculates the predicted number of events, which is
exp(xb) if neither {opt offset()} nor {opt exposure()} was
specified when the model was fit;{break}
exp(xb + offset) if {opt offset()} was specified; or{break}
exp(xb)*exposure if {opt exposure()} was specified.

{phang}
{opt ir} calculates the incidence rate exp(xb), which is the predicted number
of events when exposure is 1.  This is equivalent to specifying
both the {opt n} and the {opt nooffset} options.

{phang}
{cmd:cm} calculates the conditional mean,
E(y | Omega) =  E(y)/Pr(Omega)
where Omega represents y >L for a left-censored model, y < U for
a right-censored model, and L < y < U for an interval-censored model.
L is the left-censoring point found in {cmd:e(llopt)}, and U is the
right-censoring point found in {cmd:e(ulopt)}.

{phang}
{opt pr(n)} calculates the probability Pr(y = n), where n is a
nonnegative integer that may be specified as a number or a variable.

INCLUDE help pr_uncond_opt

{phang}
{opt cpr(n)} calculates the conditional probability Pr(y = n | Omega),
where Omega represents y >L  for a left-censored
model, y < U for a right-censored model, and L < y < U for an
interval-censored model.  L is the left-censoring point found in
{cmd:e(llopt)}, and U is the right-censoring point found in {cmd:e(ulopt)}.
{it:n} is an integer in the noncensored range.

{phang}
{opt cpr(a,b)} calculates the conditional probability
Pr({it:a} {ul:<} y {ul:<} {it:b} | Omega), where Omega
represents y > L for a left-censored model, y < U for a right-censored
model, and L < y < U for an interval-censored model.  L is the
left-censoring point found in {cmd:e(llopt)}, and U is the right-censoring
point found in {cmd:e(ulopt)}.  {it:a} and {it:b} must fall in the
noncensored range if they are not missing.  A missing value in an observation
of the variable {it:a} causes a missing value in that observation for
{opt cpr(a,b)}.

{phang}
{opt xb} calculates the linear prediction, which is xb if neither
{cmd:offset()} nor {cmd:exposure()} was specified;
xb + offset if {cmd:offset()} was specified; or
xb + ln(exposure) if {cmd:exposure()} was specified;
see {helpb cpoisson_postestimation##nooffset:nooffset} below.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt score} calculates the equation-level score, the derivative of the log
likelihood with respect to the linear prediction.

{marker nooffset}{...}
{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the
calculations made by {cmd:predict} so that they ignore the offset or exposure
variable; the linear prediction is treated as xb rather than
{bind:xb + offset} or xb + ln(exposure). Specifying {cmd:predict} ...{cmd:,}
{cmd:nooffset} is equivalent to specifying {cmd:predict} ...{cmd:,}
{opt ir}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt n}}number of events; the default{p_end}
{synopt :{opt ir}}incidence rate{p_end}
{synopt :{opt cm}}conditional mean, E(y | y > L), E(y | y < U), or
    E(y | L < y < U){p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt cpr(n)}}conditional probability Pr(y = n | y > L),
    Pr(y = n | y < U), Pr(y = n | L < y < U){p_end}
{synopt :{opt cpr(a,b)}}conditional probability Pr(a {ul:<} y {ul:<} b | y > L),
    Pr(a {ul:<} y {ul:<} b | y < U), or Pr(a {ul:<} y {ul:<} b | L < y < U){p_end}
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
numbers of events, incidence rates, conditional means, probabilities, and
linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse trips}{p_end}
{phang2}{cmd:. cpoisson trips income children, ul(3)}{p_end}

{pstd}Estimate the number of trips to amusement parks with one child compared
with one additional child{p_end}
{phang2}{cmd:. margins, at(children = generate(children))}
                   {cmd:at(children = generate(children+1)) post}

{pstd}Compute the effect of having an additional child on uncensored trips
{p_end}
{phang2}{cmd:. contrast r._at, nowald}{p_end}
