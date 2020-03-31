{smcl}
{* *! version 1.1.0  08may2019}{...}
{vieweralsosee "[RPT] markdown" "mansection RPT markdown"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] Dynamic tags" "help dynamic tags"}{...}
{vieweralsosee "[RPT] dyndoc" "help dyndoc"}{...}
{vieweralsosee "[RPT] dyntext" "help dyntext"}{...}
{viewerjumpto "Syntax" "markdown##syntax"}{...}
{viewerjumpto "Description" "markdown##description"}{...}
{viewerjumpto "Links to PDF documentation" "markdown##linkspdf"}{...}
{viewerjumpto "Options" "markdown##options"}{...}
{viewerjumpto "Remarks" "markdown##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[RPT] markdown} {hline 2}}Convert Markdown document to HTML
file or Word (.docx) document{p_end}
{p2col:}({mansection RPT markdown:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:markdown} {it:srcfile}{cmd:,}
{opth sav:ing(filename:targetfile)}
[{it:options}]

{phang}
{it:srcfile} is the Markdown document to be converted.

{phang}
You may enclose {it:srcfile} and  {it:targetfile} in double quotes and must
do so if they contain spaces or special characters.

{marker markdown_options}{...}
{synoptset 22 tabbed}{...}
{synopthdr}
{synoptline}
{p2coldent :* {opth sav:ing(filename:targetfile)}}HTML file or Word
({cmd:.docx}) document to be saved{p_end}
{synopt :{opt rep:lace}}replace the target HTML file or Word ({cmd:.docx})
document if it already exists{p_end}
{synopt :{opt hardwrap}}replace hard wraps (actual line breaks) with the
{cmd:<br>} tag in an HTML file or with line breaks in a Word ({cmd:.docx})
document{p_end}
{synopt :{opt nomsg}}suppress message with a link to {it:targetfile}{p_end}
{synopt :{opt embedimage}}embed image files as Base64 binary data in the
target HTML file{p_end}
{synopt :{opth basedir:(strings:string)}}specify the base directory for relative links
in {it:srcfile}{p_end}
{synopt :{cmd:docx}}output a Word {cmd:.docx} document instead of an HTML
file{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* {opt saving(targetfile)} is required.


{marker description}{...}
{title:Description}

{pstd}
{cmd:markdown} converts a Markdown document to an HTML file or a Word 
document.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT markdownQuickstart:Quick start}
        {mansection RPT markdownRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth saving:(filename:targetfile)} specifies the target file to be
saved.  If the {it:targetfile} has the {cmd:.docx} extension, the {cmd:docx}
option is assumed even if it is not specified.  {cmd:saving()} is required.

{phang}
{cmd:replace} specifies that the target file be replaced if it already exists.

{phang}
{cmd:hardwrap} specifies that hard wraps (actual line breaks) in the Markdown 
document be replaced with the {cmd:<br>} tag in the HTML file or with
a line break in the Word ({cmd:.docx}) file if the {cmd:docx} option is
specified.

{phang}
{cmd:nomsg} suppresses the message that contains a link to the target file.

{phang}
{cmd:embedimage} allows image files to be embedded as data URI
(Base64-encoded binary data) in the HTML file.  The supported image file types
are portable network graphics ({cmd:.png}), JPEG ({cmd:.jpg}), tagged image
file format ({cmd:.tif}), and graphics interchange format ({cmd:.gif}).  This
option cannot be used to embed SVG and PDF image file types.

{pmore}
The image must be specified in a Markdown link; you cannot embed images
specified by URLs.  This option is ignored if {cmd:docx} is specified.

{phang}
{opth basedir:(strings:string)} specifies the base directory for the relative
links in the {it:srcfile}.  This option only applies when specifying either
the {cmd:docx} option or the {cmd:embedimage} option; otherwise, this option
is ignored.

{phang}
{cmd:docx} specifies that the target file be saved in Microsoft Word
({cmd:.docx}) format.  If the target file has the {cmd:.docx} extension, the
{cmd:docx} option is implied.  The conversion process consists of first
producing an HTML file and then using {helpb html2docx} to produce the final
Word document.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:markdown} converts a Markdown document to an HTML file or a Word
({cmd:.docx}) document.  A Markdown document is written using an easy-to-read,
plain-text, lightweight markup language.  For a detailed discussion and the
syntax of Markdown, see the
{browse "https://en.wikipedia.org/wiki/Markdown":Markdown Wikipedia page}.

{pstd}
Stata uses Flexmark's Pegdown emulation as its default Markdown document
processing engine.  For information on Pegdown's flavor of Markdown, see the
{browse "https://github.com/sirthias/pegdown":Pegdown GitHub page}.

{pstd}
See {manhelp dyndoc RPT} and {manhelp dyntext RPT} for a full description of
Stata's dynamic document-generation commands.  {cmd:markdown} is used by
{cmd:dyndoc} but may also be used directly by programmers.
{p_end}

{pstd}
Suppose we have the file {cmd:markdown1.txt} containing
Markdown-formatted text.

{pstd}
To generate the target HTML file in Stata, we type

{phang2}
{cmd:. markdown markdown1.txt, saving(tips.html)}

{pstd}
The HTML file {cmd:tips.html} is saved.

{pstd}
You can see these and related files at
{browse "https://www.stata-press.com/data/r16/reporting/"}.
{p_end}
