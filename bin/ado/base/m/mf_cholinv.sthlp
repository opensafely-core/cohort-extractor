{smcl}
{* *! version 1.1.6  25sep2018}{...}
{vieweralsosee "[M-5] cholinv()" "mansection M-5 cholinv()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] invsym()" "help mf_invsym"}{...}
{vieweralsosee "[M-5] luinv()" "help mf_luinv"}{...}
{vieweralsosee "[M-5] pinv()" "help mf_pinv"}{...}
{vieweralsosee "[M-5] qrinv()" "help mf_qrinv"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholsolve()" "help mf_cholsolve"}{...}
{vieweralsosee "[M-5] solv_tol()" "help mf_solve_tol"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-4] Solvers" "help m4_solvers"}{...}
{viewerjumpto "Syntax" "mf_cholinv##syntax"}{...}
{viewerjumpto "Description" "mf_cholinv##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_cholinv##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_cholinv##remarks"}{...}
{viewerjumpto "Conformability" "mf_cholinv##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_cholinv##diagnostics"}{...}
{viewerjumpto "Source code" "mf_cholinv##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] cholinv()} {hline 2}}Symmetric, positive-definite matrix inversion
{p_end}
{p2col:}({mansection M-5 cholinv():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:cholinv(}{it:numeric} {it:matrix} {it:A}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:cholinv(}{it:numeric} {it:matrix} {it:A}{cmd:,}
{it:real scalar tol}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:_cholinv(}{it:numeric} {it:matrix} {it:A}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_cholinv(}{it:numeric} {it:matrix} {it:A}{cmd:,}
{it:real scalar tol}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:cholinv(}{it:A}{cmd:)} 
and 
{cmd:cholinv(}{it:A}{cmd:,} {it:tol}{cmd:)}
return the inverse of real or complex, symmetric
({help m6_glossary##hermitianmtx:Hermitian}),
positive-definite, square matrix {it:A}.

{p 4 4 2}
{cmd:_cholinv(}{it:A}{cmd:)} 
and
{cmd:_cholinv(}{it:A}{cmd:,} {it:tol}{cmd:)}
do the same thing except that, rather than returning the inverse matrix, they
overwrite the original matrix {it:A} with the inverse.

{p 4 4 2}
In all cases, optional argument {it:tol} specifies the tolerance for
determining singularity; see {it:Remarks} below.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 cholinv()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
These routines calculate the inverse of a symmetric, positive-definite
square matrix {it:A}.  See {bf:{help mf_luinv:[M-5] luinv()}} for the
inverse of a general square matrix.

{p 4 4 2}
{it:A} is required to be square and positive definite.
See 
{bf:{help mf_qrinv:[M-5] qrinv()}}
and
{bf:{help mf_pinv:[M-5] pinv()}} for generalized inverses of nonsquare or
rank-deficient matrices.
See {bf:{help mf_invsym:[M-5] invsym()}} for generalized inverses of real,
symmetric matrices.

{p 4 4 2}
{cmd:cholinv(}{it:A}{cmd:)} is logically equivalent to 
{cmd:cholsolve(}{it:A}{cmd:, I(rows(}{it:A}{cmd:)))};
see {bf:{help mf_cholsolve:[M-5] cholsolve()}} 
for details and for use of the optional {it:tol} argument.


{marker conformability}{...}
{title:Conformability}

    {cmd:cholinv(}{it:A}{cmd:,} {it:tol}{cmd:)}:
		{it:A}:  {it:n x n}
	      {it:tol}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:n x n}
		
    {cmd:_cholinv(}{it:A}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
		{it:A}:  {it:n x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The inverse returned by these functions is real if {it:A} is 
real and is complex if {it:A} is complex.
If you use these functions with a non-positive-definite matrix, or 
a matrix that is too close to singularity,  
returned will be a matrix of missing values.  The determination 
of singularity is made relative to {it:tol}.  See 
{it:{help mf_cholsolve##remarks3:Tolerance}} under {it:Remarks} in 
{bf:{help mf_cholsolve:[M-5] cholsolve()}} for details.

{p 4 4 2}
{cmd:cholinv(}{it:A}{cmd:)}  and {cmd:_cholinv(}{it:A}{cmd:)} 
return a result containing all missing values if {it:A} is not 
positive definite or if {it:A} contains missing values.

{p 4 4 2}
{cmd:_cholinv(}{it:A}{cmd:)} aborts with error if {it:A} is a view.

{p 4 4 2}
See
{bf:{help mf_cholsolve:[M-5] cholsolve()}}
and
{bf:{help m1_tolerance:[M-1] Tolerance}}
for information on the optional {it:tol} argument.

{p 4 4 2}
Both functions use the elements from the lower triangle of {it:A} without
checking whether {it:A} is symmetric or, in the complex case, Hermitian.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view cholinv.mata, adopath asis:cholinv.mata},
{view _cholinv.mata, adopath asis:_cholinv.mata}
{p_end}
