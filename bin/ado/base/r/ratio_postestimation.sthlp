{smcl}
{* *! version 1.1.9  23jan2019}{...}
{vieweralsosee "[R] ratio postestimation" "mansection R ratiopostestimation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ratio" "help ratio"}{...}
{viewerjumpto "Postestimation commands" "ratio postestimation##description"}{...}
{viewerjumpto "Links to PDF documentation" "ratio_postestimation##linkspdf"}{...}
{viewerjumpto "Examples" "ratio postestimation##examples"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[R] ratio postestimation} {hline 2}}Postestimation tools for ratio{p_end}
{p2col:}({mansection R ratiopostestimation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Postestimation commands}

{pstd}
The following postestimation commands are available after {cmd:ratio}:

{synoptset 11}
{p2coldent :Command}Description{p_end}
{synoptline}
INCLUDE help post_contrast
INCLUDE help post_estatvce
INCLUDE help post_svy_estat
INCLUDE help post_estimates
INCLUDE help post_lincom
{synopt :{helpb marginsplot}}graph the results from ratio{p_end}
INCLUDE help post_nlcom
INCLUDE help post_pwcompare
INCLUDE help post_test
INCLUDE help post_testnl
{synoptline}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R ratiopostestimationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. webuse fuel}{p_end}
{phang2}{cmd:. ratio myratio: mpg1/mpg2}{p_end}

{pstd}Test if ratio is significantly different from 1{p_end}
{phang2}{cmd:. test _b[myratio] = 1}

    {hline}
    Setup
{phang2}{cmd:. webuse census2}{p_end}
{phang2}{cmd:. ratio (deathrate: death/pop) (marrate: marriage/pop)}{p_end}

{pstd}Test whether marriage rate equals death rate{p_end}
{phang2}{cmd:. test _b[deathrate] = _b[marrate]}{p_end}
    {hline}
