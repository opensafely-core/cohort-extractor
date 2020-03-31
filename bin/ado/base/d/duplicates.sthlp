{smcl}
{* *! version 1.2.16  01mar2018}{...}
{viewerdialog report "dialog duplicates_report"}{...}
{viewerdialog examples "dialog duplicates_report, message(-example-)"}{...}
{viewerdialog list "dialog duplicates_report, message(-list-)"}{...}
{viewerdialog tag "dialog duplicates_tag"}{...}
{viewerdialog drop "dialog duplicates_drop"}{...}
{vieweralsosee "[D] duplicates" "mansection D duplicates"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] contract" "help contract"}{...}
{vieweralsosee "[D] edit" "help edit"}{...}
{vieweralsosee "[D] isid" "help isid"}{...}
{vieweralsosee "[D] list" "help list"}{...}
{viewerjumpto "Syntax" "duplicates##syntax"}{...}
{viewerjumpto "Menu" "duplicates##menu"}{...}
{viewerjumpto "Description" "duplicates##description"}{...}
{viewerjumpto "Links to PDF documentation" "duplicates##linkspdf"}{...}
{viewerjumpto "Options for duplicates examples and duplicates list" "duplicates##options_duplicates_examples"}{...}
{viewerjumpto "Option for duplicates tag" "duplicates##option_duplicates_tag"}{...}
{viewerjumpto "Option for duplicates drop" "duplicates##option_duplicates_drop"}{...}
{viewerjumpto "Remarks" "duplicates##remarks"}{...}
{viewerjumpto "Examples" "duplicates##examples"}{...}
{viewerjumpto "Video example" "duplicates##video"}{...}
{viewerjumpto "Stored results" "duplicates##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[D] duplicates} {hline 2}}Report, tag, or drop duplicate observations{p_end}
{p2col:}({mansection D duplicates:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Report duplicates

{p 8 10 2}
{cmd:duplicates} {opt r:eport} [{varlist}] {ifin} 


{phang}
List one example for each group of duplicates

{p 8 10 2}
{cmd:duplicates} {opt e:xamples} [{varlist}] {ifin}
[{cmd:,} {it:{help duplicates##options:options}}]


{phang}
List all duplicates

{p 8 10 2}
{cmd:duplicates} {opt l:ist} [{varlist}] {ifin}
[{cmd:,} {it:{help duplicates##options:options}}]


{phang}
Tag duplicates

{p 8 10 2}
{cmd:duplicates} {opt t:ag} [{varlist}] {ifin}
{cmd:,} {opth g:enerate(newvar)}


{phang}
Drop duplicates

{p 8 10 2}
{cmd:duplicates} {opt drop} {ifin}

{p 8 10 2}
{cmd:duplicates} {opt drop} {varlist} {ifin}
{cmd:, force}


{synoptset 23 tabbed}{...}
{marker options}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt c:ompress}}compress width of columns in both table and display formats{p_end}
{synopt :{opt noc:ompress}}use display format of each variable{p_end}
{synopt :{opt fast}}synonym for {opt nocompress}; no delay in output of large datasets{p_end}
{synopt :{opt ab:breviate(#)}}abbreviate variable names to {it:#} characters; default is {cmd:ab(8)}{p_end}
{synopt :{opt str:ing(#)}}truncate string variables to {it:#} characters; default is {cmd:string(10)}{p_end}

{syntab :Options}
{synopt :{opt t:able}}force table format{p_end}
{synopt :{opt d:isplay}}force display format{p_end}
{synopt :{opt h:eader}}display variable header once; default is table mode{p_end}
{synopt :{opt noh:eader}}suppress variable header{p_end}
{synopt :{opt h:eader(#)}}display variable header every {it:#} lines{p_end}
{synopt :{opt clean}}force table format with no divider or separator lines{p_end}
{synopt :{opt div:ider}}draw divider lines between columns{p_end}
{synopt :{opt sep:arator(#)}}draw a separator line every {it:#} lines; default is {cmd:separator(5)}{p_end}
{synopt :{opth sepby(varlist)}}draw a separator line whenever {it:varlist} values change{p_end}
{synopt :{opt nol:abel}}display numeric codes rather than label values{p_end}

{syntab :Summary}
{synopt :{opt mean}[{cmd:(}{varlist}{cmd:)}]}add line reporting the mean for each of the (specified) variables{p_end}
{synopt :{opt sum}[{cmd:(}{varlist}{cmd:)}]}add line reporting the sum for each of the (specified) variables{p_end}
{synopt :{opt N}[{cmd:(}{varlist}{cmd:)}]}add line reporting the number of nonmissing values for each of the (specified) variables{p_end}
{synopt :{opth labv:ar(varname)}}substitute {opt Mean}, {opt Sum}, or {opt N}
for value of {it:varname} in last row of table{p_end}

{syntab :Advanced}
{synopt :{opt con:stant}[{cmd:(}{varlist}{cmd:)}]}separate and list variables that are constant only once{p_end}
{synopt :{opt notr:im}}suppress string trimming{p_end}
{synopt :{opt abs:olute}}display overall observation numbers when using {opt by} {varlist}{cmd::}{p_end}
{synopt :{opt nodotz}}display numerical values equal to {opt .z} as field of blanks{p_end}
{synopt :{opt subvar:name}}substitute characteristic for variable name in header{p_end}
{synopt :{opt line:size(#)}}columns per line; default is {cmd:linesize(79)}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:duplicates report, duplicates examples, and duplicates list}

{phang2}
{bf:Data > Data utilities > Report and list duplicated observations}

    {title:duplicates tag}

{phang2}
{bf:Data > Data utilities > Tag duplicated observations}

    {title:duplicates drop}

{phang2}
{bf:Data > Data utilities > Drop duplicated observations}


{marker description}{...}
{title:Description}

{pstd}
{cmd:duplicates} reports, displays, lists, tags,
or drops duplicate observations, depending on the subcommand specified.
Duplicates are observations with identical values either on all
variables if no {varlist} is specified or on a specified {it:varlist}.

{pstd}
{cmd:duplicates report} produces a table showing observations
that occur as one or more copies and indicating how many observations are
"surplus" in the sense that they are the second (third, ...) copy of the first
of each group of duplicates.

{pstd}
{cmd:duplicates examples} lists one example for each group of
duplicated observations.  Each example represents the first occurrence of each
group in the dataset.

{pstd}
{cmd:duplicates list} lists all duplicated observations.

{pstd}
{cmd:duplicates tag} generates a variable representing the number of
duplicates for each observation.  This will be 0 for all
unique observations.

{pstd}
{cmd:duplicates drop} drops all but the first occurrence of each group
of duplicated observations.  The word {opt drop} may not be abbreviated.

{pstd}
Any observations that do not satisfy specified {opt if} and/or {opt in}
conditions are ignored when you use {opt report}, {opt examples}, {opt list},
or {opt drop}.  The variable created by {opt tag} will have
missing values for such observations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D duplicatesQuickstart:Quick start}

        {mansection D duplicatesRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_duplicates_examples}{...}
{title:Options for duplicates examples and duplicates list}

{dlgtab:Main}

{phang}
{opt compress}, {opt nocompress}, {opt fast}, {opt abbreviate(#)}, 
{opt string(#)}; see {manhelp list D}.

{dlgtab:Options}

{phang}
{opt table}, {opt display}, {opt header}, {opt noheader}, {opt header(#)}, 
{opt clean}, {opt divider}, {opt separator(#)}, {opth sepby(varlist)}, 
{opt nolabel}; see {manhelp list D}.

{dlgtab:Summary}

{phang}
{opt mean}[{cmd:(}{varlist}{cmd:)}], {opt sum}[{cmd:(}{it:varlist}{cmd:)}],
{opt N}[{cmd:(}{it:varlist}{cmd:)}], {opt labvar(varname)}; see
{manhelp list D}.

{dlgtab:Advanced}

{phang}
{opt constant}[{cmd:(}{varlist}{cmd:)}], {opt notrim}, {opt absolute}, {opt nodotz}, {opt subvarname}, {opt linesize(#)}; see {manhelp list D}.


{marker option_duplicates_tag}{...}
{title:Option for duplicates tag}

{phang}
{opth generate(newvar)} is required and specifies the name of a new variable
that will tag duplicates.


{marker option_duplicates_drop}{...}
{title:Option for duplicates drop}

{phang}
{opt force} specifies that observations duplicated with respect to a named
{varlist} be dropped.  The {cmd:force} option is required when such
a {it:varlist} is given as a reminder that information may be lost by dropping
observations, given that those observations may differ on any variable
not included in {it:varlist}.


{marker remarks}{...}
{title:Remarks}

{pstd}
As of Stata 11, the {cmd:browse} subcommand is no longer available.  To open 
duplicates in the Data Browser, use the following commands:

{phang2}{cmd:. duplicates tag, generate({it:newvar})}{p_end}
{phang2}{cmd:. browse if {it:newvar} > 0}{p_end}

{phang}See {manhelp edit D} for details on the {cmd:browse} command.{p_end}


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. keep make price mpg rep78 foreign}{p_end}
{phang2}{cmd:. expand 2 in 1/2}{p_end}

{pstd}Report duplicates{p_end}
{phang2}{cmd:. duplicates report}{p_end}

{pstd}List one example for each group of duplicated observations{p_end}
{phang2}{cmd:. duplicates examples}{p_end}

{pstd}List all duplicated observations{p_end}
{phang2}{cmd:. duplicates list}{p_end}

{pstd}Create variable {cmd:dup} containing the number of duplicates
(0 if observation is unique){p_end}
{phang2}{cmd:. duplicates tag, generate(dup)}{p_end}

{pstd}List the duplicated observations{p_end}
{phang2}{cmd:. list if dup==1}{p_end}

{pstd}Drop all but the first occurrence of each group of duplicated
observations{p_end}
{phang2}{cmd:. duplicates drop}{p_end}

{pstd}List all duplicated observations{p_end}
{phang2}{cmd:. duplicates list}{p_end}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=433GzdIwZN8":How to identify and remove duplicate observations}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:duplicates report},
{cmd:duplicates examples},
{cmd:duplicates list},
{cmd:duplicates tag}, and
{cmd:duplicates drop}
store the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}

{pstd}
{cmd:duplicates report} also stores the following in {cmd:r()}:

{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(unique_value)}}number of unique observations{p_end}

{pstd}
{cmd:duplicates drop} also stores the following in {cmd:r()}:

{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N_drop)}}number of observations dropped{p_end}
{p2colreset}{...}
