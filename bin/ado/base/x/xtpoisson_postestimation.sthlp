{smcl}
{* *! version 1.2.7  19oct2017}{...}
{viewerdialog "predict (re/fe)" "dialog xtpoisson_refe_p"}{...}
{viewerdialog "predict (pa)" "dialog xtpoisson_pa_p"}{...}
{vieweralsosee "[XT] xtpoisson postestimation" "mansection XT xtpoissonpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtpoisson" "help xtpoisson"}{...}
{viewerjumpto "Postestimation commands" "xtpoisson postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtpoisson_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtpoisson postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtpoisson postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtpoisson postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[XT] xtpoisson postestimation} {hline 2}}Postestimation tools
for xtpoisson{p_end}
{p2col:}({mansection XT xtpoissonpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtpoisson}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent :* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast_star2
INCLUDE help post_hausman
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb xtpoisson_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtpoisson postestimation##predict:predict}}predictions,
residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estat ic} and {cmd:lrtest} are not appropriate after {cmd:xtpoisson, pa}.{p_end}
{p 4 6 2}
+ {cmd:forecast} is not appropriate with {cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtpoissonpostestimationRemarksandexamples:Remarks and examples}

        {mansection XT xtpoissonpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
Random-effects (RE) models

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,}
{it:{help xtpoisson_postestimation##random:RE_statistic}}
{opt nooff:set} ]


{phang}
Fixed-effects (FE) model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,}
{it:{help xtpoisson_postestimation##fixed:FE_statistic}}
{opt nooff:set} ]


{phang}
Population-averaged (PA) model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,}
{it:{help xtpoisson_postestimation##popaverage:PA_statistic}}
{opt nooff:set} ]


{marker random}{...}
{synoptset 17 tabbed}{...}
{synopthdr :RE_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt n}}predicted number of events marginal with respect to the
random effect; only allowed after {cmd:xtpoisson,} {cmd:re normal}{p_end}
{synopt :{opt nu0}}predicted number of events assuming the random effect is zero{p_end}
{synopt :{opt iru0}}predicted incidence rate assuming the random effect is zero{p_end}
{synopt :{opt pr0(n)}}probability Pr(y = n) assuming the random effect is zero{p_end}
{synopt :{opt pr0(a,b)}}probability Pr(a {ul:<} y {ul:<} b) assuming the random effect is zero{p_end}
{synoptline}
{p2colreset}{...}

{marker fixed}{...}
{synoptset 17 tabbed}{...}
{synopthdr :FE_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt nu0}}predicted number of events assuming the fixed effect is zero{p_end}
{synopt :{opt iru0}}predicted incidence rate assuming the fixed effect is zero{p_end}
{synoptline}
{p2colreset}{...}

{marker popaverage}{...}
{synoptset 17 tabbed}{...}
{synopthdr :PA_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mu}}predicted number of events; considers
the {opt offset()}; the default{p_end}
{synopt :{opt rate}}predicted number of events{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect
to xb{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, numbers of events, incidence rates,
probabilities, and equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb} calculates the linear prediction.  This is the default for the
random-effects and fixed-effects models.

{phang}
{opt mu} and {opt rate} both calculate the predicted number of events.
{opt mu} takes into account the {opt offset()}, and {opt rate} ignores those
adjustments.  {opt mu} and {opt rate} are equivalent if you did not specify
{opt offset()}.  {opt mu} is the default for the population-averaged model.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt n} calculates the predicted number of events marginally with respect to
the random effect, which means that the statistic is calculated by integrating
the prediction function with respect to the random effect over its entire
support.  This option is only allowed after {cmd:xtpoisson,} {cmd:re}
{cmd:normal}.                            

{phang}
{opt nu0} calculates the predicted number of events assuming a zero
random or fixed effect.

{phang}
{opt iru0} calculates the predicted incidence rate assuming a zero
random or fixed effect.

{phang}
{opt pr0(n)} calculates the probability Pr(y = n) assuming the random
effect is zero, where n is a nonnegative integer that may be specified
as a number or a variable (only allowed after {cmd:xtpoisson, re}).

{phang}
{opt pr0(a,b)} calculates the probability
Pr(a {ul:<} y {ul:<} b) assuming the random effect is zero, where
a and b are nonnegative integers that may be specified as numbers or variables
(only allowed after {cmd:xtpoisson, re});

{pmore}
b missing {bind:(b {ul:>} .)} means plus infinity;{break}
{cmd:pr0(20,.)}
calculates {bind:Pr( y {ul:>} 20)}; {break}
{cmd:pr0(20,}b{cmd:)} calculates {bind:Pr( y {ul:>} 20)} in
observations for which {bind:b {ul:>} .}{break}
and calculates {bind:Pr(20 {ul:<} y {ul:<} b)} elsewhere.

{pmore}
{cmd:pr0(.,}{it:b}{cmd:)} produces a syntax error.  A missing value in an
observation on the variable {it:a} causes a missing value in that
observation for {opt pr0(a,b)}.

{phang}
{opt pr(n)} calculates the probability Pr(y = n), where n is a
nonnegative integer that may be specified as a number or a variable
(only allowed after {cmd:xtpoisson, pa}).

{phang}
{opt pr(a,b)} calculates the probability Pr(a {ul:<} y {ul:<} b) (only
allowed after {cmd:xtpoisson, pa}).  The syntax for this option is analogous
to that used with {opt pr0(a,b)}.

{phang}
{opt score} calculates the equation-level score.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:xtpoisson}.  It modifies the calculations made by {cmd:predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than xb + offset.


INCLUDE help syntax_margins

{phang}
Random-effects (RE) model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default after {cmd:xtpoisson, re}{p_end}
{synopt :{opt n}}predicted number of events marginal with respect to the
random effect; the default after and only allowed after {cmd:xtpoisson,} {cmd:re normal}{p_end}
{synopt :{opt nu0}}predicted number of events assuming the random effect is zero{p_end}
{synopt :{opt iru0}}predicted incidence rate assuming the random effect is zero{p_end}
{synopt :{opt pr0(n)}}probability Pr(y = n) assuming the random effect is zero{p_end}
{synopt :{opt pr0(a,b)}}probability Pr(a {ul:<} y {ul:<} b) assuming the random effect is zero{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
Fixed-effects (FE) model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt nu0}}predicted number of events assuming the fixed effect is zero{p_end}
{synopt :{opt iru0}}predicted incidence rate assuming the fixed effect is zero{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
Population-averaged (PA) model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt mu}}predicted number of events; considers
the {opt offset()}; the default{p_end}
{synopt :{opt rate}}predicted number of events{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
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
linear predictions, numbers of events, incidence rates, and probabilities.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse ships}{p_end}
{phang2}{cmd:. xtset ship}{p_end}

{pstd}Fit random-effects model{p_end}
{phang2}{cmd:. xtpoisson accident op_75_79 co_65_69 co_70_74 co_75_79,}
             {cmd:exp(service)}{p_end}

{pstd}Compute predicted number of accidents assuming random effect
is zero{p_end}
{phang2}{cmd:. predict cnt, nu0}

{pstd}Compute probability of no accidents assuming random effect
is zero{p_end}
{phang2}{cmd:. predict p, pr0(0) }

{pstd}Compute probability of 5 or more accidents assuming random effect
is zero{p_end}
{phang2}{cmd:. predict p2, pr0(5,.) }

{pstd}Fit population-averaged model with robust standard errors{p_end}
{phang2}{cmd:. xtpoisson accident op_75_79 co_65_69 co_70_74 co_75_79,}
             {cmd:exp(service) pa vce(robust)}{p_end}

{pstd}Compute predicted number of accidents taking into account months of
service{p_end}
{phang2}{cmd:. predict mean, mu}

{pstd}Fit random-effects model{p_end}
{phang2}{cmd:. xtpoisson accident op_75_79 co_65_69 co_70_74 co_75_79,}
               {cmd:exp(service)}{p_end}

{pstd}Save the random-effects results{p_end}
{phang2}{cmd:. estimates store re}

{pstd}Fit fixed-effects model{p_end}
{phang2}{cmd:. xtpoisson accident op_75_79 co_65_69 co_70_74 co_75_79,}
             {cmd:exp(service) fe}

{pstd}Save the fixed-effects results{p_end}
{phang2}{cmd:. estimates store fe}

{pstd}Perform Hausman test comparing fixed-effects estimates with
random-effects estimates{p_end}
{phang2}{cmd:. hausman fe re}

{pstd}Replay random-effects model estimation results{p_end}
{phang2}{cmd:. estimates replay re}

{pstd}Compute marginal effects of predicted number of events for
random-effects model{p_end}
{phang2}{cmd:. estimates restore re}{p_end}
{phang2}{cmd:. margins, predict(nu0)}{p_end}
