{smcl}
{* *! version 1.0.8  19oct2017}{...}
{vieweralsosee "[R] contrast postestimation" "mansection R contrastpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] contrast" "help contrast"}{...}
{viewerjumpto "Postestimation commands" "contrast postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "contrast_postestimation##linkspdf"}{...}
{viewerjumpto "Example" "contrast postestimation##example"}{...}
{p2colset 1 32 34 2}{...}
{p2col:{bf:[R] contrast postestimation} {hline 2}}Postestimation tools for
contrast{p_end}
{p2col:}({mansection R contrastpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are 
available after {cmd:contrast}{cmd:, post}:

{synoptset 13}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_nlcom
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R contrastpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse cholesterol}{p_end}
{phang2}{cmd:. anova chol agegrp}{p_end}
{phang2}{cmd:. contrast p.agegrp, post}

{pstd}Test whether the quadratic, cubic, and quartic effects are 
jointly zero{p_end}
{phang2}{cmd:. test p2.agegrp p3.agegrp p4.agegrp}{p_end}
