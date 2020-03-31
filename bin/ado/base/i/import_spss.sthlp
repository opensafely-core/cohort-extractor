{smcl}
{* *! version 1.0.1  22aug2019}{...}
{viewerdialog "import spss" "dialog import_spss_dlg"}{...}
{vieweralsosee "[D] import spss" "mansection D importspss"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "import_spss##syntax"}{...}
{viewerjumpto "Menu" "import_spss##menu"}{...}
{viewerjumpto "Description" "import_spss##description"}{...}
{viewerjumpto "Links to PDF documentation" "import_spss##linkspdf"}{...}
{viewerjumpto "Options" "import_spss##options"}{...}
{viewerjumpto "Examples" "import_spss##examples"}{...}
{viewerjumpto "Stored results" "import_spss##results"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[D] import spss} {hline 2}}Import SPSS files{p_end}
{p2col:}({mansection D importspss:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Load an IBM SPSS Statistics file (*.sav)

{p 8 16 2}
{cmd:import spss}
[{cmd:using}] {it:{help filename}}
[{cmd:,} {it:options}]


{phang}
Load a compressed IBM SPSS Statistics file (*.zsav)

{p 8 16 2}
{cmd:import spss}
[{cmd:using}] {it:{help filename}}{cmd:, zsav}
[{it:options}]


{phang}
Load a subset of an IBM SPSS Statistics file (*.sav)

{p 8 16 2}
{cmd:import spss}
[{help import spss##namelist:{it:namelist}}] 
{ifin}
{cmd:using} {it:{help filename}}
[{cmd:,} {it:options}]


{phang}
Load a subset of a compressed IBM SPSS Statistics file (*.zsav)

{p 8 16 2}
{cmd:import spss}
[{help import spss##namelist:{it:namelist}}]
{ifin}
{cmd:using} {it:{help filename}}{cmd:, zsav}
[{it:options}]


{phang}
If {it:{help filename}} is specified without an extension, {cmd:.sav} is
assumed unless you specify the {cmd:zsav} option, in which case extension 
{cmd:.zsav} is assumed.  If {it:filename} contains embedded spaces, enclose 
it in double quotes.

{marker namelist}{...}
{phang}
{it:namelist} specifies SPSS variable names to be imported.

{marker import_spss_options}{...}
{synoptset 26}{...}
{synopthdr :options}
{synoptline}
{synopt :{cmd:case(}{cmdab:l:ower}{c |}{cmdab:u:pper}{c |}{cmdab:pre:serve)}}read variable names as lowercase or uppercase;
the default is to preserve the case{p_end}
{synopt :{opt clear}}replace data in memory{p_end}

{synopt :{cmd:encoding("}{help encodings:{it:encoding}}{cmd:")}}specify the file encoding{p_end}
{synoptline}
{p 4 6 2}
{opt encoding()} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Import > SPSS data (*.sav)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:import spss} reads into memory a version 16 or higher IBM SPSS
Statistics ({cmd:.sav}) file or a version 21 or higher compressed IBM
SPSS Statistics ({cmd:.zsav}) file.  {cmd:import spss} can import up to 32,766
variables at one time (up to 2,048 in Stata/IC).  If your SPSS file
contains more variables than this, you can break up the SPSS file into
multiple Stata datasets.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importspssQuickstart:Quick start}

        {mansection D importspssRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:zsav} indicates the file to load is a compressed IBM SPSS
Statistics file.

{phang}
{cmd:case(lower}{c |}{cmd:upper}{c |}{cmd:preserve)} specifies the case of the
    variable names after import.  The default is {cmd:case(preserve)}.

{phang}
{cmd:clear}
    specifies that it is okay to replace the data in memory, even though the
    current data have not been saved to disk.

{pstd}
The following option is available with {opt import spss} but is not shown in
the dialog box:

{phang}
{opt encoding("encoding")} specifies the encoding of the file.  If your file
has an incorrect encoding specified in the file header, you can use this
option to specify the correct encoding.  See {help encodings} for details.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata.com/sampledata/auto.sav auto.sav}

{pstd}Load the entire {cmd:auto.sav} file into Stata{p_end}
{phang2}{cmd:. import spss auto}

{pstd}Load only a subset of the data that includes {cmd:make} and {cmd:weight}
{p_end}
{phang2}{cmd:. import spss make weight using auto, clear}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:import spss} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations imported{p_end}
{synopt :{cmd:r(k)}}number of variables imported{p_end}
{p2colreset}{...}
