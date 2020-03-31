{smcl}
{* *! version 1.1.4  15oct2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix copy" "mansection SP spmatrixcopy"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{viewerjumpto "Syntax" "spmatrix_copy##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_copy##menu"}{...}
{viewerjumpto "Description" "spmatrix_copy##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_copy##linkspdf"}{...}
{viewerjumpto "Example" "spmatrix_copy##example"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[SP] spmatrix copy} {hline 2}}Copy spatial weighting matrix
stored in memory{p_end}
{p2col:}({mansection SP spmatrixcopy:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:copy}
{it:spmatname1} {it:spmatname2}

{phang}
{it:spmatname1} is the name of an existing weighting matrix.

{phang}
{it:spmatname2} is a name of a weighting matrix that does not exist.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:copy} copies weighting matrices stored in memory to
new names, also stored in memory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixcopyQuickstart:Quick start}

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

{pstd}Create a contiguity weighting matrix with the default spectral normalization{p_end}
{phang2}{cmd:. spmatrix create contiguity W}

{pstd}Create a copy of the weighting matrix{p_end}
{phang2}{cmd:. spmatrix copy W Wcollege}
{p_end}
