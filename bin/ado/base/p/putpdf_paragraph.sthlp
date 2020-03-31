{smcl}
{* *! version 1.0.0  08may2019}{...}
{vieweralsosee "[RPT] putpdf paragraph" "mansection RPT putpdfparagraph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{vieweralsosee "[RPT] putpdf begin" "help putpdf begin"}{...}
{vieweralsosee "[RPT] putpdf pagebreak" "help putpdf pagebreak"}{...}
{vieweralsosee "[RPT] putpdf table" "help putpdf table"}{...}
{vieweralsosee "[RPT] Appendix for putpdf" "help putpdf appendix"}{...}
{viewerjumpto "Syntax" "putpdf paragraph##syntax"}{...}
{viewerjumpto "Description" "putpdf paragraph##description"}{...}
{viewerjumpto "Links to PDF documentation" "putpdf paragraph##linkspdf"}{...}
{viewerjumpto "Options" "putpdf paragraph##options"}{...}
{viewerjumpto "Examples" "putpdf paragraph##examples"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[RPT] putpdf paragraph} {hline 2}}Add text or images to a PDF file{p_end}
{p2col:}({mansection RPT putpdfparagraph:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Add paragraph to document

{p 8 22 2}
{cmd:putpdf paragraph}
[{cmd:,} {help putpdf_paragraph##paraopts:{it:paragraph_options}}]


{phang}
Add text to paragraph

{p 8 22 2}
{cmd:putpdf text} {cmd:(}{help exp:{it:exp}}{cmd:)}
[{cmd:,} {help putpdf_paragraph##textopts:{it:text_options}}]


{phang}
Add image to paragraph

{p 8 22 2}
{cmd:putpdf image} {help filename:{it:filename}}
[{cmd:,} {help putpdf_paragraph##imageopts:{it:image_options}}]

{phang}
{it:filename} is the full path to the image file or the relative path from the
current working directory.


{marker paraopts}{...}
{synoptset 28}{...}
{synopthdr:paragraph_options}
{synoptline}
{synopt :{opth font:(putpdf_paragraph##fspec:fspec)}}set font, font size, and font color{p_end}
{synopt :{opth halign:(putpdf_paragraph##para_hvalue:hvalue)}}set paragraph alignment{p_end}
{synopt :{opth valign:(putpdf_paragraph##para_vvalue:vvalue)}}set vertical alignment of characters on each line{p_end}
{synopt :{cmd:indent(}{help putpdf_paragraph##indenttype:{it:indenttype}}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set paragraph indentation{p_end}
{synopt :{cmd:spacing(}{help putpdf_paragraph##para_position:{it:position}}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set spacing between lines of text{p_end}
{synopt :{opth bgcolor:(putpdf_paragraph##color:color)}}set background color{p_end}
{synoptline}

{marker textopts}{...}
{synoptset 28}{...}
{synopthdr:text_options}
{synoptline}
{synopt :{opth nfor:mat(%fmt)}}specify numeric format for text{p_end}
{synopt :{opth font:(putpdf_paragraph##fspec:fspec)}}set font, font size, and font color{p_end}
{synopt :{opt bold}}format text as bold{p_end}
{synopt :{opt italic}}format text as italic{p_end}
{synopt :{cmd:script(sub{c |}super)}}set subscript or superscript formatting of text{p_end}
{synopt :{opt strike:out}}strike out text{p_end}
{synopt :{opt underl:ine}}underline text{p_end}
{synopt :{opth bgcolor:(putpdf_paragraph##color:color)}}set background color{p_end}
{synopt :{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}]}add line breaks after text{p_end}
{synopt :{opt allc:aps}}format text as all caps{p_end}
{synoptline}

{marker imageopts}{...}
{synoptset 28}{...}
{synopthdr:image_options}
{synoptline}
{synopt :{cmdab:w:idth(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set image width{p_end}
{synopt :{cmdab:h:eight(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set image height{p_end}
{synopt :{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}]}add line breaks after image{p_end}
{synoptline}

{marker fspec}
{phang}
{it:fspec} is

{pmore}
{it:fontname} [{cmd:,} {it:size} [{cmd:,} {it:color}]]

{marker font}{...}
{pmore2}
{it:fontname} may be any supported font installed on the user's computer.
Base 14 fonts, Type 1 fonts, and TrueType fonts with an extension of
{cmd:.ttf} and {cmd:.ttc} are supported. TrueType fonts that cannot be
embedded may not used.  If {it:fontname} includes spaces, then it must be
enclosed in double quotes.  The default font is {cmd:Helvetica}.

{marker size}{...}
{pmore2}
{it:size} is a numeric value that represents font size measured in points.
The default is {cmd:11}.

{pmore2}
{it:color} sets the text color.

{marker unit}{...}
{phang}
INCLUDE help put_units

{marker color}{...}
{phang}
{it:color} may be one of the
colors listed in 
{help putpdf_appendix##Colors:{it:Colors}} of
{helpb putpdf appendix:[RPT] Appendix of putpdf};
a valid RGB value in the form {it:### ### ###}, for example,
{cmd:171 248 103}; or a valid RRGGBB hex value in the form {it:######}, for
example, {cmd:ABF867}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:putpdf} {cmd:paragraph} adds a new paragraph to the active document. The
newly created paragraph becomes the active paragraph. All subsequent text or
images will be appended to the active paragraph.

{pstd}
{cmd:putpdf} {cmd:text}  adds content to the paragraph
created by {cmd:putpdf} {cmd:paragraph}.  The text may be a plain text
string or any valid Stata expression (see {findalias frexp}).

{pstd}
{cmd:putpdf} {cmd:image} embeds a portable network graphics ({cmd:.png}) or
JPEG ({cmd:.jpg}) file in the paragraph. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putpdfparagraphQuickstart:Quick start}

        {mansection RPT putpdfparagraphRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Options are presented under the following headings:

        {help putpdf_paragraph##opts_putpdf_paragraph:Options for putpdf paragraph}
        {help putpdf_paragraph##opts_putpdf_text:Options for putpdf text}
        {help putpdf_paragraph##opts_putpdf_image:Options for putpdf image}


{marker opts_putpdf_paragraph}{...}
{title:Options for putpdf paragraph}

{phang}
{cmd:font(}{help putpdf_paragraph##font:{it:fontname}}
[{cmd:,} {help putpdf_paragraph##size:{it:size}}
[{cmd:,} {help putpdf_paragraph##color:{it:color}}]]{cmd:)}
sets the font, font size, and font color for the text within the paragraph.
The font size and font color may be specified individually without specifying
{it:fontname}. Use {cmd:font("",} {it:size}{cmd:)} to specify font size only.
Use {cmd:font("", "",} {it:color}{cmd:)} to specify font color only. For both
cases, the default font will be used.

{pmore}
Specifying {cmd:font()} with {cmd:putpdf paragraph} overrides font settings
specified with {cmd:putpdf begin}.

{marker para_hvalue}{...}
{phang}
{opt halign(hvalue)} sets the horizontal alignment of the text within
the paragraph. {it:hvalue} may be {cmd:left}, {cmd:right}, {cmd:center},
{cmd:justified}, or {cmd:distribute}. {cmd:distribute} and {cmd:justified}
justify text between the left and right margins equally, but {cmd:distribute}
also changes the spacing between words and characters.  The default is
{cmd:halign(left)}.

{marker para_vvalue}{...}
{phang}
{opt valign(vvalue)} sets the vertical alignment of the characters on
each line when the paragraph contains characters of varying size. {it:vvalue}
may be {cmd:baseline}, {cmd:bottom}, {cmd:center}, or {cmd:top}. The default
is {cmd:valign(baseline)}.

{marker indenttype}{...}
{phang}
{cmd:indent(}{it:indenttype}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}
specifies that the paragraph be indented by {it:#} {it:units}.
{it:indenttype} may be {cmd:left}, {cmd:right}, or {cmd:para}.
{cmd:left} and {cmd:right} indent {it:#} {it:units} from the left or the
right, respectively.  {cmd:para} uses standard paragraph indentation and
indents the first line by {it:#} inches unless another {it:unit} is specified.
This option may be specified multiple times in a single command to accommodate
different indentation settings.

{marker para_position}{...}
{phang}
{cmd:spacing(}{it:position}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}
sets the spacing between lines of text.
{it:position} may be {cmd:before}, {cmd:after}, or {cmd:line}.
{cmd:before} specifies the space before the first line of the current
paragraph, {cmd:after} specifies the space after the last line of the current
paragraph, and {cmd:line} specifies the space between lines within the current
paragraph.  This option may be specified multiple times in a single command to
accommodate different spacing settings.

{phang}
{opth bgcolor:(putpdf_paragraph##color:color)}
sets the background color for the paragraph.

{pmore}
Specifying {cmd:bgcolor()} with {cmd:putpdf paragraph}
overrides background color specifications from
{cmd:putpdf begin}.


{marker opts_putpdf_text}{...}
{title:Options for putpdf text}

{phang}
{opth nformat(%fmt)} specifies the numeric format of the text when the
content of the new text appended to the paragraph is a numeric value. This
setting has no effect when the content is a string.

{phang}
{cmd:font(}{help putpdf_paragraph##font:{it:fontname}}
[{cmd:,} {help putpdf_paragraph##size:{it:size}}
[{cmd:,} {help putpdf_paragraph##color:{it:color}}]]{cmd:)}
sets the font, font size, and font color for the new text within the active
paragraph.  The font size and font color may be specified individually without
specifying {it:fontname}. Use {cmd:font("",} {it:size}{cmd:)} to specify font
size only. Use {cmd:font("", "",} {it:color}{cmd:)} to specify font color
only. For both cases, the default font will be used.

{pmore}
Specifying {cmd:font()} with {cmd:putpdf text} overrides all other font
settings, including those specified with {cmd:putpdf begin} and
{cmd:putpdf paragraph}.

{phang}
{cmd:bold} specifies that the new text in the active paragraph be formatted as
bold.

{phang}
{cmd:italic} specifies that the new text in the active paragraph be formatted
as italic.

{phang}
{cmd:script(sub{c |}super)} changes the script style of the new text.
{cmd:script(sub)} makes the text a subscript. {cmd:script(super)} makes
the text a superscript.

{phang}
{cmd:strikeout} specifies that the new text in the active paragraph have a
strikeout mark.

{phang}
{cmd:underline} specifies that the new text in the active paragraph be
underlined.

{phang}
{opth bgcolor:(putpdf_paragraph##color:color)}
sets the background color for the active paragraph.

{pmore}
Specifying {cmd:bgcolor()} with {cmd:putpdf text}
overrides background color specifications from
{cmd:putpdf begin} and {cmd:putpdf paragraph}.

{phang}
{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}] specifies that one or {it:#} line breaks
be added after the new text.

{phang}
{cmd:allcaps} specifies that all letters of the new text in the active
paragraph be capitalized.


{marker opts_putpdf_image}{...}
{title:Options for putpdf image}

{phang}
{cmd:width(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)} sets the
width of the image.  If the width is larger than the body width of the
document, then the body width is used.  If {cmd:width()} is not specified,
then the default size is used; the default is determined by the image
information and the body width of the document.

{phang}
{cmd:height(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)} sets the
height of the image. If {cmd:height()} is not specified, then the height of
the image is determined by the width and the aspect ratio of the image.

{phang}
{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}] specifies that one or {it:#} line
breaks be added after the new image.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create the {cmd:.pdf} document in memory{p_end}
{phang2}{cmd:. putpdf begin}{p_end}

{pstd}Use {cmd:summarize} to obtain summary statistics on {cmd:mpg}{p_end}
{phang2}{cmd:. summarize mpg}{p_end}

{pstd}Add a new paragraph to the active document and append text to it{p_end}
{phang2}{cmd:. putpdf paragraph}{p_end}
{phang2}{cmd:. putpdf text ("In this dataset, there are `r(N)' models")}{p_end}
{phang2}{cmd:. putpdf text (" of automobiles. The maximum MPG among them is ")}{p_end}
{phang2}{cmd:. putpdf text (r(max)), bold}{p_end}
{phang2}{cmd:. putpdf text (".")}{p_end}

{pstd}
{cmd:putpdf text} can be used to break long sentences into pieces, and each
piece in the paragraph can be customized to have a different style.  Above,
{cmd:r(max)} is formatted as bold.

{pstd}Create a scatterplot and export the graph as a {cmd:.png} file{p_end}
        {cmd:. scatter mpg price}
	{cmd:. graph export auto.png}
	
{pstd}
Add the {cmd:.png} file to the document in a new paragraph that
is centered horizontally{p_end}
	{cmd:. putpdf paragraph, halign(center)}
	{cmd:. putpdf image auto.png, width(4)}

{pstd}
Save the document to disk{p_end}
	{cmd:. putpdf save example.pdf}
