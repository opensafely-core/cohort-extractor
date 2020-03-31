{smcl}
{* *! version 1.0.8  18feb2020}{...}
{viewerdialog predict "dialog betareg_p"}{...}
{vieweralsosee "[R] betareg postestimation" "mansection R betaregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] betareg" "help betareg"}{...}
{viewerjumpto "Postestimation commands" "betareg postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "betareg_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "betareg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "betareg postestimation##syntax_margins"}{...}
{viewerjumpto "Examples" "betareg postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] betareg postestimation} {hline 2}}Postestimation tools for betareg{p_end}
{p2col:}({mansection R betaregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt betareg}:

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
INCLUDE help post_lrtest_star
{synopt:{helpb betareg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb betareg postestimation##predict:predict}}predictions, residuals, influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_pwcompare
INCLUDE help post_suest
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {cmd:forecast}, {cmd:hausman}, and {cmd:lrtest} are not appropriate with {cmd:svy}
estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R betaregpostestimationRemarksandexamples:Remarks and examples}

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
[{cmd:,} {it:statistic}]

{p 8 16 2}
{cmd:predict}
{dtype}
{c -(}{it:{help newvarlist##stub*:stub}}{cmd:*} {c |}
{it:{help newvar:newvar_mean}} {it:{help newvar:newvar_scale}}{c )-}
{ifin}{cmd:,} {opt sc:ores}


{synoptset 17 tabbed}{...}
{synopthdr :statistic}
{synoptline}
{syntab:Main}
{synopt :{opt cm:ean}}conditional mean of the dependent variable;
the default{p_end}
{synopt :{opt cvar:iance}}conditional variance of the dependent
variable{p_end}
{synopt :{opt xb}}linear prediction in the conditional-mean equation{p_end}
{synopt :{opt xbsca:le}}linear prediction in the conditional-scale
equation{p_end}
{synopt :{opt stdp}}standard error of the linear prediction{p_end}
{synoptline}
{p2colreset}{...}
INCLUDE help esample


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing predictions such as
linear predictions, conditional means, conditional variances, and
equation-level scores.


{marker options_predict}{...}
{title:Options for predict}

{dlgtab:Main}

{phang}
{opt cmean}, the default, calculates the conditional mean of the dependent
variable.

{phang}
{opt cvariance} calculates the conditional variance of the dependent
variable.

{phang}
{opt xb} calculates the linear prediction for the conditional-mean equation.

{phang}
{opt xbscale} calculates the linear prediction for the conditional-scale
equation.

{phang}
{opt stdp} calculates the standard error of the linear prediction for the
conditional-mean equation.

{phang}
{opt scores} calculates equation-level score variables.  The first new
variable will contain the derivative of the log likelihood with respect
to the conditional-mean equation, and the second new variable will contain
the derivative of the log likelihood with respect to the conditional-scale
equation.


INCLUDE help syntax_margins

{synoptset 17}{...}
{synopthdr :statistic}
{synoptline}
{synopt :{opt cm:ean}}conditional mean of the dependent variable; the
default{p_end}
{synopt :{opt cvar:iance}}conditional variance of the dependent variable{p_end}
{synopt :{opt xb}}linear prediction in the conditional-mean equation{p_end}
{synopt :{opt xbsca:le}}linear prediction in the conditional-scale
equation{p_end}
{synopt :{opt stdp}}not allowed with {cmd:margins}{p_end}
{synopt :{opt scores}}not allowed with {cmd:margins}{p_end}
{synoptline}
{p2colreset}{...}

INCLUDE help notes_margins


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
conditional means, conditional variances, and linear predictions.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sprogram}{p_end}
{phang2}{cmd:. betareg prate i.summer freemeals pdonations, scale(freemeals)}{p_end}
{phang2}{cmd:. estimates store model1}{p_end}
{phang2}{cmd:. betareg prate i.summer freemeals pdonations, scale(freemeals) link(cloglog)}{p_end}
{phang2}{cmd:. estimates store model2}{p_end}
{phang2}{cmd:. betareg prate i.summer freemeals pdonations, scale(freemeals) slink(root)}{p_end}
{phang2}{cmd:. estimates store model3}{p_end}
{phang2}{cmd:. betareg prate i.summer freemeals pdonations, scale(freemeals) link(cloglog) slink(root)}{p_end}
{phang2}{cmd:. estimates store model4}{p_end}

{pstd}Display the coefficients, standard errors, and the BIC for each model{p_end}
{phang2}{cmd:. estimates table model1 model2 model3 model4, stats(bic) se vsquish}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sprogram, clear}{p_end}
{phang2}{cmd:. betareg prate i.summer freemeals pdonations, scale(freemeals) link(cloglog) slink(root) vce(robust)}{p_end}

{pstd}Estimate standard errors for a population average treatment effect{p_end}
{phang2}{cmd:. margins r.summer, contrast(nowald) vce(unconditional)}{p_end}

    {hline}
