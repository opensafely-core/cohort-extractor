{smcl}
{* *! version 1.0.0  08may2019}{...}
{vieweralsosee "[RPT] putpdf intro" "mansection RPT putpdfintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putpdf begin" "help putpdf begin"}{...}
{vieweralsosee "[RPT] putpdf pagebreak" "help putpdf pagebreak"}{...}
{vieweralsosee "[RPT] putpdf paragraph" "help putpdf paragraph"}{...}
{vieweralsosee "[RPT] putpdf table" "help putpdf table"}{...}
{viewerjumpto "Description" "putpdf intro##description"}{...}
{viewerjumpto "Links to PDF documentation" "putpdf intro##linkspdf"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[RPT] putpdf intro} {hline 2}}Introduction to generating PDF files{p_end}
{p2col:}({mansection RPT putpdfintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:putpdf} suite of commands creates PDF documents that include text,
formatted images, and tables of Stata estimation results and summary statistics.
The following commands are used to create, format, add content to, and save 
PDF documents.


{synoptset 22 tabbed}{...}
{p2coldent:{bf:Create and save PDF files} (see {helpb putpdf begin:[RPT] putpdf begin})}{p_end}

{synopt :{cmd:putpdf begin}}Creates a PDF file for export{p_end}
{synopt :{cmd:putpdf describe}}Describes contents of the active PDF file{p_end}
{synopt :{cmd:putpdf save}}Saves and closes the PDF file{p_end}
{synopt :{cmd:putpdf clear}}Closes the PDF file without saving the changes{p_end}


{p2coldent :{bf:Insert page breaks in a PDF file} (see {helpb putpdf pagebreak:[RPT] putpdf pagebreak})}{p_end}

{synopt :{cmd:putpdf pagebreak}}Adds a page break to the document{p_end}
{synopt :{cmd:putpdf sectionbreak}}Adds a new section to the document{p_end}


{p2coldent :{bf:Add paragraphs with text and images} (see {helpb putpdf paragraph:[RPT] putpdf paragraph})}{p_end}

{synopt :{cmd:putpdf paragraph}}Adds a new paragraph to the active document{p_end}
{synopt :{cmd:putpdf text}}Adds text to the active paragraph{p_end}
{synopt :{cmd:putpdf image}}Appends an image to the active paragraph{p_end}


{p2coldent :{bf:Add tables to a PDF file} (see {helpb putpdf table:[RPT] putpdf table})}{p_end}

{synopt :{opt putpdf table}}Creates a new table in the PDF file containing estimation results, summary statistics, or data in memory{p_end}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putpdfintroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}
