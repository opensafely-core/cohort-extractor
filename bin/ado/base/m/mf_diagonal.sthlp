{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] diagonal()" "mansection M-5 diagonal()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] blockdiag()" "help mf_blockdiag"}{...}
{vieweralsosee "[M-5] diag()" "help mf_diag"}{...}
{vieweralsosee "[M-5] isdiagonal()" "help mf_isdiagonal"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_diagonal##syntax"}{...}
{viewerjumpto "Description" "mf_diagonal##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_diagonal##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_diagonal##remarks"}{...}
{viewerjumpto "Conformability" "mf_diagonal##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_diagonal##diagnostics"}{...}
{viewerjumpto "Source code" "mf_diagonal##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] diagonal()} {hline 2}}Extract diagonal into column vector
{p_end}
{p2col:}({mansection M-5 diagonal():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric colvector}
{cmd:diagonal(}{it:numeric matrix A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:diagonal(}{it:A}{cmd:)} 
extracts the diagonal of {it:A} and returns it in a column vector.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 diagonal()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:diagonal()}
may be used with nonsquare matrices.

{p 4 4 2}
Do not confuse {cmd:diagonal()} with its functional inverse, 
{cmd:diag()}; see 
{bf:{help mf_diag:[M-5] diag()}}.
{cmd:diagonal()} extracts the diagonal of a matrix into a vector;
{cmd:diag()} creates a diagonal matrix from a vector.


{marker conformability}{...}
{title:Conformability}

    {cmd:diagonal(}{it:A}{cmd:)}:
		{it:A}:  {it:r x c}
	   {it:result}:  min({it:r},{it:c}) {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
Function is built in.
{p_end}
