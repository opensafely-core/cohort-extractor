{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog "predict (re/fe)" "dialog xtnbreg_refe_p"}{...}
{viewerdialog "predict (pa)" "dialog xtnbreg_pa_p"}{...}
{vieweralsosee "[XT] xtnbreg postestimation" "mansection XT xtnbregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtnbreg" "help xtnbreg"}{...}
{viewerjumpto "Postestimation commands" "xtnbreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtnbreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtnbreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtnbreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtnbreg postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[XT] xtnbreg postestimation} {hline 2}}Postestimation tools
for xtnbreg{p_end}
{p2col:}({mansection XT xtnbregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtnbreg}:

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
{synopt:{helpb xtnbreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtnbreg postestimation##predict:predict}}predictions,
residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estat ic} and {cmd:lrtest} are not appropriate after {cmd: xtnbreg, pa}.{p_end}
{p 4 6 2}
+ {cmd:forecast} is not appropriate with {cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtnbregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
Random-effects (RE) and conditional fixed-effects (FE) overdispersion models

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,}
{it:{help xtnbreg_postestimation##randomandfixed:RE/FE_statistic}}
{opt nooff:set} ]

{phang}
Population-averaged (PA) model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,}
{it:{help xtnbreg_postestimation##popaverage:PA_statistic}}
{opt nooff:set} ]

{marker randomandfixed}{...}
{synoptset 17 tabbed}{...}
{synopthdr :RE/FE_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt nu0}}predicted number of events; assumes fixed or
random effect is zero{p_end}
{synopt :{opt iru0}}predicted incidence rate; assumes fixed or
random effect is zero{p_end}
{synopt :{opt pr0(n)}}probability Pr(y = n) assuming the
   random effect is zero; only allowed after {cmd:xtnbreg, re}{p_end}
{synopt :{opt pr0(a,b)}}probability Pr(a {ul:<} y {ul:<} b)
   assuming the random effect is zero; only allowed after {cmd:xtnbreg, re}
   {p_end}
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
{opt nu0} calculates the predicted number of events, assuming a zero
random or fixed effect.

{phang}
{opt iru0} calculates the predicted incidence rate, assuming a zero
random or fixed effect.

{phang}
{opt pr0(n)} calculates the probability Pr(y = n) assuming the
random effect is zero, where n is a nonnegative integer that may be specified
as a number or a variable (only allowed after {cmd:xtnbreg, re}).

{phang}
{opt pr0(a,b)} calculates the probability
Pr(a {ul:<} y {ul:<} b) assuming the random effect is zero, where
a and b are nonnegative integers that may be specified as numbers or variables
(only allowed after {cmd:xtnbreg, re});

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
{opt score} calculates the equation-level score.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:xtnbreg}.  It modifies the calculations made by {cmd:predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than xb + offset.


INCLUDE help syntax_margins

{phang}
Random-effects (RE) and conditional fixed-effects (FE) overdispersion models

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt nu0}}predicted number of events; assumes fixed or
random effect is zero{p_end}
{synopt :{opt iru0}}predicted incidence rate; assumes fixed or
random effect is zero{p_end}
{synopt :{opt pr0(n)}}probability Pr(y = n) assuming the
   random effect is zero; only allowed after {cmd:xtnbreg, re}{p_end}
{synopt :{opt pr0(a,b)}}probability Pr(a {ul:<} y {ul:<} b)
   assuming the random effect is zero; only allowed after {cmd:xtnbreg, re}
   {p_end}
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
{phang2}{cmd:. webuse airacc}{p_end}
{phang2}{cmd:. xtset airline}{p_end}

{pstd}Fit random-effects model{p_end}
{phang2}{cmd:. xtnbreg i_cnt inprog, exposure(pmiles)}{p_end}

{pstd}Compute predicted number of injury incidents, assuming random effect is
zero{p_end}
{phang2}{cmd:. predict cnt, nu0}{p_end}

{pstd}Compute probability of zero injury accidents, assuming random effect is
zero{p_end}
{phang2}{cmd:. predict p, pr0(0)}{p_end}

{pstd}Compute probability of 5 or fewer accidents, assuming random effect is
zero{p_end}
{phang2}{cmd:. predict p2, pr0(0,5)}{p_end}

{pstd}Store random-effects estimation results{p_end}
{phang2}{cmd:. estimates store re}{p_end}

{pstd}Fit fixed-effects model{p_end}
{phang2}{cmd:. xtnbreg i_cnt inprog, exposure(pmiles) fe}{p_end}

{pstd}Store fixed-effects estimation results{p_end}
{phang2}{cmd:. estimates store fe}{p_end}

{pstd}Display a table of the random-effects and fixed-effects models with the
AIC statistic for both models for comparison{p_end}
{phang2}{cmd:. estimates table re fe, stats(aic)}{p_end}

{pstd}Fit population-averaged model{p_end}
{phang2}{cmd:. xtnbreg i_cnt inprog, exposure(pmiles) pa}{p_end}

{pstd}Compute predicted number of injury incidents taking into account
passenger miles{p_end}
{phang2}{cmd:. predict mean}{p_end}
