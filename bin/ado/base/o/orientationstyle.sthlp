{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] orientationstyle" "mansection G-4 orientationstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] textbox_options" "help textbox_options"}{...}
{viewerjumpto "Syntax" "orientationstyle##syntax"}{...}
{viewerjumpto "Description" "orientationstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "orientationstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "orientationstyle##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[G-4]} {it:orientationstyle} {hline 2}}Choices for orientation of textboxes{p_end}
{p2col:}({mansection G-4 orientationstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:orientationstyle}}Description{p_end}
{p2line}
{p2col:{cmd:horizontal}}text reads left to right{p_end}
{p2col:{cmd:vertical}}text reads bottom to top{p_end}
{p2col:{cmd:rhorizontal}}text reads left to right (upside down){p_end}
{p2col:{cmd:rvertical}}text reads top to bottom{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:orientationstyles} may be available; type

	    {cmd:.} {bf:{stata graph query orientationstyle}}

{pstd}
to obtain the complete list {it:orientationstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
A textbox contains one or more lines of text.  {it:orientationstyle} specifies
whether the textbox is horizontal or vertical.

{pstd}
{it:orientationstyle} is specified in the {cmd:orientation()} option nested
within another option, such as {cmd:title()}:

{phang2}
	{cmd:. graph} ...{cmd:, title("My title", orientation(}{it:orientationstyle}{cmd:))} ...

{pstd}
See {manhelpi textbox_options G-3} for more information on textboxes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 orientationstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{it:orientationstyle} specifies whether the text and box are oriented
horizontally or vertically, vertically including text reading from bottom
to top or from top to bottom.
{p_end}
