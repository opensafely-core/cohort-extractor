{smcl}
{* *! version 1.0.0  20jun2019}{...}
{viewerdialog "meta" "dialog meta"}{...}
{vieweralsosee "[META] meta regress postestimation" "mansection META metaregresspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta regress" "help meta regress"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta data" "mansection META metadata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[META] meta" "help meta"}{...}
{vieweralsosee "[META] Glossary" "help meta glossary"}{...}
{vieweralsosee "[META] Intro" "mansection META Intro"}{...}
{viewerjumpto "Postestimation commands" "meta_regress_postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "meta_regress_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "meta_regress_postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "meta_regress_postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "meta_regress_postestimation##examples"}{...}
{p2colset 1 39 41 2}{...}
{p2col:{bf:[META] meta regress postestimation} {hline 2}}Postestimation tools
for meta regress{p_end}
{p2col:}({mansection META metaregresspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after
{cmd:meta regress}:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb estat bubbleplot}}bubble plots{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 18}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
{synopt :{helpb estimates}}cataloging estimation results{p_end}
INCLUDE help post_lincom
{synopt :{helpb meta_regress_postestimation##margins:margins}}marginal
        means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb menl_postestimation##predict:predict}}predictions, residuals,
and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection META metaregresspostestimationRemarksandexamples:Remarks and examples}

        {mansection META metaregresspostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 4 4 2}
Syntax for obtaining BLUPs of random effects and their standard errors
after RE meta-regression

{p 8 16 2}
{cmd:predict} {dtype}
{newvar}
{ifin}{cmd:,}
{opt ref:fects}
[{opth se:(newvar)}]


{p 4 4 2}
Syntax for obtaining other predictions

{p 8 16 2}
{cmd:predict} {dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic}
{opt fixed:only}
{opth se:(meta_regress_postestimation##sespec:sespec)}]


{synoptset 18 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{cmd:xb}}linear prediction; the default{p_end}
{synopt :{cmd:stdp}}standard error of the linear prediction{p_end}
{synopt :{opt fit:ted}}fitted values, fixed-portion linear prediction plus
predicted random effects{p_end}
{synopt :{opt res:iduals}}residuals, response minus fitted values{p_end}
{synopt :{opt lev:erage}{c |}{opt hat}}leverage (diagonal elements of hat
matrix){p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2} Unstarred statistics are available both in and out of sample; type
{cmd:predict} {it:...} {cmd:if e(sample)} {it:...} if wanted only for the
estimation sample.


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as linear
predictions, residuals, leverage, and standard errors.  After random-effects
meta-regression, you can also obtain estimates of random effects and their
standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:xb}, the default, calculates the linear prediction xb.  For the
random-effects meta-regression, this corresponds to the fixed portion of the
linear predictor based on the estimated regression coefficients.  That is,
this is equivalent to fixing all random effects in the model to their
theoretical mean value of 0.

{phang}
{cmd:stdp} calculates the standard error of the linear prediction.

{phang}
{cmd:reffects} calculates best linear unbiased predictions (BLUPs) of the
random effects.

{phang}
{cmd:fitted} calculates the fitted values.  With fixed-effects meta-regression
or with random-effects meta-regression when option {cmd:fixedonly} is also
specified, this option is equivalent to {cmd:xb}.  For random-effects
meta-regression without {cmd:fixedonly}, it calculates xb + u, which is equal
to the fixed portion of the linear prediction plus predicted random effects.

{phang}
{cmd:residuals} calculates the residuals, which are equal to the responses
minus the fitted values.  With fixed-effects meta-regression or with
random-effects meta-regression when option {cmd:fixedonly} is also specified,
it calculates θ - xb.  The former are known as marginal residuals in the
context of the random-effects model.  For random-effects meta-regression
without {cmd:fixedonly}, this option calculates θ - (xb + uj), which are known
as conditional residuals.

{phang}
{cmd:leverage} or {cmd:hat} calculates the diagonal elements of the projection
("hat") matrix.

{phang}
{cmd:fixedonly} specifies that all random effects be set to zero, which is
equivalent to using only the fixed portion of the model, when computing
results for random-effects models.  This option may be specified only with
statistics {cmd:fitted}, {cmd:residuals}, or {cmd:leverage}.

{marker sespec}{...}
{phang}
{cmd:se(}{newvar}[{cmd:, marginal}]{cmd:)} calculates the standard error of
the corresponding predicted values.  This option may be specified only with
statistics {cmd:reffects}, {cmd:fitted}, and {cmd:residuals}.

{pmore}
Suboption {cmd:marginal} is allowed only with random-effects meta-regression
and requires option {cmd:fixedonly}.  It computes marginal standard errors,
when you type

          {cmd:. predict} ...{cmd:, statistic se(newvar, marginal) fixedonly}

{pmore}
instead of the standard errors conditional on zero random effects, which are
computed when you type

          {cmd:. predict} ...{cmd:, statistic se(newvar) fixedonly}

{pmore}
{cmd:marginal} is not allowed in combination with {cmd:reffects}.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{cmd:xb}}linear prediction; the default{p_end}
{synopt :{opt fit:ted}}fitted values; implies {cmd:fixedonly}{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt ref:fects}}not allowed with {cmd:margins}{p_end}
{synopt :{opt res:iduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt lev:erage}{c |}{opt h:at}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse bcgset}{p_end}
{phang2}{cmd:. meta regress latitude_c}

{pstd}Predict random effects and their standard errors{p_end}
{phang2}{cmd:. predict double u, reffects se(u_se)}

{pstd}Predict fixed portion of fitted values and their marginal standard
errors{p_end}
{phang2}{cmd:. predict double yhat, fitted fixedonly se(yhat_se, marginal)}

{pstd}Obtain predicted log risk-ratios at different latitude values{p_end}
{phang2}{cmd:. margins, at(latitude_c = (-18.5 -5.5 16.5))}
{p_end}
