{smcl}
{* *! version 1.0.0  20apr2019}{...}
{viewerdialog "import sasxport5" "dialog import_sasxport5"}{...}
{viewerdialog "export sasxport5" "dialog export_sasxport5"}{...}
{vieweralsosee "[D] import sasxport5" "mansection D importsasxport5"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] import sas" "help import sas"}{...}
{vieweralsosee "[D] import sasxport8" "help import sasxport8"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "import_sasxport5##syntax"}{...}
{viewerjumpto "Menu" "import_sasxport5##menu"}{...}
{viewerjumpto "Description" "import_sasxport5##description"}{...}
{viewerjumpto "Links to PDF documentation" "import_sasxport5##linkspdf"}{...}
{viewerjumpto "Options for import sasxport5" "import_sasxport5##options_import"}{...}
{viewerjumpto "Options for export sasxport5" "import_sasxport5##options_export"}{...}
{viewerjumpto "Examples" "import_sasxport5##examples"}{...}
{viewerjumpto "Stored results" "import_sasxport5##results"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[D] import sasxport5} {hline 2}}Import and export data in SAS XPORT Version 5 format{p_end}
{p2col:}({mansection D importsasxport5:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Import SAS XPORT Version 5 Transport file into Stata

{p 8 16 2}
{cmd:import sasxport5}
{it:{help filename}}
[{cmd:,} {it:{help import_sasxport5##import_options:import_options}}]


{phang}
Describe contents of SAS XPORT Version 5 Transport file

{p 8 16 2}
{cmd:import sasxport5}
{it:{help filename}}{cmd:,}
{opt d:escribe}
[{opt m:ember(mbrname)}]


{phang}
Export data in memory to a SAS XPORT Version 5 Transport file

{p 8 16 2}
{cmd:export sasxport5}
{it:{help filename}}
{ifin}
[{cmd:,} {it:{help import_sasxport5##export_options:export_options}}]

{p 8 16 2}
{cmd:export sasxport5}
{varlist}
{cmd:using} {it:{help filename}}
{ifin}
[{cmd:,} {it:{help import_sasxport5##export_options:export_options}}]


{phang}
If {it:{help filename}} is specified without an extension, {cmd:.xpt} is
assumed.  If {it:filename} contains embedded spaces, enclose it in double
quotes.


{synoptset 23}{...}
{marker import_options}{...}
{synopthdr :import_options}
{synoptline}
{synopt :{opt clear}}replace data in memory{p_end}
{synopt :{opt noval:labels}}ignore accompanying {cmd:formats.xpf} file if it
exists{p_end}
{synopt :{opt m:ember(mbrname)}}member to use; seldom used{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 23 tabbed}{...}
{marker export_options}{...}
{synopthdr :export_options}
{synoptline}
{syntab:Main}
{synopt :{opt rename}}rename variables and value labels to meet SAS XPORT
restrictions{p_end}
{synopt :{opt replace}}overwrite files if they already exist{p_end}
{synopt :{cmdab:val:labfile(}{cmd:xpf)}}save value labels in
{cmd:formats.xpf}{p_end}
{synopt :{cmdab:val:labfile(}{cmdab:sas:code)}}save value labels in SAS
command file{p_end}
{synopt :{cmdab:val:labfile(}{cmd:both)}}save value labels in
{cmd:formats.xpf} and in a SAS command file{p_end}
{synopt :{cmdab:val:labfile(}{cmd:none)}}do not save value labels{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:import sasxport5}

{phang2}
{bf:File > Import > SAS XPORT Version 5 (*.xpt)}

    {title:export sasxport5}

{phang2}
{bf:File > Export > SAS XPORT Version 5 (*.xpt)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:import sasxport5} and {cmd:export sasxport5} convert data from and to
SAS XPORT Version 5 Transport format.  The U.S. Food and Drug
Administration uses this SAS XPORT Transport format as the format for
datasets submitted with new drug and new device applications (NDAs).

{pstd}
{cmd:export sasxport5} saves the data in memory as a SAS XPORT
Transport ({cmd:.xpt}) file.  If needed, this command also creates
{cmd:formats.xpf} -- an additional XPORT file -- containing
the value-label definitions.  These files can be easily read into SAS.

{pstd}
{cmd:import sasxport5} reads into memory data from a SAS XPORT
Transport ({cmd:.xpt}) file.  When available, this command also reads the
value-label definitions stored in {cmd:formats.xpf} or {cmd:FORMATS.xpf}.

{pstd}
{cmd:import sasxport5, describe} describes the contents of a SAS XPORT
Version 5 Transport file.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importsasxport5Quickstart:Quick start}

        {mansection D importsasxport5Remarksandexamples:Remarks and examples}

        {mansection D importsasxport5Technicalappendix:Technical appendix}

{pstd}
The above sections are not included in this help file.


{marker options_import}{...}
{title:Options for import sasxport5}

{phang}
{cmd:describe} describes the contents of the SAS XPORT Version 5 Transport
file.  This option can be combined only with {cmd:member()}.

{phang}
{cmd:clear} specifies that it is okay to replace the data in memory, even
though the current data have not been saved to disk.

{phang}
{cmd:novallabels}
    specifies that value-label definitions stored in {cmd:formats.xpf} or
    {cmd:FORMATS.xpf} not be looked for or loaded.  By default, if
    variables are labeled in {it:{help filename}}{cmd:.xpt}, then
    {cmd:import sasxport5} looks for {cmd:formats.xpf} to obtain and load the
    value-label definitions.  If the file is not found, Stata looks for
    {cmd:FORMATS.xpf}.  If that file is not found, a warning message is
    issued.

{pmore}
    {cmd:import sasxport5} can use only a {cmd:formats.xpf} or
    {cmd:FORMATS.xpf} file to obtain value-label definitions.
    {cmd:import sasxport5} cannot understand value-label definitions from a
    SAS command file.

{phang}
{opt member(mbrname)}
    specifies a member of the {cmd:.xpt} file.  Although no longer often used,
    the original XPORT definition allowed multiple datasets to be
    placed in one file.  The {cmd:member()} option allows you to read these
    old files, selecting only specific datasets (members) to be used
    by {cmd:import sasxport5}.  You can obtain a list of member names by using
    {cmd:import sasxport5, describe}.  By default, only the first member is
    used, unless {cmd:describe} is specified, in which case all members are
    described.  Because it is rare for an XPORT file to have more than
    one member, this option is seldom used.


{marker options_export}{...}
{title:Options for export sasxport5}

{dlgtab:Main}

{phang}
{cmd:rename} specifies that {cmd:export sasxport5} may rename variables and
value labels to attempt to meet the SAS XPORT restrictions, which are
that names be no more than eight bytes long and that there be no distinction
between uppercase and lowercase letters.  Note that {cmd:rename} does not
remove characters beyond the normal ASCII range, such as most
Unicode characters and all extended ASCII characters.  SAS may
or may not support such characters in variable labels and value labels.

{pmore}
    We recommend specifying the {cmd:rename} option.  If this option is
    specified, any name violating the restrictions is changed to a different
    but related name in the file.  The name changes are listed.  The new names
    are used only in the file; the names of the variables and value labels in
    memory remain unchanged.

{pmore}
    If {cmd:rename} is not specified and one or more names violate the
    XPORT restrictions, an error message will be issued and no file
    will be saved.  The alternative to the {cmd:rename} option is that you can
    rename variables yourself with the {cmd:rename} command:

            {cmd:. rename mylongvariablename myname}

{pmore}
    See  {manhelp rename D}.  Renaming value labels yourself is more difficult.
    The easiest way to rename value labels is to use {cmd:label save}, edit
    the resulting file to change the name, execute the file by using {cmd:do},
    and reassign the new value label to the appropriate variables by using
    {cmd:label values}:

            {cmd:. label save mylongvaluelabel using myfile.do}
            {cmd:. doedit myfile.do}   (change {cmd:mylongvaluelabel} to, say, {cmd:mlvlab})
            {cmd:. do myfile.do}
            {cmd:. label values myvar mlvlab}

{pmore}
    See {manhelp label D} and {manhelp do R} for more information about
    renaming value labels.

{phang}
{cmd:replace}
    permits {cmd:export sasxport5} to overwrite existing
    {it:{help filename}}{cmd:.xpt},
    {cmd:formats.xpf}, and {it:filename}{cmd:.sas} files.

{phang}
{cmd:vallabfile(xpf}{c |}{cmd:sascode}{c |}{cmd:both}{c |}{cmd:none)}
    specifies whether and how value labels are to be stored.
    SAS XPORT Transport files do not really have value labels.
    Value-label definitions can be preserved in one of two ways: 

{phang2}
1.  In an additional SAS XPORT Version 5 Transport file whose data
contain the value-label definitions

{phang2}
2.  In a SAS command file that will create the value labels

{pmore}
{cmd:export sasxport5} can create either or both of these files.

{pmore}
{cmd:vallabfile(xpf)}, the default,
	specifies that value labels be written into a separate
	SAS XPORT Transport file named {cmd:formats.xpf}.  Thus,
	{cmd:export sasxport5} creates two files:
	{it:{help filename}}{cmd:.xpt}, containing the data, and
	{cmd:formats.xpf}, containing the value labels.  No {cmd:formats.xpf}
	file is created if there are no value labels.

{pmore}
	SAS users can easily use the resulting {cmd:.xpt} and 
	{cmd:.xpf} XPORT files.
        See
	{browse "https://www.sas.com/govedu/fda/macro.html"}, and click on the
	{bf:FDA Submission Standards} tab.  Then, click on the
	{bf:Processing Data Sets Code} tab that appears below the "FDA and SAS
	Technology" text for SAS-provided macros for reading the XPORT files.
	The SAS macro {cmd:fromexp()} reads the XPORT files into SAS.  The SAS
	macro {cmd:toexp()} creates XPORT files.  When obtaining the macros,
	remember to save the macros at SAS's webpage as a plain-text file and
	to remove the examples at the bottom.

{pmore}
	If the SAS macro file is saved as 
	{cmd:C:\project\macros.mac} and the files {cmd:mydat.xpt} and
	{cmd:formats.xpf} created by {cmd:export sasxport5} are in
	{cmd:C:\project\}, the following SAS commands would create
	the corresponding SAS dataset and format library and list the
	data:

		{c TLC}{hline 19} SAS commands {hline 20}{c TRC}
		{c |} {cmd:%include "C:\project\macros.mac" ;}{space 18}{c |}
		{c |} {cmd:%fromexp(C:\project, C:\project) ;}{space 18}{c |}
		{c |} {cmd:libname library 'C:\project' ;}{space 22}{c |}
		{c |} {cmd:data _null_ ; set library.mydat ; put _all_ ; run ;} {c |}
		{c |} {cmd:proc print data = library.mydat ;}{space 19}{c |}
		{c |} {cmd:quit ;}{space 46}{c |}
		{c BLC}{hline 53}{c BRC}

{pmore}
    {cmd:vallabfile(sascode)} specifies that the value labels be
    written into a SAS command file, {it:filename}{cmd:.sas},
    containing SAS {cmd:proc format} and related commands.  Thus,
    {cmd:export sasxport5} creates two files: {it:filename}{cmd:.xpt},
    containing the data, and {it:filename}{cmd:.sas}, containing the value
    labels.  SAS users may wish to edit the resulting
    {it:filename}{cmd:.sas} file to change the "libname datapath" and
    "libname xptfile xport" lines at the top to correspond to the location
    that they desire.  {cmd:export sasxport5} sets the location to the current
    working directory at the time {cmd:export sasxport5} was issued.  No
    {cmd:.sas} file will be created if there are no value labels.

{pmore}
    {cmd:vallabfile(both)}
	specifies that both the actions described above be taken and that
	three files be created:  {it:filename}{cmd:.xpt}, containing the data;
	{cmd:formats.xpf}, containing the value labels in XPORT
	format; and {it:filename}{cmd:.sas}, containing the value labels in
	SAS command-file format.

{pmore}
    {cmd:vallabfile(none)}
	specifies that value-label definitions not be saved.  Only one
	file is created:  {it:filename}{cmd:.xpt}, which contains the data.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto}

{pstd}Save only variables {cmd:make}, {cmd:mpg}, and {cmd:weight} in
{cmd:auto_sub.xpt}{p_end}
{phang2}{cmd:. export sasxport5 make mpg weight using auto_sub}

{pstd}
Save all the variables in the data to {cmd:auto.xpt} and save the value labels
in {cmd:formats.xpf}, renaming variable names and value labels that are too
long or are case sensitive{p_end}
{phang2}{cmd:. export sasxport5 auto, rename}

{pstd}
Same as above, but save also save the value labels in a SAS command file
{cmd:auto.sas}{p_end}
{phang2}{cmd:. export sasxport5 auto, rename replace vallabfile(both)}

{pstd}
Display the contents of the {cmd:auto.xpt} file{p_end}
{phang2}{cmd:. import sasxport5 auto, describe}

{pstd}
Read data from {cmd:auto.xpt} and obtain the value labels from
{cmd:formats.xpf}{p_end}
{phang2}{cmd:. import sasxport5 auto, clear}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:import sasxport5, describe} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations{p_end}
{synopt :{cmd:r(k)}}number of variables{p_end}
{synopt :{cmd:r(size)}}size of data{p_end}
{synopt :{cmd:r(n_members)}}number of members{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt :{cmd:r(members)}}names of members{p_end}
{p2colreset}{...}
