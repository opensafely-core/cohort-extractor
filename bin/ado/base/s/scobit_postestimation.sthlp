{smcl}
{* *! version 1.2.5  21may2018}{...}
{viewerdialog predict "dialog scob_p"}{...}
{vieweralsosee "[R] scobit postestimation" "mansection R scobitpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] scobit" "help scobit"}{...}
{viewerjumpto "Postestimation commands" "scobit postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "scobit_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "scobit postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "scobit postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "scobit postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] scobit postestimation} {hline 2}}Postestimation tools for
scobit{p_end}
{p2col:}({mansection R scobitpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt scobit}:

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
INCLUDE help post_lincom
INCLUDE help post_lrtest_star
{synopt:{helpb scobit_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb scobit postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast} and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.{p_end}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R scobitpostestimationRemarksandexamples:Remarks and examples}

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
[{cmd:,}
{it:statistic}
{opt nooff:set} ]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |} {it:{help newvar:newvar_reg}}
    {it:{help newvar:newvar_lnalpha}}{c )-}
{ifin}
{cmd:,}
{opt sc:ores}

{synoptset 17 tabbed}
{synopthdr:statistic}
{synoptline}
{syntab:Main}
{synopt:{opt pr}}probability of a positive outcome; the default{p_end}
{synopt:{opt xb}}xb, linear prediction {p_end}
{synopt:{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
probabilities, linear predictions, and standard errors.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt pr}, the default, calculates the probability of a positive outcome.

{phang}
{opt xb} calculates the linear prediction.

{phang}
{opt stdp} calculates the standard error of the linear prediction.

{phang}
{opt nooffset} is relevant only if you specified {opth offset(varname)} for
{opt scobit}.  It modifies the calculations made by {opt predict} so that they
ignore the offset variable; the linear prediction is treated as xb rather than
as {bind:xb + offset}.

{phang}
{opt scores} calculates equation-level score variables.

{pmore}
The first new variable will contain {bind:d(ln L_j)/d(x_j b)}.

{pmore}
The second new variable will contain {bind:d(ln L_j)/d(ln(alpha))}.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt:{opt pr}}probability of a positive outcome; the default{p_end}
{synopt:{opt xb}}xb, linear prediction {p_end}
{synopt:{opt stdp}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for probabilities and linear
predictions.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Fit skewed logistic regression{p_end}
{phang2}{cmd:. scobit foreign mpg}

{pstd}Calculate predicted probabilities{p_end}
{phang2}{cmd:. predict p}

{pstd}Graph data and fitted model; jitter the binary outcome{p_end}
{phang2}{cmd:. line p mpg, sort || scatter foreign mpg, jitter(6)}
   {cmd:ytitle(Pr(foreign)) legend(off)}{p_end}
