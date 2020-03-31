{smcl}
{* *! version 1.1.12  10oct2019}{...}
{vieweralsosee "[G-4] markerlabelstyle" "mansection G-4 markerlabelstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] marker_label_options" "help marker_label_options"}{...}
{viewerjumpto "Syntax" "markerlabelstyle##syntax"}{...}
{viewerjumpto "Description" "markerlabelstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "markerlabelstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "markerlabelstyle##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[G-4]} {it:markerlabelstyle} {hline 2}}Choices for overall look of marker labels{p_end}
{p2col:}({mansection G-4 markerlabelstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:markerlabelstyle}}Description{p_end}
{p2line}
{p2col:{cmd:p1} - {cmd:p15}}used by first to fifteenth plot{p_end}
{p2col:{cmd:p1box} - {cmd:p15box}}used by first to fifteenth "box" plot{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:markerlabelstyles} may be available; type

	    {cmd:.} {bf:{stata graph query markerlabelstyle}}

{pstd}
to obtain the complete list of {it:markerlabelstyles} installed on your
computer.


{marker description}{...}
{title:Description}

{pstd}
{it:markerlabelstyle} defines the position, gap, angle, size, and color of
the marker label.  See {manhelpi marker_label_options G-3} for more
information.

{pstd}
{it:markerlabelstyle} is specified in the {cmd:mlabstyle()} option,

{phang2}
	{cmd:. graph} ...{cmd:, mlabstyle(}{it:markerlabelstyle}{cmd:)} ...

{pstd}
Sometimes (for example, with {cmd:twoway} {cmd:scatter}), a
{it:markerlabelstylelist} is allowed:  a {it:markerlabelstylelist} is a
sequence of {it:markerlabelstyles} separated by spaces.  Shorthands are
allowed to make specifying the list easier; see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 markerlabelstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help markerlabelstyle##remarks1:What is a markerlabel?}
	{help markerlabelstyle##remarks2:What is a markerlabelstyle?}
	{help markerlabelstyle##remarks3:You do not need to specify a markerlabelstyle}
	{help markerlabelstyle##remarks4:Specifying a markerlabelstyle can be convenient}
	{help markerlabelstyle##remarks5:What are numbered styles?}


{marker remarks1}{...}
{title:What is a markerlabel?}

{pstd}
A marker label is identifying text that appears next to (or in place of)
a marker.  Markers are the ink used to mark where points are on a plot.


{marker remarks2}{...}
{title:What is a markerlabelstyle?}

{pstd}
The look of marker labels is defined by five attributes:

{phang2}
     1.  the marker label's position -- where the marker is located
	 relative to the point;
	 see {manhelpi clockposstyle G-4}

{phang2}
    2.  the gap between the marker label and the point;
	see {manhelpi clockposstyle G-4}

{phang2}
    3.  the angle at which the identifying text is presented;
	see {manhelpi anglestyle G-4}

{phang2}
    4.  the overall style of the text;
	see {manhelpi textstyle G-4}

{p 12 16 2}
	a.  the size of the text;
	    see {manhelpi textsizestyle G-4}

{p 12 16 2}
	b.  the color and opacity of the text;
	    see {manhelpi colorstyle G-4}

{phang2}
    5.  the format of text, which is useful when labels are numeric;
	see {manhelp format D}

{pstd}
The {it:markerlabelstyle} specifies all five of these attributes.


{marker remarks3}{...}
{title:You do not need to specify a markerlabelstyle}

{pstd}
The {it:markerlabelstyle} is specified by the option

	{cmd:mstyle(}{it:markerlabelstyle}{cmd:)}

{pstd}
Correspondingly, you will find other options available:

	{cmd:mlabposition(}{it:clockposstyle}{cmd:)}
	{cmd:mlabgap(}{it:size}{cmd:)}
	{cmd:mlabangle(}{it:anglestyle}{cmd:)}
	{cmd:mlabtextstyle(}{it:textstyle}{cmd:)}
	{cmd:mlabsize(}{it:textstyle}{cmd:)}
	{cmd:mlabcolor(}{it:colorstyle}{cmd:)}
	{cmd:mlabformat(}{it:%fmt}{cmd:)}

{pstd}
You specify the {it:markerlabelstyle} when a style exists that is exactly what
you want or when another style would allow you to specify fewer changes to
obtain what you want.


{marker remarks4}{...}
{title:Specifying a markerlabelstyle can be convenient}

{pstd}
Consider the command

	{cmd:. scatter y1 y2 x, mlabel(country country)}

{pstd}
Assume that you want the marker labels for y2 versus x to appear the same as for
y1 versus x.
(An example of this can be found under
{it:{help marker_label_options##remarks2:Eliminating overprinting and overruns}}
and under {it:{help marker_label_options##remarks3:Advanced use}} in
{manhelpi marker_label_options G-3}.)
You might set all the attributes for the
marker labels for y1 versus x and then set all the attributes for {cmd:y2}
versus {cmd:x} to be the same.  It would be easier, however, to type

{phang2}
	{cmd:. scatter y1 y2 x, mlabel(country country) mlabstyle(p1 p1)}

{pstd}
When you do not specify {cmd:mlabstyle()}, results are the same as if you specified

{phang2}
	{cmd:mlabstyle(p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15)}

{pstd}
where the extra elements are ignored.  In any case, {cmd:p1} is one set
of marker-label attributes, {cmd:p2} is another set, and so on.

{pstd}
Say that you wanted {cmd:y2} versus {cmd:x} to look like {cmd:y1} versus
{cmd:x}, except that you wanted the line to be green; you could type

	{cmd:. scatter y1 y2 x, mlabel(country country) mlabstyle(p1 p1)}
	{cmd:                   mlabcolor(. green)}

{pstd}
There is nothing special about {it:markerlabelstyles} {cmd:p1}, {cmd:p2}, ...;
they merely specify sets of marker-label attributes, just like any other
named {it:markerlabelstyle}.  Type

	{cmd:. graph query markerlabelstyle}

{pstd}
to find out what other marker-label styles are available.

{pstd}
Also see {it:{help scatter##remarks19:Appendix: Styles and composite styles}}
in {manhelp scatter G-2:graph twoway scatter} for more information.


{* index numbered styles}{...}
{marker remarks5}{...}
{title:What are numbered styles?}

{phang}
     {cmd:p1} - {cmd:p15} are the default styles for marker labels
	in {helpb twoway} graphs that support marker labels, for example,
        {helpb twoway scatter},
        {helpb twoway dropline}, and
        {helpb twoway connected}.  {cmd:p1} is used for the
        first plot, {cmd:p2} for the second, and so on.

{phang}
     {cmd:p1box} - {cmd:p15box} are the default styles used for markers
        showing the outside values on {help graph_box:box charts}.
        {cmd:p1box} is used for the outside values on the first set of boxes,
        {cmd:p2box} for the second set, and so on.

{pstd}
        The "look" defined by a numbered style, such as {cmd:p1} or
	{cmd:p3box} -- by look we include such things as text
	color, text size, and position around marker -- is determined
	by the scheme (see {manhelp schemes G-4:Schemes intro}) selected.

{pstd}
        Numbered styles provide default looks that can be
        controlled by a scheme.  They can also be useful when you wish to
        make, say, the second set of labels on a graph look like the first.
        See {it:{help markerlabelstyle##remarks4:Specifying a markerlabelstyle can be convenient}}
        above for an example.
{p_end}
