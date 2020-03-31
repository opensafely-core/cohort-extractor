{smcl}
{* *! version 1.0.0  08may2019}{...}
{vieweralsosee "[RPT] putdocx intro" "mansection RPT putdocxintro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putdocx begin" "help putdocx begin"}{...}
{vieweralsosee "[RPT] putdocx pagebreak" "help putdocx pagebreak"}{...}
{vieweralsosee "[RPT] putdocx paragraph" "help putdocx paragraph"}{...}
{vieweralsosee "[RPT] putdocx table" "help putdocx table"}{...}
{viewerjumpto "Description" "putdocx intro##description"}{...}
{viewerjumpto "Links to PDF documentation" "putdocx intro##linkspdf"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[RPT] putdocx intro} {hline 2}}Introduction to generating Office
Open XML (.docx) files{p_end}
{p2col:}({mansection RPT putdocxintro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
The {cmd:putdocx} suite of commands creates Office Open XML
({cmd:.docx}) documents that include text, formatted images, and tables of
Stata estimation results and summary statistics. The following commands are
used to create, format, add content to, and save {cmd:.docx} files that are
compatible with Microsoft Word 2007 and later:

{synoptset 22 tabbed}{...}
{p2coldent:{bf:Create, save, and append .docx files} (see {helpb putdocx begin:[RPT] putdocx begin})}{p_end}

{synopt :{cmd:putdocx begin}}Creates a {cmd:.docx} file for export{p_end}
{synopt :{cmd:putdocx describe}}Describes contents of the active {cmd:.docx} file{p_end}
{synopt :{cmd:putdocx save}}Saves and closes the {cmd:.docx} file{p_end}
{synopt :{cmd:putdocx clear}}Closes the {cmd:.docx} file without saving the changes{p_end}
{synopt :{cmd:putdocx append}}Appends the contents of multiple {cmd:.docx} files{p_end}


{p2coldent :{bf:Insert page breaks in a .docx file} (see {helpb putdocx pagebreak:[RPT] putdocx pagebreak})}{p_end}

{synopt :{cmd:putdocx pagebreak}}Adds a page break to the document{p_end}
{synopt :{cmd:putdocx sectionbreak}}Adds a new section to the document{p_end}


{p2coldent :{bf:Add paragraphs with text and images} (see {helpb putdocx paragraph:[RPT] putdocx paragraph})}{p_end}

{synopt :{cmd:putdocx paragraph}}Adds a new paragraph to the active document{p_end}
{synopt :{cmd:putdocx text}}Adds text to the active paragraph{p_end}
{synopt :{cmd:putdocx textblock}}Adds a block of text to the active paragraph or
to a new paragraph{p_end}
{synopt :{cmd:putdocx textfile}}Adds a block of preformatted text to a new
paragraph with a predefined style{p_end}
{synopt :{cmd:putdocx image}}Appends an image to the active paragraph{p_end}
{synopt :{cmd:putdocx pagenumber}}Adds page numbers to a paragraph in a header
or footer{p_end}


{p2coldent :{bf:Add tables to a .docx file} (see {helpb putdocx table:[RPT] putdocx table})}{p_end}

{synopt :{opt putdocx table}}Creates a new table in the {cmd:.docx} file containing estimation results, summary statistics, or data in memory{p_end}
{p2colreset}{...}


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putdocxintroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.
{p_end}
