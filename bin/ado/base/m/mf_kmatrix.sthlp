{smcl}
{* *! version 1.1.8  15may2018}{...}
{vieweralsosee "[M-5] Kmatrix()" "mansection M-5 Kmatrix()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] Dmatrix()" "help mf_dmatrix"}{...}
{vieweralsosee "[M-5] Lmatrix()" "help mf_lmatrix"}{...}
{vieweralsosee "[M-5] vec()" "help mf_vec"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_kmatrix##syntax"}{...}
{viewerjumpto "Description" "mf_kmatrix##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_kmatrix##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_kmatrix##remarks"}{...}
{viewerjumpto "Conformability" "mf_kmatrix##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_kmatrix##diagnostics"}{...}
{viewerjumpto "Source code" "mf_kmatrix##source"}{...}
{viewerjumpto "Reference" "mf_kmatrix##reference"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] Kmatrix()} {hline 2}}Commutation matrix
{p_end}
{p2col:}({mansection M-5 Kmatrix():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}
{cmd:Kmatrix(}{it:real scalar m}{cmd:,} {it:real scalar n}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:Kmatrix(}{it:m}{cmd:,} {it:n}{cmd:)} 
returns the {it:mn} {it:x} {it:mn} commutation matrix {cmd:K}
for which {cmd:K}*{cmd:vec(}{it:X}{cmd:)} {cmd:=} {cmd:vec(}{it:X}{cmd:')},
where {it:X} is an {it:m x n} matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 Kmatrix()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Commutation matrices are frequently used in computing derivatives of
functions of matrices.  Section 9.2 of 
{help mf_kmatrix##L1996:L{c u:}tkepohl (1996)} lists many
useful properties of commutation matrices.


{marker conformability}{...}
{title:Conformability}

    {cmd:Kmatrix(}{it:m}{cmd:,} {it:n}{cmd:)}:
		{it:m}:   1 {it:x} 1
		{it:n}:   1 {it:x} 1
	   {it:result}:  {it:mn} {it:x mn}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:Kmatrix(}{it:m}{cmd:,} {it:n}{cmd:)} aborts with error if either 
{it:m} or {it:n} is less than 0 or is missing.  {it:m} and {it:n} are
interpreted as {cmd:trunc(}{it:m}{cmd:)} and {cmd:trunc(}{it:n}{cmd:)}.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view kmatrix.mata, adopath asis:kmatrix.mata}
{p_end}


{marker reference}{...}
{title:Reference}

{marker L1996}{...}
{p 4 4 2}
L{c u:}tkepohl, H. 1996.  {it:Handbook of Matrices}. New York: Wiley.
{p_end}
