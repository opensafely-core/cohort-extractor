{smcl}
{* *! version 1.2.5  19oct2017}{...}
{viewerdialog predict "dialog reg3_p"}{...}
{vieweralsosee "[R] sureg postestimation" "mansection R suregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] sureg" "help sureg"}{...}
{viewerjumpto "Postestimation commands" "sureg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "sureg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "sureg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "sureg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "sureg postestimation##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[R] sureg postestimation} {hline 2}}Postestimation tools for
sureg{p_end}
{p2col:}({mansection R suregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt sureg}:

{synoptset 17}{...}
{synopt:Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb sureg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt:{helpb sureg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R suregpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype} {newvar} {ifin}
[{cmd:,}
{cmdab:eq:uation:(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)}
{it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt xb}}linear prediction; the default{p_end}
{synopt:{opt stdp}}standard error of the linear prediction{p_end}
{synopt:{opt r:esiduals}}residuals{p_end}
{synopt:{opt d:ifference}}difference between the linear predictions of two
equations{p_end}
{synopt:{opt stdd:p}}standard error of the difference in linear predictions{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, residuals, and differences between
the linear predictions.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{cmd:equation(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)}
  specifies to which equation(s) you are referring.

{pmore}
{opt equation()} is filled in with one {it:eqno} for the {opt xb},
{opt stdp}, and {opt residuals} options.  {cmd:equation(#1)} would mean that
the calculation is to be made for the first equation, {cmd:equation(#2)} would
mean the second, and so on.  You could also refer to the equations by their
names.  {cmd:equation(income)} would refer to the equation named income and
{cmd:equation(hours)} to the equation named hours.

{pmore}
If you do not specify {opt equation()}, the results are the same as if you
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
{opt difference} calculates the difference between the linear
predictions of two equations in the system.
With {cmd:equation(#1,#2)}, {opt difference} computes the prediction of
{cmd:equation(#1)} minus the prediction of {cmd:equation(#2)}.

{phang}
{opt stddp} 
is allowed only after you have previously fit a multiple-equation model.
The standard error of the difference in linear predictions between equations 1
and 2 is calculated.

{pstd}
For more information on using {opt predict} after multiple-equation
estimation, see {manhelp predict R}.


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
linear predictions and differences between the linear predictions.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. sureg (price foreign weight length) (mpg foreign weight) (displ foreign weight)}

{pstd}Test that the coefficients on {cmd:foreign} are 0 in all equations{p_end}
{p 8 12 2}{cmd:. test foreign}

{pstd}Test that the coefficients on {cmd:foreign} are 0 in the {cmd:mpg} and 
{cmd:displ} equations{p_end}
{p 8 12 2}{cmd:. test [mpg]foreign [displacement]foreign}

{pstd}Test an across-equation equality{p_end}
{p 8 12 2}{cmd:. test [price]foreign = [mpg]foreign}{p_end}
{p 8 12 2}{cmd:. test [displacement]foreign = [mpg]foreign, accum}

{pstd}Test a general linear combination{p_end}
{p 8 12 2}{cmd:. test [price]foreign-[mpg]weight = [displacement]foreign - [displacement]weight}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. sureg (mpg price weight length) (gear price weight length)}{p_end}

{pstd}Calculate fitted values for the first equation{p_end}
{phang2}{cmd:. predict mpghat, xb equation(#1)}{p_end}

{pstd}Calculate the standard error of the prediction for the second
equation{p_end}
{phang2}{cmd:. predict gearstdp, stdp equation(#2)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse margex, clear}

{pstd}Fit seemingly unrelated regression model{p_end}
{phang2}{cmd:. sureg (y = i.sex age) (distance = i.sex i.group)}

{pstd}Estimate marginal means of {cmd:y} for men and women{p_end}
{phang2}{cmd:. margins sex, predict(equation(y))}

    {hline}
