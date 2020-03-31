{smcl}
{* *! version 1.0.0  10may2019}{...}
{vieweralsosee "[RPT] putpdf table" "mansection RPT putpdftable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{vieweralsosee "[RPT] putpdf begin" "help putpdf begin"}{...}
{vieweralsosee "[RPT] putpdf pagebreak" "help putpdf pagebreak"}{...}
{vieweralsosee "[RPT] putpdf paragraph" "help putpdf paragraph"}{...}
{vieweralsosee "[RPT] Appendix for putpdf" "help putpdf appendix"}{...}
{viewerjumpto "Syntax" "putpdf table##syntax"}{...}
{viewerjumpto "Description" "putpdf table##description"}{...}
{viewerjumpto "Links to PDF documentation" "putpdf table##linkspdf"}{...}
{viewerjumpto "Options" "putpdf table##options"}{...}
{viewerjumpto "Examples" "putpdf table##examples"}{...}
{viewerjumpto "Stored results" "putpdf table##results"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[RPT] putpdf table} {hline 2}}Add tables to a PDF file{p_end}
{p2col:}({mansection RPT putpdftable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Add table to document

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}
{cmd:=} {cmd:(}{help putpdf_table##nrows/ncols:{it:nrows}}{cmd:,}
   {help putpdf_table##nrows/ncols:{it:ncols}}{cmd:)}
[{cmd:,} {help putpdf_table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}
{cmd:=} {help putpdf_table##data:{bf:data(}{it:varlist}{bf:)}}
{ifin} [{cmd:,} {cmd:varnames} {cmd:obsno}
{help putpdf_table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}
{cmd:=} {help putpdf_table##matname:{bf:{ul:mat}rix(}{it:matname}{bf:)}}
[{cmd:,} {opth nfor:mat(%fmt)}
{cmd:rownames} {cmd:colnames}
{help putpdf_table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}
{cmd:=} {help putpdf_table##mata:{bf:mata(}{it:matname}{bf:)}}
[{cmd:,} {opth nfor:mat(%fmt)}
{help putpdf_table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}
{cmd:=} {help putpdf_table##etable:{bf:etable}}[{cmd:(}{it:#}_1
    {it:#}_2 ... {it:#}_n{cmd:)}]
[{cmd:,} {help putpdf_table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}
{cmd:=} {help putpdf_table##returnset:{it:returnset}}
[{cmd:,} {help putpdf_table##tabopts:{it:table_options}}]


{phang}
Add content to cell

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:)}
{cmd:=} {cmd:(}{help exp:{it:exp}}{cmd:)}
[{cmd:,} {help putpdf_table##cellopts:{it:cell_options}}]

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:)}
{cmd:=} {help putpdf_table##image:{bf:image(}{it:filename}{bf:)}}
[{cmd:,} {help putpdf_table##cellopts:{it:cell_options}}]

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:)}
{cmd:=} {cmd:table(}{help putpdf_table##mem_tablename:{it:mem_tablename}}{cmd:)}
[{cmd:,} {help putpdf_table##cellopts:{it:cell_options}}]


{phang}
Alter table layout

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,} {cmd:.),}
{help putpdf_table##rowcolopts:{it:row_col_options}}

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(.,} {it:j}{cmd:),}
{help putpdf_table##rowcolopts:{it:row_col_options}}


{phang}
Customize format of cells or table

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:),}
{help putpdf_table##cellopts:{it:cell_options}}

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(} {help numlist:{it:numlist}}_{it:i} {cmd:,} {cmd:.),}
{help putpdf_table##cellfmtopts:{it:cell_fmt_options}}

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(.,} {help numlist:{it:numlist}}_{it:j}{cmd:),}
{help putpdf_table##cellfmtopts:{it:cell_fmt_options}}

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(} {help numlist:{it:numlist}}_{it:i} {cmd:,} {help numlist:{it:numlist}}_{it:j}{cmd:),}
{help putpdf_table##cellfmtopts:{it:cell_fmt_options}}

{p 8 22 2}
{cmd:putpdf table}
{help putpdf_table##tablename:{it:tablename}}{cmd:(.,} {cmd:.),}
{help putpdf_table##cellfmtopts:{it:cell_fmt_options}}


{phang}
Describe table

{p 8 22 2}
{cmd:putpdf describe}
{help putpdf_table##tablename:{it:tablename}}


{marker tablename}{...}
{phang}
{it:tablename} specifies the name of a new table.  The name must be a valid
name according to Stata's naming conventions; see {findalias frnames}.

{marker tabopts}{...}
{synoptset 28}{...}
{synopthdr:table_options}
{synoptline}
{synopt :{opt mem:table}}keep table in memory rather than add it to document{p_end}
{synopt :{cmd:width(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}{c |}{cmd:%}] {c |} {help putpdf_table##matname:{it:matname}}{cmd:)}}set table width{p_end}
{synopt :{opth halign:(putpdf_table##table_hvalue:hvalue)}}set table horizontal alignment{p_end}
{synopt :{cmd:indent(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set table indentation{p_end}
{synopt :{cmd:spacing(}{help putpdf_table##table_position:{it:position}}{cmd:,}  {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set spacing before or after table{p_end}
{synopt :{opth bord:er(putpdf_table##bspec:bspec)}}set pattern and color for border{p_end}
{synopt :{opth title:(strings:string)}}add a title to the table{p_end}
{synopt :{opth note:(strings:string)}}add notes to the table{p_end}
{synoptline}

{marker cellopts}{...}
{synoptset 28}{...}
{synopthdr:cell_options}
{synoptline}
{synopt :{cmd:append}}append objects to current content of cell{p_end}
{synopt :{opt rowspan(#)}}merge cells vertically{p_end}
{synopt :{opt colspan(#)}}merge cells horizontally{p_end}
{synopt :{cmd:span(}{it:#}_1{cmd:,} {it:#}_2{cmd:)}}merge cells both horizontally and vertically{p_end}
{synopt :{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}]}add line breaks into the cell{p_end}
{synopt :{help putpdf_table##cellfmtopts:{it:cell_fmt_options}}}options that control the look of cell contents{p_end}
{synoptline}

{marker rowcolopts}{...}
{synoptset 28}{...}
{synopthdr:row_col_options}
{synoptline}
{synopt :{opt nosp:lit}}prevent row from breaking across pages{p_end}
{synopt :{cmd:addrows(}{it:#} [{cmd:, before}{c |}{cmd:after}]{cmd:)}}add {it:#} rows in specified location{p_end}
{synopt :{cmd:addcols(}{it:#} [{cmd:, before}{c |}{cmd:after}]{cmd:)}}add {it:#} columns in specified location{p_end}
{synopt :{opt drop}}drop specified row or column{p_end}
{synopt :{help putpdf_table##cellfmtopts:{it:cell_fmt_options}}}options that control the look of cell contents{p_end}
{synoptline}

{marker cellfmtopts}{...}
{synoptset 28 tabbed}{...}
{synopthdr:cell_fmt_options}
{synoptline}
{synopt :{cmd:margin(}{help putpdf_table##cell_marg_type:{it:type}}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}}set margins{p_end}
{synopt :{opth halign:(putpdf_table##cell_hvalue:hvalue)}}set horizontal alignment{p_end}
{synopt :{opth valign:(putpdf_table##cell_vvalue:vvalue)}}set vertical alignment{p_end}
{synopt :{opth bord:er(putpdf_table##bspec:bspec)}}set pattern and color for border{p_end}
{synopt :{opth bgcolor:(putpdf_table##color:color)}}set background color{p_end}
{synopt :{opth nfor:mat(%fmt)}}specify numeric format for cell text{p_end}
{synopt :{cmd:font(}{help putpdf_table##fspec:{it:fspec}}{cmd:)}}set font, font size, and font color{p_end}
{synopt :{opt bold}}format text as bold{p_end}
{synopt :{opt italic}}format text as italic{p_end}
{p2coldent :* {cmd:script(sub{c |}super)}}set subscript or superscript formatting of text{p_end}
{synopt :{opt strike:out}}strikeout text{p_end}
{synopt :{opt underl:ine}}underline text{p_end}
{synopt :{opt allc:aps}}format text as all caps{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
* May only be specified when formatting a single cell.

{marker fspec}{...}
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

{marker bspec}{...}
{phang}
{it:bspec} is

{pmore}
{it:bordername} [{cmd:,} {it:bpattern} [{cmd:,} {it:bcolor}]]

{pmore2}
{it:bordername} specifies the location of the border.

{pmore2}
{it:bpattern} is a keyword specifying the look of the border.
Possible patterns are {cmd:nil} and {cmd:single}. The default is {cmd:single}.
To remove an existing border, specify {cmd:nil} as the {it:bpattern}.

{pmore2}
{it:bcolor} specifies the border color.

{marker unit}{...}
{phang}
INCLUDE help put_units

{marker color}{...}
{phang}
{it:color} and {it:bcolor} may be one of the
colors listed in 
{help putpdf_appendix##Colors:{it:Colors}} of
{helpb putpdf appendix:[RPT] Appendix of putpdf};
a valid RGB value in the form {it:### ### ###}, for example,
{cmd:171 248 103}; or a valid RRGGBB hex value in the form {it:######},
for example, {cmd:ABF867}.


    {bf:Output types for tables}

{phang}
The following output types are supported when creating a new table using
{cmd:putpdf} {cmd:table} {it:tablename}:

{marker nrows/ncols}{...}
{phang2}
{cmd:(}{it:nrows}{cmd:,} {it:ncols}{cmd:)} creates an empty table with
{it:nrows} rows and {it:ncols} columns. A maximum of 50 columns in a table is
allowed.

{marker data}{...}
{phang2}
{opt data(varlist)} adds the current Stata dataset in memory as a table to the
active document.  {varlist} contains a list of the variable names from the
current dataset in memory.

{marker matname}{...}
{phang2}
{opt matrix(matname)}
adds a {help matrix} called {it:matname} as a table to the active document. 

{marker mata}{...}
{phang2}
{opt mata(matname)} adds a Mata
{help matrix} called {it:matname} as a table to the active
document.  

{marker etable}{...}
{phang2}
{cmd:etable}[{cmd:(}{it:#}_1 {it:#}_2 ... {it:#}_n{cmd:)}] adds an
automatically generated table to the active document.
The table may be derived from the
coefficient table of the last estimation command, from the table of
margins after the last {helpb margins} command,
or from the table of results from one or more models displayed by
{helpb estimates table}.

{pmore2}
If the estimation command outputs n > 1 coefficient tables, the
default is to add all tables and assign the corresponding table names
{it:tablename}{cmd:1}, {it:tablename}{cmd:2}, ..., {it:tablename}_n. To specify
which tables to add, supply the optional numlist to {cmd:etable}.  For example,
to add only the first and third tables from the estimation output, specify
{cmd:etable(1 3)}.
A few estimation commands do not support the
{cmd:etable} output type. See
{help putdocx_appendix##Unsupported_estcmds:{it:Unsupported estimation commands}} of {helpb putdocx_appendix:[RPT] Appendix for putdocx}
for a list of estimation commands that are not supported by {cmd:putpdf}.

{marker returnset}{...}
{phang2}
{it:returnset} exports a group of Stata
{help return} values to a table in the active document. It is
intended primarily for use by programmers and by those who want to do further
processing of their exported results in the active document.
{it:returnset} may be one of the following:

                 {it:returnset}    Description
                {hline 57}
                 {opt escal:ars}     All ereturned scalars
                 {opt rscal:ars}     All returned scalars
                 {opt emac:ros}      All ereturned macros
                 {opt rmac:ros}      All returned macros
                 {opt emat:rices}    All ereturned matrices
                 {opt rmat:rices}    All returned matrices
                 {opt e*}           All ereturned scalars, macros, and matrices
                 {opt r*}           All returned scalars, macros, and matrices
                {hline 57}


{phang}
The following output types are supported when adding content to an existing
table using
{cmd:putpdf table} {it:tablename}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:)}:

{marker expr}{...}
{phang2}
{cmd:(}{help exp:{it:exp}}{cmd:)} writes a valid Stata expression to a cell;
see {findalias frexp}.

{marker image}{...}
{phang2}
{cmd:image} {help filename:{it:filename}} adds a portable network graphics
({cmd:.png}) or JPEG ({cmd:.jpg}) file to the table cell. {it:filename} is the
path to the image file.  It may be either the full path or the relative path
from the current working directory.

{marker mem_tablename}{...}
{marker table}{...}
{phang2}
{opt table(mem_tablename)} adds a previously created table,
identified by {it:mem_tablename}, to the table cell.

{phang}
The following combinations of
{it:tablename}{cmd:(}{it:numlist}_{it:i}{cmd:,} {it:numlist}_{it:j}{cmd:)}
(see {findalias frnumlist} for valid specifications) can be used to format a
cell or range of cells in an existing table:

{phang2}
{it:tablename}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:)} specifies the
cell on the {it:i}th row and {it:j}th column.

{phang2}
{it:tablename}{cmd:(}{it:i}{cmd:,} {cmd:.)}
and
{it:tablename}{cmd:(}{it:numlist}_{it:i}{cmd:,} {cmd:.)}
specify all cells on the {it:i}th row or
on the rows identified by {it:numlist}_{it:i}.

{phang2}
{it:tablename}{cmd:(.,} {it:j}{cmd:)}
and
{it:tablename}{cmd:(.,} {it:numlist}_{it:j}{cmd:)}
specify all cells in the {it:j}th column
or
in the columns identified by {it:numlist}_{it:j}.

{phang2}
{it:tablename}{cmd:(., .)} specifies the whole table.


{marker description}{...}
{title:Description}

{pstd}
{cmd:putpdf} {cmd:table} creates a new table in the active PDF 
file. Tables may be created from several output types, including the
data in memory, matrices, and estimation results.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putpdftableQuickstart:Quick start}

        {mansection RPT putpdftableRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Options are presented under the following headings:

        {help putpdf_table##opts_table:table_options}
        {help putpdf_table##opts_cell:cell_options}
        {help putpdf_table##opts_row_col:row_col_options}
        {help putpdf_table##opts_cell_fmt:cell_fmt_options}


{marker opts_table}{...}
{title:table_options}

{phang}
{opt memtable} specifies that the table be created and held in memory instead
of being added to the active document. By default, the table is added to the
document immediately after it is created. This option is useful if the table
is intended to be added to a cell of another table or to be used multiple
times later.

{phang}
{cmd:width(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}{c |}{cmd:%}]{cmd:)}
 and
{opt width(matname)} set the table width.  Any two of the types of width
specifications can be combined.

{pmore}
{cmd:width(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}{c |}{cmd:%}]{cmd:)}
sets the width based on a specified value. {it:#} may be an absolute width or a
percentage of the default table width, which is determined by the page width of
the document. For example, {cmd:width(50%)} sets the table width to 50% of the
default table width. The default is {cmd:width(100%)}.

{pmore}
{opt width(matname)} sets the table width based on the dimensions specified in
the Stata matrix {it:matname}, which has contents in the form of ({it:#}_1,
{it:#}_2, ..., {it:#}_n) to denote the percent of the default table width for
each column. n is the number of columns of the table, and the sum of {it:#}_1
to {it:#}_n must be equal to 100.

{marker table_hvalue}{...}
{phang}
{opt halign(hvalue)} sets the horizontal alignment of the table within
the page. {it:hvalue} may be {cmd:left}, {cmd:right}, or {cmd:center}.
The default is {cmd:halign(left)}.

{phang}
{cmd:indent(}{it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)} specifies
the table indentation from the left margin of the current document.

{marker table_position}{...}
{phang}
{cmd:spacing(}{it:position}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}
sets the spacing before or after the table.  {it:position} may be {cmd:before}
or {cmd:after}.  {cmd:before} specifies the space before the top of the current
table, and {cmd:after} specifies the space after the bottom of the current
table. This option may be specified multiple times in a single command to
account for different space settings.

{phang}
{cmd:border(}{it:bordername}
[{cmd:,} {help putpdf_table##bspec:{it:bpattern}}
[{cmd:,} {help putpdf_table##color:{it:bcolor}}]]{cmd:)}
adds a single border in the location specified by
{it:bordername}, which may be {cmd:start}, {cmd:end}, {cmd:top},
{cmd:bottom},
{cmd:insideH} (inside horizontal borders),
{cmd:insideV} (inside vertical borders),
or {cmd:all}.
Optionally, you may change the pattern and color for the border
by specifying {it:bpattern} and {it:bcolor}.

{pmore}
This option may be specified multiple times in a single command to accommodate
different border settings.  If multiple {cmd:border()} options are specified,
they are applied in the order specified from left to right.

{phang}
{cmd:varnames} specifies that the variable names be included as the first row
in the table when the table is created using the dataset in memory. By
default, only the data values are added to the table.

{phang}
{cmd:obsno} specifies that the observation numbers be included as the first
column in the table when the table is created using the dataset in memory. By
default, only the data values are added to the table.

{phang}
{opth nformat(%fmt)} specifies the numeric format to be applied to the source
values when creating the table from a Stata or Mata matrix.  The default is
{cmd:nformat(%12.0g}).

{phang}
{cmd:rownames} specifies that the row names of the Stata matrix be included as
the first column in the table. By default, only the matrix values are added to
the table.

{phang}
{cmd:colnames} specifies that the column names of the Stata matrix be included
as the first row in the table. By default, only the matrix values are added to
the table.

{phang}
{opth title:(strings:string)} inserts a row without borders above the current
table. The added row spans all the columns of the table and contains
{it:string} as text.  The added row shifts all other table contents down by one
row. You should account for this when referencing table cells in subsequent
commands.

{phang}
{opth note:(strings:string)} inserts a row without borders to the bottom of the
table.  The added row spans all the columns of the table.  This option may be
specified multiple times in a single command to add notes on new lines within
the same cell.  Note text is inserted in the order it was specified from left
to right.


{marker opts_cell}{...}
{title:cell_options}

{phang}
{cmd:append} specifies that the new content for the cell be appended to the
current content of the cell. If {cmd:append} is not specified, then the
current content of the cell is replaced by the new content.   Unlike with the
{helpb putdocx} command, this option with {cmd:putpdf} is used only for
appending a new string to the cell when the original cell content is also a
string.

{phang}
{opt rowspan(#)} sets the specified cell to span vertically {it:#}
cells downward. If the span exceeds the total number of rows in the table, the
span stops at the last row.

{phang}
{opt colspan(#)} sets the specified cell to span horizontally {it:#}
cells to the right. If the span exceeds the total number of columns in the
table, the span stops at the last column.

{phang}
{cmd:span(}{it:#}_1{cmd:,} {it:#}_2{cmd:)} sets the specified cell to span
{it:#}_1 cells downward and span {it:#}_2 cells to the right.

{phang}
{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}] specifies that one or {it:#} line
breaks be added after the text within the cell.


{marker opts_row_col}{...}
{title:row_col_options}

{phang}
{cmd:nosplit} specifies that row {it:i} not split across pages. When a table
row is displayed, a page break may fall within the contents of a cell on the
row, causing the contents of that cell to be displayed across two pages.
{cmd:nosplit} prevents this behavior.  If the entire row cannot fit on the
current page, the row will be moved to the start of the next page.

{phang}
{cmd:addrows(}{it:#} [{cmd:, before}{c |}{cmd:after}]{cmd:)} adds {it:#} rows
to the current table before or after row {it:i}. If {cmd:before} is specified,
the rows are added before the specified row. By default, rows are added after
the specified row.

{phang}
{cmd:addcols(}{it:#} [{cmd:, before}{c |}{cmd:after}]{cmd:)} adds {it:#}
columns to the current table to the right or the left of column {it:j}.  If
{cmd:before} is specified, the columns are added to the left of the specified
column.  By default, the columns are added after, or to the right of, the
specified column.

{phang}
{cmd:drop} deletes row {it:i} or column {it:j} from the table.


{marker opts_cell_fmt}{...}
{title:cell_fmt_options}

{marker cell_marg_type}{...}
{phang}
{cmd:margin(}{it:type}{cmd:,} {it:#}[{help putdocx_paragraph##unit:{it:unit}}]{cmd:)}
sets the margins inside the specified cell or of all cells in the specified
row, column, or range. {it:type} may be {cmd:top}, {cmd:left}, {cmd:bottom}, or
{cmd:right}, which identify the top margin, left margin, bottom margin, or
right margin of the cell, respectively. This option may be specified multiple
times in a single command to account for different margin settings.

{marker cell_hvalue}{...}
{phang}
{opt halign(hvalue)} sets the horizontal alignment of the specified cell
or of all cells in the specified row, column, or range.
{it:hvalue} may be {cmd:left}, {cmd:right}, or {cmd:center}. The default is
{cmd:halign(left)}.

{marker cell_vvalue}{...}
{phang}
{opt valign(vvalue)} sets the vertical alignment of the specified cell
or of all cells in the specified row, column, or range.
{it:vvalue} may be {cmd:top}, {cmd:bottom}, or {cmd:center}. The default is
{cmd:valign(top)}.

{phang}
{cmd:border(}{it:bordername} [{cmd:,} {help putpdf_table##bspec:{it:bpattern}}
[{cmd:,} {help putpdf_table##color:{it:bcolor}}]]{cmd:)}
adds a single border to the specified cell or to all cells in the specified
row, column, or range in the given location.  {it:bordername} may be
{cmd:start}, {cmd:end}, {cmd:top}, {cmd:bottom}, or {cmd:all}.  Optionally, you
may change the pattern and color for the border by specifying {it:bpattern}
and {it:bcolor}.

{pmore}
This option may be specified multiple times in a single command to accommodate
different border settings.  If multiple {cmd:border()} options are specified,
they are applied in the order specified from left to right.

{phang}
{cmd:bgcolor(}{help putpdf_table##color:{it:color}}{cmd:)}
sets the background color for the specified cell or for all cells in the
specified row, column, or range.

{phang}
{opth nformat(%fmt)} applies the Stata numeric format {cmd:%}{it:fmt} to
the text within the specified cell or within all cells in the specified row,
column, or range.  This setting only applies when the content of the cell is a
numeric value.

{phang}
{cmd:font(}{help putpdf_table##font:{it:fontname}}
[{cmd:,} {help putpdf_table##size:{it:size}}
[{cmd:,} {help putpdf_table##color:{it:color}}]]{cmd:)}
sets the font, font size, and font color for the text within the
specified cell or within all cells in the specified row, column, or range.
The font size and font color may be specified individually without
specifying {it:fontname}. Use {cmd:font("",} {it:size}{cmd:)} to specify font
size only. Use {cmd:font("", "",} {it:color}{cmd:)} to specify font color only.
For both cases, the default font will be used.

{phang}
{cmd:bold} applies bold formatting to the text within the
specified cell
or within all cells in the specified row, column, or range.

{phang}
{cmd:italic} applies italic formatting to the text within the
specified cell
or within all cells in the specified row, column, or range.

{phang}
{cmd:script(sub{c |}super)} changes the script style of the text.
{cmd:script(sub)} makes the text a subscript. {cmd:script(super)} makes
the text a superscript. {cmd:script()} may only be specified when formatting a
single cell.

{phang}
{cmd:strikeout} adds a strikeout mark to the current text within the specified
cell or within all cells in the specified row, column, or range.

{phang}
{cmd:underline} adds an underline to the current text within the specified cell
or within all cells in the specified row, column, or range.

{phang}
{cmd:allcaps} uses capital letters for all letters of the current text within
the specified cell or within all cells in the specified row, column, or range.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create the {cmd:.pdf} document in memory{p_end}
{phang2}{cmd:. putpdf begin}{p_end}

{pstd}
Fit a linear regression model of {cmd:mpg} as a function of 
{cmd:weight} and {cmd:foreign}{p_end}
	{cmd:. regress mpg weight foreign}

{pstd}
Export the estimation results to the document as a table with the name {cmd:tbl1}{p_end}
{phang2}{cmd:. putpdf table tbl1 = etable, width(100%)}

{pstd}	
Keep only the point estimates and confidence intervals{p_end}
{phang2}{cmd:. putpdf table tbl1(.,5), drop}{p_end}
{phang2}{cmd:. putpdf table tbl1(.,4), drop}{p_end}
{phang2}{cmd:. putpdf table tbl1(.,3), drop}

{pstd}
Modify the column heading to omit the dependent variable name{p_end}
{phang2}{cmd:. putpdf table tbl1(1,2) = ("")}

{pstd}
Export the first 15 observations of the {cmd:make},
{cmd:price}, and {cmd:mpg} variables from the dataset in memory{p_end}
	{cmd:. putpdf table tbl1 = data("make price mpg") in 1/15, varnames}

{pstd}
Save the document to disk{p_end}
	{cmd:. putpdf save example.pdf}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:putpdf describe} {it:tablename} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(nrows)}}number of rows in the table{p_end}
{synopt:{cmd:r(ncols)}}number of columns in the table{p_end}
{p2colreset}{...}
