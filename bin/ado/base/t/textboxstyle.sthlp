{smcl}
{* *! version 1.1.8  16apr2019}{...}
{vieweralsosee "[G-4] textboxstyle" "mansection G-4 textboxstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] textbox_options" "help textbox_options"}{...}
{vieweralsosee "[G-4] text" "help text"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] textstyle" "help textstyle"}{...}
{viewerjumpto "Syntax" "textboxstyle##syntax"}{...}
{viewerjumpto "Description" "textboxstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "textboxstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "textboxstyle##remarks"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-4]} {it:textboxstyle} {hline 2}}Choices for the overall look of text including border{p_end}
{p2col:}({mansection G-4 textboxstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:textboxstyle}}Description{p_end}
{p2line}
{p2col:{cmd:heading}}large text suitable for headings{p_end}
{p2col:{cmd:subheading}}medium text suitable for subheadings{p_end}
{p2col:{cmd:body}}medium text{p_end}
{p2col:{cmd:smbody}}small text{p_end}
{* p1-p15 intentionally not documented}{...}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:textboxstyles} may be available; type

	    {cmd:.} {bf:{stata graph query textboxstyle}}

{pstd}
to obtain the complete list of {it:textboxstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
A textbox contains one or more lines of text.  {it:textboxstyle} specifies the
overall style of the textbox.

{pstd}
{it:textboxstyle} is specified in the {cmd:style()} option nested within
another option, such as {cmd:title()}:

{phang2}
	{cmd:. graph} ...{cmd:, title("My title", style(}{it:textboxstyle}{cmd:))} ...

{pstd}
See {manhelpi textbox_options G-3} for more information on textboxes.

{pstd}
Sometimes you will see that a {it:textboxstylelist} is allowed.  A
{it:textboxstylelist} is a sequence of {it:textboxstyles} separated by spaces.
Shorthands are allowed to make specifying the list easier; see
{manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 textboxstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help textboxstyle##remarks1:What is a textbox?}
	{help textboxstyle##remarks2:What is a textboxstyle?}
	{help textboxstyle##remarks3:You do not need to specify a textboxstyle}


{marker remarks1}{...}
{title:What is a textbox?}

{pstd}
A textbox is one or more lines of text that may or may not have a border
around it.


{marker remarks2}{...}
{title:What is a textboxstyle?}

{pstd}
Textboxes are defined by 11 attributes:

{phang2}
    1.  Whether the textbox is vertical or horizontal;
	see {manhelpi orientationstyle G-4}

{phang2}
    2.  The size of the text;
	see {manhelpi textsizestyle G-4}

{phang2}
    3.  The color of the text;
	see {manhelpi colorstyle G-4}

{phang2}
    4.  Whether the text is left-justified, centered, or right-justified;
	see {manhelpi justificationstyle G-4}

{phang2}
    5.  How the text aligns with the baseline;
	see {manhelpi alignmentstyle G-4}

{phang2}
    6.  The margin from the text to the border;
	see {manhelpi marginstyle G-4}

{phang2}
    7.  The gap between lines;
	see {manhelpi size G-4}

{phang2}
    8.  Whether a border is drawn around the box, and if so

{phang3}
	a.  The color of the background;
	    see {manhelpi colorstyle G-4}

{phang3}
	b.  The overall style of the line used to draw the border,
	    which includes its color, width, and whether solid or dashed,
	    etc.; see {manhelpi linestyle G-4}

{phang2}
    9.  The margin from the border outward;
	see {manhelpi marginstyle G-4}

{p 7 12 2}
   10.  Whether the box is to expand to fill the box in which it is placed

{p 7 12 2}
   11.  Whether the box is to be shifted when placed on the graph;
	see {manhelpi compassdirstyle G-4}

{pstd}
The {it:textboxstyle} specifies all 11 of these attributes.


{marker remarks3}{...}
{title:You do not need to specify a textboxstyle}

{pstd}
The {it:textboxstyle} is specified in option

	{cmd:tstyle(}{it:textboxstyle}{cmd:)}

{pstd}
Correspondingly, you will find other options are available for setting
each attribute above; see {manhelpi textbox_options G-3}.

{pstd}
You specify the {it:textboxstyle} when a style exists that is exactly what
you desire or when another style would allow you to specify fewer
changes to obtain what you want.
{p_end}
