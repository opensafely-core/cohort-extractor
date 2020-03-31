{smcl}
{* *! version 1.1.6  05feb2020}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix spfrommata" "mansection SP spmatrixspfrommata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix create" "help spmatrix create"}{...}
{vieweralsosee "[SP] spmatrix matafromsp" "help spmatrix matafromsp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M] mata" "mansection M-0 Mata"}{...}
{viewerjumpto "Syntax" "spmatrix_spfrommata##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_spfrommata##menu"}{...}
{viewerjumpto "Description" "spmatrix_spfrommata##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_spfrommata##linkspdf"}{...}
{viewerjumpto "Options" "spmatrix_spfrommata##options"}{...}
{viewerjumpto "Example" "spmatrix_spfrommata##example"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[SP] spmatrix spfrommata} {hline 2}}Copy Mata matrix to Sp{p_end}
{p2col:}({mansection SP spmatrixspfrommata:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:spfrommata}
{it:spmatname} {cmd:=} {it:matamatrix} {it:matavec}
[{cmd:,} {it:options}]

{marker spmatrix_spfrommata_options}{...}
{synoptset 20}{...}
{synopthdr}
{synoptline}
{synopt :{opth norm:alize(spmatrix_spfrommata##normalize:normalize)}}type of
normalization; default is {cmd:normalize(spectral)}{p_end}
{synopt :{opt replace}}replace existing weighting matrix{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix} {cmd:spfrommata}
copies a weighting matrix and an ID vector from Mata to an Sp spatial
weighting matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixspfrommataQuickstart:Quick start}

        {mansection SP spmatrixspfrommataRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

INCLUDE help sp_normalize_des

{phang}
{cmd:replace} specifies that matrix {it:spmatname} be overwritten if it
already exists.
{p_end}


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide1990.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide1990_shp.dta .}
{p_end}
{phang2}{cmd:. use homicide1990}
{p_end}
{phang2}{cmd:. spset}
{p_end}
{phang2}{cmd:. spmatrix create contiguity C}

{pstd}Fetch {cmd:C} from Sp and change the values greater than or equal to
0.8 to 0.5{p_end}
{phang2}{cmd:. spmatrix matafromsp W id = C}{p_end}
        {cmd}. mata:
          for (i=1; i<=rows(W); i++) {
                  for (j=1; j<=cols(W); j++) {
                          if (W[i,j] >= 0.8) W[i,j] = 0.5
                  }
          }
          end{txt}

{pstd}Store {cmd:W} back into {cmd:C}{p_end}
{phang2}{cmd:. spmatrix spfrommata C = W id, replace}{p_end}
