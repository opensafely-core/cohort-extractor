{smcl}
{* *! version 1.1.9  12jun2019}{...}
{vieweralsosee "[M-5] _docx*()" "mansection M-5 _docx*()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] Pdf*()" "help mf pdf"}{...}
{vieweralsosee "[M-5] xl()" "help mf xl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] IO" "help m4 io"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putexcel" "help putexcel"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{viewerjumpto "Syntax" "mf__docx##syntax"}{...}
{viewerjumpto "Description" "mf__docx##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf__docx##linkspdf"}{...}
{viewerjumpto "Remarks" "mf__docx##remarks"}{...}
{viewerjumpto "Diagnostics" "mf__docx##diagnostics"}{...}
{viewerjumpto "Source code" "mf__docx##source"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-5] _docx*()} {hline 2}}Generate Office Open XML (.docx) file 
{p_end}
{p2col:}({mansection M-5 _docx*():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 4 2}
Syntax is presented under the following headings:

	{help mf__docx##syn_file:Create and save .docx file}
	{help mf__docx##syn_para:Add paragraph and text}
	{help mf__docx##syn_image:Add image file}
	{help mf__docx##syn_table:Add table}
	{help mf__docx##syn_table_edit:Edit table}
	{help mf__docx##syn_query:Query routines}


{marker syn_file}{...}
    {title:Create and save .docx file}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_file:{bf:_docx_new()}}

{marker dh}{...}
{p 4 4 2}
In the rest of the help file, {it:dh} is the value returned by
{cmd:_docx_new()}.

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_file:{bf:_docx_save(}{it:dh}{bf:,} {it:string scalar filename} [{bf:,} {it:real scalar replace}]{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_file:{bf:_docx_append(}{it:dh}{bf:,} {it:string scalar filename}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_file:{bf:_docx_close(}{it:dh}{bf:)}}

{p 8 25 1}
{it:void}{bind:        }
{help mf__docx##remarks_file:{bf:_docx_closeall()}}


{marker syn_para}{...}
    {title:Add paragraph and text}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_para:{bf:_docx_paragraph_new(}{it:dh}{bf:,} {it:string scalar s}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_para:{bf:_docx_paragraph_new_styledtext(}{it:dh}{bf:,} {it:string scalar s}{bf:,} {it:style}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_para:{bf:_docx_paragraph_add_text(}{it:dh}{bf:,} {it:string scalar s} [{bf:,} {it:real scalar nospace}]{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_para:{bf:_docx_text_add_text(}{it:dh}{bf:,} {it:string scalar s} [{bf:,} {it:real scalar nospace}]{bf:)}}

{marker syn_image}{...}
    {title:Add image file}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_image:{bf:_docx_image_add(}{it:dh}{bf:,} {it:string scalar filepath} [{bf:,} {it:real scalar link}{bf:,} {it:cx}{bf:,} {it:cy}]{bf:)}}


{marker syn_table}{...}
    {title:Add table}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table:{bf:_docx_new_table(}{it:dh}{bf:,} {it:real scalar row}{bf:,} {it:col} [{bf:,} {it:noadd}]{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table:{bf:_docx_add_matrix(}{it:dh}{bf:,} {it:string scalar name}{bf:,} {it:fmt}{bf:,} {it:real scalar colnames}{bf:,} {it:rownames} [{bf:,} {it:noadd}]{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table:{bf:_docx_add_mata(}{it:dh}{bf:,} {it:real matrix m}{bf:,} {it:string scalar fmt} [{bf:,} {it:real scalar noadd}]{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table:{bf:_docx_add_data(}{it:dh}{bf:,} {it:real scalar varnames}{bf:,} {it:obsno}{bf:,} {it:real matrix i}{bf:,} {it:rowvector j} [{bf:,} {it:real scalar noadd}{bf:,} {it:scalar selectvar}]{bf:)}}

{marker tid}{...}
{p 4 4 2}
{cmd:_docx_new_table()}, {cmd:_docx_add_matrix()}, {cmd:_docx_add_mata()}, and
{cmd:_docx_add_data()} return an integer ID {it:tid} of the new table for
future use.  In the rest of the help file, {it:tid} is used to denote the
integer ID of the table returned by {cmd:_docx_new_table()},
{cmd:_docx_add_matrix()}, {cmd:_docx_add_mata()}, or {cmd:_docx_add_data()}. 


{marker syn_table_edit}{...}
    {title:Edit table}

{p 4 4 2}
After a table is successfully created, that table identified by {it:tid} can
be edited using the following functions:

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_table_add_row(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:,} {it:count}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_table_del_row(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_table_add_cell(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:,} {it:j} [{bf:,} {it:string scalar s}]{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_table_del_cell(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:,} {it:j}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_cell_set_colspan(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:,} {it:j}{bf:,} {it:count}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_cell_set_rowspan(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:,} {it:j}{bf:,} {it:count}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_cell_set_span(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:,} {it:j}{bf:,} {it:rowcount}{bf:,} {it:colcount}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_table_mod_cell(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:,} {it:j}{bf:,} {it:string scalar s} [{bf:,} {it: real scalar append}]{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_table_mod_cell_table(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:,} {it:j}{bf:,} {it:append}{bf:,} {it:src_tid}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_table_edit:{bf:_docx_table_mod_cell_image(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:,} {it:j}{bf:,} {it:string scalar filepath} [{bf:,} {it:real scalar link}{bf:,}  {it:append}{bf:,} {it:cx}{bf:,} {it:cy}]{bf:)}}


{marker syn_query}{...}
    {title:Query routines}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_query:{bf:_docx_query(}{it:real matrix doc_ids}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_query:{bf:_docx_query_table(}{it:dh}{bf:,} {it:tid}{bf:)}}

{p 8 25 1}
{it:real scalar}{bind: }
{help mf__docx##remarks_query:{bf:_docx_table_query_row(}{it:dh}{bf:,} {it:tid}{bf:,} {it:real scalar i}{bf:)}}


{marker description}{...}
{title:Description}

{pstd}
The syntax diagrams describe a set of Mata functions to generate Office Open
XML ({cmd:.docx}) files compatible with Microsoft Word 2007 and later.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 _docx*()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
The following sections describe the purpose, input parameters, and return
codes of the Mata functions. 

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf__docx##detailed_desc:Detailed description}
	{help mf__docx##remarks_error:Error codes}
	{help mf__docx##remarks_functions:Functions}
  	    {help mf__docx##remarks_file:Create and save .docx file}
	    {help mf__docx##remarks_para:Add paragraph and text}
	    {help mf__docx##remarks_image:Add image}
	    {help mf__docx##remarks_table:Add table}
	    {help mf__docx##remarks_table_edit:Edit table}
	    {help mf__docx##remarks_query:Query routines}
	{help mf__docx##remarks_save:Save document to disk file}
	{help mf__docx##remarks_cur:Current paragraph and text}
	{help mf__docx##remarks_img:Supported image types}
	{help mf__docx##remarks_link:Linked and embedded images}
	{help mf__docx##remarks_style:Styles}
	{help mf__docx##remarks_per:Performance}
	{help mf__docx##examples:Examples}
	    {help mf__docx##example_open:Create a .docx document in memory}
	    {help mf__docx##example_para:Add paragraphs and text}
	    {help mf__docx##example_data:Display data}
	    {help mf__docx##example_table:Display regression results}
	    {help mf__docx##example_image:Add an image}
	    {help mf__docx##example_nest_table:Display nested table}
	    {help mf__docx##example_table_image:Add images to table cells}
	    {help mf__docx##example_save:Save the .docx document in memory to a disk file}


{marker detailed_desc}{...}
{title:Detailed description}

{p 4 4 2}
{cmd:_docx_new()} creates an empty {cmd:.docx} document in memory. 

{p 4 4 2}
{cmd:_docx_save(}{it:dh}{cmd:,} {it:filename} [{cmd:,} {it:replace}]{cmd:)}
saves the document identified by ID {it:dh} to file {it:filename} on disk. The
file {it:filename} is overwritten if {it:replace} is specified and is not
{cmd:0}.

{p 4 4 2}
{cmd:_docx_append(}{it:dh}{cmd:,} {it:filename}{cmd:)}
appends the document identified by ID {it:dh} to file {it:filename} on disk.

{p 4 4 2}
{cmd:_docx_close(}{it:dh}{cmd:)} closes the document identified by ID {it:dh}
in memory.

{p 4 4 2}
{cmd:_docx_closeall()} closes all {cmd:.docx} documents in memory.

{p 4 4 2}
{cmd:_docx_paragraph_new(}{it:dh}{cmd:,} {it:s}{cmd:)} creates a new paragraph
with the content specified in {it:string scalar s}.

{p 4 4 2}
{cmd:_docx_paragraph_new_styledtext(}{it:dh}{cmd:,} {it:s}{cmd:,}
{it:style}{cmd:)} creates a new paragraph with the content specified in
{it:string scalar s}.  The text has the style specified in {it:style}.  The
styles can be {cmd:"Title"}, {cmd:"Heading1"}, {cmd:"Heading2"}, etc. See
{browse "https://www.stata.com/docx_styles.html"} for more discussion on styles.   

{p 4 4 2}
{cmd:_docx_paragraph_add_text(}{it:dh}{cmd:,} {it:s} [{cmd:,}
{it:nospace}]{cmd:)} adds text {it:s} to the current paragraph.  If
{it:nospace} is specified and is not {cmd:0}, the leading spaces in {it:s} are
trimmed; otherwise, the leading spaces in {it:s} are preserved.

{p 4 4 2}
{cmd:_docx_text_add_text(}{it:dh}{cmd:,} {it:s} [{cmd:,}
{it:nospace}]{cmd:)} adds text {it:s} to the current text.  If
{it:nospace} is specified and is not {cmd:0}, the leading spaces in {it:s} are
trimmed; otherwise, the leading spaces in {it:s} are preserved.

{p 4 4 2}
{cmd:_docx_image_add(}{it:dh}{cmd:,} {it:path} [{cmd:,} {it:link}{cmd:,}
{it:cx}{cmd:,} {it:cy}]{cmd:)} adds an image file to the document. The
{it:filepath} is the path to the image file.  

{p 4 4 2}
{cmd:_docx_new_table(}{it:dh}{cmd:,} {it:row}{cmd:,} {it:col} [{cmd:,}
{it:noadd}]{cmd:)} creates an empty table of size {it:row} by {it:col}.

{p 4 4 2}
{cmd:_docx_add_matrix(}{it:dh}{cmd:,} {it:name}{cmd:,} {it:fmt}{cmd:,}
{it:colnames}{cmd:,} {it:rownames} [{cmd:,} {it:noadd}]{cmd:)} adds a 
{help matrix:matrix} in a table to the document and returns the table ID
{it:tid} for future use.

{p 4 4 2}
{cmd:_docx_add_mata(}{it:dh}{cmd:,} {it:m}{cmd:,} {it:fmt} [{cmd:,}
{it:noadd}]{cmd:)} adds a Mata matrix in a table to the document and returns the
table ID {it:tid} for future use.

{p 4 4 2}
{cmd:_docx_add_data(}{it:dh}{cmd:,} {it:varnames}{cmd:,} {it:obsno}{cmd:,}
{it:i}{cmd:,} {it:j} [{cmd:,} {it:noadd}{cmd:,} {it:selectvar}]{cmd:)} adds the
current Stata dataset in memory in a table to the document and returns the
table ID {it:tid} for future use. 

{p 4 4 2}
{cmd:_docx_table_add_row(}{it:dh}{cmd:,} {it:tid}{cmd:,} {it:i}{cmd:,}
{it:count}{cmd:)} adds a row with {it:count} columns to the table ID
{it:tid} right after the {it:i}th row.

{p 4 4 2}
{cmd:_docx_table_del_row(}{it:dh}{cmd:,} {it:tid}{cmd:,} {it:i}{cmd:)} deletes
the {it:i}th row from the table. 

{p 4 4 2}
{cmd:_docx_table_add_cell(}{it:dh}{cmd:,} {it:tid}{cmd:,} {it:i}{cmd:,} {it:j}
[{cmd:,} {it:s}]{cmd:)} adds a cell to the table ID {it:tid} right after the
{it:j}th column on the {it:i}th row.

{p 4 4 2}
{cmd:_docx_table_del_cell(}{it:dh}{cmd:,} {it:tid}{cmd:,} {it:i}{cmd:,}
{it:j}{cmd:)} deletes the cell of the table ID {it:tid} on the {it:i}th row,
{it:j}th column.

{p 4 4 2}
{cmd:_docx_cell_set_colspan(}{it:dh}{cmd:,} {it:tid}{cmd:,}
{it:i}{cmd:,} {it:j}{cmd:,} {it:count}{cmd:)} sets the
cell of the {it:j}th column on the {it:i}th row to span horizontally
{it:count} cells to the right.

{p 4 4 2}
{cmd:_docx_cell_set_rowspan(}{it:dh}{cmd:,} {it:tid}{cmd:,}
{it:i}{cmd:,} {it:j}{cmd:,} {it:count}{cmd:)}
sets the cell of the {it:j}th column on the {it:i}th row to span vertically
{it:count} cells downward.

{p 4 4 2}
{cmd:_docx_cell_set_span(}{it:dh}{cmd:,} {it:tid}{cmd:,}
{it:i}{cmd:,} {it:j}{cmd:,} {it:rowcount}{cmd:,} {it:colcount}{cmd:)} sets the
cell of the {it:j}th column on the {it:i}th row to span vertically
{it:rowcount} cells downward and span horizontally {it:colcount} cells to
the right.

{p 4 4 2}
{cmd:_docx_table_mod_cell(}{it:dh}{cmd:,} {it:tid}{cmd:,} {it:i}{cmd:,}
{it:j}{cmd:,} {it:s} [{cmd:,} {it:append}]{cmd:)} modifies the cell on the
{it:i}th row and {it:j}th column with text {it:s}.

{p 4 4 2}
{cmd:_docx_table_mod_cell_table(}{it:dh}{cmd:,} {it:tid}{cmd:,} {it:i}{cmd:,}
{it:j}{cmd:,} {it:append}{cmd:,} {it:src_tid}{cmd:)} modifies the cell on the
{it:i}th row and {it:j}th column with a table identified by ID {it:src_tid}.

{p 4 4 2}
{cmd:_docx_table_mod_cell_image(}{it:dh}{cmd:,} {it:tid}{cmd:,} {it:i}{cmd:,}
{it:j}{cmd:,} {it:filepath} [{cmd:,} {it:link}{cmd:,} {it:append}{cmd:,} 
{it:cx}{cmd:,} {it:cy}]{cmd:)} modifies the cell on the {it:i}th row and
{it:j}th column with an image.  The {it:filepath} is the path to the image
file.

{p 4 4 2}
{cmd:_docx_query(}{it:doc_ids}{cmd:)} returns the number of all documents in
memory. It stores document IDs in {it:doc_ids} as a row vector.

{p 4 4 2}
{cmd:_docx_query_table(}{it:dh}{cmd:,} {it:tid}{cmd:)} returns the total
number of rows of table ID {it:tid} in document ID {it:dh}.

{p 4 4 2}
{cmd:_docx_table_query_row(}{it:dh}{cmd:,} {it:tid}{cmd:,} {it:i}{cmd:)}
returns the number of columns of the {it:i}th row of table ID {it:tid} in document
ID {it:dh}. 



{marker remarks_error}{...}
    {title:Error codes}

{p 4 4 2}
Functions can only abort if one of the input parameters does not meet the
specification; for example, a string scalar is used when a real scalar is
required.  Functions return a negative error code when there is an error.  The
codes specific to {cmd:_docx_*()} functions are the following:

	 Code    Meaning
	{hline 67}
	-16510    an error occurred; document is not changed
	-16511    an error occurred; document is changed
	-16512    an error occurred 
	-16513    document ID out of range
	-16514    document ID invalid
	-16515    table ID out of range
	-16516    table ID invalid
	-16517    row number out of range
	-16518    column number out of range
	-16519    no current paragraph 
	-16520    invalid property value
	-16521    too many open documents 
	-16522    last remaining row of the table cannot be deleted
	-16523    last remaining column of the row cannot be deleted
	-16524    invalid image file format or image file too big
	-16525    function is not supported on this platform
	-16526    too many columns
	-16527    no current text 
	{hline 67}

{p 4 4 2}
Any function that takes a document ID {it:{help mf__docx##dh:dh}} as an
argument may return error codes -16513 or -16514.

{p 4 4 2}
Any function that takes a table ID {it:{help mf__docx##tid:tid}} as an
argument may return error codes -16515 or -16516.

{p 4 4 2}
Any function that takes a row number as an argument may return error code
-16517.  Any function that takes a column number as an argument may return
error code -16518.

{p 4 4 2}
Error code -16511 means an error occurred during a batch of changes being
applied to the document.  For example, an error may occur when adding a matrix
to the document.  When this happens, the document is changed, but not all the
entries of the matrix are added.


{marker remarks_functions}{...}
    {title:Functions}

{marker remarks_file}{...}
    {title:Create and save .docx file}

{phang}
{cmd:_docx_new()}
creates an empty {cmd:.docx} document in memory.  The function returns an
integer ID {it:{help mf__docx##dh:dh}} that identifies the document for future
use.  The function returns a negative error code if an error occurs.  The
function returns -16521 if there are too many open documents.  If this happens,
you may use {cmd:_docx_close()} or {cmd:_docx_closeall()} to close one or all
documents in memory to fix the problem.  
 
{phang}
{cmd:_docx_save(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:string scalar filename}
[{cmd:,} {it:real scalar replace}]{cmd:)}
saves the document identified by ID {it:dh} to file {it:filename} on
disk.  The file {it:filename} is overwritten if {it:replace} is specified and is
not {cmd:0}.

{p 4 4 2}
Besides the error codes -16513 and -16514 for invalid or out of range document ID
{it:dh}, the function may return the following error codes if {it:replace} is
not specified or if specified as {cmd:0}: 

	 Code    Meaning
	{hline 67}
	-602     file already exists 
	-3602    invalid filename
	{hline 67}

{p 4 4 2}
The function may return the following error codes if {it:replace} is specified
and is not {cmd:0}: 

	 Code    Meaning
	{hline 67}
	-3621    attempt to write read-only file
	-3602    invalid filename
	{hline 67}
	
{phang}
{cmd:_docx_append(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:string scalar filename}{cmd:)}
appends the document identified by ID {it:dh} to file {it:filename} on disk.

{p 4 4 2}
Besides the error codes -16513 and -16514 for invalid or out of range document ID
{it:dh}, the function may return the following error codes:

	 Code    Meaning
	{hline 67}
	-601	 file cannot be found or read
	-3621    attempt to write read-only file
	-3602    invalid filename
	{hline 67}

{phang}
{cmd:_docx_close(}{it:{help mf__docx##dh:dh}}{cmd:)} 
closes the document identified by ID {it:dh} in memory. The function returns
error code -16513 if the ID {it:dh} is out of range.  

{phang}
{cmd:_docx_closeall()} 
closes all {cmd:.docx} documents in memory. 


{marker remarks_para}{...}
    {title:Add paragraph and text}

{phang}
{cmd:_docx_paragraph_new(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:string scalar s}{cmd:)}
creates a new paragraph with the content specified in {it:string scalar s}.
The function returns {cmd:0} if it is successful or returns a negative error
code if it fails.

{phang}
{cmd:_docx_paragraph_new_styledtext(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:string scalar s}{cmd:,} {it:style}{cmd:)}
creates a new paragraph with content {it:string scalar s}.  The text has the
style specified in {it:style}.  The styles can be {cmd:"Title"},
{cmd:"Heading1"}, and {cmd:"Heading2"}, etc.  See
{browse "https://www.stata.com/docx_styles.html"} for more discussion on
styles.   

{p 4 4 2}
After {cmd:_docx_paragraph_new()} and {cmd:_docx_paragraph_new_styledtext()},
the newly created paragraph becomes the current paragraph.

{phang}
{cmd:_docx_paragraph_add_text(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:string scalar s} [{cmd:,} {it:real scalar nospace}]{cmd:)}
adds text {it:s} to the current paragraph.  If {it:nospace} is specified and
is not {cmd:0}, the leading spaces in {it:s} are trimmed; otherwise, the
leading spaces in {it:s} are preserved.  The function returns {cmd:0} if it is
successful and returns a negative error code if it fails.  It may return -16519
if there is no current paragraph.  This case usually happens if this function
is called before a {cmd:_docx_paragraph_new()} or
{cmd:_docx_paragraph_new_styledtext()} function. 

{phang}
{cmd:_docx_text_add_text(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:string scalar s} [{cmd:,} {it:real scalar nospace}]{cmd:)}
adds text {it:s} to the current text.  If {it:nospace} is specified and
is not {cmd:0}, the leading spaces in {it:s} are trimmed; otherwise, the
leading spaces in {it:s} are preserved.  The function returns {cmd:0} if it is
successful and returns a negative error code if it fails.  It may return -16527
if there is no current text.  This case usually happens if this function
is called before a {cmd:_docx_paragraph_add_text()} function.

{p 4 4 2}
This is a convenience routine so the newly added text can have the same styles
as the current text.


{marker remarks_image}{...}
    {title:Add image}

{phang}
{cmd:_docx_image_add(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:string scalar filepath} [{cmd:,} {it:real scalar link}{cmd:,} {it:cx}{cmd:,} {it:cy}]{cmd:)}
adds an image file to the document.  The {it:filepath} is the path to the
image file.  It can be either the full path or the relative path from the
current working directory.  If {it:link} is specified and is not {cmd:0}, the
image file is linked; otherwise, the image file is embedded.

{p 4 4 2}
The width of the image is controlled by {it:cx}.  The height of the image is
controlled by {it:cy}.  {it:cx} and {it:cy} are measured in twips.  A twip is
1/20 of a point, 1/1440 of an inch, or approximately 1/567 of a centimeter.

{p 4 4 2}
If {it:cx} is not specified or is less than or equal to {cmd:0}, the default
size, which is determined by the image information and the page width of the
document, is used.  If the {it:cx} is larger than the page width of the
document, the page width is used.  Otherwise,  the width is {it:cx} in twips. 

{p 4 4 2}
If {it:cy} is not specified or is less than or equal to {cmd:0}, the height of
the image is determined by the width and the aspect ratio of the image;
otherwise, the added image has height {it:cy} in twips.

{p 4 4 2}
The function returns {cmd:0} if it is successful and returns a negative error
code if it fails.  The function may return error code -601 if the image file
specified by {it:filepath} cannot be found or read. The function may return 
error code -16524 if the type of the image file specified by {it:filepath} is
not supported or the file is too big.   

{p 4 4 2}
The function is not supported in Stata for Mac running on OS X 10.9
(Mavericks) or console Stata for Mac.  The function returns error code -16525
if specified on the above platforms.


{marker remarks_table}{...}
    {title:Add table}

{phang}
{cmd:_docx_new_table(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:real scalar row}{cmd:,} {it:col} [{cmd:,} {it:noadd}]{cmd:)}
creates an empty table of size {it:row} by {it:col}.  If it is successful, the
function returns the table ID {it:{help mf__docx##tid:tid}}, which is an
integer greater than or equal to {cmd:0} for future use.  The function returns
a negative error code if it fails.  If {it:noadd} is specified and is not
{cmd:0}, the table is created but not added to the document.  This is useful
if the table is intended to be added to a cell of another table.

{p 4 4 2}
Microsoft Word 2007/2010 allows a maximum of 63 columns in a table. The function
returns error code -16526 if {it:col} is greater than 63.

{phang}
{cmd:_docx_add_matrix(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:string scalar name}{cmd:,} {it:fmt}{cmd:,} {it:real scalar colnames}{cmd:,} {it:rownames} [{cmd:,} {it:noadd}]{cmd:)}
adds a {help matrix:matrix} in a table to the document and returns the table
ID {it:{help mf__docx##tid:tid}} for future use.  The elements of the matrix
are formatted using {it:{help format:fmt}}.  If {it:fmt} is not a valid Stata
numeric format, {cmd:%12.0g} is used.  If {it:colnames} is not {cmd:0}, the
first row of the table is filled with {help matrix_rownames:matrix colnames}.
If {it:rownames} is not {cmd:0}, the first column of the table is filled with
{help matrix_rownames:matrix rownames}.  If {it:noadd} is specified and is not
{cmd:0}, the table is created but not added to the document.  This is useful
if the table is intended to be added to a cell of another table.

{p 4 4 2}
The function returns a negative error code if it fails.  The function may
return -111 if the matrix specified by {it:name} cannot be found.  The
function may return error code -16511 if the table has been added and an error
occurred while filling the table.  In this case, the document is changed but
the operation is not entirely successful. The function returns error code 
-16526 if the number of columns of the matrix is greater than 63.

{phang}
{cmd:_docx_add_mata(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:real matrix m}{cmd:,} {it:string scalar fmt} [{cmd:,} {it:real scalar noadd}]{cmd:)}
adds a Mata matrix in a table to the document and returns the table ID
{it:{help mf__docx##tid:tid}} for future use.  The elements of the Mata matrix
are formatted using {it:{help format:fmt}}.  If {it:fmt} is not
a valid Stata numeric format, {cmd:%12.0g} is used.  If {it:noadd} is
specified and is not {cmd:0}, the table is created but not added to the
document.  This is useful if the table is intended to be added to a cell of
another table.

{p 4 4 2}
The function returns a negative error code if it fails.  The function may
return error code -16511 if the table has been added and an error occurred
while filling the table.  In this case, the document is changed, but the
operation is not entirely successful. The function returns error code 
-16526 if the number of columns of the matrix is greater than 63.

{phang}
{cmd:_docx_add_data(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:real scalar varnames}{cmd:,} {it:obsno}{cmd:,} {it:real matrix i}{cmd:,} {it:rowvector j} [{cmd:,} {it:real scalar noadd}{cmd:,} {it:scalar selectvar}]{cmd:)}
adds the current Stata dataset in memory in a table to the document and
returns the table ID {it:{help mf__docx##tid:tid}} for future use.  If there
is a value label attached to the variable, the variable is displayed according
to the value label.  Otherwise, the variable is displayed according to its
format.  {it:i}, {it:j}, and {it:selectvar} are specified in the same way as
with {helpb mf_st_data:st_data()}. Factor variables and
time-series-operated variables are not allowed.  If {it:varnames} is not
{cmd:0}, the first row of the table is filled with variable names.  If
{it:obsno} is not {cmd:0}, the first column of the table is filled with
observation numbers.  If {it:noadd} is specified and is not {cmd:0}, the table
is created but not added to the document.  This is useful if the table is
intended to be added to a cell of another table.

{p 4 4 2}
The function returns a negative error code if it fails.  The function may
return error code -16511 if the table has been added and an error occurred
while filling the table.  In this case, the document is changed, but the
operation is not entirely successful.  The function outputs  missing {cmd:.}
or empty string {cmd:""} if {it:i} or {it:j} is out of range; it does not
abort with an error.  The function returns error code -16526 if the number of
variables is greater than 63.


{marker remarks_table_edit}{...}
    {title:Edit table}

{phang}
{cmd:_docx_table_add_row(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:,} {it:count}{cmd:)}
adds a row with {it:count} columns to the table ID {it:tid} right after
the {it:i}th row.  The range of {it:i} is from 0 to {it:r}, where {it:r} is the
number of rows of the table.  Specifying {it:i} as {cmd:0} adds a row before
the first row, which is equivalent to adding a new first row; specifying
{it:i} as {it:r} adds a row right after the last row, which is equivalent
to adding a new last row.  The function returns error code -16517 if {it:i} is
out of range.

{phang}
{cmd:_docx_table_del_row(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:)}
deletes the {it:i}th row from the table.  The range of {it:i} is from 1 to
{it:r}, where {it:r} is the number of rows of the table.  The function returns
error code -16517 if {it:i} is out of range.  If the table has only one row,
the function returns error code -16522, and the row is not deleted.  This is to
ensure the document can be properly displayed in Microsoft Word.

{phang}
{cmd:_docx_table_add_cell(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:,} {it:j}[{cmd:,} {it:string scalar s}]{cmd:)}
adds a cell to the table ID {it:tid} right after the {it:j}th column on the
{it:i}th row.  The range of {it:i} is from 1 to {it:r}, where {it:r} is the
number of rows of the table.  The range of {it:j} is from 0 to {it:c}, where
{it:c} is the number of columns of the {it:i}th row.  Specifying {it:j} as
{cmd:0} adds a cell to the first column on the row; specifying {it:j} as
{it:c} adds a cell to the last column on the row.  The function returns error
code -16517 if {it:i} is out of range.  The function returns error code -16518
if {it:j} is out of range.

{phang}
{cmd:_docx_table_del_cell(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:,} {it:j}{cmd:)}
deletes a cell from the table {it:tid} on the {it:i}th row, {it:j}th column.
The range of {it:i} is from 1 to {it:r}, where {it:r} is the number of rows of
the table.  The range of {it:j} is from 1 to {it:c}, where {it:c} is the number
of columns of the {it:i}th row.  The function returns error code -16517 if
{it:i} is out of range.  The function returns error code -16518 if {it:j} is
out of range.  If the row has only one column, the function returns error code
-16523, and the column is not deleted.  This is to ensure the document can be
properly displayed in Microsoft Word.

{phang}
{cmd:_docx_cell_set_colspan(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:,} {it:j}{cmd:,} {it:count}{cmd:)}
sets the cell of the {it:j}th column on the {it:i}th row to span horizontally
{it:count} cells to the right.  This is equivalent to merging
{it:count}-1 cells right of the cell on the same row into that cell.  If
{it:j+count-1} is larger than {it:c}, where {it:c} is the total number of
columns of the {it:i}th row, the span stops at the last column.
The function returns error code -16517 if {it:i} is out of range.  The
function returns error code -16518 if {it:j} is out of range or if {it:count}
is less than 1.

{phang}
{cmd:_docx_cell_set_rowspan(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:,} {it:j}{cmd:,} {it:count}{cmd:)}
sets the cell of the {it:j}th column on the {it:i}th row to span vertically
{it:count} cells downward.  This is equivalent to merging {it:count}-1
cells below the cell on the same column into it.  If {it:i+count-1} is
larger than {it:r} where {it:r} is the total number of rows of the table, the
span stops at the last row.  The function returns error code -16517 if {it:i}
is out of range or if {it:count} is less than 1.  The function returns error
code -16518 if {it:j} is out of range.

{phang}
{cmd:_docx_cell_set_span(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:,} {it:j}{cmd:,} {it:rowcount}{cmd:,} {it:colcount}{cmd:)}
sets the cell of the {it:j}th column on the {it:i}th row to span vertically
{it:rowcount} cells downward and span horizontally {it:colcount} cells to
the right. The function returns error code -16517 if {it:i}
is out of range.  The function returns error code -16518 if {it:j} is out
of range.

{phang}
{cmd:_docx_table_mod_cell(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:,} {it:j}{cmd:,} {it:string scalar s} [{cmd:,} {it: real scalar append}]{cmd:)}
modifies the cell on the {it:i}th row and {it:j}th column with text {it:s}.  If
{it:append} is specified and is not {cmd:0}, text {it:s} is appended to the current content of
the cell; otherwise, text {it:s} replaces the current content of the cell.
The function returns {cmd:0} if it is successful and returns a negative error
code if it fails.

{phang}
{cmd:_docx_table_mod_cell_table(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:,} {it:j}{cmd:,} {it:append}{cmd:,} {it:src_tid}{cmd:)}
modifies the cell on the {it:i}th row and {it:j}th column with a table
identified by ID {it:src_tid}.  If {it:append} is not {cmd:0}, table
{it:src_tid} is appended to the current content of the cell; otherwise, table
{it:src_tid} replaces the current content of the cell.  The function returns
error code -16515 or -16516 if {it:src_id} is out of range or invalid.
 
{phang} {cmd:_docx_table_mod_cell_image(}{it:{help mf__docx##dh:dh}}{cmd:,}
{it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:,} {it:j}{cmd:,}
{it:string scalar filepath} [{cmd:,} {it:real scalar link}{cmd:,}
{it:append}{cmd:,} {it:cx}{cmd:,} {it:cy}]{cmd:)} modifies the cell on the {it:i}th
row and {it:j}th column with an image.  The {it:filepath} is the path to the
image file.  It can be either the full path or the relative path from the
current working directory.  If link is specified and is not {cmd:0}, the image
file is linked; otherwise, the image file is embedded.

{p 4 4 2}
{it:cx} and {it:cy} specify the width and the height of the image.  {it:cx}
and {it:cy} are measured in twips.  A twip is 1/20 of a point, is 1/1440 of an
inch, or approximately 1/567 of a centimeter.

{p 4 4 2}
If {it:cx} is not specified or is less than or equal to {cmd:0}, the width of
cell {it:(i,j)} is used; otherwise, the image has width {it:cx} in twips.

{p 4 4 2}
If {it:cy} is not specified or is less than or equal to {cmd:0}, the height of
the image is determined by the width and the aspect ratio of the image;
otherwise, the image has height {it:cy} in twips.

{p 4 4 2}  
If {it:append} is not {cmd:0}, the image is appended to the current content of
the cell; otherwise, the image replaces the current content of the cell. 

{p 4 4 2}
The function returns error code -601 if the image file specified by
{it:filepath} cannot be found or read. The function may return error code
-16524 if the type of the image file specified by {it:filepath} is not supported or
the file is too big.   

{p 4 4 2}
The function is not supported on Stata for Mac running on OS X 10.9
(Mavericks) or console Stata for Mac.  The function returns error code -16525
if specified on the above platforms.


{marker remarks_query}{...}
    {title:Query routines}

{phang}
{cmd:_docx_query(}{it:real matrix doc_ids}{cmd:)}
The function returns the number of all documents in memory.  It stores
document IDs in {it:doc_ids} as a row vector.  If there is no document in
memory, the function returns {cmd:0} and {it:doc_ids} is not changed.  

{phang}
{cmd:_docx_query_table(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:)}
returns the total number of rows of table ID {it:tid} in document ID {it:dh}.
The function returns a negative error code if either {it:dh} or {it:tid} is
invalid.

{phang}
{cmd:_docx_table_query_row(}{it:{help mf__docx##dh:dh}}{cmd:,} {it:{help mf__docx##tid:tid}}{cmd:,} {it:real scalar i}{cmd:)}
returns the number of columns of the {it:i}th row of table ID {it:tid} in
document ID {it:dh}.  The function returns a negative error code if either
{it:dh} or {it:tid} is invalid. The function returns a negative error code if
{it:i} is out of range.


{marker remarks_save}{...}
    {title:Save document to disk file}

{p 4 4 2}
A document in memory can be saved and resaved. It stays in memory and can be
modified as long as the document is not closed.  We do not support loading and
modifying existing Word documents from disk into memory at this time.


{marker remarks_cur}{...}
    {title:Current paragraph and text}

{p 4 4 2}
When a paragraph is added, it becomes the current paragraph. The subsequent
{cmd:_docx_paragraph_add_text()} call will add text to the current paragraph.
When {cmd:_docx_paragraph_add_text()} is called, the newly added text becomes
the current text.  Functions changing paragraph styles are applied to the
current paragraph.  Functions changing text styles are applied to the current
text. 

{p 4 4 2}
When the current paragraph and text change, there is no way to go back.  We do
not have functions to move around the document.  The only exception to this is
the table.  The table is identified by its ID and can be accessed at any time.

{p 4 4 2}
A new paragraph is always created when you add a table or an image. The table
is added to the new paragraph, and this paragraph becomes the current
paragraph. 


{marker remarks_img}{...}
    {title:Supported image types}

{p 4 4 2}
Images of types {cmd:.emf}, {cmd:.png}, and {cmd:.tiff} are supported. Images
of types {cmd:.wmf}, {cmd:.pdf}, {cmd:.ps}, and {cmd:.eps} are not supported. 


{marker remarks_link}{...}
    {title:Linked and embedded images}

{p 4 4 2}
The image is linked into the document if the {it:link} parameter is specified
and is not 0 in {cmd:_docx_image_add()} and {cmd:_docx_table_mod_cell_image()};
otherwise, the image is embedded.

{p 4 4 2}
If the image is embedded, it becomes a part of the document and has no further
relationship with the original image on the disk.  If the image is linked,
only a link to the image file is inserted into the document.  The image file
must be present so that the Word document can display the image.  

{p 4 4 2}
If the Word document is moved to a different machine, all embedded images will
display fine; all linked images will require the image files to be moved to
the same directory of the Word document on the new machine to be displayed
correctly.

{p 4 4 2}
If the original image file on the disk is updated, the linked image in the
Word document will reflect the change; the embedded image will not.


{marker remarks_style}{...}
    {title:Styles}

{p 4 4 2}
A wide range of styles -- for example, font, color, text size, table width,
justification -- is supported.  For a list of functions related to styles,
see {browse "https://www.stata.com/docx_styles.html"}.


{marker remarks_per}{...}
    {title:Performance}

{p 4 4 2}
Creating a new document in a new session of Stata can cause some noticeable
delay, usually several seconds.  


{marker examples}{...}
    {title:Examples}

{marker example_open}{...}
    {title:Create a .docx document in memory}

{p 4 4 2}
In the following example, we create a Microsoft Word document using Stata
data, results from a Stata estimation command, and Stata graphs.

{p 4 4 2}
We create a new {cmd:.docx} document in memory by calling {cmd:_docx_new()}.

	{cmd}mata:
	dh = _docx_new()
	end{txt}

{p 4 4 2}
It is good practice to check if {it:{help mf__docx##dh:dh}} is negative, which
means the document has not been successfully created.   


{marker example_para}{...}
    {title:Add paragraphs and text}

{p 4 4 2}
After the document is successfully created, we can add paragraphs and text to
it.  We start by adding a title, a subtitle, and a heading. 

	{cmd}mata:
	_docx_paragraph_new_styledtext(dh, "Sample Document", "Title")
	_docx_paragraph_new_styledtext(dh, "by Stata", "Subtitle")
	_docx_paragraph_new_styledtext(dh, "Add", "Heading1")
	end{txt}

{p 4 4 2}
The document ID {it:dh} is returned from previously calling {cmd:_docx_new()}.

{p 4 4 2}
Each function returns a real scalar.  A negative return code indicates the
function failed with error.  If you would like to suppress the display of the
return code, simply put {cmd:(void)} in front of the function.

{p 4 4 2}
Now we add a regular paragraph and some text to the document.

	{cmd}mata:
	_docx_paragraph_new(dh, "Use auto dataset. ")
	_docx_paragraph_add_text(dh, "Use -regress- with ")
	_docx_paragraph_add_text(dh, "variables -mpg price foreign-.")
	end{txt}

{p 4 4 2}
The function {cmd:_docx_paragraph_add_text()} can be used to break long
sentences into pieces. 


{marker example_data}{...}
    {title:Display data}

{p 4 4 2}
We use {cmd:auto.dta} in the rest of the examples. 

	{cmd:. sysuse auto}

{p 4 4 2}
We may use {cmd:_docx_add_data()} to display observations 1-10 of variables
{cmd:mpg}, {cmd:price}, and {cmd:foreign} to the document as a table. 

	{cmd}mata:
	_docx_add_data(dh, 1, 1, (1,10), ("mpg", "price", "foreign"))
	end{txt}

{p 4 4 2}
The table's first row contains variable names, and the first column contains
observation numbers. 


{marker example_table}{...}
    {title:Display regression results}

{p 4 4 2}
After running a regression, 

	{cmd:. regress mpg price foreign}

{p 4 4 2}
the output contains the following in the header:

	{txt}Number of obs ={res}      74
	{txt}F(  2,    71) ={res}   23.01
	{txt}Prob > F      = {res} 0.0000
	{txt}R-squared     = {res} 0.3932
	{txt}Adj R-squared = {res} 0.3761
	{txt}Root MSE      = {res} 4.5696{txt}

{p 4 4 2}
The regression table looks like this: 

{txt}{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 1}         mpg{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      t{col 46}   P>|t|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 7}price {c |}{col 14}{res}{space 2} -.000959{col 26}{space 2} .0001815{col 37}{space 1}   -5.28{col 46}{space 3}0.000{col 54}{space 4} -.001321{col 67}{space 3} -.000597
{txt}{space 5}foreign {c |}{col 14}{res}{space 2} 5.245271{col 26}{space 2} 1.163592{col 37}{space 1}    4.51{col 46}{space 3}0.000{col 54}{space 4} 2.925135{col 67}{space 3} 7.565407
{txt}{space 7}_cons {c |}{col 14}{res}{space 2} 25.65058{col 26}{space 2} 1.271581{col 37}{space 1}   20.17{col 46}{space 3}0.000{col 54}{space 4} 23.11512{col 67}{space 3} 28.18605
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}

{p 4 4 2}
We want to replicate the output in the document as two tables. 

{p 4 4 2}
First, we replicate the header.  We add an empty 6x2 table by using
{cmd:_docx_new_table()}, then modify each cell of the table by using
{cmd:_docx_table_mod_cell()} with the stored results in {cmd:e()} to replicate
the above output.  Note that {cmd:Prob > F} is not stored but computed by 

	{cmd:Ftail(e(df_m), e(df_r), e(F))}{txt}  

{p 4 4 2}
Also note the use of {cmd:sprintf()} to format the numeric values to string. 

	{cmd}mata:
	tid = _docx_new_table(dh, 6, 2)

	_docx_table_mod_cell(dh, tid, 1, 1, "Number of obs")
	result = sprintf("%g", st_numscalar("e(N)"))
	_docx_table_mod_cell(dh, tid, 1, 2, result)

	result = sprintf("F(%g, %g)", 
				st_numscalar("e(df_m)"), 
				st_numscalar("e(df_r)"))
	_docx_table_mod_cell(dh, tid, 2, 1, result)
	result = sprintf("%8.2g", st_numscalar("e(F)"))
	_docx_table_mod_cell(dh, tid, 2, 2, result)

	_docx_table_mod_cell(dh, tid, 3, 1, "Prob > F")
	prob = Ftail(st_numscalar("e(df_m)"), 
				  st_numscalar("e(df_r)"), 
				  st_numscalar("e(F)"))
	result = sprintf("%10.4g", prob)
	_docx_table_mod_cell(dh, tid, 3, 2, result)

	_docx_table_mod_cell(dh, tid, 4, 1, "R-squared")
	result = sprintf("%10.4g", st_numscalar("e(r2)"))
	_docx_table_mod_cell(dh, tid, 4, 2, result)

	_docx_table_mod_cell(dh, tid, 5, 1, "Adj R-squared")
	result = sprintf("%10.4g", st_numscalar("e(r2_a)"))
	_docx_table_mod_cell(dh, tid, 5, 2, result)

	_docx_table_mod_cell(dh, tid, 6, 1, "Root MSE")
	result = sprintf("%10.4g", st_numscalar("e(rmse)"))
	_docx_table_mod_cell(dh, tid, 6, 2, result)
	end{txt}

{p 4 4 2}
To replicate the regression table, we store the numeric values in
{cmd:r(table)}.  But {cmd:r(table)} is in the transposed form and contains
extra rows, and all row and column names are not what we want.  We extract the
stored results from {cmd:r(table)} by typing

	{cmd}mat define r_table = r(table)' 
	mat r_table = r_table[1..3, 1..6]{txt}
 
{p 4 4 2}
Then we add the extracted matrix {cmd:r_table} to the document by using
{cmd:_docx_add_matrix}:
 
	{cmd}mata:
	tid = _docx_add_matrix(dh, "r_table", "%10.0g", 1, 1)
	end{txt}

{p 4 4 2}
Notice that we are including the row and column names although they are not
what we want.  We modify them by using {cmd:_docx_table_mod_cell()}:

	{cmd}mata:
	_docx_table_mod_cell(dh, tid, 1, 1, "mpg")
	_docx_table_mod_cell(dh, tid, 1, 2, "Coef.")
	_docx_table_mod_cell(dh, tid, 1, 3, "Std. Err.")
	_docx_table_mod_cell(dh, tid, 1, 4, "t")
	_docx_table_mod_cell(dh, tid, 1, 5, "P>|t|")
	_docx_table_mod_cell(dh, tid, 1, 6, "[95% Conf. Interval]")
	end{txt}

{p 4 4 2}
We set the last column of the first row in the regression table to have a
column span of 2 to match the Stata output by typing

	{cmd}mata:
	_docx_cell_set_colspan(dh, tid, 1, 6, 2)
	end{txt}


{marker example_image}{...}
    {title:Add an image}

{p 4 4 2}
To add a graph to the document, we first need to export the Stata graph to an
image file of type {cmd:.emf}, {cmd:.png}, or {cmd:.tif}. 

	{cmd:. scatter mpg price}
	{cmd:. graph export auto.png}

{p 4 4 2}
Then we can add the image to the document by using {cmd:_docx_image_add()}:

	{cmd}mata:
	_docx_image_add(dh, "auto.png")
	end{txt}


{marker example_nest_table}{...}
    {title:Display nested table}

{p 4 4 2}
If we want to output something like the table below to the document, 

	{txt}{center:{hline 22}}
	{center:{txt}{lalign 9:}{txt}{center 11:{cmd:mpg}}}
	{txt}{center:{hline 22}}
	{center:{txt}{lalign 9:{cmd:price}}{res}{center 11:-0.001}}
	{center:{txt}{lalign 9:}{res}{center 11:(5.28)**}}
	{center:{txt}{lalign 9:{cmd:foreign}}{res}{center 11:5.245}}
	{center:{txt}{lalign 9:}{res}{center 11:(4.51)**}}
	{center:{txt}{lalign 9:{cmd:_cons}}{res}{center 11:25.651}}
	{center:{txt}{lalign 9:}{res}{center 11:(20.17)**}}
	{center:{txt}{lalign 9:{cmd:R2}}{res}{center 11:0.39}}
	{center:{txt}{lalign 9:{cmd:N}}{res}{center 11:74}}
	{txt}{center:{hline 22}}
	{txt}{center:* p<0.05; ** p<0.01}

{p 4 4 2}
we can either create a 10x2 table and fill in the content or build it in
pieces and combine the pieces.

{p 4 4 2}
Notice that the middle part of the table for each variable has a similar
pattern.  First, we run the regression and get the saved table.

	{cmd:. regress mpg price foreign}

{p 4 4 2}
Then in Mata, we can build a 2x2 table for each variable by coding

	{cmd}mata:
	mr_table = st_matrix("r(table)")
	colnames = st_matrixcolstripe("r(table)") 
	tids = J(1, cols(mr_table), .)

	for(i=1; i<=cols(mr_table); i++) {
		tids[i] = _docx_new_table(dh, 2, 2, 1)
		_docx_table_mod_cell(dh, tids[i], 1, 1, colnames[i, 2])
		output = sprintf("%10.0g", mr_table[1, i])

		_docx_table_mod_cell(dh, tids[i], 1, 2, output)
		if(mr_table[1, i]<0) {
			output = sprintf("(%10.0g)", mr_table[3, i])
		}
		else {
			output = sprintf("%10.0g", mr_table[3, i])
		}

		if(mr_table[4, i]<0.05) {
			output = output +"*"
		}

		if(mr_table[4, i]<0.01) {
			output = output +"*"
		}

		_docx_table_mod_cell(dh, tids[i], 2, 2, output)
		_docx_cell_set_rowspan(dh, tids[i], 1, 1, 2)
	}
	end{txt}

{p 4 4 2}
Now we can combine them with the header and bottom three rows. 

	{cmd}mata:
	tid = _docx_new_table(dh, cols(mr_table)+4, 2)
	_docx_table_mod_cell(dh, tid, 1, 2, "mpg")

	for(i=2; i<=cols(mr_table)+1; i++) {
		_docx_cell_set_colspan(dh, tid, i, 1, 2)
		_docx_table_mod_cell_table(dh, tid, i, 1, 
			0, tids[i-1])
	}

	_docx_table_mod_cell(dh, tid, cols(mr_table)+2, 1, "R2")
	output = sprintf("%10.4g", st_numscalar("e(r2)"))
	_docx_table_mod_cell(dh, tid, cols(mr_table)+2, 2, output)

	_docx_table_mod_cell(dh, tid, cols(mr_table)+3, 1, "N")
	output = sprintf("%10.4g", st_numscalar("e(N)"))
	_docx_table_mod_cell(dh, tid, cols(mr_table)+3, 2, output)

	_docx_table_mod_cell(dh, tid, cols(mr_table)+4, 1, 
		"* p<0.05; ** p<0.01")
	_docx_cell_set_colspan(dh, tid, cols(mr_table)+4, 1, 2)
	end{txt}


{marker example_table_image}{...}
    {title:Add images to table cells}

{p 4 4 2}
We can also add an image to a table cell. First, we create the images:

	{cmd:. histogram price, title("Prices")}
	{cmd:. graph export prices.png}
	{cmd:. histogram mpg, title("MPG")}
	{cmd:. graph export mpg.png}

{p 4 4 2}
We can add {cmd:auto0.png} and {cmd:auto1.png} to different cells of a table
by using {cmd:_docx_table_mod_cell_image()}.  

	{cmd}mata:
	tid = _docx_new_table(dh, 1, 2) 
	_docx_table_mod_cell_image(dh, tid, 1, 1, "prices.png")
	_docx_table_mod_cell_image(dh, tid, 1, 2, "mpg.png")
	end{txt}


{marker example_save}{...}
    {title:Save the .docx document in memory to a disk file}

{p 4 4 2}
We use  {cmd:_docx_save()} to save the document to a disk file:

	{cmd}mata:
	res = _docx_save(dh, "example.docx")
	end{txt}

{p 4 4 2}
Notice that we did not specify the third parameter {it:replace}; hence, the
function may fail if {cmd:example.docx} already exists in the current working
directory.  It is always good practice to check the return code of
{cmd:_docx_save()}. 


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
See {help mf__docx##remarks:Remarks}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
