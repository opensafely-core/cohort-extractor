{smcl}
{* *! version 1.1.4  15oct2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix export" "mansection SP spmatrixexport"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix import" "help spmatrix import"}{...}
{viewerjumpto "Syntax" "spmatrix_export##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_export##menu"}{...}
{viewerjumpto "Description" "spmatrix_export##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_export##linkspdf"}{...}
{viewerjumpto "Option" "spmatrix_export##option"}{...}
{viewerjumpto "Example" "spmatrix_export##example"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[SP] spmatrix export} {hline 2}}Export weighting matrix to text
file{p_end}
{p2col:}({mansection SP spmatrixexport:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix export}
{it:spmatname} {cmd:using} {help filename:{it:filename}}
[{cmd:,} {cmd:replace}]

{phang}
{it:spmatname} is the name of a weighting matrix stored in memory.

{phang}
{it:filename} is the name of a file with or without the
default {cmd:.txt} suffix.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:export} saves one weighting matrix in a text file
that you can use for sending to other researchers.

{pstd}
Stata users can import text files created by {cmd:spmatrix} {cmd:export};
see {manhelp spmatrix_import SP:spmatrix import}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixexportQuickstart:Quick start}

        {mansection SP spmatrixexportRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:replace} specifies that {it:filename} may be overwritten if it
already exists.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge_shp.dta .}
{p_end}
{phang2}{cmd:. use texas_merge}

{pstd}Create spectral-normalized contiguity weighting matrix{p_end}
{phang2}{cmd:. spmatrix create contiguity W}

{pstd}Export the spatial weighting matrix to a text file{p_end}
{phang2}{cmd:. spmatrix export W using contig.txt}
{p_end}
