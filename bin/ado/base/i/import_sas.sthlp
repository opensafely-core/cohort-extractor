{smcl}
{* *! version 1.0.2  30sep2019}{...}
{viewerdialog "import sas" "dialog import_sas_dlg"}{...}
{vieweralsosee "[D] import sas" "mansection D importsas"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import sasxport5" "help import sasxport5"}{...}
{vieweralsosee "[D] import sasxport8" "help import sasxport8"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "import_sas##syntax"}{...}
{viewerjumpto "Menu" "import_sas##menu"}{...}
{viewerjumpto "Description" "import_sas##description"}{...}
{viewerjumpto "Links to PDF documentation" "import_sas##linkspdf"}{...}
{viewerjumpto "Options" "import_sas##options"}{...}
{viewerjumpto "Examples" "import_sas##examples"}{...}
{viewerjumpto "Stored results" "import_sas##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[D] import sas} {hline 2}}Import SAS files{p_end}
{p2col:}({mansection D importsas:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Load a SAS file (*.sas7bdat)

{p 8 16 2}
{cmd:import sas}
[{cmd:using}] {it:{help filename}}
[{cmd:,} {it:options}]


{phang}
Load a subset of a SAS file (*.sas7bdat)

{p 8 16 2}
{cmd:import sas}
[{help import sas##namelist:{it:namelist}}]
{ifin}
{cmd:using} {it:{help filename}}
[{cmd:,} {it:options}]


{phang}
If {it:{help filename}} is specified without an extension, {cmd:.sas7bdat} is
assumed.  If {it:filename} contains embedded spaces, enclose it in double
quotes.

{marker namelist}{...}
{phang}
{it:namelist} specifies SAS variable names to be imported.

{synoptset 26}{...}
{marker import_sas_options}{...}
{synopthdr}
{synoptline}
{synopt :{opt bcat(filename_vl)}}load value labels defined in {it:filename_vl}
into memory{p_end}
{synopt :{cmd:case(}{cmdab:low:er}{c |}{cmdab:u:pper}{c |}{cmdab:pre:serve)}}read variable names as lowercase or uppercase;
the default is to preserve the case{p_end}
{synopt :{opt clear}}replace data in memory{p_end}

{synopt :{cmd:encoding("}{help encodings:{it:encoding}}{cmd:")}}specify the file encoding{p_end}
{synoptline}
{p 4 6 2}
{opt encoding()} does not appear in the dialog box.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:File > Import > SAS data (*.sas7bdat)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:import sas} reads into memory a version 7 or higher SAS {cmd:(.sas7bdat)}
file.  It can also import SAS value labels from a {cmd:.sas7bcat} file.
{cmd:import sas} can import up to 32,766 variables at one time (up to 2,048
variables in Stata/IC).  If your SAS file contains more variables than this,
you can break up the SAS file into multiple Stata datasets.  You can also
import SAS value labels from a {cmd:.sas7bcat} file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importsasQuickstart:Quick start}

        {mansection D importsasRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt bcat(filename_vl)} specifies that the value labels defined in
{it:filename_vl} be loaded into memory along with the dataset.  If
{it:filename_vl} is specified without an extension, {cmd:.sas7bcat} is
assumed.  If {it:filename_vl} contains embedded spaces, enclose it in double
quotes.

{pmore}
SAS does not assign value labels to variables; therefore, you must use
the {helpb label values} command to assign
the value labels to specific variables after importing them.

{phang}
{cmd:case(lower}{c |}{cmd:upper}{c |}{cmd:preserve)} specifies the case of the
variable names after import.  The default is {cmd:case(preserve)}.

{phang}
{cmd:clear} specifies that it is okay to replace the data in memory, even
though the current data have not been saved to disk.

{pstd}
The following option is available with {opt import sas} but is not shown in
the dialog box:

{phang}
{opt encoding("encoding")} specifies the encoding of the file.  If your file
has an incorrect encoding specified in the file header, you can use this
option to specify the correct encoding.  See {help encodings} for details.

{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata.com/sampledata/auto.sas7bdat auto.sas7bdat}{p_end}
{phang2}{cmd:. copy https://www.stata.com/sampledata/formats.sas7bcat formats.sas7bcat}

{pstd}Load the entire {cmd:auto.sas7bdat} file into Stata{p_end}
{phang2}{cmd:. import sas auto.sas7bdat}

{pstd}Load only a subset of the data that includes {cmd:make}, {cmd:weight},
and {cmd:foreign}{p_end}
{phang2}{cmd:. import sas make weight foreign using auto, clear}

{pstd}Same as above, but also load the value labels defined in
{cmd:format.sas7bcat}{p_end}
{phang2}{cmd:. import sas make weight foreign using auto, bcat(formats) clear}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:import sas} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations imported{p_end}
{synopt :{cmd:r(k)}}number of variables imported{p_end}
{p2colreset}{...}
