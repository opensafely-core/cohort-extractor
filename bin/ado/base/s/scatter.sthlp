{smcl}
{* *! version 1.2.1  02oct2019}{...}
{viewerdialog twoway "dialog twoway"}{...}
{vieweralsosee "[G-2] graph twoway scatter" "mansection G-2 graphtwowayscatter"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] axis_choice_options" "help axis_choice_options"}{...}
{vieweralsosee "[G-3] connect_options" "help connect_options"}{...}
{vieweralsosee "[G-3] marker_label_options" "help marker_label_options"}{...}
{vieweralsosee "[G-3] marker_options" "help marker_options"}{...}
{vieweralsosee "[G-3] twoway_options" "help twoway_options"}{...}
{viewerjumpto "Syntax" "scatter##syntax"}{...}
{viewerjumpto "Menu" "scatter##menu"}{...}
{viewerjumpto "Description" "scatter##description"}{...}
{viewerjumpto "Links to PDF documentation" "scatter##linkspdf"}{...}
{viewerjumpto "Options" "scatter##options"}{...}
{viewerjumpto "Remarks" "scatter##remarks"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[G-2] graph twoway scatter} {hline 2}}Twoway scatterplots{p_end}
{p2col:}({mansection G-2 graphtwowayscatter:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 34 2}
[{cmdab:tw:oway}]
{cmdab:sc:atter}
{varlist}
{ifin}
[{it:{help scatter##weight:weight}}]
[{cmd:,} {it:options}]


{pstd}
where {it:varlist} is 
{p_end}
		{it:y_1} [{it:y_2} [...]] {it:x}

{synoptset 30}{...}
{p2col:{it:options}}Description{p_end}
{p2line}
{p2col:{it:{help scatter##marker_options:marker_options}}}change look of
       markers (color, size, etc.){p_end}
{p2col:{it:{help scatter##marker_label_options:marker_label_options}}}add
       marker labels; change look or position{p_end}
{p2col:{it:{help scatter##connect_options:connect_options}}}change look of
       lines or connecting method{p_end}

{p2col:{it:{help scatter##composite_style_option:composite_style_option}}}overall style of the plot{p_end}

{p2col:{it:{help scatter##jitter_options:jitter_options}}}jitter marker
       positions using random noise{p_end}

{p2col:{it:{help scatter##axis_choice_options:axis_choice_options}}}associate
       plot with alternate axis{p_end}

{p2col:{it:{help scatter##twoway_options:twoway_options}}}titles, legends,
       axes, added lines and text, by, regions, name, aspect ratio, etc.{p_end}
{p2line}


{marker marker_options}{...}
{p2col:{it:marker_options}}Description{p_end}
{p2line}
{p2col:{cmdab:m:symbol:(}{it:{help symbolstyle}list}{cmd:)}}shape of marker
       {p_end}
{p2col:{cmdab:mc:olor:(}{it:{help colorstyle}list}{cmd:)}}color and opacity
	of marker, inside and out{p_end}
{p2col:{cmdab:msiz:e:(}{it:{help markersizestyle}list}{cmd:)}}size of
        marker{p_end}
{p2col:{cmdab:msa:ngle:(}{it:{help anglestyle}}{cmd:)}}angle of marker
	symbol{p_end}
{p2col:{cmdab:mfc:olor:(}{it:{help colorstyle}list}{cmd:)}}inside or "fill"
        color and opacity{p_end}
{p2col:{cmdab:mlc:olor:(}{it:{help colorstyle}list}{cmd:)}}color and opacity
	of outline{p_end}
{p2col:{cmdab:mlw:idth:(}{it:{help linewidthstyle}list}{cmd:)}}thickness of
        outline{p_end}
{p2col : {cmdab:mla:lign:(}{it:{help linealignmentstyle}}{cmd:)}}outline
	alignment (inside, outside, center){p_end}
{p2col:{cmdab:mlsty:le:(}{it:{help linestyle}list}{cmd:)}}overall style of
        outline{p_end}
{p2col:{cmdab:msty:le:(}{it:{help markerstyle}list}{cmd:)}}overall style of
        marker{p_end}
{p2line}


{marker marker_label_options}{...}
{p2col:{it:marker_label_options}}Description{p_end}
{p2line}
{p2col:{cmd:mlabel(}{varlist}{cmd:)}}specify marker variables{p_end}
{p2col:{cmdab:mlabp:osition:(}{it:{help clockposstyle:clockpos}list}{cmd:)}}where to locate label{p_end}
{p2col:{cmdab:mlabv:position:(}{varname}{cmd:)}}where to locate label 2{p_end}
{p2col:{cmdab:mlabg:ap:(}{it:{help size}list}{cmd:)}}gap between
        marker and label{p_end}
{p2col:{cmdab:mlabang:le:(}{it:{help anglestyle}list}{cmd:)}}angle of label
       {p_end}
{p2col:{cmdab:mlabs:ize:(}{it:{help textsizestyle}list}{cmd:)}}size of label
       {p_end}
{p2col:{cmdab:mlabc:olor:(}{it:{help colorstyle}list}{cmd:)}}color and opacity
	of label{p_end}
{p2col:{cmdab:mlabf:ormat:(}{it:{help %fmt}list}{cmd:)}}format of label{p_end}
{p2col:{cmdab:mlabt:extstyle:(}{it:{help textstyle}list}{cmd:)}}overall style
       of text{p_end}
{p2col:{cmdab:mlabsty:le:(}{it:{help markerlabelstyle}list}{cmd:)}}overall
       style of label{p_end}
{p2line}


{marker connect_options}{...}
{p2col:{it:connect_options}}Description{p_end}
{p2line}
{p2col:{cmdab:c:onnect:(}{it:{help connectstyle}list}{cmd:)}}how to connect
        points{p_end}
{p2col:{cmd:sort}[{cmd:(}{varlist}{cmd:)}]}how to order data before connecting
       {p_end}
{p2col:{cmdab:cmis:sing:(}{c -(}{cmd:y}|{cmd:n}{c )-} ...{cmd:)}}missing
        values are ignored{p_end}

{p2col:{cmdab:l:pattern:(}{it:{help linepatternstyle}list}{cmd:)}}line pattern
       (solid, dashed, etc.){p_end}
{p2col:{cmdab:lw:idth:(}{it:{help linewidthstyle}list}{cmd:)}}thickness of line
       {p_end}
{p2col:{cmdab:lc:olor:(}{it:{help colorstyle}list}{cmd:)}}color and opacity
	of line{p_end}
{p2col : {cmdab:la:lign:(}{it:{help linealignmentstyle}}{cmd:)}}line
	alignment (inside, outside, center){p_end}
{p2col:{cmdab:lsty:le:(}{it:{help linestyle}list}{cmd:)}}overall style of line
       {p_end}
{p2line}


{marker composite_style_option}{...}
{p2col:{it:composite_style_option}}Description{p_end}
{p2line}
{p2col:{cmdab:psty:le:(}{it:{help pstyle}list}{cmd:)}}all the {cmd:...style()}
        options above{p_end}
{p2line}
{p 4 6 2}
See {it:{help scatter##remarks19:Appendix: Styles and composite styles}} under
{it:Remarks} below.

{marker jitter_options}
{p2col:{it:jitter_options}}Description{p_end}
{p2line}
{p2col:{cmd:jitter(}{it:#}{cmd:)}}perturb location of point{p_end}
{p2col:{cmd:jitterseed(}{it:#}{cmd:)}}random-number seed for {cmd:jitter()}
      {p_end}
{p2line}
{p 4 6 2}
See {it:{help scatter##jitter:Jittered markers}} under {it:Remarks} below.


{marker axis_choice_options}{...}
{p2col:{it:axis_choice_options}}Description{p_end}
{p2line}
{p2col:{cmdab:yax:is:(}{it:#} [{it:#} ...]{cmd:)}}which {it:y} axis to use
        {p_end}
{p2col:{cmdab:xax:is:(}{it:#} [{it:#} ...]{cmd:)}}which {it:x} axis to use
        {p_end}
{p2line}


{marker twoway_options}{...}
{p2col:{it:twoway_options}}Description{p_end}
{p2line}
{p2col:{it:{help added_line_options}}}draw lines at specified {it:y} or {it:x}
        values{p_end}
{p2col:{it:{help added_text_options}}}display text at specified
        ({it:y},{it:x}) value{p_end}

{p2col:{it:{help axis_options}}}labels, ticks, grids, log scales{p_end}
{p2col:{it:{help title_options}}}titles, subtitles, notes, captions{p_end}
{p2col:{it:{help legend_options}}}legend explaining what means what{p_end}

{p2col:{help scale_option:{bf:scale(}{it:#}{bf:)}}}resize text and markers
       {p_end}
{p2col:{it:{help region_options}}}outlining, shading, aspect ratio{p_end}
{p2col:{it:{help aspect_option}}}constrain aspect ratio of plot region{p_end}
{p2col:{help scheme_option:{bf:scheme(}{it:schemename}{bf:)}}}overall look
       {p_end}
{p2col:{help play_option:{bf:play(}{it:recordingname}{bf:)}}}play edits from
       {it:recordingname}{p_end}

{p2col:{help by_option:{bf:by(}{it:varlist}{bf:, ...)}}}repeat for subgroups
       {p_end}
{p2col:{help nodraw_option:{bf:nodraw}}}suppress display of graph{p_end}
{p2col:{help name_option:{bf:name(}{it:name}{bf:, ...)}}}specify name for
       graph{p_end}
{p2col:{help saving_option:{bf:saving(}{it:filename}{bf:, ...)}}}save graph in
       file{p_end}

{p2col:{it:{help advanced_options}}}difficult to explain{p_end}
{p2line}
{p2colreset}{...}

{marker weight}{...}
{p 4 6 2}
{cmd:aweight}s,
{cmd:fweight}s, and
{cmd:pweight}s are allowed; see {help weight}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Graphics > Twoway graph (scatter, line, etc.)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:scatter} draws scatterplots and is the mother of all the {cmd:twoway}
plottypes, such as {helpb twoway line} and {helpb twoway lfit}.

{pstd}
{cmd:scatter} is both a command and a {it:plottype} as
defined in {manhelp twoway G-2:graph twoway}.  Thus the syntax for {cmd:scatter}
is

	{cmd:. graph twoway scatter} ...

	{cmd:. twoway scatter} ...

	{cmd:. scatter} ...

{pstd}
Being a plottype, {cmd:scatter} may be combined with other plottypes in the
{helpb twoway} family, as in,

{phang2}
	{cmd:. twoway (scatter} ...{cmd:) (line} ...{cmd:) (lfit} ...{cmd:)} ...

{pstd}
which can equivalently be written as

{phang2}
	{cmd:. scatter} ... {cmd:|| line} ... {cmd:|| lfit} ... {cmd:||} ...


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphtwowayscatterQuickstart:Quick start}

        {mansection G-2 graphtwowayscatterRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:marker_options}
    specify how the points on the graph are to be designated.
    Markers are the ink used to mark where points are on a plot.
    Markers have shape, color, and size, and other characteristics.
    See {manhelpi marker_options G-3} for a description of markers
    and the options that specify them.

{pmore}
    {cmd:msymbol(O D S T + X o d s t smplus x)} is the default.
    {cmd:msymbol(i)} will suppress the appearance of the marker altogether.

{phang}
{it:marker_label_options}
    specify labels to appear next to or in place of the markers.  For
    instance, if you were plotting country data, marker labels would allow you
    to have "Argentina", "Bolivia", ..., appear next to each point and, with a
    few data, that might be desirable.
    See {manhelpi marker_label_options G-3} for a description of marker
    labels and the options that control them.

{pmore}
    By default, no marker labels are displayed.
    If you wish to display marker labels in place of the markers, specify
    {cmd:mlabposition(0)} and {cmd:msymbol(i)}.

{phang}
{it:connect_options}
    specify how the points are to be connected.
    The default is not to connect the points.

{pmore}
    {cmd:connect()} specifies whether points are to be connected and, if so,
    how the line connecting them is to be shaped.  The line between each pair
    of points can connect them directly or in stairstep fashion.

{pmore}
    {cmd:sort} specifies that the data be sorted by the {it:x}
    variable before the points are connected.  Unless you are after a special
    effect or your data are already sorted, do not forget to specify this
    option.  If you are after a special effect, and if the data are not
    already sorted, you can specify {cmd:sort(}{varlist}{cmd:)} to specify
    exactly how the data should be sorted.  Understand that specifying
    {cmd:sort} or {cmd:sort(}{it:varlist}{cmd:)} when it is not necessary
    will slow Stata down a little.
    You must specify {cmd:sort} if you wish to connect points, and
    you specify the {it:twoway_option}
    {cmd:by()} with {cmd:total}.

{pmore}
    {cmd:cmissing(y)} and {cmd:cmissing(n)} specify whether missing
    values are ignored when points are connected; whether the line should have
    a break in it.  The default is {cmd:cmissing(y)}, meaning that there will
    be no breaks.

{pmore}
    {cmd:lpattern()} specifies how the style of the line is to be drawn:
    solid, dashed, etc.

{pmore}
    {cmd:lwidth()} specifies the width of the line.

{pmore}
    {cmd:lcolor()} specifies the color and opacity of the line.

{pmore}
    {cmd:lalign()} specifies the alignment of the line.

{pmore}
    {cmd:lstyle()} specifies the overall style of the line.

{pmore}
     See {manhelpi connect_options G-3} for more information on these
     and related options.
     See {help lines} for an overview of lines.

{marker pstyle()}{...}
{phang}
{cmd:pstyle(}{it:pstyle}{cmd:)}
    specifies the overall style of the plot and is a composite of
    {cmd:mstyle()}, {cmd:mlabstyle()}, {cmd:lstyle()}, {cmd:connect()}, and
    {cmd:cmissing()}.  The default is {cmd:pstyle(p1)} for the first plot,
    {cmd:pstyle(p2)} for the second, and so on.  See
    {it:{help scatter##remarks19:Appendix: Styles and composite styles}}
    under {it:Remarks} below.

{phang}
{cmd:jitter(}{it:#}{cmd:)}
     adds spherical random noise to the data before plotting.
     {it:#} represents the size of the noise as a percentage of the graphical
     area.  This option is useful when plotting data which otherwise would
     result in points plotted on top of each other.  See
     {it:{help scatter##jitter:Jittered markers}} under {it:Remarks} below.

{pmore}
     Commonly specified are {cmd:jitter(5)} or {cmd:jitter(6)};
     {cmd:jitter(0)} is the default.

{phang}
{cmd:jitterseed(}{it:#}{cmd:)}
     specifies the seed for the random noise added by the {cmd:jitter()}
     option.  {it:#} should be specified as a positive integer.  Use this
     option to reproduce the same plotted points when the
     {cmd:jitter()} option is specified.

{phang}
{it:axis_choice_options}
    are for use when you have multiple {it:x} or {it:y} axes.
    See {manhelpi axis_choice_options G-3} for more information.

{phang}
{it:twoway_options} include

{pmore}
    {it:added_line_options},
	which specify that horizontal or vertical lines be drawn on the
	graph; see {manhelpi added_line_options G-3}.  If your interest is
	in drawing grid lines through the plot region, see
	{it:axis_options} below.

{pmore}
    {it:added_text_options},
	which specify text to be displayed on the graph (inside the plot
	region); see {manhelpi added_text_options G-3}.

{pmore}
    {it:axis_options},
	which allow you to specify labels, ticks, and grids.  These options
	also allow you to obtain logarithmic scales; see 
	{manhelpi axis_options G-3}.

{pmore}
    {it:title_options},
       allow you to specify titles, subtitles, notes, and captions
       to be placed on the graph; see {manhelpi title_options G-3}.

{pmore}
    {it:legend_options},
	which allows specifying the legend explaining the symbols and line
	styles used; see {manhelpi legend_options G-3}.

{pmore}
    {cmd:scale(}{it:#}{cmd:)},
	which makes all the text and markers on a graph larger or smaller
	({cmd:scale(1)} means no change); see {manhelpi scale_option G-3}.

{pmore}
    {it:region_options},
	which allow you to control the aspect ratio and to specify that the
	graph be outlined, or given a background shading; see 
	{manhelpi region_options G-3}.

{pmore}
    {cmd:scheme(}{it:schemename}{cmd:)},
	which specifies the overall look of the graph; see 
	{manhelpi scheme_option G-3}.

{pmore}
INCLUDE help playopt_desc

{pmore}
    {cmd:by(}{varlist}{cmd:,} ...{cmd:)},
	which allows drawing multiple graphs for each subgroup of the data;
	see {manhelpi by_option G-3}.

{pmore}
    {cmd:nodraw},
	which prevents the graph from being displayed; see 
	{manhelpi nodraw_option G-3}.

{pmore}
    {cmd:name(}{it:name}{cmd:)},
	which allows you to save the graph in memory under a name
	different from {cmd:Graph}; see
	{manhelpi name_option G-3}.

{pmore}
    {cmd:saving(}{it:filename}[{cmd:, asis replace}]{cmd:)},
	which allows you to save the graph to disk; see 
	{manhelpi saving_option G-3}.

{pmore}
    other options that allow you to suppress the display of the graph, to name
    the graph, etc.

{pmore}
See {manhelpi twoway_options G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help scatter##remarks1:Typical use}
	{help scatter##remarks2:Scatter syntax}
	{help scatter##remarks3:The overall look for the graph}
	{help scatter##remarks4:The size and aspect ratio of the graph}
	{help scatter##remarks5:Titles}
	{help scatter##remarks6:Axis titles}
	{help scatter##remarks7:Axis labels and ticking}
	{help scatter##remarks8:Grid lines}
	{help scatter##remarks9:Added lines}
	{help scatter##remarks10:Axis range}
	{help scatter##remarks11:Log scales}
	{help scatter##remarks12:Multiple axes}
	{help scatter##remarks13:Markers}
	{help scatter##remarks14:Weighted markers}
	{help scatter##remarks15:Jittered markers}
	{help scatter##remarks16:Connected lines}
	{help scatter##remarks17:Graphs by groups}
	{help scatter##remarks18:Saving graphs}
	{help scatter##video:Video example}
	{help scatter##remarks19:Appendix:  Styles and composite styles}


{marker remarks1}{...}
{title:Typical use}

{pstd}
The scatter plottype by default individually marks the location of each
point:

	{cmd:. sysuse uslifeexp2}

	{cmd:. scatter le year}
	  {it:({stata "gr_example uslifeexp2: scatter le year":click to run})}
{* graph scatter1}{...}

{pstd}
With the specification of options, you can produce the same effect
as {helpb twoway connected},

	{cmd:. scatter le year, connect(l)}
	  {it:({stata "gr_example uslifeexp2: scatter le year, c(l)":click to run})}
{* graph scatter2}{...}

{pstd}
or {cmd:twoway} {cmd:line}:

	{cmd:. scatter le year, connect(l) msymbol(i)}
	  {it:({stata "gr_example uslifeexp2: scatter le year, c(l) m(i)":click to run})}
{* graph scatter3}{...}

{pstd}
In fact, all the other twoway plottypes eventually work their way back to
executing {cmd:scatter}.  {cmd:scatter} literally is the mother of all twoway
graphs in Stata.


{marker remarks2}{...}
{title:Scatter syntax}

{pstd}
See {manhelp twoway G-2:graph twoway} for an overview of {cmd:graph}
{cmd:twoway} syntax.  Especially for {cmd:graph} {cmd:twoway} {cmd:scatter},
the only thing to know is that if more than two variables are specified, all
but the last are given the interpretation of being {it:y} variables.  For
example,

	{cmd:. scatter} {it:y1var} {it:y2var} {it:xvar}

{pstd}
would plot {it:y1var} versus {it:xvar} and overlay that with a plot of
{it:y2var} versus {it:xvar}, so it is the same as typing

{phang2}
	{cmd:. scatter} {it:y1var} {it:xvar} {cmd:|| scatter} {it:y2var xvar}

{pstd}
If, using the multiple-variable syntax, you specify {cmd:scatter}-level
options (that is, all options except {it:twoway_options} as defined in the
syntax diagram), you specify arguments for {it:y1var}, {it:y2var}, ...,
separated by spaces.  That is, you might type

{phang2}
	{cmd:. scatter} {it:y1var} {it:y2var} {it:xvar}{cmd:, ms(O i) c(. l)}

{pstd}
{cmd:ms()} and {cmd:c()} are abbreviations for the {cmd:msymbol()} and
{cmd:connect()} options; see {manhelpi marker_options G-3} and
{manhelpi connect_options G-3}.  In any case, the results from the above are
the same as if you typed

{phang2}
	{cmd:. scatter} {it:y1var} {it:xvar}{cmd:, ms(O) c(.)}
		{cmd:|| scatter} {it:y2var} {it:xvar}{cmd:, ms(i) c(l)}

{pstd}
There need not be a one-to-one correspondence between options and {it:y}
variables when you use the multiple-variable syntax.  If you typed

{phang2}
	{cmd:. scatter} {it:y1var} {it:y2var} {it:xvar}{cmd:, ms(O) c(l)}

{pstd}
then options {cmd:ms()} and {cmd:c()} will have default values for the
second scatter, and if you typed

{phang2}
	{cmd:. scatter} {it:y1var} {it:y2var} {it:xvar}{cmd:, ms(O S i) c(l l l)}

{pstd}
the extra options for the nonexistent third variable would be ignored.

{pstd}
If you wish to specify the default for one of the {it:y} variables, you
may specify period ({cmd:.}):

{phang2}
	{cmd:. scatter} {it:y1var} {it:y2var} {it:xvar}{cmd:, ms(. O) c(. l)}

{pstd}
There are other shorthands available to make specifying multiple arguments
easier; see {manhelpi stylelists G-4}.

{pstd}
Because multiple variables are interpreted as multiple {it:y} variables,
to produce graphs containing multiple {it:x} variables, you must
chain together separate {cmd:scatter} commands:

{phang2}
	{cmd:. scatter} {it:yvar} {it:x1var}{cmd:,} ... {cmd:||}
		{cmd:. scatter} {it:yvar} {it:x2var}{cmd:,} ...


{marker remarks3}{...}
{title:The overall look for the graph}

{pstd}
The overall look of the graph is mightily affected by the scheme, and 
there is a {cmd:scheme()} option that will allow you to specify which
scheme to use.
We showed earlier the results of {cmd:scatter}
{cmd:le} {cmd:year}.  Here is the same graph repeated using the
{cmd:economist} scheme:

	{cmd}. sysuse uslifeexp2, clear

	. scatter le year,
		title("Scatterplot")
		subtitle("Life expectancy at birth, U.S.")
		note("1")
		caption("Source:  National Vital Statistics Report,
			 Vol. 50 No. 6")
		scheme(economist){txt}
	  {it:({stata "gr_example2 grscae":click to run})}
{* graph scatter4}{...}

{pstd}
See {manhelp schemes G-4:Schemes intro}.


{marker remarks4}{...}
{title:The size and aspect ratio of the graph}

{pstd}
The size and aspect ratio of the graph are controlled by the
{it:region_options} {cmd:ysize(}{it:#}{cmd:)} and {cmd:xsize(}{it:#}{cmd:)},
which specify the height and width in inches of the graph.
For instance,

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, xsize(4) ysize(4)}

{pstd}
would produce a 4{it:x}4 inch square graph.
See {manhelpi region_options G-3}.


{marker remarks5}{...}
{title:Titles}

{pstd}
By default, no titles appear on the graph, but the {it:title_options}
{cmd:title()}, {cmd:subtitle()}, {cmd:note()}, {cmd:caption()}, and
{cmd:legend()} allow you to specify the titles that you wish to appear, as
well as to control their position and size.  For instance,

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, title("My title")}

{pstd}
would draw the graph and include the title "My title" (without the quotes) at
the top.  Multiple-line titles are allowed.  Typing

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, title("My title" "Second line")}

{pstd}
would create a two-line title.  The above, however, would probably look better
as a title followed by a subtitle:

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, title("My title") subtitle("Second line")}

{pstd}
In any case,
see {manhelpi title_options G-3}.


{marker remarks6}{...}
{title:Axis titles}

{pstd}
Titles do, by default, appear on the {it:y} and {it:x} axes.  The axes are
titled with the variable names being plotted or, if the variables have
variable labels, with their variable labels.  The {it:axis_title_options}
{cmd:ytitle()} and {cmd:xtitle()} allow you to override that.  If you specify

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, ytitle("")}

{pstd}
the title on the {it:y} axis would disappear.  If you specify

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, ytitle("Rate of change")}

{pstd}
the {it:y}-axis title would become "Rate of change".
As with all titles, multiple-line titles are allowed:

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, ytitle("Time to event" "Rate of change")}

{pstd}
See {manhelpi axis_title_options G-3}.


{marker remarks7}{...}
{title:Axis labels and ticking}

{pstd}
By default, approximately five major ticks and labels are placed on each axis.
The {it:axis_label_options} {cmd:ylabel()} and {cmd:xlabel()} allow you to
control that.  Typing

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, ylabel(#10)}

{pstd}
would put approximately 10 labels and ticks on the {it:y} axis.  Typing

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, ylabel(0(1)9)}

{pstd}
would put exactly 10 labels at the values 0, 1, ..., 9.

{pstd}
{cmd:ylabel()} and {cmd:xlabel()} have other features, and options are also
provided for minor labels and minor ticks; see 
{manhelpi axis_label_options G-3}.


{marker remarks8}{...}
{title:Grid lines}

{pstd}
If you use a member of the {cmd:s2} family
of schemes -- see {manhelp scheme_s2 G-4:Scheme s2} -- grid lines are included
in {it:y} but not {it:x}, by default.
You can specify option {cmd:xlabel(,grid)} to add {it:x} grid lines,
and you can specify {cmd:ylabel(,nogrid)} to suppress {it:y}
grid lines.

{pstd}
Grid lines are considered
an extension of ticks and are specified as suboptions inside the
{it:axis_label_options} {cmd:ylabel()} and {cmd:xlabel()}.  For instance,

	{cmd:. sysuse auto, clear}

	{cmd:. scatter mpg weight, xlabel(,grid)}
	  {it:({stata "gr_example auto: scatter mpg weight, xlabel(,grid)":click to run})}
{* graph scatter5}{...}

{pstd}
In the above example, the grid lines are placed at the same values as the
default ticks and labels, but you can control that, too.
See {manhelpi axis_label_options G-3}.


{marker remarks9}{...}
{title:Added lines}

{pstd}
Lines may be added to the graph for emphasis by using the
{it:added_line_options} {cmd:yline()} and {cmd:xline()}; see
{manhelpi added_line_options G-3}.


{marker remarks10}{...}
{title:Axis range}

{pstd}
The extent or range of an axis is set according to all the things that appear
on it -- the data being plotted and the values on the axis being labeled
or ticked.  In the graph that just appeared above,

	{cmd:. sysuse auto, clear}

	{cmd:. scatter mpg weight}
	  {it:({stata "gr_example auto: scatter mpg weight":click to run})}
{* graph smpgweight}{...}

{pstd}
variable {cmd:mpg} varies between 12 and 41 and yet the {it:y} axis extends
from 10 to 41.  The axis was extended to include 10<12 because the value 10
was labeled.  Variable {cmd:weight} varies between 1,760 and 4,840; the {it:x}
axis extends from 1,760 to 5,000.  This axis was extended to include
5,000>4,840 because the value 5,000 was labeled.

{pstd}
You can prevent axes from being extended by specifying the
{cmd:ylabel(minmax)} and {cmd:xlabel(minmax)} options.  {cmd:minmax} specifies
that only the minimum and maximum are to be labeled:

{phang2}
	{cmd:. scatter mpg weight, ylabel(minmax) xlabel(minmax)}
{p_end}
	  {it:({stata "gr_example auto: scatter mpg weight, ylabel(minmax) xlabel(minmax)":click to run})}
{* graph scatter6}{...}

{pstd}
In other cases, you may wish to widen the range of an axis.  This you can
do by specifying the {cmd:range()} descriptor of the {it:axis_scale_options}
{cmd:yscale()} or {cmd:xscale()}.  For instance,

{phang2}
	{cmd:. scatter mpg weight, xscale(range(1000 5000))}

{pstd}
would widen the {it:x} axis to include 1,000--5,000.  We typed out the
name of the option, but most people would type

{phang2}
	{cmd:. scatter mpg weight, xscale(r(1000 5000))}

{pstd}
{cmd:range()} can widen, but never narrow, the extent of an axis.  Typing

{phang2}
	{cmd:. scatter mpg weight, xscale(r(1000 4000))}

{pstd}
would not omit cars with {cmd:weight}>4000 from the plot.  If that is your
desire, type

	{cmd:. scatter mpg weight if weight<=4000}

{pstd}
See 
{manhelpi axis_scale_options G-3} for more information on {cmd:range()},
{cmd:yscale()}, and {cmd:xscale()}; see 
{manhelpi axis_label_options G-3} for more information on
{cmd:ylabel(minmax)} and {cmd:xlabel(minmax)}.


{marker remarks11}{...}
{title:Log scales}

{pstd}
By default, arithmetic scales for the axes are used.  Log scales can be
obtained by specifying the {cmd:log} suboption of
{cmd:yscale()} and {cmd:xscale()}.  For instance,

	{cmd:. sysuse lifeexp, clear}

	{cmd:. scatter lexp gnppc, xscale(log) xlab(,g)}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc, xscale(log) xlab(,g)":click to run})}
{* graph scatter7}{...}

{pstd}
The important option above is {cmd:xscale(log)}, which caused {cmd:gnppc}
to be presented on a log scale.

{pstd}
We included {cmd:xlab(,g)} (abbreviated form of
{cmd:xlabel(, grid)}) to obtain {it:x} grid lines.
The values 30,000 and 40,000 are overprinted.  We could improve
the graph by typing

	{cmd:. generate gnp000 = gnppc/1000}

{phang2}
	{cmd:. label var gnp000 "GNP per capita, thousands of dollars"}

{phang2}
	{cmd:. scatter lexp gnp000, xsca(log) xlab(.5 2.5 10(10)40, grid)}
{p_end}
	  {it:({stata "gr_example2 scatterlog":click to run})}
{* graph scatterlog}{...}

{pstd}
See {manhelpi axis_options G-3}.


{marker remarks12}{...}
{title:Multiple axes}

{pstd}
Graphs may have more than one {it:y} axis and more than one {it:x} axis.
There are two reasons to do this:  you might include an extra axis so that you
have an extra place to label special values or so that you may plot multiple
variables on different scales.  In either case, specify the {cmd:yaxis()} or
{cmd:xaxis()} option.  See {manhelpi axis_choice_options G-3}.


{marker remarks13}{...}
{title:Markers}

{pstd}
Markers are the ink used to mark where points are on the plot.
Many people think of markers in terms of their shape (circles, diamonds,
etc.), but they have other properties, including, most
importantly, their color and size.
The shape of the marker is specified by the {cmd:msymbol()}
option, its color by the {cmd:mcolor()} option, and its size by the
{cmd:msize()} option.

{pstd}
By default, solid circles are used for the first {it:y} variable, solid
diamonds for the second, solid squares for the third, and so on;
see {it:{help scatter##marker_options:marker_options}} under {it:Options} for
the remaining details, if you care.  In any case, when you type

	{cmd:. scatter} {it:yvar} {it:xvar}

{pstd}
results are as if you typed

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, msymbol(O)}

{pstd}
You can vary the symbol used by specifying other {cmd:msymbol()} arguments.
Similarly, you can vary the color and size of the symbol by specifying the
{cmd:mcolor()} and {cmd:msize()} options.
See {manhelpi marker_options G-3}.

{pstd}
In addition to the markers themselves, you can request that the individual
points be labeled.  These marker labels are numbers or text that appear
beside the marker symbol -- or in place of it -- to identify the
points.  See {manhelpi marker_label_options G-3}.


{marker remarks14}{...}
{title:Weighted markers}

{pstd}
If weights are specified -- see {help weight} -- the size of the
marker is scaled according to the size of the weights.  {cmd:aweight}s,
{cmd:fweight}s, and {cmd:pweight}s are allowed and all are treated the same;
{cmd:iweight}s are not allowed because {cmd:scatter} would not know what to do
with negative values.  Weights affect the size of the marker and nothing else
about the plot.

{pstd}
Below we use U.S. state-averaged data to graph the divorce rate in a
state versus the state's median age.  We scale the symbols to be proportional
to the population size:

	{cmd:. sysuse census, clear}

	{cmd:. generate drate = divorce / pop18p}

	{cmd:. label var drate "Divorce rate"}

	{cmd:. scatter drate medage [w=pop18p] if state!="Nevada", msymbol(Oh)}
	     {cmd:note("Stata data excluding Nevada"}
	     {cmd:"Area of symbol proportional to state's population aged 18+")}
	  {it:({stata gr_example2 scatterwgt:click to run})}
{* graph scatterwgt}{...}

{pstd}
Note the use of the {cmd:msymbol(Oh)} option.  Hollow scaled markers look
much better than solid ones.

{pstd}
{cmd:scatter} scales the symbols so that the sizes are a fair representation
when the weights represent population weights.   If all the weights
except one are 1,000 and the exception is 999, the symbols will all be of
almost equal size.  The weight 999 observation will not be a dot and the
weight 1,000 observation giant circles as would be the result if the
exception had weight 1.

{pstd}
Weights are ignored when the {cmd:mlabel()} option is specified.
See {manhelpi marker_label_options G-3}.


{marker jitter}{...}
{marker remarks15}{...}
{title:Jittered markers}

{pstd}
{cmd:scatter} will add spherical random noise to your data before plotting if
you specify {cmd:jitter(}{it:#}{cmd:)}, where {it:#} represents the size of
the noise as a percentage of the graphical area.  This can be useful for
creating graphs of categorical data when, were the data not jittered, many of
the points would be on top of each other, making it impossible to tell whether
the plotted point represented one or 1,000 observations.

{pstd}
For instance, in a variation on {cmd:auto.dta} used below, {cmd:mpg} is
recorded in units of 5 {cmd:mpg}, and {cmd:weight} is recorded in units of 500
pounds.  A standard scatter has considerable overprinting:

	{cmd:. sysuse autornd, clear}

	{cmd:. scatter mpg weight}
	  {it:({stata "gr_example autornd: scatter mpg weight":click to run})}
{* graph scatter8}{...}

{pstd}
There are 74 points in the graph, even though it appears because of
overprinting as if there are only 19.  Jittering solves that problem:

	{cmd:. scatter mpg weight, jitter(7)}
	  {it:({stata "gr_example autornd: scatter mpg weight, jitter(7)":click to run})}
{* graph scatter9}{...}


{marker remarks16}{...}
{title:Connected lines}

{pstd}
The {cmd:connect()} option allows you to connect the points of a graph.  The
default is not to connect the points.

{pstd}
If you want connected points, you probably want to specify {cmd:connect(l)},
which is usually abbreviated {cmd:c(l)}.  The {cmd:l} means that the points
are to be connected with straight lines.  Points can be connected in other 
ways (such as a stairstep fashion), but usually {cmd:c(l)} is the right
choice.  The command

	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, c(l)}

{pstd}
will plot {it:yvar} versus {it:xvar}, marking the points in the usual
way, and drawing straight lines between the points.  It is common also to
specify the {cmd:sort} option,

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, c(l) sort}

{pstd}
because otherwise points are connected in the order of the data.  If the data
are already in the order of {it:xvar}, the {cmd:sort} is unnecessary.
You can also omit the {cmd:sort} when creating special effects.

{pstd}
{cmd:connect()} is often specified with the {cmd:msymbol(i)} option to
suppress the display of the individual points:

{phang2}
	{cmd:. scatter} {it:yvar} {it:xvar}{cmd:, c(l) sort m(i)}

{pstd}
See {manhelpi connect_options G-3}.


{marker remarks17}{...}
{title:Graphs by groups}

{pstd}
Option {cmd:by()} specifies that graphs are to be drawn separately for each of
the different groups and the results arrayed into one display.
Below we use country data and group the results by region of the world:

	{cmd:. sysuse lifeexp, clear}

	{cmd:. scatter lexp gnppc, by(region)}
	  {it:({stata "gr_example lifeexp: scatter lexp gnppc, by(region)":click to run})}
{* graph scatter10}{...}

{pstd}
Variable {cmd:region} is a numeric variable taking on values 1, 2, and 3.
Separate graphs were drawn for each value of region.  The graphs were titled
"Eur & C. Asia", "N.A.", and "S.A."  because numeric variable {cmd:region} had
been assigned a value label, but results would have been the same had variable
{cmd:region} been a string directly containing "Eur & C. Asia", "N.A.", and
"S.A.".

{pstd}
See 
{manhelpi by_option G-3} for more information on this useful option.


{marker remarks18}{...}
{title:Saving graphs}

{pstd}
To save a graph to disk for later printing or reviewing, include the
{cmd:saving()} option,

{phang2}
	{cmd:. scatter} ...{cmd:,} ... {cmd:saving(}{it:filename}{cmd:)}

{pstd}
or use the {cmd:graph} {cmd:save} command afterward:

	{cmd:. scatter} ...
	{cmd:. graph save} {it:filename}

{pstd}
See {manhelpi saving_option G-3} and {manhelp graph_save G-2:graph save}.  Also
see {help gph files} for information on how files such as
{it:filename}{cmd:.gph} can be put to subsequent use.


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=GhVGpe3lb3E":Basic scatterplots in Stata}


{marker remarks19}{...}
{title:Appendix:  Styles and composite styles}

{pstd}
Many options end in the word style, including
{cmd:mstyle()}, {cmd:mlabstyle()}, and {cmd:lstyle()}.  Option
{cmd:mstyle()}, for instance, is described as setting the "overall look" of
a marker.  What does that mean?

{pstd}
How something looks -- a marker, a marker label, a line -- is
specified by many detail options.  For markers, option
{cmd:msymbol()} specifies its shape, {cmd:mcolor()} specifies its color
and opacity, {cmd:msize()} specifies its size, and so on.

{pstd}
A {it:style} specifies a composite of related option settings.  If you typed
option {cmd:mstyle(p1)}, you would be specifying a whole set of values for
{cmd:msymbol()}, {cmd:mcolor()}, {cmd:msize()}, and all the other {cmd:m*()}
options.  {cmd:p1} is called the name of a style, and {cmd:p1} contains the
settings.

{pstd}
Concerning {cmd:mstyle()} and all the other options ending in the word style,
throughout this manual you will read statements such as

{pmore}
    Option {it:whatever}{cmd:style()} specifies the overall look of
    {it:whatever}, such as its {it:(insert list here)}.  The other options
    allow you to change the attributes of a {it:whatever}, but
    {it:whatever}{cmd:style()} is the starting point.

{pmore}
     You need not specify {it:whatever}{cmd:style()} just because there is
     something you want to change about the look of a {it:whatever}, and in
     fact, most people seldom specify the {it:whatever}{cmd:style()} option.
     You specify {it:whatever}{cmd:style()} when another style exists that is
     exactly what you desire or when another style would allow you to specify
     fewer changes to obtain what you want.

{pstd}
Styles actually come in two forms called {it:composite styles} and
{it:detail} {it:styles}, and the above statement applies only to composite
styles and appears only in manual entries concerning composite styles.
Composite styles are specified in options that end in the word style.  The
following are examples of composite styles:

	{cmd:mstyle(}{it:{help symbolstyle}}{cmd:)}
	{cmd:mlstyle(}{it:{help linestyle}}{cmd:)}
	{cmd:mlabstyle(}{it:{help markerlabelstyle}}{cmd:)}
	{cmd:lstyle(}{it:{help linestyle}}{cmd:)}
	{cmd:pstyle(}{it:{help pstyle}}{cmd:)}

{pstd}
The following are examples of detail styles:

	{cmd:mcolor(}{it:{help colorstyle}}{cmd:)}
	{cmd:mlwidth(}{it:{help linewidthstyle}}{cmd:)}
	{cmd:mlabsize(}{it:{help textsizestyle}}{cmd:)}
	{cmd:lpattern(}{it:{help linepatternstyle}}{cmd:)}

{pstd}
In the above examples, distinguish carefully between option names such as
{cmd:mcolor()} and option arguments such as {it:colorstyle}.  {it:colorstyle}
is an example of a detail style because it appears in the option
{cmd:mcolor()}, and the option name does not end in the word style.

{pstd}
Detail styles specify precisely how an attribute of something looks, and
composite styles specify an "overall look" in terms of detail-style values.

{pstd}
Composite styles sometimes contain other composite styles as members.  For
instance, when you specify the {cmd:mstyle()} option -- which specifies
the overall look of markers -- you are also specifying an
{cmd:mlstyle()} -- which specifies the overall look of the lines that
outline the shape of the markers.  That does not mean you cannot specify the
{cmd:mlstyle()} option, too.  It just means that specifying {cmd:mstyle()}
implies an {cmd:mlstyle()}.  The order in which you specify the options does
not matter.  You can type

{phang2}
	{cmd:. scatter} ...{cmd:,} ... {cmd:mstyle(}...{cmd:)} ... {cmd:mlstyle(}...{cmd:)} ...

{pstd}
or

{phang2}
	{cmd:. scatter} ...{cmd:,} ... {cmd:mlstyle(}...{cmd:)} ... {cmd:mstyle(}...{cmd:)} ...

{pstd}
and, either way, {cmd:mstyle()} will be set as you specify, and then
{cmd:mlstyle()} will be reset as you wish.  The same applies for mixing
composite-style and detail-style options.  Option {cmd:mstyle()} implies an
{cmd:mcolor()} value.  Even so, you may type

{phang2}
	{cmd:. scatter} ...{cmd:,} ... {cmd:mstyle(}...{cmd:)} ... {cmd:mcolor(}...{cmd:)} ...

{pstd}
or

{phang2}
	{cmd:. scatter} ...{cmd:,} ... {cmd:mcolor(}...{cmd:)} ... {cmd:mstyle(}...{cmd:)} ...

{pstd}
and the outcome will be the same.

{pstd}
The grandest composite style of them all is {cmd:pstyle(}{it:pstyle}{cmd:)}.
It contains all the other composite styles and {cmd:scatter} ({cmd:twoway},
in fact) makes great use of this grand style.
When you type

{phang2}
	{cmd:. scatter} {it:y1var} {it:y2var} {it:xvar}{cmd:,} ...

{pstd}
results are as if you typed

{phang2}
	{cmd:. scatter} {it:y1var} {it:y2var} {it:xvar}{cmd:,} {cmd:pstyle(p1 p2)} ...

{pstd}
That is, {it:y1var} versus {it:xvar} is plotted using {cmd:pstyle(p1)}, and
{it:y2var} versus {it:xvar} is plotted using {cmd:pstyle(p2)}.
It is the {cmd:pstyle(p1)} that sets all the defaults --  which marker
symbols are used, what color they are, etc.

{pstd}
The same applies if you type

{phang2}
	{cmd:. scatter} {it:y1var} {it:xvar}{cmd:,} ... {cmd:||}
		{cmd:scatter} {it:y2var} {it:xvar}{cmd:,} ...

{pstd}
{it:y1var} versus {it:xvar} is plotted using {cmd:pstyle(p1)}, and
{it:y2var} versus {it:xvar} is plotted using {cmd:pstyle(p2)}, just as if
you had typed

{phang2}
	{cmd:. scatter} {it:y1var} {it:xvar}{cmd:,} {cmd:pstyle(p1)} ... {cmd:||}
		{cmd:scatter} {it:y2var} {it:xvar}{cmd:,} {cmd:pstyle(p2)} ...

{pstd}
The same applies if you mix {cmd:scatter} with other plottypes:

{phang2}
	{cmd:. scatter} {it:y1var} {it:xvar}{cmd:,} ... {cmd:||}
		{cmd:line} {it:y2var} {it:xvar}{cmd:,} ...

{pstd}
is equivalent to

{phang2}
	{cmd:. scatter} {it:y1var} {it:xvar}{cmd:,} {cmd:pstyle(p1)} ... {cmd:||}
		{cmd:line} {it:y2var} {it:xvar}{cmd:,} {cmd:pstyle(p2)} ...

{pstd}
and,

	{cmd:. twoway (}..., ...{cmd:) (}..., ...{cmd:),} ...

{pstd}
is equivalent to

{phang2}
	{cmd:. twoway (}..., {cmd:pstyle(p1)} ...{cmd:) (}...{cmd:,} {cmd:pstyle(p2)} ...{cmd:),} ...

{pstd}
which is why we said that it is {cmd:twoway}, and not just {cmd:scatter}, that
exploits {cmd:scheme()}.

{pstd}
You can put this to use.  Pretend that you have a dataset on husbands and
wives and it contains the variables

	{cmd:hinc}        husband's income
	{cmd:winc}        wife's income
	{cmd:hed}         husband's education
	{cmd:wed}         wife's education

{pstd}
You wish to draw a graph of income versus education, drawing no distinctions
between husbands and wives.  You type

	{cmd:. scatter hinc hed || scatter winc wed}

{pstd}
You intend to treat husbands and wives the same in the graph, but in the
above example, they are treated differently because {cmd:msymbol(O)} will be
used to mark the points of {cmd:hinc} versus {cmd:hed} and {cmd:msymbol(D)}
will be used to designate {cmd:winc} versus {cmd:wed}.  The color of the
symbols will be different, too.

{pstd}
You could address that problem in many different ways.  You could specify
the {cmd:msymbol()} and {cmd:mcolor()} options (see
{manhelpi marker_options G-3}), along with whatever other
detail options are necessary to make the two scatters appear the same.
Being knowledgeable, you realize you do not have to do that.  There is,
you know, a composite style that specifies this.  So you get out your
manuals, flip through, and discover that the relevant composite style for
the marker symbols is {cmd:mstyle()}.

{pstd}
Easiest of all, however, would be to remember that {cmd:pstyle()} contains
all the other styles.  Rather than resetting {cmd:mstyle()}, just reset
{cmd:pstyle()}, and whatever needs to be set to make the two plots the same
will be set.  Type

	{cmd:. scatter hinc hed || scatter winc wed, pstyle(p1)}

{pstd}
or, if you prefer,

{phang2}
	{cmd:. scatter hinc hed, pstyle(p1) || scatter winc wed, pstyle(p1)}

{pstd}
You do not need to specify {cmd:pstyle(p1)} for the first plot, however,
because that is the default.

{pstd}
As another example, you have a dataset containing

	{cmd:mpg}         Mileage ratings of cars
	{cmd:weight }     Each car's weight
	{cmd:prediction}  A predicted mileage rating based on weight

{pstd}
You wish to draw the graph

{phang2}
	{cmd:. scatter mpg weight || line prediction weight}

{pstd}
but you wish the appearance of the line to "match" that of the markers used
to plot {cmd:mpg} versus {cmd:weight}.  You could go digging to find out which
option controlled the line style and color and then dig some more to figure
out which line style and color goes with the markers used in the first plot,
but much easier is simply to type

{phang2}
	{cmd:. scatter mpg weight || line prediction weight, pstyle(p1)}
{p_end}
