{smcl}
{* *! version 1.0.6  15oct2018}{...}
{viewerdialog predict "dialog heckpoisson_p"}{...}
{vieweralsosee "[R] heckpoisson postestimation" "mansection R heckpoissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] heckpoisson" "help heckpoisson"}{...}
{viewerjumpto "Postestimation commands" "heckpoisson postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "heckpoisson_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "heckpoisson postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "heckpoisson postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "heckpoisson postestimation##examples"}{...}
{p2colset 1 35 37 2}{...}
{p2col:{bf:[R] heckpoisson postestimation} {hline 2}}Postestimation tools
for heckpoisson{p_end}
{p2col:}({mansection R heckpoissonpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:heckpoisson}:

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
{synopt:{helpb heckpoisson_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb heckpoisson postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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

        {mansection R heckpoissonpostestimationRemarksandexamples:Remarks and examples}

        {mansection R heckpoissonpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} {opt nooff:set}]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvarlist:newvarlist}}{c )-}
{ifin}{cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt n}}number of events; the default{p_end}
{synopt :{opt ir}}incidence rate{p_end}
{synopt :{opt nc:ond}}predicted number of events conditional on y_j being
observed{p_end}
{synopt :{opt pr(n)}}Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt ps:el}}Pr(y observed){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt xbs:el}}linear prediction for selection equation{p_end}
{synoptline}
{p2colreset}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates new variables containing predictions such as
number of events, incidence rates, conditional predicted number of events,
probabilities, linear predictions, and equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}
{phang}
{opt n}, the default, calculates the predicted number of events, which is
exp(xb) if neither {opt offset()} nor {opt exposure()} was
specified when the model was fit; is{break}
exp(xb + offset) if {opt offset()} was specified; or is{break}
exp(xb)*exposure if {opt exposure()} was specified.

{phang}
{opt ir} calculates the incidence rate exp(xb), which is the predicted number
of events when exposure is 1.  Specifying {opt ir} is equivalent to specifying
{opt n} when neither {opt offset()} nor {opt exposure()} was specified when
the model was fit.

{phang}
{opt ncond} calculates the predicted number of events conditional on y_j
being observed.

{phang}
{opt pr(n)} calculates the probability Pr(y = n), where n is a
nonnegative integer that may be specified as a number or a variable.

INCLUDE help pr_uncond_opt

{phang}
{opt psel} calculates the probability of selection (or being observed).

{phang}
{opt xb} calculates the linear prediction for the dependent count variable,
which is xb if neither {cmd:offset()} nor {cmd:exposure()} was specified;
xb + offset if {cmd:offset()} was specified; or
xb + ln(exposure) if {cmd:exposure()} was specified.

{phang}
{opt xbsel} calculates the linear prediction for the selection equation.

{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the calculations made by
{cmd:predict} so that they ignore the offset or exposure variable; the linear
prediction is treated as xb rather than as xb + offset or xb + ln(exposure).

{phang}
{opt scores} calculates equation-level score variables.{p_end}

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the selection equation.

{pmore}
The third new variable will contain the derivative of the log likelihood with
respect to the third equation ({hi:athrho}).

{pmore}
The fourth new variable will contain the derivative of the log likelihood with
respect to the fourth equation ({hi:lnsigma}).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt n}}number of events; the default{p_end}
{synopt :{opt ir}}incidence rate{p_end}
{synopt :{opt nc:ond}}predicted number of events conditional on y_j being
observed{p_end}
{synopt :{opt pr(n)}}Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt ps:el}}Pr(y observed){p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt xbs:elect}}linear prediction for selection equation{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for number of events, incidence
rates, conditional predicted number of events, probabilities, and linear
predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse patent}

{pstd}Fit Poisson model with endogenous sample selection{p_end}
{phang2}{cmd:. heckpoisson npatents expenditure i.tech, select(applied = expenditure size i.tech)}

{pstd}Estimate effect of an increase of a million dollars in R&D expenditures
({cmd:expenditure}) on the number of patents ({cmd:npatents}) for firms in the
information technology and non-IT sectors ({cmd:tech}){p_end}
{phang2}{cmd:. margins i.tech, at(expenditure = generate(expenditure))}
        {cmd:at(expenditure = generate(expenditure+1)) post}

{pstd}Obtain an estimate of the difference in the differences for the sectors
and a test of its significance{p_end}
{phang2}{cmd:. lincom (_b[2._at#1.tech] - _b[1._at#1.tech]) -}
        {cmd:(_b[2._at#0.tech] - _b[1._at#0.tech])}

{pstd}Calculate the number of events{p_end}
{phang2}{cmd:. predict p}{p_end}
