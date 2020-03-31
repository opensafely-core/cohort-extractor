{smcl}
{* *! version 1.1.7  16apr2019}{...}
{vieweralsosee "[G-4] tickstyle" "mansection G-4 tickstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_label_options" "help axis_label_options"}{...}
{viewerjumpto "Syntax" "tickstyle##syntax"}{...}
{viewerjumpto "Description" "tickstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "tickstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "tickstyle##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-4]} {it:tickstyle} {hline 2}}Choices for the overall look of axis ticks and axis tick labels{p_end}
{p2col:}({mansection G-4 tickstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:tickstyle}}Description{p_end}
{p2line}
{p2col:{cmd:major}}major tick and major tick label{p_end}
{p2col:{cmd:major_nolabel}}major tick with no tick label{p_end}
{p2col:{cmd:major_notick}}major tick label with no tick{p_end}

{p2col:{cmd:minor}}minor tick and minor tick label{p_end}
{p2col:{cmd:minor_nolabel}}minor tick with no tick label{p_end}
{p2col:{cmd:minor_notick}}minor tick label with no tick{p_end}

{p2col:{cmd:none}}no tick, no tick label{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:tickstyles} may be available; type

	    {cmd:.} {bf:{stata graph query tickstyle}}

{pstd}
to obtain the complete list of {it:tickstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
Ticks are the marks that appear on axes.  {it:tickstyle} specifies the
overall look of ticks.  See {manhelpi axis_label_options G-3}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 tickstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help tickstyle##remarks1:What is a tick?  What is a tick label?}
	{help tickstyle##remarks2:What is a tickstyle?}
	{help tickstyle##remarks3:You do not need to specify a tickstyle}
	{help tickstyle##remarks4:Suppressing ticks and/or tick labels}


{* index tick, definition}{...}
{marker remarks1}{...}
{title:What is a tick?  What is a tick label?}

{pstd}
A tick is the small line that extends or crosses an axis and next to which,
sometimes, numbers are placed.

{pstd}
A tick label is the text (typically a number) that optionally appears beside
the tick.


{marker remarks2}{...}
{title:What is a tickstyle?}

{pstd}
{it:tickstyle} is really misnamed; it ought to be called a
{it:tick_and_tick_label_style} in that it controls both the look of ticks and
their labels.

{pstd}
Ticks are defined by three attributes:

{phang2}
    1.  The length of the tick;
	see {manhelpi size G-4}

{phang2}
    2.  Whether the tick extends out, extends in, or crosses the axis

{phang2}
    3.  The line style of the tick, including its thickness, color,
	and whether it is to be solid, dashed, etc.;
	see {manhelpi linestyle G-4}

{pstd}
Labels are defined by two attributes:

{phang2}
    1.  The size of the text

{phang2}
    2.  The color of the text

{pstd}
Ticks and tick labels share one more attribute:

{phang2}
    1.  The gap between the tick and the tick label

{pstd}
The {it:tickstyle} specifies all six of these attributes.


{marker remarks3}{...}
{title:You do not need to specify a tickstyle}

{pstd}
The {it:tickstyle} is specified in the options named

	{c -(}{...}
{cmd:y}|{cmd:x}{...}
{c )-}{...}
{c -(}{...}
{cmd:label}|{cmd:tick}|{cmd:mlabel}|{cmd:mtick}{...}
{c )-}{...}
{cmd:(tstyle(}{it:tickstyle}{cmd:))}

{pstd}
Correspondingly, there are other
{c -(}{cmd:y}|{cmd:x}{c )-}{c -(}{cmd:label}|{cmd:tick}|{cmd:mlabel}|{cmd:mtick}{c )-}{cmd:()}
suboptions that allow you to specify the individual attributes;
see {manhelpi axis_label_options G-3}.

{pstd}
You specify the {it:tickstyle} when a style exists that is exactly what you
desire or when another style would allow you to specify fewer changes to
obtain what you want.


{* grid lines, without ticks}{...}
{* ticks, suppressing}{...}
{marker remarks4}{...}
{title:Suppressing ticks and/or tick labels}

{pstd}
To suppress the ticks that usually appear, specify one of these
styles

{p2colset 9 36 38 2}{...}
{p2col:{it:tickstyle}}Description{p_end}
{p2line}
{p2col:{cmd:major_nolabel}}major tick with no tick label{p_end}
{p2col:{cmd:major_notick}}major tick label with no tick{p_end}

{p2col:{cmd:minor_nolabel}}minor tick with no tick label{p_end}
{p2col:{cmd:minor_notick}}minor tick label with no tick{p_end}

{p2col:{cmd:none}}no tick, no tick label{p_end}
{p2line}
{p2colreset}{...}

{phang}
For instance, you might type

{phang2}
	{cmd:. scatter} .... {cmd:, ylabel(,tstyle(major_notick))}

{pstd}
Suppressing the ticks can be useful when you are creating special effects.  For
instance, consider a case where you wish to add grid lines to a graph at
{it:y} = 10, 20, 30, and 40, but you do not want ticks or labels at those
values.  Moreover, you do not want even to interfere with the ordinary ticking
or labeling of the graph.  The solution is

{phang2}
	{cmd:. scatter} ...{cmd:, ymtick(10(10)40, grid tstyle(none))}

{pstd}
We "borrowed" the {cmd:ymtick()} option and changed it so that it did not
output ticks.  We could just as well have borrowed the {cmd:ytick()} option.
See {manhelpi axis_label_options G-3}.
{p_end}
