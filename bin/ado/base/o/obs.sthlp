{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[D] obs" "mansection D obs"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] insobs" "help insobs"}{...}
{viewerjumpto "Syntax" "obs##syntax"}{...}
{viewerjumpto "Description" "obs##description"}{...}
{viewerjumpto "Links to PDF documentation" "obs##linkspdf"}{...}
{viewerjumpto "Examples" "obs##examples"}{...}
{p2colset 1 12 14 2}{...}
{p2col:{bf:[D] obs} {hline 2}}Increase the number of observations in a
dataset{p_end}
{p2col:}({mansection D obs:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 13 2}
{cmd:set}
{opt ob:s}
{it:#}


{marker description}{...}
{title:Description}

{pstd}
{opt set obs} changes the number of observations in the current dataset.
{it:#} must be at least as large as the current number of observations.
If there are variables in memory, the values of all new observations are set
to missing.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D obsQuickstart:Quick start}

        {mansection D obsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. drop _all}{space 6}(drop data from memory)          {p_end}
{phang}{cmd:. set obs 100}{space 4}(make 100 observations) {p_end}
{phang}{cmd:. gen x = _n}{space 5}(x = 1, 2, 3, .., 100)  {p_end}
{phang}{cmd:. gen y = x^2}{space 4}(y = 1, 4, 9, .., 10000){p_end}
{phang}{cmd:. scatter y x}{space 4}(make a graph)          {p_end}
