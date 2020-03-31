{smcl}
{* *! version 1.0.9  05dec2018}{...}
{vieweralsosee "[G-3] svg_options" "mansection G-3 svg_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph set" "help graph_set"}{...}
{viewerjumpto "Syntax" "svg_options##syntax"}{...}
{viewerjumpto "Description" "svg_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "svg_options##linkspdf"}{...}
{viewerjumpto "Options" "svg_options##options"}{...}
{viewerjumpto "Remarks" "svg_options##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-3]} {it:svg_options} {hline 2}}Options for exporting to Scalable Vector Graphics{p_end}
{p2col:}({mansection G-3 svg_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:svg_options}}Description{p_end}
{p2line}
{p2col:{cmdab:base:lineshift:(on}|{cmd:off)}}whether to use SVG {cmd:baseline-shift} attribute for subscript or superscript; default is {cmd:off}{p_end}
{p2col:{cmdab:ignoref:ont(on}|{cmd:off)}}whether to ignore graph fonts used for text; default is {cmd:off}{p_end}
{p2col:{cmdab:bgf:ill(on}|{cmd:off)}}whether to ignore background fill; default is {cmd:on}{p_end}
{p2col:{cmd:nbsp(on}|{cmd:off)}}whether to use Unicode character for no-break space instead of spaces in some strings; default is {cmd:on}{p_end}
{p2col:{cmdab:clipstr:oke(on}|{cmd:off)}}whether to use clipping paths to simulate stroke alignment; default is {cmd:on}{p_end}
{p2col:{cmdab:scalestr:okewidth(on}|{cmd:off)}}whether to manually scale stroke widths; default is {cmd:off}{p_end}
{p2col:{cmdab:verb:ose}}whether to output all default attributes and classes{p_end}
{p2col:{opt pathp:refix(prefix)}}prefix to use when naming SVG paths{p_end}
{p2col:{cmdab:wid:th:(}{it:#}{cmd:px}|{it:#}{cmd:in}{cmd:)}}width of graph in pixels or inches{p_end}
{p2col:{cmdab:hei:ght:(}{it:#}{cmd:px}|{it:#}{cmd:in}{cmd:)}}height of graph in pixels or inches{p_end}
{p2col:{cmdab:font:face:(}{it:fontname}{cmd:)}}default font to use{p_end}
{p2col:{cmd:fontfacesans(}{it:fontname}{cmd:)}}font to use for text in
      {cmd:{c -(}stSans{c )-}} "font"{p_end}
{p2col:{cmd:fontfaceserif(}{it:fontname}{cmd:)}}font to use for text in
      {cmd:{c -(}stSerif{c )-}} "font"{p_end}
{p2col:{cmd:fontfacemono(}{it:fontname}{cmd:)}}font to use for text in
      {cmd:{c -(}stMono{c )-}} "font"{p_end}
{p2col:{cmd:fontfacesymbol(}{it:fontname}{cmd:)}}font to use for text in
      {cmd:{c -(}stSymbol{c )-}} "font"{p_end}
{p2line}
{p2colreset}{...}

{p 4 6 2}
where {it:fontname} may be a valid font name or {cmd:default} to restore
the default setting.

{pstd}
Current default values may be listed by typing

	{cmd:. graph set svg}

{pstd}
and default values may be set by typing

{p 8 16 2}
{cmd:. graph set}
{cmd:svg}
{it:name}
{it:value}

{pstd}
where {it:name} is the name of an {it:svg_option}, omitting the
parentheses.


{marker description}{...}
{title:Description}

{pstd}
These {it:svg_options} are used with {cmd:graph} {cmd:export}
when creating a Scalable Vector Graphics file; see
{manhelp graph_export G-2:graph export}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 svg_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:baselineshift(on)} and {cmd:baselineshift(off)}
    specify whether to use the SVG attribute {cmd:baseline-shift} for
    displaying subscripts and superscripts.  As of February 4, 2016, IE,
    Microsoft Edge, and Firefox do not support this attribute, but Chrome and
    Safari do.  When {cmd:baselineshift(off)} is specified, Stata instead uses
    the SVG {cmd:dy} attribute to display subscripts and superscripts.
    However, Chrome and Safari may not properly render subscripts and
    superscripts when using the {cmd:dy} attribute if there are leading or
    trailing spaces in the string and the {cmd:nbsp(off)} option is specified.
    The default is {cmd:baselineshift(off)}.

{phang}
{cmd:ignorefont(on)} and {cmd:ignorefont(off)}
    specify whether to output the SVG {cmd:font-family} attribute.  When
    {cmd:ignorefont(on)} is specified, no font information is written to the
    SVG file, so the SVG renderer must determine which font to use when
    displaying text.  The default is {cmd:ignorefont(off)}.

{phang}
{cmd:bgfill(on)} and {cmd:bgfill(off)}
    specify whether to use the background fill. When {cmd:bgfill(off)} is
    specified, no background fill is written to the SVG file, so the SVG
    background is transparent. The default is {cmd:bgfill(on)}.

{phang}
{cmd:nbsp(on)} and {cmd:nbsp(off)}
    specify whether to use the Unicode character for no-break space (U+00A0)
    in place of spaces in a string.  By default, SVG renderers ignore leading
    and trailing spaces in strings.  The SVG {cmd:xml:space} attribute can be
    used to preserve leading and trailing spaces in strings, but both IE and
    Microsoft Edge ignore that attribute.  When {cmd:nbsp(on)} is specified,
    Stata first looks at a string to see whether it has any leading or
    trailing spaces.  If so, it replaces all the spaces in the string with the
    Unicode no-break space character.  When {cmd:nbsp(off)} is specified,
    Stata uses the {cmd:xml:space} attribute when a string contains leading or
    trailing spaces.  {cmd:nbsp()} is a tradeoff between making the XML data
    within the SVG file more readable and the SVG file itself more compact
    ({cmd:off}) versus greater compatibility among web browsers ({cmd:on}).
    The default is {cmd:nbsp(on)}.

{phang}
{cmd:clipstroke(on)} and {cmd:clipstroke(off)}
    specify whether to use clipping paths to simulate stroke alignment for
    polygons.  Stata allows a closed object such as an ellipse, a rectangle,
    or a polygon to be stroked on the inside, center, or outside of the
    object's outline.  Stata uses the SVG {cmd:stroke-alignment} property to
    support stroke alignment for polygons.  But popular web browsers such as
    Internet Explorer, Apple Safari, and Google Chrome do not support the
    {cmd:stroke-alignment} property (as of March 15, 2016).  When
    {cmd:clipstroke(on)} is specified, Stata simulates an inside or outside
    stroke alignment for polygons by first defining the polygon as its own
    clipping path, then stroking the center of the polygon's outline with
    twice the stroke width.  The half of the doubled stroke that is not
    contained within the clipping path will not be visible.  The default is
    {cmd:clipstroke(on)}.

{phang}
{cmd:scalestrokewidth(on)} and {cmd:scalestrokewidth(off)}
    specify whether to manually scale the stroke widths in an SVG file.  Most
    SVG renderers use the SVG file's viewbox to scale shapes and stroke
    widths.  While Adobe Illustrator does scale shapes according to an SVG
    file's viewbox, it fails to do so for the stroke widths, which causes the
    strokes to appear extremely thick.  When {cmd:scalestrokewidth(on)} is
    specified, Stata manually scales every stroke width so that SVG files
    appear correctly in Adobe Illustrator but incorrectly in every other known
    SVG renderer.  The default is {cmd:scalestrokewidth(off)}.

{phang}
{cmd:verbose}
    specifies whether to output all default attributes and classes.  For
    example, the default text alignment value for the SVG attribute
    {cmd:text-anchor} is {cmd:start}.  Stata only outputs the
    {cmd:text-anchor} attribute if the text alignment is centered or end
    aligned.  When {cmd:verbose} is specified, Stata will always output the
    {cmd:text-anchor} attribute even if the text uses the default start text
    alignment.  Stata will also output attributes such as the writing
    direction, the type of point cloud if applicable, and the type of marker
    symbol being displayed.

{phang}
{opt pathprefix(prefix)}
    specifies the prefix to use when naming SVG paths.  A path is a collection
    of lines and curves that define a shape. A path in an SVG image can be
    named so that it can be used multiple times in the image.  However, if
    multiple SVG images are included in an HTML document and they share common
    path names, the browser can become confused about which path to use.  To
    prevent this path name collision, Stata uses random strings to create
    unique path names.  If you would prefer to create stable path names,
    specify {cmd:pathprefix()}. Stata will use your path prefix and an index
    that is incremented for each path to create stable path names.  Use the
    same guidelines as naming variables when specifying a path prefix.

{phang}
{cmd:width(}{it:#}{cmd:px}|{it:#}{cmd:in}{cmd:)}
    specifies the width of the graph in pixels or inches.  The default units
    are pixels if no units are specified.  If the width is specified but not
    the height, Stata determines the appropriate height from the graph's
    aspect ratio.

{phang}
{cmd:height(}{it:#}{cmd:px}|{it:#}{cmd:in}{cmd:)}
    specifies the height of the graph in pixels or inches.  The default units
    are pixels if no units are specified.  If the height is specified but not
    the width, Stata determines the appropriate width from the graph's aspect
    ratio.

{phang}
{cmd:fontface(}{it:fontname}{cmd:)}
    specifies the name of the font to be used to render text for which no
    other font has been specified.  The default is {cmd:Helvetica}, which may
    be restored by specifying {it:fontname} as {cmd:default}.  If
    {it:fontname} contains spaces, it must be enclosed in double quotes.

{phang}
{cmd:fontfacesans(}{it:fontname}{cmd:)}
    specifies the name of the font to be used to render text for which the
    {cmd:{c -(}stSans{c )-}} "font" has been specified.  The default is
    {cmd:Helvetica}, which may be restored by specifying {it:fontname} as
    {cmd:default}.  If {it:fontname} contains spaces, it must be enclosed in
    double quotes.

{phang}
{cmd:fontfaceserif(}{it:fontname}{cmd:)}
    specifies the name of the font to be used to render text for which the
    {cmd:{c -(}stSerif{c )-}} "font" has been specified.  The default is
    {cmd:Times}, which may be restored by specifying {it:fontname} as
    {cmd:default}.  If {it:fontname} contains spaces, it must be enclosed in
    double quotes.

{phang}
{cmd:fontfacemono(}{it:fontname}{cmd:)}
    specifies the name of the font to be used to render text for which the
    {cmd:{c -(}stMono{c )-}} "font" has been specified.  The default is
    {cmd:Courier}, which may be restored by specifying {it:fontname} as
    {cmd:default}.  If {it:fontname} contains spaces, it must be enclosed in
    double quotes.

{phang}
{cmd:fontfacesymbol(}{it:fontname}{cmd:)}
    specifies the name of the font to be used to render text for which the
    {cmd:{c -(}stSymbol{c )-}} "font" has been specified.  The default is
    {cmd:Symbol}, which may be restored by specifying {it:fontname} as
    {cmd:default}.  If {it:fontname} contains spaces, it must be enclosed in
    double quotes.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help svg_options##remarks1:Using the svg_options}
	{help svg_options##remarks2:Setting defaults}


{marker remarks1}{...}
{title:Using the svg_options}

{pstd}
You have drawn a graph and wish to create a Scalable Vector Graphics file
for including the file in an HTML document.  You wish, however, to
change text for which no other font has been specified from the
default of Helvetica to Arial:

	{cmd:. graph} ...{col 50}(draw a graph)

	{cmd:. graph export myfile.svg, fontface(Arial)}


{marker remarks2}{...}
{title:Setting defaults}

{pstd}
If you always wanted {helpb graph export} to use Arial
when exporting to Scalable Vector Graphics files, you could type

	{cmd:. graph set svg fontface Arial}

{pstd}
Later, you could type

	{cmd:. graph set svg fontface Helvetica}

{pstd}
to change it back.  You can list the current {it:svg_option} settings
for Scalable Vector Graphics files by typing

	{cmd:. graph set svg}
