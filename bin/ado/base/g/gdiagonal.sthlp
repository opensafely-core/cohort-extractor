{smcl}
{* *! version 1.0.4  11feb2011}{...}
{* this hlp file is called by graph_matrix.dlg}{...}
{vieweralsosee "[G-2] graph matrix" "help graph_matrix"}{...}
{title:Diagonal labels}

{pstd}
There are as many diagonal labels as there are variables in the {it:varlist}
for {bind:{cmd:graph matrix}}.  As a default, the variable labels are used
as the diagonal labels.  If you wish to customize the diagonal labels,
you specify them with a list of strings in this edit box.

{pstd}
Although you
can sometimes get by without them, it is always wise
to enclose each string in quotes or compound double quotes.
A {bind:string of {cmd:.}} indicates that Stata should
use the default label.  If there are fewer labels than
variables, the remainder are assumed to be equal to the default variable
label.


{title:Examples:}

{pstd}
{cmd:Variables:} price weight mpg

    {cmd:Diagonal labels:} "US Dollars" Pounds "Miles per gallon"
    {cmd:    or          } "US Dollars" {cmd:.} "Miles per gallon"
    {cmd:    or          } {cmd:.} "Pounds" "Miles per gallon"
    {cmd:    or          } "US Dollars"
