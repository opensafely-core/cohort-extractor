{smcl}
{* *! version 1.0.3  15may2018}{...}
{vieweralsosee "[G-4] linealignmentstyle" "mansection G-4 linealignmentstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Concept: lines" "help lines"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] connectstyle" "help connectstyle"}{...}
{viewerjumpto "Syntax" "linealignmentstyle##syntax"}{...}
{viewerjumpto "Description" "linealignmentstyle##description"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[G-4]} {it:linealignmentstyle} {hline 2}}Choices for whether
outlines are inside, outside, or centered{p_end}
{p2col:}({mansection G-4 linealignmentstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:linealignmentstyle}}Description{p_end}
{p2line}
{p2col:{cmd:inside}}line is inside the outline{p_end}
{p2col:{cmd:outside}}line is outside the outline{p_end}
{p2col:{cmd:center}}line is centered on the outline{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:linealignmentstyles} may be available; type

	    {cmd:.} {bf:{stata graph query linealignmentstyle}}

{pstd}
to obtain the full list installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
The look of a border or outline for markers, fill areas, bars, and boxes
is determined by its pattern, thickness, alignment, and color.
{it:linealignmentstyle} specifies the alignment.

{pstd}
{it:linealignmentstyle} is specified via options named

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:align()}

{pstd}
or

	<{cmd:l} or {cmd:li} or {cmd:line}>{cmd:align()}

{pstd}
For instance, for the bars used by {cmd:graph} {cmd:twoway} {cmd:histogram},
the option is named {cmd:lalign()}:

{phang2}
	{cmd:. twoway histogram} ...{cmd:, lalign(}{it:linealignmentstyle}{cmd:)} ...
{p_end}
