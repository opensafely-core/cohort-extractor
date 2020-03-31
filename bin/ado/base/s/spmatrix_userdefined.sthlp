{smcl}
{* *! version 1.1.5  23jun2019}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix userdefined" "mansection SP spmatrixuserdefined"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix spfrommata" "help spmatrix spfrommata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M] mata" "mansection M-0 Mata"}{...}
{viewerjumpto "Syntax" "spmatrix_userdefined##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_userdefined##menu"}{...}
{viewerjumpto "Description" "spmatrix_userdefined##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_userdefined##linkspdf"}{...}
{viewerjumpto "Options" "spmatrix_userdefined##options"}{...}
{viewerjumpto "Example" "spmatrix_userdefined##example"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[SP] spmatrix userdefined} {hline 2}}Create custom weighting
matrix{p_end}
{p2col:}({mansection SP spmatrixuserdefined:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:userdefined}
{it:Wmatname} {cmd:=} {it:fcnname}{cmd:(}{varlist}{cmd:)}
{ifin}
[{cmd:,} {it:options}]

{phang}
{it:Wmatname} is a weighting matrix name, such as {cmd:W}.

{phang}
{it:fcnname} is the name of a Mata function you have
             written, such as {cmd:SinvD} or {cmd:Awind}.

{phang2}
1.  {it:fcnname} must start with the letter {cmd:S} or {cmd:A}, which
indicates whether the function produces a symmetric or an asymmetric result.

{phang2}
2.  {it:fcnname} receives two row-vector arguments and
                     returns a scalar result.  For example,

                function SinvD(v1, v2)
                {
                     return(1/sqrt((v1-v2)*(v1-v2)'))
                }

{pmore2}
Function {cmd:SinvD()} starts with {cmd:S} because
for all {it:x} and {it:y}, {cmd:SinvD(}{it:x}{cmd:,} {it:y}{cmd:)} =
{cmd:SinvD(}{it:y}{cmd:,} {it:x}{cmd:)}.

{marker spmatrix_export_options}{...}
{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opth norm:alize(spmatrix_userdefined##normalize:normalize)}}type of
normalization; default is {cmd:normalize(spectral)}{p_end}
{synopt :{opt replace}}replace existing weighting matrix{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:userdefined} is one way of creating custom spatial
weighting matrices.  The function you write need not be based on
coordinate locations.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixuserdefinedQuickstart:Quick start}

        {mansection SP spmatrixuserdefinedRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

INCLUDE help sp_normalize_des

{phang}
{opt replace} specifies to overwrite matrix {it:spmatname} if it already
exists. 


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/texas_merge_shp.dta .}
{p_end}
{phang2}{cmd:. use texas_merge}

{pstd}Write a Mata function{p_end}
        {cmd}. mata:
          function SinvD(vi, vj)
	  {
                  return (1/sqrt( (vi-vj)*(vi-vj)' ) )
          }
          end{txt}

{pstd}Create a custom weighting matrix{p_end}
{phang2}{cmd:. spmatrix userdefined W = SinvD(_CX _CY)} 
{p_end}
