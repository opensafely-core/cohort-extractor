{smcl}
{* *! version 1.1.4  15oct2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix save" "mansection SP spmatrixsave"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix export" "help spmatrix export"}{...}
{vieweralsosee "[SP] spmatrix use" "help spmatrix use"}{...}
{viewerjumpto "Syntax" "spmatrix_save##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_save##menu"}{...}
{viewerjumpto "Description" "spmatrix_save##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_save##linkspdf"}{...}
{viewerjumpto "Option" "spmatrix_save##option"}{...}
{viewerjumpto "Example" "spmatrix_save##example"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[SP] spmatrix save} {hline 2}}Save spatial weighting matrix to
file{p_end}
{p2col:}({mansection SP spmatrixsave:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:save}
{it:spmatname}  {cmd:using} {help filename:{it:filename}}
[{cmd:,} {cmd:replace}]

{phang}
{it:spmatname} is the name of an existing weighting matrix.

{phang}
{it:filename} is the name of a file with or without the {cmd:.stswm}
suffix.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:save} saves the specified spatial weighting matrix to
disk.  You can later load the matrix using {helpb spmatrix use}.

{pstd}
{it:spmatname} is saved to disk but is not dropped from memory. 
If you wish to eliminate the matrix from memory, see 
{manhelp spmatrix_drop SP:spmatrix drop}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixsaveQuickstart:Quick start}

        {mansection SP spmatrixsaveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:replace} specifies that {it:filename} be overwritten if
it already exists.


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

{pstd}Save weighting matrix {cmd:M}{p_end}
{phang2}{cmd:. spmatrix save M using mwm}
{p_end}
