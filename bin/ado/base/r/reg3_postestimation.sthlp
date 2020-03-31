{smcl}
{* *! version 1.2.4  19oct2017}{...}
{viewerdialog predict "dialog reg3_p"}{...}
{vieweralsosee "[R] reg3 postestimation" "mansection R reg3postestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] reg3" "help reg3"}{...}
{viewerjumpto "Postestimation commands" "reg3 postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "reg3_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "reg3 postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "reg3 postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "reg3 postestimation##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[R] reg3 postestimation} {hline 2}}Postestimation tools for reg3{p_end}
{p2col:}({mansection R reg3postestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:reg3}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
{p2coldent :* {bf:{help estat ic}}}Akaike's and Schwarz's Bayesian information criteria (AIC and BIC){p_end}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb reg3_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb reg3 postestimation##predict:predict}}predictions, residuals,
influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{pstd}* {cmd:estat ic} is not appropriate after {cmd:reg3, 2sls}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R reg3postestimationRemarksandexamples:Remarks and examples}

        {mansection R reg3postestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 19 2}
{cmd:predict} {dtype} {newvar} {ifin} 
   [{cmd:,} {opt eq:uation}{cmd:(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)} 
   {it:statistic}]

{marker statistic}{...}
{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt d:ifference}}difference between the linear predictions of two
equations{p_end}
{synopt :{opt stddp}}standard error of the difference in linear
predictions{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, residuals, and differences between the
linear predictions of two equations.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:equation(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)} specifies to which
equation you are referring.

{pmore}
{opt equation()} is filled in with one {it:eqno} for the {opt xb}, 
{opt stdp}, and {opt residuals} options.  {cmd:equation(#1)} would mean the
calculation is to be made for the first equation, {cmd:equation(#2)} would
mean the second, and so on.  You could also refer to the equations
by their names.  {cmd:equation(income)} would refer to the equation named
income and {cmd:equation(hours)} to the equation named hours.

{pmore}
If you do not specify {opt equation()}, results are the same as if you
specified {cmd:equation(#1)}.

{pmore}
{opt difference} and {opt stddp} refer to between-equation concepts.
To use these options, you must specify two equations, for example, 
{cmd:equation(#1,#2)} or {cmd:equation(income,hours)}.  When two equations
must be specified, {opt equation()} is required.

{phang}
{opt xb}, the default, calculates the linear prediction (fitted values) -- the
prediction of xb for the specified equation.

{phang}
{opt stdp} calculates the standard error of the prediction for the specified
equation.  It can be thought of as the standard error of the predicted
expected value or mean for the observation's covariate pattern.  The standard
error of the prediction is also referred to as the standard error of the
fitted value.

{phang}
{opt residuals} calculates the residuals.

{phang}
{opt difference} calculates the difference between the linear predictions of
two equations in the system.  With {cmd:equation(#1,#2)}, {opt difference}
computes the prediction of {cmd:equation(#1)} minus the prediction of
{cmd:equation(#2)}.

{phang}
{opt stddp} is allowed only after you have previously fit a
multiple-equation model.  The standard error of the difference in linear
predictions (x1b - x2b) between equations 1 and 2 is calculated.

{phang}
For more information on using {cmd:predict} after multiple-equation estimation
commands, see {manhelp predict R}. 


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :default}linear predictions for each equation{p_end}
{synopt :{cmd:xb}}linear prediction for a specified equation{p_end}
{synopt :{opt d:ifference}}difference between the linear predictions of two equations{p_end}
{synopt :{cmd:stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stdd:p}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{opt xb} defaults to the first equation.
{p_end}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions and differences between the linear predictions of two
equations.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse supDem}{p_end}
{phang2}{cmd:. global demand "(qDemand: quantity price pcompete income)"}{p_end}
{phang2}{cmd:. global supply "(qSupply: quantity price praw)"}{p_end}
{phang2}{cmd:. reg3 $demand $supply, endog(price)}{p_end}
{phang2}{cmd:. summarize pcompete, meanonly}{p_end}
{phang2}{cmd:. replace pcompete = r(mean)}{p_end}
{phang2}{cmd:. summarize income, meanonly}{p_end}
{phang2}{cmd:. replace income = r(mean)}{p_end}
{phang2}{cmd:. summarize praw, meanonly}{p_end}
{phang2}{cmd:. replace praw = r(mean)}{p_end}

{pstd}Predict demand{p_end}
{phang2}{cmd:. predict demand, equation(qDemand)}{p_end}

{pstd}Predict supply{p_end}
{phang2}{cmd:. predict supply, equation(qSupply)}{p_end}
