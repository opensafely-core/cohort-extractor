{smcl}
{* *! version 1.1.7  19oct2017}{...}
{viewerdialog compare "dialog compare"}{...}
{vieweralsosee "[D] compare" "mansection D compare"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] cf" "help cf"}{...}
{vieweralsosee "[D] codebook" "help codebook"}{...}
{vieweralsosee "[D] inspect" "help inspect"}{...}
{viewerjumpto "Syntax" "compare##syntax"}{...}
{viewerjumpto "Menu" "compare##menu"}{...}
{viewerjumpto "Description" "compare##description"}{...}
{viewerjumpto "Links to PDF documentation" "compare##linkspdf"}{...}
{viewerjumpto "Example" "compare##example"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] compare} {hline 2}}Compare two variables{p_end}
{p2col:}({mansection D compare:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:compare}
{it:{help varname}1}
{it:{help varname}2}
{ifin}

{pstd}
{opt by} is allowed; see {manhelp by D}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Data utilities > Compare two variables}


{marker description}{...}
{title:Description}

{pstd}
{opt compare} reports the differences and similarities
between {it:{help varname}1} and {it:varname2}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D compareQuickstart:Quick start}

        {mansection D compareRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse fullauto}{p_end}

{pstd}Report differences between {cmd:rep77} and {cmd:rep78}{p_end}
{phang2}{cmd:. compare rep77 rep78}{p_end}
