{smcl}
{* *! version 1.4.1  04jun2017}{...}
{vieweralsosee "[G-2] graph export" "mansection G-2 graphexport"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-3] eps_options" "help eps_options"}{...}
{vieweralsosee "[G-3] gif_options" "help gif_options"}{...}
{vieweralsosee "[G-3] jpg_options" "help jpg_options"}{...}
{vieweralsosee "[G-3] png_options" "help png_options"}{...}
{vieweralsosee "[G-3] ps_options" "help ps_options"}{...}
{vieweralsosee "[G-3] svg_options" "help svg_options"}{...}
{vieweralsosee "[G-3] tif_options" "help tif_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph display" "help graph_display"}{...}
{vieweralsosee "[G-2] graph set" "help graph_set"}{...}
{vieweralsosee "[G-2] graph use" "help graph_use"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph print" "help graph_print"}{...}
{viewerjumpto "Syntax" "graph_export##syntax"}{...}
{viewerjumpto "Description" "graph_export##description"}{...}
{viewerjumpto "Links to PDF documentation" "graph_export##linkspdf"}{...}
{viewerjumpto "Options" "graph_export##options"}{...}
{viewerjumpto "Remarks" "graph_export##remarks"}{...}
{viewerjumpto "Technical note for Stata for Unix(GUI) users" "graph_export##technote"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-2] graph export} {hline 2}}Export current graph{p_end}
{p2col:}({mansection G-2 graphexport:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:gr:aph}
{cmd:export}
{it:newfilename}{cmd:.}{it:suffix}
[{cmd:,}
{it:options}]

    {it:options}{col 35}Description
    {hline 69}
    {cmd:name(}{it:windowname}{cmd:)}{...}
{col 35}name of Graph window to export 
    {cmd:as(}{it:fileformat}{cmd:)}{...}
{col 35}desired format of output
    {cmd:replace}{...}
{col 35}{it:newfilename} may already exist
    {it:override_options}{...}
{col 35}override defaults in conversion
    {hline 69}

{pstd}
If {cmd:as()} is not specified, the output format is determined by the suffix
of {it:newfilename}{cmd:.}{it:suffix}:

    {col 20}Implied
    {it:suffix}{col 20}option{col 35}Output format
    {hline 69}
    {cmd:.ps}{col 20}{cmd:as(ps)}{col 35}PostScript
    {cmd:.eps}{col 20}{cmd:as(eps)}{col 35}EPS (Encapsulated PostScript)
    {cmd:.svg}{col 20}{cmd:as(svg)}{col 35}SVG (Scalable Vector Graphics)
    {cmd:.wmf}{col 20}{cmd:as(wmf)}{col 35}Windows Metafile
    {cmd:.emf}{col 20}{cmd:as(emf)}{col 35}Windows Enhanced Metafile
    {cmd:.pdf}{col 20}{cmd:as(pdf)}{col 35}PDF (Portable Document Format)
    {cmd:.png}{col 20}{cmd:as(png)}{col 35}PNG (Portable Network Graphics)
    {cmd:.tif}{col 20}{cmd:as(tif)}{col 35}TIFF (Tagged Image File Format)
    {cmd:.gif}{col 20}{cmd:as(gif)}{col 35}GIF (Graphics Interchange Format)
    {cmd:.jpg}{col 20}{cmd:as(jpg)}{col 35}JPEG (Joint Photographic Experts Group)
    {it: other}{col 35}must specify {cmd:as()}
    {hline 69}
{phang}
{cmd:ps}, {cmd:eps}, and {cmd:svg} are available for all versions of Stata;
{cmd: png} and {cmd:tif} are available for all versions of Stata except
Stata(console); {cmd:wmf} and {cmd:emf} are available only for
Stata for Windows; and {cmd:gif} and {cmd:jpg} are available only for
Stata for Mac.

    {it:override_options}{col 35}Description
    {hline 69}
    {it:{help ps_options}}{...}
{col 30}when exporting to {cmd:ps}
    {it:{help eps_options}}{...}
{col 30}when exporting to {cmd:eps}
    {it:{help svg_options}}{...}
{col 30}when exporting to {cmd:svg}
    {it:{help png_options}}{...}
{col 30}when exporting to {cmd:png}
    {it:{help tif_options}}{...}
{col 30}when exporting to {cmd:tif}
    {it:{help gif_options}}{...}
{col 30}when exporting to {cmd:gif}
    {it:{help jpg_options}}{...}
{col 30}when exporting to {cmd:jpg}
    {hline 69}

{phang}
There are no override_options for the {cmd:pdf} format.


{marker description}{...}
{title:Description}

{pstd}
{cmd:graph} {cmd:export} exports to a file the graph displayed
in a Graph window.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-2 graphexportQuickstart:Quick start}

        {mansection G-2 graphexportRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
    {cmd:name(}{it:windowname}{cmd:)} specifies which window to export from when
    exporting a graph.  Omitting the {cmd:name()} option exports the
    topmost graph (Stata for Unix(GUI) users: see 
    {it:{help graph export##GUI:Technical note for Stata for Unix(GUI) users}}).
    The name for a window is displayed inside parentheses in the window title.
    For example, if the title for a Graph window is {hi:Graph (MyGraph)},
    the name for the window is {hi:MyGraph}.  If a graph is an {cmd:asis} or
    {cmd:graph7} graph where there is no name in the window title,
    specify "" for {it:windowname}.

{phang}
{cmd:as(}{it:fileformat}{cmd:)}
    specifies the file format to which the graph is to be exported.
    This option is rarely specified because, by default, {cmd:graph}
    {cmd:export} determines the format from the suffix of the
    file being created.

{phang}
{cmd:replace}
    specifies that it is okay to replace {it:filename}{cmd:.}{it:suffix}
    if it already exists.

{phang}
{it:override_options}
    modify how the graph is converted.  See 
    {manhelpi ps_options G-3},
    {manhelpi eps_options G-3},
    {manhelpi svg_options G-3},
    {manhelpi png_options G-3},
    {manhelpi tif_options G-3},
    {manhelpi gif_options G-3}, and
    {manhelpi jpg_options G-3}.
    See also {manhelp graph_set G-2:graph set} for permanently setting default
    values for the {it:override_options}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Graphs are exported by displaying them on the screen and then typing

	{cmd:. graph export} {it:filename}{cmd:.}{it:suffix}

{pstd}
Remarks are presented under the following headings:

	{help graph export##remarks1:Exporting the graph displayed in a Graph window}
	{help graph export##remarks2:Exporting a graph stored on disk}
	{help graph export##remarks3:Exporting a graph stored in memory}

{pstd}
If your interest is simply in printing a graph, see
{manhelp graph_print G-2:graph print}.


{marker remarks1}{...}
{title:Exporting the graph displayed in a Graph window}

{pstd}
There are three ways to export the graph displayed in a Graph window:

{phang2}
    1.  Right-click on the Graph window, select {bf:Save Graph...}, and choose
	the appropriate {bf:Save as type}.

{phang2}
    2.  Select {bf:File > Save Graph...}, and choose
	the appropriate {bf:Save as type}.

{phang2}
    3.  Type "{cmd:graph} {cmd:export} {it:filename}{cmd:.}{it:suffix}"
        in the Command window.  Stata for Unix(GUI) users should use the
        {cmd:name()} option if there is more than one graph displayed to
	ensure that the correct graph is exported (see
	{it:{help graph export##GUI:Technical note for Stata for Unix(GUI) users}}).

{pstd}
All three are equivalent.  The advantage of {cmd:graph} {cmd:export} is that you
can include it in do-files:

	{cmd:. graph} ...{col 40}(draw a graph)

	{cmd:. graph export} {it:filename}{cmd:.}{it:suffix}{...}
{col 40}(and export it)

{pstd}
By default, {cmd:graph} {cmd:export} determines the output type by the
{it:suffix}.  If we wanted to create an Encapsulated PostScript file,
we might type

	{cmd:. graph export figure57.eps}


{marker remarks2}{...}
{title:Exporting a graph stored on disk}

{pstd}
To export a graph stored on disk, type

	{cmd:. graph use} {it:gph_filename}

	{cmd:. graph export} {it:output_filename}{cmd:.}{it:suffix}


{pstd}
Do not specify {cmd:graph} {cmd:use}'s {cmd:nodraw} option; see 
{manhelp graph_use G-2:graph use}.

{pstd}
Stata(console) for Unix users:  follow the instructions just given,
even though you have no Graph window and cannot see what has just been
"displayed".  Use the graph, and then export it.


{marker remarks3}{...}
{title:Exporting a graph stored in memory}

{pstd}
To export a graph stored in memory but not currently displayed, type

	{cmd:. graph display} {it:name}

	{cmd:. graph export} {it:filename}{cmd:.}{it:suffix}

{pstd}
Do not specify {cmd:graph} {cmd:display}'s {cmd:nodraw} option; see 
{manhelp graph_display G-2:graph display}.

{pstd}
Stata for Unix(console) users:  follow the instructions just given,
even though you have no Graph window and cannot see what has just been
"displayed".  Display the graph, and then export it.


{marker technote}{...}
{marker GUI}{...}
{title:Technical note for Stata for Unix(GUI) users}

{pstd}
X-Windows does not have a concept of a window z-order, which prevents Stata
from determining which window is the topmost window.  Instead, Stata
determines which window is topmost based on which window has the focus.
However, some window managers will set the focus to a window without bringing
the window to the top.  What Stata considers the topmost window to Stata may
not appear topmost visually.  For this reason, you should always use the
{cmd:name()} option to ensure that the correct Graph window is exported.
{p_end}
