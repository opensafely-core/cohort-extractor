{smcl}
{* *! version 1.2.5  23oct2017}{...}
{viewerdialog predict "dialog xtdpd_p"}{...}
{viewerdialog estat "dialog xtdpd_estat"}{...}
{vieweralsosee "[XT] xtabond postestimation" "mansection XT xtabondpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtabond" "help xtabond"}{...}
{viewerjumpto "Postestimation commands" "xtabond postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtabond_postestimation##linkspdf"}{...}
{viewerjumpto "predict" "xtabond postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "xtabond postestimation##syntax_margins"}{...}
{viewerjumpto "estat" "xtabond postestimation##syntax_estat"}{...}
{viewerjumpto "Examples" "xtabond postestimation##examples"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[XT] xtabond postestimation} {hline 2}}Postestimation tools for xtabond{p_end}
{p2col:}({mansection XT xtabondpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are of special interest after 
{cmd:xtabond}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt :{helpb xtabond postestimation##estatabond:estat abond}}test for
autocorrelation{p_end}
{synopt :{helpb xtabond postestimation##estatsargan:estat sargan}}Sargan test
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
{synopt:{helpb xtabond_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{p2col :{helpb xtabond postestimation##predict:predict}}predictions, residuals,
 influence statistics, and other diagnostic measures{p_end}
INCLUDE help post_predictnl
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtabondpostestimationRemarksandexamples:Remarks and examples}

        {mansection XT xtabondpostestimationMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.



INCLUDE help xtdpd_predict


INCLUDE help xtdpd_margins


INCLUDE help xtdpd_estat


INCLUDE help xtdpd_postspecial2b


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse abdata}{p_end}

{pstd}Fit a model and obtain default AR tests{p_end}
{phang2}{cmd:. xtabond n w k, twostep}{p_end}
{phang2}{cmd:. estat abond}{p_end}

{pstd}Request a higher order than originally computed{p_end}
{phang2}{cmd:. estat abond, artests(3)}{p_end}

{pstd}Obtain the Sargan test{p_end}
{phang2}{cmd:. estat sargan}{p_end}

{pstd}Compute the linear prediction{p_end}
{phang2}{cmd:. predict nhat, xb}

{pstd}Fit a model including both {cmd:w} and the first lag of {cmd:w} as
regressors, obtaining a Windmeijer-corrected robust VCE, and then test
the joint significance of {cmd:w} and {cmd:L.w}{p_end}
{phang2}{cmd:. xtabond n L(0/1).w k, twostep vce(robust)}{p_end}
{phang2}{cmd:. test w = 0, notest}{p_end}
{phang2}{cmd:. test L.w = 0, accumulate}{p_end}
