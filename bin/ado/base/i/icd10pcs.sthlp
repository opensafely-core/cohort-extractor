{smcl}
{* *! version 1.0.5  07jan2020}{...}
{viewerdialog icd10pcs "dialog icd10pcs"}{...}
{vieweralsosee "[D] icd10pcs" "mansection D icd10pcs"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] icd" "help icd"}{...}
{vieweralsosee "[D] icd9p" "help icd9p"}{...}
{vieweralsosee "[D] icd10cm" "help icd10cm"}{...}
{viewerjumpto "Syntax" "icd10pcs##syntax"}{...}
{viewerjumpto "Menu" "icd10pcs##menu"}{...}
{viewerjumpto "Description" "icd10pcs##description"}{...}
{viewerjumpto "Links to PDF documentation" "icd10pcs##linkspdf"}{...}
{viewerjumpto "Options" "icd10pcs##options"}{...}
{viewerjumpto "Examples" "icd10pcs##examples"}{...}
{viewerjumpto "Stored results" "icd10pcs##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] icd10pcs} {hline 2}}ICD-10-PCS procedure codes{p_end}
{p2col:}({mansection D icd10pcs:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Verify that variable contains defined codes

{p 8 16 2}
{cmd:icd10pcs}
{cmd:check} {varname} {ifin}
[{cmd:,} {it:{help icd10pcs##checkopts:checkopts}}]


{phang}
Clean variable and verify format of codes

{p 8 16 2}
{cmd:icd10pcs}
{opt clean} {varname} {ifin}{cmd:,}
{c -(}{opth gen:erate(newvar)} | {opt rep:lace}{c )-}
[{it:{help icd10pcs##cleanopts:cleanopts}}]


{phang}
Generate new variable from existing variable

{p 8 16 2}
{cmd:icd10pcs}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt cat:egory} [{opt check}]

{p 8 16 2}
{cmd:icd10pcs}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt d:escription}
[{it:{help icd10pcs##genopts:genopts}}]

{p 8 16 2}
{cmd:icd10pcs}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt r:ange(codelist)} [{opt check}]


{phang}
Display code descriptions

{p 8 16 2}
{cmd:icd10pcs}
{opt look:up} {it:codelist}
[{cmd:,} {opt version(#)}]


{phang}
Search for codes from descriptions

{p 8 16 2}
{cmd:icd10pcs}
{opt sea:rch}
[{cmd:"}]{it:text}[{cmd:"}]
[[{cmd:"}]{it:text}[{cmd:"}] {it:...}]
[{cmd:,}
{it:{help icd10pcs##searchopts:searchopts}}]


{phang}
Display ICD-10-PCS version

{p 8 16 2}
{cmd:icd10pcs}
{opt q:uery}


{pstd}
{it:codelist} is one of the following:

{p2colset 9 30 32 2}{...}
{p2col :{it:icd10code}}(the particular code){p_end}
{p2col :{it:icd10code}{cmd:*}}(all codes starting with){p_end}
{p2col :{it:icd10code}{cmd:/}{it:icd10code}}(the code range){p_end}
{p2colreset}{...}

{pstd}
or any combination of the above, such as {cmd:041.E09P 2W3* BQ2L/BQ2LZZZ}.

{marker checkopts}{...}
{synoptset 18}{...}
{synopthdr:checkopts}
{synoptline}
{synopt :{opt fmt:only}}check only format of the codes{p_end}
{synopt :{opt summ:ary}}frequency of each invalid or undefined code{p_end}
{synopt :{opt l:ist}}list observations with invalid or undefined ICD-10-PCS codes{p_end}
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
{synopt :{opt check}}check that variable contains ICD-10-PCS codes before cleaning{p_end}
{synopt :{opt nodot:s}}format codes without a period{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}* Either {cmd:generate()} or {cmd:replace} is required.

{marker genopts}{...}
{synoptset 18}{...}
{synopthdr:genopts}
{synoptline}
{synopt :{cmd:addcode(begin}|{cmd:end)}}add code to the beginning or end of the description{p_end}
{synopt :{opt nodot:s}}format codes without a period; must specify {cmd:addcode()}{p_end}
{synopt :{opt check}}check that variable contains ICD-10-PCS codes before
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
{bf:Data > ICD codes > ICD-10-PCS}


{marker description}{...}
{title:Description}

{pstd}
{cmd:icd10pcs} is a suite of commands for working with ICD-10-PCS procedure
codes from U.S. federal fiscal year 2016 to the present.  To see the current
version of the ICD-10-PCS procedure codes and any changes that have been
applied, type {cmd:icd10pcs query}.

{pstd}
{cmd:icd10pcs check}, {cmd:icd10pcs clean}, and {cmd:icd10pcs generate} are
data management commands.  {cmd:icd10pcs check} verifies that a variable
contains defined ICD-10-PCS procedure codes and provides a summary of any
problems encountered.  {cmd:icd10pcs clean} standardizes the format of the
codes.  {cmd:icd10pcs generate} can create a binary indicator variable for
whether the code is in a specified set of codes, a variable containing a
corresponding higher-level code, or a variable containing the description of
the code.

{pstd}
{cmd:icd10pcs lookup} and {cmd:icd10pcs search} are interactive utilities.
{cmd:icd10pcs lookup} displays descriptions of the codes specified on the
command line.  {cmd:icd10pcs search} looks for relevant ICD-10-PCS procedure
codes from keywords given on the command line.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D icd10pcsQuickstart:Quick start}

        {mansection D icd10pcsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd} Options are presented under the following headings:

        {help icd10pcs##opts_icd10pcscheck:Options for icd10pcs check}
        {help icd10pcs##opts_icd10pcsclean:Options for icd10pcs clean}
        {help icd10pcs##opts_icd10pcsgen:Options for icd10pcs generate}
        {help icd10pcs##opts_icd10pcslookup:Option for icd10pcs lookup}
        {help icd10pcs##opts_icd10pcssearch:Options for icd10pcs search}


{marker opts_icd10pcscheck}{...}
{title:Options for icd10pcs check}

{phang}
{opt fmtonly} tells {cmd:icd10pcs check} to verify that the codes fit the
format of ICD-10-PCS procedure codes but not to check whether the codes are
defined.

{phang}
{opt summary} specifies that {cmd:icd10pcs check} should report the frequency
of each invalid or undefined code that was found in the data.  Codes are
displayed in descending order by frequency.  {cmd:summary} may not be combined
with {cmd:list}.

{phang}
{opt list} specifies that {cmd:icd10pcs check} list the observation number,
the invalid or undefined ICD-10-PCS procedure code, and the reason the code is
invalid or whether it is an undefined code.  {cmd:list} may not be combined
with {cmd:summary}.

{phang}
{opth generate(newvar)} specifies that {cmd:icd10pcs check} create a new
variable containing, for each observation, 0 if the observation contains a
defined code. Otherwise, it contains a number from 1 to 11 if the code is
invalid, 77 if the code is valid only for a previous version, 88 if the code
is valid only for a later version, 99 if the code is undefined, or missing if
the code is missing. The positive numbers indicate the kind of problem and
correspond to the listing produced by {cmd:icd10pcs check}.

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10pcs check}
should reference.  {it:#} indicates the federal fiscal year for the codes.
For example, use {cmd:2016} for federal fiscal year 2016 (FFY-2016), which is
October 1, 2015 to September 30, 2016.  {cmd:icd10pcs} supports all years after
the United States officially adopted ICD-10-PCS.  The appropriate value of
{it:#} should be determined from the data source.  The default is the current
year.

{pmore}
Warning: The default value of {cmd:version()} will change over time so that
the most recent codes are used.  Using the default value rather than specifying
a specific version may change results after a new version of the codes is
introduced.


{marker opts_icd10pcsclean}{...}
{title:Options for icd10pcs clean}

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
{opt check} specifies that {cmd:icd10pcs clean} should first check that
{it:varname} contains codes that fit the format of ICD-10-PCS procedure codes.
Specifying the {opt check} option will slow down {cmd:icd10pcs clean}.

{phang}
{opt nodots} specifies that the period be removed in the final format.


{marker opts_icd10pcsgen}{...}
{title:Options for icd10pcs generate}

{phang}
{cmd:category}, {cmd:description}, and {opt range(codelist)}
specify the contents of the new variable that {cmd:icd10pcs} {cmd:generate} is
to create.  You do not need to {cmd:icd10pcs} {cmd:clean} {it:varname} before
using {cmd:icd10pcs} {cmd:generate}; it will accept any supported format or
combination of formats.

{phang2}
{cmd:category} specifies to extract the three-character category code from the
ICD-10-PCS procedure code.  The resulting variable may be used with the other
{cmd:icd10pcs} subcommands.

{phang2}
{opt description} creates {newvar} containing descriptions of the ICD-10-PCS
procedure codes.

{phang2}
{opt range(codelist)} creates a new indicator variable equal to 1 when the
ICD-10-PCS procedure code is in the range specified, equal to 0 when the
ICD-10-PCS procedure code is not in the range, and equal to missing when
{it:varname} is missing.

{phang}
{cmd:addcode(begin}|{cmd:end)} specifies that the code should be included with
the text describing the code.  Specifying {cmd:addcode(begin)} will prepend the
code to the text.  Specifying {cmd:addcode(end)} will append the code to the
text.

{phang}
{cmd:nodots} specifies that the code that is added to the description should
be formatted without a period.  {cmd:nodots} may be specified only if
{cmd:addcode()} is also specified.

{phang}
{cmd:check} specifies that {cmd:icd10pcs} {cmd:generate} should first check that
{it:varname} contains codes that fit the format of ICD-10-PCS procedure codes.
Specifying the {cmd:check} option will slow down the {cmd:generate}
subcommand.

{phang}
{cmd:long} specifies that the long description of the code be used rather than
the short (abbreviated) description.

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10pcs}
{cmd:generate} should reference.  {it:#} indicates the federal fiscal year for
the codes.  For example, use {cmd:2016} for federal fiscal year 2016
(FFY-2016), which is October 1, 2015 to September 30, 2016.  {cmd:icd10pcs}
supports all years after the United States officially adopted ICD-10-PCS.  The
appropriate value of {it:#} should be determined from the data source.  The
default is the current year.

{pmore}
Warning: The default value of {cmd:version()} will change over time so that
the most recent codes are used.  Using the default value rather than specifying
a specific version may change results after a new version of the codes is
introduced.


{marker opts_icd10pcslookup}{...}
{title:Option for icd10pcs lookup}

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10pcs lookup}
should reference.  {it:#} indicates the federal fiscal year for the codes.
For example, use {cmd:2016} for federal fiscal year 2016 (FFY-2016), which is
October 1, 2015 to September 30, 2016.  {cmd:icd10pcs} supports all years after
the United States officially adopted ICD-10-PCS.  The appropriate value of
{it:#} should be determined from the data source.  The default is the current
year.

{pmore}
Warning: The default value of {cmd:version()} will change over time so that
the most recent codes are used.  Using the default value rather than specifying
a specific version may change results after a new version of the codes is
introduced.


{marker opts_icd10pcssearch}{...}
{title:Options for icd10pcs search}

{phang}
{cmd:or} specifies that ICD-10-PCS procedure codes be searched for descriptions
that contain any word specified with {cmd:icd10pcs search}.  The default is to
list only descriptions that contain all the words specified.

{phang}
{opt matchcase} specifies that {cmd:icd10pcs search} should match the case of
the keywords given on the command line.  The default is to perform a
case-insensitive search.

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10pcs}
{cmd:search} should reference.  {it:#} indicates the federal fiscal year for the
codes.  For example, use {cmd:2016} for federal fiscal year 2016 (FFY-2016),
which is October 1, 2015 to September 30, 2016.  {cmd:icd10pcs} supports all
years after the United States officially adopted ICD-10-PCS.

{pmore}
By default, descriptions for all versions are searched, meaning that codes
that changed descriptions and that have descriptions in multiple versions that
contain the search terms will be duplicated.  To ensure a list of unique code
values, specify the version number.


{marker examples}{...}
{title:Examples}

{pstd}View the current license and log of changes that WHO has made
to the list of ICD-10 codes since {cmd:icd10pcs} was implemented in Stata{p_end}
{phang2}{cmd:. icd10pcs query}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse hosp2015}{p_end}
{phang2}{cmd:. drop if dmonth < tm(2015m10)}{p_end}

{pstd}Verify that the variable {cmd:proc1} has valid codes procedure
codes for federal fiscal year 2016{p_end}
{phang2}{cmd:. icd10pcs check proc1, version(2016)}

{pstd}Clean the codes to make them more readable{p_end}
{phang2}{cmd:. icd10pcs clean proc1, replace}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:icd10pcs} {cmd:check} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(e}{it:#}{cmd:)}}number of errors of type {it:#}{p_end}
{synopt :{cmd:r(esum)}}total number of errors{p_end}
{synopt :{cmd:r(miss)}}number of missing values{p_end}
{synopt :{cmd:r(N)}}number of nonmissing values{p_end}

{pstd}
{cmd:icd10pcs} {cmd:clean} stores the following in {cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of changes{p_end}

{pstd}
{cmd:icd10pcs} {cmd:lookup} and {cmd:icd10pcs} {cmd:search} store the
following in {cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(N_codes)}}number of codes found{p_end}
{p2colreset}{...}
