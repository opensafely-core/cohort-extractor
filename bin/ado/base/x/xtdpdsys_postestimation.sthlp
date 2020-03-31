{smcl}
{* *! version 1.2.7  23oct2017}{...}
{viewerdialog predict "dialog xtdpd_p"}{...}
{viewerdialog estat "dialog xtdpd_estat"}{...}
{vieweralsosee "[XT] xtdpdsys postestimation" "mansection XT xtdpdsyspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtdpdsys" "help xtdpdsys"}{...}
{viewerjumpto "Postestimation commands" "xtdpdsys postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtdpdsys_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtdpdsys postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtdpdsys postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "xtdpdsys postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "xtdpdsys postestimation##examples"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[XT] xtdpdsys postestimation} {hline 2}}Postestimation tools for xtdpdsys{p_end}
{p2col:}({mansection XT xtdpdsyspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after 
{cmd:xtdpdsys}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb xtdpdsys postestimation##estatabond:estat abond}}test for
autocorrelation{p_end}
{synopt :{helpb xtdpdsys postestimation##estatsargan:estat sargan}}Sargan test
of overidentifying restrictions{p_end}
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
{synopt:{helpb xtdpdsys_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb xtdpdsys postestimation##predict:predict}}predictions, residuals,
 influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtdpdsyspostestimationRemarksandexamples:Remarks and examples}

        {mansection XT xtdpdsyspostestimationMethodsandformulas:Methods and formulas}

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
{phang2}{cmd:. xtdpdsys n w k, vce(robust)}{p_end}

{pstd}Obtain default AR tests{p_end}
{phang2}{cmd:. estat abond}{p_end}

{pstd}Request a higher order than originally computed{p_end}
{phang2}{cmd:. estat abond, artests(3)}{p_end}

{pstd}Obtain the Sargan test{p_end}
{phang2}{cmd:. estat sargan}{p_end}

{pstd}Compute the linear prediction{p_end}
{phang2}{cmd:. predict nhat, xb}

{pstd}Test that the coefficients on the first difference of {cmd:w} and the
lagged first difference of {cmd:w} are jointly zero{p_end}
{phang2}{cmd:. test w = 0, notest}{p_end}
{phang2}{cmd:. test k = 0, accumulate}{p_end}
