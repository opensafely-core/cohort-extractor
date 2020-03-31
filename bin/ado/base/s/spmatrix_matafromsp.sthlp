{smcl}
{* *! version 1.1.5  23jun2019}{...}
{viewerdialog Sp "dialog sp"}{...}
{vieweralsosee "[SP] spmatrix matafromsp" "mansection SP spmatrixmatafromsp"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "[SP] spmatrix" "help spmatrix"}{...}
{vieweralsosee "[SP] spmatrix spfrommata" "help spmatrix spfrommata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M] mata" "mansection M-0 Mata"}{...}
{viewerjumpto "Syntax" "spmatrix_matafromsp##syntax"}{...}
{viewerjumpto "Menu" "spmatrix_matafromsp##menu"}{...}
{viewerjumpto "Description" "spmatrix_matafromsp##description"}{...}
{viewerjumpto "Links to PDF documentation" "spmatrix_matafromsp##linkspdf"}{...}
{viewerjumpto "Example" "spmatrix_matafromsp##example"}{...}
{p2colset 1 29 27 2}{...}
{p2col:{bf:[SP] spmatrix matafromsp} {hline 2}}Copy weighting matrix to
Mata{p_end}
{p2col:}({mansection SP spmatrixmatafromsp:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:spmatrix} {cmd:matafromsp}
{it:matamatrix} {it:matavec} {cmd:=} {it:spmatname}


INCLUDE help menu_spatial


{marker description}{...}
{title:Description}

{pstd}
{cmd:spmatrix matafromsp} copies weighting matrix {it:spmatname} from Sp to
Mata.  Weighting matrix {it:spmatname} remains unchanged.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP spmatrixmatafromspQuickstart:Quick start}

        {mansection SP spmatrixmatafromspRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


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
