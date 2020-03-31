{smcl}
{* *! version 1.0.12  19oct2017}{...}
{vieweralsosee "[R] margins postestimation" "mansection R marginspostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] margins" "help margins"}{...}
{vieweralsosee "[R] marginsplot" "help marginsplot"}{...}
{viewerjumpto "Postestimation commands" "margins postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "margins_postestimation##linkspdf"}{...}
{viewerjumpto "Examples" "margins postestimation##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[R] margins postestimation} {hline 2}}Postestimation tools for
margins{p_end}
{p2col:}({mansection R marginspostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following standard postestimation command is available after {cmd:margins}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
{synopt:{bf:{help marginsplot}}}graph the results from margins -- profile plots,
	interaction plots, etc.{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
The following standard postestimation commands are available after
{cmd:margins}{cmd:, post}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatsum
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_nlcom
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R marginspostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse margex}{p_end}
{phang2}{cmd:. logistic outcome sex##group age}{p_end}
{phang2}{cmd:. margins sex, post}

{pstd}Estimate a risk ratio of males to females, using the average
probabilities for males and females posted by {cmd:margins}{p_end}
{phang2}{cmd:. nlcom (_b[1.sex] / _b[0.sex])}

{pstd}Estimate the average risk difference between males and females{p_end}
{phang2}{cmd:. lincom (_b[1.sex] - _b[0.sex])}{p_end}
