{smcl}
{* *! version 1.1.5  30nov2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spgenerate" "mansection SP spgenerate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix create" "help spmatrix create"}{...}
{vieweralsosee "[SP] spregress" "help spregress"}{...}
{viewerjumpto "Syntax" "spgenerate##syntax"}{...}
{viewerjumpto "Menu" "spgenerate##menu"}{...}
{viewerjumpto "Description" "spgenerate##description"}{...}
{viewerjumpto "Links to PDF documentation" "spgenerate##linkspdf"}{...}
{viewerjumpto "Example" "spgenerate##example"}{...}
{p2colset 1 20 21 2}{...}
{p2col:{bf:[SP] spgenerate} {hline 2}}Generate variables containing
spatial lags{p_end}
{p2col:}({mansection SP spgenerate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax} 

{p 8 14 2}
{cmd:spgenerate} {dtype} {newvar} {cmd:=}
{it:spmatname}{cmd:*}{varname} {ifin}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spgenerate} creates new variables containing {bf:W}{bf:x}.
These are the same spatial lag variables that you include in models that
you fit with the Sp estimation commands.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spgenerateQuickstart:Quick start}

        {mansection SP spgenerateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge_shp.dta .}
{p_end}
{phang2}{cmd:. use texas_merge}

{pstd}Create a contiguity weighting matrix with default spectral normalization{p_end}
{phang2}{cmd:. spmatrix create contiguity W}

{pstd}Create a variable of {cmd:W*college}{p_end}
{phang2}{cmd:. spgenerate Wcollege = W*college}

{pstd}View the summary statistics of {cmd:college} and {cmd:Wcollege}{p_end}
{phang2}{cmd:. summarize unemployment college Wcollege}
{p_end}
