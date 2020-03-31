{smcl}
{* *! version 1.0.4  11may2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix import" "mansection SP spmatriximport"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix export" "help spmatrix export"}{...}
{vieweralsosee "[SP] spmatrix normalize" "help spmatrix normalize"}{...}
{viewerjumpto "Syntax" "spmatrix_import##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_import##menu"}{...}
{viewerjumpto "Description" "spmatrix_import##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_import##linkspdf"}{...}
{viewerjumpto "Option" "spmatrix_import##option"}{...}
{viewerjumpto "Example" "spmatrix_import##example"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[SP] spmatrix import} {hline 2}}Import weighting matrix from
text file{p_end}
{p2col:}({mansection SP spmatriximport:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:import}
{it:spmatname} {cmd:using}  {help filename:{it:filename}}
[{cmd:,} {cmd:replace}]

{phang}
{it:spmatname} will be the name of the weighting matrix that is created.

{phang}
{it:filename} is the name of a file with or without the default
{cmd:.txt} suffix.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:import} reads files created by
{helpb spmatrix export}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatriximportQuickstart:Quick start}

        {mansection SP spmatriximportRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt replace} specifies that weighting matrix {it:spmatname} in memory 
be overwritten if it already exists.


{marker example}{...}
{title:Example}

{pstd}Import the spatial weighting matrix from a text file{p_end}
{phang2}{cmd:. spmatrix import W using contig.txt}
{p_end}
