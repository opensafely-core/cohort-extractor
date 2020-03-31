{smcl}
{* *! version 1.2.5  23oct2017}{...}
{viewerdialog predict "dialog xtdpd_p"}{...}
{viewerdialog estat "dialog xtdpd_estat"}{...}
{vieweralsosee "[XT] xtdpd postestimation" "mansection XT xtdpdpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtdpd" "help xtdpd"}{...}
{viewerjumpto "Postestimation commands" "xtdpd postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtdpd_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtdpd postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtdpd postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "xtdpd postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "xtdpd postestimation##examples"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[XT] xtdpd postestimation} {hline 2}}Postestimation tools for xtdpd{p_end}
{p2col:}({mansection XT xtdpdpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after 
{cmd:xtdpd}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb xtdpd postestimation##estatabond:estat abond}}test for
autocorrelation{p_end}
{synopt :{helpb xtdpd postestimation##estatsargan:estat sargan}}Sargan test of
overidentifying restrictions{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are also available:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_forecast
INCLUDE help post_hausman
INCLUDE help post_lincom
{synopt:{helpb xtdpd_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb xtdpd postestimation##predict:predict}}predictions, residuals,
 influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtdpdpostestimationRemarksandexamples:Remarks and examples}

        {mansection XT xtdpdpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


INCLUDE help xtdpd_predict


INCLUDE help xtdpd_margins


INCLUDE help xtdpd_estat


INCLUDE help xtdpd_postspecial2c


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse abdata}{p_end}

{pstd}Fit a model and obtain default AR tests{p_end}
{phang2}{cmd:. xtdpd l(0/1).(n w), dgmmiv(n) lgmmiv(n) div(w) vce(robust)}{p_end}
{phang2}{cmd:. estat abond}{p_end}

{pstd}Request a higher order than originally computed{p_end}
{phang2}{cmd:. estat abond, artests(3)}{p_end}

{pstd}Compute the linear prediction for the levels{p_end}
{phang2}{cmd:. predict xb, xb}

{pstd}Compute the residuals for the first differences{p_end}
{phang2}{cmd:. predict de, e difference}

{pstd}Test a linear hypothesis{p_end}
{phang2}{cmd:. test w = 0}{p_end}
