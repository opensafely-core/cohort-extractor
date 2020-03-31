{smcl}
{* *! version 1.1.9  19oct2017}{...}
{vieweralsosee "[G-2] graph twoway dot" "mansection G-2 graphtwowaydot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "help scatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph dot" "help graph_dot"}{...}
{viewerjumpto "Syntax" "twoway_dot##syntax"}{...}
{viewerjumpto "Menu" "twoway_dot##menu"}{...}
{viewerjumpto "Description" "twoway_dot##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_dot##linkspdf"}{...}
{viewerjumpto "Options" "twoway_dot##options"}{...}
{viewerjumpto "Remarks" "twoway_dot##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[G-2] graph twoway dot} {hline 2}}Twoway dot plots{p_end}
{p2col:}({mansection G-2 graphtwowaydot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 52 2}
{cmdab:tw:oway}
{cmd:dot}
{it:yvar} {it:xvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 25}{...}	
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:vert:ical}}vertical bar plot; the default{p_end}
{p2col:{cmdab:hor:izontal}}horizontal bar plot{p_end}
{p2col:{cmdab:dotex:tend:(yes}|{cmd:no)}}dots extend beyond point{p_end}
{p2col:{cmd:base(}{it:#}{cmd:)}}value to drop to if {cmd:dotextend(no)}{p_end}
{p2col:{cmdab:ndot:s:(}{it:#}{cmd:)}}{it:#} of dots in full span of {it:y} or
       {it:x}{p_end}

{p2col:{cmdab:dsty:le:(}{it:{help markerstyle}}{cmd:)}}overall marker style of
       dots{p_end}
{p2col:{cmdab:d:symbol:(}{it:{help symbolstyle}}{cmd:)}}marker symbol for
       dots{p_end}
{p2col:{cmdab:dc:olor:(}{it:{help colorstyle}}{cmd:)}}fill and outline color
       and opacity for dots{p_end}
{p2col:{cmdab:dfc:olor:(}{it:{help colorstyle}}{cmd:)}}fill color and opacity
	for dots{p_end}
{p2col:{cmdab:dsiz:e:(}{it:{help markersizestyle}}{cmd:)}}size of dots{p_end}
{p2col:{cmdab:dlsty:le:(}{it:{help linestyle}}{cmd:)}}overall outline style of
       dots{p_end}
{p2col:{cmdab:dlc:olor:(}{it:{help colorstyle}}{cmd:)}}outline color and
	opacity for dots{p_end}
{p2col:{cmdab:dlw:idth:(}{it:{help linewidthstyle}}{cmd:)}}thickness of
       outline for dots{p_end}
{p2col : {cmdab:dla:lign:(}{it:{help linealignmentstyle}}{cmd:)}}alignment of
	outline for dots{p_end}

{p2col:{it:scatter_options}}any options other than
       {it:connect_options}
	documented in {manhelp scatter G-2:graph twoway scatter}{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
All options are {it:rightmost}, except {cmd:vertical} 
and {cmd:horizontal}, which are {it:unique}; see 
{help repeated options}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:twoway} {cmd:dot} displays numeric ({it:y},{it:x}) data as
dot plots.
Also see {manhelp graph_dot G-2:graph dot} to create dot plots of categorical
variables.  {cmd:twoway} {cmd:dot} is useful in programming contexts.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowaydotQuickstart:Quick start}

        {mansection G-2 graphtwowaydotRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:vertical} and {cmd:horizontal}
    specify either a vertical or a horizontal dot plot.
    {cmd:vertical} is the default.  If {cmd:horizontal} is specified, the
    values recorded in {it:yvar} are treated as {it:x} values, and the values
    recorded in {it:xvar} are treated as {it:y} values.
    That is, to make horizontal plots, do not switch the order of the
    two variables specified.

{pmore}
    In the {cmd:vertical} case, dots are drawn at the specified {it:xvar}
    values and extend up and down.

{pmore}
    In the {cmd:horizontal} case, lines are drawn at the specified {it:xvar}
    values and extend left and right.

{phang}
{cmd:dotextend(yes}|{cmd:no)}
    determines whether the dots extend beyond the {it:y} value (or {it:x}
    value if {cmd:horizontal} is specified).  {cmd:dotextend(yes)} is the
    default.

{phang}
{cmd:base(}{it:#}{cmd:)}
    is relevant only if {cmd:dotextend(no)} is also specified.  {cmd:base()}
    specifies the value from which the dots are to extend.  The default is
    {cmd:base(0)}.

{phang}
{cmd:ndots(}{it:#}{cmd:)}
    specifies the number of dots across a line; {cmd:ndots(75)} is the
    default.  Depending on printer/screen resolution, using fewer or more dots
    can make the graph look better.

{phang}
{cmd:dstyle(}{it:markerstyle}{cmd:)}
    specifies the overall look of the markers used to create the dots,
    including their shape and color.  The other options listed below
    allow you to change their attributes, but {cmd:dstyle()} provides the
    starting point.

{pmore}
    You need not specify {cmd:dstyle()} just because there is something you
    want to change.  You specify {cmd:dstyle()} when another style exists that
    is exactly what you desire or when another style would allow you to
    specify fewer changes to obtain what you want.

{pmore}
    See {manhelpi markerstyle G-4} for a list of available marker styles.

{phang}
{cmd:dsymbol(}{it:symbolstyle}{cmd:)}
    specifies the shape of the marker used for the dot.  See 
    {manhelpi symbolstyle G-4} for a list of symbol choices, although it really
    makes little sense to change the shape of dots; else why would it be
    called a dot plot?

{phang}
{cmd:dcolor(}{it:colorstyle}{cmd:)}
    specifies the color and opacity of the symbol used for the dot.
    See {manhelpi colorstyle G-4} for a list of color choices.

{phang}
{cmd:dfcolor(}{it:colorstyle}{cmd:)},
{cmd:dsize(}{it:markersizestyle}{cmd:)},
{cmd:dlstyle(}{it:linestyle}{cmd:)},
{cmd:dlcolor(}{it:colorstyle}{cmd:)},
{cmd:dlwidth(}{it:linewidthstyle}{cmd:)}, and
{cmd:dlalign(}{it:linealignmentstyle}{cmd:)}
    are rarely (never) specified options.  They control, respectively, the
    fill color and opacity, size, outline style, outline color and opacity,
    outline width, and outline alignment.  Dots -- if you are really using
    them -- are affected by none of these things.  For these options to
    be useful, you must also specify {cmd:dsymbol()}; as we said earlier, why
    then would it be called a dot plot?  In any case, see
    {manhelpi colorstyle G-4},
    {manhelpi markersizestyle G-4},
    {manhelpi linestyle G-4},
    {manhelpi linewidthstyle G-4}, and
    {manhelpi linealignmentstyle G-4},
    for a list of choices.

{phang}
{it:scatter_options} refer to any of the options allowed by {cmd:scatter},
    and most especially the {it:marker_options}, which control how the marker
    (not the dot) appears.  {it:connect_options}, even if specified, are
    ignored.  See {manhelp scatter G-2:graph twoway scatter}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:twoway} {cmd:dot} is of little, if any use.  We cannot think of a use
for it, but perhaps someday, somewhere, someone will.  We
have nothing against the dot plot used with categorical data -- see
{manhelp graph_dot G-2:graph dot} for a useful command -- but using the dot
plot in a twoway context would be bizarre.  It is nonetheless included for
logical completeness.

{pstd}
In {manhelp twoway_bar G-2:graph twoway bar}, we graphed the change in the value
for the S&P 500.  Here are a few of that data graphed as a dot plot:

	{cmd:. sysuse sp500}

	{cmd:. twoway dot change date in 1/45}
	  {it:({stata "gr_example sp500: twoway dot change date in 1/45":click to run})}
{* graph gtdot1}{...}

{pstd}
Dot plots are usually presented horizontally,

	{cmd:. twoway dot change date in 1/45, horizontal}
	  {it:({stata "gr_example sp500: twoway dot change date in 1/45, horizontal":click to run})}
{* graph gtdot2}{...}

{pstd}
and below we specify the {cmd:dotextend(n)} option to prevent the dots from
extending across the range of {it:x}:

{phang2}
	{cmd:. twoway dot change date in 1/45, horizontal dotext(n)}
{p_end}
	  {it:({stata "gr_example sp500: twoway dot change date in 1/45, horizontal dotext(n)":click to run})}
{* graph gtdot3}{...}
