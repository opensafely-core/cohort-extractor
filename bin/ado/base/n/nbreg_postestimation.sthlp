{smcl}
{* *! version 1.3.5  31may2018}{...}
{viewerdialog "nbreg predict" "dialog nbreg_p"}{...}
{viewerdialog "gnbreg predict" "dialog gnbreg_p"}{...}
{vieweralsosee "[R] nbreg postestimation" "mansection R nbregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] nbreg" "help nbreg"}{...}
{viewerjumpto "Postestimation commands" "nbreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "nbreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "nbreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "nbreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "nbreg postestimation##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[R] nbreg postestimation} {hline 2}}Postestimation tools for
nbreg and gnbreg{p_end}
{p2col:}({mansection R nbregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:nbreg} and
{cmd:gnbreg}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
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
{synopt:{helpb nbreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb nbreg postestimation##predict:predict}}predictions,
residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with
{cmd:svy} estimation results.  {cmd:forecast} is also not appropriate with
{cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R nbregpostestimationRemarksandexamples:Remarks and examples}

        {mansection R nbregpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} {it:statistic}
{opt nooff:set}]

{p 8 16 2}
{cmd:predict} {dtype} {c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_reg}}
 {it:{help newvar:newvar_disp}}{c )-}
 {ifin} {cmd:,} {opt sc:ores}

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{cmd:n}}number of events; the default{p_end}
{synopt :{cmd:ir}}incidence rate (equivalent to {cmd:predict} ...,
{cmd:n nooffset}){p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{cmd:stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
In addition, relevant only after {cmd:gnbreg} are the following:

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt a:lpha}}predicted values of alpha{p_end}
{synopt :{opt lna:lpha}}predicted values of ln(alpha){p_end}
{synopt :{opt stdpl:na}}standard error of predicted ln(alpha){p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
numbers of events, incidence rates, probabilities, linear predictions, 
standard errors, and predicted values.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt n}, the default, calculates the predicted number of events, which
is exp(xb) if neither {opth offset:(varname:varname_o)}
nor {opt exposure(varname_e)}
was specified when the model was fit; exp(xb + offset) if
{opt offset()} was specified; or exp(xb)*exposure if {opt exposure()} was
specified.

{phang}
{opt ir} calculates the incidence rate exp(xb), which is the predicted number
of events when exposure is 1.  This is equivalent to specifying both
the {opt n} and the {opt nooffset} options.

{phang}
{opt pr(n)} calculates the probability Pr(y = n), where n is a
nonnegative integer that may be specified as a number or a variable.

INCLUDE help pr_uncond_opt

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt alpha}, {opt lnalpha}, and {opt stdplna} are relevant after {cmd:gnbreg}
estimation only; they produce the predicted values of alpha, ln(alpha), and
the standard error of the predicted ln(alpha), respectively.

{phang}
{opt nooffset} is relevant only if you specified {opt offset()} or
{opt exposure()} when you fit the model.  It modifies the
calculations made by {cmd:predict} so that they ignore the
offset or exposure variable; the linear prediction is treated as xb rather
than as xb + offset or xb + ln(exposure_j).  Specifying {cmd:predict}
...{cmd:,} {opt nooffset} is equivalent to specifying {cmd:predict} ...{cmd:,}
{opt ir}.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain the derivative of the log likelihood with
respect to the regression equation.

{pmore}
The second new variable will contain the derivative of the log likelihood with
respect to the dispersion equation.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{cmd:n}}number of events; the default{p_end}
{synopt :{cmd:ir}}incidence rate (equivalent to {cmd:predict} ...,
{cmd:n nooffset}){p_end}
{synopt :{opt pr(n)}}probability Pr(y = n){p_end}
{synopt :{opt pr(a,b)}}probability Pr(a {ul:<} y {ul:<} b){p_end}
{synopt :{cmd:xb}}linear prediction{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
In addition, relevant only after {cmd:gnbreg} are the following:

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt a:lpha}}predicted values of alpha{p_end}
{synopt :{opt lna:lpha}}predicted values of ln(alpha){p_end}
{synopt :{opt stdpl:na}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
numbers of events, incidence rates, probabilities, linear predictions,
and predicted values.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rod93}{p_end}
{phang2}{cmd:. nbreg deaths i.cohort, exposure(exp)}{p_end}

{pstd}Test that coefficients of {cmd:2.cohort} and {cmd:3.cohort} are equal
{p_end}
{phang2}{cmd:. test 2.cohort=3.cohort}{p_end}

{pstd}Predict number of events{p_end}
{phang2}{cmd:. predict count}{p_end}

{pstd}Predict incidence rate{p_end}
{phang2}{cmd:. predict rate, ir}

{pstd}Predict probability of 5 deaths for each cohort accounting for the
exposure described in the sample{p_end}
{phang2}{cmd:. predict p, pr(5)}

{pstd}Predict probability of 5 or more deaths for each cohort accounting for
the exposure described in the sample{p_end}
{phang2}{cmd:. predict p, pr(5, .)}{p_end}
