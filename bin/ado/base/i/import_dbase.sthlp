{smcl}
{* *! version 1.0.8  17sep2019}{...}
{viewerdialog "import dbase" "dialog import_dbase"}{...}
{viewerdialog "export dbase" "dialog export_dbase"}{...}
{vieweralsosee "[D] import dbase" "mansection D importdbase"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[SP] spshape2dta" "help spshape2dta"}{...}
{viewerjumpto "Syntax" "import_dbase##syntax"}{...}
{viewerjumpto "Menu" "import_dbase##menu"}{...}
{viewerjumpto "Description" "import_dbase##description"}{...}
{viewerjumpto "Links to PDF documentation" "import_dbase##linkspdf"}{...}
{viewerjumpto "Options for import dbase" "import_dbase##import_options"}{...}
{viewerjumpto "Options for export dbase" "import_dbase##export_options"}{...}
{viewerjumpto "Remarks" "import_dbase##remarks"}{...}
{viewerjumpto "Examples" "import_dbase##examples"}{...}
{viewerjumpto "Stored results" "import_dbase##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[D] import dbase} {hline 2}}Import and export dBase files{p_end}
{p2col:}({mansection D importdbase:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Load a dBase file

{p 8 32 2}
{cmd:import} {cmd:dbase}
[{cmd:using}] {it:{help filename}}
[{cmd:,} {cmd:clear} {cmd:case(preserve}|{cmd:lower}|{cmd:upper)}]


{pstd}
Save data in memory to a dBase file

{p 8 32 2}
{cmd:export} {cmd:dbase}
[{cmd:using}] {it:{help filename}}
{ifin}
[{cmd:,} {opt dataf:mt} {cmd:replace}]


{pstd}
Save subset of variables in memory to a dBase file

{p 8 32 2}
{cmd:export} {cmd:dbase}
[{varlist}] {cmd:using} {it:{help filename}}
{ifin}
[{cmd:,} {opt dataf:mt} {cmd:replace}]


{phang}
If {it:{help filename}} is specified without an extension, {cmd:.dbf} is
assumed for both {cmd:import dbase} and {cmd:export dbase}.  If
{it:filename} contains embedded spaces, enclose it in double quotes.


{marker menu}{...}
{title:Menu}

    {title:import dbase}

{phang2}
{bf:File > Import > dBase (*.dbf)}

    {title:export dbase}

{phang2}
{bf:File > Export > dBase (*.dbf)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:import dbase} reads into memory a version III or version IV dBase
({cmd:.dbf}) file.  {cmd:export dbase} exports data in memory to a version IV
dBase ({cmd:.dbf}) file.

{pstd}
Stata has other commands for importing data.  If you are not sure that
{cmd:import dbase} will do what you are looking for, see {manhelp import D}
and {findalias frdatain}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importdbaseQuickstart:Quick start}

{pstd}
The above sections are not included in this help file.


{marker import_options}{...}
{title:Options for import dbase}

{phang}
{opt clear} specifies that it is okay to replace the data in memory,
even though the current data have not been saved to disk.

{phang}
{cmd:case(preserve}|{cmd:lower}|{cmd:upper)} specifies the case of
the variable names after import.  The default is {cmd:case(preserve)}.


{marker export_options}{...}
{title:Options for export dbase}

{phang}
{opt datafmt} specifies that all variables be exported using their display
format.  For example, the number 1000 with a display format of {cmd:%7.2f}
would export as {cmd:1000.00}, not {cmd:1000}. The default is to use the raw,
unformatted value when exporting.

{phang}
{opt replace} specifies that {it:{help filename}} be replaced if it already
exists.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:import dbase} reads into memory a version III or version IV dBase
({cmd:.dbf}) file.  If the dBase file is not version III or IV,
{cmd:import dbase} will issue an error.  dBase files are often paired with
shapefiles for storing geometric location data.  To import a shapefile, see
{manhelp spshape2dta SP}.

{pstd}
{cmd:export dbase} exports data in memory to a version IV dBase ({cmd:.dbf})
file.  dBase version IV has several file limitations when exporting.

        1.  Unicode is not supported.
        2.  Data cannot be more than 2 GB in size.
        3.  Data in memory must be less than 1,000,000,000 observations.
        4.  Data in memory must have less than 255 variables.
        5.  Variable names cannot exceed 10 characters in length.
        6.  Maximum string variable length is 255 characters.
        7.  Data width must be less than 4,000.

{pstd}
If your data in memory exceed any of these limits, {cmd:export dbase} will
issue an error when trying to export the data.


{marker examples}{...}
{title:Examples}

{pstd}
Setup

{phang2}{cmd:. webuse autornd}{p_end}

{pstd}
Export the dataset to dBase file {cmd:auto.dbf}

{phang2}{cmd:. export dbase auto.dbf}{p_end}

{pstd}
Export only variables {cmd:make} and {cmd:weight} to {cmd:auto2.dbf}

{phang2}{cmd:. export dbase make weight using auto2.dbf}{p_end}

{pstd}
Import {cmd:auto.dbf} back into Stata

{phang2}{cmd:. import dbase auto, clear}

{pstd}
List the data loaded from {cmd:auto.dbf}

{phang2}{cmd:. list}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:import dbase} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations imported{p_end}
{synopt :{cmd:r(k)}}number of variables imported{p_end}
{p2colreset}{...}
