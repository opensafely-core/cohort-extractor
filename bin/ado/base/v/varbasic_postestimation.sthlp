{smcl}
{* *! version 1.2.6  19oct2017}{...}
{viewerdialog predict "dialog var_p"}{...}
{vieweralsosee "[TS] varbasic postestimation" "mansection TS varbasicpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] varbasic" "help varbasic"}{...}
{viewerjumpto "Postestimation commands" "varbasic postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "varbasic_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "varbasic postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "varbasic postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "varbasic postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[TS] varbasic postestimation} {hline 2}}Postestimation tools for varbasic{p_end}
{p2col:}({mansection TS varbasicpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after {opt varbasic}:

{synoptset 17}{...}
{synopt:Command}Description{p_end}
{synoptline}
{synopt:{helpb fcast compute}}obtain dynamic forecasts{p_end}
{synopt:{helpb fcast graph}}graph dynamic forecasts obtained from {cmd:fcast compute}{p_end}
{synopt:{helpb irf}}create and analyze IRFs and FEVDs{p_end}
{synopt:{helpb vargranger}}Granger causality tests{p_end}
{synopt:{helpb varlmar}}LM test for autocorrelation in residuals{p_end}
{synopt:{helpb varnorm}}test for normally distributed residuals{p_end}
{synopt:{helpb varsoc}}lag-order selection criteria{p_end}
{synopt:{helpb varstable}}check stability condition of estimates{p_end}
{synopt:{helpb varwle}}Wald lag-exclusion statistics{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{synopt:Command}Description{p_end}
{synoptline}
INCLUDE help post_estatic
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_lincom
INCLUDE help post_lrtest
{synopt:{helpb varbasic_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb varbasic postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS varbasicpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}
[{cmd:,} {it:statistic}	{opt eq:uation(eqno|eqname)}]

{synoptset 17 tabbed}{...}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt xb}}linear prediction; the default{p_end}
{synopt:{opt stdp}}standard error of the linear prediction{p_end}
{synopt:{opt r:esiduals}}residuals{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions and residuals.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt xb}, the default, calculates the linear prediction for the specified
equation.

{phang}
{opt stdp} calculates the standard error of the linear prediction for the
specified equation.

{phang}
{opt residuals} calculates the residuals.

{phang}
{opt equation(eqno|eqname)} specifies the equation to which you are referring.

{pmore}
    {opt equation()} is filled in with one {it:eqno} or {it:eqname} for
    the {opt xb}, {opt stdp}, and {opt residuals} options.  For example,
    {cmd:equation(#1}) would mean that the calculation is to be made for the
    first equation, {cmd:equation(#2)} would mean the second, and so on.  You
    could also refer to the equation by its name; thus, {cmd:equation(income)}
    would refer to the equation named income and {cmd:equation(hours)}, to the
    equation named hours.

{pmore}
    If you do not specify {opt equation()}, the results are the same as if you
    specified {cmd:equation(#1)}.

{pstd}
For more information on using {opt predict} after multiple-equation
estimation commands, see {manhelp predict R}.


INCLUDE help syntax_margins1

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt:default}linear predictions for each equation{p_end}
{synopt:{opt xb}}linear prediction for a specified equation{p_end}
{synopt:{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt:{opt r:esiduals}}not allowed with {cmd:margins}{p_end}
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
{cmd:margins} estimates margins of response for linear predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}

{pstd}Fit a VAR model and graph OIRFs{p_end}
{phang2}{cmd:. varbasic dln_inv dln_inc dln_consump}{p_end}

{pstd}Perform Lagrange multiplier test for residual autocorrelation{p_end}
{phang2}{cmd:. varlmar}{p_end}

{pstd}Check stability of the {cmd:var} results{p_end}
{phang2}{cmd:. varstable}{p_end}

{pstd}Compute 8-step dynamic forecasts{p_end}
{phang2}{cmd:. fcast compute ex_, step(8)}{p_end}

{pstd}Graph forecast of variables computed by {cmd:fcast compute}{p_end}
{phang2}{cmd:. fcast graph ex_dln_inv ex_dln_inc, observed}{p_end}

{pstd}Obtain linear prediction for equation 1{p_end}
{phang2}{cmd:. predict dln_inv_hat}{p_end}
