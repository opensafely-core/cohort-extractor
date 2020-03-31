{smcl}
{* *! version 1.3.7  19oct2017}{...}
{viewerdialog "predict (re/be/fe/mle)" "dialog xtrefe_p"}{...}
{viewerdialog "predict (pa)" "dialog xtreg_pa_p"}{...}
{viewerdialog xttest0 "dialog xttest0"}{...}
{vieweralsosee "[XT] xtreg postestimation" "mansection XT xtregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtreg" "help xtreg"}{...}
{viewerjumpto "Postestimation commands" "xtreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtreg postestimation##syntax_margins"}{...}
{viewerjumpto "xttest0" "xtreg postestimation##syntax_xttest0"}{...}
{viewerjumpto "Examples" "xtreg postestimation##examples"}{...}
{viewerjumpto "Reference" "xtreg postestimation##reference"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[XT] xtreg postestimation} {hline 2}}Postestimation tools for xtreg{p_end}
{p2col:}({mansection XT xtregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:xtreg}:

{synoptset 19}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{cmd:{helpb xtreg_postestimation##xttest0:xttest0}}}Breusch and Pagan LM test for random effects{p_end}
{synoptline}
{p2colreset}{...}

{phang}
The following standard postestimation commands are also available:

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
{synopt:{helpb xtreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb xtreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{phang}
* {cmd:estat ic} and {cmd:lrtest} are not appropriate after {cmd:xtreg} with the
{cmd:pa} or {cmd:re} option.{p_end}
{phang}
+ {cmd:forecast} is not appropriate with {cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtregpostestimationRemarksandexamples:Remarks and examples}

        {mansection XT xtregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
For all but the population-averaged model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
{it:statistic} {opt nooff:set}]


{phang}
Population-averaged model

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
{it:PA_statistic} {opt nooff:set}]


{marker statistic}{...}
{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}a + xb, fitted values; the default{p_end}
{synopt :{opt stdp}}standard error of the fitted values{p_end}
{synopt :{opt ue}}u_i + e_it, the combined residual{p_end}
{p2coldent :* {opt xbu}}a + xb + u_i, prediction including effect{p_end}
{p2coldent :* {opt u}}u_i, the fixed- or random-error component{p_end}
{p2coldent :* {opt e}}e_it, the overall error component{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help unstarred


{marker pastatistic}{...}
{synoptset 17 tabbed}{...}
{synopthdr :PA_statistic}
{synoptline}
{syntab:Main}
{synopt :{opt mu}}predicted value of {depvar}; considers the {opt offset()}{p_end}
{synopt :{opt rate}}predicted value of {depvar}{p_end}
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
fitted values, standard errors, predicted values, linear predictions, and
equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb} calculates the linear prediction, that is, a + xb.  This is the
default for all except the population-averaged model.

{phang}
{opt stdp} calculates the standard error of the linear prediction. 
For the fixed-effects model, this excludes the variance due to
uncertainty about the estimate of u_i.

{phang}
{opt mu} and {opt rate} both calculate the predicted value of {depvar}.
{opt mu} takes into account the {opt offset()}, and {opt rate} ignores those
adjustments.  {opt mu} and {cmd:rate} are equivalent if you did not specify
{opt offset()}.  {opt mu} is the default for the population-averaged model.

{phang}
{opt ue} calculates the prediction of u_i + e_it.

{phang}
{opt xbu} calculates the prediction of a + xb + u_i, the prediction
including the fixed or random component.

{phang}
{opt u} calculates the prediction of u_i, the estimated fixed or random effect.

{phang}
{opt e} calculates the prediction of e_it.

{phang}
{opt score} calculates the equation-level score.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{cmd:xtreg, pa}.  It modifies the calculations made by {cmd:predict} so that
they ignore the offset variable; the linear prediction is treated as xb rather
than xb + offset.


INCLUDE help syntax_margins

{phang}
For all but the population-averaged model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}a + xb, fitted values; the default{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ue}}not allowed with {cmd:margins}{p_end}
{synopt :{opt xbu}}not allowed with {cmd:margins}{p_end}
{synopt :{opt u}}not allowed with {cmd:margins}{p_end}
{synopt :{opt e}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{phang}
Population-averaged model

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt mu}}predicted value of {depvar}; considers the {opt offset()}{p_end}
{synopt :{opt rate}}predicted value of {depvar}{p_end}
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
{cmd:margins} estimates margins of response for fitted values, probabilities,
and linear predictions.


{marker syntax_xttest0}{...}
{marker xttest0}{...}
{title:Syntax for xttest0}

        {cmd:xttest0}


{marker menu_xttest0}{...}
{title:Menu for xttest0}

{phang}
{bf:Statistics > Longitudinal/panel data > Linear models >}
     {bf:Lagrange multiplier test for random effects}


{marker des_xttest0}{...}
{title:Description for xttest0}

{pstd}
{cmd:xttest0}, for use after {cmd:xtreg, re}, presents the 
{help xtreg_postestimation##BP1980:Breusch and Pagan (1980)}
Lagrange multiplier test for random effects, a test that Var(v_i)=0.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork}{p_end}
{phang2}{cmd:. xtset idcode}{p_end}

{pstd}Fit random-effects model{p_end}
{phang2}{cmd:. xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp}
   {cmd:tenure c.tenure#c.tenure 2.race not_smsa south, re}

{pstd}Store random-effects results for later use{p_end}
{phang2}{cmd:. estimates store random_effects}{p_end}

{pstd}Breusch and Pagan Lagrangian multiplier test for random effects{p_end}
{phang2}{cmd:. xttest0}

{pstd}Fit fixed-effects model{p_end}
{phang2}{cmd:. xtreg ln_w grade age c.age#c.age ttl_exp c.ttl_exp#c.ttl_exp}
   {cmd:tenure c.tenure#c.tenure 2.race not_smsa south, fe}

{pstd}Hausman specification test{p_end}
{phang2}{cmd:. hausman . random_effects}{p_end}


{marker reference}{...}
{title:Reference}

{marker BP1980}{...}
{phang}
Breusch, T. S., and A. R. Pagan. 1980. The Lagrange multiplier test and its
applications to model specification in econometrics. 
{it:Review of Economic Studies} 47: 239-253.
{p_end}
