{smcl}
{* *! version 1.1.7  15may2018}{...}
{vieweralsosee "[G-4] axisstyle" "mansection G-4 axisstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] ticksetstyle" "help ticksetstyle"}{...}
{vieweralsosee "[G-4] tickstyle" "help tickstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "help scheme files" "help scheme_files"}{...}
{viewerjumpto "Syntax" "axisstyle##syntax"}{...}
{viewerjumpto "Description" "axisstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "axisstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "axisstyle##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-4]} {it:axisstyle} {hline 2}}Choices for overall look of axes{p_end}
{p2col:}({mansection G-4 axisstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:textstyle}}Description{p_end}
{p2line}
{p2col:{cmd:horizontal_default}}default standard horizontal axis{p_end}
{p2col:{cmd:horizontal_notick}}default horizontal axis without ticks{p_end}
{p2col:{cmd:horizontal_nogrid}}default horizontal axis without gridlines{p_end}
{p2col:{cmd:horizontal_withgrid}}default horizontal axis with gridlines{p_end}
{p2col:{cmd:horizontal_noline}}default horizontal axis without an axis
    line{p_end}
{p2col:{cmd:horizontal_nolinetick}}default horizontal axis with neither
    an axis line nor ticks{p_end}

{p2col:{cmd:vertical_default}}default standard vertical axis{p_end}
{p2col:{cmd:vertical_notick}}default vertical axis without ticks{p_end}
{p2col:{cmd:vertical_nogrid}}default vertical axis without gridlines{p_end}
{p2col:{cmd:vertical_withgrid}}default vertical axis with gridlines{p_end}
{p2col:{cmd:vertical_noline}}default vertical axis without an axis
    line{p_end}
{p2col:{cmd:vertical_nolinetick}}default vertical axis with neither
    an axis line nor ticks{p_end}
{p2line}
{p2colreset}{...}

{p 4 4 2}
Other {it:axisstyles} may be available; type

	    {cmd:.} {bf:{stata graph query axisstyle}}

{p 4 4 2}
to obtain the complete list of {it:axisstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
Axis styles are used only in scheme files (see
{help scheme files}) and are not accessible from {helpb graph}
commands.  You would rarely want to change axis styles.

{pstd}
{it:axisstyle} is a composite style that holds and sets all attributes of an
axis, including the look of ticks and tick labels (see
{manhelpi ticksetstyle G-4})
for that axis's major and minor labeled ticks and major and minor unlabeled
ticks, the axis line style (see {manhelpi linestyle G-4}), rules for whether the
axis extends through the plot region margin (both at the low and high end of
the scale), whether grids are drawn for each of the labeled and unlabeled
major and minor ticks, the gap between the tick labels and axis title, and any
extra space beyond the axis title.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 axisstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
When changing the look of an axis in a {help scheme_files:scheme file}, you 
would rarely want to change the {it:axisstyle} entries.  Instead, you should
change the entries for the individual components making up the axis style.
{p_end}
