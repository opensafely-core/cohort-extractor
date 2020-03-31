{smcl}
{* *! version 1.1.9  16apr2019}{...}
{vieweralsosee "[G-4] linewidthstyle" "mansection G-4 linewidthstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Concept: lines" "help lines"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] connectstyle" "help connectstyle"}{...}
{viewerjumpto "Syntax" "linewidthstyle##syntax"}{...}
{viewerjumpto "Description" "linewidthstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "linewidthstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "linewidthstyle##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-4]} {it:linewidthstyle} {hline 2}}Choices for thickness of lines{p_end}
{p2col:}({mansection G-4 linewidthstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:linewidthstyle}}Description{p_end}
{p2line}
{p2col:{cmd:none}}line has zero width; it vanishes{p_end}
{p2col:{cmd:vvthin}}thinnest{p_end}
{p2col:{cmd:vthin}}{p_end}
{p2col:{cmd:thin}}{p_end}
{p2col:{cmd:medthin}}{p_end}
{p2col:{cmd:medium}}{p_end}
{p2col:{cmd:medthick}}{p_end}
{p2col:{cmd:thick}}{p_end}
{p2col:{cmd:vthick}}{p_end}
{p2col:{cmd:vvthick}}{p_end}
{p2col:{cmd:vvvthick}}thickest{p_end}
{p2col:{it:{help size}}}any size you want{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:linewidthstyles} may be available; type

	     {cmd:.} {bf:{stata graph query linewidthstyle}}

{pstd}
to obtain the full list installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
A line's look is determined by its pattern, thickness, alignment, and color;
see {help lines}.  {it:linewidthstyle} specifies the line's thickness.

{pstd}
{it:linewidthstyle} is specified via options named

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:width()}

{pstd}
or, just

	<{cmd:l} or {cmd:li} or {cmd:line}>{cmd:width()}

{pstd}
For instance, for connecting lines (the lines used to connect
points in a plot) used by {cmd:graph} {cmd:twoway} {cmd:function}, the option
is named {cmd:lwidth}():

{phang2}
	{cmd:. twoway function} ...{cmd:, lwidth(}{it:linewidthstyle}{cmd:)} ...

{pstd}
Sometimes you will see that a {it:linewidthstylelist} is allowed:

{phang2}
	{cmd:. twoway line} ...{cmd:, lwidth(}{it:linewidthstylelist}{cmd:)} ...

{pstd}
A {it:linewidthstylelist} is a sequence of {it:linewidths} separated by
spaces.  Shorthands are allowed to make specifying the list easier;
see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 linewidthstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
If you specify the line width as {cmd:none}, the line will vanish.
{p_end}
