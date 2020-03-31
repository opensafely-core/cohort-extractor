{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[G-4] textstyle" "mansection G-4 textstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] marker_label_options" "help marker_label_options"}{...}
{vieweralsosee "[G-4] text" "help text"}{...}
{vieweralsosee "[G-4] textboxstyle" "help textboxstyle"}{...}
{viewerjumpto "Syntax" "textstyle##syntax"}{...}
{viewerjumpto "Description" "textstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "textstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "textstyle##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-4]} {it:textstyle} {hline 2}}Choices for the overall look of text{p_end}
{p2col:}({mansection G-4 textstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:textstyle}}Description{p_end}
{p2line}
{p2col:{cmd:heading}}large text suitable for headings; default used by
    {cmd:title()}{p_end}
{p2col:{cmd:subheading}}medium text suitable for subheadings;
    default used by {cmd:subtitle()}{p_end}
{p2col:{cmd:body}}medium-sized text; default used by {cmd:caption()}{p_end}
{p2col:{cmd:small_body}}small text; default used by {cmd:note()}{p_end}

{p2col:{cmd:axis_title}}default for axis titles{p_end}

{p2col:{cmd:label}}text suitable for labeling{p_end}
{p2col:{cmd:key_label}}default used to label keys in legends{p_end}
{p2col:{cmd:small_label}}default used to label points{p_end}
{p2col:{cmd:tick_label}}default used to label major ticks{p_end}
{p2col:{cmd:minor_ticklabel}}default used to label minor ticks{p_end}
{* p1-p15 intentionally not documented}{...}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:textstyles} may be available; type

	    {cmd:.} {bf:{stata graph query textboxstyle}}      {it:(sic)}

{pstd}
to obtain the complete list of {it:textstyles} installed on your computer.
The {it:textstyle} list is the same as the {it:textboxstyle} list.


{marker description}{...}
{title:Description}

{pstd}
{it:textstyle} specifies the overall look of single lines of text.
{it:textstyle} is specified in options such as the marker-label option
{cmd:mltextstyle()} (see {manhelpi marker_label_options G-3}):

{p 6 16 2}
{cmd:. twoway scatter}
...{cmd:, mlabel(...) mltextstyle(}{it:textstylelist}{cmd:)} ...

{pstd}
In the example above, a {it:textstylelist} is allowed.  A {it:textstylelist}
is a sequence of {it:textstyles} separated by spaces.  Shorthands are allowed
to make specifying the list easier; see {manhelpi stylelists G-4}.

{pstd}
A {it:textstyle} is in fact a {it:textboxstyle}, but only a
subset of the attributes of the textbox matter; see 
{manhelpi textboxstyle G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 textstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help textstyle##remarks1:What is text?}
	{help textstyle##remarks2:What is a textstyle?}
	{help textstyle##remarks3:You do not need to specify a textstyle}
	{help textstyle##remarks4:Relationship between textstyles and textboxstyles}


{marker remarks1}{...}
{title:What is text?}

{pstd}
Text is one line of text.


{marker remarks2}{...}
{title:What is a textstyle?}

{pstd}
How text appears is defined by five attributes:

{phang2}
    1.  Whether the text is vertical or horizontal;
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

{pstd}
The {it:textstyle} specifies these five attributes.


{marker remarks3}{...}
{title:You do not need to specify a textstyle}

{pstd}
The {it:textstyle} is specified in options such as

	{cmd:mltextstyle(}{it:textstyle}{cmd:)}

{pstd}
Correspondingly, you will find other options are available for setting
each attribute above; see 
{manhelpi marker_label_options G-3}.

{pstd}
You specify the {it:textstyle} when a style exists that is exactly what
you desire or when another style would allow you to specify fewer
changes to obtain what you want.


{* index text and textboxes, relationship between}{...}
{marker remarks4}{...}
{title:Relationship between textstyles and textboxstyles}

{pstd}
{it:textstyles} are in fact a subset of the attributes of {it:textboxstyles};
see {manhelpi textboxstyle G-4}.  A textbox allows multiple lines, has 
an optional border around it, has a background
color, and more.  By comparison, text is just a line of
text, and {it:textstyle} is the overall style of that single line.

{pstd}
Most textual graphical elements are textboxes, but there are a few simple
graphical elements that are merely text, such as the marker labels mentioned
above.  The {cmd:mltextstyle(}{it:textstyle}{cmd:)} option really should be
documented as {cmd:mltextstyle(}{it:textboxstyle}{cmd:)} because it is in fact
a {it:textboxstyle} that {cmd:mltextstyle()} accepts.  When
{cmd:mltextstyle()} processes the {it:textboxstyle}, however, it looks only at
the five attributes listed above and ignores the other attributes
{it:textboxstyle} defines.
{p_end}
