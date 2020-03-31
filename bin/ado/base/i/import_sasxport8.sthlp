{smcl}
{* *! version 1.0.0  20apr2019}{...}
{viewerdialog "import sasxport8" "dialog import_sasxport8"}{...}
{viewerdialog "export sasxport8" "dialog export_sasxport8"}{...}
{vieweralsosee "[D] import sasxport8" "mansection D importsasxport8"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import sas" "help import sas"}{...}
{vieweralsosee "[D] import sasxport5" "help import sasxport5"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "import_sasxport8##syntax"}{...}
{viewerjumpto "Menu" "import_sasxport8##menu"}{...}
{viewerjumpto "Description" "import_sasxport8##description"}{...}
{viewerjumpto "Links to PDF documentation" "import_sasxport8##linkspdf"}{...}
{viewerjumpto "Options for import sasxport8" "import_sasxport8##options_import"}{...}
{viewerjumpto "Options for export sasxport8" "import_sasxport8##options_export"}{...}
{viewerjumpto "Examples" "import_sasxport8##examples"}{...}
{viewerjumpto "Stored results" "import_sasxport8##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[D] import sasxport8} {hline 2}}Import and export data in SAS XPORT Version 8 format{p_end}
{p2col:}({mansection D importsasxport8:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Import SAS XPORT Version 8 Transport file into Stata

{p 8 16 2}
{cmd:import sasxport8}
{it:{help filename}}
[{cmd:,} {it:{help import_sasxport8##import_options:import_options}}]


{phang}
Export data in memory to a SAS XPORT Version 8 Transport file

{p 8 16 2}
{cmd:export sasxport8}
{it:{help filename}}
{ifin}
[{cmd:,} {it:{help import_sasxport8##export_options:export_options}}]

{p 8 16 2}
{cmd:export sasxport8}
{varlist}
{cmd:using} {it:{help filename}}
{ifin}
[{cmd:,} {it:{help import_sasxport8##export_options:export_options}}]


{phang}
If {it:{help filename}} is specified without an extension, {cmd:.v8xpt} is
assumed. If {it:filename} contains embedded spaces, enclose it in double
quotes.


{synoptset 26}{...}
{marker import_options}{...}
{synopthdr :import_options}
{synoptline}
{synopt :{cmd:case(}{cmdab:l:ower}{c |}{cmdab:u:pper}{c |}{cmdab:pre:serve)}}read variable names as lowercase or uppercase; the default is to preserve the case{p_end}
{synopt :{opt clear}}replace data in memory{p_end}
{synoptline}

{synoptset 26 tabbed}{...}
{marker export_options}{...}
{synopthdr :export_options}
{synoptline}
{syntab:Main}
{synopt :{opt replace}}overwrite files if they already exist{p_end}
{synopt :{opt vall:abfile}}save value labels in SAS command file{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

    {title:import sasxport8}

{phang2}
{bf:File > Import > SAS XPORT Version 8 (*.v8xpt)}

    {title:export sasxport8}

{phang2}
{bf:File > Export > SAS XPORT Version 8 (*.v8xpt)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:import sasxport8} and {cmd:export sasxport8} import and export data from
and to SAS XPORT Version 8 Transport format.

{pstd}
To import and export datasets from and to SAS XPORT Version 5 Transport
format, see {helpb import_sasxport5:[D] import sasxport5}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importsasxport8Quickstart:Quick start}

        {mansection D importsasxport8Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_import}{...}
{title:Options for import sasxport8}

{phang}
{cmd:case(lower}{c |}{cmd:upper}{c |}{cmd:preserve)} specifies the case of the
variable names after import. The default is {cmd:case(preserve)}.

{phang}
{cmd:clear} specifies that it is okay to replace the data in memory, even
though the current data have not been saved to disk.


{marker options_export}{...}
{title:Options for export sasxport8}

{dlgtab:Main}

{phang}
{opt replace} permits {cmd:export sasxport8} to overwrite the existing
{it:{help filename}}{cmd:.v8xpt}.

{phang}
{cmd:vallabfile} specifies that the value labels be written into a SAS
command file, {it:filename}{cmd:.sas}, containing SAS {cmd:proc format} and
related commands. Thus, {cmd:export sasxport8} creates two files:
{it:filename}{cmd:.v8xpt}, containing the data, and  {it:filename}{cmd:.sas},
containing the value labels. SAS users may wish to edit the resulting
{it:filename}{cmd:.sas} file to change the "libname datapath" and "libname
xptfile xport" lines at the top to correspond to the location that they
desire. {cmd:export sasxport8} sets the location to the current working
directory at the time {cmd:export sasxport8} was issued. No {cmd:.sas} file
will be created if there are no value labels.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto}

{pstd}Export these data to a SAS V8XPORT named {cmd:auto.v8xpt}{p_end}
{phang2}{cmd:. export sasxport8 auto}

{pstd}Export a subset of the data that includes {cmd:make}, {cmd:mpg}, and
{cmd:weight} to {cmd:auto_sub.v8xpt}{p_end}
{phang2}{cmd:. export sasxport8 make mpg weight using auto_sub}

{pstd}
Read data from {cmd:auto_sub.v8xpt}{p_end}
{phang2}{cmd:. import sasxport8 auto_sub, clear}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:import sasxport8} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations imported{p_end}
{synopt :{cmd:r(k)}}number of variables imported{p_end}
{p2colreset}{...}
