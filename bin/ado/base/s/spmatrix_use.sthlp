{smcl}
{* *! version 1.1.4  15oct2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix use" "mansection SP spmatrixuse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix import" "help spmatrix import"}{...}
{vieweralsosee "[SP] spmatrix save" "help spmatrix save"}{...}
{viewerjumpto "Syntax" "spmatrix_use##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_use##menu"}{...}
{viewerjumpto "Description" "spmatrix_use##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_use##linkspdf"}{...}
{viewerjumpto "Option" "spmatrix_use##option"}{...}
{viewerjumpto "Example" "spmatrix_use##example"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[SP] spmatrix use} {hline 2}}Load spatial weighting matrix from
file{p_end}
{p2col:}({mansection SP spmatrixuse:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:use}
{it:spmatname} {cmd:using} {help filename:{it:filename}}
[{cmd:,} {cmd:replace}]

{phang}
{it:spmatname} is a weighting matrix name.

{phang}
{it:filename} is the name of a file with or without
the {cmd:.stswm} suffix.


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:use} loads the spatial weighting matrix previously
saved using {helpb spmatrix save}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixuseQuickstart:Quick start}

        {mansection SP spmatrixuseRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt replace} specifies that weighting matrix {it:spmatname}
be overwritten if it already exists.


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

{pstd}Load weighting matrix {cmd:M} stored in {cmd:mwm.stswm}{p_end}
{phang2}{cmd:. spmatrix use M using mwm.stswm, replace}
{p_end}
