{smcl}
{* *! version 1.2.5  21may2018}{...}
{viewerdialog predict "dialog tobit_p"}{...}
{vieweralsosee "[R] tobit postestimation" "mansection R tobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] tobit" "help tobit"}{...}
{viewerjumpto "Postestimation commands" "tobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "tobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "tobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "tobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "tobit postestimation##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[R] tobit postestimation} {hline 2}}Postestimation tools for tobit{p_end}
{p2col:}({mansection R tobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt tobit}:

{synoptset 17 tabbed}{...}
{p2coldent:Command}Description{p_end}
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
INCLUDE help post_linktest
INCLUDE help post_lrtest_star
{synopt:{helpb tobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb tobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
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

        {mansection R tobitpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 17 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,}
{it:statistic}
{opt nooff:set}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_reg}}
      {it:{help newvar:newvar_sigma}}{c )-}
{ifin}
{cmd:,}
{opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt xb}}linear prediction; the default{p_end}
{synopt:{opt stdp}}standard error of the linear prediction{p_end}
{synopt:{opt stdf}}standard error of the forecast{p_end}
{synopt:{opt pr(a,b)}}Pr(a < y < b){p_end}
{synopt:{opt e(a,b)}}{it:E}(y|a < y < b){p_end}
{synopt:{opt ys:tar(a,b)}}{it:E}(y*),y* = max{c -(}a, min(y,b){c )-} {p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample
{p 4 6 2}
{opt stdf} is not allowed with {cmd:svy} estimation results.
{p_end}

INCLUDE help whereab


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, probabilities, and expected values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the prediction, which can be
thought of as the standard error of the predicted expected value or mean for
the observation's covariate pattern.  The standard error of the prediction is
also referred to as the standard error of the fitted value.

{phang}
{opt stdf} calculates the standard error of the forecast, which is the
standard error of the point prediction for 1 observation.  It is
commonly referred to as the standard error of the future or forecast value.
By construction, the standard errors produced by {opt stdf} are always larger
than those produced by {opt stdp}; see
{it:{mansection R regresspostestimationMethodsandformulas:Methods and formulas}} in
{hi:[R] regress postestimation}.

INCLUDE help pr_opt

{phang}
{opt e(a,b)} calculates
{bind:{it:E}(xb + u | {it:a} < xb + u < {it:b})}, the expected value of y|x
conditional on y|x being in the interval {opt (a,b)}, meaning that y|x is
truncated.  {it:a} and {it:b} are specified as they are for {opt pr()}.

{phang}
{opt ystar(a,b)} calculates {it:E}(y*),
where {bind:y* = {it:a}} if {bind:xb + u {ul:<} {it:a}}, {bind:y* = {it:b}} if
{bind:xb + u {ul:>} {it:b}}, and {bind:y* = xb+u} otherwise, meaning that
y* is censored.  {it:a} and {it:b} are specified as they are for
{opt pr()}.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)}.
It modifies the calculations made
by {cmd:predict} so that they ignore the offset variable; the linear
prediction is treated as xb rather than as xb + offset.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the scale equation ({hi:sigma}).


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt:{opt xb}}linear prediction; the default{p_end}
{synopt:{opt pr(a,b)}}Pr(a < y < b){p_end}
{synopt:{opt e(a,b)}}{it:E}(y|a < y < b){p_end}
{synopt:{opt ys:tar(a,b)}}{it:E}(y*),y* = max{c -(}a, min(y,b){c )-} {p_end}
{synopt:{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt:{opt stdf}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions, probabilities, and expected values.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. generate wgt = weight/100}{p_end}
{phang2}{cmd:. tobit mpg wgt, ll(17) ul(24)}{p_end}

{pstd}Average marginal effects for all covariates{p_end}
{phang2}{cmd:. margins, dydx(*)}{p_end}

{pstd}Marginal effect on the truncated expected value, conditional on weights
of 2000 and 2500 pounds{p_end}
{phang2}{cmd:. margins, dydx(wgt) predict(e(17,24)) at(wgt=(20 25))}{p_end}
