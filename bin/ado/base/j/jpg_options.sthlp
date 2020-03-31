{smcl}
{* *! version 1.0.1  04jun2018}{...}
{vieweralsosee "[G-3] jpg_options" "mansection G-3 jpg_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph set" "help graph_set"}{...}
{viewerjumpto "Syntax" "jpg_options##syntax"}{...}
{viewerjumpto "Description" "jpg_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "jpg_options##linkspdf"}{...}
{viewerjumpto "Options" "jpg_options##options"}{...}
{viewerjumpto "Remarks" "jpg_options##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-3]} {it:jpg_options} {hline 2}}Options for exporting to Joint Photographic Experts Group
(JPEG) format{p_end}
{p2col:}({mansection G-3 jpg_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 20}{...}
{p2col:{it:jpg_options}}Description{p_end}
{p2line}
{p2col:{cmdab:wid:th:(}{it:#}{cmd:)}}width of graph in pixels{p_end}
{p2col:{cmdab:hei:ght:(}{it:#}{cmd:)}}height of graph in pixels{p_end}
{p2col:{cmdab:q:uality:(}{it:#}{cmd:)}}JPEG quality setting; default is {cmd:quality(90)}{p_end}
{p2line}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {it:jpg_options} are used with {cmd:graph} {cmd:export} when creating
JPEG graphs; see {manhelp graph_export G-2:graph export}. JPEG support is
available only in Stata for Mac.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 jpg_optionsRemarksandexamples:Remarks and examples}

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

{phang}
{cmd:quality(}{it:#}{cmd:)}
    specifies the JPEG quality setting.  {cmd:quality()} must
    contain an integer between 0 and 100.  The default is {cmd:quality(90)},
    meaning high image quality with some compression.  A quality setting of 0
    results in low image quality using the maximum compression possible,
    whereas a quality setting of 100 results in the highest image quality
    possible using no compression but a larger file size.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help jpg_options##remarks1:Using jpg_options}
	{help jpg_options##remarks2:Specifying the width or height}
	{help jpg_options##remarks3:Image quality}


{marker remarks1}{...}
{title:Using jpg_options}

{pstd}
You have drawn a graph and wish to create a JPEG file to include in a
web page.  You wish, however, to set the width of the graph to 800 pixels,
set the height to 600 pixels, and decrease the file size by setting the
quality setting to 60:

	{cmd:. graph} ...{col 50}(draw a graph)

{phang2}
	{cmd:. graph export myfile.jpg, width(800) height(600) quality(60)}


{marker remarks2}{...}
{title:Specifying the width or height}

{pstd}
If the width is specified but not the height, Stata determines the appropriate
height from the graph's aspect ratio.  If the height is specified but
not the width, Stata determines the appropriate width from the graph's aspect
ratio.  If neither the width nor the height is specified, Stata
will export the graph on the basis of the current size of the Graph window.
{p_end}


{marker remarks3}{...}
{title:Image quality}

{pstd}
The JPEG format is a bitmap format and is ideal for web use where the image
quality may not be as important as minimizing the file size.  You can strike a
balance between image quality and file size by lowering the quality setting
until visible compression artifacts are introduced into the image.  If you
intend to use the graph for any kind of print purpose, you should use the
maximum quality setting or use a nonlossy bitmap format such as TIFF.  For
the best print quality, avoid bitmap formats altogether and use a scalable
vector format such as PDF, SVG, or EPS.
{p_end}

