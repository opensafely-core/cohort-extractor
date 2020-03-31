{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog "predict (re)" "dialog xtcloglog_re_p"}{...}
{viewerdialog "predict (pa)" "dialog xtcloglog_pa_p"}{...}
{vieweralsosee "[XT] xtcloglog postestimation" "mansection XT xtcloglogpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtcloglog" "help xtcloglog"}{...}
{viewerjumpto "Postestimation commands" "xtcloglog postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtcloglog_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtcloglog postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtcloglog postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "xtcloglog postestimation##examples"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[XT] xtcloglog postestimation} {hline 2}}Postestimation tools for xtcloglog{p_end}
{p2col:}({mansection XT xtcloglogpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:xtcloglog}:

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
INCLUDE help post_lrtest
{synopt:{helpb xtcloglog_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb xtcloglog postestimation##predict:predict}}predictions, 
residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{phang}
* {cmd:estat ic} is not appropriate after {cmd:xtcloglog, pa}.{p_end}
{phang}
+ {cmd:forecast} is not appropriate with {cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtcloglogpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
Random-effects (RE) model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:{help xtcloglog_postestimation##randomeffects:RE_statistic}}
{opt nooff:set} ]


{phang}
Population-averaged (PA) model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} 
[{cmd:,} {it:{help xtcloglog_postestimation##populationaveraged:PA_statistic}}
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


{marker populationaveraged}{...}
{synoptset 17 tabbed}{...}
{synopthdr :PA_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mu}}predicted probability of {depvar}; considers the
             {opt offset()}; the default{p_end}
{synopt :{opt rate}}predicted probability of {depvar}{p_end}
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
probabilities, linear predictions, standard errors, and equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang} 
{opt xb} calculates the linear prediction, which is xb if {cmd:offset()}
was not specified when the model was fit and xb + offset if {cmd:offset()}
was specified.  This is the default for the random-effects model.

{phang}
{opt pr} calculates the probability of a positive outcome that is marginal
with respect to the random effect, which means that the probability is
calculated by integrating the prediction function with respect to the random
effect over its entire support.


{phang}
{opt pu0} calculates the probability of a positive outcome, assuming that the
random effect for that observation's panel is zero.  This may not be
similar to the proportion of observed outcomes in the group.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt mu} and {opt rate} both calculate the predicted probability of {depvar}.
{opt mu} takes into account the {opt offset()}.  {opt rate} ignores those
adjustments.  {opt mu} and {opt rate} are equivalent if you did not specify
{opt offset()}.  {opt mu} is the default for the population-averaged model.

{phang}
{opt score} calculates the equation-level score.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:xtcloglog}.  It modifies the calculations made by {cmd:predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than xb + offset.


INCLUDE help syntax_margins

{phang}
Random-effects (RE) model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt pr}}marginal probability of a positive outcome; the default{p_end}
{synopt :{opt pu0}}probability of a positive outcome{p_end}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
Population-averaged (PA) model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt mu}}predicted probability of {depvar}; considers the
             {opt offset()}; the default{p_end}
{synopt :{opt rate}}predicted probability of {depvar}{p_end}
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
{cmd:margins} estimates margins of responses for
probabilities and linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse union}{p_end}

{pstd}Fit random-effects cloglog model{p_end}
{phang2}{cmd:. xtcloglog union age grade south##c.year}{p_end}

{pstd}Linear prediction{p_end}
{phang2}{cmd:. predict xt}

{pstd}Probability of a positive outcome{p_end}
{phang2}{cmd:. predict prob, pu0}

{pstd}Fit population-averaged cloglog model{p_end}
{phang2}{cmd:. xtcloglog union age grade south##c.year, pa}{p_end}

{pstd}Predicted probability of {cmd:union}{p_end}
{phang2}{cmd:. predict probpa}

{pstd}Average effect each regressor has on probability of a positive response
{p_end}
{phang2}{cmd:. margins, dydx(*)}{p_end}
