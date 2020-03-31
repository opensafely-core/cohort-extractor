{smcl}
{* *! version 1.0.0  08may2019}{...}
{vieweralsosee "[RPT] html2docx" "mansection RPT html2docx"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] docx2pdf" "help docx2pdf"}{...}
{vieweralsosee "[RPT] dyndoc" "help dyndoc"}{...}
{vieweralsosee "[RPT] markdown" "help markdown"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{viewerjumpto "Syntax" "html2docx##syntax"}{...}
{viewerjumpto "Description" "html2docx##description"}{...}
{viewerjumpto "Links to PDF documentation" "html2docx##linkspdf"}{...}
{viewerjumpto "Options" "html2docx##options"}{...}
{viewerjumpto "Remarks" "html2docx##remarks"}{...}
{p2colset 1 20 31 2}{...}
{p2col:{bf:[RPT] html2docx} {hline 2}}Convert an HTML file to a Word (.docx)
document{p_end}
{p2col:}({mansection RPT html2docx:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:html2docx} {it:srcfile}
[{cmd:,} {it:options}]

{phang}
{it:srcfile} is an HTML file, either a local file or a URL.
If {it:srcfile} is specified without an extension, {cmd:.html} is assumed.
If {it:srcfile} contains embedded spaces or other special characters,
enclose it in double quotes.

{marker html2docx_options}{...}
{synoptset 22}{...}
{synopthdr}
{synoptline}
{synopt :{opth sav:ing(filename:targetfile)}}specify the target Word
({cmd:.docx}) document to be saved{p_end}
{synopt :{opt rep:lace}}replace the target Word ({cmd:.docx}) document if it
already exists{p_end}
{synopt :{cmd:nomsg}}suppress message with link to {it:targetfile}{p_end}
{synopt :{opth base:(strings:string)}}specify the base directory or base URL for
relative links in {it:srcfile}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:html2docx} converts an HTML file to a Word ({cmd:.docx}) document.  The
HTML file can be either a file on the local disk or a URL on a remote website.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT html2docxQuickstart:Quick start}
        {mansection RPT html2docxRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth saving:(filename:targetfile)} specifies the target Word ({cmd:.docx})
document file to be saved.  If {it:targetfile} is specified without an
extension, {cmd:.docx} is assumed.  If {it:targetfile} contains embedded
spaces or other special characters, enclose it in double quotes.  If
{cmd:saving()} is not specified, the target filename is constructed using the
source filename ({it:srcfile}) with the {cmd:.docx} extension.  {cmd:saving()}
is required if the {it:srcfile} is a URL.

{phang}
{cmd:replace} specifies that the target Word ({cmd:.docx}) document be
replaced if it already exists.

{phang}
{cmd:nomsg} suppresses the message that contains a link to the target file.

{phang}
{opth base:(strings:string)} specifies the base directory or the base URL for 
the relative links in the {it:srcfile}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:html2docx} converts HTML files to Word ({cmd:.docx}) documents.  It
attempts to preserve the styles of various HTML elements in the {cmd:.docx}
file.  However, for some HTML elements, there is no direct translation for a
{cmd:.docx} file.  For instance, an apostrophe in an HTML file may be replaced
with another character in the {cmd:.docx} file.  Thus, your target Word
document may require some cleaning after the {cmd:html2docx} conversion.

{pstd}
{cmd:html2docx} expects a valid HTML file -- one that contains
essential HTML elements such as {cmd:<!DOCTYPE html>}, {cmd:<html>},
{cmd:<head>}, and {cmd:<body>}.  If the HTML file is not valid, {cmd:html2docx}
will go through a tidying process to attempt to make it valid.  {cmd:html2docx}
will produce an error message if this tidying process fails.  You may check
whether an HTML file is valid by using the W3C online Markup
Validation Service at
{browse "https://validator.w3.org/#validate_by_upload+with_options"}.

{pstd}
If you are working with a Markdown-formatted text file, you can convert this
file directly to a Word document by specifying the {cmd:docx} option with
{cmd:markdown}; see {manhelp markdown RPT}.  Similarly, you can use
{cmd:dyndoc} to convert a text file with Stata commands and Markdown-formatted
text to a Word document with Stata output; see {manhelp dyndoc RPT}.

{pstd}
Suppose we have the HTML file {cmd:graphs.html}.
To convert this file to a Word document, we type

{phang2}
{cmd:. html2docx graphs.html}

{pstd}
The file {cmd:graphs.docx} is saved.

{pstd}
You can see these files at
{browse "https://www.stata-press.com/data/r16/reporting/"}.
{p_end}
