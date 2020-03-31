{smcl}
{* *! version 1.0.2  15oct2019}{...}
{vieweralsosee "[RPT] putdocx table" "mansection RPT putdocxtable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putdocx begin" "help putdocx begin"}{...}
{vieweralsosee "[RPT] putdocx pagebreak" "help putdocx pagebreak"}{...}
{vieweralsosee "[RPT] putdocx paragraph" "help putdocx paragraph"}{...}
{vieweralsosee "[RPT] Appendix for putdocx" "help putdocx_appendix"}{...}
{viewerjumpto "Syntax" "putdocx table##syntax"}{...}
{viewerjumpto "Description" "putdocx table##description"}{...}
{viewerjumpto "Links to PDF documentation" "putdocx table##linkspdf"}{...}
{viewerjumpto "Options" "putdocx table##options"}{...}
{viewerjumpto "Examples" "putdocx table##examples"}{...}
{viewerjumpto "Stored results" "putdocx table##results"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[RPT] putdocx table} {hline 2}}Add tables to an Office Open XML
(.docx) file{p_end}
{p2col:}({mansection RPT putdocxtable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Add table to document

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}
{cmd:=} {cmd:(}{help putdocx_table##nrows/ncols:{it:nrows}}{cmd:,}
   {help putdocx_table##nrows/ncols:{it:ncols}}{cmd:)}
[{cmd:,} {help putdocx_table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}
{cmd:=} {help putdocx_table##data:{bf:data(}{it:varlist}{bf:)}}
{ifin}
[{cmd:,} {cmd:varnames} {cmd:obsno}
{help putdocx_table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}
{cmd:=} {help putdocx_table##matname:{bf:{ul:mat}rix(}{it:matname}{bf:)}}
[{cmd:,} {opth nfor:mat(%fmt)}
{cmd:rownames}
{cmd:colnames}
{help putdocx_table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}
{cmd:=} {help putdocx_table##mata:{bf:mata(}{it:matname}{bf:)}}
[{cmd:,} {opth nfor:mat(%fmt)}
{help putdocx_table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}
{cmd:=} {help putdocx_table##etable:{bf:etable}}[{cmd:(}{it:#}_1
              {it:#}_2 ... {it:#}_n{cmd:)}]
[{cmd:,}
{help putdocx table##tabopts:{it:table_options}}]

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}
{cmd:=} {help putdocx_table##returnset:{it:returnset}}
[{cmd:,} {help putdocx_table##tabopts:{it:table_options}}]


{phang}
Add content to cell

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:)}
{cmd:=} {cmd:(}{help putdocx_table##expr:{it:exp}}{cmd:)}
[{cmd:,} {help putdocx_table##cellopts:{it:cell_options}}
{help putdocx_table##expopts:{it:exp_options}}]

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:)}
{cmd:=} {help putdocx_table##image:{bf:image(}{it:filename}{bf:)}}
[{cmd:,} {help putdocx_table##imageopts:{it:image_options}}
{help putdocx_table##cellopts:{it:cell_options}}]

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,}{it:j}{cmd:)}
{cmd:=} {cmd:table(}{help putdocx_table##mem_tablename:{it:mem_tablename}}{cmd:)}
[{cmd:,} {help putdocx_table##cellopts:{it:cell_options}}]


{phang}
Alter table layout

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,} {cmd:.),}
{help putdocx_table##rowcolopts:{it:row_col_options}}

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(.,} {it:j}{cmd:),}
{help putdocx_table##rowcolopts:{it:row_col_options}}


{phang}
Customize format of cells or table

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:),}
{help putdocx_table##cellopts:{it:cell_options}}

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(} {help numlist:{it:numlist}}_{it:i}{cmd:, .),}
{help putdocx_table##cellfmtopts:{it:cell_fmt_options}}

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(.,} {help numlist:{it:numlist}}_{it:j}{cmd:),}
{help putdocx_table##cellfmtopts:{it:cell_fmt_options}}

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(} {help numlist:{it:numlist}}_{it:i}{cmd:,} {help numlist:{it:numlist}}_{it:j}{cmd:),}
{help putdocx_table##cellfmtopts:{it:cell_fmt_options}}

{p 8 22 2}
{cmd:putdocx table}
{help putdocx_table##tablename:{it:tablename}}{cmd:(.,} {cmd:.),}
{help putdocx_table##cellfmtopts:{it:cell_fmt_options}}


{phang}
Describe table

{p 8 22 2}
{cmd:putdocx describe}
{help putdocx_table##tablename:{it:tablename}}


{marker tablename}{...}
{phang}
{it:tablename} specifies the name of a table.  The name must be a valid
name according to Stata's naming conventions; see {findalias frnames}.

{marker tabopts}{...}
{synoptset 28}{...}
{synopthdr:table_options}
{synoptline}
{synopt :{opt mem:table}}keep table in memory rather than add it to document{p_end}
{synopt :{cmd:width(}{it:#}[{help putdocx_table##unit:{it:unit}}{c |}{cmd:%}]{cmd:)}}set table width{p_end}
{synopt :{opth halign:(putdocx_table##table_hvalue:hvalue)}}set table horizontal alignment{p_end}
{synopt :{cmd:indent(}{it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)}}set table indentation{p_end}
{synopt :{opth layout:(putdocx_table##layouttype:layouttype)}}adjust column width{p_end}
{synopt :{cmdab:cellmar:gin(}{help putdocx_table##cmarg:{it:cmarg}}{cmd:,} {it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)}}set margins for each table cell{p_end}
{synopt :{cmdab:cellsp:acing(}{it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)}}set spacing between adjacent cells and the edges of the table{p_end}
{synopt :{opth bord:er(putdocx_table##bspec:bspec)}}set pattern, color, and width for border{p_end}
{synopt :{opt headerr:ow(#)}}set number of the top rows that constitute the table header{p_end}
{synopt :{opth title:(strings:string)}}add a title to the table{p_end}
{synopt :{opth note:(strings:string)}}add notes to the table{p_end}
{synopt :{opth toheader:(putdocx_table##hname:hname)}}add the table to the header {it:hname}{p_end}
{synopt :{opth tofooter:(putdocx_table##fname:fname)}}add the table to the footer {it:fname}{p_end}
{synoptline}

{marker cellopts}{...}
{synoptset 28}{...}
{synopthdr:cell_options}
{synoptline}
{synopt :{opt append}}append objects to current content of cell{p_end}
{synopt :{opt rowspan(#)}}merge cells vertically{p_end}
{synopt :{opt colspan(#)}}merge cells horizontally{p_end}
{synopt :{cmd:span(}{it:#}_1{cmd:,} {it:#}_2{cmd:)}}merge cells both horizontally and vertically{p_end}
{synopt :{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}]}add line breaks into the cell{p_end}
{synopt :{help putdocx_table##cellfmtopts:{it:cell_fmt_options}}}options that control the look of cell contents{p_end}
{synoptline}

{marker expopts}{...}
{synoptset 28}{...}
{synopthdr:exp_options}
{synoptline}
{synopt :{opt pagenumber}}append the current page number to the end of
{it:exp}{p_end}
{synopt :{opt totalpages}}append the number of total pages to the end of
{it:exp}{p_end}
{synopt :{opt trim}}remove the leading and trailing spaces in {it:exp}{p_end}
{synopt :{opth hyperlink:(putdocx_table##link:link)}}add the expression as a
hyperlink{p_end}
{synoptline}

{marker imageopts}{...}
{synoptset 28}{...}
{synopthdr:image_options}
{synoptline}
{synopt :{cmdab:w:idth(}{it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)}}set image width{p_end}
{synopt :{cmdab:h:eight(}{it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)}}set image height{p_end}
{synopt :{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}]}add line breaks after image{p_end}
{synopt :{opt link}}insert link to image file{p_end}
{synoptline}

{marker rowcolopts}{...}
{synoptset 28}{...}
{synopthdr:row_col_options}
{synoptline}
{synopt :{opt nosp:lit}}prevent row from breaking across pages{p_end}
{synopt :{cmd:addrows(}{it:#} [{cmd:, before}{c |}{cmd:after}]{cmd:)}}add {it:#} rows in specified location{p_end}
{synopt :{cmd:addcols(}{it:#} [{cmd:, before}{c |}{cmd:after}]{cmd:)}}add {it:#} columns in specified location{p_end}
{synopt :{opt drop}}drop specified row or column{p_end}
{synopt :{help putdocx_table##cellfmtopts:{it:cell_fmt_options}}}options that control the look of cell contents{p_end}
{synoptline}

{marker cellfmtopts}{...}
{synoptset 28 tabbed}{...}
{synopthdr:cell_fmt_options}
{synoptline}
{synopt :{opth halign:(putdocx_table##cell_hvalue:hvalue)}}set horizontal alignment{p_end}
{synopt :{opth valign:(putdocx_table##cell_vvalue:vvalue)}}set vertical alignment{p_end}
{synopt :{opth bord:er(putdocx_table##bspec:bspec)}}set pattern, color, and width for border{p_end}
{synopt :{opth shad:ing(putdocx_table##sspec:sspec)}}set background color, foreground color, and fill pattern{p_end}
{synopt :{opth nfor:mat(%fmt)}}specify numeric format for cell text{p_end}
{synopt :{opth font:(putdocx_table##fspec:fspec)}}set font, font size, and font color{p_end}
{synopt :{opt bold}}format text as bold{p_end}
{synopt :{opt italic}}format text as italic{p_end}
{p2coldent: * {cmd:script(sub{c |}super)}}set subscript or superscript formatting of text{p_end}
{synopt :{opt strike:out}}strikeout text{p_end}
{synopt :{cmdab:underl:ine}[{cmd:(}{help putdocx_table##cell_upattern:{it:upattern}}{cmd:)}]}underline text using specified pattern{p_end}
{synopt :{opt allc:aps}}format text as all caps{p_end}
{synopt :{opt smallc:aps}}format text as small caps{p_end}
{synoptline}
{p 4 6 2}
* May only be specified when formatting a single cell.


{marker unit}{...}
{phang}
INCLUDE help put_units

{marker bspec}{...}
{phang}
{it:bspec} is

{pmore}
{it:bordername} [{cmd:,} {it:bpattern} [{cmd:,} {help putdocx_table##color:{it:bcolor}} [{cmd:,} {it:bwidth}]]]

{pmore2}
{it:bordername} specifies the location of the border.

{pmore2}
{it:bpattern} is a keyword specifying the look of the border.  The most common
patterns are {cmd:single}, {cmd:dashed}, {cmd:dotted}, and {cmd:double}.  The
default is {cmd:single}.  For a complete list of border patterns, see
{help putdocx_appendix##Border_patterns:{it:Border patterns}} of
{helpb putdocx_appendix:[RPT] Appendix for putdocx}.  To remove an existing
border, specify {cmd:nil} as the {it:bpattern}.

{pmore2}
{it:bcolor} specifies the border color.

{pmore2}
{it:bwidth} is defined as {it:#}[{help putdocx_paragraph##unit:{it:unit}}] and
specifies the border width.  The default border width is 0.5 points.
If {it:#} is specified without the optional {it:unit}, inches is assumed.
{it:bwidth} may be ignored if you specify a width larger than that allowed
by the program used to view the {cmd:.docx} file.  We suggest using 12 points
or less or an equivalent specification.

{marker sspec}{...}
{phang}
{it:sspec} is

{pmore}
{help putdocx_table##color:{it:bgcolor}}
[{cmd:,} {help putdocx_table##color:{it:fgcolor}}
[{cmd:,} {it:fpattern}]]

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

{marker fspec}{...}
{phang}
{it:fspec} is

{pmore}
{it:fontname} [{cmd:,} {it:size}
[{cmd:,} {help putdocx_table##color:{it:color}}]

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

{marker color}{...}
{phang}
{it:bcolor}, {it:bgcolor}, {it:fgcolor}, and {it:color}  may be one of the
colors listed in {help putdocx_appendix##Colors:{it:Colors}} of 
{helpb putdocx appendix:[RPT] Appendix for putdocx}; a valid RGB value in the
form {it:### ### ###}, for example, {cmd:171 248 103}; or a valid RRGGBB hex
value in the form {it:######}, for example, {cmd:ABF867}.


{title:Output types for tables}

{phang}
The following output types are supported when creating a new table using
{cmd:putdocx} {cmd:table} {it:tablename}:

{marker nrows/ncols}{...}
{phang2}
{cmd:(}{it:nrows}{cmd:,} {it:ncols}{cmd:)} creates an empty table with
{it:nrows} rows and {it:ncols} columns.  Microsoft Word allows a maximum of
63 columns in a table.

{marker data}{...}
{phang2}
{opt data(varlist)} adds the current Stata dataset in memory as a table to the
active document.  {varlist} contains a list of the variable names from the
current dataset in memory.

{marker matname}{...}
{phang2}
{opt matrix(matname)}
adds a {help matrix} called {it:matname} as a table to the
active document.

{marker mata}{...}
{phang2}
{opt mata(matname)} adds a Mata
{help matrix} called {it:matname} as a table to the active
document.

{marker etable}{...}
{phang2}
{cmd:etable}[{cmd:(}{it:#}_1 {it:#}_2 ...{it:#}_n{cmd:)}] adds an
automatically generated table to the active document.
The table may be derived from the
coefficient table of the last estimation command, from the table of
margins after the last {helpb margins} command,
or from the table of results from one or more models displayed by
{helpb estimates table}.

{pmore2}
If the estimation command outputs n > 1 coefficient tables, the
default is to add all tables and assign the corresponding table names
{it:tablename}{cmd:1}, {it:tablename}{cmd:2}, ..., {it:tablename}_n.  To
specify which tables to add, supply the optional numlist to {cmd:etable}.  For
example, to add only the first and third tables from the estimation output,
specify {cmd:etable(1 3)}.  A few estimation commands do not support the
{cmd:etable} output type.  See
{help putdocx_appendix##Unsupported_estcmds:{it:Unsupported estimation commands}} of {helpb putdocx_appendix:[RPT] Appendix for putdocx}
for a list of estimation commands that have displayed output that is not
supported by {cmd:putdocx}.

{marker returnset}{...}
{phang2}
{it:returnset} exports a group of Stata
{helpb return} values to a table in the active document.  It is
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
{cmd:putdocx table} {it:tablename}{cmd:(}{it:i}{cmd:,} {it:j}{cmd:)}:

{marker expr}{...}
{phang2}
{cmd:(}{help exp:{it:exp}}{cmd:)} writes a valid Stata expression to a cell;
see {findalias frexp}.

{marker image}{...}
{phang2}
{opth image(filename)} adds a portable network graphics ({cmd:.png}),
JPEG ({cmd:.jpg}), Windows metafile ({cmd:.wmf}), device-independent
bitmap ({cmd:.dib}), enhanced metafile ({cmd:.emf}), or bitmap
({cmd:.bmp}) file to the table cell.  If {it:filename} contains spaces, it must
be enclosed in double quotes.

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
{it:tablename}{cmd:(}{it:numlist}_i{cmd:,} {cmd:.)}
specify all cells on the {it:i}th row or
on the rows identified by {it:numlist}_i.

{phang2}
{it:tablename}{cmd:(.,} {it:j}{cmd:)}
and
{it:tablename}{cmd:(.,} {it:numlist}_j{cmd:)}
specify all cells in the {it:j}th column
or
in the columns identified by {it:numlist}_j.

{phang2}
{it:tablename}{cmd:(.,} {cmd:.)} specifies the whole table.


{marker description}{...}
{title:Description}

{pstd}
{cmd:putdocx} {cmd:table} creates and modifies tables in the active 
{cmd:.docx} file.  Tables may be created from several output types, including
the data in memory, matrices, and estimation results.

{pstd}
{cmd:putdocx} {cmd:describe} describes a table within the active {cmd:.docx}
file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection RPT putdocxtableQuickstart:Quick start}

        {mansection RPT putdocxtableRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}
Options are presented under the following headings:

        {help putdocx_table##table_opts:table_options}
        {help putdocx_table##cell_opts:cell_options}
        {help putdocx_table##row_col_opts:row_col_options}
        {help putdocx_table##cell_fmt_opts:cell_fmt_options}
        {help putdocx_table##exp_opts:exp_options}
        {help putdocx_table##image_opts:image_options}


{marker table_opts}{...}
{title:table_options}

{phang}
{opt memtable} specifies that the table be created and held in memory instead
of being added to the active document.  By default, the table is added to the
document immediately after it is created.  This option is useful if the table
is intended to be added to a cell of another table or to be used multiple
times later.

{phang}
{cmd:width(}{it:#}[{help putdocx_table##unit:{it:unit}}{c |}{cmd:%}]{cmd:)}
sets the table width.  {it:#} may be an absolute width or a percentage of the
default table width, which is determined by the page width of the document.
For example, {cmd:width(50%)} sets the table width to 50% of the default
table width.  The default is {cmd:width(100%)}.

{marker table_hvalue}{...}
{phang}
{opt halign(hvalue)} sets the horizontal alignment of the table within
the page.  {it:hvalue} may be {cmd:left}, {cmd:right}, or {cmd:center}.
The default is {cmd:halign(left)}.

{phang}
{cmd:indent(}{it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)} specifies the
table indentation from the left margin of the current document.

{marker layouttype}{...}
{phang}
{opt layout(layouttype)} adjusts the column width of the table.
{it:layouttype} may be {cmd:fixed}, {cmdab:autofitw:indow}, or
{cmdab:autofitc:ontents}.  {cmd:fixed} means the width is the same for all
columns in the table.  When {cmd:autofitwindow} is specified, the
column width automatically resizes to fit the window.  When
{cmd:autofitcontents} is specified, the table width is determined by the
overall table layout algorithm, which automatically resizes the column width
to fit the contents.  The default is {cmd:layout(autofitwindow)}.

{marker cmarg}{...}
{phang}
{cmd:cellmargin(}{it:cmarg}{cmd:,} {it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)}
sets the cell margins for table cells.  {it:cmarg} may be {cmd:top},
{cmd:bottom}, {cmd:left}, or {cmd:right}.  This option may be specified
multiple times in a single command to accommodate different margin settings.

{phang}
{cmd:cellspacing(}{it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)}
sets the spacing between adjacent cells and the edges of the table.

{phang}
{cmd:border(}{it:bordername}
[{cmd:,} {help putdocx_table##bspec:{it:bpattern}}
[{cmd:,} {help putdocx_table##color:{it:bcolor}}
[{cmd:,} {help putdocx_table##bspec:{it:bwidth}}]]]{cmd:)}
adds a single border in the location specified by
{it:bordername}, which may be {cmd:start}, {cmd:end}, {cmd:top},
{cmd:bottom},
{cmd:insideH} (inside horizontal borders),
{cmd:insideV} (inside vertical borders),
or {cmd:all}.
Optionally, you may change the pattern, color, and width for the border
by specifying {it:bpattern}, {it:bcolor}, and {it:bwidth}.

{pmore}
This option may be specified multiple times in a single command to accommodate
different border settings.  If multiple {cmd:border()} options are specified,
they are applied in the order specified from left to right.

{phang}
{opt headerrow(#)} sets the top {it:#} rows to be repeated as header
rows at the top of each page on which the table is displayed.  This setting
has a visible effect only when the table crosses multiple pages.

{phang}
{cmd:varnames} specifies that the variable names be included as the first row
in the table when the table is created using the dataset in memory.  By
default, only the data values are added to the table.

{phang}
{cmd:obsno} specifies that the observation numbers be included as the first
column in the table when the table is created using the dataset in memory.  By
default, only the data values are added to the table.

{phang}
{opth nformat(%fmt)} specifies the numeric format to be applied to the source
values when creating the table from a Stata or Mata matrix.  The default is
{cmd:nformat(%12.0g}).

{phang}
{cmd:rownames} specifies that the row names of the Stata matrix be included as
the first column in the table.  By default, only the matrix values are added to
the table.

{phang}
{cmd:colnames} specifies that the column names of the Stata matrix be included
as the first row in the table.  By default, only the matrix values are added to
the table.

{phang}
{opth title:(strings:string)} inserts a row without borders above the current
table.  The added row spans all the columns of the table and contains
{it:string} as text.  The added row shifts all other table contents down by
one row.  You should account for this when referencing table cells in
subsequent commands.

{phang}
{opth note:(strings:string)} inserts a row without borders to the bottom of
the table.  The added row spans all the columns of the table.  This option may
be specified multiple times in a single command to add notes on new lines
within the same cell.  Note text is inserted in the order it was specified
from left to right.

{marker hname}{...}
{phang}
{opt toheader(hname)} specifies that the table be added to the header
{it:hname}.  The table will not be added to the body of the document.

{marker fname}{...}
{phang}
{opt tofooter(fname)} specifies that the table be added to the footer
{it:fname}.  The table will not be added to the body of the document.


{marker cell_opts}{...}
{title:cell_options}

{phang}
{cmd:append} specifies that the new content for the cell be appended to the
current content of the cell.  If {cmd:append} is not specified, then the
current content of the cell is replaced by the new content.

{phang}
{opt rowspan(#)} sets the specified cell to span vertically {it:#}
cells downward.  If the span exceeds the total number of rows in the table, the
span stops at the last row.

{phang}
{opt colspan(#)} sets the specified cell to span horizontally {it:#}
cells to the right.  If the span exceeds the total number of columns in the
table, the span stops at the last column.

{phang}
{cmd:span(}{it:#}_1{cmd:,} {it:#}_2{cmd:)} sets the specified cell to span
{it:#}_1 cells downward and span {it:#}_2 cells to the right.

{phang}
{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}] specifies that one or {it:#} line
breaks be added after the text, the image, or the table within the cell.


{marker row_col_opts}{...}
{title:row_col_options}

{phang}
{cmd:nosplit} specifies that row {it:i} not split across pages.  When a table
row is displayed, a page break may fall within the contents of a cell on the
row, causing the contents of that cell to be displayed across two pages.
{cmd:nosplit} prevents this behavior.  If the entire row cannot fit on the
current page, the row will be moved to the start of the next page.

{phang}
{cmd:addrows(}{it:#} [{cmd:,} {cmd:before}{c |}{cmd:after}]{cmd:)} adds {it:#}
rows to the current table before or after row {it:i}.  If {cmd:before} is
specified, the rows are added before the specified row.  By default, rows are
added after the specified row.

{phang}
{cmd:addcols(}{it:#} [{cmd:,} {cmd:before}{c |}{cmd:after}]{cmd:)} adds {it:#}
columns to the current table to the right or the left of column {it:j}.  If
{cmd: before} is specified, the columns are added to the left of the specified
column.  By default, the columns are added after, or to the right of, the
specified column.

{phang}
{cmd:drop} deletes row {it:i} or column {it:j} from the table.


{marker cell_fmt_opts}{...}
{title:cell_fmt_options}

{marker cell_hvalue}{...}
{phang}
{opt halign(hvalue)} sets the horizontal alignment of the specified cell
or of all cells in the specified row, column, or range.
{it:hvalue} may be {cmd:left}, {cmd:right}, or {cmd:center}.  The default is
{cmd:halign(left)}.

{marker cell_vvalue}{...}
{phang}
{opt valign(vvalue)} sets the vertical alignment of the specified cell
or of all cells in the specified row, column, or range.
{it:vvalue} may be {cmd:top}, {cmd:bottom}, or {cmd:center}.  The default is
{cmd:valign(top)}.

{phang}
{cmd:border(}{it:bordername}
[{cmd:,} {help putdocx_table##bspec:{it:bpattern}}
[{cmd:,} {help putdocx_table##color:{it:bcolor}}
[{cmd:,} {help putdocx_table##bspec:{it:bwidth}}]]]{cmd:)}
adds a single border to the specified cell or to all cells in the specified
row, column, or range in the given location.  {it:bordername} may be
{cmd:start}, {cmd:end}, {cmd:top}, {cmd:bottom}, or {cmd:all}.  Optionally,
you may change the pattern, color, and width for the border by specifying
{it:bpattern}, {it:bcolor}, and {it:bwidth}.

{pmore}
This option may be specified multiple times in a single command to accommodate
different border settings.  If multiple {cmd:border()} options are specified,
they are applied in the order specified from left to right.

{phang}
{cmd:shading(}{help putdocx_table##color:{it:bgcolor}}
[{cmd:,} {help putdocx_table##color:{it:fgcolor}}
[{cmd:,} {help putdocx_table##fpattern:{it:fpattern}}]]{cmd:)}
sets the background color, foreground color, and fill pattern for the
specified cell or for all cells in the specified row, column, or range.

{phang}
{opth nformat(%fmt)} applies the Stata numeric format {cmd:%}{it:fmt} to
the text within the specified cell or within all cells in the specified row,
column, or range.  This setting only applies when the content of the cell is a
numeric value.

{phang}
{cmd:font(}{help putdocx_table##font:{it:fontname}}
[{cmd:,} {help putdocx_table##size:{it:size}}
[{cmd:,} {help putdocx_table##color:{it:color}}]]{cmd:)}
sets the font, font size, and font color for the current text within the
specified cell or within all cells in the specified row, column, or range.
The font size and font color may be specified individually without
specifying {it:fontname}.  Use {cmd:font("",} {it:size}{cmd:)} to specify font
size only.  Use {cmd:font("", "",} {it:color}{cmd:)} to specify font color
only.  For both cases, the default font will be used.

{phang}
{cmd:bold} applies bold formatting to the current text within the specified
cell or within all cells in the specified row, column, or range.

{phang}
{cmd:italic} applies italic formatting to the current text within the
specified cell or within all cells in the specified row, column, or range.

{phang}
{cmd:script(sub{c |}super)} changes the script style of the current text.
{cmd:script(sub)} makes the text a subscript.  {cmd:script(super)} makes the
text a superscript.  {cmd:script()} may only be specified when formatting a
single cell.

{phang}
{cmd:strikeout} adds a strikeout mark to the current text within the specified
cell or within all cells in the specified row, column, or range.

{marker cell_upattern}{...}
{phang}
{cmd:underline} adds an underline to the current text within the specified
cell or within all cells in the specified row, column, or range.  By default,
a single underline is used.  {opt underline(upattern)} can be used to
change the format of the line, where {it:upattern} may be any of the patterns
listed in {help putdocx_appendix##Underline_patterns:{it:Underline patterns}}
of {helpb putdocx_appendix:[RPT] Appendix for putdocx}.  The most common
patterns are {cmd:double}, {cmd:dash}, and {cmd:none}.

{phang}
{cmd:allcaps} uses capital letters for all letters of the current text within
the specified cell or within all cells in the specified row, column, or range.

{phang}
{cmd:smallcaps} uses capital letters for all letters of the current text
within the specified cell or within all cells in the specified row, column, or
range.  {cmd:smallcaps} uses larger capitals for uppercase letters and smaller
capitals for lowercase letters.


{marker exp_opts}{...}
{title:exp_options}

{phang}
{cmd:pagenumber} specifies that the current page number be appended to
the end of the new content for the cell.  {cmd:pagenumber} applies only to
tables being added to a header or footer and cannot be combined with
{cmd:totalpages}.

{phang}
{cmd:totalpages} specifies that the number of total pages be appended to
the end of the new content for the cell.  {cmd:totalpages} applies only to
tables being added to a header or footer and cannot be combined with
{cmd:pagenumber}.

{phang}
{cmd:trim} removes the leading and trailing spaces in the expression to be
added to the table cell.

{marker link}
{phang}
{opt hyperlink(link)} adds the expression as a hyperlink to the webpage
address specified in {it:link}.


{marker image_opts}{...}
{title:image_options}

{phang}
{cmd:width(}{it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)} sets the width
of the image.  If the width is larger than the width of the cell, then the
width is used.  If {cmd:width()} is not specified, then the default size is
used; the default is determined by the image information and the width of the
cell.

{phang}
{cmd:height(}{it:#}[{help putdocx_table##unit:{it:unit}}]{cmd:)} sets the
height of the image.  If {cmd:height()} is not specified, then the height of
the image is determined by the width and the aspect ratio of the image.

{phang}
{cmd:linebreak}[{cmd:(}{it:#}{cmd:)}] specifies that one or {it:#} line
breaks be added after the new image.

{phang}
{cmd:link} specifies that a link to the image {it:filename} be inserted
into the document.  If the image is linked, then the referenced file
must be present so that the document can display the image.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Create a {cmd:.docx} document in memory{p_end}
{phang2}{cmd:. putdocx begin}{p_end}

{pstd}
Fit a linear regression model of {cmd:mpg} as a function of 
{cmd:weight} and {cmd:foreign}{p_end}
	{cmd:. regress mpg weight foreign}

{pstd}
Export the estimation results to the document as a table with the name {cmd:tbl1}{p_end}
{phang2}{cmd:. putdocx table tbl1 = etable, width(100%)}

{pstd}	
Keep only the point estimates and confidence intervals{p_end}
{phang2}{cmd:. putdocx table tbl1(.,5), drop}{p_end}
{phang2}{cmd:. putdocx table tbl1(.,4), drop}{p_end}
{phang2}{cmd:. putdocx table tbl1(.,3), drop}

{pstd}
Modify the column heading to omit the dependent variable name{p_end}
{phang2}{cmd:. putdocx table tbl1(1,2) = ("")}

{pstd}
Export the first 15 observations of the {cmd:make},
{cmd:price}, and {cmd:mpg} variables from the dataset in memory{p_end}
	{cmd:. putdocx table tbl1 = data("make price mpg") in 1/15, varnames}

{pstd}
Save the document to disk{p_end}
	{cmd:. putdocx save example.docx}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:putdocx describe} {it:tablename} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(nrows)}}number of rows in the table{p_end}
{synopt:{cmd:r(ncols)}}number of columns in the table{p_end}
{p2colreset}{...}
