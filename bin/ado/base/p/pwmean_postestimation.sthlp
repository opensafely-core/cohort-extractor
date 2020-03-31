{smcl}
{* *! version 1.0.7  19oct2017}{...}
{vieweralsosee "[R] pwmean postestimation" "mansection R pwmeanpostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pwmean" "help pwmean"}{...}
{viewerjumpto "Postestimation commands" "pwmean postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "pwmean_postestimation##linkspdf"}{...}
{viewerjumpto "Example" "pwmean postestimation##example"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[R] pwmean postestimation} {hline 2}}Postestimation tools for
pwmean{p_end}
{p2col:}({mansection R pwmeanpostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:pwmean}:

{synoptset 17}{...}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_estatvce
INCLUDE help post_estimates
INCLUDE help post_lincom
INCLUDE help post_nlcom
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R pwmeanpostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse yield}{p_end}

{pstd}Pairwise comparisons of the mean yields for each pair of
fertilizers{p_end}
{phang2}{cmd:. pwmean yield, over(fertilizer)}{p_end}

{pstd}Test whether the mean yield for fertilizer 4 is 10% larger than the 
mean yield for fertilizer 5{p_end}
{phang2}
{cmd:. testnl (_b[4.fertilizer] - _b[5.fertilizer])/_b[5.fertilizer] = 0.1}
{p_end}
