{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] legendstyle" "mansection G-4 legendstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] legend_options" "help legend_options"}{...}
{viewerjumpto "Syntax" "legendstyle##syntax"}{...}
{viewerjumpto "Description" "legendstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "legendstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "legendstyle##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-4]} {it:legendstyle} {hline 2}}Choices for look of legends{p_end}
{p2col:}({mansection G-4 legendstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:legendstyle}}Description{p_end}
{p2line}
{p2col:{cmd:default}}determined by scheme{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:legendstyles} may be available; type

	    {cmd:.} {bf:{stata graph query legendstyle}}

{pstd}
to obtain the complete list of {it:legendstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
{it:legendstyle} specifies the
overall style of legends
and
is specified in the {cmd:legend(style())} option:

{phang2}
	{cmd:. graph} ...{cmd:, legend(} ... {cmd:style(}{it:legendstyle}{cmd:)} ...{cmd:)}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 legendstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help legendstyle##remarks1:What is a legend?}
	{help legendstyle##remarks2:What is a legendstyle?}
	{help legendstyle##remarks3:You do not need to specify a legendstyle}


{marker remarks1}{...}
{title:What is a legend?}

{pstd}
A legend is a table that shows the symbols used in a graph along with text
describing their meaning.  Each symbol/text entry in a legend is called a key.
See {manhelpi legend_options G-3} for more information.


{marker remarks2}{...}
{title:What is a legendstyle?}

{pstd}
The look of a legend is defined by 14 attributes:

{phang2}
    1.  The number of columns or rows of the table

{phang2}
    2.  Whether, in a multicolumn table, the first, second, ..., keys
	appear across the rows or down the columns

{phang2}
    3.  Whether the symbol/text of a key appears horizontally adjacent
	or vertically stacked

{phang2}
    4.  The gap between lines of the legend

{phang2}
    5.  The gap between columns of the legend

{phang2}
    6.  How the symbol of a key is aligned and justified

{phang2}
    7.  The gap between the symbol and text of a key

{phang2}
    8.  The height to be allocated in the table for the symbol of the key

{phang2}
    9.  The width to be allocated in the table for the symbol of the key

{p 7 12 2}
   10.  The width to be allocated in the table for the text of the key

{p 7 12 2}
   11.  Whether the above-specified height and width are to be
	dynamically adjusted according to contents of the keys

{p 7 12 2}
   12.  The margin around the legend

{p 7 12 2}
   13.  The color, size, etc., of the text of a key (17 features)

{p 7 12 2}
   14.  The look of any titles, subtitles, notes, and captions
	placed around the table (23 characteristics each)

{pstd}
The {it:legendstyle} specifies all 14 of these attributes.


{marker remarks3}{...}
{title:You do not need to specify a legendstyle}

{pstd}
The {it:legendstyle} is specified in the option

	{cmd:legend(style(}{it:legendstyle}{cmd:))}

{pstd}
Correspondingly, option {cmd:legend()} has other suboptions that will
allow you to specify the 14 attributes individually; see
{it:{help legend_options}}.

{pstd}
Specify the {it:legendstyle} when a style exists that is exactly what
you desire or when another style would allow you to specify fewer changes
to obtain what you want.
{p_end}
