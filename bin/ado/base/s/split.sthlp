{smcl}
{* *! version 1.2.14  19oct2017}{...}
{viewerdialog split "dialog split"}{...}
{vieweralsosee "[D] split" "mansection D split"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] destring" "help destring"}{...}
{vieweralsosee "[D] egen" "help egen"}{...}
{vieweralsosee "[D] rename" "help rename"}{...}
{vieweralsosee "[D] separate" "help separate"}{...}
{vieweralsosee "[FN] String functions" "help string functions"}{...}
{viewerjumpto "Syntax" "split##syntax"}{...}
{viewerjumpto "Menu" "split##menu"}{...}
{viewerjumpto "Description" "split##description"}{...}
{viewerjumpto "Links to PDF documentation" "split##linkspdf"}{...}
{viewerjumpto "Options" "split##options"}{...}
{viewerjumpto "Examples" "split##examples"}{...}
{viewerjumpto "Stored results" "split##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] split} {hline 2}}Split string variables into parts{p_end}
{p2col:}({mansection D split:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 4 10 2}
{cmd:split}
{it:strvar}
{ifin}
[{cmd:,}
{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt g:enerate(stub)}}begin new variable names with {it:stub};
default is {it:strvar}{p_end}
{synopt :{opt p:arse(parse_strings)}}parse on specified strings; default is to
parse on spaces{p_end}
{synopt :{opt l:imit(#)}}create a maximum of {it:#} new variables{p_end}
{synopt :{opt not:rim}}do not trim leading or trailing spaces of original
variable{p_end}

{syntab :Destring}
{synopt :{opt destring}}apply {opt destring} to new string variables, replacing
initial string variables with numeric variables where possible{p_end}
{synopt :{cmdab:i:gnore("}{it:chars}{cmd:")}}remove specified nonnumeric
characters{p_end}
{synopt :{opt force}}convert nonnumeric strings to missing values{p_end}
{synopt :{opt float}}generate numeric variables as type {opt float}{p_end}
{synopt :{opt percent}}convert percent variables to fractional form{p_end}
{synoptline}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
      {bf:> Split string variables into parts}


{marker description}{...}
{title:Description}

{pstd}
{opt split} splits the contents of a string variable, {it:strvar}, into one or
more parts, using one or more {it:parse_strings} (by default, blank spaces),
so that new string variables are generated.  Thus {opt split} is useful for
separating "words" or other parts of a string variable. {it:strvar} itself is
not modified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D splitQuickstart:Quick start}

        {mansection D splitRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt generate(stub)} specifies the beginning characters of the new
variable names so that new variables {it:stub}{cmd:1}, {it:stub}{cmd:2},
etc., are produced. {it:stub} defaults to {it:strvar}.

{phang}
{opt parse(parse_strings)} specifies that, instead of using spaces,
parsing use one or more {it:parse_strings}. Most commonly,
one string that is one punctuation character will be specified.  For
example, if {cmd:parse(,)} is specified, then {cmd:{bind:"1,2,3"}} is split
into {cmd:"1"}, {cmd:"2"}, and {cmd:"3"}.

{pmore}
You can also specify 1) two or more strings that are alternative
separators of "words" and 2) strings that consist of two or more
characters.  Alternative strings should be separated by spaces. Strings
that include spaces should be bound by {cmd:{bind:" "}}. Thus if
{cmd:{bind:parse(, " ")}} is specified, {cmd:{bind:"1,2 3"}} is also
split into {cmd:"1"}, {cmd:"2"}, and {cmd:"3"}.  Note particularly the
difference between, say, {cmd:{bind:parse(a b)}} and {cmd:parse(ab)}: with the
first, {cmd:a} and {cmd:b} are both acceptable as separators, whereas with
the second, only the string {cmd:ab} is acceptable.

{phang}
{opt limit(#)} specifies an upper limit to the number of new
variables to be created. Thus {cmd:limit(2)} specifies that, at most, two new
variables be created.

{phang}
{opt notrim} specifies that the original string variable not be trimmed
of leading and trailing spaces before being parsed. {opt notrim} is not
compatible with parsing on spaces, because the latter implies that spaces
in a string are to be discarded.  You can either specify a parsing character
or, by default, allow a {opt trim}.

{dlgtab:Destring}

{phang}
{opt destring} applies {cmd:destring} to the new string variables, replacing
the variables initially created as strings by numeric variables where possible.
See {manhelp destring D}.

{phang}
{opt ignore()}, {opt force}, {opt float}, {opt percent};
see {manhelp destring D}.


{marker examples}{...}
{title:Examples}

{phang}
1.  Suppose that input is somehow misread as one string variable, say, when
you copy and paste into the Data Editor, but data are space-separated:

{p 12 16 2}
{cmd:. split var1, destring}

{phang}
2.  Email addresses split at {cmd:"@"}:

{p 12 16 2}
{cmd:. split address, p(@)}

{phang}
3.  Suppose that a string variable holds names of legal cases that should be
split into variables for plaintiff and defendant. The separators could be
{cmd:{bind:" V "}}, {cmd:{bind:" V. "}}, {cmd:{bind:" VS "}}, and
{cmd:{bind:" VS. "}}.  Note particularly the leading and trailing spaces
in our detailing of separators: 
the first separator is {cmd:{bind:" V "}}, for example, not
{cmd:"V"}, which would incorrectly split {cmd:"GOLIATH V DAVID"} into
{cmd:{bind:"GOLIATH "}}, {cmd:{bind:" DA"}}, and {cmd:"ID"}. The alternative
separators are given as the argument to {cmd:parse()}:

{p 12 16 2}
{cmd:. split case, p(" V " " V. " " VS " " VS. ")}

{pmore}Signs of problems would be the creation of more than two
variables and any variable having blank values, so check:

{p 12 16 2}
{cmd:. list case if case2 == ""}

{phang}
4.  Suppose that a string variable contains fields separated by tabs. For
example, {helpb import delimited} leaves tabs unchanged. Knowing that a tab is
{cmd:char(9)}, we can type

{p 12 16 2}
{cmd:. split data, p(`=char(9)') destring}{p_end}

{pmore}
{cmd:p(char(9))} would not work. The argument to {cmd:parse()} is taken
literally, but evaluation of functions on the fly can be forced as part of
macro substitution.

{phang}
5.  Suppose that a string variable contains substrings bound in parentheses,
such as {cmd:(1 2 3) (4 5 6)}.  Here we can split on the right parentheses
and, if desired, replace those afterward.  For example,

{p 12 12 2}
{cmd:. split data, p(")")}{break}
{cmd:. foreach v in `r(varlist)' {c -(}}{break}
{space 8}{cmd:replace `v' = `v' + ")"}{break}
{cmd:. {c )-}}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse splitxmpl}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Split {cmd:var1} into two string variables based on " " (space) as the
parsing character{p_end}
{phang2}{cmd:. split var1}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

{pstd}Drop newly created variables {cmd:var11} and {cmd:var12}{p_end}
{phang2}{cmd:. drop var11 var12}

{pstd}Split {cmd:var1} into two variables based on " " as the parsing
character and name the variables {cmd:geog1} and {cmd:geog2}{p_end}
{phang2}{cmd:. split var1, gen(geog)}

{pstd}List the result{p_end}
{phang2}{cmd:. list var1 geog*}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse splitxmpl2, clear}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Split {cmd:var1} into two variables using comma as the parsing character
and name the variables {cmd:geog1} and {cmd:geog2}{p_end}
{phang2}{cmd:. split var1, parse(,) gen(geog)}

{pstd}List the result{p_end}
{phang2}{cmd:. list var1 geog*}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse splitxmpl3, clear}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Split {cmd:date} into variables using comma-followed-by-space and space
as the parsing characters and use {cmd:ndate} as the prefix for the new
variable names{p_end}
{phang2}{cmd:. split date, parse(", "" ") gen(ndate)}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse splitxmpl4, clear}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Split {cmd:x} into variables using comma as the parsing
character, and try to replace new string variables with numeric
variables{p_end}
{phang2}{cmd:. split x, parse(,) destring}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Describe the data{p_end}
{phang2}{cmd:. describe}{p_end}
    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:split} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(nvars)}}number of new variables created{p_end}
{synopt:{cmd:r(varlist)}}names of newly created variables{p_end}
{p2colreset}{...}
