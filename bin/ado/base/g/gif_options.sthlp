{smcl}
{* *! version 1.0.1  04jun2018}{...}
{vieweralsosee "[G-3] gif_options" "mansection G-3 gif_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph set" "help graph_set"}{...}
{viewerjumpto "Syntax" "gif_options##syntax"}{...}
{viewerjumpto "Description" "gif_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "gif_options##linkspdf"}{...}
{viewerjumpto "Options" "gif_options##options"}{...}
{viewerjumpto "Remarks" "gif_options##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-3]} {it:gif_options} {hline 2}}Options for exporting to Graphics
Interchange Format (GIF){p_end}
{p2col:}({mansection G-3 gif_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:gif_options}}Description{p_end}
{p2line}
{p2col:{cmdab:wid:th:(}{it:#}{cmd:)}}width of graph in pixels{p_end}
{p2col:{cmdab:hei:ght:(}{it:#}{cmd:)}}height of graph in pixels{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {it:gif_options} are used with {cmd:graph} {cmd:export} when creating
GIF graphs; see {manhelp graph_export G-2:graph export}. GIF support is
available only in Stata for Mac.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 gif_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:width(}{it:#}{cmd:)}
    specifies the width of the graph in pixels.  {cmd:width()} must
    contain an integer between 8 and 16,000.

{phang}
{cmd:height(}{it:#}{cmd:)}
    specifies the height of the graph in pixels.  {cmd:height()} must
    contain an integer between 8 and 16,000.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help gif_options##remarks1:Using gif_options}
	{help gif_options##remarks2:Specifying the width or height}


{marker remarks1}{...}
{title:Using gif_options}

{pstd}
You have drawn a graph and wish to create a GIF file to include in a
web page.  You wish, however, to set the width of the graph to 800 pixels and
the height to 600 pixels:

	{cmd:. graph} ...{col 50}(draw a graph)

{phang2}
	{cmd:. graph export myfile.gif, width(800) height(600)}


{marker remarks2}{...}
{title:Specifying the width or height}

{pstd}
If the width is specified but not the height, Stata determines the appropriate
height from the graph's aspect ratio.  If the height is specified but
not the width, Stata determines the appropriate width from the graph's aspect
ratio.  If neither the width nor the height is specified, Stata
will export the graph on the basis of the current size of the Graph window.
{p_end}
