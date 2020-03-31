{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] Hilbert()" "mansection M-5 Hilbert()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_hilbert##syntax"}{...}
{viewerjumpto "Description" "mf_hilbert##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_hilbert##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_hilbert##remarks"}{...}
{viewerjumpto "Conformability" "mf_hilbert##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_hilbert##diagnostics"}{...}
{viewerjumpto "Source code" "mf_hilbert##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] Hilbert()} {hline 2}}Hilbert matrices
{p_end}
{p2col:}({mansection M-5 Hilbert():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix} 
{cmd:Hilbert(}{it:real scalar n}{cmd:)}

{p 8 12 2}
{it:real matrix} 
{cmd:invHilbert(}{it:real scalar n}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:Hilbert(}{it:n}{cmd:)}
returns the {it:n x n} Hilbert matrix, defined as 
matrix {it:H} with elements {it:H}[{it:i},{it:j}]=1/({it:i}+{it:j}-1).

{p 4 4 2}
{cmd:invHilbert(}{it:n}{cmd:)}
returns the inverse of the {it:n x n} Hilbert matrix, defined as 
the matrix with elements
(-1)^({it:i}+{it:j})*({it:i}+{it:j}-1)*comb({it:n}+{it:i}-1,
{it:n}-{it:j})*comb({it:n}+{it:j}-1,
{it:n}-{it:i})*comb({it:i}+{it:j}-2, {it:i}-1)^2. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 Hilbert()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:Hilbert(}{it:n}{cmd:)} and 
{cmd:invHilbert(}{it:n}{cmd:)}
are used in testing Mata.  
Hilbert matrices are notoriously ill conditioned.  
The determinants of the first five Hilbert matrices are
1, 1/12, 1/2,160, 1/6,048,000, and 1/266,716,800,000.


{marker conformability}{...}
{title:Conformability}

    {cmd:Hilbert(}{it:n}{cmd:)}, {cmd:invHilbert(}{it:n}{cmd:)}:
		{it:n}:  1 {it:x} 1
	   {it:result}:  {it:n} {it:x} {it:n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
If {it:n} is not an integer, trunc({it:n}) is used.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view hilbert.mata, adopath asis:hilbert.mata},
{view invhilbert.mata, adopath asis:invhilbert.mata}
{p_end}
