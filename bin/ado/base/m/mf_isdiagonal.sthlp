{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] isdiagonal()" "mansection M-5 isdiagonal()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] diag()" "help mf_diag"}{...}
{vieweralsosee "[M-5] diagonal()" "help mf_diagonal"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_isdiagonal##syntax"}{...}
{viewerjumpto "Description" "mf_isdiagonal##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_isdiagonal##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_isdiagonal##remarks"}{...}
{viewerjumpto "Conformability" "mf_isdiagonal##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_isdiagonal##diagnostics"}{...}
{viewerjumpto "Source code" "mf_isdiagonal##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] isdiagonal()} {hline 2}}Whether matrix is diagonal
{p_end}
{p2col:}({mansection M-5 isdiagonal():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:isdiagonal(}{it:numeric matrix A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:isdiagonal(}{it:A}{cmd:)} returns 1 if {it:A} has only zeros
off the principal diagonal and returns 0 otherwise.
{cmd:isdiagonal()} may be used with
either real or complex matrices.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 isdiagonal()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
See {bf:{help mf_diag:[M-5] diag()}}
for making diagonal matrices out of vectors or out of nondiagonal matrices; 
see {bf:{help mf_diagonal:[M-5] diagonal()}}
for extracting the diagonal of a matrix into a vector.


{marker conformability}{...}
{title:Conformability}

    {cmd:isdiagonal(}{it:A}{cmd:)}:
		{it:A}:  {it:r x c}
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:isdiagonal(}{it:A}{cmd:)} returns 1 if {it:A} is void.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view isdiagonal.mata, adopath asis:isdiagonal.mata}
{p_end}
