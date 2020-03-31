{smcl}
{* *! version 1.2.8  21may2018}{...}
{viewerdialog "predict (re)" "dialog xtlogit_re_p"}{...}
{viewerdialog "predict (fe)" "dialog xtlogit_fe_p"}{...}
{viewerdialog "predict (pa)" "dialog xtlogit_pa_p"}{...}
{vieweralsosee "[XT] xtlogit postestimation" "mansection XT xtlogitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtlogit" "help xtlogit"}{...}
{viewerjumpto "Postestimation commands" "xtlogit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtlogit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtlogit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtlogit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtlogit postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[XT] xtlogit postestimation} {hline 2}}Postestimation tools for xtlogit{p_end}
{p2col:}({mansection XT xtlogitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtlogit}:

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
{synopt:{helpb xtlogit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtlogit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estat ic} and {cmd:lrtest} are not appropriate after {cmd:xtlogit, pa}.{p_end}
{p 4 6 2}
+ {cmd:forecast} is not appropriate with {cmd:mi} estimation results or
after {cmd:xtlogit, fe}.{p_end}
{phang}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtlogitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
Random-effects model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
{it:{help xtlogit_postestimation##randomeffects:RE_statistic}} {opt nooff:set}]

{phang}
Fixed-effects model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
{it:{help xtlogit_postestimation##fixedeffects:FE_statistic}} {opt nooff:set}]

{phang}
Population-averaged model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
{it:{help xtlogit_postestimation##popaverage:PA_statistic}} {opt nooff:set}]

{marker randomeffects}{...}
{synoptset 17 tabbed}{...}
{synopthdr :RE_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt pr}}marginal probability of a positive outcome{p_end}
{synopt :{opt pu0}}probability of a positive outcome assuming that the random effect is zero{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}

{marker fixedeffects}{...}
{synoptset 17 tabbed}{...}
{synopthdr :FE_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt pc1}}probability of a positive outcome conditional on one positive outcome within group; the default{p_end}
{synopt :{opt pu0}}probability of a positive outcome assuming that the fixed effect is zero{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
The predicted probability for the fixed-effects model is conditional
on there being only one outcome per group.  See {helpb clogit:[R] clogit} for
details.

{marker popaverage}{...}
{synoptset 17 tabbed}{...}
{synopthdr :PA_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mu}}probability of {depvar}; considers the {opt offset()}{p_end}
{synopt :{opt rate}}probability of {depvar}{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt sc:ore}}first derivative of the log likelihood with respect to xb{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, probabilities, standard errors, and equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb} calculates the linear prediction.  This is the default for the
random-effects model.

{phang}
{opt pc1} calculates the predicted probability of a positive outcome conditional
on one positive outcome within group.  This is the default for the
fixed-effects model.

{phang}
{opt mu} and {opt rate} both calculate the predicted probability of {depvar}.
{opt mu} takes into account the {opt offset()}, and {opt rate} ignores those
adjustments.  {opt mu} and {cmd:rate} are equivalent if you did not specify
{opt offset()}.  {opt mu} is the default for the population-averaged model.

{phang}
{opt pr} calculates the probability of a positive outcome that is marginal
with respect to the random effect, which means that the probability is
calculated by integrating the prediction function with respect to the random
effect over its entire support.

{phang}
{opt pu0} calculates the probability of a positive outcome, assuming that the
fixed or random effect for that observation's panel is zero.  This
may not be similar to the proportion of observed outcomes in the group.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt score} calculates the equation-level score.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:xtlogit}.  This option modifies the calculations made by {cmd:predict} so
that they ignore the offset variable; the linear prediction is treated as xb
rather than xb + offset.


INCLUDE help syntax_margins

{phang}
Random-effects model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pr}}marginal probability of a positive outcome; the default{p_end}
{synopt :{opt pu0}}probability of a positive outcome assuming that the random effect is zero{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
Fixed-effects model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pu0}}probability of a positive outcome assuming that the fixed effect is zero; the default{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt pc1}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
Population-averaged model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt mu}}probability of {depvar}; considers the {opt offset()}{p_end}
{synopt :{opt rate}}probability of {depvar}{p_end}
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
{cmd:margins} estimates margins of response for linear predictions and
probabilities.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse union}{p_end}

{pstd}Fit random-effects model{p_end}
{phang2}{cmd:. xtlogit union age grade i.south}{p_end}

{pstd}Compute probability of positive outcome, assuming that random effect is zero
{p_end}
{phang2}{cmd:. predict prob, pu0}

{pstd}Fit population-averaged model{p_end}
{phang2}{cmd:. xtlogit union age grade i.south, pa}{p_end}

{pstd}Compute predicted probability of {cmd:union}{p_end}
{phang2}{cmd:. predict unionpr, mu}{p_end}

{pstd}Compute average marginal effect of {cmd:age} on probability of
{cmd:union}{p_end}
{phang2}{cmd:. margins, dydx(age)}{p_end}
