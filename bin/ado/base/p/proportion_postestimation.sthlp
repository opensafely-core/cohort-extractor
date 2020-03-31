{smcl}
{* *! version 1.1.9  27dec2018}{...}
{vieweralsosee "[R] proportion postestimation" "mansection R proportionpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] proportion" "help proportion"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SVY] svy postestimation" "help svy_postestimation"}{...}
{viewerjumpto "Postestimation commands" "proportion postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "proportion_postestimation##linkspdf"}{...}
{viewerjumpto "Example" "proportion postestimation##example"}{...}
{p2colset 1 34 36 2}{...}
{p2col:{bf:[R] proportion postestimation} {hline 2}}Postestimation tools for proportion{p_end}
{p2col:}({mansection R proportionpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:proportion}:

{synoptset 11}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_lincom
{synopt :{helpb marginsplot}}graph the results from proportion{p_end}
INCLUDE help post_nlcom
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R proportionpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. proportion rep78, over(foreign)}{p_end}

{pstd}Test whether the proportions of cars having a repair record of 4 
({cmd:rep78=4}) is the same for {cmd:Domestic} and {cmd:Foreign} cars{p_end}
{phang2}{cmd:. contrast r.foreign@4.rep78}{p_end}
