{smcl}
{* *! version 1.2.4  15may2018}{...}
{vieweralsosee "[FN] Functions by category" "mansection FN Functionsbycategory"}{...}
{vieweralsosee "[FN] Functions by name" "mansection FN Functionsbyname"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] egen" "help egen"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{vieweralsosee "[M-4] Intro" "help m4_intro"}{...}
{findalias asfrfunctions}{...}
{viewerjumpto "Description" "functions##description"}{...}
{viewerjumpto "Introduction" "functions##intro"}{...}
{viewerjumpto "Examples" "functions##examples"}{...}
{p2colset 1 31 33 2}{...}
{p2col:{bf:[FN] Functions by category}}
{p_end}
{p2col:({mansection FN Functionsbycategory:View complete PDF manual entry})}{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

    Quick references are available for the following types of functions:

        {c TLC}{hline 30}{c TT}{hline 25}{c TRC}
        {c |} Type of function{space 13}{c |} See help                {c |}
        {c LT}{hline 30}{c +}{hline 25}{c RT}
        {c |} Date and time {space 15}{c |} {help datetime functions}      {c |}
        {c |}{space 30}{c |}{space 25}{c |}
        {c |} Mathematical {space 16}{c |} {help mathematical functions}  {c |}
        {c |}{space 30}{c |}{space 25}{c |}
        {c |} Matrix {space 22}{c |} {help matrix functions}        {c |}
        {c |}{space 30}{c |}{space 25}{c |}
        {c |} Programming {space 17}{c |} {help programming functions}   {c |}
        {c |}{space 30}{c |}{space 25}{c |}
        {c |} Random-number {space 15}{c |} {help random-number functions} {c |}
        {c |}{space 30}{c |}{space 25}{c |}
        {c |} Selecting time spans {space 8}{c |} {help time-series functions}   {c |}
        {c |}{space 30}{c |}{space 25}{c |}
        {c |} Statistical {space 17}{c |} {help statistical functions}   {c |}
        {c |}{space 30}{c |}{space 25}{c |}
        {c |} String {space 22}{c |} {help string functions}        {c |}
        {c |}{space 30}{c |}{space 25}{c |}
        {c |} Trigonometric {space 15}{c |} {help trigonometric functions} {c |}
        {c |}{space 30}{c |}{space 25}{c |}
        {c BLC}{hline 30}{c BT}{hline 25}{c BRC}


{marker intro}{...}
{title:Introduction}

{pstd}
Functions are used in expressions, which are abbreviated {help exp} in
syntax diagrams.  For example, a simplified version of {helpb generate}'s
syntax is

{phang2}{cmd:generate} {it:newvar} {cmd:=} {it:exp}

{pstd}
and thus, one might type "{cmd:generate loginc = ln(income)}".  {cmd:ln()}
is a function.

{pstd}
Functions may be specified in any expression.  The arguments of a function
may be any expression, including other functions.

{pstd}
A function's arguments are enclosed in parentheses and, if there are
multiple arguments, separated by commas.

{pstd}
Functions return {it:missing} ({hi:.}) when the value of the
function is undefined.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. generate y = sqrt(abs(z*z-x*x-y))}

{phang}{cmd:. gen str20 new = cond(sex=="m","Mr. ", "Ms. ") + proper(name)}
{p_end}
