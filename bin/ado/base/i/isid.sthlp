{smcl}
{* *! version 1.1.8  19oct2017}{...}
{viewerdialog isid "dialog isid"}{...}
{vieweralsosee "[D] isid" "mansection D isid"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] ds" "help ds"}{...}
{vieweralsosee "[D] duplicates" "help duplicates"}{...}
{vieweralsosee "[D] lookfor" "help lookfor"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] inspect" "help inspect"}{...}
{viewerjumpto "Syntax" "isid##syntax"}{...}
{viewerjumpto "Menu" "isid##menu"}{...}
{viewerjumpto "Description" "isid##description"}{...}
{viewerjumpto "Links to PDF documentation" "isid##linkspdf"}{...}
{viewerjumpto "Options" "isid##options"}{...}
{viewerjumpto "Examples" "isid##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[D] isid} {hline 2}}Check for unique identifiers{p_end}
{p2col:}({mansection D isid:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmd:isid}
{varlist}
[{cmd:using} {it:{help filename}}]
[{cmd:,}
{opt s:ort}
{opt m:issok}]


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Data utilities > Check for unique identifiers}


{marker description}{...}
{title:Description}

{pstd}
{opt isid} checks whether the specified variables uniquely identify the
observations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D isidQuickstart:Quick start}

        {mansection D isidRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{opt sort} indicates that the dataset be sorted by {varlist}.

{phang}{opt missok} indicates that missing values are permitted in {varlist}.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
{phang2}{cmd:. sysuse auto}

{pstd}Check whether {cmd:mpg} uniquely identifies observations{p_end}
{phang2}{cmd:. isid mpg}

{pstd}Check whether {cmd:make} uniquely identifies observations{p_end}
{phang2}{cmd:. isid make}

    Setup
{phang2}{cmd:. replace make = "" in 1}

{pstd}Check whether {cmd:make} uniquely identifies observations{p_end}
{phang2}{cmd:. isid make}

{pstd}Same as above command, but permit missing values in {cmd:make}{p_end}
{phang2}{cmd:. isid make, missok}

    {hline}
    Setup
{phang2}{cmd:. webuse grunfeld, clear}

{pstd}Check whether panel and time variables uniquely identify
observations{p_end}
{phang2}{cmd:. isid company year}{p_end}
    {hline}
