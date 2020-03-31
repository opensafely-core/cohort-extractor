{smcl}
{* *! version 1.0.2  19oct2017}{...}
{viewerdialog icd9p "dialog icd9"}{...}
{vieweralsosee "[D] icd9p" "mansection D icd9p"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] icd" "help icd"}{...}
{vieweralsosee "[D] icd9" "help icd9"}{...}
{vieweralsosee "[D] icd10pcs" "help icd10pcs"}{...}
{viewerjumpto "Syntax" "icd9p##syntax"}{...}
{viewerjumpto "Menu" "icd9p##menu"}{...}
{viewerjumpto "Description" "icd9p##description"}{...}
{viewerjumpto "Links to PDF documentation" "icd9p##linkspdf"}{...}
{viewerjumpto "Options" "icd9p##options"}{...}
{viewerjumpto "Examples" "icd9p##examples"}{...}
{viewerjumpto "Stored results" "icd9p##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] icd9p} {hline 2}}ICD-9-CM procedure codes{p_end}
{p2col:}({mansection D icd9p:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Verify that variable contains defined codes

{p 8 16 2}
{cmd:icd9p}
{cmd:check} {varname}
{ifin}
[{cmd:,}
{opt any}
{opt l:ist}
{opth g:enerate(newvar)}]


{phang}
Clean variable and verify format of codes 

{p 8 16 2}
{cmd:icd9p}
{opt clean} {varname}
{ifin}
[{cmd:,}
{opt dot:s}
{opt pad}]


{phang}
Generate new variable from existing variable

{p 8 16 2}
{cmd:icd9p}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt cat:egory}

{p 8 16 2}
{cmd:icd9p}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt d:escription}
[{opt long} {opt end}]

{p 8 16 2}
{cmd:icd9p}
{opt gen:erate} {newvar} {cmd:=} {varname} {ifin}{cmd:,}
{opt r:ange(codelist)}


{phang}
Display code descriptions

{p 8 16 2}
{cmd:icd9p}
{opt look:up} {it:codelist}


{phang}
Search for codes from descriptions

{p 8 16 2}
{cmd:icd9p}
{opt sea:rch}
[{cmd:"}]{it:text}[{cmd:"}]
[[{cmd:"}]{it:text}[{cmd:"}] {it:...}]
[{cmd:,}
{opt or}]


{phang}
Display ICD-9 code source

{p 8 16 2}
{cmd:icd9p}
{opt q:uery}


{pstd}
{it:codelist} is

{p2colset 9 30 32 2}{...}
{p2col :{it:icd9code}}(the particular code){p_end}
{p2col :{it:icd9code}{cmd:*}}(all codes starting with){p_end}
{p2col :{it:icd9code}{cmd:/}{it:icd9code}}(the code range){p_end}
{p2colreset}{...}

{pstd}
or any combination of the above, such as {cmd:50.21 37.7* 88.71/88.79}.
{it:icd9codes} must be typed with leading 0s.  For example, type
{cmd:01}; typing {cmd:1} will result in an error.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > ICD codes > ICD-9}


{marker description}{...}
{title:Description}

{pstd}
{cmd:icd9p} is a suite of commands for working with ICD-9-CM procedure codes
from the 16th version (effective October 1998) to the 32nd version.  To see
the current version of the ICD-9-CM procedure codes and any changes that have
been applied, type {cmd:icd9p query}.

{pstd}
{cmd:icd9p check}, {cmd:icd9p clean}, and {cmd:icd9p generate} are data
management commands.  {cmd:icd9p check} verifies that a variable contains
defined ICD-9-CM procedure codes and provides a summary of any problems
encountered.  {cmd:icd9p clean} standardizes the format of the codes.
{cmd:icd9p generate} can create a binary indicator variable for whether the
code is in a specified set of codes, a variable containing a corresponding
higher-level code, or a variable containing the description of the code.

{pstd}
{cmd:icd9p lookup} and {cmd:icd9p search} are interactive utilities.
{cmd:icd9p lookup} displays descriptions of the codes specified on the command
line.  {cmd:icd9p search} looks for relevant ICD-9-CM procedure codes from key
words given on the command line.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D icd9pQuickstart:Quick start}

        {mansection D icd9pRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{pstd}Options are presented under the following headings:

        {help icd9p##options_icd9p_check:Options for icd9p check}
        {help icd9p##options_icd9p_clean:Options for icd9p clean}
        {help icd9p##options_icd9p_gen:Options for icd9p generate}
        {help icd9p##options_icd9p_search:Options for icd9p search}


{marker options_icd9p_check}{...}
{title:Options for icd9p check}

{phang}
{cmd:any} tells {cmd:icd9p} check to verify that the codes fit the format of
ICD-9-CM procedure codes but not to check whether the codes are defined.

{phang}
{cmd:list} specifies that {cmd:icd9p check} list the observation number, the
invalid or undefined ICD-9-CM procedure code, and the reason the code is
invalid or whether it is an undefined code.

{phang}
{opth generate(newvar)} specifies that {cmd:icd9p check} create a new variable
containing, for each observation, 0 if the observation contains a defined code
or is missing.  Otherwise, it contains a number from 1 to 10.  The positive
numbers indicate the kind of problem and correspond to the listing produced by
{cmd:icd9p check}.


{marker options_icd9p_clean}{...}
{title:Options for icd9p clean}

{phang}
{opt dots} specifies that the period be included in the final format.
If {opt dots} is not specified, then all periods are removed.

{phang}
{opt pad} specifies that {cmd:icd9p clean} pad the codes with spaces, front
and back, to make the (implied) dots align vertically in listings.  Specifying
{opt pad} makes the resulting codes look better when used with most other
Stata commands.


{marker options_icd9p_gen}{...}
{title:Options for icd9p generate}

{phang}
{opt category}, {opt description}, and {opt range(codelist)} specify the
contents of the new variable that {opt icd9p} {opt generate} is to create.
You do not need to {opt icd9p} {opt clean} {it:varname} before using
{opt icd9p} {opt generate}; it will accept any supported format or combination
of formats.

{phang2}
{opt category} creates a new variable that contains ICD-9-CM procedure
category codes.  The resulting variable may be used with the other {cmd:icd9p}
subcommands.  For procedure codes, the category code is the first two
characters.

{phang2}
{opt description} creates {newvar} containing descriptions of the ICD-9-CM
procedure codes.

{phang3}
{opt long} is for use with {opt description}.  It specifies that the
code be prepended to the text describing the code.

{phang3}
{opt end} modifies {opt long} (specifying {opt end} implies {opt long})
and places the code at the end of the string.

{phang2}
{opt range(codelist)} creates a new indicator variable equal to 1 when the
ICD-9-CM procedure code is in the range specified, equal to 0 when the
ICD-9-CM procedure code is not in the range, and equal to missing when
{it:varname} is missing.


{marker options_icd9p_search}{...}
{title:Option for icd9p search}

{phang}
{opt or} specifies that ICD-9-CM procedure codes be searched for descriptions
that contain any word specified with {opt icd9p} {opt search}.  The default is
to list only descriptions that contain all the words specified.


{marker examples}{...}
{title:Examples}

{pstd}View log of changes made to the list of ICD-9 codes since {cmd:icd9p} was
implemented in Stata{p_end}
{phang2}{cmd:. icd9p query}{p_end}

{pstd}Display a description of code 526.4{p_end}
{phang2}{cmd:. icd9p lookup 526.4}{p_end}

{pstd}Look up a range of codes{p_end}
{phang2}{cmd:. icd9p lookup 526/527}{p_end}

{pstd}Search for codes containing the words jaw and disease{p_end}
{phang2}{cmd:. icd9p search jaw disease}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nhds2010}{p_end}

{pstd}Clean {cmd:pr1} procedure code variable and add periods{p_end}
{phang2}{cmd:. icd9p clean pr1, dots}{p_end}

{pstd}Check that {cmd:pr1} contains valid procedure codes if {cmd:pr1}
is not missing{p_end}
{phang2}{cmd:. icd9p check pr1 if !missing(pr1)}{p_end}

{pstd}Create variable {cmd:dp1} containing descriptions of codes in {cmd:pr1}
{p_end}
{phang2}{cmd:. icd9p generate dp1 = pr1, description}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:icd9p} {cmd:check} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(e}{it:#}{cmd:)}}number of errors of type {it:#}{p_end}
{synopt:{cmd:r(esum)}}total number of errors{p_end}
{p2colreset}{...}

{pstd}
{cmd:icd9p} {cmd:clean} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of changes{p_end}
{p2colreset}{...}

{pstd}
{cmd:icd9p} {cmd:lookup} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of codes found{p_end}
{p2colreset}{...}
