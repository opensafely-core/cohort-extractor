{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[G-3] png_options" "mansection G-3 png_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph set" "help graph_set"}{...}
{viewerjumpto "Syntax" "png_options##syntax"}{...}
{viewerjumpto "Description" "png_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "png_options##linkspdf"}{...}
{viewerjumpto "Options" "png_options##options"}{...}
{viewerjumpto "Remarks" "png_options##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-3]} {it:png_options} {hline 2}}Options for exporting to portable network graphics (PNG) format{p_end}
{p2col:}({mansection G-3 png_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:png_options}}Description{p_end}
{p2line}
{p2col:{cmdab:wid:th:(}{it:#}{cmd:)}}width of graph in pixels{p_end}
{p2col:{cmdab:hei:ght:(}{it:#}{cmd:)}}height of graph in pixels{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {it:png_options} are used with {cmd:graph} {cmd:export} when creating
graphs in PNG format; see {manhelp graph_export G-2:graph export}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 png_optionsRemarksandexamples:Remarks and examples}

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

	{help png_options##remarks1:Using png_options}
	{help png_options##remarks2:Specifying the width or height}


{marker remarks1}{...}
{title:Using png_options}

{pstd}
You have drawn a graph and wish to create a PNG file to include in a document.
You wish, however, to set the width of the graph to 800 pixels and the height
to 600 pixels:

	{cmd:. graph} ...{col 50}(draw a graph)

{phang2}
	{cmd:. graph export myfile.png, width(800) height(600)}


{marker remarks2}{...}
{title:Specifying the width or height}

{pstd}
If the width is specified but not the height, Stata determines the appropriate
height from the graph's aspect ratio.  If the height is specified but
not the width, Stata determines the appropriate width from the graph's aspect
ratio.  If neither the width nor the height is specified, Stata
will export the graph on the basis of the current size of the Graph window.
{p_end}
