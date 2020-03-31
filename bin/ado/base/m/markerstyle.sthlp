{smcl}
{* *! version 1.1.8  19oct2017}{...}
{vieweralsosee "[G-4] markerstyle" "mansection G-4 markerstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] marker_options" "help marker_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "[G-4] markersizestyle" "help markersizestyle"}{...}
{vieweralsosee "[G-4] markerstyle" "help markerstyle"}{...}
{vieweralsosee "[G-4] symbolstyle" "help symbolstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] stylelists" "help stylelists"}{...}
{viewerjumpto "Syntax" "markerstyle##syntax"}{...}
{viewerjumpto "Description" "markerstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "markerstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "markerstyle##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-4]} {it:markerstyle} {hline 2}}Choices for overall look of markers{p_end}
{p2col:}({mansection G-4 markerstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:markerstyle}}Description{p_end}
{p2line}
{p2col:{cmd:p1} - {cmd:p15}}used by first to fifteenth "scatter" plot{p_end}
{p2col:{cmd:p1box} - {cmd:p15box}}used by first to fifteenth "box" plot{p_end}
{p2col:{cmd:p1dot} - {cmd:p15dot}}used by first to fifteenth "dot" plot{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:markerstyles} may be available; type

	    {cmd:.} {bf:{stata graph query markerstyle}}

{pstd}
to obtain the full list installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
Markers are the ink used to mark where points are on a plot.
{it:markerstyle} defines the symbol, size, and color of a marker.
See {manhelpi marker_options G-3} for more information.

{pstd}
{it:markerstyle} is specified in the {cmd:mstyle()} option,

{phang2}
	{cmd:. graph} ...{cmd:, mstyle(}{it:markerstyle}{cmd:)} ...

{pstd}
Sometimes you will see that a {it:markerstylelist} is allowed:

{phang2}
	{cmd:. twoway scatter} ...{cmd:, mstyle(}{it:markerstylelist}{cmd:)} ...

{pstd}
A {it:markerstylelist} is a sequence of {it:markerstyles} separated by
spaces.  Shorthands are allowed to make specifying the list easier;
see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 markerstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help markerstyle##remarks1:What is a marker?}
	{help markerstyle##remarks2:What is a markerstyle?}
	{help markerstyle##remarks3:You do not have to specify a markerstyle}
	{help markerstyle##remarks4:Specifying a markerstyle can be convenient}
	{help markerstyle##remarks5:What are numbered styles?}


{marker remarks1}{...}
{title:What is a marker?}

{pstd}
Markers are the ink used to mark where points are on a plot.
Some people use the word point or symbol, but a point is where the
marker is placed, and a symbol is merely one characteristic of a marker.


{marker remarks2}{...}
{title:What is a markerstyle?}

{pstd}
Markers are defined by five attributes:

{phang2}
    1.  {it:symbol} -- the shape of the marker;
	see {manhelpi symbolstyle G-4}

{phang2}
    2.  {it:markersize} -- the size of the marker;
	see {manhelpi markersizestyle G-4}

{phang2}
    3.  overall color and opacity of the marker;
	see {manhelpi colorstyle G-4}

{phang2}
    4.  interior (fill) color and opacity of the marker;
	see {manhelpi colorstyle G-4}

{phang2}
    5.  the line that outlines the shape of the marker:
{p_end}

{phang3}
	a.  the overall style of the line;
	    see {manhelpi linestyle G-4}

{phang3}
	b.  the thickness of the line;
	    see {manhelpi linewidthstyle G-4}

{phang3}
	c.  the color and opacity of the line;
	    see {manhelpi colorstyle G-4}

{phang3}
	d.  the alignment of the border or outline;
	    see {manhelpi linealignmentstyle G-4}

{pstd}
The {it:markerstyle} defines all five (seven) of these attributes.


{marker remarks3}{...}
{title:You do not have to specify a markerstyle}

{pstd}
The {it:markerstyle} is specified via the

	{cmd:mstyle(}{it:markerstyle}{cmd:)}

{pstd}
option.  Correspondingly, you will find eight other options available:

	{cmd:msymbol(}{it:symbolstyle}{cmd:)}
	{cmd:msize(}{it:markersizestyle}{cmd:)}
	{cmd:mcolor(}{it:colorstyle}{cmd:)}
	{cmd:mfcolor(}{it:colorstyle}{cmd:)}
	{cmd:mlstyle(}{it:linestyle}{cmd:)}
	{cmd:mlwidth(}{it:linewidthstyle}{cmd:)}
	{cmd:mlcolor(}{it:colorstyle}{cmd:)}
	{cmd:mlalign(}{it:linealignmentstyle}{cmd:)}

{pstd}
You specify the {it:markerstyle} when a style exists that is exactly what
you want or when another style would allow you to specify fewer
changes to obtain what you want.


{marker remarks4}{...}
{title:Specifying a markerstyle can be convenient}

{pstd}
Consider the command

	{cmd:. scatter y1var y2var xvar}

{pstd}
Say that you wanted the markers for {cmd:y2var} versus {cmd:xvar} to be the
same as {cmd:y1var} versus {cmd:xvar}.  You might set all the characteristics
of the marker for {cmd:y1var} versus {cmd:xvar} and then set all the
characteristics of the marker for {cmd:y2var} versus {cmd:xvar} to be the
same.  It would be easier, however, to type

{phang2}
	{cmd:. scatter y1var y2var xvar, mstyle(p1 p1)}

{pstd}
{cmd:mstyle()} is the option that specifies the overall style
of the marker.  When you do not specify the {cmd:mstyle()} option, results
are the same as if you specified

{phang2}
	{cmd:mstyle(p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15)}

{pstd}
where the extra elements are ignored.  In any case, {cmd:p1} is one set of
marker characteristics, {cmd:p2} another, and so on.

{pstd}
Say that you wanted {cmd:y2var} versus {cmd:xvar} to look like {cmd:y1var}
versus {cmd:xvar}, except that you wanted the symbols to be green; you could
type

{phang2}
	{cmd:. scatter y1var y2var xvar, mstyle(p1 p1) mcolor(. green)}

{pstd}
There is nothing special about the {it:markerstyles} {cmd:p1}, {cmd:p2}, ...;
they merely specify sets of marker attributes just like any other
named {it:markerstyle}.  Type

	{cmd:. graph query markerstyle}

{pstd}
to find out what other marker styles are available.  You may find something
pleasing, and if so, that is more easily specified than each of the individual
options to modify the shape, color, size, ... elements.


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
        showing the outside values on {help graph box:box charts}.
        {cmd:p1box} is used for the outside values on the first set of boxes,
        {cmd:p2box} for the second set, and so on.


{pstd}
        The "look" defined by a numbered style, such as {cmd:p1} or
        {cmd:p3dot} -- and by "look" we include such things as color,
        size, or symbol -- is determined by the {help schemes:scheme} selected.

{pstd}
        Numbered styles provide default looks that can be
        controlled by a scheme.  They can also be useful when you wish to
        make, say, the second set of markers on a graph look like the first.
        See {it:{help markerstyle##remarks4:Specifying a markerstyle can be convenient}}
        above for an example.
{p_end}
