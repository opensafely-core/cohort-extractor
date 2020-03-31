{smcl}
{* *! version 1.1.4  15oct2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix note" "mansection SP spmatrixnote"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix save" "help spmatrix save"}{...}
{viewerjumpto "Syntax" "spmatrix_note##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_note##menu"}{...}
{viewerjumpto "Description" "spmatrix_note##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_note##linkspdf"}{...}
{viewerjumpto "Example" "spmatrix_note##example"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[SP] spmatrix note} {hline 2}}Put note on weighting matrix, or
display it{p_end}
{p2col:}({mansection SP spmatrixnote:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:note} {it:spmatname} {cmd::} {it:text}

{p 8 14 2}
{cmd:spmatrix} {cmd:note} {it:spmatname}

{phang}
{it:spmatname} is the name of an existing weighting matrix.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:note} {it:spmatname}{cmd::} {it:text} puts or
replaces the note on weighting matrix {it:spmatname} stored in
memory.

{pstd}
{cmd:spmatrix} {cmd:note} {it:spmatname} displays the note.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixnoteQuickstart:Quick start}

        {mansection SP spmatrixnoteRemarksandexamples:Remarks and examples}

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

{pstd}Create row-standardized contiguity weighting matrix with second-order
neighbors set to 0.5{p_end}
{phang2}{cmd:. spmatrix create contiguity M, normalize(row) second(0.5)}

{pstd}Add a note on the weighting matrix{p_end}
{phang2}{cmd:. spmatrix note M: row-standardized second-order contiguity matrix}

{pstd}Display the note for weighting matrix {cmd:M}{p_end}
{phang2}{cmd:. spmatrix note M}
{p_end}
