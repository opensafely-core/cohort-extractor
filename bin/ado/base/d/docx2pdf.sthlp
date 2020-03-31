{smcl}
{* *! version 1.0.0  08may2019}{...}
{vieweralsosee "[RPT] docx2pdf" "mansection RPT docx2pdf"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] html2docx" "help html2docx"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{viewerjumpto "Syntax" "docx2pdf##syntax"}{...}
{viewerjumpto "Description" "docx2pdf##description"}{...}
{viewerjumpto "Links to PDF documentation" "docx2pdf##linkspdf"}{...}
{viewerjumpto "Options" "docx2pdf##options"}{...}
{viewerjumpto "Remarks" "docx2pdf##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[RPT] docx2pdf} {hline 2}}Convert a Word (.docx) document to a PDF
file{p_end}
{p2col:}({mansection RPT docx2pdf:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:docx2pdf} {it:srcfile}
[{cmd:,} {it:options}]

{phang}
{it:srcfile} is a {cmd:.docx} file.
If {it:srcfile} is specified without an extension, {cmd:.docx} is assumed.
If {it:srcfile} contains embedded spaces or other special characters,
enclose it in double quotes.

{marker docx2pdf_options}{...}
{synoptset 22}{...}
{synopthdr}
{synoptline}
{synopt :{opth sav:ing(filename:targetfile)}}specify the target
PDF file to be saved{p_end}
{synopt :{opt rep:lace}}replace the target PDF file if it
already exists{p_end}
{synopt :{opt nomsg}}suppress message with link to {it:targetfile}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:docx2pdf} converts a Word ({cmd:.docx}) document to a PDF file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT docx2pdfQuickstart:Quick start}
        {mansection RPT docx2pdfRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth saving:(filename:targetfile)} specifies the target
PDF file to be saved.  If {it:targetfile} is specified without an extension,
{cmd:.pdf} is assumed.  If {it:targetfile} contains embedded spaces or other
special characters, enclose it in double quotes.  If {cmd:saving()} is not
specified, the target filename is constructed using the source filename
({it:srcfile}) with the {cmd:.pdf} extension.

{phang}
{cmd:replace} specifies that the target PDF file be replaced if it 
already exists.

{phang}
{cmd:nomsg} suppresses the message that contains a link to the target file.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:docx2pdf} converts Word ({cmd:.docx}) documents to PDF files.  This
command is most useful when you want to convert an HTML file to a PDF file; in
this case, you would first use {helpb html2docx} to convert the HTML file to a
Word document and then use {cmd:docx2pdf} to convert it to a PDF file.  If you
would like to convert a dynamic Markdown document to a PDF file, you can use
{helpb dyndoc} to create a Word document and then use {cmd:docx2pdf} to
convert that Word document to a PDF file.

{pstd}
If you are wanting to embed Stata results and graphs in a PDF file, you can
also use the {cmd:putpdf} suite; see {helpb putpdf intro:[RPT] putpdf intro}.

{pstd}
Suppose we have the Word document {cmd:graphs.docx}.
To convert this file to a PDF file, we type

{phang2}
{cmd:. docx2pdf graphs.docx}

{pstd}
The file {cmd:graphs.pdf} is saved.

{pstd}
You can see these files at
{browse "https://www.stata-press.com/data/r16/reporting/"}.
{p_end}
