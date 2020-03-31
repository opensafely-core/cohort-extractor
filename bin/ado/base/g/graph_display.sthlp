{smcl}
{* *! version 1.1.13  15may2018}{...}
{viewerdialog "graph display" "dialog graph_display"}{...}
{vieweralsosee "[G-2] graph display" "mansection G-2 graphdisplay"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph manipulation" "help graph_manipulation"}{...}
{vieweralsosee "[G-2] graph replay" "help graph_replay"}{...}
{viewerjumpto "Syntax" "graph_display##syntax"}{...}
{viewerjumpto "Menu" "graph_display##menu"}{...}
{viewerjumpto "Description" "graph_display##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_display##linkspdf"}{...}
{viewerjumpto "Options" "graph_display##options"}{...}
{viewerjumpto "Remarks" "graph_display##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-2] graph display} {hline 2}}Display graph stored in memory{p_end}
{p2col:}({mansection G-2 graphdisplay:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmdab:gr:aph}
{cmdab:di:splay}
[{it:name}]
[{cmd:,}
{it:options}]

{phang}
If {it:name} is not specified, the name of the current graph -- the graph
displayed in the Graph window -- is assumed.

{synoptset 25}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:ysiz:e:(}{it:#}{cmd:)}}change height of graph (in inches){p_end}
{p2col:{cmdab:xsiz:e:(}{it:#}{cmd:)}}change width of graph (in inches){p_end}
{p2col:{cmdab:margin:s:(}{it:{help marginstyle}}{cmd:)}}change outer margins
          {p_end}
{p2col:{help scale_option:{bf:scale(}{it:#}{bf:)}}}resize text, markers, and
        line widths{p_end}

{p2col:{helpb scheme_option:{ul:sch}eme({it:schemename})}}change overall look
         {p_end}
{p2line}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Manage graphs > Make memory graph current}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:display} redisplays a graph stored in memory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphdisplayQuickstart:Quick start}

        {mansection G-2 graphdisplayRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:ysize(}{it:#}{cmd:)}
and
{cmd:xsize(}{it:#}{cmd:)}
    specify in inches the height and width of the entire graph (also known as
    the {it:available} {it:area}).  The defaults are the original height and
    width of the graph.  These two options can be used to change the aspect
    ratio; see
    {it:{help graph display##remarks1:Changing the size and aspect ratio}} under
    {it:Remarks} below.

{phang}
{cmd:margins(}{it:marginstyle}{cmd:)}
    specifies the outer margins:  the margins between the outer graph region
    and the inner graph region as shown in the diagram in
    {manhelpi region_options G-3}.  See
    {it:{help graph display##remarks2:Changing the margins and aspect ratio}}
    under {it:Remarks} below, and see {manhelpi marginstyle G-4}.

{phang}
{cmd:scale(}{it:#}{cmd:)}
    specifies a multiplier that affects the size of all text, markers, and
    line widths in a graph.  {cmd:scale(1)} is the default, and
    {cmd:scale(1.2)} would make all text and markers 20% larger.  See 
    {manhelpi scale_option G-3}.

{phang}
{cmd:scheme(}{it:schemename}{cmd:)}
    specifies the overall look of the graph.
    The default is the original scheme with which the graph was drawn.
    See {it:{help graph display##remarks3:Changing the scheme}} under
    {it:Remarks}
    below, and see {manhelpi scheme_option G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manhelp graph_manipulation G-2:graph manipulation} for an introduction to
the graph manipulation commands.

{pstd}
Remarks are presented under the following headings:

	{help graph display##remarks1:Changing the size and aspect ratio}
	{help graph display##remarks2:Changing the margins and aspect ratio}
	{help graph display##remarks3:Changing the scheme}


{marker remarks1}{...}
{title:Changing the size and aspect ratio}

{pstd}
Under {it:{help region_options##remarks2:Controlling the aspect ratio}} in
{manhelpi region_options G-3}, we compared

	{cmd:. sysuse auto}

	{cmd:. scatter mpg weight}

{pstd}
with

	{cmd:. scatter mpg weight, ysize(5)}

{pstd}
We do not need to reconstruct the graph merely to change the {cmd:ysize()}
or {cmd:xsize()}.  We could start with some graph

	{cmd:. scatter mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight":click to run})}
{* graph mpgweight}{...}

{pstd}
and then we could redisplay it with different {cmd:ysize()} and/or
{cmd:xsize()} values:

	{cmd:. graph display, ysize(5)}
	  {it:({stata "graph display, ysize(5)":click to run, but after you click the first one})}
{* graph display1}{...}

{pstd}
In this way we can quickly find the best {cmd:ysize()} and {cmd:xsize()}
values.  This works particularly well when the graph we have drawn required
many options:

	{cmd}. sysuse uslifeexp, clear

	. generate diff = le_wm - le_bm

	. label var diff "Difference"

	.    line le_wm year, yaxis(1 2) xaxis(1 2)
	  || line le_bm year
	  || line diff  year
	  || lfit diff  year
	  ||,
	     ylabel(0(5)20, axis(2) gmin angle(horizontal))
	     ylabel(0 20(10)80,     gmax angle(horizontal))
	     ytitle("", axis(2))
	     xlabel(1918, axis(2)) xtitle("", axis(2))
	     ytitle("Life expectancy at birth (years)")
             ylabel(, axis(2) grid)
	     title("White and black life expectancy")
	     subtitle("USA, 1900-1999")
	     note("Source: National Vital Statistics, Vol 50, No. 6"
		  "(1918 dip caused by 1918 Influenza Pandemic)")
	     legend(label(1 "White males") label(2 "Black males")){txt}
	  {it:({stata gr_example2 line3:click to run})}
{* graph line 3}{...}

	{cmd:. graph display, ysize(5.25)}
	  {it:({stata "graph display, ysize(5.25)":click to run, but after you click the first one})}
{* graph display2}{...}

{pstd}
Also, we can change sizes of graphs we have previously
drawn and stored on disk:

	{cmd:. graph use} ...

	{cmd:. graph display, ysize(}...{cmd:) xsize(}...{cmd:)}

{pstd}
You may not remember what {cmd:ysize()} and {cmd:xsize()} values were
used (the defaults are {cmd:ysize(4)} and {cmd:xsize(5.5)}).
Then use {cmd:graph} {cmd:describe} to describe the file;
it reports the {cmd:ysize()} and {cmd:xsize()} values;
see {manhelp graph_describe G-2:graph describe}.


{marker remarks2}{...}
{title:Changing the margins and aspect ratio}

{pstd}
We can change the size of a graph or change its margins to control the aspect
ratio; this is discussed in
{it:{help region_options##remarks2:Controlling the aspect ratio}} in
{manhelpi region_options G-3}, which gives the example

{phang2}
	{cmd:scatter mpg weight, by(foreign, total graphregion(margin(l+10 r+10)))}

{pstd}
This too can be done in two steps:

	{cmd:. scatter mpg weight, by(foreign, total)}

	{cmd:. graph display, margins(l+10 r+10)}

{pstd}
{cmd:graph} {cmd:display}'s {cmd:margin()} option corresponds to
{cmd:graphregion(margin())} used at the time we construct graphs.


{marker remarks3}{...}
{title:Changing the scheme}

{pstd}
Schemes determine the overall look of a graph, such as where axes, titles, and
legends are placed and the color of the background; see 
{manhelp schemes G-4:Schemes intro}.  Changing the scheme after a graph has been
constructed sometimes works well and sometimes works poorly.

{pstd}
Here is an example in which it works well:

	{cmd}. sysuse uslifeexp2, clear

	. line le year, sort
		title("Line plot")
		subtitle("Life expectancy at birth, U.S.")
		note("1")
		caption("Source:  National Vital Statistics Report,
			 Vol. 50 No. 6"){txt}
	  {it:({stata "gr_example2 grlinee":click to run})}
{* graph leyear}{...}

	{cmd:. graph display, scheme(economist)}
	  {it:({stata "graph display, scheme(economist)":click to run, but after you click the first one})}
{* graph display3}{...}

{pstd}
The above example works well because no options were specified to move from
their default location things such as axes, titles, and legends, and no
options were specified to override default colors.  The issue is simple:  if
we draw a graph and say, "Move the title from its default location to over
here", over here might be a terrible place for the title once
we change schemes.  Or if we override a color and make it magenta, 
magenta may clash terribly.

{pstd}
The above does not mean that the graph command need be simple.
The example shown in
{it:{help graph display##remarks1:Changing the size and aspect ratio}} above,

	{cmd}.    line le_wm year, yaxis(1 2) xaxis(1 2)
	  || line le_bm year
	  || line diff  year
	  || lfit diff  year
	  ||,
	     ylabel(0(5)20, axis(2) gmin angle(horizontal))
	     ylabel(0 20(10)80,     gmax angle(horizontal))
	     ytitle("", axis(2))
	     xlabel(1918, axis(2)) xtitle("", axis(2))
	     ytitle("Life expectancy at birth (years)")
	     title("White and black life expectancy")
	     subtitle("USA, 1900-1999")
	     note("Source: National Vital Statistics, Vol 50, No. 6"
		  "(1918 dip caused by 1918 Influenza Pandemic)")
	     legend(label(1 "White males") label(2 "Black males")){txt}

{pstd}
moves across schemes just fine, the only potential problem being our
specification of {cmd:angle(horizontal)} for labeling the two {it:y} axes.
That might not look good with some schemes.

{pstd}
If you are concerned about moving between schemes, when you specify options,
specify style options in preference to options that directly control the
outcome.  For example,
to have two sets of points with the same color, specify the
{cmd:mstyle()} option rather than changing the color of one set to match
the color you currently see of the other set.

{pstd}
There is another issue when moving between styles that have different
background colors.  Styles are said to have naturally white or naturally black
background colors; see {manhelp schemes G-4:Schemes intro}.  When you move from
one type of scheme to another, if the colors were not changed, colors that
previously stood out would blend into the background and vice versa.  To
prevent this, {cmd:graph} {cmd:display} changes all the colors to be in
accordance with the scheme, except that {cmd:graph} {cmd:display} does not
change colors you specify by name (for example, you specify
{cmd:mcolor(magenta)} or {cmd:mcolor("255 0 255")} to change the color of a
symbol).

{pstd}
We recommend that you do not use {cmd:graph} {cmd:display} to change
graphs from having naturally black to naturally white backgrounds.  As long as
you print in monochrome, {cmd:print} does an excellent job
translating black to white backgrounds, so there is no need to change styles
for that reason.  If you are printing in color, we recommend that you change
your default scheme to a naturally white scheme; see
{manhelp set_scheme G-2:set scheme}.
{p_end}
