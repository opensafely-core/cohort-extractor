{smcl}
{* *! version 1.2.6  20oct2017}{...}
{viewerdialog predict "dialog poisso_p"}{...}
{viewerdialog estat "dialog poisson_estat"}{...}
{vieweralsosee "[R] poisson postestimation" "mansection R poissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] poisson" "help poisson"}{...}
{viewerjumpto "Postestimation commands" "poisson postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "poisson_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "poisson postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "poisson postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "poisson postestimation##syntax_estat_gof"}{...}
{viewerjumpto "Examples" "poisson postestimation##examples"}{...}
{viewerjumpto "Stored results" "poisson postestimation##results"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] poisson postestimation} {hline 2}}Postestimation tools for
poisson{p_end}
{p2col:}({mansection R poissonpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation command is of special interest after
{cmd:poisson}:

{synoptset 19}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb poisson postestimation##estatgof:estat gof}}goodness-of-fit
test{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{cmd:estat gof} is not appropriate after the {cmd:svy} prefix.
{p_end}

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
INCLUDE help post_linktest
INCLUDE help post_lrtest_star
{synopt:{helpb poisson_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb poisson postestimation##predict:predict}}predictions,
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
{cmd:svy} estimation results.  {cmd:forecast} is also not appropriate with
{cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R poissonpostestimationRemarksandexamples:Remarks and examples}

        {mansection R poissonpostestimationMethodsandformulas:Methods and formulas}

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
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
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
numbers of events, incidence rates, probabilities, linear predictions,
standard errors, and equation-level scores.


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
of events when exposure is 1.  Specifying {opt ir} is equivalent to specifying
{opt n} when neither {opt offset()} nor {opt exposure()} was specified when the
model was fit.

{phang}
{opt pr(n)} calculates the probability Pr(y = n), where n is a
nonnegative integer that may be specified as a number or a variable.

INCLUDE help pr_uncond_opt

{phang}
{opt xb} calculates the linear prediction, which is xb if neither
{cmd:offset()} nor {cmd:exposure()} was specified;
xb + offset if {cmd:offset()} was specified; or
xb + ln(exposure) if {cmd:exposure()} was specified;
see {helpb poisson_postestimation##nooffset:nooffset} below.

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
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
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
numbers of events, incidence rates, probabilities, and linear predictions.


{marker syntax_estat_gof}{...}
{marker estatgof}{...}
{title:Syntax for estat}

{p 8 14 2}
{cmd:estat gof}


INCLUDE help menu_estat


{marker des_estat}{...}
{title:Description for estat}

{pstd}
{cmd:estat gof} performs a goodness-of-fit test of the model.  Both the
deviance statistic and the Pearson statistic are reported.  If the tests are
significant, the Poisson regression model is inappropriate.  Then you could try
a negative binomial model; see {helpb nbreg:[R] nbreg}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse dollhill3}{p_end}
{phang2}{cmd:. poisson deaths i.smokes i.agecat, exp(pyears)}{p_end}

{pstd}Predict incidence rate{p_end}
{phang2}{cmd:. predict deathrate, ir}

{pstd}Estimate incidence rates and standard errors{p_end}
{phang2}{cmd:. margins agecat#smokes, predict(ir)}

{pstd}Plot estimates and confidence intervals{p_end}
{phang2}{cmd:. marginsplot}

{pstd}Goodness-of-fit tests{p_end}
{phang2}{cmd:. estat gof}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat gof} after {cmd:poisson} stores the following in {cmd:r()}:
 
{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(df)}}degrees of freedom (Pearson and deviance){p_end}
{synopt:{cmd:r(chi2_p)}}chi-squared (Pearson){p_end}
{synopt:{cmd:r(chi2_d)}}chi-squared (deviance){p_end}
{synopt:{cmd:r(p_p)}}p-value for chi-squared test (Pearson){p_end}
{synopt:{cmd:r(p_d)}}p-value for chi-squared test (deviance){p_end}
{p2colreset}{...}
