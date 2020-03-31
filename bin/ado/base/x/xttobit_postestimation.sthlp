{smcl}
{* *! version 1.2.7  19oct2017}{...}
{viewerdialog predict "dialog xttobit_p"}{...}
{vieweralsosee "[XT] xttobit postestimation" "mansection XT xttobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xttobit" "help xttobit"}{...}
{viewerjumpto "Postestimation commands" "xttobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xttobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xttobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xttobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xttobit postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[XT] xttobit postestimation} {hline 2}}Postestimation tools for xttobit{p_end}
{p2col:}({mansection XT xttobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xttobit}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb xttobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xttobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xttobitpostestimationRemarksandexamples:Remarks and examples}

        {mansection XT xttobitpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic} {opt nooff:set}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt stdf}}standard error of the linear forecast{p_end}
{synopt :{opt pr(a,b)}}Pr({it:a} < y < {it:b}), marginal with respect to the random effect{p_end}
{synopt :{opt e(a,b)}}{it:E}(y | {it:a} < y < {it:b}), marginal with respect to the random effect{p_end}
{synopt :{opt ys:tar(a,b)}}{it:E}(y*), y*=max{a,min(y_j,b)}, marginal with respect to the random effect{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample

INCLUDE help whereab


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as linear
predictions, standard errors, probabilities, and expected values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:xb}, the default, calculates the linear prediction xb using the estimated
fixed effects (coefficients) in the model.  This is equivalent to fixing all
random effects in the model to their theoretical (prior) mean value of zero.

{phang}
{opt stdp} calculates the standard error of the linear prediction.
It can be thought of as the standard error of the predicted expected value or
mean for the observation's covariate pattern.  The standard error of the
prediction is also referred to as the standard error of the fitted value.

{phang}
{opt stdf} calculates the standard error of the linear forecast.
This is the standard error of the point prediction for 1 observation.  It is
commonly referred to as the standard error of the future or forecast value.  By
construction, the standard errors produced by {cmd:stdf} are always larger than
those produced by {cmd:stdp}; see
{mansection R regressMethodsandformulas:{it:Methods and formulas}} in
{bf:[R] regress}.

{phang}
{opt pr(a,b)} calculates estimates of
{bind:Pr({it:a} < y < {it:b})}, which is the probability
that y would be observed in the interval (a,b), given the current values of
the predictors, {bf:x}_{it:it}.
The predictions are calculated marginally with respect to the random effect.
That is, the random effect is integrated out of the prediction function.
In the discussion that follows, these two conditions are implied.

{pmore}
{it:a} and {it:b} may be specified as numbers or variable names;{break}
{cmd:pr(20,30)} calculates {bind:Pr(20 < y < 30)};{break}
{cmd:pr(lb,ub)} calculates {bind:Pr(lb < y < ub)}; and{break}
{cmd:pr(20,ub)} calculates {bind:Pr(20 < y < ub)}.

{pmore}
{it:a} missing {bind:({it:a} {ul:>} .)} means minus infinity;
{cmd:pr(.,30)} calculates {bind:Pr(y < 30)} and
{cmd:pr(lb,30)} calculates {bind:Pr(y < 30)} in observations for which
{bind:lb {ul:>} .} (and calculates {bind:Pr(lb < y < 30)} elsewhere).

{pmore}
{it:b} missing {bind:({it:b} {ul:>} .)} means plus infinity;
{cmd:pr(20,.)} calculates {bind:Pr(y > 20)} and
{cmd:pr(20,ub)} calculates {bind:Pr(y > 20)} in observations for which
{bind:ub {ul:>} .} (and calculates {bind:Pr(20 < y < ub)} elsewhere).

{phang}
{opt e(a,b)} calculates estimates of {bind:{it:E}(y | {it:a} < y < {it:b})},
which is the expected value of y conditional on y being
in the interval (a,b), meaning that y is truncated.  {it:a} and {it:b} are
specified as they are for {cmd:pr()}.
The predictions are calculated marginally with respect to the random effect.
That is, the random effect is integrated out of the prediction function.

{phang}
{opt ystar(a,b)} calculates estimates of {it:E}(Y*), where {bind:Y* = {it:a}}
if {bind:y {ul:<} {it:a}}, {bind:Y* = {it:b}}
if {bind:y {ul:>} {it:b}}, and {bind:Y* = y} otherwise, meaning that
Y* is the censored version of y.  {it:a} and {it:b} are specified as they are
for {cmd:pr()}.
The predictions are calculated marginally with respect to the random effect.
That is, the random effect is integrated out of the prediction function.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:xttobit}.  It modifies the calculations made by {cmd:predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than xb + offset.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt pr(a,b)}}Pr({it:a} < y < {it:b}), marginal with respect to the random effect{p_end}
{synopt :{opt e(a,b)}}{it:E}(y | {it:a} < y < {it:b}), marginal with respect to the random effect{p_end}
{synopt :{opt ys:tar(a,b)}}{it:E}(y*), y*=max{a,min(y_j,b)}, marginal with respect to the random effect{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdf}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions,
probabilities, and expected values.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork3}{p_end}
{phang2}{cmd:. xtset idcode}{p_end}
{phang2}{cmd:. xttobit ln_wage i.union age grade not_smsa south##c.year, ul(1.9)}
{p_end}

{pstd}Average marginal effect of {cmd:age} on expected log wage, conditional
on log wage being less than 1.9{p_end}
{phang2}{cmd:. margins, predict(e(., 1.9)) dydx(age)}{p_end}
