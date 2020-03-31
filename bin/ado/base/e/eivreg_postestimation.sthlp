{smcl}
{* *! version 1.2.4  30may2019}{...}
{viewerdialog predict "dialog cnsreg_p"}{...}
{vieweralsosee "[R] eivreg postestimation" "mansection R eivregpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] eivreg" "help eivreg"}{...}
{viewerjumpto "Postestimation commands" "eivreg postestimation##description"}{...}
{viewerjumpto "predict" "eivreg postestimation##syntax_predict"}{...}
{viewerjumpto "margins" "eivreg postestimation##syntax_margins"}{...}
{viewerjumpto "Example" "eivreg postestimation##example"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] eivreg postestimation} {hline 2}}Postestimation tools for eivreg{p_end}
{p2col:}({mansection R eivregpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {opt eivreg}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
{synopt:{helpb eivreg_postestimation##margins:margins}}marginal
	means, predictive margins, marginal effects, and average marginal
	effects{p_end}
INCLUDE help post_marginsplot
INCLUDE help post_nlcom
{synopt :{helpb eivreg postestimation##predict:predict}}linear predictions{p_end}
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker syntax_predict}{...}
{marker predict}{...}
{title:Syntax for predict}

{p 8 16 2}
{cmd:predict}
{dtype}
{newvar}
{ifin}

{phang}
Available both in and out of sample; type
{cmd:predict} {it:...} {cmd:if e(sample)} {it:...} if wanted only for the
estimation sample.{p_end}


INCLUDE help menu_predict


{marker des_predict}{...}
{title:Description for predict}

{pstd}
{cmd:predict} creates a new variable containing the linear prediction
assuming that values of the covariates used for the prediction were measured
without error.


{marker syntax_margins}{...}
{marker margins}{...}
{title:Syntax for margins}

{p 8 16 2}
{cmd:margins} [{it:{help margins##syntax:marginlist}}] 
[{cmd:,} {it:{help margins##syntax:options}}] 


INCLUDE help menu_margins


{marker des_margins}{...}
{title:Description for margins}

{pstd}
{cmd:margins} estimates margins of response for
linear predictions.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Fit regression in which {cmd:weight} and {cmd:mpg} are measured with
reliabilities .85 and .95{p_end}
{phang2}{cmd:. eivreg price weight foreign mpg, reliab(weight .85 mpg .95)}

{pstd}Calculate fitted values for estimation sample only{p_end}
{phang2}{cmd:. predict prhat if e(sample)}{p_end}
