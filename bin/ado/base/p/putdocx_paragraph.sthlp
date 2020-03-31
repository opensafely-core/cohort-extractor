{smcl}
{* *! version 1.0.2  15oct2019}{...}
{vieweralsosee "[RPT] putdocx paragraph" "mansection RPT putdocxparagraph"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putdocx pagebreak" "help putdocx pagebreak"}{...}
{vieweralsosee "[RPT] putdocx paragraph" "help putdocx paragraph"}{...}
{vieweralsosee "[RPT] putdocx table" "help putdocx table"}{...}
{vieweralsosee "[RPT] Appendix for putdocx" "help putdocx_appendix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] set docx" "help set docx"}{...}
{viewerjumpto "Syntax" "putdocx paragraph##syntax"}{...}
{viewerjumpto "Description" "putdocx paragraph##description"}{...}
{viewerjumpto "Links to PDF documentation" "putdocx paragraph##linkspdf"}{...}
{viewerjumpto "Options" "putdocx paragraph##options"}{...}
{viewerjumpto "Examples" "putdocx paragraph##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[RPT] putdocx paragraph} {hline 2}}Add text or images to an Office
Open XML (.docx) file{p_end}
{p2col:}({mansection RPT putdocxparagraph:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Add paragraph to document

{p 8 22 2}
{cmd:putdocx paragraph}
[{cmd:,}
{help putdocx_paragraph##paraopts:{it:paragraph_options}}]


{phang}
Add text to paragraph

{p 8 22 2}
{cmd:putdocx text} {cmd:(}{help exp:{it:exp}}{cmd:)}
[{cmd:,}
{help putdocx_paragraph##textopts:{it:text_options}}]


{phang}
Add a paragraph with a block of text

{p 8 22 2}
{cmd:putdocx textblock begin}
[{cmd:,} {help putdocx_paragraph##textblockopts:{it:textblock_options}}
{help putdocx_paragraph##paraopts:{it:paragraph_options}}]


{phang}
Append a block of text to the active paragraph

{p 8 22 2}
{cmd:putdocx textblock append}
[{cmd:,} {help putdocx_paragraph##textblockopts:{it:textblock_options}}]


{phang}
End the block of text initiated with {cmd:putdocx} {cmd:textblock} {cmd:begin}
or {cmd:putdocx} {cmd:textblock} {cmd:append}

{p 8 22 2}
{cmd:putdocx textblock end}


{phang}
Add page number to paragraph (to be added to header or footer)

{p 8 22 2}
{cmd:putdocx pagenumber}
[{cmd:,}
{help putdocx_paragraph##textopts:{it:text_options}}
{cmd:totalpages}]


{phang}
Add a textfile as a block of preformatted text

{p 8 22 2}
{cmd:putdocx textfile} {it:textfile}
[{cmd:,} {cmd:append}
{cmd:stopat(}{help strings:{it:string}} [{cmd:,}
{help putdocx_paragraph##opt_putdocx_textfile:{it:stopatopt}}]{cmd:)}]


{phang}
Add image to paragraph

{p 8 22 2}
{cmd:putdocx image} {it:{help filename}}
[{cmd:,} {help putdocx_paragraph##imageopts:{it:image_options}}]

{phang}
{it:filename} is the full path to the image file or the relative path from the 
current working directory.


{marker paraopts}{...}
{synoptset 28}{...}
{synopthdr:paragraph_options}
{synoptline}
{synopt :{opth style:(putdocx_paragraph##pstyle:pstyle)}}set paragraph text
with specific style{p_end}
{synopt :{opth font:(putdocx_paragraph##fspec:fspec)}}set font, font size, and
font color{p_end}
{synopt :{opth halign:(putdocx_paragraph##para_hvalue:hvalue)}}set paragraph
alignment{p_end}
{synopt :{opth valign:(putdocx_paragraph##para_vvalue:vvalue)}}set vertical
alignment of characters on each line{p_end}
{synopt :{cmd:indent(}{help putdocx_paragraph##indenttype:{it:indenttype}}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set paragraph indentation{p_end}
{synopt :{cmd:spacing(}{help putdocx_paragraph##position:{it:position}}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set
spacing between lines of text{p_end}
{synopt :{opth shad:ing(putdocx_paragraph##sspec:sspec)}}set background color, foreground color, and fill pattern{p_end}
{synopt :{opth toheader:(putdocx_paragraph##hname:hname)}}add paragraph content to the header {it:hname}{p_end}
{synopt :{opth tofooter:(putdocx_paragraph##fname:fname)}}add paragraph content to the footer {it:fname}{p_end}
{synoptline}

{marker textopts}{...}
{synoptset 28 tabbed}{...}
{synopthdr:text_options}
{synoptline}
{p2coldent :* {opth nfor:mat(%fmt)}}specify numeric format for text{p_end}
{synopt :{opth font:(putdocx_paragraph##fspec:fspec)}}set font, font size, and
font color{p_end}
{synopt :{opt bold}}format text as bold{p_end}
{synopt :{opt italic}}format text as italic{p_end}
{synopt :{cmd:script(sub{c |}super)}}set subscript or superscript formatting of
text{p_end}
{synopt :{opt strike:out}}strike out text{p_end}
{synopt :{cmdab:underl:ine}[{cmd:(}{help putdocx paragraph##upattern:{it:upattern}}{cmd:)}]}underline text using specified pattern{p_end}
{synopt :{opth shad:ing(putdocx_paragraph##sspec:sspec)}}set
background color, foreground color, and fill pattern{p_end}
{synopt :{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}]}add line breaks after
text{p_end}
{synopt :{opt allc:aps}}format text as all caps{p_end}
{p2coldent :* {opt smallc:aps}}format text as small caps{p_end}
{p2coldent :* {opth hyperlink:(putdocx_paragraph##link:link)}}add the text as
a hyperlink{p_end}
{p2coldent :* {opt trim}}remove the leading and trailing spaces in the text{p_end}
{synoptline}
{p 4 6 2}
* Cannot be specified with {cmd:putdocx pagenumber}.

{marker textblockopts}{...}
{synoptset 28}{...}
{synopthdr:textblock_options}
{synoptline}
{synopt :[{ul:{bf:no}}]{opt para:mode}}specify whether blank lines
signal new paragraphs; default is {cmd:noparamode}{p_end}
{synopt :[{ul:{bf:no}}]{opt hard:break}}specify whether spaces
are added after hard line breaks; default is {cmd:nohardbreak}{p_end}
{synoptline}

{marker imageopts}{...}
{synoptset 28}{...}
{synopthdr:image_options}
{synoptline}
{synopt :{cmdab:w:idth(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set image width{p_end}
{synopt :{cmdab:h:eight(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set image height{p_end}
{synopt :{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}]}add line breaks after
image{p_end}
{synopt :{opt link}}insert link to image file{p_end}
{synoptline}

{marker fspec}{...}
{phang}
{it:fspec} is

{pmore}
{it:fontname} [{cmd:,} {it:size} [{cmd:,} {it:color}]]

{marker font}{...}
{pmore2}
{it:fontname} may be any valid font installed on the user's computer.  If
{it:fontname} includes spaces, then it must be enclosed in double quotes.

{marker size}{...}
{pmore2}
{it:size} is a numeric value that represents font size measured in points.
The default is {cmd:11}.

{pmore2}
{it:color} sets the text color.

{marker sspec}{...}
{phang}
{it:sspec} is

{pmore}
{it:bgcolor} [{cmd:,} {it:fgcolor} [{cmd:,} {it:fpattern}]]

{pmore2}
{it:bgcolor} specifies the background color.

{pmore2}
{it:fgcolor} specifies the foreground color.  The default foreground color is
{cmd:black}.

{marker fpattern}{...}
{pmore2}
{it:fpattern} specifies the fill pattern.  The most common fill patterns are
{cmd:solid} for a solid color (determined by {it:fgcolor}), {cmd:pct25} for
25% gray scale, {cmd:pct50} for 50% gray scale, and {cmd:pct75} for 75% gray
scale.  A complete list of fill patterns is shown in
{help putdocx_appendix##Shading_patterns:{it:Shading patterns}} of
{helpb putdocx_appendix:[RPT] Appendix for putdocx}.

{marker color}{...}
{phang}
{it:color}, {it:bgcolor}, and {it:fgcolor} may be one of the colors listed
in {help putdocx_appendix##Colors:{it:Colors}}
of {helpb putdocx_appendix:[RPT] Appendix for putdocx}; a valid RGB value in
the form {it:### ### ###}, for example, {cmd:171 248 103}; or a valid RRGGBB
hex value in the form {it:######}, for example, {cmd:ABF867}.

{marker upattern}{...}
{phang}
{it:upattern} may be any of the patterns listed in
{help putdocx_appendix##Underline_patterns:{it:Underline patterns}} of
{helpb putdocx_appendix:[RPT] Appendix for putdocx}.  The most common underline
patterns are {cmd:double}, {cmd:dash}, and {cmd:none}.

{marker unit}{...}
{phang}
INCLUDE help put_units


{marker description}{...}
{title:Description}

{pstd}
{cmd:putdocx} {cmd:paragraph} adds a new paragraph to the document. The
newly created paragraph becomes the active paragraph. All subsequent text or
images will be appended to the active paragraph.

{pstd}
{cmd:putdocx} {cmd:text} adds text to the paragraph created
by {cmd:putdocx} {cmd:paragraph}.  The text may be a plain text
string or any valid Stata expression (see {findalias frexp}).

{pstd}
{cmd:putdocx} {cmd:textblock} {cmd:begin} adds a new paragraph to which a block
of text can be added. 

{pstd}
{cmd:putdocx} {cmd:textblock} {cmd:append} appends a block of text to the
active paragraph.

{pstd}
{cmd:putdocx} {cmd:textblock} {cmd:end} ends a block of text initiated by
{cmd:putdocx} {cmd:textblock} {cmd:begin} or {cmd:putdocx} {cmd:textblock} 
{cmd:append}. 

{pstd}
{cmd:putdocx} {cmd:textfile} adds a block of
preformatted text to a new paragraph with a predefined style.

{pstd}
{cmd:putdocx} {cmd:pagenumber} adds page numbers to a paragraph that is
to be added to the header or footer.

{pstd}
{cmd:putdocx image} embeds a portable network graphics ({cmd:.png}), JPEG
({cmd:.jpg}), enhanced metafile ({cmd:.emf}), or tagged image file format
({cmd:.tif}) file in the active paragraph.  Adding an image is not supported
on console Stata for Mac.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putdocxparagraphQuickstart:Quick start}

        {mansection RPT putdocxparagraphRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Options are presented under the following headings:

        {help putdocx_paragraph##opt_putdocx_paragraph:Options for putdocx paragraph}
        {help putdocx_paragraph##opt_putdocx_text:Options for putdocx text}
        {help putdocx_paragraph##opt_putdocx_textblock_begin:Options for putdocx textblock begin}
        {help putdocx_paragraph##opt_putdocx_textblock_append:Options for putdocx textblock append}
        {help putdocx_paragraph##opt_putdocx_pagenumber:Options for putdocx pagenumber}
        {help putdocx_paragraph##opt_putdocx_textfile:Options for putdocx textfile}
        {help putdocx_paragraph##opt_putdocx_image:Options for putdocx image}


{marker opt_putdocx_paragraph}{...}
{title:Options for putdocx paragraph}

{marker pstyle}{...}
{phang}
{opt style(pstyle)}
specifies that the text in the paragraph be
formatted with style {it:pstyle}. Common values for {it:pstyle} are
{cmd:Title}, {cmd:Subtitle}, and {cmd:Heading1}. See the complete list of
paragraph styles in
{help putdocx_appendix##Paragraph_styles:{it:Paragraph styles}} of
{helpb putdocx_appendix:Appendix for putdocx}.

{phang}
{cmd:font(}{help putdocx_paragraph##font:{it:fontname}}
[{cmd:,} {help putdocx_paragraph##size:{it:size}}
[{cmd:,} {help putdocx_paragraph##color:{it:color}}]]{cmd:)}
sets the font, font size, and font color for the text within the paragraph.
The font size and font color may be specified individually without specifying
{it:fontname}. Use {cmd:font("",} {it:size}{cmd:)} to specify font size only.
Use {cmd:font("", "",} {it:color}{cmd:)} to specify font color only. For both
cases, the default font will be used.

{pmore}
Specifying {cmd:font()} with {cmd:putdocx paragraph} overrides font properties
specified with {cmd:putdocx begin}.

{marker para_hvalue}{...}
{phang}
{opt halign(hvalue)} sets the horizontal alignment of the text within the
paragraph. {it:hvalue} may be {cmd:left}, {cmd:right}, {cmd:center},
{cmd:both}, or {cmd:distribute}.  {cmd:distribute} and {cmd:both} justify text
between the left and right margins equally, but {cmd:distribute} also changes
the spacing between words and characters. The default is {cmd:halign(left)}.

{marker para_vvalue}{...}
{phang}
{opt valign(vvalue)} sets the vertical alignment of the characters on
each line when the paragraph contains characters of varying size. {it:vvalue}
may be {cmd:auto}, {cmd:baseline}, {cmd:bottom}, {cmd:center}, or {cmd:top}.
The default is {cmd:valign(baseline)}.

{marker indenttype}{...}
{phang}
{cmd:indent(}{it:indenttype}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}
specifies that the paragraph be indented by {it:#} {it:units}.
{it:indenttype} may be {cmd:left}, {cmd:right}, {cmd:hanging}, or {cmd:para}.
{cmd:left} and {cmd:right} indent {it:#} {it:units} from the left or the
right, respectively.  {cmd:hanging} uses hanging indentation and indents lines
after the first line by {it:#} inches unless another {it:unit} is specified.
{cmd:para} uses standard paragraph indentation and indents the first line by
{it:#} inches unless another {it:unit} is specified.  This option may be
specified multiple times in a single command to accommodate different
indentation settings.  If both {cmd:indent(hanging)} and {cmd:indent(para)}
are specified, only {cmd:indent(hanging)} is used.

{marker position}{...}
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
{cmd:shading(}{help putdocx_paragraph##color:{it:bgcolor}}
[{cmd:,} {help putdocx_paragraph##color:{it:fgcolor}}
[{cmd:,} {help putdocx_paragraph##fpattern:{it:fpattern}}]]{cmd:)}
sets the background color, foreground color, and fill pattern for the
paragraph.

{marker hname}{...}
{phang}
{opt toheader(hname)}
specifies that the paragraph be added to the header {it:hname}. The paragraph
will not be added to the body of the document.

{marker fname}{...}
{phang}
{opt tofooter(fname)}
specifies that the paragraph be added to the footer {it:fname}. The
paragraph will not be added to the body of the document.


{marker opt_putdocx_text}{...}
{title:Options for putdocx text}

{phang}
{opth nformat(%fmt)} specifies the numeric format of the text when the
content of the new text appended to the paragraph is a numeric value. This
setting has no effect when the content is a string.

{phang}
{cmd:font(}{help putdocx_paragraph##font:{it:fontname}}
[{cmd:,} {help putdocx_paragraph##size:{it:size}}
[{cmd:,} {help putdocx_paragraph##color:{it:color}}]]{cmd:)}
sets the font, font size, and font color for the new text within the active
paragraph.  The font size and font color may be specified individually without
specifying {it:fontname}. Use {cmd:font("",} {it:size}{cmd:)} to specify the
font size only. Use {cmd:font("", "",} {it:color}{cmd:)} to specify the font
color only.  For both cases, the default font will be used.

{pmore}
Specifying {cmd:font()} with {cmd:putdocx text} overrides all other font
settings, including those specified with {cmd:putdocx begin} and
{cmd:putdocx paragraph}.

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
{cmd:underline}[{cmd:(}{help putdocx_paragraph##upattern:{it:upattern}}{cmd:)}]
specifies that the new text in the active paragraph be underlined and
optionally specifies the format of the line.  By default, a single underline
is used.

{phang}
{cmd:shading(}{help putdocx_paragraph##color:{it:bgcolor}}
[{cmd:,} {help putdocx_paragraph##color:{it:fgcolor}}
[{cmd:,} {help putdocx_paragraph##fpattern:{it:fpattern}}]]{cmd:)}
sets the background color, foreground color, and fill pattern for the active
paragraph.  Specifying {cmd:shading()} with {cmd:putdocx text} overrides
shading specifications from {cmd:putdocx paragraph}.

{phang}
{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}] specifies that one or {it:#} line
breaks be added after the new text.

{phang}
{cmd:allcaps} specifies that all letters of the new text in the active paragraph
be capitalized.

{phang}
{cmd:smallcaps} specifies that all letters of the new text in the active
paragraph be capitalized, with larger capitals for uppercase letters and
smaller capitals for lowercase letters.


{marker opt_putdocx_textblock_begin}{...}
{title:Options for putdocx textblock begin}

{phang}
{opt style(pstyle)}
specifies that the text in the paragraphs be
formatted with style {it:pstyle}.  Common values for {it:pstyle} are
{cmd:Title}, {cmd:Subtitle}, and {cmd:Heading1}. See the complete list of
paragraph styles in
{help putdocx_appendix##Paragraph styles}:{it:Paragraph styles}} of
{manhelp putdoc_appendix RPT:Appendix for putdocx}.

{phang}
{cmd:font(}{help putdocx_paragraph##font:{it:fontname}}
[{cmd:,} {help putdocx_paragraph##size:{it:size}}
[{cmd:,} {help putdocx_paragraph##color:{it:color}}]]{cmd:)}
sets the font, font size, and font color for the text within the paragraphs.
The font size and font color may be specified individually without specifying
{it:fontname}. Use {cmd:font("",} {it:size}{cmd:)} to specify font size only.
Use {cmd:font("", "",} {it:color}{cmd:)} to specify font color only. For both
cases, the default font will be used.

{pmore}
Specifying {cmd:font()} with {cmd:putdocx} {cmd:textblock} {cmd:begin}
overrides font properties specified with {cmd:putdocx begin}.

{phang}
{opt halign(hvalue)} sets the horizontal alignment of the text within the
paragraphs. {it:hvalue} may be {cmd:left}, {cmd:right}, {cmd:center},
{cmd:both}, or {cmd:distribute}.  {cmd:distribute} and {cmd:both} justify text
between the left and right margins equally, but {cmd:distribute} also changes
the spacing between words and characters. The default is {cmd:halign(left)}.

{phang}
{opt valign(vvalue)} sets the vertical alignment of the characters on
each line when the paragraphs contain characters of varying size. {it:vvalue}
may be {cmd:auto}, {cmd:baseline}, {cmd:bottom}, {cmd:center}, or {cmd:top}.
The default is {cmd:valign(baseline)}.

{phang}
{cmd:indent(}{it:indenttype}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}
specifies that the paragraphs be indented by {it:#} {it:units}.
{it:indenttype} may be {cmd:left}, {cmd:right}, {cmd:hanging}, or {cmd:para}.
{cmd:left} and {cmd:right} indent {it:#} {it:units} from the left or the
right, respectively.  {cmd:hanging} uses hanging indentation and indents lines
after the first line by {it:#} inches unless another {it:unit} is specified.
{cmd:para} uses standard paragraph indentation and indents the first line by
{it:#} inches unless another {it:unit} is specified.  This option may be
specified multiple times in a single command to accommodate different
indentation settings.  If both {cmd:indent(hanging)} and {cmd:indent(para)}
are specified, only {cmd:indent(hanging)} is used.

{phang}
{cmd:spacing(}{it:position}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}
sets the spacing between lines of text.  {it:position} may be {cmd:before},
{cmd:after}, or {cmd:line}.  {cmd:before} specifies the space before the first
line of each paragraph in the text block, {cmd:after} specifies the space
after the last line of each paragraph, and {cmd:line} specifies the space
between lines within each paragraph.  This option may be specified multiple
times in a single command to accommodate different spacing settings.

{phang}
{cmd:shading(}{help putdocx_paragraph##color:{it:bgcolor}}
[{cmd:,} {help putdocx_paragraph##color:{it:fgcolor}}
[{cmd:,} {help putdocx_paragraph##fpattern:{it:fpattern}}]]{cmd:)}
sets the background color, foreground color, and fill pattern for the
paragraphs.

{phang}
{opt toheader(hname)}
specifies that the first paragraph in a text block be added to the header
{it:hname}.  The first paragraph will not be added to the body of the
document.

{pmore}
When you specify the {cmd:paramode} option with {cmd:toheader()}, all
paragraphs after the first will be added to the body of the document, not the
header.

{phang}
{opt tofooter(fname)}
specifies that the first paragraph in a text block be added to the footer
{it:fname}. The first paragraph will not be added to the body of the
document.

{pmore}
When you specify the {cmd:paramode} option with {cmd:tofooter()}, all
paragraphs after the first will be added to the body of the document, not the
footer.

{phang}
{cmd:noparamode} and {cmd:paramode} specify whether blank lines within a
block of text signal the beginning of a new paragraph in the document.
{cmd:noparamode}, the default, exports the block of text as a single
paragraph, removing any empty lines.  {cmd:paramode} treats blank lines as an
indication of a new paragraph. When {cmd:paramode} is specified, the text
following each blank line will begin a new paragraph.  The treatment of
paragraphs within text blocks can also be specified by using
{cmd:set docx_paramode}; see {manhelp set_docx RPT:set docx}.

{phang}
{cmd:nohardbreak} and {cmd:hardbreak} specify whether {cmd:putdocx textblock}
inserts a space at the beginning of lines or respects spaces exactly as they
are typed. {cmd:nohardbreak}, the default, respects spaces at the beginning
and end of lines exactly as they are typed in the text block.  The
{cmd:hardbreak} option inserts a space at the beginning of all nonempty lines,
excluding the first line in the block of text and the first line of each
paragraph.  Thus, {cmd:hardbreak} adds a space after the hard line breaks in
the text block.  The treatment of spaces at line breaks can also be specified
by using {cmd:set docx_hardbreak}; see {manhelp set_docx RPT:set docx}.


{marker opt_putdocx_textblock_append}{...}
{title:Options for putdocx textblock append}

{phang}
{cmd:noparamode} and {cmd:paramode} specify whether blank lines within a
block of text signal the beginning of a new paragraph in the document.
{cmd:noparamode}, the default, exports the block of text as
a single paragraph, removing any empty lines.  {cmd:paramode} treats
blank lines as an indication of a new paragraph. When {cmd:paramode} is
specified, the text following each blank line will begin a new paragraph.
The treatment of paragraphs within text blocks can also be specified by
using {cmd:set docx_paramode}; see {manhelp set_docx RPT:set docx}.

{phang}
{cmd:nohardbreak} and {cmd:hardbreak} specify whether {cmd:putdocx textblock}
inserts a space at the beginning of lines or respects spaces exactly as
they are typed. {cmd:nohardbreak}, the default, respects spaces at the
beginning and end of lines exactly as they are typed in the text block.
The {cmd:hardbreak} option inserts a space at the beginning of all nonempty
lines, excluding the first line in the block of text and the first line of
each paragraph.  Thus, {cmd:hardbreak} adds a space after the hard line breaks
in the text block.  The treatment of spaces at line breaks can also be
specified by using {cmd:set docx_hardbreak}; see
{manhelp set_docx RPT:set docx}.


{marker opt_putdocx_pagenumber}{...}
{title:Options for putdocx pagenumber}

{phang}
{cmd:font(}{help putdocx_paragraph##font:{it:fontname}}
[{cmd:,} {help putdocx_paragraph##size:{it:size}}
[{cmd:,} {help putdocx_paragraph##color:{it:color}}]]{cmd:)}
sets the font, font size, and font color for the page numbers. The font size 
and font color may be specified individually without
specifying {it:fontname}. Use {cmd:font("",} {it:size}{cmd:)} to specify the
font size only. Use {cmd:font("", "",} {it:color}{cmd:)} to specify the font
color only.  For both cases, the default font will be used.

{pmore}
Specifying {cmd:font()} with {cmd:putdocx pagenumber} overrides all other font
settings, including those specified with {cmd:putdocx begin} and
{cmd:putdocx paragraph}.

{phang}
{cmd:bold} specifies that the page numbers be formatted as bold.

{phang}
{cmd:italic} specifies that the page numbers be formatted as italic.

{phang}
{cmd:script(sub{c |}super)} changes the script style of the page numbers.
{cmd:script(sub)} makes the page numbers subscripts. {cmd:script(super)} makes
the page numbers superscripts.

{phang}
{cmd:strikeout} specifies that the page numbers have a strikeout mark.

{phang}
{cmd:underline}[{cmd:(}{help putdocx_paragraph##upattern:{it:upattern}}{cmd:)}]
specifies that the page numbers be underlined and optionally specifies the
format of the line.  By default, a single underline is used.

{phang}
{cmd:shading(}{help putdocx_paragraph##color:{it:bgcolor}}
[{cmd:,} {help putdocx_paragraph##color:{it:fgcolor}}
[{cmd:,} {help putdocx_paragraph##fpattern:{it:fpattern}}]]{cmd:)}
sets the background color, foreground color, and fill pattern for the page
numbers. Specifying {cmd:shading()} with {cmd:putdocx pagenumber} overrides
shading specifications from {cmd:putdocx paragraph}.

{phang}
{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}] specifies that one or {it:#} line
breaks be added after the page numbers.

{phang}
{cmd:allcaps} specifies that the page numbers be capitalized; this only applies 
with the page number formats {cmd:lower_letter}, {cmd:lower_roman},
{cmd:cardinal_text}, and {cmd:ordinal_text}. 

{phang}
{cmd:totalpages} specifies that the total number of pages be displayed, instead 
of the current number of the page.


{marker opt_putdocx_textfile}{...}
{title:Options for putdocx textfile}

{phang}
{cmd:append} specifies that the text file be appended to the current paragraph,
rather than being added as a new paragraph.

{phang}
{cmd:stopat(}{it:string}[{cmd:,} {it:stopatopt}]{cmd:)} specifies that only a
portion of the text file be included, using the specified string as the end
point. 

{pmore} 
{it:stopatopt} must be one of {cmd:contain}, {cmd:begin}, or {cmd:end}.  The
default is {cmd:contain}, which matches the string inside the line.
{cmd:begin} matches the string at the beginning of the line.  {cmd:end}
matches the string at the end of the line.  If the line matches the string,
the rest of the text file, including the line, will not be included in the
document.


{marker opt_putdocx_image}{...}
{title:Options for putdocx image}

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

{marker link}{...}
{phang}
{cmd:link} specifies that a link to the image {it:filename} be inserted into
the document.  If the image is linked, then the referenced file must be
present so that the document can display the image.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create a {cmd:.docx} document in memory{p_end}
{phang2}{cmd:. putdocx begin}{p_end}

{pstd}Use {cmd:summarize} to obtain summary statistics on {cmd:mpg}{p_end}
{phang2}{cmd:. summarize mpg}{p_end}

{pstd}Add a new paragraph to the active document and append text to it{p_end}
{phang2}{cmd:. putdocx paragraph}{p_end}
{phang2}{cmd:. putdocx text ("In this dataset, there are `r(N)' models")}{p_end}
{phang2}{cmd:. putdocx text (" of automobiles. The maximum MPG among them is ")}{p_end}
{phang2}{cmd:. putdocx text (r(max)), bold}{p_end}
{phang2}{cmd:. putdocx text (".")}{p_end}

{pstd}
{cmd:putdocx text} can be used to break long sentences into pieces, and each
piece in the paragraph can be customized to have a different style.  Above,
{cmd:r(max)} is formatted as bold.

{pstd}Create a scatterplot and export the graph as a {cmd:.png} file{p_end}
        {cmd:. scatter mpg price}
	{cmd:. graph export auto.png}
	
{pstd}
Add the {cmd:.png} file to the document in a new paragraph that
is centered horizontally{p_end}
	{cmd:. putdocx paragraph, halign(center)}
	{cmd:. putdocx image auto.png, width(4)}

{pstd}
Save the document to disk{p_end}
	{cmd:. putdocx save example.docx}
