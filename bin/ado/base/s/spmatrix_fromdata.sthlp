{smcl}
{* *! version 1.0.5  23jun2019}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix fromdata" "mansection SP spmatrixfromdata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix spfrommata" "help spmatrix spfrommata"}{...}
{vieweralsosee "[SP] spmatrix userdefined" "help spmatrix userdefined"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M] mata" "mansection M-0 Mata"}{...}
{viewerjumpto "Syntax" "spmatrix_fromdata##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_fromdata##menu"}{...}
{viewerjumpto "Description" "spmatrix_fromdata##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_fromdata##linkspdf"}{...}
{viewerjumpto "Options" "spmatrix_fromdata##options"}{...}
{viewerjumpto "Example" "spmatrix_fromdata##example"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[SP] spmatrix fromdata} {hline 2}}Create custom weighting
matrix from data{p_end}
{p2col:}({mansection SP spmatrixfromdata:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:fromdata}
{it:spmatname} {cmd:=} {varlist}
[{cmd:,} {it:options}]

{phang}
{it:spmatname} is the name of the spatial weighting matrix to be
created.

{marker spmatrix_fromdata_options}{...}
{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opt idist:ance}}store reciprocal of elements{p_end}
{synopt :{opth norm:alize(spmatrix_fromdata##normalize:normalize)}}type of
normalization; default is {cmd:normalized(spectral)}{p_end}
{synopt :{opt replace}}replace existing weighting matrix{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:fromdata} creates custom spatial weighting matrices
from Sp data.

{pstd}
There are two other ways to create custom weighting matrices:
{helpb spmatrix userdefined} and
{helpb spmatrix spfrommata}.  Those
ways may require less work, but they require knowledge of Mata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixfromdataQuickstart:Quick start}

        {mansection SP spmatrixfromdataRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt idistance} converts distance to inverse distance by storing the
reciprocal of the elements.

INCLUDE help sp_normalize_des

{phang}
{opt replace} specifies that matrix {it:spmatname} be overwritten if it
already exists.


{marker example}{...}
{title:Example}

{phang2}{cmd:. spmatrix fromdata Wnew = x1 -xn}
{p_end}
