{smcl}
{* *! version 1.0.11  19oct2017}{...}
{viewerdialog icd10 "dialog icd10"}{...}
{vieweralsosee "[D] icd10" "mansection D icd10"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] icd" "help icd"}{...}
{vieweralsosee "[D] icd10cm" "help icd10cm"}{...}
{viewerjumpto "Syntax" "icd10##syntax"}{...}
{viewerjumpto "Menu" "icd10##menu"}{...}
{viewerjumpto "Description" "icd10##description"}{...}
{viewerjumpto "Links to PDF documentation" "icd10##linkspdf"}{...}
{viewerjumpto "Options" "icd10##options"}{...}
{viewerjumpto "Examples" "icd10##examples"}{...}
{viewerjumpto "Stored results" "icd10##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] icd10} {hline 2}}ICD-10 diagnosis codes{p_end}
{p2col:}({mansection D icd10:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Verify that variable contains defined codes

{p 8 16 2}
{cmd:icd10}
{cmd:check} {varname} {ifin}
[{cmd:,} {it:{help icd10##checkopts:checkopts}}]


{phang}
Clean variable and verify format of codes

{p 8 16 2}
{cmd:icd10}
{opt clean} {varname} {ifin}{cmd:,}
{c -(}{opth gen:erate(newvar)} | {opt rep:lace}{c )-}
[{it:{help icd10##cleanopts:cleanopts}}]


{phang}
Generate new variable from existing variable

{p 8 16 2}
{cmd:icd10}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{c -(}{opt cat:egory} | {opt sh:ort}{c )-} [{opt check}]

{p 8 16 2}
{cmd:icd10}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt d:escription}
[{it:{help icd10##genopts:genopts}}]

{p 8 16 2}
{cmd:icd10}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt r:ange(codelist)} [{opt check}]


{phang}
Display code descriptions

{p 8 16 2}
{cmd:icd10}
{opt look:up} {it:codelist}
[{cmd:,} {opt version(#)}]


{phang}
Search for codes from descriptions

{p 8 16 2}
{cmd:icd10}
{opt sea:rch}
[{cmd:"}]{it:text}[{cmd:"}]
[[{cmd:"}]{it:text}[{cmd:"}] {it:...}]
[{cmd:,}
{it:{help icd10##searchopts:searchopts}}]


{phang}
Display ICD-10 version

{p 8 16 2}
{cmd:icd10}
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
{synopt :{opt l:ist}}list observations with invalid or undefined ICD-10 codes{p_end}
{synopt :{opth gen:erate(newvar)}}create new variable marking invalid codes{p_end}
{synopt :{opt version(#)}}year to check codes against; default is
{cmd:version(2016)}{p_end}
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
{synopt :{opt check}}check that variable contains ICD-10 codes before cleaning{p_end}
{synopt :{opt nodot:s}}format codes without a period{p_end}
{synopt :{opt pad}}add space to the right of three-character codes{p_end}
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
{synopt :{opt check}}check that variable contains ICD-10 codes before
generating new variable{p_end}
{synopt :{opt version(#)}}select description from year {it:#}; default is {cmd:version(2016)}{p_end}
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
{bf:Data > ICD codes > ICD-10}


{marker description}{...}
{title:Description}

{pstd}
{cmd:icd10} is a suite of commands for working with the World Health
Organization's (WHO's) ICD-10 diagnosis codes from the second edition (2003)
to the fifth edition (2016).  To see the current version of the ICD-10
diagnosis codes and any changes that have been applied, type {cmd:icd10}
{cmd:query}.

{pstd}
{cmd:icd10 check}, {cmd:icd10 clean}, and {cmd:icd10 generate} are data
management commands.  {cmd:icd10 check} verifies that a variable contains
defined ICD-10 diagnosis codes and provides a summary of any problems
encountered.  {cmd:icd10 clean} standardizes the format of the codes.
{cmd:icd10 generate} can create a binary indicator variable for whether the
code is in a specified set of codes, a variable containing a corresponding
higher-level code, or a variable containing the description of the code.

{pstd} {cmd:icd10 lookup} and {cmd:icd10 search} are interactive utilities.
{cmd:icd10 lookup} displays descriptions of the codes specified on the command
line.  {cmd:icd10 search} looks for relevant ICD-10 diagnosis codes from key
words given on the command line.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D icd10Quickstart:Quick start}

        {mansection D icd10Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd} Options are presented under the following headings:

        {help icd10##opts_icd10check:Options for icd10 check}
        {help icd10##opts_icd10clean:Options for icd10 clean}
        {help icd10##opts_icd10gen:Options for icd10 generate}
        {help icd10##opts_icd10lookup:Option for icd10 lookup}
        {help icd10##opts_icd10search:Options for icd10 search}

{pstd}
Warning:
The option descriptions are brief and use jargon.  Please read 
{mansection D icdRemarksandexamplesIntroductiontoICDcoding:{it:Introduction to ICD coding}}
in {bf:[D] icd} before using the {cmd:icd10} command.


{marker opts_icd10check}{...}
{title:Options for icd10 check}

{phang}
{opt fmtonly} tells {cmd:icd10 check} to verify that the codes fit the format
of ICD-10 diagnosis codes but not to check whether the codes are defined.

{phang}
{opt summary} specifies that {cmd:icd10 check} should report the frequency of
each invalid or undefined code that was found in the data.  Codes are
displayed in descending order by frequency.  {cmd:summary} may not be combined
with {cmd:list}.

{phang}
{opt list} specifies that {cmd:icd10 check} list the observation number, the
invalid or undefined ICD-10 diagnosis code, and the reason the code is invalid
or whether it is an undefined code.  {cmd:list} may not be combined with
{cmd:summary}.

{phang}
{opth generate(newvar)} specifies that {cmd:icd10 check} create a new variable
containing, for each observation, 0 if the observation contains a defined
code. Otherwise, it contains a number from 1 to 8 if the code is invalid, 99
if the code is undefined, or missing if the code is missing. The positive
numbers indicate the kind of problem and correspond to the listing produced by
{cmd:icd10 check}.

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10 check}
should reference.  {it:#} may be any value between 2003, which is the second
edition of ICD-10 without any updates applied, and 2016, which is the fifth
edition of ICD-10.  The appropriate value of {it:#} should be determined from
the data source.  The default is {cmd:version(2016)}.


{marker opts_icd10clean}{...}
{title:Options for icd10 clean}

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
{opt check} specifies that {cmd:icd10 clean} should first check that
{it:varname} contains codes that fit the format of ICD-10 diagnosis codes.
Specifying the {opt check} option will slow down {cmd:icd10 clean}.

{phang}
{opt nodots} specifies that the period be removed in the final format.

{phang}
{opt pad} specifies that spaces be added to the end of the codes to make the
(implied) dots align vertically in listings.  The default is to left-align
codes without adding spaces.


{marker opts_icd10gen}{...}
{title:Options for icd10 generate}

{phang}
{cmd:category}, {cmd:short}, {cmd:description}, and {opt range(codelist)}
specify the contents of the new variable that {cmd:icd10} {cmd:generate} is to
create.  You do not need to {cmd:icd10} {cmd:clean} {it:varname} before using
{cmd:icd10} {cmd:generate}; it will accept any supported format or combination
of formats.

{phang2}
{cmd:category} and {cmd:short} generate a new variable that also contains
ICD-10 diagnosis codes.  The resulting variable may be used with the other
{cmd:icd10} subcommands.

{phang3}
{cmd:category} specifies to extract the three-character category code from the
ICD-10 diagnosis code.

{phang3}
{cmd:short} is designed for users who have data with greater specificity than
the standard four-character ICD-10 codes.  {cmd:short} will reduce five- and
six-character codes to their first four characters.  Three- and four-character
codes are left as they are.

{phang2}
{opt description} creates {newvar} containing descriptions of the ICD-10
diagnosis codes.

{phang2}
{opt range(codelist)} creates a new indicator variable equal to 1 when the
ICD-10 diagnosis code is in the range specified, equal to 0 when the ICD-10
diagnosis code is not in the range, and equal to missing when {it:varname} is
missing.

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
{cmd:check} specifies that {cmd:icd10} {cmd:generate} should first check that
{it:varname} contains codes that fit the format of ICD-10 diagnosis codes.
Specifying the {cmd:check} option will slow down the {cmd:generate}
subcommand.

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10 generate}
should reference.  {it:#} may be any value between 2003, which is the second
edition of ICD-10 without any updates applied, and 2016, which is the fifth
edition of ICD-10.  The appropriate value of {it:#} should be determined from
the data source.  The default is {cmd:version(2016)}.


{marker opts_icd10lookup}{...}
{title:Option for icd10 lookup}

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10 lookup}
should reference.  {it:#} may be any value between 2003, which is the second
edition of ICD-10 without any updates applied, and 2016, which is the fifth
edition of ICD-10.  The appropriate value of {it:#} should be determined from
the data source.  The default is {cmd:version(2016)}.


{marker opts_icd10search}{...}
{title:Options for icd10 search}

{phang}
{cmd:or} specifies that ICD-10 diagnosis codes be searched for descriptions
that contain any word specified with {cmd:icd10 search}.  The default is to
list only descriptions that contain all the words specified.

{phang}
{opt matchcase} specifies that {cmd:icd10 search} should match the case of the
keywords given on the command line.  The default is to perform a
case-insensitive search.

{phang}
{opt version(#)} specifies the version of the codes that {cmd:icd10 search}
should reference.  {it:#} may be any value between 2003, which is the second
edition of ICD-10 without any updates applied, and 2016, which is the fifth
edition of ICD-10.

{pmore}
By default, descriptions for all versions are searched, meaning that codes
that changed descriptions and that have descriptions in multiple versions that
contain the search terms will be duplicated.  To ensure a list of unique code
values, specify the version number.


{marker examples}{...}
{title:Examples}

{pstd}View the current license and log of changes that WHO has made
to the list of ICD-10 codes since {cmd:icd10} was implemented in Stata{p_end}
{phang2}{cmd:. icd10 query}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse australia10}

{pstd}Verify that the variable {cmd:cause} has valid codes and flag any
observations containing invalid codes{p_end}
{phang2}{cmd:. icd10 check cause, generate(prob)}

{pstd}Same as above, but also specify that the data were reported using
ICD-10 codes from 2010{p_end}
{phang2}{cmd:. icd10 check cause, generate(prob2) version(2010)}

{pstd}Clean the codes to make them more readable{p_end}
{phang2}{cmd:. icd10 clean cause, replace}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:icd10} {cmd:check} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(e}{it:#}{cmd:)}}number of errors of type {it:#}{p_end}
{synopt :{cmd:r(esum)}}total number of errors{p_end}
{synopt :{cmd:r(miss)}}number of missing values{p_end}
{synopt :{cmd:r(N)}}number of nonmissing values{p_end}

{pstd}
{cmd:icd10} {cmd:clean} stores the following in {cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of changes{p_end}

{pstd}
{cmd:icd10} {cmd:lookup} and {cmd:icd10} {cmd:search} store the following in
{cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt :{cmd:r(N_codes)}}number of codes found{p_end}
{p2colreset}{...}
