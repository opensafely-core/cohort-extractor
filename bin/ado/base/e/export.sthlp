{smcl}
{* *! version 1.0.11  15jun2019}{...}
{vieweralsosee "[D] export" "mansection D export"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] _docx*()" "help mf_docx"}{...}
{vieweralsosee "[RPT] dyndoc" "help dyndoc"}{...}
{vieweralsosee "[RPT] putdocx intro" "help putdocx intro"}{...}
{vieweralsosee "[RPT] putexcel" "help putexcel"}{...}
{vieweralsosee "[RPT] putpdf intro" "help putpdf intro"}{...}
{vieweralsosee "[M-5] xl()" "help mf_xl"}{...}
{viewerjumpto "Description" "export##description"}{...}
{viewerjumpto "Links to PDF documentation" "export##linkspdf"}{...}
{viewerjumpto "Summary of the different methods" "export##summary"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] export} {hline 2}}Overview of exporting data from Stata
{p_end}
{p2col:}({mansection D export:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry provides a quick reference for determining which method to use for
exporting Stata data from memory to other formats.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D exportRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker summary}{...}
{title:Summary of the different methods}


{title:export excel}

{phang}
1.  {opt export excel} creates Microsoft Excel worksheets in {cmd:.xls}
    and {cmd:.xlsx} files.

{phang}
2.  Entire worksheets can be exported, or custom cell ranges can be overwritten.

{phang}
See {manhelp import_excel D:import excel}.

{title:export delimited}

{phang}
1.  {opt export delimited} creates comma-separated or tab-delimited files
that many other programs can read.

{phang}
2.  A custom delimiter may also be specified.

{phang}
3.  The first line of the file can optionally contain the names of the
variables.

{phang}
See {manhelp import_delimited D:import delimited}.

{title:odbc}

{phang}
1.  ODBC, an acronym for Open DataBase Connectivity, is a standard for
exchanging data between programs.  Stata supports the ODBC standard for
exporting data via the {opt odbc} command and can write to any ODBC data
source on your computer.

{phang}
See {manhelp odbc D}.

{title:outfile}

{phang}
1.  {cmd:outfile} creates text-format datasets.

{phang}
2.  The data can be written in space-separated or comma-separated format.

{phang}
3.  Alternatively, the data can be written in fixed-column format.

{phang}
See {manhelp outfile D}.

{title:export sasxport5 and export sasxport8}

{phang}
1.  {cmd:export sasxport5} saves SAS XPORT Version 5 Transport format files.

{phang}
2.  {cmd:export sasxport5} can also write value-label information to a
{cmd:formats.xpf} XPORT file.

{phang}
3.  {cmd:export sasxport8} saves SAS XPORT Version 8 Transport format files.

{phang}
4.  {cmd:export sasxport8} can also write value-label information to a SAS
command ({cmd:.sas}) file.

{phang}
See {manhelp import_sasxport5 D:import sasxport5} and
{manhelp import_sasxport8 D:import sasxport8}.

{title:export dbase}

{phang}
1.  {opt export dbase} saves version IV dbase ({cmd:.dbf}) files.

{phang}
See {manhelp import_dbase D:import dbase}.
{p_end}
