{smcl}
{* *! version 1.1.6  15may2018}{...}
{vieweralsosee "[M-5] luinv()" "mansection M-5 luinv()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] cholinv()" "help mf_cholinv"}{...}
{vieweralsosee "[M-5] invsym()" "help mf_invsym"}{...}
{vieweralsosee "[M-5] lud()" "help mf_lud"}{...}
{vieweralsosee "[M-5] lusolve()" "help mf_lusolve"}{...}
{vieweralsosee "[M-5] pinv()" "help mf_pinv"}{...}
{vieweralsosee "[M-5] qrinv()" "help mf_qrinv"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{vieweralsosee "[M-4] Solvers" "help m4_solvers"}{...}
{viewerjumpto "Syntax" "mf_luinv##syntax"}{...}
{viewerjumpto "Description" "mf_luinv##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_luinv##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_luinv##remarks"}{...}
{viewerjumpto "Conformability" "mf_luinv##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_luinv##diagnostics"}{...}
{viewerjumpto "Source code" "mf_luinv##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] luinv()} {hline 2}}Square matrix inversion
{p_end}
{p2col:}({mansection M-5 luinv():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:numeric matrix}
{cmd:luinv(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:numeric matrix}
{cmd:luinv(}{it:numeric matrix A}{cmd:,}
{it:real scalar tol}{cmd:)}


{p 8 12 2}
{it:void}{bind:         }
{cmd:_luinv(}{it:numeric matrix A}{cmd:)}

{p 8 12 2}
{it:void}{bind:         }
{cmd:_luinv(}{it:numeric matrix A}{cmd:,}
{it:real scalar tol}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:  }
{cmd:_luinv_la(}{it:numeric matrix A}{cmd:,}
{it:b}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:luinv(}{it:A}{cmd:)} 
and 
{cmd:luinv(}{it:A}{cmd:,} {it:tol}{cmd:)}
return the inverse of real or complex, square matrix {it:A}.

{p 4 4 2}
{cmd:_luinv(}{it:A}{cmd:)} 
and
{cmd:_luinv(}{it:A}{cmd:,} {it:tol}{cmd:)}
do the same thing except that, rather than returning the inverse matrix, they
overwrite the original matrix {it:A} with the inverse.

{p 4 4 2}
In all cases, optional argument {it:tol} specifies the tolerance for
determining singularity; see {it:Remarks} below.

{p 4 4 2}
{cmd:_luinv_la(}{it:A}{cmd:,} {it:b}{cmd:)}
is the interface to the 
{bf:{help m1_lapack:[M-1] LAPACK}} routines that do the work.  The 
output {it:b} is a real scalar, which is 1 if the LAPACK routine used a
blocked algorithm and 0 otherwise.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 luinv()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
These routines calculate the inverse of {it:A}.  The inverse matrix
{it:A}^(-1) of {it:A} satisfies the conditions

		{it:A}{it:A}^(-1) = {it:I}

		{it:A}^(-1){it:A} = {it:I}

{p 4 4 2}
{it:A} is required to be square and of full rank.
See 
{bf:{help mf_qrinv:[M-5] qrinv()}}
and
{bf:{help mf_pinv:[M-5] pinv()}} for generalized inverses of nonsquare or
rank-deficient matrices.
See {bf:{help mf_invsym:[M-5] invsym()}} for inversion of real, symmetric
matrices.

{p 4 4 2}
{cmd:luinv(}{it:A}{cmd:)} is logically equivalent to 
{cmd:lusolve(}{it:A}{cmd:, I(rows(}{it:A}{cmd:)))};
see {bf:{help mf_lusolve:[M-5] lusolve()}} 
for details and for use of the optional {it:tol} argument.



{marker conformability}{...}
{title:Conformability}

    {cmd:luinv(}{it:A}{cmd:,} {it:tol}{cmd:)}:
		{it:A}:  {it:n x n}
	      {it:tol}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:n x n}
		
    {cmd:_luinv(}{it:A}{cmd:,} {it:tol}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
	      {it:tol}:  1 {it:x} 1    (optional)
	{it:output:}
		{it:A}:  {it:n x n}

    {cmd:_luinv_la(}{it:A}{cmd:,} {it:b}{cmd:)}:
	{it:input:}
		{it:A}:  {it:n x n}
	{it:output:}
		{it:A}:  {it:n x n}
	        {it:b}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
The inverse returned by these functions is real if {it:A} is 
real and is complex if {it:A} is complex.
If you use these functions with a singular matrix, 
returned will be a matrix of missing values.  The determination 
of singularity is made relative to {it:tol}.  See 
{it:{help mf_lusolve##remarks3:Tolerance}}
under {it:Remarks} in {bf:{help mf_lusolve:[M-5] lusolve()}} for details.

{p 4 4 2}
{cmd:luinv(}{it:A}{cmd:)}  and {cmd:_luinv(}{it:A}{cmd:)} 
return a matrix containing missing
if {it:A} contains missing values.

{p 4 4 2}
{cmd:_luinv(}{it:A}{cmd:)} aborts with error if {it:A} is a view.

{p 4 4 2}
{cmd:_luinv_la(}{it:A}{cmd:,} {it:b}{cmd:)}
should not be used directly; use {cmd:_luinv()}.

{p 4 4 2}
See
{bf:{help mf_lusolve:[M-5] lusolve()}}
and
{bf:{help m1_tolerance:[M-1] Tolerance}}
for information on the optional {it:tol} argument.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view luinv.mata, adopath asis:luinv.mata},
{view _luinv.mata, adopath asis:_luinv.mata};
{cmd:_luinv_la()} is built in.
{p_end}
