{smcl}
{* *! version 1.1.4  19oct2017}{...}
{vieweralsosee "[P] sleep" "mansection P sleep"}{...}
{viewerjumpto "Syntax" "sleep##syntax"}{...}
{viewerjumpto "Description" "sleep##description"}{...}
{viewerjumpto "Links to PDF documentation" "sleep##linkspdf"}{...}
{viewerjumpto "Example" "sleep##example"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] sleep} {hline 2}}Pause for a specified time{p_end}
{p2col:}({mansection P sleep:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

	{cmd:sleep} {it:#}

{pstd}where {it:#} is the number of milliseconds (1,000 ms = 1 second).


{marker description}{...}
{title:Description}

{pstd}
{cmd:sleep} tells Stata to pause for {it:#} ms before continuing
with the next command.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P sleepRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

	{cmd:. sleep 10000}

{pstd}pauses for 10 seconds{p_end}
