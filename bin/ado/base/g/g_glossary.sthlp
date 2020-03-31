{smcl}
{* *! version 1.0.3  17apr2019}{...}
{vieweralsosee "[G-4] Glossary" "mansection G-4 Glossary"}{...}
{viewerjumpto "Description" "g_glossary##description"}{...}
{viewerjumpto "Glossary" "g_glossary##glossary"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[G-4] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection G-4 Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:added line}.
Added lines are lines added by {it:added_line_options} that extend
across the plot region and perhaps across the plot region's margins.  For
instance, {opt yline()} adds horizontal lines at the specified values, 
whereas {opt xline()} adds vertical lines at the specified values.
See {manhelpi added_line_options G-3}.

{phang}
{bf:addedlinestyle}.
{it:addedlinestyle} specifies the overall look of added lines.
The look of the added line is defined by the {it:linestyle} and whether
or not the line extends through the margins of the plot region.
See {manhelpi addedlinestyle G-4} and {manhelpi linestyle G-4}.

{marker alignmentstyle}{...}
{phang}
{bf:alignmentstyle}.
{it:alignmentstyle} specifies how text is vertically aligned in a
textbox, that is, whether text should appear on the baseline of a textbox,
near the bottom, in the middle, or at the top.  See
{manhelpi alignmentstyle G-4}.

{phang}
{bf:anglestyle}.
{it:anglestyle} specifies the angle at which text is to be displayed.
The text could be displayed horizontally, vertically, at a 45-degree angle,
or at any angle that you desire.  See {manhelpi anglestyle G-4}.

{phang}
{bf:areastyle}.
{it:areastyle} determines whether an area is to be outlined and filled,
and, if so, in what color.  The area might be an entire region, bars, an area
under a curve, or other enclosed areas such as boxes in box plots.  See
{manhelpi areastyle G-4}.

{phang}
{bf:aspect ratio}.
The aspect ratio of an object is the ratio of its width to its height.  The
aspect ratio of an overall Stata graph, also known as the
{help g_glossary##avail_area:available area}, is
controlled by specifying options {opt ysize()} or {opt xsize()}; see
{manhelpi region_options G-3}.  {helpb graph describe} will show you the
{opt ysize()} and {opt xsize()} for a graph.  The aspect ratio of the
{help g_glossary##plot_region:plot region} is controlled by the
{opt aspect(#)} option; see {manhelpi aspect_option G-3}.

{marker avail_area}{...}
{phang}
{bf:available area}.
The available area is defined by the height and width of the overall graph
area, as determined by options {opt ysize(#)} and
{opt xsize(#)}.  See {manhelpi region_options G-3}.  Also see
{help g_glossary##graph_region:{it:graph region}} and
{help g_glossary##plot_region:{it:plot region}}.

{phang}
{bf:axisstyle}.
{it:axisstyle} is a composite style that holds and sets all attributes
of an axis, including whether there are ticks, gridlines, and axis lines.
Axis styles are used only in scheme files.  You would rarely want to change
axis styles.  See {manhelpi axisstyle G-4}.

{phang}
{bf:baseline of text}.
The baseline of text is the imaginary line on which text rests.
Letters with descenders, such as p and g, will have the descenders fall
beneath the baseline.  See {manhelpi alignmentstyle G-4}.

{phang}
{bf:bitmap image format}.
See {help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{phang}
{bf:by-graph}.
A by-graph is one graph that contains an array of separate graphs, each
of the same type and each reflecting a different subset of the data.
See {manhelpi bystyle G-4} and {manhelpi by_option G-3}.

{phang}
{bf:bystyle}.
{it:bystyle} specifies the overall look for by-graphs, including whether
individual graphs have their own axes and labels or whether they are shared;
whether the axis scales are different for each graph; and how close the graphs
are to each other.  See {manhelpi bystyle G-4}.

{marker clockposstyle}{...}
{phang}
{bf:clockposstyle}.
{it:clockposstyle}, an integer from 0 to 12, specifies a location around a
central point.  {it:clockposstyle} of 0 is always allowed and refers to the
center.  See {help g_glossary##compassdirstyle:{it:compassdirstyle}}
for another method for specifying directions.  See
{manhelpi clockposstyle G-4}.

{phang}
{bf:CMYK values}.
See {help g_glossary##CMYK:{it:cyan, magenta, yellow, and key or black (CMYK) values}}.

{phang}
{bf:color saturation}.
See {help g_glossary##intensity:{it:intensity}}.

{marker colorstyle}{...}
{phang}
{bf:colorstyle}.
{it:colorstyle} sets the color and opacity of graph components such as lines,
backgrounds, and bars.  See {manhelpi colorstyle G-4}.

{marker compassdirstyle}{...}
{phang}
{bf:compassdirstyle}.
{it:compassdirstyle} specifies a direction such as {opt north}, {opt neast},
or {opt east}.  See
{help g_glossary##clockposstyle:{it:clockposstyle}} 
for another method for specifying directions.  See
{manhelpi compassdirstyle G-4}.

{phang}
{bf:composite style}.
See
{help g_glossary##styles:{it:style, composite style, and detail style}}.

{phang}
{bf:connectstyle}.
{it:connectstyle} specifies if and how points in a scatterplot are to be
connected.  The most common choice is {cmd:connect(l)}, which means to connect
with straight lines.  See {manhelpi connectstyle G-4}.

{marker CMYK}{...}
{phang}
{bf:cyan, magenta, yellow, and key or black (CMYK) values}.
Cyan, magenta, yellow, and key or black (CMYK) values are used to
specify a color.  For example, values {cmd:0}, {cmd:0}, {cmd:255}, {cmd:0}
specify yellow.
Also see {help g_glossary##RGB:{it:red, green, and blue (RGB) values}} and
{help g_glossary##HSV:{it:hue, saturation, and value (HSV) values}}.

{phang}
{bf:detail style}.
See {help g_glossary##styles:{it:style, composite style, and detail style}}.

{phang}
{bf:EMF}.
See {help g_glossary##EMF:{it:Windows Enhanced Metafile}}.

{marker EPS}{...}
{phang}
{bf:Encapsulated PostScript (EPS)}.
Encapsulated PostScript (EPS) is a vector image format that is based on
{help g_glossary##PS:PostScript} with certain restrictions, created by Adobe.
The restrictions allow an EPS file to be included within other PostScript
documents.  A common use of EPS files is for them to contain a graph that can
then be inserted into another document such as a report.  An EPS file may
contain both graphics and text.  See {manhelpi eps_options G-3}.  Also see
{help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{phang}
{bf:EPS}.
See {help g_glossary##EPS:{it:Encapsulated PostScript (EPS)}}.

{marker family}{...}
{phang}
{bf:family and plottype}.
A family describes a group of related graphs.  Stata
graphs can be categorized into six different families:  bar, box, dot,
matrix, pie, and twoway.  Each family has different plottypes.  The twoway
family, for instance, has 42 different plottypes, including scatterplots,
lineplots, dropline plots, and range plots.

{phang}
{bf:GIF}.
See {help g_glossary##GIF:{it:Graphics Interchange Format (GIF)}}.

{phang}
{bf:.gph file}.
Stata stores graphs in {cmd:.gph} files, along with the original data
from which the graph was drawn.  These {cmd:.gph} files are binary files
written in a machine-and-operating-system independent format, which means that
{cmd:.gph} files may be read on a Mac, Windows, or Unix computer, regardless
of the type of computer on which it was originally created.  See
{helpb gph files:[G-4] Concept: gph files}.

{marker graph_region}{...}
{phang}
{bf:graph region}.
The graph region is typically larger than the plot region but
smaller than the available area.  The graph region includes the plot region
and the area where the titles and the axis labels occur.  See the 
{help region_options##regions_image:image of regions} in
{manhelpi region_options G-3}.  Also see 
{help g_glossary##avail_area:{it:available area}} and 
{help g_glossary##plot_region:{it:plot region}}.

{marker GIF}{...}
{phang}
{bf:Graphics Interchange Format (GIF)}.
Graphics Interchange Format (GIF) is a type of raster image format,
developed by CompuServe in 1987.  See {manhelpi gif_options G-3}.  Also see 
{help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{phang}
{bf:grids}.
Grids are lines that extend from an axis across the
{help g_glossary##plot_region:plot region}.

{marker gridstyle}{...}
{phang}
{bf:gridstyle}.
{it:gridstyle} specifies the overall look of grids, such as whether the grid
lines extend into the plot region's margin.  See {manhelpi gridstyle G-4}.

{phang}
{bf:HSV values}.
See {help g_glossary##HSV:{it:hue, saturation, and value (HSV) values}}.

{marker HSV}{...}
{phang}
{bf:hue, saturation, and value (HSV) values}.
Hue, saturation, and value (HSV) values are used to specify a color.
For example, values {cmd:0}, {cmd:0}, {cmd:1} specify white.
Also see 
{help g_glossary##CMYK:{it:cyan, magenta, yellow, and key or black (CMYK) values}}
and
{help g_glossary##RGB:{it:red, green, and blue (RGB) values}}.

{marker image_format}{...}
{phang}
{bf:image format, raster image format, and vector image format}.
An image format is a way of storing a digital image.  A raster image format,
also known as a bitmap image format, describes the image in terms of pixels.
A vector image format describes the image in terms of its individual
components such as lines, points, and text.  Examples of raster image formats
are
{help g_glossary##GIF:GIF},
{help g_glossary##JPEG:JPEG},
{help g_glossary##PNG:PNG}, and
{help g_glossary##TIFF:TIFF}.
Examples of vector image formats are 
{help g_glossary##EPS:EPS},
{help g_glossary##PDF:PDF},
{help g_glossary##PS:PS}, and
{help g_glossary##SVG:SVG}.

{marker intensity}{...}
{phang}
{bf:intensity}.
Color intensity is the brightness of a color.  As intensity decreases, the
color is paler.  Another term for intensity of color is color saturation.  See
{manhelpi colorstyle G-4} for how to adjust intensity.

{phang}
{bf:intensitystyle}.
{it:intensitystyle} specifies the intensity of colors as a percentage from
0 to 100.  For example, 0% means no color at all; 100% means full color.
{it:intensitystyle} is used primarily in scheme files.  See
{manhelpi intensitystyle G-4}.

{marker JPEG}{...}
{phang}
{bf:Joint Photographic Experts Group (JPEG)}.
Joint Photographic Experts Group (JPEG) is a type of raster image
format, created in 1992.  See {manhelpi jpg_options G-3}.  Also see
{help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{phang}
{bf:JPEG}.
See {help g_glossary##JPEG:{it:Joint Photographic Experts Group (JPEG)}}.

{marker justificationstyle}{...}
{phang}
{bf:justificationstyle}.
{it:justificationstyle} specifies how text is horizontally aligned in a
textbox.  Choices include left-justified, centered, or right-justified.  See
{manhelpi justificationstyle G-4}.

{phang}
{bf:legend and legend key}.
A legend is a table that shows the symbols used in a graph along with
the text describing their meaning.  A legend key is a symbol and the
descriptive text describing the symbol.  Stata has a standard legend, a
{opt contourline} plot legend, and a {opt contour} plot legend, controlled by
{opt legend()}, {opt plegend()}, and {opt clegend()}, respectively.  See
{manhelpi legend_options G-3} and {manhelpi clegend_option G-3}.

{phang}
{bf:legendstyle}.
{it:legendstyle} defines the look of a legend, which is defined by 14
attributes, including the number of columns or rows of the table, the gaps
between lines and columns, and the margin around the legend.  See
{manhelpi legendstyle G-4}.

{phang}
{bf:linealignmentstyle}.
{it:linealignmentstyle} specifies the alignment of a border or outline for
markers, fill areas, bars, and boxes.  The line can be placed inside the
outline, outside the outline, or centered on the outline.  See
{manhelpi linealignmentstyle G-4}.

{phang}
{bf:linepatternstyle}.
{it:linepatternstyle} specifies the pattern of a line, such as solid line,
dashed line, or dotted line.  See {manhelpi linepatternstyle G-4}.

{phang}
{bf:linestyle}.
sets the overall pattern, thickness, color and opacity, and alignment of a
line.  See {manhelpi linestyle G-4}.

{phang}
{bf:linewidthstyle}.
{it:linewidthstyle} specifies the thickness of lines, from so thin as to be 
invisible to very thick.  See {manhelpi linewidthstyle G-4}.

{phang}
{bf:marginstyle}.
{it:marginstyle} specifies where to include margins (bottom, top, left, right)
as well as their size (from no margin to very large).  See
{manhelpi marginstyle G-4}.

{marker marker}{...}
{phang}
{bf:marker}.
A marker is the ink used to mark where points are on a plot.
The overall look of a marker is determined by the 
{it:markerstyle}, which consists of the symbol used ({it:symbolstyle}),
the size of the marker ({it:markersizestyle}), and the color of the marker
({it:colorstyle}).  See {manhelpi markerstyle G-4},
{manhelpi symbolstyle G-4}, {manhelpi markersizestyle G-4}, and
{manhelpi colorstyle G-4}.
Also see
{help g_glossary##markerstyle:{it:markerstyle}},
{help g_glossary##symbolstyle:{it:symbolstyle}},
{help g_glossary##markersizestyle:{it:markersizestyle}}, and 
{help g_glossary##colorstyle:{it:colorstyle}}.

{phang}
{bf:markerlabelstyle}.
{it:markerlabelstyle} specifies the overall look of marker labels
by defining the position, gap, angle, size, and color of the marker label.
See {manhelpi markerlabelstyle G-4}.

{marker markersizestyle}{...}
{phang}
{bf:markersizestyle}.
{it:markersizestyle} determines the size of markers, which ranges from tiny to
huge.  You can make the marker any size that you want; see
{manhelpi size G-4}.  See {manhelpi markersizestyle G-4}.  Also see 
{help g_glossary##marker:{it:marker}} and
{help g_glossary##symbolstyle:{it:symbolstyle}}.

{marker markerstyle}{...}
{phang}
{bf:markerstyle}.
{it:markerstyle} defines the five attributes of a marker:
the shape of the marker; the size of the marker; the color and opacity of the
marker; the interior color and opacity of the marker; and the overall style,
thickness, color and opacity, and alignment of the marker's outline.  See
{manhelpi markerstyle G-4}.

{marker merged_exp}{...}
{phang}
{bf:merged-explicit option}.
An option allowed with a graph command is called merged-explicit if it is
treated as rightmost unless a suboption is specified.  The option
{opt title()} is a merged-explicit option.  If you do not specify any
suboptions within option {opt title()}, then the rightmost rule applies.  For
example, {it:graph_command} ... {cmd:, title(hello) title(goodbye)} will
result in the single title of "goodbye" on the graph.  If, however, you were to
specify {it:graph_command} ... {cmd:,  title(hello) title(goodbye, suffix)},
then the title of "hello goodbye" would appear on the graph.  Each
merged-explicit option will have documentation on what the merge options are
and how they work.
See {helpb repeated_options:[G-4] Concept: repeated options}.

{marker merged_imp}{...}
{phang}
{bf:merged-implicit option}.
An option allowed with a graph command is called merged-implicit if repeated 
instances of the same option within a graph command are merged.
Examples of merged-implicit options are {opt yline()} and {opt xline()} 
for adding horizontal and vertical lines, respectively, to a graph.
See {helpb repeated_options:[G-4] Concept: repeated options}.

{phang}
{bf:object}.
Graph objects are the building blocks of Stata graphs: plot regions,
axes, legends, notes, captions, titles, subtitles, and positional titles.
Objects may themselves contain other objects.  A plot region may contain
several different plots, each of which are objects.  A legend contains a key
region, which is itself an object.

{marker opacity_transparency}{...}
{phang}
{bf:opacity and transparency}.
Opacity is the percentage of a color that covers the background color.
Opacity varies between 0% (color has no coverage) to 100% (color fully hides
the background).  The inverse of opacity is transparency, so 0% opacity means
completely transparent and 100% opacity means not transparent.  See
{manhelpi colorstyle G-4} for information on how to adjust opacity.

{marker orientationstyle}{...}
{phang}
{bf:orientationstyle}.
{it:orientationstyle} specifies whether textboxes are horizontal or vertical.
See {manhelpi orientationstyle G-4}.

{phang}
{bf:PDF}.
See {help g_glossary##PDF:{it:Portable Document Format (PDF)}}.

{marker plot_region}{...}
{phang}
{bf:plot region}.
The plot region is the area enclosed by the axes.  It is where data 
are plotted.  This is not to be confused with the 
{help g_glossary##graph_region:graph region}, which encompasses the
plot region and the area with the titles and axes labels.  See the
{help region_options##regions_image:image of regions} in
{manhelpi region_options G-3}.
Also see {help g_glossary##avail_area:{it:available area}} and
{help g_glossary##graph_region:{it:graph region}}.

{phang}
{bf:plotregionstyle}.
{it:plotregionstyle} controls the overall look of a plot region and
is defined by four sets of attributes: marginstyle, overall areastyle,
internal areastyle, and horizontal and vertical positioning of the plot
region.  See {manhelpi plotregionstyle G-4}.

{phang}
{bf:plottype}.
See {help g_glossary##family:{it:family and plottype}}.

{phang}
{bf:PNG}.
See {help g_glossary##PNG:{it:Portable Network Graphics (PNG)}}.

{marker PDF}{...}
{phang}
{bf:Portable Document Format (PDF)}.
Portable Document Format (PDF) is a vector file format that can be 
used to represent graphics and documents independent of hardware, software, or
operating system.  It was developed by Adobe and initially released in 1993.
PDF was standardized (ISO) as an open format in 2008.  
Also see {help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{marker PNG}{...}
{phang}
{bf:Portable Network Graphics (PNG)}.
Portable Network Graphics (PNG) is a raster image format that is
nonpatented and was originally released in 1996.  See
{manhelpi png_options G-3}.
Also see {help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{marker PS}{...}
{phang}
{bf:PostScript (PS)}.
PostScript (PS) is a vector file format that is actually its own
language.  It was originally created by Adobe Systems in 1984 as a page
description language with hopes that it could be used by any printer.
Although not all printers support PostScript, it has become a widely used
format supported by many printers, screen rendering programs, and graphic
design programs.  See {manhelpi ps_options G-3}.  Also see
{help g_glossary##EPS:{it:Encapsulated PostScript (EPS)}} and
{help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{phang}
{bf:PS}.
See {help g_glossary##PS:{it:PostScript (PS)}}.

{phang}
{bf:pstyle}.
{it:pstyle} specifies the overall look of a plot, which is defined by the
look of markers, marker labels, and lines (markerstyle, markerlabelstyle,
linestyle); how points are connected by lines (connectstyle); whether missing
values cause lines to be broken when connected; the way areas are filled,
colored, shaded, and outlined (areastyle); the look of dots in dot plots; and
the look of arrowheads.  See {manhelpi pstyle G-4}.

{phang}
{bf:raster image format}.
See {help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{marker RGB}{...}
{phang}
{bf:red, green, and blue (RGB) values}.
Red, green, and blue (RGB) values are a triplet of numbers, each of
which specifies, on a scale of 0-255, the amount of red, green, and blue to
be mixed.  For example, to obtain the following colors, you would use these
values:

	{cmd:red}     =   {cmd:255    0    0}
	{cmd:green}   =   {cmd:  0  255    0}
	{cmd:blue}    =   {cmd:  0    0  255}
	{cmd:white}   =   {cmd:255  255  255}
	{cmd:black}   =   {cmd:  0    0    0}
	{cmd:gray}    =   {cmd:128  128  128}
	{cmd:navy}    =   {cmd: 26   71  111}

{pmore}
The overall scale of the triplet affects intensity, so changing 255 to 128
would keep the color the same but make it dimmer.  Also see 
{help g_glossary##CMYK:{it:cyan, magenta, yellow, and key or black (CMYK) values}}
and 
{help g_glossary##HSV:{it:hue, saturation, and value (HSV) values}}.

{phang}
{bf:repeated option}.
A repeated option is an option to a graph command that can be specified more
than once.  It is unusual for Stata to allow a repeated option for a command,
but graph commands are an exception because so many other commands are
implemented in terms of graph commands.  Repeated options are either
{it:rightmost} or {it:merged}.  {it:rightmost} instructs Stata to take the
rightmost occurrence; {it:merged} specifies to merge repeated instances
together.  See {helpb repeated_options:[G-4] Concept: repeated options}.

{phang}
{bf:RGB values}.
See {help g_glossary##RGB:{it:red, green, and blue (RGB) values}}.

{marker rightmost}{...}
{phang}
{bf:rightmost option}.
An option allowed with a graph command is called {it:rightmost} if an
option is repeated within the same graph command, and all but the rightmost
occurrence of the option are ignored.  {opt msymbol()} is an example of a
rightmost option.
See {helpb repeated_options:[G-4] Concept: repeated options}.
Also see {help g_glossary##unique_op:{it:unique option}}, 
{help g_glossary##merged_imp:{it:merged-implicit option}}, and
{help g_glossary##merged_exp:{it:merged-explicit option}}.

{phang}
{bf:ringposstyle}.
{it:ringposstyle}, a number from 0 to 100, specifies the distance
from the plot region for titles, subtitles, etc.  Positioning of titles is
controlled by options {opt position(clockposstyle})} and 
{opt ring(ringposstyle)}.  The option {opt position()} specifies 
a direction according to the hours of a clock, whereas the option {opt ring()} 
controls the distance of the title from the plot region.  If two titles were 
specified at the same {opt position()}, the title with the larger {opt ring()} 
would be the furthest from the plot region.  See {manhelpi ringposstyle G-4}.

{phang}
{bf:saturation}.
See {help g_glossary##intensity:{it:intensity}}.

{marker SVG}{...}
{phang}
{bf:Scalable Vector Graphics (SVG)}.
Scalable Vector Graphics (SVG) is a vector image format based on
XML.  SVG is an open standard developed by the World Wide Web
Consortium and initially released in 2001.  See {manhelpi svg_options G-3}.
Also see
{help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{phang}
{bf:scheme}.
A scheme specifies the overall look of a graph, which includes
everything from foreground color and background color to whether the y 
axis appears on the left or the right.  A scheme is a set of defaults.
Stata's default setting is scheme {opt s2color}.  Type
{cmd:graph query, schemes} to see the list of schemes installed on your
computer.  See {mansection G-4 SchemesintroRemarksandexamplesExamplesofschemes:{it:Examples of schemes}}
in {bf:[G-4] Schemes intro}.

{phang}
{bf:shadestyle}.
{it:shadestyle} sets the color ({manhelpi colorstyle G-4}) and
intensity ({manhelpi intensitystyle G-4}) of the color for a filled area.
See {manhelpi shadestyle G-4}.

{marker styles}{...}
{phang}
{bf:style, composite style, and detail style}.
{it:style} specifies a composite of related option settings that together
determine the overlook of the graph.  Styles come in two forms:  detail
styles and composite styles.  Detail styles specify precisely how an
attribute of something looks, and composite styles specify an overall look in
terms of detail-style values.

{pmore}
Examples of composite style options are {opt mstyle(symbolstyle)},
{opt mlabstyle(markerlabelstyle)}, and {opt lstyle(linestyle)}, 
which specify the overall look of symbols, marker labels, and lines,
respectively.  Note that composite style options all end in "style":
{opt mstyle()}, {opt mlabstyle()}, and {opt lstyle()}.

{pmore}
Examples of detail styles are {opt mcolor(colorstyle)}, 
{opt mlwidth(linewidthstyle)}, and {opt mlabsize(textsizestyle)},
which specify the color of an object, the outline thickness, and the size of
the label, respectively.  Note that the option names do not end in the word
style: {opt mcolor()}, {opt mlwidth()}, and {opt mlabsize()}.

{phang}
{bf:SVG}.
See {help g_glossary##SVG:{it:Scalable Vector Graphics (SVG)}}.

{marker symbolstyle}{...}
{phang}
{bf:symbolstyle}.
The {it:symbolstyle} determines the shape of markers.  Choices
include circles, diamonds, triangles, squares (these four can be different
sizes and hollow or not), plus signs, X's (these two can be only different
sizes), dots and even an invisible symbol.  See {manhelpi symbolstyle G-4}.
Also see {help g_glossary##marker:{it:marker}} and 
{help g_glossary##markersizestyle:{it:markersizestyle}}.

{marker TIFF}{...}
{phang}
{bf:Tagged Image File Format (TIFF)}.
Tagged Image File Format (TIFF) is a raster graphics image format
created by Aldus Corporation in 1986 and subsequently updated by Adobe Systems
after Adobe acquired Aldus.  See {manhelpi tif_options G-3}.  Also see
{help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{phang}
{bf:textbox}.
A textbox is one or more lines of text with an optional border around it.
Also see {help g_glossary##textboxstyle:{it:textboxstyle}}.

{marker textboxstyle}{...}
{phang}
{bf:textboxstyle}.
Textboxes are defined by 11 attributes such as whether the textbox is
vertical or horizontal ({it:orientationstyle}); the size of the text
({it:textsizestyle}), the color of the text ({it:colorstyle}), and whether the
text is left-justified, centered, or right-justified
({it:justificationstyle}).  See {manhelpi textboxstyle G-4}.
Also see
{help g_glossary##orientationstyle:{it:orientationstyle}},
{help g_glossary##colorstyle:{it:colorstyle}}, and
{help g_glossary##justificationstyle:{it:justificationstyle}}.

{marker textsizestyle}{...}
{phang}
{bf:textsizestyle}.
{it:textsizestyle} specifies the size of text.  See
{manhelpi textsizestyle G-4} for choices for the size of text.

{phang}
{bf:textstyle}.
{it:textstyle} specifies the overall look of text, which is defined by five
attributes: whether the text is vertical or horizontal
({it:orientationstyle}); the size of the text ({it:textsizestyle}); the color
of the text ({it:colorstyle}); whether the text is left-justified, centered, or
right-justified ({it:justificationstyle}); and how the text aligns with the
baseline ({it:alignmentstyle}).  See {manhelpi textstyle G-4}.
Also see
{help g_glossary##orientationstyle:{it:orientationstyle}},
{help g_glossary##textsizestyle:{it:textsizestyle}},
{help g_glossary##colorstyle:{it:colorstyle}},
{help g_glossary##symbolstyle:{it:symbolstyle}},
{help g_glossary##justificationstyle:{it:justificationstyle}}, and
{help g_glossary##alignmentstyle:{it:alignmentstyle}}.

{phang}
{bf:ticks}.
Ticks are the marks that appear on axes.  See {manhelpi tickstyle G-4}.

{phang}
{bf:ticksetstyle}.
{it:ticksetstyle} specifies the overall look of axis ticks, which is
determined by the {it:tickstyle}, the {it:gridstyle} (if a grid is
associated with the tickset), and other tick details.  See
{manhelpi ticksetstyle G-4}.  Also see 
{help g_glossary##tickstyle:{it:tickstyle}} and
{help g_glossary##gridstyle:{it:gridstyle}}.

{marker tickstyle}{...}
{phang}
{bf:tickstyle}.
{it:tickstyle} specifies the overall look of axis ticks and their labels.
Ticks are defined by three attributes: the length of the tick; the line style
of the tick; and whether the tick extends out, extends in, or crosses the
axis.  Tick labels are defined by two attributes: their size and color.
{it:tickstyle} also determines the gap between the tick and the tick label.
See {manhelpi tickstyle G-4}.

{phang}
{bf:TIFF}.
See {help g_glossary##TIFF:{it:Tagged Image File Format (TIFF)}}.

{phang}
{bf:transparency}.
See {help g_glossary##opacity_transparency:{it:opacity and transparency}}.

{phang}
{bf:twoway graph}.
Twoway graphs are graphs with two dimensions; they display the relationship
between the variables in the numeric y and x axes.  See
{helpb graph_twoway:[G-2] graph twoway}.

{marker unique_op}{...}
{phang}
{bf:unique option}.
An option allowed with a graph command is called unique if the option may be
specified only once.  {opt saving()} is an example of a unique option.  Also
see {help g_glossary##rightmost:{it:rightmost option}},
{help g_glossary##merged_imp:{it:merged-implicit option}}, and
{help g_glossary##merged_exp:{it:merged-explicit option}}.

{phang}
{bf:vector image format}.
See {help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{marker EMF}{...}
{phang}
{bf:Windows Enhanced Metafile (EMF)}.
Windows Enhanced Metafile (EMF) is a newer version of 
{help g_glossary##WMF:Windows Metafile (WMF)} that was 
initially released in 1993 by Microsoft Corporation.  Like WMF, 
EMF is primarily a vector format, although it can contain raster
formats.  EMF is also used as a graphics language for printer drivers 
and as a clipboard image format.  
Also see {help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{marker WMF}{...}
{phang}
{bf:Windows Metafile (WMF)}.
Windows Metafile (WMF). Windows Metafile (WMF) is an image
format that is primarily vector but may also contain raster components.  It
was developed by Microsoft Corporation and initially released in 1990.  
WMF is also used as a clipboard image format.  
Also see {help g_glossary##EMF:{it:Windows Enhanced Metafile (EMF)}} and
{help g_glossary##image_format:{it:image format, raster image format, and vector image format}}.

{phang}
{bf:WMF}.
See {help g_glossary##WMF:{it:Windows Enhanced Metafile}}.
{p_end}
