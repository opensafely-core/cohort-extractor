{smcl}
{* *! version 1.0.7  19oct2017}{...}
{vieweralsosee "[R] pwcompare postestimation" "mansection R pwcomparepostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] pwcompare" "help pwcompare"}{...}
{viewerjumpto "Postestimation commands" "pwcompare postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "pwcompare_postestimation##linkspdf"}{...}
{viewerjumpto "Example" "pwcompare postestimation##example"}{...}
{p2colset 1 33 35 2}{...}
{p2col:{bf:[R] pwcompare postestimation} {hline 2}}Postestimation tools for
pwcompare{p_end}
{p2col:}({mansection R pwcomparepostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are 
available after {cmd:pwcompare}{cmd:, post}:

{synoptset 17}{...}
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

        {mansection R pwcomparepostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Setup for a one-way model{p_end}
{phang2}{cmd:. webuse yield}{p_end}
{phang2}{cmd:. regress yield i.fertilizer}{p_end}

{pstd}Mean yield for each fertilizer{p_end}
{phang2}{cmd:. pwcompare fertilizer, cimargins post}{p_end}

{pstd}Percent improvement in mean yield for fertilizer 2 compared with
fertilizer 1{p_end}
{phang2}
{cmd:. nlcom 100*(_b[2.fertilizer] - _b[1.fertilizer])/_b[1.fertilizer]}{p_end}
