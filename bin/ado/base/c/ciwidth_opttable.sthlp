{smcl}
{* *! version 1.0.0  27feb2019}{...}
{viewerdialog ciwidth "dialog ciwidth_dlg"}{...}
{vieweralsosee "[PSS-3] ciwidth, table" "mansection PSS-3 ciwidth,table"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[PSS-3] ciwidth" "help ciwidth"}{...}
{vieweralsosee "[PSS-3] ciwidth, graph" "help ciwidth_optgraph"}{...}
{viewerjumpto "Syntax" "ciwidth_opttable##syntax"}{...}
{viewerjumpto "Menu" "ciwidth_opttable##menu"}{...}
{viewerjumpto "Description" "ciwidth_opttable##description"}{...}
{viewerjumpto "Links to PDF documentation" "ciwidth_opttable##linkspdf"}{...}
{viewerjumpto "Suboptions" "ciwidth_opttable##suboptions"}{...}
{viewerjumpto "Examples" "ciwidth_opttable##examples"}{...}
{viewerjumpto "Stored results" "ciwidth_opttable##results"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[PSS-3] ciwidth, table} {hline 2}}Produce table of the results from
the ciwidth command{p_end}
{p2col:}({mansection PSS-3 ciwidth,table:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Produce default table 

{p 8 16 2}
{opt ciwidth} ... {cmd:,} {cmdab:tab:le} ...


{phang}
Suppress table

{p 8 16 2}
{opt ciwidth} ... {cmd:,} {cmdab:notab:le} ...
  

{marker tablespec}{...}
{phang}
Produce custom table

{p 8 16 2}
{opt ciwidth} ... {cmd:,} {cmdab:tab:le(}[{it:colspec}] [{cmd:,} {it:{help ciwidth_opttable##tableopts:tableopts}}]{cmd:)} ...


{marker colspec}{...}
{pstd}
where {it:colspec} is

{p 16 16 2}
{it:{help ciwidth_opttable##column:column}}[{cmd::}{it:label}] [{it:column}[{cmd::}{it:label}] [...]]

{pstd}
{it:column} is one of the columns defined {help ciwidth_opttable##column:below},
and {it:label} is a column label (may contain quotes and compound quotes).

{synoptset 28 tabbed}{...}
{marker tableopts}{...}
{synopthdr:tableopts}
{synoptline}
{syntab:Table}
{synopt: {cmd:add}}add {it:column}s to the default table{p_end}
{synopt: {opth lab:els(ciwidth_opttable##labspec:labspec)}}change default labels
for specified columns; default labels are column names{p_end}
{synopt: {opth wid:ths(ciwidth_opttable##widthspec:widthspec)}}change default
column widths; default is specific to each column{p_end}
{synopt: {opth f:ormats(ciwidth_opttable##fmtspec:fmtspec)}}change default
column formats; default is specific to each column{p_end}
{synopt:{opt noformat}}do not use default column formats{p_end}
{synopt: {opt sep:arator(#)}}draw a horizontal separator line every {it:#}
lines; default is {cmd:separator(0)}, meaning no separator lines{p_end}
{synopt:{opt div:ider}}draw divider lines between columns{p_end}
{synopt:{opt byrow}}display rows as computations are performed; 
seldom used{p_end}
{synopt:{opt nohead:er}}suppress table header; seldom used{p_end}
{synopt:{opt cont:inue}}draw a continuation border in the table output;
    seldom used{p_end}
{synoptline}
{p 4 6 2}
{cmd:noheader} and {cmd:continue} are not shown in the dialog box.
{p_end}

{synoptset 28}{...}
{marker column}{...}
{synopthdr :column}
{synoptline}
{synopt :{opt level}}confidence level{p_end}
{synopt :{opt alpha}}significance level{p_end}
{synopt :{opt N}}total number of subjects{p_end}
{synopt :{opt N1}}number of subjects in the control group{p_end}
{synopt :{opt N2}}number of subjects in the experimental group{p_end}
{synopt :{opt nratio}}ratio of sample sizes, experimental to control{p_end}
{synopt :{opt Pr_width}}probability of CI width{p_end}
{synopt :{opt width}}CI width{p_end}
{synopt :{opt _all}}display all supported columns{p_end}
{synopt :{it:method_columns}}columns specific to the 
{help ciwidth##method:method} specified with {cmd:ciwidth}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
By default, the following columns are displayed:{p_end}
{phang2}
{cmd:level}, {cmd:width}, and {cmd:N} are always displayed;{p_end}
{phang2}
{cmd:N1} and {cmd:N2} are displayed for two-sample methods;{p_end}
{phang2}
additional columns specific to each {cmd:ciwidth} {help ciwidth##method:method}
may be displayed.{p_end}


INCLUDE help menu_pss


{marker description}{...}
{title:Description}

{pstd}
{cmd:ciwidth, table} displays results in a tabular format.  {cmd:table} is
implied if any of the {cmd:ciwidth} command's arguments or options contain more
than one element.  The {cmd:table} option is useful if you are producing
graphs and would like to see the table as well or if you are producing results
one case at a time using a loop and wish to display results in a table.  The
{cmd:notable} option suppresses table results; it is implied with the
graphical output of {cmd:ciwidth, graph}; see
{manhelp ciwidth_optgraph PSS-3:ciwidth, graph}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection PSS-3 ciwidth,tableRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker suboptions}{...}
{title:Suboptions}

{pstd}
The following are suboptions within the {cmd:table()} option of the 
{cmd:ciwidth} command.

{dlgtab:Table}

{phang}
{cmd:add} requests that the columns specified in 
{it:{help ciwidth_opttable##colspec:colspec}} be added to the default table.  The
columns are added to the end of the table.

{marker labspec}{...}
{phang}
{opt labels(labspec)} specifies labels to be used in the table for the
specified columns.  {it:labspec} is

{pmore}
{it:{help ciwidth_opttable##column:column}} {cmd:"}{it:label}{cmd:"} [{it:column} {cmd:"}{it:label}{cmd:"} [...]]

{pmore}
{cmd:labels()} takes precedence over the specification of column labels
in {it:{help ciwidth_opttable##colspec:colspec}}.

{marker widthspec}{...}
{phang}
{opt widths(widthspec)} specifies column widths.  The default values are the
widths of the default column formats plus one.  If the {cmd:noformat} option
is used, the default for each column is nine.  The column widths are adjusted
to accommodate longer column labels and larger format widths.  {it:widthspec}
is either a list of values including missing values ({it:{help numlist}}) or

{pmore}
{it:{help ciwidth_opttable##column:column}} {it:#} [{it:column} {it:#} [...]]

{pmore}
For the value-list specification, the number of specified values may not
exceed the number of columns in the table.  A missing value ({cmd:.}) may be
specified for any column to indicate the default width.  If fewer widths are
specified than the number of columns in the table, the last width specified is
used for the remaining columns.

{pmore}
The alternative column-list specification provides a way to change widths
of specific columns.

{marker fmtspec}{...}
{phang}
{opt formats(fmtspec)} specifies column formats.  The default is {cmd:%7.0gc}
for integer-valued columns and {cmd:%7.4g} for real-valued columns.
{it:fmtspec} is either a list of string value-list of
{help format:format}s that may include empty strings or a column list:

{pmore}
{it:{help ciwidth_opttable##column:column}} {cmd:"}{it:{help format:fmt}}{cmd:"} [{it:column} {cmd:"}{it:fmt}{cmd:"} [...]]

{pmore}
For the value-list specification, the number of specified values may not
exceed the number of columns in the table.  Am empty string ({cmd:""}) may be
specified for any column to indicate the default format.  If fewer formats are
specified than the number of columns in the table, the last format specified
is used for the remaining columns.

{pmore}
The alternative column-list specification provides a way to change
formats of specific columns.

{phang}
{opt noformat} requests that the default formats not be applied to the column
values.  If this suboption is specified, the column values are based on the
column width.

{phang}
{opt separator(#)} specifies how often separator lines should be drawn between
rows of the table.  The default is {cmd:separator(0)}, meaning that no
separator lines should be displayed.

{phang}
{opt divider} specifies that divider lines be drawn between columns.  The
default is no dividers.

{phang}
{opt byrow} specifies that table rows be displayed as computations are
performed.  By default, the table is displayed after all computations are
performed.  This suboption may be useful when the computation of each row of the
table takes a long time.

{pstd}
The following suboptions are available but are not shown in the dialog box:

{phang}
{cmd:noheader} prevents the table header from displaying.  This suboption is
useful when the command is issued repeatedly, such as within a loop.

{phang}
{cmd:continue} draws a continuation border at the bottom of the table.  This
suboption is useful when the command is issued repeatedly, such as  within a
loop.


{marker examples}{...}
{title:Examples}

{pstd}
These examples are intended for quick reference.  For a conceptual overview of
{cmd:ciwidth, table} and examples with discussion, see
{mansection PSS-3 ciwidth,tableRemarksandexamples:{it:Remarks and examples}}
in {bf:[PSS-3] ciwidth, table}.

{pstd}
    Display results in a table{p_end}
{phang2}{cmd:. ciwidth onemean, n(80) width(4) table}{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)80) width(4) sd(8)}

{pstd}
    Change labels of specified columns{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)80) width(4) sd(8)}
       {cmd:table(, labels(N "Sample size" sd "Std. Dev."))}

{pstd}
    Same as above, also changing widths or formats of some columns{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)80) width(4) sd(8)}
       {cmd:table(, labels(N "Sample size" sd "Std. Dev.")}
       {cmd:widths(N 14 sd 14) formats(Pr_width "%5.2f"))}

{pstd}
    Add an additional column not shown by default{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)80) width(4) sd(8)}
       {cmd:table(alpha, add)}

{pstd}
    Produce a customized table with only the specified columns{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)80) width(4) sd(8)}
       {cmd:table(N:"Sample size" Pr_width width:"CI width", }
       {cmd:widths(. 12))}

{pstd}
    Draw a separator line after every line{p_end}
{phang2}{cmd:. ciwidth onemean, n(50(10)80) width(4) sd(8)}
       {cmd:table(, separator(1))}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:ciwidth, table} stores the following in {cmd:r()} in addition to other
results stored by {helpb ciwidth##results:ciwidth}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
INCLUDE help pss_rrestab_sc.ihlp

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
INCLUDE help pss_rrestab_mac.ihlp

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
INCLUDE help pss_rrestab_mat.ihlp
{p2colreset}{...}
