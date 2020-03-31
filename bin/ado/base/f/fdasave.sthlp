{smcl}
{* *! version 2.0.0  05may2011}{...}
{cmd:help fdasave}, {cmd:help fdause},{right:dialogs:  {dialog fdasave}  {dialog fdause}}
{cmd:help fdadescribe}
{hline}
{pstd}
{cmd:fdasave} has been renamed {cmd:export sasxport}. 
{cmd:fdause} has been renamed {cmd:import sasxport}.  
{cmd:fdadescribe} has been renamed {cmd:import sasxport, describe}.  
See {helpb import sasxport:[D] import sasxport}.
{cmd:fdasave}, {cmd:fdause}, and {cmd:fdadescribe} are understood as
synonyms.  This is the original help file, which we will no longer update, so
some links may no longer work.


{title:Title}

{p2colset 5 20 22 2}{...}
{p2col :{bf:[D] fdasave} {hline 2}}Save and use datasets in FDA (SAS XPORT)
format{p_end}
{p2colreset}{...}


{title:Syntax}

{phang}
Save data in memory in FDA format

{p 8 32 2}
{opt fdasav:e}
{it:filename}
{ifin}
[{cmd:,} {it:{help fdasave##fdasave_options:fdasave_options}}]

{p 8 32 2}
{opt fdasav:e}
{varlist}
{helpb using}
{it:filename}
{ifin}
[{cmd:,} {it:{help fdasave##fdasave_options:fdasave_options}}]


{phang}
Read SAS XPORT file into Stata

{p 8 31 2}
{cmd:fdause}
{it:filename}
[{cmd:,} {it:{help fdasave##fdause_options:fdause_options}}]


{phang}
Describe contents of SAS XPORT Transport file

{p 8 31}
{opt fdades:cribe}
{it:filename}
[{cmd:,} {opt m:ember(mbrname)}]


{synoptset 23 tabbed}{...}
{marker fdasave_options}{...}
{synopthdr :fdasave_options}
{synoptline}
{syntab :Main}
{synopt :{opt ren:ame}}rename variables and value labels to meet SAS XPORT
restrictions{p_end}
{synopt :{opt replace}}overwrite files if they already exist{p_end}
{synopt :{cmdab:val:labfile:(xpf)}}save value labels in
{opt formats.xpf}{p_end}
{synopt :{cmdab:val:labfile:(}{cmdab:sas:code)}}save value labels in SAS command
file{p_end}
{synopt :{cmdab:val:labfile:(both)}}save value labels in {opt formats.xpf} and in
a SAS command file{p_end}
{synopt :{cmdab:val:labfile:(none)}}do not save value labels{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 23}{...}
{marker fdause_options}{...}
{synopthdr :fdause_options}
{synoptline}
{synopt :{opt clear}}replace data in memory{p_end}
{synopt :{opt noval:labels}}ignore accompanying {opt formats.xpf} file if it
exists{p_end}
{synopt :{opt m:ember(mbrname)}}member to use; seldom used{p_end}
{synoptline}
{p2colreset}{...}


{title:Menu}

    {title:fdasave}

{phang2}
{bf:File > Export > FDA data (SAS XPORT)}

    {title:fdause}

{phang2}
{bf:File > Import > FDA data (SAS XPORT)}


{title:Description}

{pstd}
{opt fdasave}, {opt fdause}, and {opt fdadescribe} convert datasets to and
from the U.S. Food & Drug Administration (FDA) format for new drug and new
device applications (NDAs) -- SAS XPORT Transport format.  The primary
intent of these commands is to assist people making submissions to the FDA,
but the commands are general enough for use in transferring data between SAS
and Stata.

{pstd}
To save the data in memory in the FDA format, type

	{cmd:. fdasave} {it:filename}

{pstd}
although sometimes you will want to type

	{cmd:. fdasave} {it:filename}{cmd:, rename}

{pstd}
It never hurts to specify the {opt rename} option.  In any case, Stata
will create {it:filename}{opt .xpt} as an XPORT file containing the data and,
if needed, will also create {opt formats.xpf} -- an additional XPORT
file -- containing the value-label definitions.  These files can be easily
read into SAS.

{pstd}
To read a SAS XPORT Transport file into Stata, type

	{cmd:. fdause} {it:filename}

{pstd}
Stata will read into memory the XPORT file {it:filename}{opt .xpt} containing
the data and, if available, will also read the value-label definitions stored
in {opt formats.xpf} or {opt FORMATS.xpf}.

{pstd}
{opt fdadescribe} describes the contents of a SAS XPORT Transport file.  The
display is similar to that produced by {helpb describe}, as is the syntax:

	{cmd:. fdadescribe} {it:filename}

{pstd}
If {it:filename} is specified without an extension, {opt .xpt} is assumed.


{title:Options for fdasave}

{dlgtab:Main}

{phang}
{opt rename} specifies that {opt fdasave} may rename variables and value
labels to meet the SAS XPORT restrictions, which are that names be no more
than eight characters long and that there be no distinction between uppercase
and lowercase letters.

{pmore}
    We recommend specifying the {opt rename} option.  If this option is
    specified, any name violating the restrictions is changed to a different
    but related name in the file.  The name changes are listed.  The new names
    are used only in the file; the names of the variables and value labels in
    memory remain unchanged.

{pmore}
If {opt rename} is not specified and one or more names violate the
XPORT restrictions, an error message will be issued and no file will be
saved.  The alternative to the {opt rename} option is that you can rename
variables yourself with the {helpb rename} command:

{pin2}{cmd:. rename mylongvariablename myname}

{pmore}
See {manhelp rename D}.  Renaming value labels yourself is more difficult.
The easiest way to rename value labels is to use {helpb label save}, edit the
resulting file to change the name, execute the file by using {helpb do}, and
reassign the new value label to the appropriate variables by using
{opt label values}:

{pin2}{cmd:. label save mylongvaluelabel using myfile.do}{p_end}
            {cmd:. doedit myfile.do}{right:(change mylongvaluelabel to, say, mlvlab)  }
{pin2}{cmd:. do myfile.do}{p_end}
{pin2}{cmd:. label values myvar mlvlab}{p_end}

{pmore}
See {manhelp label D} and {manhelp do R} for more information about renaming
value labels.

{phang}
{opt replace}
permits {opt fdasave} to overwrite existing {it:filename}{opt .xpt},
{opt formats.xpf}, and {it:filename}{opt .sas} files.

{phang}
{cmd:vallabfile(xpf}|{cmd:sascode}|{cmd:both}|{cmd:none)}
specifies whether and how value labels are to be stored.  SAS XPORT
Transport files do not really have value labels.  In
preparing datasets for submission to the FDA, value-label definitions
should be provided in one of two ways:

{phang2}
1.  In an additional SAS XPORT Transport file whose data contain the
value-label definitions

{phang2}
2.  In a SAS command file that will create the value labels

{pmore}
{opt fdasave} can create either or both of these files.

{pmore}
{cmd:vallabfile(xpf)}, the default,
specifies that value labels be written into a separate SAS
XPORT Transport file named {opt formats.xpf}.  Thus {opt fdasave}
creates two files:  {it:filename}{opt .xpt}, containing the data,
and {opt formats.xpf}, containing the value labels.  No
{opt formats.xpf} file is created if there are no value labels.

{pmore}
	SAS users can easily use the resulting {opt .xpt} and {opt .xpf} XPORT
	files.  See
	{browse "http://www.sas.com/govedu/fda/macro.html"} for SAS-provided
	macros for reading the XPORT files.  The SAS macro {opt fromexp()}
	reads the XPORT files into SAS.  The SAS macro {opt toexp()} creates
	XPORT files.  When obtaining the macros, remember to save the macros
	at SAS's web page as a plain-text file and to remove the examples at
	the bottom.

{pmore}
If the SAS macro file is saved as {cmd:C:\project\macros.mac}
and the files {opt mydat.xpt} and {opt formats.xpf} created by
{opt fdasave} are in {cmd:C:\project\}, the following SAS commands would create
the corresponding SAS dataset and format library and list the data:

		{c TLC}{hline 19} SAS commands {hline 20}{c TRC}
		{c |} {cmd:%include "C:\project\macros.mac" ;}{space 18}{c |}
		{c |} {cmd:%fromexp(C:\project, C:\project) ;}{space 18}{c |}
		{c |} {cmd:libname library 'C:\project' ;}{space 22}{c |}
		{c |} {cmd:data _null_ ; set library.mydat ; put _all_ ; run ;} {c |}
		{c |} {cmd:proc print data = library.mydat ;}{space 19}{c |}
		{c |} {cmd:quit ;}{space 46}{c |}
		{c BLC}{hline 53}{c BRC}

{pmore}
{cmd:vallabfile(sascode)}
specifies that the value labels be written into a SAS command
file, {it:filename}{opt .sas}, containing SAS {cmd:proc format} and
related commands.  Thus {opt fdasave} creates two files:
{it:filename}{opt .xpt}, containing the data, and
{it:filename}{opt .sas}, containing the value labels.  SAS users may
wish to edit the resulting {it:filename}{opt .sas} file to change the
"libname datapath" and "libname xptfile xport" lines at the top to
correspond with the location that they desire.  {opt fdasave} sets the
location to the current working directory at the time {opt fdasave}
was issued.  No {opt .sas} file will be created if there are no value
labels.

{pmore}
{cmd:vallabfile(both)}
specifies that both the actions described above be taken and that three
files be created: {it:filename}{opt .xpt}, containing the data;
{opt formats.xpf}, containing the value labels in XPORT format;
and {it:filename}{opt .sas}, containing the value labels in SAS
command-file format.

{pmore}
{cmd:vallabfile(none)}
specifies that value-label definitions not be saved.  Only one
file is created: {it:filename}{opt .xpt}, which contains the data.


{title:Options for fdause}

{phang}
{opt clear}
permits the data to be loaded, even if there is a dataset already in
memory and even if that dataset has changed since the data were last saved.

{phang}
{opt novallabels}
specifies that value-label definitions stored in {opt formats.xpf} or
{opt FORMATS.xpf} not be looked for or loaded.  By default, if
variables are labeled in {it:filename}{opt .xpt}, then {opt fdause} looks for
{opt formats.xpf} to obtain and load the value-label definitions.  If the
file is not found, Stata looks for {opt FORMATS.xpf}.  If that file is not
found, a warning message is issued.

{pmore}
{opt fdause} can use only a {opt formats.xpf} or
{opt FORMATS.xpf} file to obtain value-label definitions.
{opt fdause} cannot understand value-label definitions from a SAS command
file.

{phang}
{opt member(mbrname)}
is a rarely specified option indicating which member of the {opt .xpt}
file is to be loaded.  It is not used much anymore, but the original XPORT
definition allowed multiple datasets to be placed in one file.  The 
{opt member()} option allows you to read these old files.  You can obtain a
list of member names using {opt fdadescribe}.  If {opt member()} is not
specified -- and it usually is not -- {opt fdause} reads the first (and usually
only) member.


{title:Option for fdadescribe}

{phang}
{opt member(mbrname)}
is a rarely specified option indicating which member of the {opt .xpt}
file is to be described.  See the description of {opt member()} option for
{opt fdause} directly above.  If {opt member()} is not specified, all
members are described, one after the other.  It is rare for an XPORT file
to have more than one member.


{title:Remarks}

{pstd}
SAS XPORT Transport format has been adopted by the U.S. Food & Drug
Administration (FDA) for datasets submitted in support of new drug and
device applications.  For the FDA submission guidance document, see
{browse "http://www.fda.gov/cder/guidance/2867fnl.pdf"}.

{p 4 4 2}
All users, of course, may use these commands to transfer data between SAS and
Stata, but there are limitations in the SAS
XPORT Transport format, such as the eight-character limit on the names of
variables (specifying {opt fdasave}'s {opt rename} option works around that).
For a complete listing of limitations and issues concerning the SAS XPORT
Transport format, and an explanation of how {opt fdasave} and {opt fdause}
work around these limitations, see the technical appendix in 
{bind:{bf:[D] fdasave}}.  For non-FDA
applications, you may find it more convenient to use translation packages such
as Stat/Transfer; see
{browse "http://www.stata.com/products/transfer.html"}.

{pstd}
Remarks are presented under the following headings:

        {help fdasave##remarks1:Saving XPORT files for transferring to SAS}
        {help fdasave##remarks2:Determining contents of XPORT files received from SAS}
        {help fdasave##remarks3:Using XPORT files received from SAS}


{marker remarks1}{...}
{title:Saving XPORT files for transferring to SAS}

{pstd}
To save the current dataset in {cmd:clindata.xpt} and the value labels in
{cmd:formats.xpf}, type

	{cmd:. fdasave clindata}

{pstd}
To save the data as above but automatically handle renaming variable names and
value labels that are too long or are case sensitive, type

	{cmd:. fdasave clindata, rename}

{pstd}
To allow the replacement of any preexisting files, type

	{cmd:. fdasave clindata, rename replace}

{pstd}
To save the current dataset in {cmd:clindata.xpt} and the value labels in SAS
command file {cmd:clindata.sas} and to automatically handle renaming variable
and value-label names:

	{cmd:. fdasave clindata, rename vallab(sas)}

{pstd}
To save the data as above but save the value labels in both {cmd:formats.xpf}
and {cmd:clindata.sas}, type

	{cmd:. fdasave clindata, rename vallab(both)}

{pstd}
To not save the value labels at all, thus creating only {cmd:clindata.xpt},
type

	{cmd:. fdasave clindata, rename vallab(none)}


{marker remarks2}{...}
{title:Determining contents of XPORT files received from SAS}

{pstd}
To determine the contents of {cmd:drugdata.xpt}, you might type

	{cmd:. fdadescribe drugdata}


{marker remarks3}{...}
{title:Using XPORT files received from SAS}

{pstd}
To read data from {cmd:drugdata.xpt} and obtain value labels from
{cmd:formats.xpf} (or {cmd:FORMATS.xpf}), if the file exists, you would type

	{cmd:. fdause drugdata}

{pstd}
To read the data as above and discard any data in memory, type

	{cmd:. fdause drugdata, clear}


{title:Saved results}

{pstd}
{cmd:fdadescribe} saves the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{synopt:{cmd:r(k)}}number of variables{p_end}
{synopt:{cmd:r(size)}}size of data{p_end}
{synopt:{cmd:r(n_members)}}number of members{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(members)}}names of members{p_end}
{p2colreset}{...}


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp describe D},
{manhelp infiling D},
{manhelp odbc D},
{manhelp outfile D},
{manhelp save D}
{p_end}
