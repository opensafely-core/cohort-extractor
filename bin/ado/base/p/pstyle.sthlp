{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-4] pstyle" "mansection G-4 pstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] connect_options" "help connect_options"}{...}
{vieweralsosee "[G-4] areastyle" "help areastyle"}{...}
{vieweralsosee "[G-4] connectstyle" "help connectstyle"}{...}
{vieweralsosee "[G-4] linestyle" "help linestyle"}{...}
{vieweralsosee "[G-4] markerlabelstyle" "help markerlabelstyle"}{...}
{vieweralsosee "[G-4] markerstyle" "help markerstyle"}{...}
{viewerjumpto "Syntax" "pstyle##syntax"}{...}
{viewerjumpto "Description" "pstyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "pstyle##linkspdf"}{...}
{viewerjumpto "Remarks" "pstyle##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[G-4]} {it:pstyle} {hline 2}}Choices for overall look of plot{p_end}
{p2col:}({mansection G-4 pstyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:pstyle}}Description{p_end}
{p2line}
{p2col:{cmd:ci}}first plot used as confidence interval{p_end}
{p2col:{cmd:ci2}}second plots used as confidence interval{p_end}

{p2col:{cmd:p1} - {cmd:p15}}used by first to fifteenth "other" plot{p_end}
{p2col:{cmd:p1line} - {cmd:p15line}}used by first to fifteenth "line" plot
      {p_end}
{p2col:{cmd:p1bar} - {cmd:p15bar}}used by first to fifteenth "bar" plot{p_end}
{p2col:{cmd:p1box} - {cmd:p15box}}used by first to fifteenth "box" plot{p_end}
{p2col:{cmd:p1dot} - {cmd:p15dot}}used by first to fifteenth "dot" plot{p_end}
{p2col:{cmd:p1pie} - {cmd:p15pie}}used by first to fifteenth "pie" plot{p_end}
{p2col:{cmd:p1area} - {cmd:p15area}}used by first to fifteenth "area" plot
      {p_end}
{p2col:{cmd:p1arrow} - {cmd:p15arrow}}used by first to fifteenth "arrow" plot
      {p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:pstyles} may be available; type

	    {cmd:.} {bf:{stata graph query pstyle}}

{pstd}
to obtain a complete list of {it:pstyles} installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
A {it:pstyle} -- always specified in option
{cmd:pstyle(}{it:pstyle}{cmd:)} -- specifies the overall style of a plot
and is a composite of {it:{help markerstyle}}; {it:{help markerlabelstyle}};
{it:{help areastyle}}; connected lines, {it:{help linestyle}},
 {it:{help connectstyle}}; and the {it:{help connect_options:connect_option}}
{cmd:cmissing()}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 pstyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help pstyle##remarks1:What is a plot?}
	{help pstyle##remarks2:What is a pstyle?}
	{help pstyle##remarks3:The pstyle() option}
	{help pstyle##remarks4:Specifying a pstyle}
	{help pstyle##remarks5:What are numbered styles?}


{* index plot, definition}{...}
{marker remarks1}{...}
{title:What is a plot?}

{pstd}
When you type

	{cmd:. scatter y x}

{pstd}
y versus x is called a plot.  When you type

	{cmd:. scatter y1 x || scatter y2 x}

{pstd}
or

	{cmd:. scatter y1 y2 x}

{pstd}
{cmd:y1} versus {cmd:x} is the first plot, and {cmd:y2} versus {cmd:x} is the
second.

{pstd}
A plot is one presentation of a data on a graph.


{marker remarks2}{...}
{title:What is a pstyle?}

{pstd}
The overall look of a plot -- the {it:pstyle} -- is defined by the
following attributes:

{phang2}
    1.  The look of markers, including their shape, color, size, etc.;
	see {manhelpi markerstyle G-4}

{phang2}
    2.  The look of marker labels, including the position, angle,
	size, color, etc.;
	see {manhelpi markerlabelstyle G-4}

{phang2}
    3.  The look of lines that are used to connect points, including
	their color, width, and style (solid, dashed, etc.);
	see {manhelpi linestyle G-4}

{phang2}
    4.  The way points are connected by lines (straight lines, stair step,
	etc.) if they are connected;
	see {manhelpi connectstyle G-4}

{phang2}
    5.  Whether missing values are ignored or cause lines to be broken
	when the points are connected

{phang2}
    6.  The way areas such as bars or beneath or between curves are filled,
	colored, or shaded, including whether and how they are
	outlined; see {manhelpi areastyle G-4}

{phang2}
    7.  The look of the "dots" in dot plots

{phang2}
    8.  The look of arrow heads

{pstd}
The {it:pstyle} specifies these seven attributes.


{marker remarks3}{...}
{title:The pstyle() option}

{pstd}
The {it:pstyle} is specified by the option

	{cmd:pstyle(}{it:pstyle}{cmd:)}

{pstd}
Correspondingly, other options are always available
to control each of the attributes; see, for instance,
{manhelp scatter G-2:graph twoway scatter}.

{pstd}
You specify the {it:pstyle} when a style exists that is exactly what you
want or when another style would allow you to specify fewer changes to
obtain what you want.


{marker remarks4}{...}
{title:Specifying a pstyle}

{pstd}
Consider the command

	{cmd:. scatter y1 y2 x,} ...

{pstd}
and further, assume that many options are specified.  Now imagine that you
want to make the plot of {cmd:y1} versus {cmd:x} look just like the plot of
{cmd:y2} versus {cmd:x}:  you want the same marker symbols used, the same
colors, the same style of connecting lines (if they are connecting), etc.
Whatever attributes there are, you want them treated the same.

{pstd}
One solution would be to track down every little detail of how the things
that are displayed appear and specify options to make sure that they
are specified the same.  It would be easier, however, to type

	{cmd:. scatter y1 y2 x,} ... {cmd:pstyle(p1 p1)}

{pstd}
When you do not specify the {cmd:pstyle()} option, results
are the same as if you specified

	{cmd:pstyle(p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15)}

{pstd}
where the extra elements are ignored.  In any case, {cmd:p1} is one set of
plot-appearance values, {cmd:p2} is another set, and so on.
So when you type

	{cmd:. scatter y1 y2 x,} ... {cmd:pstyle(p1 p1)}

{pstd}
all the appearance values used for y2 versus x are the same as those used for
y1 versus x.

{pstd}
Say that you wanted y2 versus x to look like y1 versus x, except that you wanted the
markers to be green; you could type

	{cmd:. scatter y1 y2 x,} ... {cmd:pstyle(p1 p1) mcolor(. green)}

{pstd}
There is nothing special about the {it:pstyles} {cmd:p1}, {cmd:p2}, ...;
they merely specify sets of plot-appearance values just like any other
{it:pstyles}.  Type

	{cmd:. graph query pstyle}

{pstd}
to find out what other plot styles are available.

{pstd}
Also see {it:{help scatter##remarks19:Appendix: Styles and composite styles}}
in {manhelp scatter G-2:graph twoway scatter} for more information.


{* index numbered styles}{...}
{marker remarks5}{...}
{title:What are numbered styles?}

{phang}
     {cmd:p1} {hline 1} {cmd:p15} are the default styles for all {helpb twoway} 
        graphs except {helpb twoway line} charts, {helpb twoway bar} charts, 
	and {helpb twoway area} charts.  {cmd:p1} is used for the first
        plot, {cmd:p2} for the second, and so on.

{phang}
     {cmd:p1line} {hline 1} {cmd:p15line} are the default styles used for line charts, 
        including {helpb twoway line} charts and 
        {helpb twoway rline}.  {cmd:p1line} is used for the first
        line, {cmd:p2line} for the second, and so on.

{phang}
     {cmd:p1bar} {hline 1} {cmd:p15bar} are the default styles used for bar
     charts, including {helpb twoway bar} charts and
     {help graph bar:bar charts}.  {cmd:p1bar} is used for the first set of
     bars, {cmd:p2bar} for the second, and so on.

{phang}
     {cmd:p1box} {hline 1} {cmd:p15box} are the default styles used for 
        {help graph box:box charts}.  {cmd:p1box} is used for the first set of
        boxes, {cmd:p2box} for the second, and so on.

{phang}
     {cmd:p1dot} {hline 1} {cmd:p15dot} are the default styles used for 
        {help graph dot:dot charts}.  {cmd:p1dot} is used for the first set of
        dots, {cmd:p2dot} for the second, and so on.

{phang}
     {cmd:p1pie} {hline 1} {cmd:p15pie} are the default styles used for 
        {help graph pie:pie charts}.  {cmd:p1pie} is used for the first pie
        slice, {cmd:p2pie} for the second, and so on.

{phang}
     {cmd:p1area} {hline 1} {cmd:p15area} are the default styles used for area charts, 
        including {helpb twoway area} charts and 
        {helpb twoway rarea}.  {cmd:p1area} is used for the first
        filled area, {cmd:p2area} for the second, and so on.

{phang}
     {cmd:p1arrow} {hline 1} {cmd:p15arrow} are the default styles used for 
        arrow plots, including {helpb twoway pcarrow} plots and 
        {helpb twoway pcbarrow}.  {cmd:p1arrow} is used for the first arrow
        plot, {cmd:p2arrow} for the second, and so on.

{pstd}
        The "look" defined by a numbered style, such as {cmd:p1bar}, {cmd:p3},
        or {cmd:p2area}, is determined by the
	{help schemes:scheme}
        selected.  By "look" we mean such things as color, width of lines,
        or patterns used.

{pstd}
	Numbered styles provide default looks that can be controlled
        by a scheme.  They can also be useful when you wish to make, say, the
        second element on a graph look like the first.  You can, for example,
        specify that markers for the second scatter on a scatterplot be drawn
        with the style of the first scatter by using the option
        {cmd:pstyle(p1 p1)}.  See
        {it:{help pstyle##remarks4:Specifying a pstyle}}
        above for a more detailed example.
{p_end}
