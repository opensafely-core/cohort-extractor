{smcl}
{* *! version 1.1.10  05nov2019}{...}
{viewerdialog "graph combine" "dialog graph_combine"}{...}
{vieweralsosee "[G-2] graph combine" "mansection G-2 graphcombine"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph use" "help graph_use"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph save" "help graph_save"}{...}
{vieweralsosee "[G-3] saving_option" "help saving_option"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-4] Concept: gph files" "help gph_files"}{...}
{viewerjumpto "Syntax" "graph_combine##syntax"}{...}
{viewerjumpto "Menu" "graph_combine##menu"}{...}
{viewerjumpto "Description" "graph_combine##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_combine##linkspdf"}{...}
{viewerjumpto "Options" "graph_combine##options"}{...}
{viewerjumpto "Remarks" "graph_combine##remarks"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[G-2] graph combine} {hline 2}}Combine multiple graphs{p_end}
{p2col:}({mansection G-2 graphcombine:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 23 2}
{cmdab:gr:aph}
{cmd:combine}
{it:name}
[{it:name} ...]
[{cmd:,}
{it:options}]

{synoptset 25}{...}
{p2col:{it:name}}Description{p_end}
{p2line}
{p2col:{it:simplename}}name of graph in memory{p_end}
{p2col:{it:name}{cmd:.gph}}name of graph stored on disk{p_end}
{p2col:{cmd:"}{it:name}{cmd:"}}name of graph stored on disk{p_end}
{p2line}


{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{cmdab:colf:irst}}display down columns{p_end}
{p2col:{cmdab:r:ows:(}{it:#}{cmd:)} | {cmdab:c:ols:(}{it:#}{cmd:)}}display in
        {it:#} rows or {it:#} columns{p_end}
{p2col:{cmdab:hol:es:(}{it:{help numlist}}{cmd:)}}positions to leave blank
       {p_end}
{p2col:{cmd:iscale(}[{cmd:*}]{it:#}{cmd:)}}size of text and markers{p_end}
{p2col:{cmd:altshrink}}alternate scaling of text, etc.{p_end}
{p2col:{cmd:imargin(}{it:{help marginstyle}}{cmd:)}}margins for individual
         graphs{p_end}

{p2col:{cmdab:ycom:mon}}give {it:y} axes common scales{p_end}
{p2col:{cmdab:xcom:mon}}give {it:x} axes common scales{p_end}

{p2col:{it:{help title_options}}}titles to appear on combined graph{p_end}
{p2col:{it:{help region_options}}}outlining, shading, aspect ratio{p_end}

{p2col:{cmdab:com:monscheme}}put graphs on common scheme{p_end}
{p2col:{helpb scheme_option:{ul:sch}eme({it:schemename})}}overall look{p_end}
{p2col:{help nodraw_option:{bf:nodraw}}}suppress display of combined graph{p_end}
{p2col:{help name_option:{bf:name(}{it:name}{bf:, ...)}}}specify name for
        combined graph{p_end}
{p2col:{help saving_option:{bf:saving(}{it:filename}{bf:, ...)}}}save combined
        graph in file{p_end}
{p2line}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Table of graphs}


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:combine} arrays separately drawn graphs into one.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphcombineQuickstart:Quick start}

        {mansection G-2 graphcombineRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:colfirst},
{cmd:rows(}{it:#}{cmd:)},
{cmd:cols(}{it:#}{cmd:)},
and
{cmd:holes(}{it:{help numlist}}{cmd:)}
    specify how the resulting graphs are arrayed.  These are the same
    options described in {manhelpi by_option G-3}.

{phang}
{cmd:iscale(}{it:#}{cmd:)}
and
{cmd:iscale(*}{it:#}{cmd:)}
    specify a size adjustment (multiplier) to be used to scale the text and
    markers used in the individual graphs.

{pmore}
    By default, {cmd:iscale()} gets smaller and smaller the larger is
    {it:G}, the number of graphs being combined.
    The default is parameterized as a multiplier
    f({it:G}) -- 0<f({it:G})<1,
    f'({it:G})<0 -- that is used to multiply {cmd:msize()},
    {c -(}{cmd:y}|{cmd:x}{c )-}{cmd:label(,labsize())}, etc., in the
    individual graphs.

{pmore}
    If you specify {cmd:iscale(}{it:#}{cmd:)}, the number you specify is
    substituted for f({it:G}).  {cmd:iscale(1)} means that text and markers
    should appear the same size that they were originally.  {cmd:iscale(.5)}
    displays text and markers at half that size.  We recommend that you
    specify a number between 0 and 1, but you are free to specify numbers
    larger than 1.

{pmore}
    If you specify {cmd:iscale(*}{it:#}{cmd:)}, the number you specify is
    multiplied by f({it:G}), and that product is used to scale the text and
    markers.  {cmd:iscale(*1)} is the default.  {cmd:iscale(*1.2)} means that
    text and markers should appear at 20% larger than {cmd:graph}
    {cmd:combine} would ordinarily choose.  {cmd:iscale(*.8)} would make them
    20% smaller.

{phang}
{cmd:altshrink}
    specifies an alternate method of determining the size of text, markers,
    line thicknesses, and line patterns.  The size of everything drawn on each
    graph is as though the graph were drawn at full size, but at the
    aspect ratio of the combined individual graph, and then the individual graph
    and everything on it were shrunk to the size shown in the combined graph.

{phang}
{cmd:imargin(}{it:marginstyle}{cmd:)}
    specifies margins to be put around the individual graphs.
    See {manhelpi marginstyle G-4}.

{phang}
{cmd:ycommon}
and
{cmd:xcommon}
    specify that the individual graphs previously drawn by {cmd:graph}
    {cmd:twoway}, and for which the {cmd:by()} option was not specified,
    be put on common {it:y} or {it:x} axes scales.  See
    {it:{help graph combine##remarks3:Combining twoway graphs}} under
    {it:Remarks} below.

{pmore} These options have no effect when applied to the categorical axes of
{cmd:bar}, {cmd:box}, and {cmd:dot} graphs.  Also, when {cmd:twoway} graphs
are combined with {cmd:bar}, {cmd:box}, and {cmd:dot} graphs, the options
affect only those graphs of the same type as the first graph combined.

{phang}
{it:title_options}
    allow you to specify titles, subtitles, notes, and captions
    to be placed on the combined graph; see {manhelpi title_options G-3}.

{phang}
{it:region_options}
    allow you to control the aspect ratio, size, etc., of the combined graph;
    see {manhelpi region_options G-3}.  Important among these options are
    {cmd:ysize(}{it:#}{cmd:)} and {cmd:xsize(}{it:#}{cmd:)}, which specify the
    overall size of the resulting graph.  It is sometimes desirable to make
    the combined graph wider or longer than usual.

{phang}
{cmd:commonscheme} and {opt scheme(schemename)}
    are for use when combining graphs that use different schemes.  By default,
    each subgraph will be drawn according to its own scheme.

{pmore}
    {cmd:commonscheme} specifies that all subgraphs be drawn using the same
    scheme and, by default, that scheme will be your default scheme.

{pmore}
    {cmd:scheme(}{it:schemename}{cmd:)} specifies that the
    {it:schemename} be used instead; see {manhelpi scheme_option G-3}.

{phang}
{cmd:nodraw}
    causes the combined graph to be constructed but not displayed;
    see {manhelpi nodraw_option G-3}.

{phang}
{cmd:name(}{it:name}[{cmd:, replace}]{cmd:)}
    specifies the name of the resulting combined graph.
    {cmd:name(Graph, replace)} is the default.
    See {manhelpi name_option G-3}.

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:, asis replace}]{cmd:)}
    specifies that the combined graph be saved as {it:filename}.  If
    {it:filename} is specified without an extension, {cmd:.gph} is assumed.
    {cmd:asis} specifies that the graph be saved in as-is format.
    {cmd:replace} specifies that, if the file already exists, it is okay to
    replace it.  See {manhelpi saving_option G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help graph combine##remarks1:Typical use}
	{help graph combine##remarks2:Typical use with memory graphs}
	{help graph combine##remarks3:Combining twoway graphs}
	{help graph combine##remarks4:Advanced use}
	{help graph combine##remarks5:Controlling the aspect ratio of subgraphs}


{marker remarks1}{...}
{title:Typical use}

{pstd}
We have previously drawn

	{cmd:. sysuse uslifeexp}

	{cmd:. line le_male   year, saving(male)}

	{cmd:. line le_female year, saving(female)}

{pstd}
We now wish to combine these two graphs:

	{cmd:. gr combine male.gph female.gph}
	  {it:({stata "gr_example2 combine1":click to run})}
{* graph combine1}{...}

{pstd}
This graph would look better combined into one column and if we 
specified {cmd:iscale(1)} to prevent the font from shrinking:

	{cmd:. gr combine male.gph female.gph, col(1) iscale(1)}
	  {it:({stata "gr_example2 combine2":click to run})}
{* graph combine2}{...}


{marker remarks2}{...}
{title:Typical use with memory graphs}

{pstd}
In both the above examples, we explicitly typed
the {cmd:.gph} suffix on the ends of the filenames:

	{cmd:. gr combine male.gph female.gph}

	{cmd:. gr combine male.gph female.gph, col(1) iscale(1)}

{pstd}
We must do that, or we must enclose the filenames in quotes:

	{cmd:. gr combine "male" "female"}

	{cmd:. gr combine "male" "female", col(1) iscale(1)}

{pstd}
If we did neither, {cmd:graph} {cmd:combine} would assume that the graphs
were stored in memory and would then have issued the error that the graphs
could not be found.  Had we wanted to do these examples by using memory graphs
rather than disk files, we could have substituted {cmd:name()} for saving on
the individual graphs

	{cmd:. sysuse uslifeexp, clear}

	{cmd:. line le_male   year, name(male)}

	{cmd:. line le_female year, name(female)}

{pstd}
and then we could type the names without quotes on the {cmd:graph}
{cmd:combine} commands:

	{cmd:. gr combine male female}

	{cmd:. gr combine male female, col(1) iscale(1)}


{marker remarks3}{...}
{title:Combining twoway graphs}

{pstd}
In the first example of {it:{help graph_combine##remarks1:Typical use}}, the
{it:y} axis of the two graphs did not align:  one had a minimum of 40, whereas
the other was approximately 37.  Option {cmd:ycommon} will put all
{cmd:twoway} graphs on a common {it:y} scale.

	{cmd:. sysuse uslifeexp, clear}

	{cmd:. line le_male   year, saving(male)}

	{cmd:. line le_female year, saving(female)}

	{cmd:. gr combine male.gph female.gph, ycommon}
	  {it:({stata "gr_example2 combine3":click to run})}
{* graph combine3}{...}


{marker remarks4}{...}
{title:Advanced use}

	{cmd}. sysuse lifeexp, clear

	. gen loggnp = log10(gnppc)

	. label var loggnp "Log base 10 of GNP per capita"

	. scatter lexp loggnp,
		ysca(alt) xsca(alt)
		xlabel(, grid gmax)      saving(yx)

	. twoway histogram lexp, fraction
		xsca(alt reverse) horiz  saving(hy)

	. twoway histogram loggnp, fraction
		ysca(alt reverse)
		ylabel(,nogrid)
		xlabel(,grid gmax)       saving(hx)

	. graph combine hy.gph yx.gph hx.gph,
		hole(3)
		imargin(0 0 0 0) graphregion(margin(l=22 r=22))
		title("Life expectancy at birth vs. GNP per capita")
		note("Source:  1998 data from The World Bank Group"){txt}
	  {it:({stata "gr_example2 combine4":click to run})}
{* graph combine4}{...}

{pstd}
Note the specification of

		{cmd:imargin(0 0 0 0) graphregion(margin(l=22 r=22))}

{pstd}
on the {cmd:graph} {cmd:combine} statement.
Specifying {cmd:imargin()} pushes the graphs together by eliminating the
margins around them.  Specifying {cmd:graphregion(margin())} makes the
graphs more square -- to control the aspect ratio.


{* index aspect ratio, controlling}{...}
{* index fysize() tt option}{...}
{* index fxsize() tt option}{...}
{marker remarks5}{...}
{title:Controlling the aspect ratio of subgraphs}

{pstd}
The above graph can be converted to look like this

	  {it:({stata "gr_example2 combine5":click to run})}
{* graph combine5}{...}

{pstd}
by adding {cmd:fysize(25)} to the drawing of the histogram for the {it:x}
axis,

	{cmd}. twoway histogram loggnp, fraction
		ysca(alt reverse)
		ylabel(0(.1).2), nogrid)
		xlabel(, grid gmax)       saving(hx)
		fysize(25){txt}{right:<- {it:new}  }

{pstd}
and adding {cmd:fxsize(25)} to the drawing of the histogram for the {it:y}
axis:

	{cmd}. twoway histogram lexp, fraction
		xsca(alt reverse) horiz
					 saving(hy)
		fxsize(25){txt}{right:<- {it:new}  }

{pstd}
The {cmd:graph} {cmd:combine} command remained unchanged.

{pstd}
The {it:forced_size_options} {cmd:fysize()} and {cmd:fxsize()} are allowed
with any graph, their syntax being

{p2colset 9 40 42 2}{...}
{p2col:{it:forced_size_options}}
	description{p_end}
{p2line}
{p2col:{cmdab:fysiz:e:(}{it:{help size}}{cmd:)}}
	use only percent of height available{p_end}
{p2col:{cmdab:fxsiz:e:(}{it:{help size}}{cmd:)}}
	use only percent of width available{p_end}
{p2line}
{p2colreset}{...}

{pstd}
There are three ways to control the aspect ratio of a graph:

{phang2}
1.  Specify the {it:{help region_options}} {cmd:ysize(}{it:#}{cmd:)} and
    {cmd:xsize(}{it:#}{cmd:)}; {it:#} is specified in inches.

{phang2}
2.  Specify the {it:region_option}
    {cmd:graphregion(margin(}{it:marginstyle}{cmd:))}.

{phang2}
3.  Specify the {it:forced_size_options}
    {cmd:fysize(}{it:size}{cmd:)}
    and
    {cmd:fxsize(}{it:size}{cmd:)}.

{pstd}
Now let us distinguish between

{phang2}
a.  controlling the aspect ratio of the
overall graph, and

{phang2}
b.  controlling the aspect ratio of individual
graphs in a combined graph.

{pstd}
For problem (a), methods (1) and (2) are best.
We used method (2) when we constructed the overall combined
graph above -- we specified
{cmd:graphregion(margin(l=22 r=22))}.
Methods 1 and 2 are discussed
under {it:{help region_options##remarks2:Controlling the aspect ratio}} in
{manhelpi region_options G-3}.

{pstd}
For problem (b), method (1) will not work, and methods (2) and (3)
do different things.

{pstd}
Method (1) controls the physical size at which the graph appears, so it
indirectly controls the aspect ratio.  {cmd:graph} {cmd:combine}, however,
discards this physical-size information.

{pstd}
Method (2) is one way of controlling the aspect ratio of subgraphs.
{cmd:graph} {cmd:combine} honors margins, assuming that you do not specify
{cmd:graph} {cmd:combine}'s {cmd:imargin()} option, which overrides the
original margin information.  In any case, if you want the subgraph long and
narrow, or short and wide, you need only specify the appropriate
{cmd:graphregion(margin())} at the time you draw the subgraph.  When you combine
the resulting graph with other graphs, it will look exactly as you want it.
The long-and-narrow or short-and-wide graph will appear in the array adjacent
to all the other graphs.  Each graph is allocated
an equal-sized area in the array, and the oddly shaped graph is drawn into it.

{pstd}
Method (3) is the only way you can obtain unequally sized areas.  
For the combined graph above, you specified {it:graph} {cmd:combine}'s
{cmd:imargin()} option and that alone precluded our use of method (2), but
most importantly, you did not want an array of four equally sized areas:

		{c TLC}{hline 15}{c TT}{hline 15}{c TRC}
		{c |} 1             {c |}             2 {c |}
		{c |}{space 15}{c |}{space 15}{c |}
		{c |}   {it:histogram}   {c |}    {it:scatter}    {c |}
		{c |}{space 15}{c |}{space 15}{c |}
		{c |}{space 15}{c |}{space 15}{c |}
		{c LT}{hline 15}{c +}{hline 15}{c RT}
		{c |} 3             {c |}             4 {c |}
		{c |}{space 15}{c |}{space 15}{c |}
		{c |}               {c |}   {it:histogram}   {c |}
		{c |}{space 15}{c |}{space 15}{c |}
		{c |}{space 15}{c |}{space 15}{c |}
		{c BLC}{hline 15}{c BT}{hline 15}{c BRC}

{pstd}
We wanted

		{c TLC}{hline 3}{c TT}{hline 27}{c TRC}
		{c |} {it:h} {c |}                         2 {c |}
		{c |} {it:i} {c |}                           {c |}
		{c |} {it:s} {c |}                           {c |}
		{c |} {it:t} {c |}                           {c |}
		{c |} {it:o} {c |}         {it:scatter}           {c |}
		{c |} {it:g} {c |}                           {c |}
		{c |} {it:r} {c |}                           {c |}
		{c |} {it:a} {c |}                           {c |}
		{c |} {it:m} {c |}                           {c |}
		{c LT}{hline 3}{c +}{hline 27}{c RT}
		{c |} 3 {c |}        {it:histogram}        4 {c |}
		{c BLC}{hline 3}{c BT}{hline 27}{c BRC}


{pstd}
The {it:forced_size_options} allowed us to achieve that.  You specify the
{it:forced_size_options} {cmd:fysize()} and {cmd:fxsize()} with the commands
that draw the subgraphs, not with {cmd:graph} {cmd:combine}.  Inside the
parentheses, you specify the percentage of the graph region to be used.
Although you could use {cmd:fysize()} and {cmd:fxsize()} to control the aspect
ratio in ordinary cases, there is no reason to do that.  Use {cmd:fysize()}
and {cmd:fxsize()} to control the aspect ratio when you are going to use
{cmd:graph} {cmd:combine} and you want unequally sized areas or when you will
be specifying {cmd:graph} {cmd:combine}'s {cmd:imargin()} option.
{p_end}
