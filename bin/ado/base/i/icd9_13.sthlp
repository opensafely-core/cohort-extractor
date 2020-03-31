{smcl}
{* *! version 1.3.4  12jan2015}{...}
{* based on version 1.3.3  27aug2014 of icd9.sthlp}{...}
{* this help file does not appear in the manual}{...}
{vieweralsosee "previously documented" "help prdocumented"}{...}
{viewerjumpto "Syntax" "icd9##syntax"}{...}
{viewerjumpto "Menu" "icd9##menu"}{...}
{viewerjumpto "Description" "icd9##description"}{...}
{viewerjumpto "Options for icd9[p] check" "icd9##options_icd9_check"}{...}
{viewerjumpto "Options for icd9[p] clean" "icd9##options_icd9_clean"}{...}
{viewerjumpto "Options for icd9[p] generate" "icd9##options_icd9_gen"}{...}
{viewerjumpto "Options for icd9[p] search" "icd9##options_icd9_search"}{...}
{viewerjumpto "Examples" "icd9##examples"}{...}
{viewerjumpto "Stored results" "icd9##results"}{...}
{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{hi:[D] icd9} {hline 2}}ICD-9-CM diagnostic and procedure codes{p_end}
{p2colreset}{...}

{p 12 12 8}
{it}[{bf:icd9} and {bf:icd9p} syntax was changed as of version 14.  This help
file documents the old syntax and as such is probably of no interest to you.
If you have set {helpb version} to less than 14 in your old do-files, you do
not have to translate {cmd:icd9} and {cmd:icd9p} to modern syntax.  This help
file is provided for those wishing to debug or understand old code.  Click
{help icd9:here} for the help file of the modern {cmd:icd9} and {cmd:icd9p}
commands.]{rm}


{marker syntax}{...}
{title:Syntax}

{phang}
Verify that variable contains defined codes

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{cmd:check} {varname}
[{cmd:,}
{opt any}
{opt l:ist}
{opth g:enerate(newvar)}]


{phang}
Verify and clean variable

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt clean} {varname}
[{cmd:,}
{opt d:ots}
{opt p:ad}]


{phang}
Generate new variable from existing variable

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt gen:erate} {newvar} {cmd:=} {varname}{cmd:,}
{opt m:ain}

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt gen:erate} {newvar} {cmd:=} {varname}{cmd:,}
{opt d:escription}
[{opt l:ong} {opt e:nd}]

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt gen:erate} {newvar} {cmd:=} {varname}{cmd:,}
{opt r:ange(icd9rangelist)}


{phang}
Display code descriptions

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt l:ookup} {it:icd9rangelist}


{phang}
Search for codes from descriptions

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt sea:rch}
[{cmd:"}]{it:text}[{cmd:"}]
[[{cmd:"}]{it:text}[{cmd:"}] {it:...}]
[{cmd:,}
{opt or}]


{phang}
Display ICD-9 code source

{p 8 16 2}
{c -(}{cmd:icd9}|{cmd:icd9p}{c )-}
{opt q:uery}


{pstd}
where {it:icd9rangelist} is

{p2colset 9 30 32 2}{...}
{p2col :{it:icd9code}}(the particular code){p_end}
{p2col :{it:icd9code}{cmd:*}}(all codes starting with){p_end}
{p2col :{it:icd9code}{cmd:/}{it:icd9code}}(the code range){p_end}
{p2colreset}{...}

{pstd}
or any combination of the above, such as {cmd:001* 018/019 E* 018.02}.
{it:icd9codes} must be typed with leading zeros:  {cmd:1} is an
error; type {cmd:001} (diagnostic code) or {cmd:01} (procedure code).

{p 4 6 2}
{opt icd9} is for use with ICD-9 diagnostic codes, and {opt icd9p} for use with
procedure codes.  The two commands' syntaxes parallel each other.


{marker menu}{...}
{title:Menu}

    {title:{c -(}icd9|icd9p{c )-} check}

{phang2}
{bf:Data > Other utilities > ICD9 utilities > Verify variable is valid}

    {title:{c -(}icd9|icd9p{c )-} clean}

{phang2}
{bf:Data > Other utilities > ICD9 utilities > Clean and verify variable}

    {title:{c -(}icd9|icd9p{c )-} generate}

{phang2}
{bf:Data > Other utilities > ICD9 utilities > Generate new variable from existing}

    {title:{c -(}icd9|icd9p{c )-} lookup}

{phang2}
{bf:Data > Other utilities > ICD9 utilities > Display code descriptions}

    {title:{c -(}icd9|icd9p{c )-} search}

{phang2}
{bf:Data > Other utilities > ICD9 utilities > Search for codes from descriptions}

    {title:{c -(}icd9|icd9p{c )-} query}

{phang2}
{bf:Data > Other utilities > ICD9 utilities > Display ICD-9 code source}


{marker description}{...}
{title:Description}

{pstd}
{opt icd9} and {opt icd9p} help when working with ICD-9-CM codes.

{pstd}
ICD-9 codes come in two forms:  diagnostic codes and procedure codes.  In this
system, 001 (cholera) and 941.45 (deep 3rd deg burn nose) are examples of
diagnostic codes, although some people write (and datasets record) 94145
rather than 941.45.  Also, 01 (incise-excis brain/skull) and 55.01
(nephrotomy) are examples of procedure codes, although some people write 5501
rather than 55.01.  {opt icd9} and {opt icd9p} understand both ways of
recording codes.

{pstd}
{* this note really is important, because it needs to be seen by skimmers.}
Important note: What constitutes a valid ICD-9 code changes over time.
For the rest of this help file, a {it:defined code} is any code
that is either currently valid, was valid at some point since version V16
(effective October 1, 1998), or has meaning as a grouping of codes.  Some
examples would help.  The diagnosis code 001, though not valid on its
own, is useful because it denotes cholera.  It is kept as a defined code
whose description ends with an asterisk (*).  The diagnosis code 645.01
was deleted between versions V16 and V18.  It remains as a defined
code, and its description ends with a hash mark (#). 

{pstd}
{opt icd9} and {opt icd9p} parallel each other; {opt icd9} is
for use with diagnostic codes, and {opt icd9p} for use with procedure codes.

{pstd}
{opt icd9}[{opt p}]
{opt check} verifies that existing variable {varname} contains defined
ICD-9 codes.  If not, {opt icd9}[{opt p}] {opt check} provides a full
report on the problems.
{opt icd9}[{opt p}] {opt check} is useful for tracking down problems when any
of the other {opt icd9}[{opt p}] commands tell you that the 
"variable does not contain
ICD-9 codes".  {opt icd9}[{opt p}] {opt check} 
verifies that each recorded code actually exists in the defined
code list.

{pstd}
{opt icd9}[{opt p}]
{opt clean} also verifies that existing variable {it:varname} contains
defined ICD-9 codes and, if it does, {opt icd9}[{opt p}] {opt clean} modifies
the variable to contain the codes in either of two standard formats.
All {opt icd9}[{opt p}] commands
work equally well with cleaned or uncleaned codes.  There are many ways of
writing the same ICD-9 code, and {opt icd9}[{opt p}] {opt clean} is designed
to ensure consistency and to make subsequent output look better.

{pstd}
{opt icd9}[{opt p}]
{opt generate}
produces new variables based on existing variables containing
(cleaned or uncleaned) ICD-9 codes.
{opt icd9}[{opt p}] {opt generate,} {opt main}
produces {newvar} containing the main code.
{opt icd9}[{opt p}] {opt generate,} {opt description}
produces {it:newvar} containing a textual description of the ICD-9 code.
{opt icd9}[{opt p}] {opt generate,} {opt range()}
produces numeric {it:newvar} containing 1 if {it:varname} records an ICD-9
code in the range listed and 0 otherwise.

{pstd}
{opt icd9}[{opt p}]
{opt lookup}
and {opt icd9}[{opt p}] {opt search}
are utility routines that are useful interactively.
{opt icd9}[{opt p}] {opt lookup} simply displays descriptions of the codes
specified on the command line, so to find out what
diagnostic E913.1 means, you can type {cmd:icd9 lookup e913.1}.  The
data that you have in memory are irrelevant -- and remain
unchanged -- when you use
{opt icd9}[{opt p}] {opt lookup}.
{opt icd9}[{opt p}] {opt search} is similar to
{opt icd9}[{opt p}] {opt lookup}, except that it turns the problem around;
{opt icd9}[{opt p}] {opt search} looks for relevant ICD-9 codes from the
description given on the command line.  For instance, you could type
{cmd:icd9 search liver} or {cmd:icd9p search liver} to obtain a list of
codes containing the word "liver".

{pstd}
{opt icd9}[{opt p}]
{opt query}
displays the identity of the source from which the ICD-9 codes
were obtained and the textual description that {opt icd9}[{opt p}] uses.

{pstd}
ICD-9 codes are commonly written two ways: with and without periods.
For instance, with diagnostic codes, you can write 001, 86221, E8008, and
V822, or you can write 001., 862.21, E800.8, and V82.2.  With procedure codes,
you can write 01, 50, 502, and 5021, or 01., 50., 50.2, and 50.21.  The
{opt icd9}[{opt p}] command does not care which syntax you use or even whether
you are consistent.  Case also is irrelevant:  v822, v82.2, V822, and V82.2
are all equivalent.  Codes may be recorded with or without leading and
trailing blanks.

{pstd}
{opt icd9}[{opt p}] works with V32, V31, V30, V29, V28, V27, V26, V25, V24,
V22, V21, V19, V18, and V16 codes.


{marker options_icd9_check}{...}
{title:Options for icd9[p] check}

{phang}
{opt any} tells {opt icd9}[{opt p}] {opt check} to verify that the codes
fit the format of ICD-9 codes but not to check whether the codes are
actually defined.  This makes {opt icd9}[{opt p}] {opt check} run faster.  For
instance, diagnostic code 230.52 (or 23052, if you prefer) looks valid,
but there is no such ICD-9 code.  Without the {opt any} option, 230.52
would be flagged as an error.  With {opt any}, 230.52
is not an error.

{phang}
{opt list} reports any invalid codes that were found in the data 
by {opt icd9}[{opt p}] {opt check}.
For example, 1, 1.1.1, and perhaps 230.52, if {opt any} is not
specified, are to be individually listed.

{phang}
{opth generate(newvar)} specifies that {opt icd9}[{opt p}]
{opt check} create new variable {it:newvar} containing, for each
observation, 0 if the code is defined and a number from 1 to 10 otherwise.  The
positive numbers indicate the kind of problem and correspond to the listing
produced by {opt icd9}[{opt p}] {opt check}.  For instance, 10 means that the
code could be valid, but it turns out not to be on the list of defined codes.


{marker options_icd9_clean}{...}
{title:Options for icd9[p] clean}

{phang}
{opt dots} specifies whether periods are to be included in the final format.
Do you want the diagnostic codes recorded, for instance, as 86221 or 862.21?
Without the {cmd:dots} option, the 86221 format would be used.
With the {opt dots} option, the 862.21 format would be used.

{phang}
{opt pad} specifies that the codes are to be padded with spaces, front
and back, to make the codes line up vertically in listings.  Specifying
{opt pad} makes the resulting codes look better when used with most other
Stata commands.


{marker options_icd9_gen}{...}
{title:Options for icd9[p] generate}

{phang}
{opt main}, {opt description}, and {opt range(icd9rangelist)}
specify what {opt icd9}[{opt p}] {opt generate} is to calculate.
{varname} always specifies a variable containing ICD-9 codes.

{phang2}
{opt main} specifies that the main code be extracted from the
ICD-9 code.  For procedure codes, the main code is the first two characters.
For diagnostic codes, the main code is usually the first three or four
characters (the characters before the dot if the code has dots).  In any case,
{opt icd9}[{opt p}] {opt generate} does not care whether the code is padded
with blanks in front or how strangely it might be written; {opt icd9}[{opt p}]
{opt generate} will find the main code and extract it.  The resulting variable
is itself an ICD-9 code and may be used with the other {opt icd9}[{opt p}]
subcommands.  This includes {opt icd9}[{opt p}] {opt generate, main}.

{phang2}
{opt description} creates {newvar} containing descriptions of the
ICD-9 codes.

{pmore2}
{opt long} is for use with {opt description}.  It specifies that the new
variable, in addition to containing the text describing the code,
contain the code, too.  Without {opt long}, {it:newvar} in an observation
might contain "bronchus injury-closed".  With {opt long}, it would contain
"862.21 bronchus injury-closed".

{pmore2}
{opt end} modifies {opt long} (specifying {opt end} implies {opt long})
and places the code at the end of the string:  "bronchus injury-closed
862.21".

{phang2}
{opt range(icd9rangelist)} allows you to create indicator variables
equal to 1 when the ICD-9 code is in the inclusive range specified.


{marker options_icd9_search}{...}
{title:Option for icd9[p] search}

{phang}
{opt or} specifies that ICD-9 codes be searched for entries
that contain any word specified after {opt icd9}[{opt p}]
{opt search}.  The default is to list only entries that contain all the words
specified.


{marker examples}{...}
{title:Examples}

{pstd}Display a description of code 526.4{p_end}
{phang2}{cmd:. icd9 lookup 526.4}{p_end}

{pstd}Look up a range of codes{p_end}
{phang2}{cmd:. icd9 lookup 526/527}{p_end}

{pstd}Search for codes containing the words jaw and disease{p_end}
{phang2}{cmd:. icd9 search jaw disease}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse patients}{p_end}

{pstd}Attempt to clean {cmd:diag1} diagnostic code variable; will return
error{p_end}
{phang2}{cmd:. icd9 clean diag1}{p_end}

{pstd}Flag observations containing invalid codes{p_end}
{phang2}{cmd:. icd9 check diag1, gen(prob)}{p_end}

{pstd}List flagged observations{p_end}
{phang2}{cmd:. list patid diag1 if prob}{p_end}

{pstd}Clean {cmd:diag2} diagnostic code variable{p_end}
{phang2}{cmd:. icd9 clean diag2}{p_end}

{pstd}Add periods to {cmd:diag2} variable{p_end}
{phang2}{cmd:. icd9 clean diag2, dots}{p_end}

{pstd}Clean {cmd:proc1} procedure code variable and add periods{p_end}
{phang2}{cmd:. icd9p clean proc1, dots}{p_end}

{pstd}Check that {cmd:proc1} contains valid procedure codes{p_end}
{phang2}{cmd:. icd9p check proc1}{p_end}

{pstd}Create variable {cmd:tp1} containing descriptions of codes in {cmd:proc1}
{p_end}
{phang2}{cmd:. icd9p generate tp1 = proc1, description}{p_end}

{pstd}Create variable {cmd:main1} containing main codes{p_end}
{phang2}{cmd:. icd9 generate main1 = diag2, main}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:icd9} {cmd:check} and {cmd:icd9p} {cmd:check} store the following in
{cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(e}{it:#}{cmd:)}}number of errors of type {it:#}{p_end}
{synopt:{cmd:r(esum)}}total number of errors{p_end}
{p2colreset}{...}

{pstd}
{cmd:icd9} {cmd:clean} and {cmd:icd9p} {cmd:clean} store the following in
{cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of changes{p_end}
{p2colreset}{...}
