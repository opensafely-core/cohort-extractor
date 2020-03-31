{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[G-4] linestyle" "mansection G-4 linestyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Concept: lines" "help lines"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] linealignmentstyle" "help linealignmentstyle"}{...}
{vieweralsosee "[G-4] linepatternstyle" "help linepatternstyle"}{...}
{vieweralsosee "[G-4] linewidthstyle" "help linewidthstyle"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] colorstyle" "help colorstyle"}{...}
{vieweralsosee "[G-4] connectstyle" "help connectstyle"}{...}
{viewerjumpto "Syntax" "linestyle##syntax"}{...}
{viewerjumpto "Description" "linestyle##description"}{...}
{viewerjumpto "Links to PDF documentation" "linestyle##linkspdf"}{...}
{viewerjumpto "Remarks" "linestyle##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[G-4]} {it:linestyle} {hline 2}}Choices for overall look of lines{p_end}
{p2col:}({mansection G-4 linestyle:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 25}{...}
{p2col:{it:linestyle}}Description{p_end}
{p2line}
{p2col:{cmd:foreground}}borders, axes, etc., in foreground color{p_end}
{p2col:{cmd:grid}}grid lines{p_end}
{p2col:{cmd:minor_grid}}a lesser grid line or same as {cmd:grid}{p_end}
{p2col:{cmd:major_grid}}a bolder grid line or same as {cmd:grid}{p_end}
{p2col:{cmd:refline}}reference lines{p_end}
{p2col:{cmd:yxline}}{cmd:yline()} or {cmd:xline()}{p_end}
{p2col:{cmd:none}}nonexistent line{p_end}

{p2col:{cmd:p1} - {cmd:p15}}used by first - fifteenth "line" plot{p_end}
{p2col:{cmd:p1bar} - {cmd:p15bar}}used by first - fifteenth "bar" plot{p_end}
{p2col:{cmd:p1box} - {cmd:p15box}}used by first - fifteenth "box" plot{p_end}
{p2col:{cmd:p1area} - {cmd:p15area}}used by first - fifteenth "area" plot{p_end}
{p2col:{cmd:p1solid} - {cmd:p15solid}}same as {cmd:p1} - {cmd:p15} but always
        solid{p_end}

{p2col:{cmd:p1mark} - {cmd:p15mark}}markers for first - fifteenth plot{p_end}
{p2col:{cmd:p1boxmark} - {cmd:p15boxmark}}markers for outside values of
       box plots{p_end}
{p2col:{cmd:p1dotmark} - {cmd:p15dotmark}}markers for dot plots{p_end}
{p2col:{cmd:p1other} - {cmd:p15other}}"other" lines, such as
       {help twoway_spike:spikes} and {help twoway_rcap:range plots}{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Other {it:linestyles} may be available; type

	    {cmd:.} {bf:{stata graph query linestyle}}

{pstd}
to obtain the full list installed on your computer.


{marker description}{...}
{title:Description}

{pstd}
{it:linestyle} sets the overall pattern, thickness, color and alignment of a
line; see {help lines} for more information.

{pstd}
{it:linestyle} is specified via options named

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:style()}

{pstd}
or

	<{cmd:l} or {cmd:li} or {cmd:line}>{cmd:style()}

{pstd}
For instance, for connecting lines (the lines used to connect
points in a plot) used by {cmd:graph} {cmd:twoway} {cmd:function},
the option is named {cmd:lstyle()}:

{phang2}
	{cmd:. twoway function} ...{cmd:, lstyle(}{it:linestyle}{cmd:)} ...

{pstd}
Sometimes you will see that a {it:linestylelist} is allowed:

{phang2}
	{cmd:. twoway line} ...{cmd:, lstyle(}{it:linestylelist}{cmd:)} ...

{pstd}
A {it:linestylelist} is a sequence of {it:linestyles} separated by
spaces.  Shorthands are allowed to make specifying the list easier;
see {manhelpi stylelists G-4}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-4 linestyleRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help linestyle##remarks1:What is a line?}
	{help linestyle##remarks2:What is a linestyle?}
	{help linestyle##remarks3:You do not need to specify a linestyle}
	{help linestyle##remarks4:Specifying a linestyle can be convenient}
	{help linestyle##remarks5:What are numbered styles?}
	{help linestyle##remarks6:Suppressing lines}


{* index line, definition}{...}
{marker remarks1}{...}
{title:What is a line?}

{pstd}
Nearly everything that appears on a graph is a line, the exceptions being
markers, fill areas, bars, and the like, and even they are outlined or
bordered by a line.


{marker remarks2}{...}
{title:What is a linestyle?}

{pstd}
Lines are defined by the following attributes:

{phang2}
    1.  {it:linepattern} -- whether it is solid, dashed, etc.;{break}
	see {manhelpi linepatternstyle G-4}

{phang2}
    2.  {it:linewidth} -- how thick the line is; {break}
	see {manhelpi linewidthstyle G-4}

{phang2}
    3.  {it:linecolor} -- the color and opacity of the line; {break}
	see {manhelpi colorstyle G-4}

{phang2}
    4.  {it:linealignment} -- the alignment of the outline or border of
    markers, fill areas, bars, and boxes; {break}
	see {manhelpi linealignmentstyle G-4}

{pstd}
The {it:linestyle} specifies all of these attributes.


{marker remarks3}{...}
{title:You do not need to specify a linestyle}

{pstd}
The {it:linestyle} is specified in options named

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:style(}{it:linestyle}{cmd:)}

{pstd}
Correspondingly, the following other options are always available:

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:pattern(}{it:linepatternstyle}{cmd:)}

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:width(}{it:linewidthstyle}{cmd:)}

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:color(}{it:colorstyle}{cmd:)}

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:align(}{it:linealignmentstyle}{cmd:)}

{pstd}
Often the <{it:object}> prefix is not required.

{pstd}
You specify the {it:linestyle} when a style exists that is exactly what you
want or when using another style would allow you to specify fewer changes to
obtain what you want.


{marker remarks4}{...}
{title:Specifying a linestyle can be convenient}

{pstd}
Consider the command

	{cmd:. line y1 y2 x}

{pstd}
Assume that you wanted the line for y2 versus x to be the same as y1 versus x.
You might set the pattern, width, and color of the line
for y1 versus x and then set the pattern, width, and color of the line for y2 versus
x to be the same.  It would be easier, however, to type

	{cmd:. line y1 y2 x, lstyle(p1 p1)}

{pstd}
{cmd:lstyle()} is the option that specifies the style of
connected lines.  When you do not specify the {cmd:lstyle()} option, results
are the same as if you specified

{phang2}
	{cmd:lstyle(p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15)}

{pstd}
where the extra elements are ignored.  In any case, {cmd:p1} is one set of
pattern, thickness, and color values; {cmd:p2} is another set; and so on.

{pstd}
Say that you wanted y2 versus x to look like y1 versus x, except that you wanted the
line to be green; you could type

{phang2}
	{cmd:. line y1 y2 x, lstyle(p1 p1) lcolor(. green)}

{pstd}
There is nothing special about the {it:linestyles} {cmd:p1}, {cmd:p2}, ...;
they merely specify sets of pattern, thickness, and color values, just like any
other named {it:linestyle}.  Type

	{cmd:. graph query linestyle}

{pstd}
to find out what other line styles are available.  You may find something
pleasing, and if so, that is more easily specified than each of the individual
options to modify the individual elements.

{pstd}
Also see 
    {it:{help scatter##remarks19:Appendix: Styles and composite styles}} in 
    {manhelp scatter G-2:graph twoway scatter} for more information.


{* index numbered styles}{...}
{marker remarks5}{...}
{title:What are numbered styles?}

{phang}
     {cmd:p1} - {cmd:p15} are the default styles for connecting lines 
	in all {helpb twoway} graphs, for example,
        {helpb twoway line}, 
        {helpb twoway connected}, and
        {helpb twoway function}.  {cmd:p1} is used for the
        first plot, {cmd:p2} for the second, and so on.  Some
	{cmd:twoway} graphs do not have connecting lines.

{phang}
     {cmd:p1bar} - {cmd:p15bar} are the default styles used for outlining the
        bars on bar charts; this includes {helpb twoway bar} charts
        and {help graph bar:bar charts}.  {cmd:p1bar} is used for the first
        set of bars, {cmd:p2bar} for the second, and so on.

{phang}
     {cmd:p1box} - {cmd:p15box} are the default styles used for outlining the
        boxes on {help graph box:box charts}.  {cmd:p1box} is used for the
        first set of boxes, {cmd:p2box} for the second, and so on.

{phang}
     {cmd:p1area} - {cmd:p15area} are the default styles used for outlining
        the areas on area charts; this includes {helpb twoway area}
        charts and {helpb twoway rarea}.  {cmd:p1area} is used for
        the first filled area, {cmd:p2area} for the second, and so on.

{phang}
     {cmd:p1solid} - {cmd:p15solid} are the same as {cmd:p1} -
     {cmd:p15}, but the lines are always solid; they have the same color
     and same thickness as {cmd:p1} - {cmd:p15}.

{phang}
     {cmd:p1mark} - {cmd:p15mark} are the default styles for lines used to
        draw markers in all {helpb twoway} graphs, for example,
	{helpb twoway scatter}, 
	{helpb twoway connected}, and
        {helpb twoway rcapsym}.  {cmd:p1mark} is used 
        for the first plot, {cmd:p2mark} for the second, and so on.  

{pmore}
        The {it:{help linepatternstyle}} attribute is always ignored
        when drawing symbols.

{phang}
     {cmd:p1boxmark} - {cmd:p15boxmark} are the default styles for 
        drawing the markers for the outside values on 
	{help graph box:box charts}.  {cmd:p1box} is
        used for the first set of dots, {cmd:p2box} for the second, and so on.

{phang}
     {cmd:p1dotmark} - {cmd:p15dotmark} are the default styles for
        drawing the markers on {help graph dot:dot charts}.  {cmd:p1dot} is
        used for the first set of dots, {cmd:p2dot} for the second, and so on.

{phang}
     {cmd:p1other} - {cmd:p15other} are the default styles used for
        "other" lines for some {helpb twoway} plottypes, including the spikes
        for {helpb twoway spike} and 
        {helpb twoway rspike} and the lines for 
        {helpb twoway dropline},
        {helpb twoway rcap}, and
        {helpb twoway rcapsym}.
	{cmd:p1other} is used for the first set of 
	lines, {cmd:p2other} for the second, and so on.

{pstd}
        The "look" defined by a numbered style, such as {cmd:p1},
        {cmd:p1mark}, {cmd:p1bar}, etc. -- by "look" we mean 
        width (see {manhelpi linewidthstyle G-4}),
	color (see {manhelpi colorstyle G-4}), and 
        pattern (see {manhelpi linepatternstyle G-4} -- is determined by the 
        scheme (see {manhelp schemes G-4:Schemes intro}) selected.

{pstd}
        Numbered styles provide default "looks" that can be
        controlled by a scheme.  They can also be useful when you wish to
        make, say, the second "thing" on a graph look like the first.  See
        {it:{help linestyle##remarks4:Specifying a linestyle can be convenient}}
        above for an example.


{* lines, suppressing}{...}
{* outlines, suppressing}{...}
{* borders, suppressing}{...}
{marker remarks6}{...}
{title:Suppressing lines}

{pstd}
Sometimes you want to suppress lines.  For instance, you might want to remove
the border around the plot region.  There are two ways to do this:
You can specify

	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:style(none)}

{pstd}
or

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:color(}{it:color}{cmd:)}

{pstd}
The first usually works well; see
{it:{help axis_scale_options##remarks5:Suppressing the axes}}
in {manhelpi axis_scale_options G-3} for an example.

{pstd}
For the outlines of solid objects, however, remember that lines have a
thickness.  Removing the outline by setting its line style to {cmd:none}
sometimes makes the resulting object seem too small, especially when the
object was small to begin with.
In those cases, specify

{phang2}
	<{it:object}><{cmd:l} or {cmd:li} or {cmd:line}>{cmd:color(}{it:color}{cmd:)}

{pstd}
and set the outline color to be the same as the interior color.
{p_end}
