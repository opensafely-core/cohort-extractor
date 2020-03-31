{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] matpowersym()" "mansection M-5 matpowersym()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] eigensystem()" "help mf_eigensystem"}{...}
{vieweralsosee "[M-5] matexpsym()" "help mf_matexpsym"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_matpowersym##syntax"}{...}
{viewerjumpto "Description" "mf_matpowersym##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_matpowersym##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_matpowersym##remarks"}{...}
{viewerjumpto "Conformability" "mf_matpowersym##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_matpowersym##diagnostics"}{...}
{viewerjumpto "Source code" "mf_matpowersym##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] matpowersym()} {hline 2}}Powers of a symmetric matrix
{p_end}
{p2col:}({mansection M-5 matpowersym():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 35 2}
{it:numeric matrix}
{cmd:matpowersym(}{it:numeric matrix A}{cmd:,}
{it:real scalar p}{cmd:)}

{p 8 35 2}
{it:void}{bind:         }
{cmd:_matpowersym(}{it:numeric matrix A}{cmd:,}
{it:real scalar p}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:matpowersym(}{it:A}{cmd:,} {it:p}{cmd:)} 
returns {it:A^p} for symmetric matrix or Hermitian matrix {it:A}.
The matrix returned is real if {it:A} is real and complex is {it:A} is 
complex.  

{p 4 4 2}
{cmd:_matpowersym(}{it:A}{cmd:,} {it:p}{cmd:)} 
does the same thing, but instead of returning the result, it stores the 
result in {it:A}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 matpowersym()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Do not confuse 
{cmd:matpowersym(}{it:A}{cmd:,} {it:p}{cmd:)} 
and 
{it:A}{cmd::^}{it:p}.  If {it:p}==2, the first returns {it:A}{cmd:*}{it:A} and
the second returns {it:A} with each element squared.  

{p 4 4 2}
Powers can be positive, negative, integer, or noninteger.  Thus
{cmd:matpowersym(}{it:A}{cmd:, .5)} is a way to find the square-root matrix
{it:R} such that {it:R}{cmd:*}{it:R}=={it:A}, and
{cmd:matpowersym(}{it:A}{cmd:, -1)} is a way to find the inverse.  
For inversion, you could obtain the result more quickly using other routines.

{p 4 4 2}
Powers are obtained by extracting the eigenvectors and eigenvalues of 
{it:A}, raising the eigenvalues to the specified power, and then rebuilding 
the matrix.  That is, first {it:X} and {it:L} are found such that 

			{it:A}{it:X} = {it:X}*diag({it:L}){right:(1)   }

{p 4 4 2}
For symmetric (Hermitian) matrix {it:A}, {it:X} is orthogonal, meaning 
{it:X}'{it:X} = {it:X}{it:X}' = {it:I}.  Thus

			{it:A} = {it:X}*diag({it:L})*{it:X}'{right:(2)   }

{p 4 4 2}
{it:A}^{it:p} is then defined 

			{it:A} = {it:X}*diag({it:L}:^{it:p})*{it:X}'{right:(3)   }

{p 4 4 2}
(1) is obtained via {cmd:symeigensystem()}; see 
{bf:{help mf_eigensystem:[M-5] eigensystem()}}.


{marker conformability}{...}
{title:Conformability}

    {cmd:matpowersym(}{it:A}{cmd:,} {it:p}{cmd:)}:
		{it:A}:  {it:n x n}
		{it:p}:  1 {it:x} 1
	   {it:result}:  {it:n x n}

    {cmd:_matpowersym(}{it:A}{cmd:,} {it:p}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
		{it:p}:  1 {it:x} 1
	{it:output:}
		{it:A}:  {it:n x n}

		
{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:matpowersym(}{it:A}{cmd:,} {it:p}{cmd:)}
and 
{cmd:_matpowersym(}{it:A}{cmd:,} {it:p}{cmd:)}
return missing results if {it:A} contains missing values.

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
That means that if {it:A} is real and {it:A}^{it:p} cannot be expressed 
as a real, a matrix of missing values is returned.  If you want the 
generalized solution, code {cmd:matpowersym(C(}{it:A}{cmd:),} {it:p}{cmd:)}.
This is the same rule as with scalars:  (-1){cmd:^}.5 is missing, but 
{cmd:C(}-1{cmd:)^}.5 is 1i.

{p 8 12 2}
3.  
These functions are guaranteed to return a matrix that is numerically
symmetric, Hermitian, or
{help m6_glossary##symmetriconly:symmetriconly} if theory states that the
matrix should be symmetric, Hermitian, or symmetriconly.

{p 12 12 2}
Concerning theory, the returned result is not necessarily symmetric
(Hermitian).  The eigenvalues {it:L} of a symmetric (Hermitian) matrix are 
real.  If {it:L}{cmd::^}{it:p} are real, then the returned matrix will be 
symmetric (Hermitian), but otherwise, it will not.  Think of a negative
eigenvalue and {it:p}=.5:  this results in a complex eigenvalue for
{it:A}^{it:p}.  Then if the original matrix was real (the
eigenvectors were real), the resulting matrix will be symmetriconly.  If
the original matrix was complex (the eigenvectors were complex), the
resulting matrix will have no special structure.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view matpowersym.mata, adopath asis:matpowersym.mata},
{view _matpowersym.mata, adopath asis:_matpowersym.mata},
{view _symmatfunc_work.mata, adopath asis:_symmatfunc_work.mata}
{p_end}
