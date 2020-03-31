{smcl}
{* *! version 1.2.0  08may2019}{...}
{vieweralsosee "[RPT] dyndoc" "mansection RPT dyndoc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] Dynamic tags" "help dynamic tags"}{...}
{vieweralsosee "[RPT] dyntext" "help dyntext"}{...}
{vieweralsosee "[RPT] markdown" "help markdown"}{...}
{viewerjumpto "Syntax" "dyndoc##syntax"}{...}
{viewerjumpto "Description" "dyndoc##description"}{...}
{viewerjumpto "Links to PDF documentation" "dyndoc##linkspdf"}{...}
{viewerjumpto "Options" "dyndoc##options"}{...}
{viewerjumpto "Remarks" "dyndoc##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[RPT] dyndoc} {hline 2}}Convert dynamic Markdown document to
HTML or Word (.docx) document{p_end}
{p2col:}({mansection RPT dyndoc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:dyndoc} {it:srcfile} [{it:arguments}]
[{cmd:,} {it:options}]

{phang}
{it:srcfile} is a plain text file containing Markdown-formatted text
and {help Dynamic tags:Stata dynamic tags}.

{phang}
{it:arguments} are stored in the local macros {cmd:`1'}, {cmd:`2'}, and so
on for use in {it:srcfile}; see {findalias frarg}.

{phang}
You may enclose {it:srcfile} and {it:targetfile} in double quotes and
must do so if they contain blanks or other special characters.

{marker dyndoc_options}{...}
{synoptset 19}{...}
{synopthdr}
{synoptline}
{synopt :{opth sav:ing(filename:targetfile)}}specify the target
HTML file or Word ({cmd:.docx}) document to be saved{p_end}
{synopt :{opt rep:lace}}replace the target HTML file or Word ({cmd:.docx})
document if it already exists{p_end}
{synopt :{opt hardwrap}}replace hard wraps (actual line breaks) with the
{cmd:<br>} tag in an HTML file or with line breaks in a Word ({cmd:.docx})
document{p_end}
{synopt :{cmd:nomsg}}suppress message with a link to {it:targetfile}{p_end}
{synopt :{cmd:nostop}}do not stop when an error occurs{p_end}
{synopt :{cmd:embedimage}}embed image files as Base64 binary data in the
target HTML file{p_end}
{synopt :{cmd:docx}}output a Word ({cmd:.docx}) document instead of an HTML
file{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:dyndoc} converts a dynamic Markdown document -- a document containing
both formatted text and Stata commands -- to an HTML file or Word document.
Stata processes the Markdown text and Stata dynamic tags (see
{helpb dynamic tags:[RPT] Dynamic tags}) and creates the output file.
Markdown is a simple markup language with a formatting syntax based on plain
text.  It is easily converted to an output format such as HTML.  Stata dynamic
tags allow Stata commands, output, and graphs to be interleaved with Markdown
text.

{pstd}
If you want to convert a Markdown document without Stata dynamic tags to an
HTML file or Word document, see {manhelp markdown RPT}.
If you want to convert a plain text file containing Stata dynamic tags to a
plain text output file, see {manhelp dyntext RPT}.  If you want to convert an 
HTML file to a Word document, see {manhelp html2docx RPT}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT dyndocQuickstart:Quick start}
        {mansection RPT dyndocRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang} 
{opth saving:(filename:targetfile)} specifies the target file to be saved.  If
{cmd:saving()} is not specified, the target filename is constructed using the
source filename ({it:srcfile}) with the {cmd:.html} extension or with the
{cmd:.docx} extension if {cmd:docx} is specified.  If the {it:targetfile} has
the {cmd:.docx} extension, the {cmd:docx} option is assumed even if it is not
specified.

{phang}
{cmd:replace} specifies that the target file be replaced if it already exists.

{phang}
{cmd:hardwrap} specifies that hard wraps (actual line breaks) in the Markdown
document be replaced with the {cmd:<br>} tag in the HTML file or with a line
break in the Word ({cmd:.docx}) document if the {cmd:docx} option is
specified.

{phang}
{cmd:nomsg} suppresses the message that contains a link to the target file.

{phang}
{cmd:nostop} allows the document to continue being processed even if an error
occurs.  By default, {cmd:dyndoc} stops processing the document if an error
occurs.  The error can be caused by either a malformed dynamic tag or 
Stata code executed within the tag.

{phang}
{cmd:embedimage} allows image files to be embedded as data URI (Base64-encoded
binary data) in the HTML file.  The supported image file types are
portable network graphics ({cmd:.png}), JPEG ({cmd:.jpg}), tagged image file
format ({cmd:.tif}), and graphics interchange format ({cmd:.gif}).  This option
cannot be used to embed SVG and PDF image file types.

{pmore}
The image must be specified in a Markdown link; you cannot embed images 
specified by URLs.  This option is ignored if {cmd:docx} is specified.

{phang}
{cmd:docx} specifies that the target file be saved in Microsoft Word
({cmd:.docx}) format.  If the target file has the {cmd:.docx} extension, the
{cmd:docx} option is implied.  The conversion process consists of first
producing an HTML file and then using {helpb html2docx} to produce the final
Word document.


{marker remarks}{...}
{title:Remarks}

{pstd}
A dynamic document contains both static narrative and dynamic tags.
Dynamic tags are instructions for {cmd:dyndoc} to perform a certain
action, such as run a block of Stata code, insert the result of a
Stata expression in text, export a Stata graph to an image file, or
include a link to the image file.  Any changes in the data or in
Stata will change the output as the document is created.  The main advantages
of using dynamic documents are

{phang2} o results in the document come from executing commands instead of
being copied from Stata and pasted into the document;

{phang2}o no need to maintain parallel do-files; and

{phang2}o any changes in data or in Stata are reflected in the final document
when it is created.
{p_end}

{pstd}
Suppose we have the file {cmd:dyndoc_ex.txt} containing
Markdown-formatted text that includes
{help dynamic tags:Stata dynamic tags}.

{pstd}
To generate the target HTML file in Stata, we type

{phang2}
{cmd:. dyndoc dyndoc_ex.txt}

{pstd}
The HTML file {cmd:dyndoc_ex.html} is saved.

{pstd}
You can see these and related files at
{browse "https://www.stata-press.com/data/r16/reporting/"}.
{p_end}
