{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] matexpsym()" "mansection M-5 matexpsym()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] eigensystem()" "help mf_eigensystem"}{...}
{vieweralsosee "[M-5] matpowersym()" "help mf_matpowersym"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_matexpsym##syntax"}{...}
{viewerjumpto "Description" "mf_matexpsym##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_matexpsym##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_matexpsym##remarks"}{...}
{viewerjumpto "Conformability" "mf_matexpsym##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_matexpsym##diagnostics"}{...}
{viewerjumpto "Source code" "mf_matexpsym##source"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[M-5] matexpsym()} {hline 2}}Exponentiation and logarithms of symmetric matrices
{p_end}
{p2col:}({mansection M-5 matexpsym():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:matexpsym(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:matlogsym(}{it:numeric matrix A}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:_matexpsym(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_matlogsym(}{it:numeric matrix A}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:matexpsym(}{it:A}{cmd:)} returns the matrix exponential of the
symmetric (Hermitian) matrix {it:A}.

{p 4 4 2}
{cmd:matlogsym(}{it:A}{cmd:)} returns the matrix natural logarithm of the
symmetric (Hermitian) matrix {it:A}.

{p 4 4 2}
{cmd:_matexpsym(}{it:A}{cmd:)} and {cmd:_matlogsym(}{it:A}{cmd:)} do the same
thing as {cmd:matexpsym()} and {cmd:matlogsym()}, but instead of returning the
result, they store the result in {it:A}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 matexpsym()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Do not confuse 
{cmd:matexpsym(}{it:A}{cmd:)}
with
{helpb mf_exp:exp({it:A})}, 
nor 
{cmd:matlogsym(}{it:A}{cmd:)}
with
{helpb mf_log:log({it:A})}.  
{cmd:matexpsym(2*matlogsym(}{it:A}{cmd:))} produces the same result as 
{it:A}{cmd:*}{it:A}.
{cmd:exp()} and {cmd:log()} return elementwise results.

{p 4 4 2}
Exponentiated results and logarithms are obtained by extracting the eigenvalues
and eigenvectors of {it:A}, performing the operation on the eigenvalues, 
and then rebuilding the matrix.  That is, first {it:X} and {it:L} are found
such that

			{it:A}{it:X} = {it:X}*diag({it:L}){right:(1)   }

{p 4 4 2}
For symmetric (Hermitian) matrix {it:A}, {it:X} is orthogonal,
meaning {it:X}'{it:X} = {it:X}{it:X}' = {it:I}.  Thus

			{it:A} = {it:X}*diag({it:L})*{it:X}'{right:(2)   }

{p 4 4 2}
{cmd:matexpsym(}{it:A}{cmd:)} is then defined

			{it:A} = {it:X}*diag(exp({it:L}))*{it:X}'{right:(3)   }

{p 4 4 2}
and {cmd:matlogsym(}{it:A}{cmd:)} is defined 

			{it:A} = {it:X}*diag(log({it:L}))*{it:X}'{right:(4)   }

{p 4 4 2}
(1) is obtained via {cmd:symeigensystem()}; see 
{bf:{help mf_eigensystem:[M-5] eigensystem()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:matexpsym(}{it:A}{cmd:)}, {cmd:matlogsym(}{it:A}{cmd:)}:
		{it:A}:  {it:n x n}
	   {it:result}:  {it:n x n}

    {cmd:_matexpsym(}{it:A}{cmd:)}, {cmd:_matlogsym(}{it:A}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
	{it:output:}
		{it:A}:  {it:n x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:matexpsym(}{it:A}{cmd:)},
{cmd:matlogsym(}{it:A}{cmd:)},
{cmd:_matexpsym(}{it:A}{cmd:)}, 
and
{cmd:_matlogsym(}{it:A}{cmd:)}
return missing results if 
{it:A} contains missing values.

{p 4 4 2}
Also:

{p 8 12 2}
1.
These functions do not check that {it:A} is symmetric or Hermitian. If {it:A}
is a real matrix, only the lower triangle, including the diagonal, is used.
If {it:A} is a complex matrix, only the lower triangle and the real parts of
the diagonal elements are used.

{p 8 12 2}
2.  
These functions return a matrix of the same storage type as {it:A}.  

{p 12 12 2}
For {cmd:matlogsym(}{it:A}{cmd:)}, this means that if {it:A} is real
and the result cannot be expressed as a real, a matrix of missing values is
returned.  If you want the generalized solution, code
{cmd:matlogsym(C(}{it:A}{cmd:))}.  This is the same rule as with scalars:
{cmd:log(}-1{cmd:)} evaluates to missing, but {cmd:log(C(}-1{cmd:))} is
3.14159265i.

{p 8 12 2}
3.  
These functions are guaranteed to return a matrix that is numerically
symmetric, Hermitian, or
{help m6_glossary##symmetriconly:symmetriconly} if theory states that the
matrix should be symmetric, Hermitian, or symmetriconly.  See
{bf:{help mf_matpowersym:[M-5] matpowersym()}} for a discussion of this issue.  

{p 12 12 2}
For the functions here, real function {cmd:exp(}{it:x}{cmd:)} is defined for
all real values of x (ignoring overflow), and thus the matrix returned by
{cmd:matexpsym()} will be symmetric (Hermitian).

{p 12 12 2}
The same is not true for {cmd:matlogsym()}.  {cmd:log(}{it:x}{cmd:)} is not 
defined for {it:x}=0, so if any of the eigenvalues of {it:A} are 0 or 
very small, a matrix of missing values will result.  
Also, 
{cmd:log(}{it:x}{cmd:)} is complex for {it:x}<0, and thus if any of the
eigenvalues are negative, the resulting matrix will be (1) missing if {it:A}
is real stored as real, (2) symmetriconly if {it:A} contains reals stored as
complex, and (3) general if {it:A} is complex.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view matexpsym.mata, adopath asis:matexpsym.mata},
{view matlogsym.mata, adopath asis:matlogsym.mata},
{view _matexpsym.mata, adopath asis:_matexpsym.mata},
{view _matlogsym.mata, adopath asis:_matlogsym.mata},
{view _symmatfunc_work.mata, adopath asis:_symmatfunc_work.mata}
{p_end}
