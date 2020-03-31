{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] cholesky()" "mansection M-5 cholesky()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] lud()" "help mf_lud"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_cholesky##syntax"}{...}
{viewerjumpto "Description" "mf_cholesky##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_cholesky##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_cholesky##remarks"}{...}
{viewerjumpto "Conformability" "mf_cholesky##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_cholesky##diagnostics"}{...}
{viewerjumpto "Source code" "mf_cholesky##source"}{...}
{viewerjumpto "Reference" "mf_cholesky##reference"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] cholesky()} {hline 2}}Cholesky square-root decomposition
{p_end}
{p2col:}({mansection M-5 cholesky():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:cholesky(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_cholesky(}{it:numeric matrix A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:cholesky(}{it:A}{cmd:)} returns the Cholesky decomposition {it:G} of
symmetric
({help m6_glossary##hermitianmtx:Hermitian}),
positive-definite matrix {it:A}.  
{cmd:cholesky()} returns a lower-triangular matrix of missing values if
{it:A} is not positive definite.

{p 4 4 2}
{cmd:_cholesky(}{it:A}{cmd:)} does the same thing, except that it overwrites
{it:A} with the Cholesky result.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 cholesky()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The Cholesky decomposition {it:G} of a symmetric, positive-definite matrix
{it:A} is 

		{it:A} = {it:G}{it:G}{bf:'}

{p 4 4 2}
where {it:G} is lower triangular.
When {it:A} is complex, {it:A} must be Hermitian, and {it:G}{bf:'}, of course,
is the conjugate transpose of {it:G}.

{p 4 4 2}
Decomposition is performed via {bf:{help m1_lapack:[M-1] LAPACK}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:cholesky(}{it:A}{cmd:)}
		{it:A}:  {it:n x n} 
	   {it:result}:  {it:n x n} 

    {cmd:_cholesky(}{it:A}{cmd:)}
	{it:input:}
		{it:A}:  {it:n x n} 
	{it:output:}
		{it:A}:  {it:n x n} 


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:cholesky(}{cmd:)} returns a lower-triangular matrix of missing values
if {it:A} contains missing values or if {it:A} is not positive definite.

{p 4 4 2}
{cmd:_cholesky(}{it:A}{cmd:)} overwrites {it:A} with a lower-triangular
matrix of missing values if {it:A} contains missing values or if {it:A} is
not positive definite.

{p 4 4 2}
Both functions use the elements from the lower triangle of {it:A} without
checking whether {it:A} is symmetric or, in the complex case, Hermitian.  


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view cholesky.mata, adopath asis:cholesky.mata};
{cmd:_cholesky()} is built in.
{p_end}


{marker reference}{...}
{title:Reference}

{phang}
Chabert, J.-L., {c E'}. Barbin, J. Borowczyk, M. Guillemot, and A. Michel-Pajus.
1999.
{it:A History of Algorithms: From the Pebble to the Microchip.}
Trans. C. Weeks.  Berlin: Springer.
{p_end}
