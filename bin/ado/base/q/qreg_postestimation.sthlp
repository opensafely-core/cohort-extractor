{smcl}
{* *! version 1.2.8  19oct2017}{...}
{viewerdialog "predict for qreg, iqreg, bsqreg" "dialog qreg_p"}{...}
{viewerdialog "predict for sqreg" "dialog sqreg_p"}{...}
{vieweralsosee "[R] qreg postestimation" "mansection R qregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] qreg" "help qreg"}{...}
{viewerjumpto "Postestimation commands" "qreg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "qreg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "qreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "qreg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "qreg postestimation##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[R] qreg postestimation} {hline 2}}Postestimation tools for qreg,
iqreg, bsqreg, and sqreg{p_end}
{p2col:}({mansection R qregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:qreg},
{cmd:iqreg}, {cmd:bsqreg}, and {cmd:sqreg}:

{synoptset 17 tabbed}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast_star2
INCLUDE help post_hausman_star
INCLUDE help post_lincom
INCLUDE help post_linktest
{synopt:{helpb qreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb qreg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:hausman} is not appropriate after {cmd:bsqreg}, {cmd:iqreg}, or {cmd:sqreg}.{p_end}
{p 4 6 2}
+ {cmd:forecast} is not appropriate with {cmd:mi} estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R qregpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{phang}
For qreg, iqreg, and bsqreg

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin}
	[{cmd:,} [{opt xb}{c |}{opt stdp}{c |}{opt r:esiduals}]]

{phang}
For sqreg

{p 8 16 2}
{cmd:predict} {dtype} {newvar} {ifin}
	[{cmd:,} {cmdab:eq:uation:(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)}
          {it:statistic}]

{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab :Main}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synopt :{opt stddp}}standard error of the difference in linear predictions{p_end}
{synopt :{opt r:esiduals}}residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, standard errors, and residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}{opt xb}, the default, calculates the linear prediction.

{phang}{opt stdp} calculates the standard error of the linear prediction.

{phang}{opt stddp} is allowed only after you have fit a model using
{cmd:sqreg}.  The standard error of the difference in linear predictions
between equations 1 and 2 is calculated.

{phang}{opt residuals} calculates the residuals, that is, y - xb.

{phang}{cmd:equation(}{it:eqno}[{cmd:,}{it:eqno}]{cmd:)} specifies the
equation to which you are making the calculation.  

{pmore} {opt equation()} is filled in
with one {it:eqno} for the {opt xb}, {opt stdp}, and {opt residuals} options.
{cmd:equation(#1)} would mean that the calculation is to be made for the first
equation, {cmd:equation(#2)} would mean the second, and so on.  
You could also refer to the equations by their names.  {cmd:equation(income)}
would refer to the equation named income and {cmd:equation(hours)} to the
equation named hours.

{pmore} If you do not specify {opt equation()}, results are the same as if you
had specified {cmd:equation(#1)}.

{pmore}To use {opt stddp}, you must specify two equations.  You might specify
{cmd:equation(#1, #2)} or {cmd:equation(q80, q20)} to indicate the 80th and
20th quantiles.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt xb}}linear prediction; the default{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt stddp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. qreg price weight length foreign}{p_end}

{pstd}Obtain predicted values{p_end}
{phang2}{cmd:. predict hat}

{pstd}Obtain residuals{p_end}
{phang2}{cmd:. predict r, resid}{p_end}
