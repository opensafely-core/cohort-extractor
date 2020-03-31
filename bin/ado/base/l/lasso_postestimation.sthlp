{smcl}
{* *! version 1.0.0  21jun2019}{...}
{viewerdialog predict "dialog lasso_p"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "mansection lasso lassopostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lasso examples" "mansection lasso lassoexamples"}{...}
{vieweralsosee "[LASSO] elasticnet" "help elasticnet"}{...}
{vieweralsosee "[LASSO] lasso" "help lasso"}{...}
{vieweralsosee "[LASSO] sqrtlasso" "help sqrtlasso"}{...}
{viewerjumpto "Postestimation commands" "lasso_postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "lasso_postestimation##linkspdf"}{...}
{viewerjumpto "Predictions" "lasso postestimation##syntax_predict"}{...}
{viewerjumpto "Examples" "lasso postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[LASSO] lasso postestimation} {hline 2}}Postestimation tools for lasso for prediction{p_end}
{p2col:}({mansection LASSO lassopostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {cmd:lasso},
{cmd:sqrtlasso}, and {cmd:elasticnet}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb coefpath}}plot path of coefficients{p_end}
{synopt :{helpb cvplot}}plot cross-validation function{p_end}
{synopt :{helpb lassocoef}}display selected coefficients{p_end}
{synopt :{helpb lassogof}}goodness of fit after lasso for prediction{p_end}
{synopt :{helpb lassoinfo}}information about lasso estimation results{p_end}
{synopt :{helpb lassoknots}}knot table of coefficient selection and measures of fit{p_end}
{synopt :{helpb lassoselect}}select alternative lambda* (and alpha* for {cmd:elasticnet}){p_end}
{synoptline}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estimates
{synopt :{helpb lasso postestimation##predict:predict}}predictions{p_end}
{synopt :{helpb predictnl}}point estimates for generalized predictions{p_end}
{synoptline}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO lassopostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker predict}{...}
{marker syntax_predict}{...}
{title:Syntax for predict}

{p 8 19 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic} {it:options}]

{marker statistic}{...}
{synoptset 19 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear predictions; the default for the {cmd:linear} model{p_end}
{synopt :{opt pr}}probability of a positive outcome; the default for the {cmd:logit} and 
{cmd:probit} models{p_end}
{synopt :{opt n}}number of events; the default for the {cmd:poisson} model{p_end}
{synopt :{opt ir}}incidence rate; optional for the {cmd:poisson} model{p_end}
{synoptline}
{p 4 6 2}
Option {cmd:pr} is not allowed when the model is {cmd:linear} or {cmd:poisson}.{p_end}
{p 4 6 2}
Options {cmd:n} and {cmd:ir} are allowed only when the model is {cmd:poisson}.


{marker statistic}{...}
{synoptset 19 tabbed}{...}
{synopthdr:options}
{synoptline}
{syntab:Main}
{synopt :{opt pen:alized}}use penalized coefficients; the default{p_end}
{synopt :{opt post:selection}}use postselection (unpenalized) coefficients{p_end}
{synopt :{opt nooff:set}}ignore the offset or exposure variable (if any){p_end}
{synoptline}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as linear
predictions, probabilities when the model is logit or probit, or number of
events when the model is Poisson.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:xb}, the default for the {cmd:linear} model, calculates linear
predictions.

{phang}
{cmd:pr}, the default for the {cmd:logit} and {cmd:probit} models, calculates
the probability of a positive event.

{phang}
{cmd:n}, the default for the {cmd:poisson} model, calculates the number of
events.

{phang}
{cmd:ir} applies to {cmd:poisson} models only.  It calculates the incidence
rate exp(xbeta'), which is the predicted number of events when exposure is 1.
Specifying {cmd:ir} is equivalent to specifying {cmd:n} when neither
{cmd:offset()} nor {cmd:exposure()} was specified when the model was fit.

{phang}
{cmd:penalized} specifies that penalized coefficients be used to calculate
predictions.  This is the default.  Penalized coefficients are those estimated
by lasso in the calculation of the lasso penalty.  See
{mansection LASSO lassoMethodsandformulas:{it:Methods and formulas}} in
{bf:[LASSO] lasso}.

{phang}
{cmd:postselection} specifies that postselection coefficients be used to
calculate predictions.  Postselection coefficients are calculated by taking the
variables selected by lasso and refitting the model with the appropriate
ordinary estimator: linear regression for {cmd:linear} models, logistic
regression for {cmd:logit} models, probit regression for {cmd:probit} models,
and Poisson regression for {cmd:poisson} models.

{phang}
{cmd:nooffset} is relevant only if you specified {cmd:offset()} or
{cmd:exposure()} when you fit the model.  It modifies the calculations made by
{cmd:predict} so that they ignore the offset or exposure variable; the linear
prediction is treated as xbeta' rather than xbeta' + offset or xbeta' +
ln(exposure).  For the {cmd:poisson} model, specifying {cmd:predict} 
...{cmd:, nooffset} is equivalent to specifying {cmd:predict} 
...{cmd:, ir}.{p_end}


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto}{p_end}
{phang2}{cmd:. set seed 1234}{p_end}
{phang2}{cmd:. lasso linear mpg i.foreign i.rep78 headroom weight turn}
        {cmd:gear_ratio price trunk length displacement}

{pstd}Predict {cmd:mpg}{p_end}
{phang2}{cmd:. predict mpghat}

{pstd}Use postselection (unpenalized) coefficients{p_end}
{phang2}{cmd:. predict mpghat1, postselection}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. clear all}{p_end}
{phang2}{cmd:. set maxvar 10000}{p_end}
{phang2}{cmd:. webuse fakesurvey_vl}{p_end}
{phang2}{cmd:. vl rebuild}{p_end}
{phang2}{cmd:. lasso logit q106 $idemographics $ifactors $vlcontinuous,}
               {cmd:rseed(1234)}

{pstd}Predict probability that q106=1{p_end}
{phang2}{cmd:. predict prob}{p_end}

    {hline}
