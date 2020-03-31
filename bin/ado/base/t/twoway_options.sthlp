{smcl}
{* *! version 1.1.6  19oct2017}{...}
{vieweralsosee "[G-3] twoway_options" "mansection G-3 twoway_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] advanced_options" "help advanced_options"}{...}
{vieweralsosee "[G-3] axis_options" "help axis_options"}{...}
{vieweralsosee "[G-3] by_option" "help by_option"}{...}
{vieweralsosee "[G-3] legend_options" "help legend_options"}{...}
{vieweralsosee "[G-3] name_option" "help name_option"}{...}
{vieweralsosee "[G-3] nodraw_option" "help nodraw_option"}{...}
{vieweralsosee "[G-3] region_options" "help region_options"}{...}
{vieweralsosee "[G-3] saving_option" "help saving_option"}{...}
{vieweralsosee "[G-3] scale_option" "help scale_option"}{...}
{vieweralsosee "[G-3] scheme_option" "help scheme_option"}{...}
{vieweralsosee "[G-3] title_options" "help title_options"}{...}
{viewerjumpto "Syntax" "twoway_options##syntax"}{...}
{viewerjumpto "Description" "twoway_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "twoway_options##linkspdf"}{...}
{viewerjumpto "Options" "twoway_options##options"}{...}
{viewerjumpto "Remarks" "twoway_options##remarks"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[G-3]} {it:twoway_options} {hline 2}}Options for twoway graphs{p_end}
{p2col:}({mansection G-3 twoway_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
The {it:twoway_options} allowed with all {cmd:twoway} graphs are

{synoptset 25}{...}
{p2col:{it:twoway_options}}Description{p_end}
{p2line}
{p2col:{it:{help added_line_options}}}draw lines at specified {it:y} or
      {it:x} values{p_end}
{p2col:{it:{help added_text_options}}}display text at specified
      ({it:y},{it:x}) value{p_end}

{p2col:{it:{help axis_options}}}labels, ticks, grids, log scales{p_end}
{p2col:{it:{help title_options}}}titles, subtitles, notes, captions{p_end}
{p2col:{it:{help legend_options}}}legend explaining what means what{p_end}

{p2col:{help scale_option:{bf:scale(}{it:#}{bf:)}}}resize text, markers, and
        line widths{p_end}
{p2col:{it:{help region_options}}}outlining, shading, graph size{p_end}
{p2col:{it:{help aspect_option}}}constrain aspect ratio of plot region{p_end}
{p2col:{help scheme_option:{bf:scheme(}{it:schemename}{cmd:)}}}overall
       look{p_end}
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


{marker description}{...}
{title:Description}

{pstd}
The above options are allowed with all {it:plottypes} 
({cmd:scatter}, {cmd:line}, etc.) allowed by {helpb graph twoway}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 twoway_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{it:added_line_options}
    specify that horizontal or vertical lines be drawn on the graph; see 
    {manhelpi added_line_options G-3}.  If your interest is in drawing grid
    lines through the plot region, see {it:axis_options} below.

{phang}
{it:added_text_options}
    specifies text to be displayed on the graph (inside the plot region);
    see {manhelpi added_text_options G-3}.

{phang}
{it:axis_options}
    specify how the axes are to look, including values to be labeled or ticked
    on the axes.  These options also allow you to obtain logarithmic scales
    and grid lines.  See {manhelpi axis_options G-3}.

{phang}
{it:title_options}
        allow you to specify titles, subtitles, notes, and captions
        to be placed on the graph; see {manhelpi title_options G-3}.

{phang}
{it:legend_options}
    specifies whether a legend is to appear and allows you to modify the
    legend's contents.
    See {manhelpi legend_options G-3}.

{phang}
{cmd:scale(}{it:#}{cmd:)}
    specifies a multiplier that affects the size of all text, markers, and
    line widths in a graph.  {cmd:scale(1)} is the default, and
    {cmd:scale(1.2)} would make all text, markers, and line widths 20% larger.
    See {manhelpi scale_option G-3}.

{phang}
{it:region_options}
    allow outlining the plot region (such as placing or suppressing a border
    around the graph), specifying a background shading for the region, and 
    controlling the graph size.  See {manhelpi region_options G-3}.

{phang}
{it:aspect_option}
    allows you to control the relationship between the height and width of
    a graph's plot region; see {manhelpi aspect_option G-3}.

{phang}
{cmd:scheme(}{it:schemename}{cmd:)}
    specifies the overall look of the graph;
    see {manhelpi scheme_option G-3}.

{phang}
INCLUDE help playopt_desc

{phang}
{cmd:by(}{varlist}{cmd:,} ...{cmd:)}
    specifies that the plot be repeated for each set of values of
    {it:varlist}; see {manhelpi by_option G-3}.

{phang}
{cmd:nodraw}
    causes the graph to be constructed but not displayed;
    see {manhelpi nodraw_option G-3}.

{phang}
{cmd:name(}{it:name}[{cmd:, replace}]{cmd:)}
    specifies the name of the graph.  {cmd:name(Graph, replace)} is the default.
    See {manhelpi name_option G-3}.

{phang}
    {cmd:saving(}{it:{help filename}}[{cmd:, asis replace}]{cmd:)}
    specifies that the graph be saved as {it:filename}.  If {it:filename}
    is specified without an extension, {cmd:.gph} is assumed.
    {cmd:asis} specifies that the graph be saved just as it is.
    {cmd:replace} specifies that, if the file already exists, it is okay
    to replace it.
    See {manhelpi saving_option G-3}.

{phang}
{it:advanced_options}
    are not so much advanced as they are difficult to explain and are
    rarely used.  They are also invaluable when you need them; see 
    {manhelpi advanced_options G-3}.


{marker remarks}{...}
{title:Remarks}

{pstd}
The above options may be used with any of the {cmd:twoway}
plottypes -- see {manhelp twoway G-2:graph twoway} -- for instance,

	{cmd:. twoway scatter mpg weight, by(foreign)}

{phang2}
	{cmd:. twoway line le year, xlabel(,grid) saving(myfile, replace)}

{pstd}
The above options are options of {cmd:twoway}, meaning that
they affect the entire twoway graph and not just one or the other of the plots
on it.  For instance, in

	{cmd}. twoway lfitci  mpg weight, stdf ||
		 scatter mpg weight, ms(O) by(foreign, total row(1)){txt}

{pstd}
the {cmd:by()} option applies to the entire graph, and in theory you should
type

	{cmd}. twoway lfitci  mpg weight, stdf  ||
		 scatter mpg weight, ms(O) ||, by(foreign, total row(1)){txt}

{pstd}
or

	{cmd}. twoway (lfitci  mpg weight, stdf)
		 (scatter mpg weight, ms(O)), by(foreign, total row(1)){txt}

{pstd}
to demonstrate your understanding of that fact.  You need not do that, however,
and in fact it does not matter to which plot you attach the
{it:twoway_options}.
You could even type

	{cmd}. twoway lfitci  mpg weight, stdf by(foreign, total row(1)) ||
		 scatter mpg weight, ms(O){txt}

{pstd}
and, when specifying multiple {it:twoway_options}, you could even attach
some to one plot and the others to another:

	{cmd}. twoway lfitci  mpg weight, stdf by(foreign, total row(1)) ||
		 scatter mpg weight, ms(O) saving(myfile){txt}
