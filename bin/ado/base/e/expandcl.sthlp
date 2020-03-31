{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog expandcl "dialog expandcl"}{...}
{vieweralsosee "[D] expandcl" "mansection D expandcl"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] bsample" "help bsample"}{...}
{vieweralsosee "[D] expand" "help expand"}{...}
{viewerjumpto "Syntax" "expandcl##syntax"}{...}
{viewerjumpto "Menu" "expandcl##menu"}{...}
{viewerjumpto "Description" "expandcl##description"}{...}
{viewerjumpto "Links to PDF documentation" "expandcl##linkspdf"}{...}
{viewerjumpto "Options" "expandcl##options"}{...}
{viewerjumpto "Example" "expandcl##example"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[D] expandcl} {hline 2}}Duplicate clustered observations{p_end}
{p2col:}({mansection D expandcl:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:expandcl} [=]{it:{help exp}} {ifin} {cmd:,} {opth cl:uster(varlist)}
{opth gen:erate(newvar)}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
    {bf:> Duplicate clustered observations}


{marker description}{...}
{title:Description}

{pstd}
{cmd:expandcl} duplicates clusters of observations and generates a new
variable that identifies the clusters uniquely.

{pstd}
{cmd:expandcl} replaces each cluster in the dataset with n copies of
the cluster, where n is equal to the required expression rounded to the nearest
integer.  The expression is required to be constant within cluster.  If the
expression is less than 1 or equal to {it:missing}, it is interpreted as if it
were 1, and the cluster is retained but not duplicated.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D expandclQuickstart:Quick start}

        {mansection D expandclRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth cluster(varlist)} is required and specifies the variables that identify
the clusters before expanding the data.

{phang}
{opth generate(newvar)} is required and stores unique identifiers for the
duplicated clusters in {it:newvar}.  {it:newvar} will identify the clusters
by using consecutive integers starting from 1.


{marker example}{...}
{title:Example}

    Setup
{phang2}{cmd:. webuse expclxmpl}{p_end}

    List the data
{phang2}{cmd:. list, sep(0)}

{pstd}Replace each cluster with {cmd:n} copies of the cluster{p_end}
{phang2}{cmd:. expandcl n, generate(newcl) cluster(cl)}{p_end}

{pstd}Sort the observations based on values of {cmd:newcl}, {cmd:cl}, 
and {cmd:x}{p_end}
{phang2}{cmd:. sort newcl cl x}{p_end}

    List the resulting data
{phang2}{cmd:. list, sepby(newcl)}{p_end}
