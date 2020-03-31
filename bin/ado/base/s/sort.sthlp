{smcl}
{* *! version 1.1.12  19oct2017}{...}
{viewerdialog sort "dialog sort"}{...}
{vieweralsosee "[D] sort" "mansection D sort"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] gsort" "help gsort"}{...}
{viewerjumpto "Syntax" "sort##syntax"}{...}
{viewerjumpto "Menu" "sort##menu"}{...}
{viewerjumpto "Description" "sort##description"}{...}
{viewerjumpto "Links to PDF documentation" "sort##linkspdf"}{...}
{viewerjumpto "Option" "sort##option"}{...}
{viewerjumpto "Examples" "sort##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] sort} {hline 2}}Sort data{p_end}
{p2col:}({mansection D sort:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{opt so:rt}
{varlist}
[{it:{help in}}]
[{cmd:,} {opt stable}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Sort}


{marker description}{...}
{title:Description}

{pstd}
{opt sort} arranges the observations of the current data into ascending order
based on the values of the variables in {varlist}.  There is no limit to the
number of variables in the {it:varlist}.  Missing numeric values (see 
{help missing}) are interpreted as being larger than any other number, so they
are placed last with {cmd:. < .a < .b < ... < .z}.  When you sort on a string
variable, however, null strings are placed first and uppercase letters come
before lowercase letters.

{pstd}
The dataset is marked as
being sorted by {it:varlist} unless {help in:{bf:in} {it:range}} is specified.
If {opt in} {it:range} is specified, only those observations are rearranged.
The unspecified observations remain in the same place.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D sortQuickstart:Quick start}

        {mansection D sortRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt stable} specifies that observations with the same values of the variables
in {varlist} keep the same relative order in the sorted data that
they had previously.  For instance, consider the following data:

{center:x  b}
{center:3  1}
{center:1  2}
{center:1  1}
{center:1  3}
{center:2  4}

{pmore}
Typing {cmd:sort x} without the {opt stable} option produces one of the
following six orderings.

{center:x  b  {c |}  x  b  {c |}  x  b  {c |}  x  b  {c |}  x  b  {c |}  x  b}
{center:1  2  {c |}  1  2  {c |}  1  1  {c |}  1  1  {c |}  1  3  {c |}  1  3}
{center:1  1  {c |}  1  3  {c |}  1  3  {c |}  1  2  {c |}  1  1  {c |}  1  2}
{center:1  3  {c |}  1  1  {c |}  1  2  {c |}  1  3  {c |}  1  2  {c |}  1  1}
{center:2  4  {c |}  2  4  {c |}  2  4  {c |}  2  4  {c |}  2  4  {c |}  2  4}
{center:3  1  {c |}  3  1  {c |}  3  1  {c |}  3  1  {c |}  3  1  {c |}  3  1}

{pmore}
Without the {opt stable} option, the ordering of observations with equal
values of {it:varlist} is randomized.  With {cmd:sort x, stable}, you will
always get the first ordering and never the other five.

{pmore}
If your intent is to have the observations sorted first on {opt x} and then
on {opt b} within tied values of {opt x} (the fourth ordering above), you
should type {opt sort x b} rather than {opt sort x, stable}.

{pmore}
{opt stable} is seldom used, and, when specified, causes {opt sort} to
execute more slowly.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. keep make mpg weight}

{pstd}Arrange observations into ascending order based on the values of
{cmd:mpg}{p_end}
{phang2}{cmd:. sort mpg}

{pstd}Same as above, but for observations with the same values of {cmd:mpg},
keep them in the same relative order in the sorted data as they had previously
{p_end}
{phang2}{cmd:. sort mpg, stable}

{pstd}List the 5 cars with the lowest {cmd:mpg}{p_end}
{phang2}{cmd:. list make mpg in 1/5}

{pstd}List the 5 cars with the highest {cmd:mpg}{p_end}
{phang2}{cmd:. list make mpg in -5/L}

{pstd}Arrange observations into ascending order based on the values of
{cmd:mpg}, and within each {cmd:mpg} category arrange observations into
ascending order based on the values of {cmd:weight}{p_end}
{phang2}{cmd:. sort mpg weight}

{pstd}List the 8 cars with the lowest {cmd:mpg}, and within each {cmd:mpg}
category with the lowest {cmd:weight}{p_end}
{phang2}{cmd:. list in 1/8}{p_end}

{pstd}Arrange observations into alphabetical order based on the value of
{cmd:make}{p_end}
{phang2}{cmd:. sort make}

{pstd}
For most purposes, this method of sorting is sufficient.  It is possible to
override Stata's sort logic.  See {findalias frunicodesort} for information
about ordering strings in a language-sensitive way.  We do not recommend that
you do this.
{p_end}
