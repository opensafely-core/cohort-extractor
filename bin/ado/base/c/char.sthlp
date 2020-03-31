{smcl}
{* *! version 1.1.5  22mar2018}{...}
{vieweralsosee "[P] char" "mansection P char"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "[D] notes" "help notes"}{...}
{viewerjumpto "Syntax" "char##syntax"}{...}
{viewerjumpto "Description" "char##description"}{...}
{viewerjumpto "Links to PDF documentation" "char##linkspdf"}{...}
{viewerjumpto "Option" "char##option"}{...}
{viewerjumpto "Examples" "char##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[P] char} {hline 2}}Characteristics{p_end}
{p2col:}({mansection P char:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Define characteristics

{p 8 25 2}{cmd:char} [{cmd:define}] {it:evarname}{cmd:[}{it:charname}{cmd:]}
[[{cmd:"}]{it:text}[{cmd:"}]]


    List characteristics

{p 8 25 2}{cmd:char} {cmdab:l:ist}{space 5}[ {it:evarname}{cmd:[}[{it:charname}]{cmd:]} ]


    Rename characteristics

{p 8 25 2}
{cmd:char} {cmdab:ren:ame}{space 3}{it:oldvar newvar}
[{cmd:,}
{cmd:replace}
]


{pstd}Also related is

{p 8 25 2}{c -(}{cmdab:loc:al} | {cmdab:gl:obal}{c )-} {it:mname} {cmd::}
{cmd:char} {it:evarname}{cmd:[}[{it:charname}]{cmd:]}


{pstd}
{it:evarname} is a variable name or {cmd:_dta} and {it:charname} is a
characteristic name.  In the syntax diagrams, distinguish carefully between
{cmd:[]}, which you type, and [], which indicate the element is optional.


{marker description}{...}
{title:Description}

{pstd}
The dataset itself and each variable within the dataset have associated
with them a set of characteristics.  Characteristics are named and referred to
as {it:varname}{cmd:[}{it:charname}{cmd:]}, where {it:varname} is the name of
a variable or {cmd:_dta}.  The characteristics contain text.  Characteristics
are stored with the dataset in the Stata-format {cmd:.dta} dataset, so they are
recalled whenever the dataset is loaded.

{pstd}
Characteristics are sometimes used in Stata programs to store additional
metadata for variables.  See {findalias frchars} for more details.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P charRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:replace} (for use only with {cmd:char} {cmd:rename}) specifies that if
    characteristics of the same name already exist, they are to be replaced.
    {cmd:replace} is a seldom-used, low-level, programmer's option.

{pmore}
    {cmd:char} {cmd:rename} {it:oldvar} {it:newvar} moves all characteristics
    of {it:oldvar} to {it:newvar}, leaving {it:oldvar} with none and
    {it:newvar} with all the characteristics {it:oldvar} previously had.
    {cmd:char} {cmd:rename} {it:oldvar} {it:newvar} moves the characteristics,
    but only if {it:newvar} has no characteristics with the same name.
    Otherwise, {cmd:char} {cmd:rename} produces the error message that
    {it:newvar}{cmd:[}{it:whatever}{cmd:]} already exists.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}Define characteristic {cmd:one} attached to the data{p_end}
{phang2}{cmd:. char _dta[one] this is char named one of _dta}

{pstd}Define characteristic {cmd:two} attached to the data{p_end}
{phang2}{cmd:. char _dta[two] this is char named two of _dta}

{pstd}List the characteristics{p_end}
{phang2}{cmd:. char list}

{pstd}Clear characteristic {cmd:two} attached to the data{p_end}
{phang2}{cmd:. char _dta[two]}

{pstd}List the characteristics{p_end}
{phang2}{cmd:. char list}

{pstd}Define characteristic {cmd:one} attached to variable {cmd:mpg}{p_end}
{phang2}{cmd:. char mpg[one] this is char named one of mpg}

{pstd}Define characteristic {cmd:two} attached to variable {cmd:mpg}{p_end}
{phang2}{cmd:. char mpg[two] this is char named two of mpg}

{pstd}List all the characteristics{p_end}
{phang2}{cmd:. char list}

{pstd}List the characteristics attached to variable {cmd:mpg}{p_end}
{phang2}{cmd:. char list mpg[]}

{pstd}Move the characteristics attached to variable {cmd:mpg} to variable
{cmd:price}{p_end}
{phang2}{cmd:. char rename mpg price}

{pstd}List the characteristics attached to variable {cmd:price}{p_end}
{phang2}{cmd:. char list price[]}{p_end}
