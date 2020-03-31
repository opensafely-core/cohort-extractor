{smcl}
{* *! version 1.1.4  15oct2018}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix normalize" "mansection SP spmatrixnormalize"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix import" "help spmatrix import"}{...}
{viewerjumpto "Syntax" "spmatrix_normalize##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_normalize##menu"}{...}
{viewerjumpto "Description" "spmatrix_normalize##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_normalize##linkspdf"}{...}
{viewerjumpto "Option" "spmatrix_normalize##option"}{...}
{viewerjumpto "Examples" "spmatrix_normalize##examples"}{...}
{p2colset 1 28 30 2}{...}
{p2col:{bf:[SP] spmatrix normalize} {hline 2}}Normalize weighting
matrix{p_end}
{p2col:}({mansection SP spmatrixnormalize:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:normalize}
{it:spmatname}
[{cmd:,} {opt norm:alize(normalize)}]

{phang}
{it:spmatname} is the name of an existing spatial weighting matrix
stored in memory.

{marker spmatrix_normalize_options}{...}
{synoptset 20}{...}
{synopthdr:normalize}
{synoptline}
{synopt :{opt spec:tral}}spectral; the default{p_end}
{synopt :{opt minmax}}min--max{p_end}
{synopt :{opt row}}row{p_end}
{synopt :{opt none}}do not normalize; leave matrix as is{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:normalize} normalizes a spatial weighting
matrix.  It is mostly used after {helpb spmatrix import}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixnormalizeQuickstart:Quick start}

        {mansection SP spmatrixnormalizeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

INCLUDE help sp_normalize_des


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge_shp.dta .}
{p_end}
{phang2}{cmd:. use texas_merge}

{pstd}Create spectral-normalized contiguity weighting matrices{p_end}
{phang2}{cmd:. spmatrix create contiguity W}{p_end}
{phang2}{cmd:. spmatrix create contiguity M}{p_end}
{phang2}{cmd:. spmatrix create contiguity R}

{pstd}Normalize spatial weighting matrix using the spectral normalization{p_end}
{phang2}{cmd:. spmatrix normalize W}

{pstd}Normalize spatial weighting matrix using the min-max normalization{p_end}
{phang2}{cmd:. spmatrix normalize M, normalize(minmax)}

{pstd}Normalize spatial weighting matrix using the row normalization{p_end}
{phang2}{cmd:. spmatrix normalize R, normalize(row)}
{p_end}
