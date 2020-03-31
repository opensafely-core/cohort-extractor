{smcl}
{* *! version 1.3.5  19oct2017}{...}
{viewerdialog predict "dialog reg3_p"}{...}
{vieweralsosee "[MV] mvreg postestimation" "mansection MV mvregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] mvreg" "help mvreg"}{...}
{viewerjumpto "Postestimation commands" "mvreg postestimation##description"}{...}
{viewerjumpto "predict" "mvreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "mvreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "mvreg postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[MV] mvreg postestimation} {hline 2}}Postestimation tools for mvreg{p_end}
{p2col:}({mansection MV mvregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:mvreg}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast_star
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb mvreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb mvreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast} is not appropriate with {cmd:mi} estimation results.{p_end}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin} [{cmd:,} 
{cmdab:eq:uation:(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)} {it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synopt :{opt d:ifference}}difference between the linear predictions of two equations{p_end}
{synopt :{opt stdd:p}}standard error of the difference in linear predictions{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2} 
These statistics are available both in and out of sample; type {cmd:predict} ... {cmd:if e(sample)} ... if wanted only for the estimation sample.  


INCLUDE help menu_predict


{marker desc_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, residuals, and differences between the
linear predictions.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:equation(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)} specifies the equation to
which you are referring.

{pmore}
{opt equation()} is filled in with one {it:eqno} for the {opt xb}, 
{opt stdp}, and {opt residuals} options.  {cmd:equation(#1)} would mean the
calculation is to be made for the first equation, {cmd:equation(#2)} would
mean the second, and so on.  You could also refer to the equations
by their names.  {cmd:equation(income)} would refer to the equation named
income and {cmd:equation(hours)}, to the equation named hours.

{pmore}
If you do not specify {opt equation()}, results are as if you specified
{cmd:equation(#1)}.

{pmore}
{opt difference} and {opt stddp} refer to between-equation concepts.  To use
these options, you must specify two equations, for example,
{cmd:equation(#1,#2)} or {cmd:equation(income,hours)}.  When two equations must
be specified, {opt equation()} is required.  With {cmd:equation(#1,#2)},
{opt difference} computes the prediction of {cmd:equation(#1)} minus the
prediction of {cmd:equation(#2)}.

{phang}
{opt xb}, the default, calculates the fitted values -- the prediction of
xb for the specified equation.

{phang}
{opt stdp} calculates the standard error of the prediction for the specified
equation (the standard error of the predicted expected value or mean for the
observation's covariate pattern).  The standard error of the prediction is
also referred to as the standard error of the fitted value.

{phang}
{opt residuals} calculates the residuals.

{phang}
{opt difference} calculates the difference between the linear
predictions of two equations in the system.

{phang}
{opt stddp} is allowed only after you have previously fit a
multiple-equation model.  The standard error of the difference in linear
predictions between equations 1 and 2 is calculated.


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


{marker desc_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of responses for
linear predictions, fitted values, and differences between the linear
predictions.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. mvreg headroom trunk turn = price mpg displ gear_ratio length weight}

{pstd}Test that the coefficients on {cmd:price} are 0 in all equations{p_end}
{phang2}{cmd:. test price}

{pstd}Test that the coefficients on {cmd:price} are 0 in the {cmd:trunk} and
{cmd:turn} equations{p_end}
{phang2}{cmd:. test [trunk]price [turn]price}

{pstd}Test an across-equation equality{p_end}
{phang2}{cmd:. test [trunk]price = [turn]price}{p_end}
{phang2}{cmd:. test [headroom]price = [trunk]price, accum}

{pstd}Test a general linear combination{p_end}
{phang2}{cmd:. test [trunk]price - [headroom]mpg = [turn]price - [turn]mpg}
{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse jaw}{p_end}
{phang2}{cmd:. mvreg y1 y2 y3 = gender##fracture}{p_end}

{pstd}Test main effects and interaction in the equation for {cmd:y2}{p_end}
{phang2}{cmd:. contrast gender##fracture, equation(y2)}{p_end}

{pstd}Test whether the main effects of gender differ between the dependent
variables{p_end}
{phang2}{cmd:. contrast gender#_eqns}{p_end}

    {hline}
