{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] qrinv()" "mansection M-5 qrinv()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholinv()" "help mf_cholinv"}{...}
{vieweralsosee "[M-5] invsym()" "help mf_invsym"}{...}
{vieweralsosee "[M-5] luinv()" "help mf_luinv"}{...}
{vieweralsosee "[M-5] pinv()" "help mf_pinv"}{...}
{vieweralsosee "[M-5] qrsolve()" "help mf_qrsolve"}{...}
{vieweralsosee "[M-5] solve_tol()" "help mf_solve_tol"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-4] Solvers" "help m4_solvers"}{...}
{viewerjumpto "Syntax" "mf_qrinv##syntax"}{...}
{viewerjumpto "Description" "mf_qrinv##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_qrinv##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_qrinv##remarks"}{...}
{viewerjumpto "Conformability" "mf_qrinv##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_qrinv##diagnostics"}{...}
{viewerjumpto "Source code" "mf_qrinv##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] qrinv()} {hline 2}}Generalized inverse of matrix via QR decomposition
{p_end}
{p2col:}({mansection M-5 qrinv():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:qrinv(}numeric matrix {it:A}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:qrinv(}numeric matrix {it:A}{cmd:,} {it:rank}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:qrinv(}numeric matrix {it:A}{cmd:,} {it:rank}{cmd:,}
{it:real scalar tol}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_qrinv(}numeric matrix {it:A}{cmd:)}

{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_qrinv(}numeric matrix {it:A}{cmd:,}
{it:real scalar tol}{cmd:)}


{p 4 4 2}
where the type of {it:rank} is irrelevant; the rank of {it:A} is returned 
there.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:qrinv(}{it:A}{cmd:,} ...{cmd:)} 
returns the inverse or generalized inverse of real or complex
matrix {it:A}: {it:m} {it:x} {it:n}, {it:m}>={it:n}.  If optional argument
{it:rank} is specified, the rank of {it:A} is returned there.

{p 4 4 2}
{cmd:_qrinv(}{it:A}{cmd:,} ...{cmd:)} 
does the same thing except that, rather than returning the result, it 
overwrites the original matrix {it:A} with the result.
{cmd:_qrinv()} returns the rank of {it:A}.

{p 4 4 2}
In both cases, optional argument {it:tol} specifies the tolerance for
determining singularity; see {it:Remarks} below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 qrinv()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
{cmd:qrinv()} and {cmd:_qrinv()} are most often used on square and possibly
rank-deficient matrices but may be used on nonsquare matrices that have more
rows than columns.  Also see
{bf:{help mf_pinv:[M-5] pinv()}} 
for an alternative.  See 
{bf:{help mf_luinv:[M-5] luinv()}} 
for a more efficient way to obtain the inverse of full-rank, square matrices,
and see
{bf:{help mf_invsym:[M-5] invsym()}}
for inversion of real, symmetric matrices.

{p 4 4 2}
When {it:A} is of full rank, the inverse calculated by {cmd:qrinv()} is
essentially the same as that computed by the faster {bf:luinv()}.  When {it:A}
is singular, {cmd:qrinv()} and {cmd:_qrinv()} compute a generalized inverse,
{it:A*}, which satisfies

		{it:A}({it:A*}){it:A}    =  {it:A} 

		({it:A*}){it:A}({it:A*}) =  {it:A*}

{p 4 4 2}
This generalized inverse is also calculated for nonsquare matrices
that have more rows than columns and, then returned is a
least-squares solution.  If {it:A} is {it:m} {it:x} {it:n}, {it:m}>={it:n},
and if the rank of {it:A} is equal to {it:n}, then ({it:A*}){it:A}={it:I},
ignoring roundoff error.

{p 4 4 2}
{cmd:qrinv(}{it:A}{cmd:)} is implemented as 
{cmd:qrsolve(}{it:A}{cmd:, I(rows(}{it:A}{cmd:)))};
see {bf:{help mf_qrsolve:[M-5] qrsolve()}} for details and for use of 
the optional {it:tol} argument.


{marker conformability}{...}
{title:Conformability}

    {cmd:qrinv(}{it:A}{cmd:,} {it:rank}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n},   {it:m} >= {it:n}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
	     {it:rank}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:n x m}
		
    {cmd:_qrinv(}{it:A}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:m x n},   {it:m} >= {it:n}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
		{it:A}:  {it:n x m}
	   {it:result}:  1 {it:x} 1    (containing rank)


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The inverse returned by these functions is real if {it:A} is 
real and is complex if {it:A} is complex.

{p 4 4 2}
{cmd:qrinv(}{it:A}{cmd:,} ...{cmd:)} and 
{cmd:_qrinv(}{it:A}{cmd:,} ...{cmd:)} 
return a result containing missing values if
{it:A} contains missing values.

{p 4 4 2}
{cmd:_qrinv(}{it:A}{cmd:,} ...{cmd:)} 
aborts with error if {it:A} is a view.

{p 4 4 2}
See
{bf:{help mf_qrsolve:[M-5] qrsolve()}}
and
{bf:{help m1_tolerance:[M-1] Tolerance}}
for information on the optional {it:tol} argument.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view qrinv.mata, adopath asis:qrinv.mata},
{view _qrinv.mata, adopath asis:_qrinv.mata}
{p_end}
