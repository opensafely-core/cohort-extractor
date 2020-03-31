{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog xtdescribe "dialog xtdescribe"}{...}
{vieweralsosee "[XT] xtdescribe" "mansection XT xtdescribe"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[XT] xtsum" "help xtsum"}{...}
{vieweralsosee "[XT] xttab" "help xttab"}{...}
{viewerjumpto "Syntax" "xtdescribe##syntax"}{...}
{viewerjumpto "Menu" "xtdescribe##menu"}{...}
{viewerjumpto "Description" "xtdescribe##description"}{...}
{viewerjumpto "Links to PDF documentation" "xtdescribe##linkspdf"}{...}
{viewerjumpto "Options" "xtdescribe##options"}{...}
{viewerjumpto "Example" "xtdescribe##example"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[XT] xtdescribe} {hline 2}}Describe pattern of xt data{p_end}
{p2col:}({mansection XT xtdescribe:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmdab:xtdes:cribe} {ifin} [{cmd:,} {it:options}]

{synoptset 15 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt :{opt p:atterns(#)}}maximum participation patterns; default is {cmd:patterns(9)}{p_end}
{synopt :{opt w:idth(#)}}display {it:#} width of participation patterns; default is {cmd:width(100)}{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A panel variable and a time variable must be specified; use {helpb xtset}.
{p_end}
{p 4 6 2}
{opt by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Longitudinal/panel data > Setup and utilities >}
     {bf:Describe pattern of xt data}


{marker description}{...}
{title:Description}

{pstd}
{cmd:xtdescribe} describes the participation pattern of cross-sectional
time-series (xt) data.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection XT xtdescribeQuickstart:Quick start}

        {mansection XT xtdescribeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt patterns(#)} specifies the maximum number of
participation patterns to be reported; {cmd:patterns(9)} is the default.
Specifying {cmd:patterns(50)} would list up to 50 patterns.  Specifying
{cmd:patterns(1000)} is taken to mean {cmd:patterns(}infinity{cmd:)}: all the
patterns will be listed.

{phang}
{opt width(#)} specifies the desired width of the participation patterns to be
displayed; {cmd:width(100)} is the default.  If the number of times is greater
than {cmd:width()}, then each column in the participation pattern represents
multiple periods as indicated in a footnote at the bottom of the table.  The
actual width may differ slightly from the requested width depending on the
span of the time variable and the number of periods.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlswork}{p_end}

{pstd}Describe participation pattern of data{p_end}
{phang2}{cmd:. xtdescribe}{p_end}
