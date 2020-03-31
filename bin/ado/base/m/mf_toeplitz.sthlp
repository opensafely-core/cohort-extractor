{smcl}
{* *! version 1.2.5  15may2018}{...}
{vieweralsosee "[M-5] Toeplitz()" "mansection M-5 Toeplitz()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_toeplitz##syntax"}{...}
{viewerjumpto "Description" "mf_toeplitz##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_toeplitz##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_toeplitz##remarks"}{...}
{viewerjumpto "Conformability" "mf_toeplitz##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_toeplitz##diagnostics"}{...}
{viewerjumpto "Source code" "mf_toeplitz##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] Toeplitz()} {hline 2}}Toeplitz matrices
{p_end}
{p2col:}({mansection M-5 Toeplitz():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix} 
{cmd:Toeplitz(}{it:numeric colvector c1}{cmd:,}
{it:numeric rowvector r1}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:Toeplitz(}{it:c1}{cmd:,} {it:r1}{cmd:)}
returns the Toeplitz matrix defined by {it:c1} being its first 
column and {it:r1} being its first row.  A Toeplitz matrix {it:T} is
characterized by {it:T}[{it:i},{it:j}] = {it:T}[{it:i}-1,{it:j}-1], 
{it:i, j} > 1.
In a Toeplitz matrix, each diagonal is constant.

{p 4 4 2}
Vectors {it:c1} and {it:r1} specify the first column and first row of {it:T}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 Toeplitz()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{it:c1}[1] is used to fill {it:T}[1,1], and {it:r1}[1] is not used.

{p 4 4 2}
To obtain the symmetric (Hermitian) Toeplitz matrix, code
{cmd:Toeplitz(}{it:v}{cmd:,} {it:v}{cmd:')} 
(if {it:v} is a column vector), or
{cmd:Toeplitz(}{it:v}{cmd:',} {it:v}{cmd:)} if {it:v} is a row vector.


{marker conformability}{...}
{title:Conformability}

    {cmd:Toeplitz(}{it:c1}{cmd:,} {it:r1}{cmd:)}:
	       {it:c1}:  {it:r x} 1
	       {it:r1}:  1 {it:x c}
	   {it:result}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view toeplitz.mata, adopath asis:toeplitz.mata}
{p_end}
