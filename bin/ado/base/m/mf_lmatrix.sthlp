{smcl}
{* *! version 1.1.9  25sep2018}{...}
{vieweralsosee "[M-5] Lmatrix()" "mansection M-5 Lmatrix()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] Dmatrix()" "help mf_dmatrix"}{...}
{vieweralsosee "[M-5] Kmatrix()" "help mf_kmatrix"}{...}
{vieweralsosee "[M-5] vec()" "help mf_vec"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_lmatrix##syntax"}{...}
{viewerjumpto "Description" "mf_lmatrix##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_lmatrix##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_lmatrix##remarks"}{...}
{viewerjumpto "Conformability" "mf_lmatrix##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_lmatrix##diagnostics"}{...}
{viewerjumpto "Source code" "mf_lmatrix##source"}{...}
{viewerjumpto "Reference" "mf_lmatrix##reference"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] Lmatrix()} {hline 2}}Elimination matrix
{p_end}
{p2col:}({mansection M-5 Lmatrix():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:Lmatrix(}{it:real scalar n}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:Lmatrix(}{it:n}{cmd:)} returns the 
{it:n}({it:n}+1)/2 {it:x} {it:n}^2 elimination matrix {cmd:L}
for which {cmd:L}*{cmd:vec(}{it:X}{cmd:)} {cmd:=} {cmd:vech(}{it:X}{cmd:)},
where {it:X} is an {it:n x n} symmetric matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 Lmatrix()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Elimination matrices are frequently used in computing derivatives of
functions of symmetric matrices.  Section 9.6 of
{help mf_lmatrix##L1996:L{c u:}tkepohl (1996)} lists many
useful properties of elimination matrices.


{marker conformability}{...}
{title:Conformability}

    {cmd:Lmatrix(}{it:n}{cmd:)}:
		{it:n}:         1 {it:x} 1
	   {it:result}:  {it:n}({it:n}+1)/2 {it:x n}^2


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:Lmatrix(}{it:n}{cmd:)} aborts with error if 
{it:n} is less than 0 or is missing.  {it:n} is
interpreted as {cmd:trunc(}{it:n}{cmd:)}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view lmatrix.mata, adopath asis:lmatrix.mata}


{marker reference}{...}
{title:Reference}

{marker L1996}{...}
{p 4 4 2}
L{c u:}tkepohl, H. 1996.  {it:Handbook of Matrices}. New York: Wiley.
{p_end}
