{smcl}
{* *! version 1.0.5  07jan2020}{...}
{viewerdialog icd10cm "dialog icd10cm"}{...}
{vieweralsosee "[D] icd10cm" "mansection D icd10cm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] icd" "help icd"}{...}
{vieweralsosee "[D] icd9" "help icd9"}{...}
{vieweralsosee "[D] icd10" "help icd10"}{...}
{vieweralsosee "[D] icd10pcs" "help icd10pcs"}{...}
{viewerjumpto "Syntax" "icd10cm##syntax"}{...}
{viewerjumpto "Menu" "icd10cm##menu"}{...}
{viewerjumpto "Description" "icd10cm##description"}{...}
{viewerjumpto "Links to PDF documentation" "icd10cm##linkspdf"}{...}
{viewerjumpto "Options" "icd10cm##options"}{...}
{viewerjumpto "Examples" "icd10cm##examples"}{...}
{viewerjumpto "Stored results" "icd10cm##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] icd10cm} {hline 2}}ICD-10-CM diagnosis codes{p_end}
{p2col:}({mansection D icd10cm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Verify that variable contains defined codes

{p 8 16 2}
{cmd:icd10cm}
{cmd:check} {varname} {ifin}
[{cmd:,} {it:{help icd10cm##checkopts:checkopts}}]


{phang}
Clean variable and verify format of codes

{p 8 16 2}
{cmd:icd10cm}
{opt clean} {varname} {ifin}{cmd:,}
{c -(}{opth gen:erate(newvar)} | {opt rep:lace}{c )-}
[{it:{help icd10cm##cleanopts:cleanopts}}]


{phang}
Generate new variable from existing variable

{p 8 16 2}
{cmd:icd10cm}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt cat:egory} [{opt check}]

{p 8 16 2}
{cmd:icd10cm}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt d:escription}
[{it:{help icd10cm##genopts:genopts}}]

{p 8 16 2}
{cmd:icd10cm}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt r:ange(codelist)} [{opt check}]


{phang}
Display code descriptions

{p 8 16 2}
{cmd:icd10cm}
{opt look:up} {it:codelist}
[{cmd:,} {opt version(#)}]


{phang}
Search for codes from descriptions

{p 8 16 2}
{cmd:icd10cm}
{opt sea:rch}
[{cmd:"}]{it:text}[{cmd:"}]
[[{cmd:"}]{it:text}[{cmd:"}] {it:...}]
[{cmd:,}
{it:{help icd10cm##searchopts:searchopts}}]


{phang}
Display ICD-10-CM version

{p 8 16 2}
{cmd:icd10cm}
{opt q:uery}


{pstd}
{it:codelist} is one of the following:

{p2colset 9 30 32 2}{...}
{p2col :{it:icd10code}}(the particular code){p_end}
{p2col :{it:icd10code}{cmd:*}}(all codes starting with){p_end}
{p2col :{it:icd10code}{cmd:/}{it:icd10code}}(the code range){p_end}
{p2colreset}{...}

{pstd}
or any combination of the above, such as {cmd:A27.0 G40* Y60/Y69.9}.

{marker checkopts}{...}
{synoptset 18}{...}
{synopthdr:checkopts}
{synoptline}
{synopt :{opt fmt:only}}check only format of the codes{p_end}
{synopt :{opt summ:ary}}frequency of each invalid or undefined code{p_end}
{synopt :{opt l:ist}}list observations with invalid or undefined ICD-10-CM codes{p_end}
{synopt :{opth gen:erate(newvar)}}create new variable marking invalid codes{p_end}
{synopt :{opt version(#)}}fiscal year to check codes against; default is
the current year{p_end}
{synoptline}
{p2colreset}{...}

{marker cleanopts}{...}
{synoptset 18 tabbed}{...}
{synopthdr:cleanopts}
{synoptline}
{p2coldent:* {opth gen:erate(newvar)}}create new variable containing cleaned
codes{p_end}
{p2coldent:* {opt replace}}replace existing codes with the cleaned
codes{p_end}
{synopt :{opt check}}check that variable contains ICD-10-CM codes before cleaning{p_end}
{synopt :{opt nodot:s}}format codes without a period{p_end}
{synopt :{opt pad}}add space to the right of codes shorter than seven
characters{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Either {cmd:generate()} or {cmd:replace} is required.

{marker genopts}{...}
{synoptset 18}{...}
{synopthdr:genopts}
{synoptline}
{synopt :{cmd:addcode(begin}|{cmd:end)}}add code to the beginning or end of the description{p_end}
{synopt :{opt pad}}add spaces to the right of the code; must specify {cmd:addcode(begin)}{p_end}
{synopt :{opt nodot:s}}format codes without a period; must specify {cmd:addcode()}{p_end}
{synopt :{opt check}}check that variable contains ICD-10-CM codes before
generating new variable{p_end}
{synopt :{opt long}}use long description rather than short{p_end}
{synopt :{opt version(#)}}select description from year {it:#}; default is the
current year{p_end}
{synoptline}
{p2colreset}{...}

{marker searchopts}{...}
{synoptset 18}{...}
{synopthdr:searchopts}
{synoptline}
{synopt :{opt or}}match any keyword{p_end}
{synopt :{opt matchc:ase}}match case of keywords{p_end}
{synopt :{opt version(#)}}select description from year {it:#}; default is all{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > ICD codes > ICD-10-CM}


{marker description}{...}
{title:Description}

{pstd}
{cmd:icd10cm} is a suite of commands for working with ICD-10-CM diagnosis
codes from U.S. federal fiscal year 2016 to the present.  To see the current
version of the ICD-10-CM diagnosis codes and any changes that have been
applied, type {cmd:icd10cm query}.

{pstd}
{cmd:icd10cm check}, {cmd:icd10cm clean}, and {cmd:icd10cm generate} are data
management commands.  {cmd:icd10cm check} verifies that a variable contains
defined ICD-10-CM diagnosis codes and provides a summary of any problems
encountered.  {cmd:icd10cm clean} standardizes the format of the codes.
{cmd:icd10cm generate} can create a binary indicator variable for whether the
code is in a specified set of codes, a variable containing a corresponding
higher-level code, or a variable containing the description of the code.

{pstd}
{cmd:icd10cm lookup} and {cmd:icd10cm search} are interactive utilities.
{cmd:icd10cm lookup} displays descriptions of the codes specified on the
command line.  {cmd:icd10cm search} looks for relevant ICD-10-CM diagnosis
codes from keywords given on the command line.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D icd10cmQuickstart:Quick start}

        {mansection D icd10cmRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd} Options are presented under the following headings:

        {help icd10cm##opts_icd10cmcheck:Options for icd10cm check}
        {help icd10cm##opts_icd10cmclean:Options for icd10cm clean}
        {help icd10cm##opts_icd10cmgen:Options for icd10cm generate}
        {help icd10cm##opts_icd10cmlookup:Option for icd10cm lookup}
        {help icd10cm##opts_icd10cmsearch:Options for icd10cm search}


{marker opts_icd10cmcheck}{...}
{title:Options for icd10cm check}

{phang}
{opt fmtonly} tells {cmd:icd10cm check} to verify that the codes fit the format
of ICD-10-CM diagnosis codes but not to check whether the codes are defined.

{phang}
{opt summary} specifies that {cmd:icd10cm check} should report the frequency of
each invalid or undefined code that was found in the data.  Codes are
displayed in descending order by frequency.  {cmd:summary} may not be combined
with {cmd:list}.

{phang}
{opt list} specifies that {cmd:icd10cm check} list the observation number, the
invalid or undefined ICD-10-CM diagnosis code, and the reason the code is
invalid or whether it is an undefined code.  {cmd:list} may not be combined
with {cmd:summary}.

{phang}
{opth generate(newvar)} specifies that {cmd:icd10cm check} create a new
variable containing, for each observation, 0 if the observation contains a
defined code. Otherwise, it contains a number from 1 to 11 if the code is
invalid, 77 if the code is valid only for a previous version, 88 if the code
is valid only for a later version, 99 if the code is undefined, or missing if
{it:varname} is missing. The positive numbers indicate the kind of problem and
correspond to the listing produced by {cmd:icd10cm check}.

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10cm check}
should reference.  {it:#} indicates the federal fiscal year for the codes.
For example, use {cmd:2016} for federal fiscal year 2016 (FFY-2016), which is
October 1, 2015 to September 30, 2016.  {cmd:icd10cm} supports all years after
the United States officially adopted ICD-10-CM.  The appropriate value of
{it:#} should be determined from the data source.  The default is the current
year.

{pmore}
Warning: The default value of {cmd:version()} will change over time so that
the most recent codes are used.  Using the default value rather than specifying
a specific version may change results after a new version of the codes is
introduced.


{marker opts_icd10cmclean}{...}
{title:Options for icd10cm clean}

{phang}
{opth generate(newvar)} and {opt replace} specify how the formatted values of
{varname} are to be handled.  You must specify either {cmd:generate()} or
{cmd:replace}.

{phang2}
{opt generate()} specifies that the cleaned values be placed in the new
variable specified in {it:newvar}.

{phang2}
{opt replace} specifies that the existing values of {it:varname} be replaced
with the formatted values.

{phang}
{opt check} specifies that {cmd:icd10cm clean} should first check that
{it:varname} contains codes that fit the format of ICD-10-CM diagnosis codes.
Specifying the {opt check} option will slow down {cmd:icd10cm clean}.

{phang}
{opt nodots} specifies that the period be removed in the final format.

{phang}
{opt pad} specifies that spaces be added to the end of the codes to make the
(implied) dots align vertically in listings.  The default is to left-align
codes without adding spaces.


{marker opts_icd10cmgen}{...}
{title:Options for icd10cm generate}

{phang}
{cmd:category}, {cmd:description}, and {opt range(codelist)}
specify the contents of the new variable that {cmd:icd10cm} {cmd:generate} is
to create.  You do not need to {cmd:icd10cm} {cmd:clean} {it:varname} before
using {cmd:icd10cm} {cmd:generate}; it will accept any supported format or
combination of formats.

{phang2}
{cmd:category} specifies to extract the three-character category code from the
ICD-10-CM diagnosis code.  The resulting variable may be used with the other
{cmd:icd10cm} subcommands.

{phang2}
{opt description} creates {newvar} containing descriptions of the ICD-10-CM
diagnosis codes.

{phang2}
{opt range(codelist)} creates a new indicator variable equal to 1 when the
ICD-10-CM diagnosis code is in the range specified, equal to 0 when the
ICD-10-CM diagnosis code is not in the range, and equal to missing when
{it:varname} is missing.

{phang}
{cmd:addcode(begin}|{cmd:end)} specifies that the code should be included with
the text describing the code.  Specifying {cmd:addcode(begin)} will prepend the
code to the text.  Specifying {cmd:addcode(end)} will append the code to the
text.

{phang}
{cmd:pad} specifies that the code that is to be added to the description
should be padded spaces to the right of the code so that the start of
description text is aligned for all codes.  {cmd:pad} may be specified only
with {cmd:addcode(begin)}.

{phang}
{cmd:nodots} specifies that the code that is added to the description should
be formatted without a period.  {cmd:nodots} may be specified only if
{cmd:addcode()} is also specified.

{phang}
{cmd:check} specifies that {cmd:icd10cm} {cmd:generate} should first check that
{it:varname} contains codes that fit the format of ICD-10-CM diagnosis codes.
Specifying the {cmd:check} option will slow down the {cmd:generate}
subcommand.

{phang}
{cmd:long} specifies that the long description of the code be used rather than
the short (abbreviated) description.

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10cm}
{cmd:generate} should reference.  {it:#} indicates the federal fiscal year for
the codes.  For example, use {cmd:2016} for federal fiscal year 2016
(FFY-2016), which is October 1, 2015 to September 30, 2016.  {cmd:icd10cm}
supports all years after the United States officially adopted ICD-10-CM.  The
appropriate value of {it:#} should be determined from the data source.  The
default is the current year.

{pmore}
Warning: The default value of {cmd:version()} will change over time so that
the most recent codes are used.  Using the default value rather than specifying
a specific version may change results after a new version of the codes is
introduced.


{marker opts_icd10cmlookup}{...}
{title:Option for icd10cm lookup}

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10cm lookup}
should reference.  {it:#} indicates the federal fiscal year for the codes.
For example, use {cmd:2016} for federal fiscal year 2016 (FFY-2016), which is
October 1, 2015 to September 30, 2016.  {cmd:icd10cm} supports all years after
the United States officially adopted ICD-10-CM.  The appropriate value of
{it:#} should be determined from the data source.  The default is the current
year.

{pmore}
Warning: The default value of {cmd:version()} will change over time so that
the most recent codes are used.  Using the default value rather than specifying
a specific version may change results after a new version of the codes is
introduced.


{marker opts_icd10cmsearch}{...}
{title:Options for icd10cm search}

{phang}
{cmd:or} specifies that ICD-10-CM diagnosis codes be searched for descriptions
that contain any word specified with {cmd:icd10cm search}.  The default is to
list only descriptions that contain all the words specified.

{phang}
{opt matchcase} specifies that {cmd:icd10cm search} should match the case of
the keywords given on the command line.  The default is to perform a
case-insensitive search.

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10cm}
{cmd:search} should reference.  {it:#} indicates the federal fiscal year for
the codes.  For example, use {cmd:2016} for federal fiscal year 2016
(FFY-2016), which is October 1, 2015 to September 30, 2016.  {cmd:icd10cm}
supports all years after the United States officially adopted ICD-10-CM.

{pmore}
By default, descriptions for all versions are searched, meaning that codes
that changed descriptions and that have descriptions in multiple versions that
contain the search terms will be duplicated.  To ensure a list of unique code
values, specify the version number.


{marker examples}{...}
{title:Examples}

{pstd}View the ICD-10-CM diagnosis code version and changes made
since {cmd:icd10cm} was implemented in Stata{p_end}
{phang2}{cmd:. icd10cm query}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hosp2015}{p_end}
{phang2}{cmd:. drop if dmonth < tm(2015m10)}{p_end}

{pstd}Verify that the variable {cmd:diag1} has valid codes 
for federal fiscal year 2016{p_end}
{phang2}{cmd:. icd10cm check diag1, version(2016) summary}

{pstd}Clean the codes to make them more readable, padding the 
codes with spaces for alignment and storing the result in
new variable {cmd:pdx}{p_end}
{phang2}{cmd:. icd10cm clean diag1, pad generate(pdx)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:icd10cm} {cmd:check} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(e}{it:#}{cmd:)}}number of errors of type {it:#}{p_end}
{synopt :{cmd:r(esum)}}total number of errors{p_end}
{synopt :{cmd:r(miss)}}number of missing values{p_end}
{synopt :{cmd:r(N)}}number of nonmissing values{p_end}

{pstd}
{cmd:icd10cm} {cmd:clean} stores the following in {cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of changes{p_end}

{pstd}
{cmd:icd10cm} {cmd:lookup} and {cmd:icd10cm} {cmd:search} store the following
in {cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(N_codes)}}number of codes found{p_end}
{p2colreset}{...}
