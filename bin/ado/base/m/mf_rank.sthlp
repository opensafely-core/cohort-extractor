{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] rank()" "mansection M-5 rank()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] fullsvd()" "help mf_fullsvd"}{...}
{vieweralsosee "[M-5] pinv()" "help mf_pinv"}{...}
{vieweralsosee "[M-5] svd()" "help mf_svd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_rank##syntax"}{...}
{viewerjumpto "Description" "mf_rank##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_rank##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_rank##remarks"}{...}
{viewerjumpto "Conformability" "mf_rank##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_rank##diagnostics"}{...}
{viewerjumpto "Source code" "mf_rank##source"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-5] rank()} {hline 2}}Rank of matrix
{p_end}
{p2col:}({mansection M-5 rank():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real scalar}
{cmd:rank(}{it:numeric matrix} {it:A}{cmd:)}

{p 8 12 2}
{it:real scalar}
{cmd:rank(}{it:numeric matrix} {it:A}{cmd:,}
{it:real scalar tol}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:rank(}{it:A}{cmd:)}
and 
{cmd:rank(}{it:A}{cmd:,} {it:tol}{cmd:)}
return the rank of {it:A}: {it:m x n}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 rank()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The row rank of a matrix {it:A}: {it:m x n} is the number of rows of {it:A}
that are linearly independent.  The column rank is the number of columns that
are linearly independent.  The terms row rank and column rank, however, are
used merely for emphasis. The ranks are equal, and the result is simply called
the rank of {it:A}.

{p 4 4 2}
{cmd:rank()} calculates the rank 
by counting the number of nonzero singular values of the SVD of {it:A}, 
where nonzero is interpreted relative to a tolerance.  
{cmd:rank()} uses the same tolerance as {cmd:pinv()} (see
{bf:{help mf_pinv:[M-5] pinv()}}) and as {cmd:svsolve()} (see
{bf:{help mf_svsolve:[M-5] svsolve()}}), and optional argument {it:tol} 
is specified in the same way as with those functions.

{p 4 4 2}
Thus if you were going to use {cmd:rank()} before calculating an inverse 
using {cmd:pinv()}, it would be better to skip {cmd:rank()} altogether
and proceed to the {cmd:pinv()} step, because {cmd:pinv()} will return the
rank, calculated as a by-product of calculating the inverse.  Using
{cmd:rank()} ahead of time, the SVD would be calculated twice.

{p 4 4 2}
{cmd:rank()} in general duplicates calculations; and, worse, 
if you are not planning on using {cmd:pinv()} or {cmd:svsolve()}
but rather are planning on using some other function, 
the rank returned by {cmd:rank()} may disagree with the implied rank 
of whatever numerical method you subsequently use because each 
numerical method has its own precision and tolerances.

{p 4 4 2}
All that said, {cmd:rank()} is useful in interactive and 
pedagogical situations.


{marker conformability}{...}
{title:Conformability}

    {cmd:rank(}{it:A}{cmd:,} {it:tol}{cmd:)}:
		{it:A}:  {it:m x n}
	      {it:tol}:  1 {it:x} 1  (optional)
	   {it:result}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:rank(}{it:A}{cmd:)} returns missing if {it:A} contains missing 
values.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view rank.mata, adopath asis:rank.mata},
{view rank_from_singular_values.mata, adopath asis:rank_from_singular_values.mata}
{p_end}
