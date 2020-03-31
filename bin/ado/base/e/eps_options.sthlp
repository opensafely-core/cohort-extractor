{smcl}
{* *! version 1.2.10  15oct2018}{...}
{vieweralsosee "[G-3] eps_options" "mansection G-3 eps_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph export" "help graph_export"}{...}
{vieweralsosee "[G-2] graph set" "help graph_set"}{...}
{vieweralsosee "[G-3] ps_options" "help ps_options"}{...}
{viewerjumpto "Syntax" "eps_options##syntax"}{...}
{viewerjumpto "Description" "eps_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "eps_options##linkspdf"}{...}
{viewerjumpto "Options" "eps_options##options"}{...}
{viewerjumpto "Remarks" "eps_options##remarks"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[G-3]} {it:eps_options} {hline 2}}Options for exporting to Encapsulated PostScript{p_end}
{p2col:}({mansection G-3 eps_options:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 30}{...}
{p2col:{it:eps_options}}Description{p_end}
{p2line}
{p2col:{cmd:logo(on}|{cmd:off)}}whether to include Stata logo{p_end}
{p2col:{cmd:cmyk(on}|{cmd:off)}}whether to use CMYK rather than RGB colors
      {p_end}
{p2col:{cmdab:pre:view:(on}|{cmd:off)}}whether to include TIFF preview{p_end}
{p2col:{cmd:mag(}{it:#}{cmd:)}}magnification/shrinkage factor; default is 100
      {p_end}
{p2col:{cmdab:font:face:(}{it:fontname}{cmd:)}}default font to use{p_end}
{p2col:{cmd:fontfacesans(}{it:fontname}{cmd:)}}font to use for text in
      {cmd:{c -(}stSans{c )-}} "font"{p_end}
{p2col:{cmd:fontfaceserif(}{it:fontname}{cmd:)}}font to use for text in
      {cmd:{c -(}stSerif{c )-}} "font"{p_end}
{p2col:{cmd:fontfacemono(}{it:fontname}{cmd:)}}font to use for text in
      {cmd:{c -(}stMono{c )-}} "font"{p_end}
{p2col:{cmd:fontfacesymbol(}{it:fontname}{cmd:)}}font to use for text in
      {cmd:{c -(}stSymbol{c )-}} "font"{p_end}
{p2col:{cmd:fontdir(}{it:directory}{cmd:)}}(Unix only) directory in which
      TrueType fonts are stored{p_end}
{p2col:{cmdab:or:ientation:(portrait}|}{p_end}
{p2col 21 37 37 2:{cmd:landscape)}}whether vertical or horizontal{p_end}
{p2line}
{p2colreset}{...}

{p 4 6 2}
where {it:fontname} may be a valid font name or {cmd:default} to restore
the default setting and {it:directory} may be a valid directory or
{cmd:default} to restore the default setting.

{pstd}
Current default values may be listed by typing

	{cmd:. graph set eps}

{pstd}
and default values may be set by typing

{p 8 16 2}
{cmd:. graph set}
{cmd:eps}
{it:name}
{it:value}

{pstd}
where {it:name} is the name of an {it:eps_option}, omitting the
parentheses.


{marker description}{...}
{title:Description}

{pstd}
These {it:eps_options} are used with {cmd:graph} {cmd:export}
when creating an Encapsulated PostScript file; see
{manhelp graph_export G-2:graph export}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection G-3 eps_optionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:logo(on)} and {cmd:logo(off)}
    specify whether the Stata logo should be included at the bottom of the
    graph.

{phang}
{cmd:cmyk(on)} and {cmd:cmyk(off)}
    specify whether colors in the output file should be specified as CMYK
    values rather than RGB values.

{phang}
{cmd:preview(on)} and {cmd:preview(off)}
    specify whether a TIFF preview of the graph should be included in the 
    Encapsulated PostScript file.  This option allows word processors that
    cannot interpret PostScript to display a preview of the file.  The preview
    is often substituted for the Encapsulated PostScript file when printing
    to a non-PostScript printer.  This option is not available in Stata 
    console and requires the Graph window to be visible.

{phang}
{cmd:mag(}{it:#}{cmd:)}
    specifies that the graph be drawn smaller or larger than the default.
    {cmd:mag(100)} is the default, meaning ordinary size.
    {cmd:mag(110)} would make the graph 10% larger than usual, and
    {cmd:mag(90)} would make the graph 10% smaller than usual.
    {it:#} must be an integer.

{phang}
{cmd:fontface(}{it:fontname}{cmd:)}
    specifies the name of the PostScript font to be used to render text for
    which no other font has been specified.  The default is {cmd:Helvetica},
    which may be restored by specifying {it:fontname} as {cmd:default}.
    If {it:fontname} contains spaces, it must be enclosed in double quotes.

{phang}
{cmd:fontfacesans(}{it:fontname}{cmd:)}
    specifies the name of the PostScript font to be used to render text for
    which the {cmd:{c -(}stSans{c )-}} "font" has been specified.  The
    default is {cmd:Helvetica}, which may be restored by specifying
    {it:fontname} as {cmd:default}.  If {it:fontname} contains
    spaces, it must be enclosed in double quotes.

{phang}
{cmd:fontfaceserif(}{it:fontname}{cmd:)}
    specifies the name of the PostScript font to be used to render text for
    which the {cmd:{c -(}stSerif{c )-}} "font" has been specified.  The
    default is {cmd:Times}, which may be restored by specifying
    {it:fontname} as {cmd:default}.  If {it:fontname} contains
    spaces, it must be enclosed in double quotes.

{phang}
{cmd:fontfacemono(}{it:fontname}{cmd:)}
    specifies the name of the PostScript font to be used to render text for
    which the {cmd:{c -(}stMono{c )-}} "font" has been specified.  The
    default is {cmd:Courier}, which may be restored by specifying
    {it:fontname} as {cmd:default}.  If {it:fontname} contains
    spaces, it must be enclosed in double quotes.

{phang}
{cmd:fontfacesymbol(}{it:fontname}{cmd:)}
    specifies the name of the PostScript font to be used to render text for
    which the {cmd:{c -(}stSymbol{c )-}} "font" has been specified.  The
    default is {cmd:Symbol}, which may be restored by specifying
    {it:fontname} as {cmd:default}.  If {it:fontname} contains
    spaces, it must be enclosed in double quotes.

{phang}
{cmd:fontdir(}{it:directory}{cmd:)}
    specifies the directory that Stata for Unix uses to find TrueType fonts (if
    you specified any) for conversion to PostScript fonts when you export
    a graph to Encapsulated PostScript.  You may specify {it:directory}
    as {cmd:default} to restore the default setting.  If
    {it:directory} contains spaces, it must be enclosed in double
    quotes.

{phang}
{cmd:orientation(portrait)}
and
{cmd:orientation(landscape)}
    specify whether the graph is to be presented vertically or horizontally.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help eps_options##remarks1:Using the eps_options}
	{help eps_options##remarks2:Setting defaults}
	{help eps_options##remarks3:Note about PostScript fonts}


{marker remarks1}{...}
{title:Using the eps_options}

{pstd}
You have drawn a graph and wish to create an Encapsulated PostScript file
for including the file in a document.  You wish, however, to
change text for which no other font has been specified from the
default of Helvetica to Roman, which is "Times" in PostScript
jargon:

	{cmd:. graph} ...{col 50}(draw a graph)

	{cmd:. graph export myfile.eps, fontface(Times)}


{marker remarks2}{...}
{title:Setting defaults}

{pstd}
If you always wanted {helpb graph export} to use Times
when exporting to Encapsulated PostScript files, you could type

	{cmd:. graph set eps fontface Times}

{pstd}
Later, you could type

	{cmd:. graph set eps fontface Helvetica}

{pstd}
to change it back.  You can list the current {it:eps_option} settings
for Encapsulated PostScript by typing

	{cmd:. graph set eps}


{marker remarks3}{...}
{title:Note about PostScript fonts}

{pstd}
Graphs exported to Encapsulated PostScript format by Stata conform to what is
known as PostScript Level 2.  There are 10 built-in font faces, known as
the Core Font Set, some of which are available in modified forms,
for example, bold or italic (a listing of the original 10 font faces in the
Core Font Set is shown at  
{browse "https://en.wikipedia.org/wiki/Type_1_and_Type_3_fonts#Core_Font_Set"}).
If you change any of the {cmd:fontface}{it:*}{cmd:()} settings, we recommend
that you use one of those 10 font faces.  We do not recommend changing
{cmd:fontfacesymbol()}, because doing so can lead to incorrect characters being
printed.

{pstd}
If you specify a font face other than one that is part of the Core Font
Set, Stata will first attempt to map it to the closest matching font
in the Core Font Set.  For example, if you specify
{cmd:fontfaceserif("Times New Roman")}, Stata will map it to
{cmd:fontfaceserif("Times")}.

{pstd}
If Stata is unable to map the font face to the Core Font Set, Stata
will look in the {cmd:fontdir()} directory for a TrueType font on
your system matching the font you specified.  If it finds one, it
will attempt to convert it to a PostScript font and, if
successful, will embed the converted font in the exported
Encapsulated PostScript graph.  Because of the wide variety of TrueType fonts
available on different systems, this conversion can be problematic,
which is why we recommend that you use fonts found in the Core Font Set.
{p_end}
