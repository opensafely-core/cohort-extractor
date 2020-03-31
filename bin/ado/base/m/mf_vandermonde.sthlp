{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] Vandermonde()" "mansection M-5 Vandermonde()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Standard" "help m4_standard"}{...}
{viewerjumpto "Syntax" "mf_vandermonde##syntax"}{...}
{viewerjumpto "Description" "mf_vandermonde##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_vandermonde##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_vandermonde##remarks"}{...}
{viewerjumpto "Conformability" "mf_vandermonde##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_vandermonde##diagnostics"}{...}
{viewerjumpto "Source code" "mf_vandermonde##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] Vandermonde()} {hline 2}}Vandermonde matrices
{p_end}
{p2col:}({mansection M-5 Vandermonde():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix} 
{cmd:Vandermonde(}{it:numeric colvector x}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:Vandermonde(}{it:x}{cmd:)} returns the Vandermonde matrix 
containing the geometric progression of {it:x} in each row

		{c TLC}{c -}                                  {c -}{c TRC}
		{c |} 1  {it:x}_1  {it:x}_1^2  {it:x}_1^3  ...  {it:x}_1^{it:n}-1 {c |}
		{c |} 1  {it:x}_2  {it:x}_2^2  {it:x}_2^3  ...  {it:x}_2^{it:n}-1 {c |}
		{c |} .   .    .      .             .    {c |}
		{c |} .   .    .      .             .    {c |}
		{c |} .   .    .      .             .    {c |}
		{c |} 1  {it:x}_{it:n}  {it:x}_{it:n}^2  {it:x}_{it:n}^3  ...  {it:x}_{it:n}^{it:n}-1 {c |}
		{c BLC}{c -}                                  {c -}{c BRC}

{p 4 4 2}
where {it:n} = {cmd:rows(}{it:x}{cmd:)}.
Some authors use the transpose of the above matrix.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 Vandermonde()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Vandermonde matrices are useful in polynomial interpolation.


{marker conformability}{...}
{title:Conformability}

    {cmd:Vandermonde(}{it:x}{cmd:)}:
		{it:x}:  {it:n x} 1
	   {it:result}:  {it:n x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view vandermonde.mata, adopath asis:vandermonde.mata}
{p_end}
