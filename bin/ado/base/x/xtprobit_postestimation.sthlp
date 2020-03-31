{smcl}
{* *! version 1.2.7  19oct2017}{...}
{viewerdialog "predict (re)" "dialog xtprobit_re_p"}{...}
{viewerdialog "predict (pa)" "dialog xtprobit_pa_p"}{...}
{vieweralsosee "[XT] xtprobit postestimation" "mansection XT xtprobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtprobit" "help xtprobit"}{...}
{viewerjumpto "Postestimation commands" "xtprobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtprobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtprobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtprobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtprobit postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[XT] xtprobit postestimation} {hline 2}}Postestimation tools for xtprobit{p_end}
{p2col:}({mansection XT xtprobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtprobit}:

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
{synopt:{helpb xtprobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtprobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:estat ic} and {cmd:lrtest} are not appropriate after {cmd:xtprobit, pa}.{p_end}
{p 4 6 2}
+ {cmd:forecast} is not appropriate with {cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtprobitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
Random-effects model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
{it:{help xtprobit_postestimation##randomeffects:RE_statistic}} 
{opt nooff:set} ]


{phang}
Population-averaged model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
{it:{help xtprobit_postestimation##popaverage:PA_statistic}} 
{opt nooff:set} ]


{marker randomeffects}{...}
{synoptset 17 tabbed}{...}
{synopthdr :RE_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt pr}}marginal probability of a positive outcome{p_end}
{synopt :{opt pu0}}probability of a positive outcome{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}

{marker popaverage}{...}
{synoptset 17 tabbed}{...}
{synopthdr :PA_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mu}}probability of {depvar}; considers the {opt offset()}; the default{p_end}
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
{opt pr} calculates the probability of a positive outcome that is marginal
with respect to the random effect, which means that the probability is
calculated by integrating the prediction function with respect to the random
effect over its entire support.

{phang}
{opt pu0} calculates the probability of a positive outcome, assuming that the
random effect for that observation's panel is zero.  This probability
may not be similar to the proportion of observed outcomes in the group.

{phang}
{opt mu} and {opt rate} both calculate the predicted probability of {depvar}.
{opt mu} takes into account the {opt offset()}, and {opt rate} ignores those
adjustments.  {opt mu} and {opt rate} are equivalent if you did not specify
{opt offset()}.  {opt mu} is the default for the population-averaged model.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt score} calculates the equation-level score.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:xtprobit}.  It modifies the calculations made by {cmd:predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than xb + offset.


INCLUDE help syntax_margins

{phang}
Random-effects model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pr}}marginal probability of a positive outcome; the default{p_end}
{synopt :{opt pu0}}probability of a positive outcome{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
Population-averaged model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt mu}}probability of {depvar}; considers the {opt offset()}; the default{p_end}
{synopt :{opt rate}}probability of {depvar}{p_end}
{synopt :{opt xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt sc:ore}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Descriptions for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions and
probabilities.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse union}{p_end}

{pstd}Fit random-effects model{p_end}
{phang2}{cmd:. xtprobit union age grade south}{p_end}

{pstd}Calculate predicted probability of a positive outcome{p_end}
{phang2}{cmd:. predict prob, pu0}{p_end}

{pstd}Fit population-averaged model{p_end}
{phang2}{cmd:. xtprobit union age grade i.not_smsa south##c.year, pa}{p_end}

{pstd}Compute the average marginal effects from the fitted model on the
probability of being in a union{p_end}
{phang2}{cmd:. margins, dydx(*)}{p_end}
