{smcl}
{* *! version 1.1.20  04may2019}{...}
{vieweralsosee "[D] import" "mansection D import"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] edit" "help edit"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] input" "help input"}{...}
{viewerjumpto "Description" "import##description"}{...}
{viewerjumpto "Links to PDF documentation" "import##linkspdf"}{...}
{viewerjumpto "Summary of the different methods" "import##summary"}{...}
{viewerjumpto "Video example" "import##video"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] import} {hline 2}}Overview of importing data into Stata
{p_end}
{p2col:}({mansection D import:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This entry provides a quick reference for determining which method to use for
reading non-Stata data into memory.
See {findalias frdatain} for more details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker summary}{...}
{title:Summary of the different methods}


{title:import excel}

{phang}
1.  {opt import excel} reads worksheets from Microsoft Excel ({cmd:.xls}
    and {cmd:.xlsx}) files.

{phang}
2.  Entire worksheets can be read, or custom cell ranges can be read.

{phang}
See {manhelp import_excel D:import excel}.

{title:import delimited}

{phang}
1.  {opt import delimited} reads text-delimited files.

{phang}
2.  The data can be tab-separated or comma-separated.
A custom delimiter may also be specified.

{phang}
3.  An observation must be on only one line.

{phang}
4.  The first line of the file can optionally contain the names of the
variables.

{phang}
See {manhelp import_delimited D:import delimited}.

{title:odbc}

{phang}
1.  ODBC, an acronym for Open DataBase Connectivity, is a standard for
exchanging data between programs.  Stata supports the ODBC standard for
importing data via the {opt odbc} command and can read from any ODBC data
source on your computer.

{phang}
See {manhelp odbc D}.

{title:infile (free format) -- infile without a dictionary}

{phang}
1.  The data can be space-separated, tab-separated, or comma-separated.

{phang}
2.  Strings with embedded spaces or commas must be enclosed in quotes
(even if tab- or comma-separated).

{phang}
3.  An observation can be on more than one line, or there can even be
multiple observations per line.

{phang}
See {help infile1}.

{title:infix (fixed format)}

{phang}
1.  The data must be in fixed-column format.

{phang}
2.  An observation can be on more than one line.

{phang}
3.  {opt infix} has simpler syntax than {opt infile} (fixed format).

{phang}
See {manhelp infix D:infix (fixed format)}.

{title:infile (fixed format) -- infile with a dictionary}

{phang}
1.  The data may be in fixed-column format.

{phang}
2.  An observation can be on more than one line.

{phang}
3.  ASCII or EBCDIC data can be read.

{phang}
4.  {opt infile} (fixed format) has the most capabilities for reading data.

{phang}
See {help infile2}.

{title:import sas}

{phang}
1.  {cmd:import sas} reads Version 7 SAS ({cmd:.sas7bdat}) files.

{phang}
2.  {cmd:import sas} will also read value-label information from
a {cmd:.sas7bcat} file.

{phang}
See {manhelp import_sas D:import sas}.

{title:import sasxport5 and import sasxport8}

{phang}
1.  {cmd:import sasxport5} reads SAS XPORT Version 5 Transport format files.

{phang}
2.  {cmd:import sasxport5} will also read value-label information from a
{cmd:formats.xpf} XPORT file.

{phang}
3.  {cmd:import sasxport8} reads SAS XPORT Version 8 Transport format files.

{phang}
See {manhelp import_sasxport5 D:import sasxport5} and
{manhelp import_sasxport8 D:import sasxport8}.

{title:import spss}

{phang}
1.  {cmd:import spss} reads IBM SPSS Statistics ({cmd:.sav} and {cmd:.zsav})
files.

{phang}
See {manhelp import_spss D:import spss}.

{title:import fred}

{phang}
1.  {opt import fred} reads Federal Reserve Economic Data.

{phang}
2.  To use {opt import fred}, you must have a valid API key obtained from the
    St. Louis Federal Reserve.

{phang}
See {manhelp import_fred D:import fred}.

{title:import haver (Windows only)}

{phang}
1.  {opt import haver} reads Haver Analytics ({browse "http://www.haver.com/"})
    database files.

{phang}
See {manhelp import_haver D:import haver}.

{title:import dbase}

{phang}
1.  {opt import dbase} reads a version III or version IV dBase ({cmd:.dbf})
    file.

{phang}
See {manhelp import_dbase D:import dbase}.

{title:spshape2dta}

{phang}
1.  {opt spshape2dta} translates the {cmd:.dbf} and {cmd:.shp} files of a
shapefile into two Stata datasets.

{phang}
See {manhelp spshape2dta SP}.


{marker video}{...}
{title:Video example}

{phang}
{browse "http://www.youtube.com/watch?v=iCvZ9pvPy-8":Copy/paste data from Excel into Stata}
{p_end}
